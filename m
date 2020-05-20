Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B191DB584
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgETNsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:48:05 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24040 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726851AbgETNsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:48:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KDeifp014982;
        Wed, 20 May 2020 06:47:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=kYUIeQLCZVdEuTdcY6VGHrH3KLua67JMiIO1SlD319Q=;
 b=Y2y5Z721LoLFJFD2dsitTsLfL0gbRAok79hliLSt8+92Mb+DrS5LQh0x6AC//5Q/rMld
 XHCY+LOCeQtAuPkVgDO/mVlq4cI4q+HehA7zl3lYjJfEadK79Hckat4/MgnISV20JM14
 LbKln03wsIXa7kn7NVUbfNsjAARntCk4S/rZDCF0QWQUce4R2RSL0VA3qTHGSl/SukRP
 erOD8jBFIfcGIMHXHCWKC3sV9gY7GpnBG7F3NU4Dgm7P82REhuXPUvN9nHZCQ+8SuLRw
 S/Fr/HuA9hJigjZdTWwS5BnZz/agkln3eM1+F6OzbS7bWr0VAu833dWXQuNnGZWP9/NK PQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 312fpp8ks8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 May 2020 06:47:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:47:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:47:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 May 2020 06:47:56 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 0EBEE3F7040;
        Wed, 20 May 2020 06:47:54 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 08/12] net: atlantic: automatically downgrade the number of queues if necessary
Date:   Wed, 20 May 2020 16:47:30 +0300
Message-ID: <20200520134734.2014-9-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200520134734.2014-1-irusskikh@marvell.com>
References: <20200520134734.2014-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-20_09:2020-05-20,2020-05-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch adds support for automatic queue number downgrade.

On A2: this is a must have, because only TC0/TC1 support more than 4Q.
Other TCs support 4Qs maximum.
Thus, on A2 we must downgrade the number of queues per TC to 4, if more
than 2 TCs are requested.

On A1: this allows using 8TCs even on systems with cpu count >= 8, when
we have 8 queues by default.
We will just automatically switch to 8TCx4Q mode in this case.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 15 +---
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  5 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 78 +++++++++++++------
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  1 +
 4 files changed, 63 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 90a52a4b2d48..743d3b13b39d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -793,8 +793,6 @@ static int aq_set_ringparam(struct net_device *ndev,
 		dev_close(ndev);
 	}
 
-	aq_nic_free_vectors(aq_nic);
-
 	cfg->rxds = max(ring->rx_pending, hw_caps->rxds_min);
 	cfg->rxds = min(cfg->rxds, hw_caps->rxds_max);
 	cfg->rxds = ALIGN(cfg->rxds, AQ_HW_RXD_MULTIPLE);
@@ -803,15 +801,10 @@ static int aq_set_ringparam(struct net_device *ndev,
 	cfg->txds = min(cfg->txds, hw_caps->txds_max);
 	cfg->txds = ALIGN(cfg->txds, AQ_HW_TXD_MULTIPLE);
 
-	for (aq_nic->aq_vecs = 0; aq_nic->aq_vecs < cfg->vecs;
-	     aq_nic->aq_vecs++) {
-		aq_nic->aq_vec[aq_nic->aq_vecs] =
-		    aq_vec_alloc(aq_nic, aq_nic->aq_vecs, cfg);
-		if (unlikely(!aq_nic->aq_vec[aq_nic->aq_vecs])) {
-			err = -ENOMEM;
-			goto err_exit;
-		}
-	}
+	err = aq_nic_realloc_vectors(aq_nic);
+	if (err)
+		goto err_exit;
+
 	if (ndev_running)
 		err = dev_open(ndev, NULL);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 9835ad4fbec0..00a0032a5abc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -337,9 +337,12 @@ static int aq_validate_mqprio_opt(struct aq_nic_s *self,
 				  const unsigned int num_tc)
 {
 	const bool has_min_rate = !!(mqprio->flags & TC_MQPRIO_F_MIN_RATE);
+	struct aq_nic_cfg_s *aq_nic_cfg = aq_nic_get_cfg(self);
+	const unsigned int tcs_max = min_t(u8, aq_nic_cfg->aq_hw_caps->tcs_max,
+					   AQ_CFG_TCS_MAX);
 	int i;
 
-	if (num_tc > aq_hw_num_tcs(self->aq_hw)) {
+	if (num_tc > tcs_max) {
 		netdev_err(self->ndev, "Too many TCs requested\n");
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 7fd8dc779717..f5b57420e1b7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -69,6 +69,33 @@ static void aq_nic_rss_init(struct aq_nic_s *self, unsigned int num_rss_queues)
 		rss_params->indirection_table[i] = i & (num_rss_queues - 1);
 }
 
+/* Recalculate the number of vectors */
+static void aq_nic_cfg_update_num_vecs(struct aq_nic_s *self)
+{
+	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
+
+	cfg->vecs = min(cfg->aq_hw_caps->vecs, AQ_CFG_VECS_DEF);
+	cfg->vecs = min(cfg->vecs, num_online_cpus());
+	if (self->irqvecs > AQ_HW_SERVICE_IRQS)
+		cfg->vecs = min(cfg->vecs, self->irqvecs - AQ_HW_SERVICE_IRQS);
+	/* cfg->vecs should be power of 2 for RSS */
+	cfg->vecs = rounddown_pow_of_two(cfg->vecs);
+
+	if (ATL_HW_IS_CHIP_FEATURE(self->aq_hw, ANTIGUA)) {
+		if (cfg->tcs > 2)
+			cfg->vecs = min(cfg->vecs, 4U);
+	}
+
+	if (cfg->vecs <= 4)
+		cfg->tc_mode = AQ_TC_MODE_8TCS;
+	else
+		cfg->tc_mode = AQ_TC_MODE_4TCS;
+
+	/*rss rings */
+	cfg->num_rss_queues = min(cfg->vecs, AQ_CFG_NUM_RSS_QUEUES_DEF);
+	aq_nic_rss_init(self, cfg->num_rss_queues);
+}
+
 /* Checks hw_caps and 'corrects' aq_nic_cfg in runtime */
 void aq_nic_cfg_start(struct aq_nic_s *self)
 {
@@ -85,7 +112,6 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 
 	cfg->rxpageorder = AQ_CFG_RX_PAGEORDER;
 	cfg->is_rss = AQ_CFG_IS_RSS_DEF;
-	cfg->num_rss_queues = AQ_CFG_NUM_RSS_QUEUES_DEF;
 	cfg->aq_rss.base_cpu_number = AQ_CFG_RSS_BASE_CPU_NUM_DEF;
 	cfg->fc.req = AQ_CFG_FC_MODE;
 	cfg->wol = AQ_CFG_WOL_MODES;
@@ -101,24 +127,7 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 	cfg->rxds = min(cfg->aq_hw_caps->rxds_max, AQ_CFG_RXDS_DEF);
 	cfg->txds = min(cfg->aq_hw_caps->txds_max, AQ_CFG_TXDS_DEF);
 
-	/*rss rings */
-	cfg->vecs = min(cfg->aq_hw_caps->vecs, AQ_CFG_VECS_DEF);
-	cfg->vecs = min(cfg->vecs, num_online_cpus());
-	if (self->irqvecs > AQ_HW_SERVICE_IRQS)
-		cfg->vecs = min(cfg->vecs, self->irqvecs - AQ_HW_SERVICE_IRQS);
-	/* cfg->vecs should be power of 2 for RSS */
-	if (cfg->vecs >= 8U)
-		cfg->vecs = 8U;
-	else if (cfg->vecs >= 4U)
-		cfg->vecs = 4U;
-	else if (cfg->vecs >= 2U)
-		cfg->vecs = 2U;
-	else
-		cfg->vecs = 1U;
-
-	cfg->num_rss_queues = min(cfg->vecs, AQ_CFG_NUM_RSS_QUEUES_DEF);
-
-	aq_nic_rss_init(self, cfg->num_rss_queues);
+	aq_nic_cfg_update_num_vecs(self);
 
 	cfg->irq_type = aq_pci_func_get_irq_type(self);
 
@@ -129,11 +138,6 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 		cfg->vecs = 1U;
 	}
 
-	if (cfg->vecs <= 4)
-		cfg->tc_mode = AQ_TC_MODE_8TCS;
-	else
-		cfg->tc_mode = AQ_TC_MODE_4TCS;
-
 	/* Check if we have enough vectors allocated for
 	 * link status IRQ. If no - we'll know link state from
 	 * slower service task.
@@ -1223,6 +1227,22 @@ void aq_nic_free_vectors(struct aq_nic_s *self)
 err_exit:;
 }
 
+int aq_nic_realloc_vectors(struct aq_nic_s *self)
+{
+	struct aq_nic_cfg_s *cfg = aq_nic_get_cfg(self);
+
+	aq_nic_free_vectors(self);
+
+	for (self->aq_vecs = 0; self->aq_vecs < cfg->vecs; self->aq_vecs++) {
+		self->aq_vec[self->aq_vecs] = aq_vec_alloc(self, self->aq_vecs,
+							   cfg);
+		if (unlikely(!self->aq_vec[self->aq_vecs]))
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
 void aq_nic_shutdown(struct aq_nic_s *self)
 {
 	int err = 0;
@@ -1292,6 +1312,7 @@ void aq_nic_release_filter(struct aq_nic_s *self, enum aq_rx_filter_type type,
 int aq_nic_setup_tc_mqprio(struct aq_nic_s *self, u32 tcs, u8 *prio_tc_map)
 {
 	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
+	const unsigned int prev_vecs = cfg->vecs;
 	bool ndev_running;
 	int err = 0;
 	int i;
@@ -1320,9 +1341,18 @@ int aq_nic_setup_tc_mqprio(struct aq_nic_s *self, u32 tcs, u8 *prio_tc_map)
 
 	netdev_set_num_tc(self->ndev, cfg->tcs);
 
+	/* Changing the number of TCs might change the number of vectors */
+	aq_nic_cfg_update_num_vecs(self);
+	if (prev_vecs != cfg->vecs) {
+		err = aq_nic_realloc_vectors(self);
+		if (err)
+			goto err_exit;
+	}
+
 	if (ndev_running)
 		err = dev_open(self->ndev, NULL);
 
+err_exit:
 	return err;
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 351c4e68f40d..7a1d799b1e0d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -177,6 +177,7 @@ void aq_nic_deinit(struct aq_nic_s *self, bool link_down);
 void aq_nic_set_power(struct aq_nic_s *self);
 void aq_nic_free_hot_resources(struct aq_nic_s *self);
 void aq_nic_free_vectors(struct aq_nic_s *self);
+int aq_nic_realloc_vectors(struct aq_nic_s *self);
 int aq_nic_set_mtu(struct aq_nic_s *self, int new_mtu);
 int aq_nic_set_mac(struct aq_nic_s *self, struct net_device *ndev);
 int aq_nic_set_packet_filter(struct aq_nic_s *self, unsigned int flags);
-- 
2.25.1

