Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A63EC28F8
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbfI3VmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:42:00 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37875 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfI3VmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:42:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id y5so6344919pfo.4
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 14:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZZfaTyp+JKU39F6H6TWYgpuuxaGlvyXotawwsqbU1tQ=;
        b=dJqSPmIAokYb6q6eol3tqzNh4KKXF2OPuxZNNUhVA35GTabZhRvesqGOu5VqM6pkmg
         IBSz3kORsbose55xbvhil4ZCqQ8QkX5n1Oooj0QltG6dmLDm2ESud6QDskGU5uW+yLzb
         pz3C7CZh7Rl/FqEBp2pb3tLsLJm5Wn72I0nycZaEXJ8+6z6tdI3lgQGFwtrPa3BOO23d
         nreh22JOUd0OSdIaWmNPwXUjeNecPoOv5jl3IlMbhMoUdvZLBfZXFxmnx6rHx9BN3f/U
         Jc194g2p03imTUkgEsFSV2SV1h7bb/dMPQPDggc8BVwmGiyQ4iR1pLZ+ChNsReXlIn6l
         Qdng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZZfaTyp+JKU39F6H6TWYgpuuxaGlvyXotawwsqbU1tQ=;
        b=d1IRPscPUyLomGejBnDXnSiOA4WjqAqbVYdJIzNC7WKTmS7x0VIsTPh983gx2h45Ht
         i8hF7nEmTRc2R7C8MPzFInKepl5POIXzrFxybNMh2svVTJ603+QOZgd56n6gzPRELc72
         QsRD8klJpfoHSX1FmoKTnkYaZf+VQJgS4pDcZxf6jRJv8n4759qsscoTce2sManpyNHe
         45kjxoaCwYqLyeVX/XZO5xAg9VBQp2FZZie7GE8TgsA/8jN73m9IbjIV/0M+RV7DBLyK
         ixbF3SpV31bU1YyWoeLOP/Gg4t47/KFiOFWB2bNKBhzQNgIIKmHUJIzc3OzKf5UIEXJF
         0FtQ==
X-Gm-Message-State: APjAAAWT14itDenX6ZGjxS+MhoF3ln5a1NFUnsX/NxJgDAhXhbJoffws
        nZZJYa1ETIt8WOgWrQHShs/RtwXryMwHFQ==
X-Google-Smtp-Source: APXvYqxU9qMYdMtBd5GL/d05JuCQ0GbTywn1mreCAdGOzZRqXCsRiuWyQUy1qIJB5t8/M/L9VpqT/w==
X-Received: by 2002:aa7:8f14:: with SMTP id x20mr23455215pfr.223.1569866537373;
        Mon, 30 Sep 2019 11:02:17 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id u1sm153873pjn.3.2019.09.30.11.02.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 11:02:16 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/5] ionic: report users coalesce request
Date:   Mon, 30 Sep 2019 11:01:56 -0700
Message-Id: <20190930180158.36101-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190930180158.36101-1-snelson@pensando.io>
References: <20190930180158.36101-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The user's request for an interrupt coalescing value gets
translated into a hardware value to be used with the NIC,
but we should still report back to the user what they
requested.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 22 +++++++++----------
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 11 +++++-----
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  4 +++-
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 7760fcd709b4..63cc14c060d6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -372,7 +372,6 @@ static int ionic_set_coalesce(struct net_device *netdev,
 	struct ionic_identity *ident;
 	struct ionic_qcq *qcq;
 	unsigned int i;
-	u32 usecs;
 	u32 coal;
 
 	if (coalesce->rx_max_coalesced_frames ||
@@ -410,26 +409,27 @@ static int ionic_set_coalesce(struct net_device *netdev,
 		return -EINVAL;
 	}
 
+	/* Convert the usec request to a HW useable value.  If they asked
+	 * for non-zero and it resolved to zero, bump it up
+	 */
 	coal = ionic_coal_usec_to_hw(lif->ionic, coalesce->rx_coalesce_usecs);
-
-	if (coal > IONIC_INTR_CTRL_COAL_MAX)
-		return -ERANGE;
-
-	/* If they asked for non-zero and it resolved to zero, bump it up */
 	if (!coal && coalesce->rx_coalesce_usecs)
 		coal = 1;
 
-	/* Convert it back to get device resolution */
-	usecs = ionic_coal_hw_to_usec(lif->ionic, coal);
+	if (coal > IONIC_INTR_CTRL_COAL_MAX)
+		return -ERANGE;
 
-	if (usecs != lif->rx_coalesce_usecs) {
-		lif->rx_coalesce_usecs = usecs;
+	/* Save the new value */
+	lif->rx_coalesce_usecs = coalesce->rx_coalesce_usecs;
+	if (coal != lif->rx_coalesce_hw) {
+		lif->rx_coalesce_hw = coal;
 
 		if (test_bit(IONIC_LIF_UP, lif->state)) {
 			for (i = 0; i < lif->nxqs; i++) {
 				qcq = lif->rxqcqs[i].qcq;
 				ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
-						     qcq->intr.index, coal);
+						     qcq->intr.index,
+						     lif->rx_coalesce_hw);
 			}
 		}
 	}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4d5883a7e586..372329389c84 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1430,7 +1430,6 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 	unsigned int flags;
 	unsigned int i;
 	int err = 0;
-	u32 coal;
 
 	flags = IONIC_QCQ_F_TX_STATS | IONIC_QCQ_F_SG;
 	for (i = 0; i < lif->nxqs; i++) {
@@ -1447,7 +1446,6 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 	}
 
 	flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_INTR;
-	coal = ionic_coal_usec_to_hw(lif->ionic, lif->rx_coalesce_usecs);
 	for (i = 0; i < lif->nxqs; i++) {
 		err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
 				      lif->nrxq_descs,
@@ -1460,7 +1458,8 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 		lif->rxqcqs[i].qcq->stats = lif->rxqcqs[i].stats;
 
 		ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
-				     lif->rxqcqs[i].qcq->intr.index, coal);
+				     lif->rxqcqs[i].qcq->intr.index,
+				     lif->rx_coalesce_hw);
 		ionic_link_qcq_interrupts(lif->rxqcqs[i].qcq,
 					  lif->txqcqs[i].qcq);
 	}
@@ -1640,7 +1639,6 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	struct net_device *netdev;
 	struct ionic_lif *lif;
 	int tbl_sz;
-	u32 coal;
 	int err;
 
 	netdev = alloc_etherdev_mqs(sizeof(*lif),
@@ -1671,8 +1669,9 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	lif->nrxq_descs = IONIC_DEF_TXRX_DESC;
 
 	/* Convert the default coalesce value to actual hw resolution */
-	coal = ionic_coal_usec_to_hw(lif->ionic, IONIC_ITR_COAL_USEC_DEFAULT);
-	lif->rx_coalesce_usecs = ionic_coal_hw_to_usec(lif->ionic, coal);
+	lif->rx_coalesce_usecs = IONIC_ITR_COAL_USEC_DEFAULT;
+	lif->rx_coalesce_hw = ionic_coal_hw_to_usec(lif->ionic,
+						    lif->rx_coalesce_usecs);
 
 	snprintf(lif->name, sizeof(lif->name), "lif%u", index);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index b74f7e9ee82d..cf243a9d0168 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -175,7 +175,9 @@ struct ionic_lif {
 	unsigned long *dbid_inuse;
 	unsigned int dbid_count;
 	struct dentry *dentry;
-	u32 rx_coalesce_usecs;
+	u32 rx_coalesce_usecs;		/* what the user asked for */
+	u32 rx_coalesce_hw;		/* what the hw is using */
+
 	u32 flags;
 	struct work_struct tx_timeout_work;
 };
-- 
2.17.1

