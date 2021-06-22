Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D203B0A18
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 18:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFVQSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 12:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhFVQSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 12:18:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2D0C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 09:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dtVe0AJXy7anZOT9IZ0v6o+FzPwJ6e2fZ1XMWeGMC1Y=; b=A+OfhcN7qrSL1WqLDZsZ8xzs/t
        KrqrqkdmVcd+BMg+1zGi/kb0MHH9Pxd+wQcMOcHe4+quSlOjxWqFy2nHDnMVUQnaliK5ZHs5FgYk6
        j2qqKEietAM6PnsbVKcExxbNPSif1LkyLIeB6giaYvt3GpDjuOLOobSdOIjILZbnqatPtaUMx72ue
        xTN8XfJWzmvQdwKSN02x96/OIFCYaGxznA9K4d7+avYSs1zN8ULV8/TU9HCTstB3pu5I4Qjn9dv2l
        VFvdz4L1sS7G+fZlFXHRfxWfC+oGLU2esiLYREju0iSvkCUZetV6nB1oveJHzeRFzbs0TW3V1LPmC
        cyCKzKVA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvj3m-00ETxf-5A; Tue, 22 Jun 2021 16:15:48 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvj3l-00560B-Mf; Tue, 22 Jun 2021 17:15:33 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Subject: [PATCH v2 2/4] net: tun: don't assume IFF_VNET_HDR in tun_xdp_one() tx path
Date:   Tue, 22 Jun 2021 17:15:31 +0100
Message-Id: <20210622161533.1214662-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622161533.1214662-1-dwmw2@infradead.org>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210622161533.1214662-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Sometimes it's just a data packet. The virtio_net_hdr processing should be
conditional on IFF_VNET_HDR, just as it is in tun_get_user().

Fixes: 043d222f93ab ("tuntap: accept an array of XDP buffs through sendmsg()")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/net/tun.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index f812dcdc640e..96933887d03d 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2331,7 +2331,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 {
 	unsigned int datasize = xdp->data_end - xdp->data;
 	struct tun_xdp_hdr *hdr = xdp->data_hard_start;
-	struct virtio_net_hdr *gso = &hdr->gso;
+	struct virtio_net_hdr *gso = NULL;
 	struct bpf_prog *xdp_prog;
 	struct sk_buff *skb = NULL;
 	u32 rxhash = 0, act;
@@ -2340,9 +2340,12 @@ static int tun_xdp_one(struct tun_struct *tun,
 	bool skb_xdp = false;
 	struct page *page;
 
+	if (tun->flags & IFF_VNET_HDR)
+		gso = &hdr->gso;
+
 	xdp_prog = rcu_dereference(tun->xdp_prog);
 	if (xdp_prog) {
-		if (gso->gso_type) {
+		if (gso && gso->gso_type) {
 			skb_xdp = true;
 			goto build;
 		}
@@ -2388,7 +2391,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
 
-	if (virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
+	if (gso && virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
 		atomic_long_inc(&tun->rx_frame_errors);
 		kfree_skb(skb);
 		err = -EINVAL;
-- 
2.31.1

