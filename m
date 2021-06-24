Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA5D3B2EEF
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 14:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhFXMdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 08:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbhFXMc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 08:32:29 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FF8C06175F
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 05:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Xfv0QJt87fWC41FLuReVlnvOZnWEghlxZzhYQuRJUw0=; b=PSKzL7uEn/at65I9Dr0E4HqMJw
        bpJh0wk6yQku0y/PLNIlASQidTBbYhPgI5ZYfSNFY6VL6TyTL4oaaO5V2yqwx6b4u6s3xx6lgvq5f
        yWDh2x8z/QrwLvKSMYd3kse5/0hCh4f2opMyLkal3QsW77k0Fz4QIoL/C0BAGfW+9bjuaoDENYYhx
        KoHzWCrl04QwpA2diTxqaxlIxxZScee93TSS4aC3WangDNCICrxszg6euQcjRRah3gvWUc/0x9KTU
        /gQaDtaHIQOGeIzO5lRprlR0mV4J85pG6U3CFp8Vb8n8qaQqmoLmy+XEg/wNEKC4Hy0W2iUyGOaFR
        8B5syIKA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwOUZ-00BEEN-40; Thu, 24 Jun 2021 12:30:06 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwOUf-005Sex-Jo; Thu, 24 Jun 2021 13:30:05 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v3 2/5] net: tun: don't assume IFF_VNET_HDR in tun_xdp_one() tx path
Date:   Thu, 24 Jun 2021 13:30:02 +0100
Message-Id: <20210624123005.1301761-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624123005.1301761-1-dwmw2@infradead.org>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
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
index 67b406fa0881..9acd448e6dfc 100644
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

