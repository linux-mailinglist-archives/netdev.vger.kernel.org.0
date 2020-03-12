Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15558183BBC
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 22:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgCLVug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 17:50:36 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54467 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbgCLVud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 17:50:33 -0400
Received: by mail-pj1-f66.google.com with SMTP id np16so3093478pjb.4
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 14:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3mb9QuPeiADGGqmEP+838Y3QNMnODA03xCrK5e6N588=;
        b=jtcuZBPXsHGdn+xxrAG+082fFCkEWRwybCs+7jsdq9Ca1Ktf0bwwl4uUV9b7zz9HyN
         DlK9QQaiCTRa+pi2Cmkub50ENeSJLNxmmvrPlvVl+97DowjLCF1HL8u1g/R2yn5LwuwR
         X4XCX1cXB+i1nwNbQ3J+k/5shOLRSYDFQliUvm8l6RpaN7J3KueXxmYjR82fjVSZzbuH
         SgIiSpX461GZUFreY/d75RWL6l6mx/ILABYKSspI4qFLSZUf/QuD0tppxYDdirm1GROs
         J0U+oZX5K+V57D4yKzHyPNxjgT3AdX7JQnSFcb/ojUfe03vFJAbfnAyiqUl6okv8QTYM
         /Ppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3mb9QuPeiADGGqmEP+838Y3QNMnODA03xCrK5e6N588=;
        b=a4axrLcOo50rY5rqB3mCdiQbXg4R5rQZVdhp2Gzcy7+WLeNpEyB+e1d8r88/TCSlXl
         c6B3NS6N2oU1yJxMBPcH5C//P9FHE40a488+YBuWNL/+IJVLqRHqNDGTjU+35WtGvE9K
         O/0tpOBZEK3mbE3fhH1AyI4jAcHvGHuI6CY1BkBwgdAaMU+7j4EtfUyyKJhYvtDWM4Hg
         nO+EqdyCwgkNGby+oIScHIVpp/nIwjnx2+0067wHxsHsnSgrozLXtltOdukIpBP9FUDi
         QC4vaO5nkw9TZfwLmGv1FpsEYAMRicAq7tgrTGW9aml+mLYu1PZAOOMcNfOG0okj1rl/
         WizA==
X-Gm-Message-State: ANhLgQ1KcGehb3Fitfiouzyho9DEQj8l3A8w2yhmKjpyl5NHEFIay7yj
        Oko3i3KWXChjuFhcJQfT/TD9wlugXus=
X-Google-Smtp-Source: ADFU+vs/TFSUq/bZe8RVcJZ3rmcSb/6Z0KbfcP3qpprYqiqEiSc0fre8j1uxTB5T4Tz6RKHqWPKJvA==
X-Received: by 2002:a17:902:247:: with SMTP id 65mr10175663plc.128.1584049831486;
        Thu, 12 Mar 2020 14:50:31 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p2sm38281203pfb.41.2020.03.12.14.50.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Mar 2020 14:50:30 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/7] ionic: add a flag for FW in reset
Date:   Thu, 12 Mar 2020 14:50:12 -0700
Message-Id: <20200312215015.69547-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312215015.69547-1-snelson@pensando.io>
References: <20200312215015.69547-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the FW_RESET flag, and prevent a few things from happening
if the FW_RESET flag is set.  Code for setting and clearing
it is in a following patch.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---

Depending on timing of net updates into net-next, this may have a
conflict with 905fc4f8a399 ("ionic: fix vf op lock usage")

 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  4 ++
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 17 +++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 40 +++++++++++++++----
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  1 +
 .../net/ethernet/pensando/ionic/ionic_main.c  |  8 ++--
 5 files changed, 58 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 60fc191a35e5..c55e28f3c986 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -185,6 +185,10 @@ static int ionic_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	struct device *dev = ionic->dev;
 	int ret = 0;
 
+	if (ionic->master_lif &&
+	    test_bit(IONIC_LIF_F_FW_RESET, ionic->master_lif->state))
+		return -EBUSY;
+
 	if (num_vfs > 0) {
 		ret = pci_enable_sriov(pdev, num_vfs);
 		if (ret) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index a233716eac29..ddae21b1f80a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -27,10 +27,11 @@ static void ionic_get_stats_strings(struct ionic_lif *lif, u8 *buf)
 static void ionic_get_stats(struct net_device *netdev,
 			    struct ethtool_stats *stats, u64 *buf)
 {
-	struct ionic_lif *lif;
+	struct ionic_lif *lif = netdev_priv(netdev);
 	u32 i;
 
-	lif = netdev_priv(netdev);
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return;
 
 	memset(buf, 0, stats->n_stats * sizeof(*buf));
 	for (i = 0; i < ionic_num_stats_grps; i++)
@@ -255,6 +256,9 @@ static int ionic_set_link_ksettings(struct net_device *netdev,
 	struct ionic_dev *idev;
 	int err = 0;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	idev = &lif->ionic->idev;
 
 	/* set autoneg */
@@ -303,6 +307,9 @@ static int ionic_set_pauseparam(struct net_device *netdev,
 	u32 requested_pause;
 	int err;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	if (pause->autoneg)
 		return -EOPNOTSUPP;
 
@@ -355,6 +362,9 @@ static int ionic_set_fecparam(struct net_device *netdev,
 	u8 fec_type;
 	int ret = 0;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	if (lif->ionic->idev.port_info->config.an_enable) {
 		netdev_err(netdev, "FEC request not allowed while autoneg is enabled\n");
 		return -EINVAL;
@@ -739,6 +749,9 @@ static int ionic_nway_reset(struct net_device *netdev)
 	struct ionic *ionic = lif->ionic;
 	int err = 0;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	/* flap the link to force auto-negotiation */
 
 	mutex_lock(&ionic->dev_cmd_lock);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index eb1e885a2f70..7909a037d5f7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1664,6 +1664,9 @@ static int ionic_get_vf_config(struct net_device *netdev,
 	struct ionic *ionic = lif->ionic;
 	int ret = 0;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	down_read(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -1691,6 +1694,9 @@ static int ionic_get_vf_stats(struct net_device *netdev, int vf,
 	struct ionic_lif_stats *vs;
 	int ret = 0;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	down_read(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -1726,6 +1732,9 @@ static int ionic_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
 	if (!(is_zero_ether_addr(mac) || is_valid_ether_addr(mac)))
 		return -EINVAL;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	down_read(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -1757,6 +1766,9 @@ static int ionic_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
 	if (proto != htons(ETH_P_8021Q))
 		return -EPROTONOSUPPORT;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	down_read(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -1783,6 +1795,9 @@ static int ionic_set_vf_rate(struct net_device *netdev, int vf,
 	if (tx_min)
 		return -EINVAL;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	down_write(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -1805,6 +1820,9 @@ static int ionic_set_vf_spoofchk(struct net_device *netdev, int vf, bool set)
 	u8 data = set;  /* convert to u8 for config */
 	int ret;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	down_write(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -1827,6 +1845,9 @@ static int ionic_set_vf_trust(struct net_device *netdev, int vf, bool set)
 	u8 data = set;  /* convert to u8 for config */
 	int ret;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	down_write(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -1863,6 +1884,9 @@ static int ionic_set_vf_link_state(struct net_device *netdev, int vf, int set)
 		return -EINVAL;
 	}
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	down_write(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -2055,7 +2079,8 @@ static void ionic_lif_free(struct ionic_lif *lif)
 
 	/* free queues */
 	ionic_qcqs_free(lif);
-	ionic_lif_reset(lif);
+	if (!test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		ionic_lif_reset(lif);
 
 	/* free lif info */
 	dma_free_coherent(dev, lif->info_sz, lif->info, lif->info_pa);
@@ -2093,6 +2118,11 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 
 	clear_bit(IONIC_LIF_F_INITED, lif->state);
 
+	if (!test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
+		cancel_work_sync(&lif->deferred.work);
+		cancel_work_sync(&lif->tx_timeout_work);
+	}
+
 	ionic_rx_filters_deinit(lif);
 	ionic_lif_rss_deinit(lif);
 
@@ -2454,12 +2484,8 @@ void ionic_lifs_unregister(struct ionic *ionic)
 	 * current model, so don't bother searching the
 	 * ionic->lif for candidates to unregister
 	 */
-	if (!ionic->master_lif)
-		return;
-
-	cancel_work_sync(&ionic->master_lif->deferred.work);
-	cancel_work_sync(&ionic->master_lif->tx_timeout_work);
-	if (ionic->master_lif->netdev->reg_state == NETREG_REGISTERED)
+	if (ionic->master_lif &&
+	    ionic->master_lif->netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(ionic->master_lif->netdev);
 }
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 7c0c6fef8c0b..d811cbb790dc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -126,6 +126,7 @@ enum ionic_lif_state_flags {
 	IONIC_LIF_F_UP,
 	IONIC_LIF_F_LINK_CHECK_REQUESTED,
 	IONIC_LIF_F_QUEUE_RESET,
+	IONIC_LIF_F_FW_RESET,
 
 	/* leave this as last */
 	IONIC_LIF_F_STATE_SIZE
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 40345281b2c9..601865db7e03 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -283,9 +283,11 @@ int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 
 	err = ionic_adminq_post(lif, ctx);
 	if (err) {
-		name = ionic_opcode_to_str(ctx->cmd.cmd.opcode);
-		netdev_err(netdev, "Posting of %s (%d) failed: %d\n",
-			   name, ctx->cmd.cmd.opcode, err);
+		if (!test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
+			name = ionic_opcode_to_str(ctx->cmd.cmd.opcode);
+			netdev_err(netdev, "Posting of %s (%d) failed: %d\n",
+				   name, ctx->cmd.cmd.opcode, err);
+		}
 		return err;
 	}
 
-- 
2.17.1

