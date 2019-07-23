Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 336D171A2A
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 16:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388075AbfGWOXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 10:23:06 -0400
Received: from mail.online.net ([62.210.16.11]:36664 "EHLO mail.online.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731271AbfGWOXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 10:23:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.online.net (Postfix) with ESMTP id 5754A117E8638;
        Tue, 23 Jul 2019 16:23:04 +0200 (CEST)
Received: from mail.online.net ([127.0.0.1])
        by localhost (mail.online.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id CYzHCIbUH6kF; Tue, 23 Jul 2019 16:23:04 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.online.net (Postfix) with ESMTP id 2671D117E873D;
        Tue, 23 Jul 2019 16:23:04 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mail.online.net
Received: from mail.online.net ([127.0.0.1])
        by localhost (mail.online.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QT6JU_pV3gI0; Tue, 23 Jul 2019 16:23:04 +0200 (CEST)
Received: from legolas.infra.online.net (unknown [195.154.229.35])
        by mail.online.net (Postfix) with ESMTPSA id 00F6D117E860E;
        Tue, 23 Jul 2019 16:23:03 +0200 (CEST)
From:   Alexis Bauvin <abauvin@scaleway.com>
To:     stephen@networkplumber.org, davem@davemloft.net,
        jasowang@redhat.com
Cc:     netdev@vger.kernel.org, abauvin@scaleway.com
Subject: [PATCH v2] tun: mark small packets as owned by the tap sock
Date:   Tue, 23 Jul 2019 16:23:01 +0200
Message-Id: <20190723142301.39568-1-abauvin@scaleway.com>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- v1 -> v2: Move skb_set_owner_w to __tun_build_skb to reduce patch size

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
 drivers/net/tun.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3d443597bd04..db16d7a13e00 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1599,7 +1599,8 @@ static bool tun_can_build_skb(struct tun_struct *tun, struct tun_file *tfile,
 	return true;
 }
 
-static struct sk_buff *__tun_build_skb(struct page_frag *alloc_frag, char *buf,
+static struct sk_buff *__tun_build_skb(struct tun_file *tfile,
+				       struct page_frag *alloc_frag, char *buf,
 				       int buflen, int len, int pad)
 {
 	struct sk_buff *skb = build_skb(buf, buflen);
@@ -1609,6 +1610,7 @@ static struct sk_buff *__tun_build_skb(struct page_frag *alloc_frag, char *buf,
 
 	skb_reserve(skb, pad);
 	skb_put(skb, len);
+	skb_set_owner_w(skb, tfile->socket.sk);
 
 	get_page(alloc_frag->page);
 	alloc_frag->offset += buflen;
@@ -1686,7 +1688,8 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 	 */
 	if (hdr->gso_type || !xdp_prog) {
 		*skb_xdp = 1;
-		return __tun_build_skb(alloc_frag, buf, buflen, len, pad);
+		return __tun_build_skb(tfile, alloc_frag, buf, buflen, len,
+				       pad);
 	}
 
 	*skb_xdp = 0;
@@ -1723,7 +1726,7 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 	rcu_read_unlock();
 	local_bh_enable();
 
-	return __tun_build_skb(alloc_frag, buf, buflen, len, pad);
+	return __tun_build_skb(tfile, alloc_frag, buf, buflen, len, pad);
 
 err_xdp:
 	put_page(alloc_frag->page);
-- 

