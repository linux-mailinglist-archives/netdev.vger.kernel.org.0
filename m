Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30928C2922
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732062AbfI3Vtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:49:36 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38796 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731308AbfI3Vtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:49:33 -0400
Received: by mail-pg1-f194.google.com with SMTP id x10so8107820pgi.5
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 14:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3k9LuzNQxlMx3rNW7QTaJHFnhI8G9qRWi6K8sugpnCk=;
        b=PFgGLNeGS8+36sQZQIQNXnCpD6mpwbjEaNTxkELvUFsMyN6hW6SGEh6EBZW5BKiq+Z
         bmVZJkjhyVd7jLIo8jTRWqVgWl/oFkhkHZBe1coevkjjzx7aGbTQZj4dNmhgwfKqPybT
         pqaA05t3sVXYyi/UcyqElwYdtMoo23vhN4m7LRWNYqRZs0qYSakW2hrYxNNaggyra6sj
         /pSleHSD9bsfxl9KhSwQ9KeF78h9fVCj+KVPirmWxVbRkH6TiBYj/9yrGc8kZMFSgoqy
         pFRTjFZxIyRsgpEwUfmbFqs/LKU7514Lu9aj4HZQDY0fK9XZUrCfue6OqLRmCjk9X+jw
         fnTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3k9LuzNQxlMx3rNW7QTaJHFnhI8G9qRWi6K8sugpnCk=;
        b=Q5cdllV08cSz4bjN8zpFgcd/vlKS5IYXvj5RZ2JZtTw5GHojFHrDNANlj5HNwHUQYR
         CmJ14Z44bqtOVC+9JRjeZ8rpwLvJ0JPry84hdMwOugGn28wyzNfQyhtDS9Q0f5ZKwy/i
         H1PGepJFlluX40das8do/Y2mJBgPiCfMyDoOgk0pJYwUdFNtSxn8hiyJFchvbMkNC85M
         r2YhkVeRkAntO1jFIpvsRmFPmNIJFIERGh6AOAJL5P/9KaaxRlnjr+cy0JRZqm0LZkpT
         jn7FXkV7Xz6i+j0gj/9jjfTry5Qd0CCAATWzD8eRsI+2YeZdYALHkwlMnx+fGlz33Hv3
         yjCw==
X-Gm-Message-State: APjAAAVhn3TMtNVlNqlcyxdmrl0MBIJZain3eO9dIJ0wKbWMytvueDPH
        FtuEFfW+RSl5r1PTjn8VbIvRFxvghuPlGg==
X-Google-Smtp-Source: APXvYqxfmh22EAyKLA2pI1whLAhrvqthAlGwGgcede+v29iLV1blmCDKswpcAdhGJ8n5gbFNWGCOsw==
X-Received: by 2002:a17:90a:1609:: with SMTP id n9mr1556225pja.64.1569880172506;
        Mon, 30 Sep 2019 14:49:32 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 30sm505746pjk.25.2019.09.30.14.49.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 14:49:31 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 3/5] ionic: report users coalesce request
Date:   Mon, 30 Sep 2019 14:49:18 -0700
Message-Id: <20190930214920.18764-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190930214920.18764-1-snelson@pensando.io>
References: <20190930214920.18764-1-snelson@pensando.io>
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

Fixes: 8c15440bce31 ("ionic: Add coalesce and other features")
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

