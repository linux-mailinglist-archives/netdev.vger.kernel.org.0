Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15C03347E7
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhCJT1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbhCJT1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:27:05 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDE1C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:27:05 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y13so9338634pfr.0
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=w3zvhwyhoSJ/TBvXM0V8rKoEJe+heF8go/8KszYVs88=;
        b=yih/H32T9oHwW19AcvT5TTbGF3lO8FVqjao88rwitqHLjs2Tg8bm5y4ZqPTM30UaPD
         c//5kBchuy19I7fk1ilMHTSScrHJm6yh4AgWv+XUmB8QWX2erqljE1rJFBb1njeq3cN9
         C9fmFb8XQIBmox8XxNW9/2KQn8Zl2VJ48vCxOO2cKjg36UhH3EQSeACtphb5JXbK5NyU
         4NHstX8/ivcrGMb740kLaB93gvdk3Ir9zD7Yg83MSW/TQGbgfm2aMI1bKcTYG3MYCQP7
         kGYKYAvGLGd05AP8Qev4P4yXjuxBhKGnopWNsgvJb/xu/aKlY/MOBcz4RI6BZ+PXIsAd
         S82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=w3zvhwyhoSJ/TBvXM0V8rKoEJe+heF8go/8KszYVs88=;
        b=WXjFTn9lOxaTpmNcbPs7+GC26X5O0UmiuzfKsgQL3MWxg8qupewfsQXIXu18lPKQR2
         lyVYqyLDG1uvanCArEKpbyKNQzpgZ6oBRlWOuDQzvKZzs+/mnG1F9W+VMCXTU1VlxWxE
         Q3kuR4lcKt4iP9vEjtuIOLSfoDz5B09LhnRXIrKyaXZAWdaGwy+2sMMJUUyUlcAan+6r
         Fkbtz7CONPBnI7J1ygw3TdJl+3By9eBq3LkH9jFz4ZWPTy2KzTXzJN+NBc7knbGNqpda
         kb6VAtKdLLj/t0ZWnfV9N3CIWqFj/i3a1/kakZzVjQhUxy8s2ZXV1z59ARMjw/KNJLTS
         aDcA==
X-Gm-Message-State: AOAM533wqKFDp4Y4tbyziezY+0BPdHtnHeFKIhcDjRpUfzaob12qAmzD
        V5zXB5NaRe7Mj8588ZAU/ByU24Cv5yGWlA==
X-Google-Smtp-Source: ABdhPJy+Jus8rPB3Nj9up9WXVupnzyWh8JMXZK+z1tFR49Ifc1gaT/clVpF3Ddk2D7it+R1G9lgzzQ==
X-Received: by 2002:a63:1266:: with SMTP id 38mr3993939pgs.266.1615404424456;
        Wed, 10 Mar 2021 11:27:04 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 12sm306393pgw.18.2021.03.10.11.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 11:27:03 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/6] ionic: simplify rx skb alloc
Date:   Wed, 10 Mar 2021 11:26:29 -0800
Message-Id: <20210310192631.20022-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210310192631.20022-1-snelson@pensando.io>
References: <20210310192631.20022-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove an unnecessary layer over rx skb allocation.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 63 +++++++------------
 1 file changed, 22 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index c472c14b3a80..cd2540ff9251 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -10,12 +10,6 @@
 #include "ionic_lif.h"
 #include "ionic_txrx.h"
 
-static void ionic_rx_clean(struct ionic_queue *q,
-			   struct ionic_desc_info *desc_info,
-			   struct ionic_cq_info *cq_info,
-			   void *cb_arg);
-
-static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info);
 
 static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info);
 
@@ -40,32 +34,6 @@ static inline struct netdev_queue *q_to_ndq(struct ionic_queue *q)
 	return netdev_get_tx_queue(q->lif->netdev, q->index);
 }
 
-static struct sk_buff *ionic_rx_skb_alloc(struct ionic_queue *q,
-					  unsigned int len, bool frags)
-{
-	struct ionic_lif *lif = q->lif;
-	struct ionic_rx_stats *stats;
-	struct net_device *netdev;
-	struct sk_buff *skb;
-
-	netdev = lif->netdev;
-	stats = &q->lif->rxqstats[q->index];
-
-	if (frags)
-		skb = napi_get_frags(&q_to_qcq(q)->napi);
-	else
-		skb = napi_alloc_skb(&q_to_qcq(q)->napi, len);
-
-	if (unlikely(!skb)) {
-		net_warn_ratelimited("%s: SKB alloc failed on %s!\n",
-				     netdev->name, q->name);
-		stats->alloc_err++;
-		return NULL;
-	}
-
-	return skb;
-}
-
 static void ionic_rx_buf_reset(struct ionic_buf_info *buf_info)
 {
 	buf_info->page = NULL;
@@ -76,12 +44,10 @@ static void ionic_rx_buf_reset(struct ionic_buf_info *buf_info)
 static int ionic_rx_page_alloc(struct ionic_queue *q,
 			       struct ionic_buf_info *buf_info)
 {
-	struct ionic_lif *lif = q->lif;
+	struct net_device *netdev = q->lif->netdev;
 	struct ionic_rx_stats *stats;
-	struct net_device *netdev;
 	struct device *dev;
 
-	netdev = lif->netdev;
 	dev = q->dev;
 	stats = q_to_rx_stats(q);
 
@@ -162,21 +128,29 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
 				      struct ionic_cq_info *cq_info)
 {
 	struct ionic_rxq_comp *comp = cq_info->cq_desc;
+	struct net_device *netdev = q->lif->netdev;
 	struct ionic_buf_info *buf_info;
+	struct ionic_rx_stats *stats;
 	struct device *dev = q->dev;
 	struct sk_buff *skb;
 	unsigned int i;
 	u16 frag_len;
 	u16 len;
 
+	stats = q_to_rx_stats(q);
+
 	buf_info = &desc_info->bufs[0];
 	len = le16_to_cpu(comp->len);
 
 	prefetch(buf_info->page);
 
-	skb = ionic_rx_skb_alloc(q, len, true);
-	if (unlikely(!skb))
+	skb = napi_get_frags(&q_to_qcq(q)->napi);
+	if (unlikely(!skb)) {
+		net_warn_ratelimited("%s: SKB alloc failed on %s!\n",
+				     netdev->name, q->name);
+		stats->alloc_err++;
 		return NULL;
+	}
 
 	i = comp->num_sg_elems + 1;
 	do {
@@ -218,17 +192,25 @@ static struct sk_buff *ionic_rx_copybreak(struct ionic_queue *q,
 					  struct ionic_cq_info *cq_info)
 {
 	struct ionic_rxq_comp *comp = cq_info->cq_desc;
+	struct net_device *netdev = q->lif->netdev;
 	struct ionic_buf_info *buf_info;
+	struct ionic_rx_stats *stats;
 	struct device *dev = q->dev;
 	struct sk_buff *skb;
 	u16 len;
 
+	stats = q_to_rx_stats(q);
+
 	buf_info = &desc_info->bufs[0];
 	len = le16_to_cpu(comp->len);
 
-	skb = ionic_rx_skb_alloc(q, len, false);
-	if (unlikely(!skb))
+	skb = napi_alloc_skb(&q_to_qcq(q)->napi, len);
+	if (unlikely(!skb)) {
+		net_warn_ratelimited("%s: SKB alloc failed on %s!\n",
+				     netdev->name, q->name);
+		stats->alloc_err++;
 		return NULL;
+	}
 
 	if (unlikely(!buf_info->page)) {
 		dev_kfree_skb(skb);
@@ -253,13 +235,12 @@ static void ionic_rx_clean(struct ionic_queue *q,
 			   void *cb_arg)
 {
 	struct ionic_rxq_comp *comp = cq_info->cq_desc;
+	struct net_device *netdev = q->lif->netdev;
 	struct ionic_qcq *qcq = q_to_qcq(q);
 	struct ionic_rx_stats *stats;
-	struct net_device *netdev;
 	struct sk_buff *skb;
 
 	stats = q_to_rx_stats(q);
-	netdev = q->lif->netdev;
 
 	if (comp->status) {
 		stats->dropped++;
-- 
2.17.1

