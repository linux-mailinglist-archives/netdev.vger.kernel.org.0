Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04AE54748A
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 14:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbiFKMbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 08:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiFKMbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 08:31:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F6D65A4;
        Sat, 11 Jun 2022 05:31:47 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LKxvL4XCjzRhr0;
        Sat, 11 Jun 2022 20:28:30 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 11 Jun 2022 20:31:45 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 11 Jun 2022 20:31:45 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 6/6] net: hns3: fix tm port shapping of fibre port is incorrect after driver initialization
Date:   Sat, 11 Jun 2022 20:25:29 +0800
Message-ID: <20220611122529.18571-7-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220611122529.18571-1-huangguangbin2@huawei.com>
References: <20220611122529.18571-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently in driver initialization process, driver will set shapping
parameters of tm port to default speed read from firmware. However, the
speed of SFP module may not be default speed, so shapping parameters of
tm port may be incorrect.

To fix this problem, driver sets new shapping parameters for tm port
after getting exact speed of SFP module in this case.

Fixes: 88d10bd6f730 ("net: hns3: add support for multiple media type")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 11 ++++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h |  1 +
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 2e891b837c51..fae79764dc44 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3268,7 +3268,7 @@ static int hclge_tp_port_init(struct hclge_dev *hdev)
 static int hclge_update_port_info(struct hclge_dev *hdev)
 {
 	struct hclge_mac *mac = &hdev->hw.mac;
-	int speed = HCLGE_MAC_SPEED_UNKNOWN;
+	int speed;
 	int ret;
 
 	/* get the port info from SFP cmd if not copper port */
@@ -3279,10 +3279,13 @@ static int hclge_update_port_info(struct hclge_dev *hdev)
 	if (!hdev->support_sfp_query)
 		return 0;
 
-	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
+		speed = mac->speed;
 		ret = hclge_get_sfp_info(hdev, mac);
-	else
+	} else {
+		speed = HCLGE_MAC_SPEED_UNKNOWN;
 		ret = hclge_get_sfp_speed(hdev, &speed);
+	}
 
 	if (ret == -EOPNOTSUPP) {
 		hdev->support_sfp_query = false;
@@ -3294,6 +3297,8 @@ static int hclge_update_port_info(struct hclge_dev *hdev)
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		if (mac->speed_type == QUERY_ACTIVE_SPEED) {
 			hclge_update_port_capability(hdev, mac);
+			if (mac->speed != speed)
+				(void)hclge_tm_port_shaper_cfg(hdev);
 			return 0;
 		}
 		return hclge_cfg_mac_speed_dup(hdev, mac->speed,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index f5296ff60694..2f33b036a47a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -420,7 +420,7 @@ static int hclge_tm_pg_shapping_cfg(struct hclge_dev *hdev,
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
-static int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
+int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
 {
 	struct hclge_port_shapping_cmd *shap_cfg_cmd;
 	struct hclge_shaper_ir_para ir_para;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 619cc30a2dfc..d943943912f7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -237,6 +237,7 @@ int hclge_pause_addr_cfg(struct hclge_dev *hdev, const u8 *mac_addr);
 void hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats);
 void hclge_pfc_tx_stats_get(struct hclge_dev *hdev, u64 *stats);
 int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate);
+int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev);
 int hclge_tm_get_qset_num(struct hclge_dev *hdev, u16 *qset_num);
 int hclge_tm_get_pri_num(struct hclge_dev *hdev, u8 *pri_num);
 int hclge_tm_get_qset_map_pri(struct hclge_dev *hdev, u16 qset_id, u8 *priority,
-- 
2.33.0

