Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A950F58E54F
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiHJDOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiHJDNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:52 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A0182F8D
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:50 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M2Zfr1mG5zXdSy;
        Wed, 10 Aug 2022 11:09:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:45 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 08/36] ravb: replace const features initialization with NETDEV_FEATURE_SET
Date:   Wed, 10 Aug 2022 11:05:56 +0800
Message-ID: <20220810030624.34711-9-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220810030624.34711-1-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ravb driver use netdev_features in global structure
initialization. Changed the its netdev_features_t memeber
to netdev_features_t *, and make it refer to a netdev_features_t
global variables.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  4 ++--
 drivers/net/ethernet/renesas/ravb_main.c | 27 +++++++++++++++++-------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index b980bce763d3..efd3c32b9e46 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1014,8 +1014,8 @@ struct ravb_hw_info {
 	void (*emac_init)(struct net_device *ndev);
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
 	size_t gstrings_size;
-	netdev_features_t net_hw_features;
-	netdev_features_t net_features;
+	const netdev_features_t *net_hw_features;
+	const netdev_features_t *net_features;
 	int stats_len;
 	size_t max_rx_len;
 	u32 tccr_mask;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b357ac4c56c5..b38f689c3683 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -50,6 +50,9 @@ static const char *ravb_tx_irqs[NUM_TX_QUEUE] = {
 	"ch19", /* RAVB_NC */
 };
 
+static netdev_features_t ravb_default_features;
+static netdev_features_t ravb_empty_features;
+
 void ravb_modify(struct net_device *ndev, enum ravb_reg reg, u32 clear,
 		 u32 set)
 {
@@ -2422,8 +2425,8 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.emac_init = ravb_emac_init_rcar,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
-	.net_hw_features = NETIF_F_RXCSUM,
-	.net_features = NETIF_F_RXCSUM,
+	.net_hw_features = &ravb_default_features,
+	.net_features = &ravb_default_features,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.tccr_mask = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
@@ -2448,8 +2451,8 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.emac_init = ravb_emac_init_rcar,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
-	.net_hw_features = NETIF_F_RXCSUM,
-	.net_features = NETIF_F_RXCSUM,
+	.net_hw_features = &ravb_default_features,
+	.net_features = &ravb_default_features,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.tccr_mask = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
@@ -2471,8 +2474,8 @@ static const struct ravb_hw_info ravb_rzv2m_hw_info = {
 	.emac_init = ravb_emac_init_rcar,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
-	.net_hw_features = NETIF_F_RXCSUM,
-	.net_features = NETIF_F_RXCSUM,
+	.net_hw_features = &ravb_default_features,
+	.net_features = &ravb_default_features,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.tccr_mask = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
@@ -2496,6 +2499,8 @@ static const struct ravb_hw_info gbeth_hw_info = {
 	.emac_init = ravb_emac_init_gbeth,
 	.gstrings_stats = ravb_gstrings_stats_gbeth,
 	.gstrings_size = sizeof(ravb_gstrings_stats_gbeth),
+	.net_hw_features = &ravb_empty_features,
+	.net_features = &ravb_empty_features,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats_gbeth),
 	.max_rx_len = ALIGN(GBETH_RX_BUFF_MAX, RAVB_ALIGN),
 	.tccr_mask = TCCR_TSRQ0,
@@ -2610,6 +2615,11 @@ static void ravb_set_delay_mode(struct net_device *ndev)
 	ravb_modify(ndev, APSR, APSR_RDM | APSR_TDM, set);
 }
 
+static void ravb_features_init(void)
+{
+	ravb_default_features |= NETIF_F_RXCSUM;
+}
+
 static int ravb_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -2639,8 +2649,9 @@ static int ravb_probe(struct platform_device *pdev)
 
 	info = of_device_get_match_data(&pdev->dev);
 
-	ndev->features = info->net_features;
-	ndev->hw_features = info->net_hw_features;
+	ravb_features_init();
+	ndev->features = *info->net_features;
+	ndev->hw_features = *info->net_hw_features;
 
 	reset_control_deassert(rstc);
 	pm_runtime_enable(&pdev->dev);
-- 
2.33.0

