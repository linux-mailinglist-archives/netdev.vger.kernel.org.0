Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C248F084
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfD3Ghe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:37:34 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48766 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbfD3Ghd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 58EC12027E;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id q_OOuCg09Ucp; Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6AC6E201E6;
        Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 084123180398;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 01/18] xfrm: gso partial offload support
Date:   Tue, 30 Apr 2019 08:37:10 +0200
Message-ID: <20190430063727.10908-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430063727.10908-1-steffen.klassert@secunet.com>
References: <20190430063727.10908-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: D00B0856-418B-45CD-8138-EBF11B3E6BAD
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>

This patch introduces support for gso partial ESP offload.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4_offload.c | 10 +++++++---
 net/xfrm/xfrm_device.c  |  3 +++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 8756e0e790d2..c6c84f2bc41c 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -138,9 +138,11 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 
 	skb->encap_hdr_csum = 1;
 
-	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev)
+	if ((!(skb->dev->gso_partial_features & NETIF_F_HW_ESP) &&
+	     !(features & NETIF_F_HW_ESP)) || x->xso.dev != skb->dev)
 		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK);
-	else if (!(features & NETIF_F_HW_ESP_TX_CSUM))
+	else if (!(features & NETIF_F_HW_ESP_TX_CSUM) &&
+		 !(skb->dev->gso_partial_features & NETIF_F_HW_ESP_TX_CSUM))
 		esp_features = features & ~NETIF_F_CSUM_MASK;
 
 	xo->flags |= XFRM_GSO_SEGMENT;
@@ -181,7 +183,9 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 	if (!xo)
 		return -EINVAL;
 
-	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev) {
+	if ((!(features & NETIF_F_HW_ESP) &&
+	     !(skb->dev->gso_partial_features & NETIF_F_HW_ESP)) ||
+	    x->xso.dev != skb->dev) {
 		xo->flags |= CRYPTO_FALLBACK;
 		hw_offload = false;
 	}
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 2db1626557c5..e437b60fba51 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -78,6 +78,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	}
 
 	if (!skb->next) {
+		esp_features |= skb->dev->gso_partial_features;
 		x->outer_mode->xmit(x, skb);
 
 		xo->flags |= XFRM_DEV_RESUME;
@@ -101,6 +102,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 
 	do {
 		struct sk_buff *nskb = skb2->next;
+
+		esp_features |= skb->dev->gso_partial_features;
 		skb_mark_not_on_list(skb2);
 
 		xo = xfrm_offload(skb2);
-- 
2.17.1

