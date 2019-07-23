Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71BD9718EB
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 15:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389755AbfGWNLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 09:11:30 -0400
Received: from mail.online.net ([62.210.16.11]:35560 "EHLO mail.online.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728323AbfGWNLa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 09:11:30 -0400
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jul 2019 09:11:30 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.online.net (Postfix) with ESMTP id 6CA10117E82DC;
        Tue, 23 Jul 2019 15:02:21 +0200 (CEST)
Received: from mail.online.net ([127.0.0.1])
        by localhost (mail.online.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id a-OgYyK55Acp; Tue, 23 Jul 2019 15:02:21 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.online.net (Postfix) with ESMTP id 214FD117E8307;
        Tue, 23 Jul 2019 15:02:21 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mail.online.net
Received: from mail.online.net ([127.0.0.1])
        by localhost (mail.online.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZMQWgaJiF3s2; Tue, 23 Jul 2019 15:02:21 +0200 (CEST)
Received: from legolas.infra.online.net (unknown [195.154.229.35])
        by mail.online.net (Postfix) with ESMTPSA id E3D23117E82DC;
        Tue, 23 Jul 2019 15:02:20 +0200 (CEST)
From:   Alexis Bauvin <abauvin@scaleway.com>
To:     stephen@networkplumber.org, davem@davemloft.net,
        jasowang@redhat.com
Cc:     netdev@vger.kernel.org, abauvin@scaleway.com
Subject: [PATCH v1] tun: mark small packets as owned by the tap sock
Date:   Tue, 23 Jul 2019 15:01:51 +0200
Message-Id: <20190723130151.36745-1-abauvin@scaleway.com>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Small packets going out of a tap device go through an optimized code
path that uses build_skb() rather than sock_alloc_send_pskb(). The
latter calls skb_set_owner_w(), but the small packet code path does not.

The net effect is that small packets are not owned by the userland
application's socket (e.g. QEMU), while large packets are.
This can be seen with a TCP session, where packets are not owned when
the window size is small enough (around PAGE_SIZE), while they are once
the window grows (note that this requires the host to support virtio
tso for the guest to offload segmentation).
All this leads to inconsistent behaviour in the kernel, especially on
netfilter modules that uses sk->socket (e.g. xt_owner).

Signed-off-by: Alexis Bauvin <abauvin@scaleway.com>
Fixes: 66ccbc9c87c2 ("tap: use build_skb() for small packet")
---
 drivers/net/tun.c | 71 ++++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3d443597bd04..ac56b6a29eb2 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1656,6 +1656,7 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 {
 	struct page_frag *alloc_frag = &current->task_frag;
 	struct bpf_prog *xdp_prog;
+	struct sk_buff *skb;
 	int buflen = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	char *buf;
 	size_t copied;
@@ -1686,44 +1687,46 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 	 */
 	if (hdr->gso_type || !xdp_prog) {
 		*skb_xdp = 1;
-		return __tun_build_skb(alloc_frag, buf, buflen, len, pad);
-	}
-
-	*skb_xdp = 0;
+	} else {
+		*skb_xdp = 0;
 
-	local_bh_disable();
-	rcu_read_lock();
-	xdp_prog = rcu_dereference(tun->xdp_prog);
-	if (xdp_prog) {
-		struct xdp_buff xdp;
-		u32 act;
-
-		xdp.data_hard_start = buf;
-		xdp.data = buf + pad;
-		xdp_set_data_meta_invalid(&xdp);
-		xdp.data_end = xdp.data + len;
-		xdp.rxq = &tfile->xdp_rxq;
-
-		act = bpf_prog_run_xdp(xdp_prog, &xdp);
-		if (act == XDP_REDIRECT || act == XDP_TX) {
-			get_page(alloc_frag->page);
-			alloc_frag->offset += buflen;
+		local_bh_disable();
+		rcu_read_lock();
+		xdp_prog = rcu_dereference(tun->xdp_prog);
+		if (xdp_prog) {
+			struct xdp_buff xdp;
+			u32 act;
+
+			xdp.data_hard_start = buf;
+			xdp.data = buf + pad;
+			xdp_set_data_meta_invalid(&xdp);
+			xdp.data_end = xdp.data + len;
+			xdp.rxq = &tfile->xdp_rxq;
+
+			act = bpf_prog_run_xdp(xdp_prog, &xdp);
+			if (act == XDP_REDIRECT || act == XDP_TX) {
+				get_page(alloc_frag->page);
+				alloc_frag->offset += buflen;
+			}
+			err = tun_xdp_act(tun, xdp_prog, &xdp, act);
+			if (err < 0)
+				goto err_xdp;
+			if (err == XDP_REDIRECT)
+				xdp_do_flush_map();
+			if (err != XDP_PASS)
+				goto out;
+
+			pad = xdp.data - xdp.data_hard_start;
+			len = xdp.data_end - xdp.data;
 		}
-		err = tun_xdp_act(tun, xdp_prog, &xdp, act);
-		if (err < 0)
-			goto err_xdp;
-		if (err == XDP_REDIRECT)
-			xdp_do_flush_map();
-		if (err != XDP_PASS)
-			goto out;
-
-		pad = xdp.data - xdp.data_hard_start;
-		len = xdp.data_end - xdp.data;
+		rcu_read_unlock();
+		local_bh_enable();
 	}
-	rcu_read_unlock();
-	local_bh_enable();
 
-	return __tun_build_skb(alloc_frag, buf, buflen, len, pad);
+	skb = __tun_build_skb(alloc_frag, buf, buflen, len, pad);
+	if (skb)
+		skb_set_owner_w(skb, tfile->socket.sk);
+	return skb;
 
 err_xdp:
 	put_page(alloc_frag->page);
-- 

