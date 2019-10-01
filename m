Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA46CC2C33
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 05:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732515AbfJADDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 23:03:40 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34204 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732441AbfJADDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 23:03:39 -0400
Received: by mail-pf1-f193.google.com with SMTP id b128so6882536pfa.1
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 20:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EbQukDfpzbUuJFAghlKSb/xcCgZGvCvxXVSx0Ko+OTs=;
        b=ZCxWbbvvo8erW8lFtGVF20BBt2Bh1bH4ZV7I2d9LxWjliFtj0pQf8Q5Z328a6IRokl
         NgUaDezZU5aRKwf+pDdjAA8t0mU3ugNfH0+FowAaWlDX1Z7q3JlfVVISOMFOnAt46sMr
         PgkbON86143znr8/kSDQwF8TF9UUEriJAKFg46NHCXtd8wXTJFtGrhyD/VjcP0PO6A6D
         iLJdqDp3WTL3uHnAtCtf1FjKut82OJr0i0YA6RQiKfoZTbJGoY38Gi6WgIHWnSP+IdSf
         a44bKb1SaZB31MlHt90Fr5Q3Gvy81ijxXTrgfUMaOR8eE3FzXr6utGdLNPqAnmWmxJZt
         dL0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EbQukDfpzbUuJFAghlKSb/xcCgZGvCvxXVSx0Ko+OTs=;
        b=pHO48SGolkKAf4TMH7u7VOvL2dvoSy2XdyyJr/gBr9mSqqfv5iDWXclWLsMOWgXNzA
         Lh42Oy50S/KMxD4HrATqF/kJZ0g2w8ki/EZ89snOU1e8aKr8vJrrGT/sClUD7HMJxD0w
         4971AoH8p9y06wH3b7AXw8y4OSHRDogfwSHw+JpdPIZJVxvbrCvIwejpLjxdf+BnpSE5
         BI66jTFoYd/fenJqeifUGxXmWOGY+hoFHCCDghumWa/ubfOHqRIrWQTAgRJFy7B1h729
         VYMLtk7zC3i/bwh86qvGDgF+JJOM7D264pEOk6LyDIAD5k09K+VFAQv0NgCFFJNFjyjE
         57BA==
X-Gm-Message-State: APjAAAUMYbDSLC17Ra7Q673OIVdDPMxF6tGAZZ4hoP66Vk9XrMX1ACEK
        msEhhmR1LeTU8If5k19Yf9Mhz+/IO40YUg==
X-Google-Smtp-Source: APXvYqwCwtRIGcBJk4tuA3FHN1mNpP26375b0fKzrwRJUOGtKV3GeEkoemqYo0bV72nkkHzT43kjLQ==
X-Received: by 2002:a63:c7:: with SMTP id 190mr14031506pga.186.1569899018348;
        Mon, 30 Sep 2019 20:03:38 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id y17sm14831062pfo.171.2019.09.30.20.03.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 20:03:37 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 3/5] ionic: report users coalesce request
Date:   Mon, 30 Sep 2019 20:03:24 -0700
Message-Id: <20191001030326.29623-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191001030326.29623-1-snelson@pensando.io>
References: <20191001030326.29623-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The user's request for an interrupt coalescing value gets
translated into a hardware value to be used with the NIC,
and was getting reported back based on the hw value, which,
due to hw tic resolution, could be reported as a different
number than what the user originally asked for.  This code
now tracks both the user request and what was put into the
hardware so we can report back to the user what they
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

