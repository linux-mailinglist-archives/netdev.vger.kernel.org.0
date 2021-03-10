Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAAB3347E9
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhCJT1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbhCJT1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:27:07 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A06DC061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:27:07 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id ha17so1432718pjb.2
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8dftNfGs7u/TavY2VL10CRoiQcorWiSHQAURk/X4aiU=;
        b=Y4ggoDjjzc6uk67uZSs+wCw3bZpQLiBpKorhRpzSW015f7lxMfrj/nPdf+QkJsTuTI
         9riY2UD2HjMvn5yEBNnzlf1D22ewBxk4OZ8d5UtWKmOcLovGDfBVfi/48irDvHAMMnJ1
         A9gb1Z3pqsk0ZnAWfX+AZmuxdEUx9AkfZyyqCgmGW5xH7XUHaPr617UilU7Jvmfm8pl0
         wufYSP1jngZ+VjuGU3/q3hHO7oRdqerOJduKOgxQBAGWn7/xZzM4FlWw3ciNHGlmq4Qh
         B1Dr9cxK2m09gQvdZW+tYyrQBx+wOeyQwzOcDTF9R9BYHg78LhRhDKVx1ddHVtU5tHYv
         WULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8dftNfGs7u/TavY2VL10CRoiQcorWiSHQAURk/X4aiU=;
        b=X8cWc6JqcWn08VDLQ68mvOo+SCyWIGLtHIdVGdsItk4LMke/DORJH3ImnNTyp+znaB
         4f4KPzUJkNLWmev5TSTK5vSEoAZzMh0ucs63h4vO7E2LXCzA1jK51CHLKoXvvALt6Ywo
         xGsQwqpBbIJZ4q89uk7dgX7mhOcC4M6qR6ljGfKGqPT/QImOKC1FGcJwKF+0NgUj3phY
         HNkUe2dlfOPPwtgQcYlMAQXqet5k0gQZI2cKuyztTd2l1nWCVB3k/r9HFmJacxngP5NK
         FD47oTpOAPC4iheYqgKt3TAyw+rB2gz7dvMeM9KpQK/CqNoa11VgO4bZU0mC2UTAc3AY
         iPrg==
X-Gm-Message-State: AOAM530FhhDmy7dHqtc2pSZIjTdCRW7k9fkbdIcVAj41hxV2WjLfPVgj
        zAYwvuaum46E4ay3Huji2oblc8bdkEabXw==
X-Google-Smtp-Source: ABdhPJyPQRzPg9V3c1YTz6/zL5vdlx4DIlINH0O9fw85OIB079jr3k+K/2Q5Q5RQabHX8716B2SDKw==
X-Received: by 2002:a17:90b:ecc:: with SMTP id gz12mr5030968pjb.79.1615404426762;
        Wed, 10 Mar 2021 11:27:06 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 12sm306393pgw.18.2021.03.10.11.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 11:27:06 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 6/6] ionic: simplify use of completion types
Date:   Wed, 10 Mar 2021 11:26:31 -0800
Message-Id: <20210310192631.20022-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210310192631.20022-1-snelson@pensando.io>
References: <20210310192631.20022-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make better use of our struct types and type checking by passing
the actual Rx or Tx completion type rather than a generic void
pointer type.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index cd2540ff9251..c63e6e7aa47b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -125,9 +125,8 @@ static bool ionic_rx_buf_recycle(struct ionic_queue *q,
 
 static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
 				      struct ionic_desc_info *desc_info,
-				      struct ionic_cq_info *cq_info)
+				      struct ionic_rxq_comp *comp)
 {
-	struct ionic_rxq_comp *comp = cq_info->cq_desc;
 	struct net_device *netdev = q->lif->netdev;
 	struct ionic_buf_info *buf_info;
 	struct ionic_rx_stats *stats;
@@ -155,9 +154,6 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
 	i = comp->num_sg_elems + 1;
 	do {
 		if (unlikely(!buf_info->page)) {
-			struct napi_struct *napi = &q_to_qcq(q)->napi;
-
-			napi->skb = NULL;
 			dev_kfree_skb(skb);
 			return NULL;
 		}
@@ -189,9 +185,8 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
 
 static struct sk_buff *ionic_rx_copybreak(struct ionic_queue *q,
 					  struct ionic_desc_info *desc_info,
-					  struct ionic_cq_info *cq_info)
+					  struct ionic_rxq_comp *comp)
 {
-	struct ionic_rxq_comp *comp = cq_info->cq_desc;
 	struct net_device *netdev = q->lif->netdev;
 	struct ionic_buf_info *buf_info;
 	struct ionic_rx_stats *stats;
@@ -234,7 +229,7 @@ static void ionic_rx_clean(struct ionic_queue *q,
 			   struct ionic_cq_info *cq_info,
 			   void *cb_arg)
 {
-	struct ionic_rxq_comp *comp = cq_info->cq_desc;
+	struct ionic_rxq_comp *comp = cq_info->rxcq;
 	struct net_device *netdev = q->lif->netdev;
 	struct ionic_qcq *qcq = q_to_qcq(q);
 	struct ionic_rx_stats *stats;
@@ -251,9 +246,9 @@ static void ionic_rx_clean(struct ionic_queue *q,
 	stats->bytes += le16_to_cpu(comp->len);
 
 	if (le16_to_cpu(comp->len) <= q->lif->rx_copybreak)
-		skb = ionic_rx_copybreak(q, desc_info, cq_info);
+		skb = ionic_rx_copybreak(q, desc_info, comp);
 	else
-		skb = ionic_rx_frags(q, desc_info, cq_info);
+		skb = ionic_rx_frags(q, desc_info, comp);
 
 	if (unlikely(!skb)) {
 		stats->dropped++;
@@ -309,7 +304,7 @@ static void ionic_rx_clean(struct ionic_queue *q,
 
 static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 {
-	struct ionic_rxq_comp *comp = cq_info->cq_desc;
+	struct ionic_rxq_comp *comp = cq_info->rxcq;
 	struct ionic_queue *q = cq->bound_q;
 	struct ionic_desc_info *desc_info;
 
@@ -661,7 +656,7 @@ static void ionic_tx_clean(struct ionic_queue *q,
 
 static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 {
-	struct ionic_txq_comp *comp = cq_info->cq_desc;
+	struct ionic_txq_comp *comp = cq_info->txcq;
 	struct ionic_queue *q = cq->bound_q;
 	struct ionic_desc_info *desc_info;
 	u16 index;
-- 
2.17.1

