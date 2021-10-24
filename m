Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C134643880F
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 11:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhJXJsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 05:48:07 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:26187 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhJXJr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 05:47:58 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HcY812QVYz8tk6;
        Sun, 24 Oct 2021 17:44:17 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:35 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 4/8] net: hns3: add support pause/pfc durations for mac statistics
Date:   Sun, 24 Oct 2021 17:41:11 +0800
Message-ID: <20211024094115.42158-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024094115.42158-1-huangguangbin2@huawei.com>
References: <20211024094115.42158-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mac statistics add pause/pfc durations in device version V3, we can
get total active cycle of pause/pfc from these durations.

As driver gets register number from firmware to calculate desc number to
query mac statistics, it needs to set mac statistics extended enable bit
in firmware command 0x701A to tell firmware that driver supports extended
mac statistics, otherwise firmware only returns register number of
version V1.

As pause/pfc durations are not supported by hardware of old version, they
should not been shown in command "ethtool -S ethX" in this case, so add
checking max register number of each mac statistic in their version.
If the max register number of one mac statistic is greater than register
number got from firmware, it means hardware does not support this mac
statistic, so ignore this statistic when get string and data of mac
statistic.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         |   1 +
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |   1 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 245 +++++++++++-------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  27 ++
 4 files changed, 182 insertions(+), 92 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 9c2eeaa82294..c327df9dbac4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -482,6 +482,7 @@ static int hclge_firmware_compat_config(struct hclge_dev *hdev, bool en)
 		hnae3_set_bit(compat, HCLGE_NCSI_ERROR_REPORT_EN_B, 1);
 		if (hnae3_dev_phy_imp_supported(hdev))
 			hnae3_set_bit(compat, HCLGE_PHY_IMP_EN_B, 1);
+		hnae3_set_bit(compat, HCLGE_MAC_STATS_EXT_EN_B, 1);
 
 		req->compat = cpu_to_le32(compat);
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index bfcfefa9d2b5..c38b57fc6c6a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1150,6 +1150,7 @@ struct hclge_query_ppu_pf_other_int_dfx_cmd {
 #define HCLGE_LINK_EVENT_REPORT_EN_B	0
 #define HCLGE_NCSI_ERROR_REPORT_EN_B	1
 #define HCLGE_PHY_IMP_EN_B		2
+#define HCLGE_MAC_STATS_EXT_EN_B	3
 struct hclge_firmware_compat_cmd {
 	__le32 compat;
 	u8 rsv[20];
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7c807abe968a..b79e36144647 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -156,174 +156,210 @@ static const char hns3_nic_test_strs[][ETH_GSTRING_LEN] = {
 };
 
 static const struct hclge_comm_stats_str g_mac_stats_string[] = {
-	{"mac_tx_mac_pause_num",
+	{"mac_tx_mac_pause_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_mac_pause_num)},
-	{"mac_rx_mac_pause_num",
+	{"mac_rx_mac_pause_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_mac_pause_num)},
-	{"mac_tx_control_pkt_num",
+	{"mac_tx_pause_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pause_xoff_time)},
+	{"mac_rx_pause_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pause_xoff_time)},
+	{"mac_tx_control_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_ctrl_pkt_num)},
-	{"mac_rx_control_pkt_num",
+	{"mac_rx_control_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_ctrl_pkt_num)},
-	{"mac_tx_pfc_pkt_num",
+	{"mac_tx_pfc_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pause_pkt_num)},
-	{"mac_tx_pfc_pri0_pkt_num",
+	{"mac_tx_pfc_pri0_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri0_pkt_num)},
-	{"mac_tx_pfc_pri1_pkt_num",
+	{"mac_tx_pfc_pri1_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri1_pkt_num)},
-	{"mac_tx_pfc_pri2_pkt_num",
+	{"mac_tx_pfc_pri2_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri2_pkt_num)},
-	{"mac_tx_pfc_pri3_pkt_num",
+	{"mac_tx_pfc_pri3_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri3_pkt_num)},
-	{"mac_tx_pfc_pri4_pkt_num",
+	{"mac_tx_pfc_pri4_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri4_pkt_num)},
-	{"mac_tx_pfc_pri5_pkt_num",
+	{"mac_tx_pfc_pri5_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri5_pkt_num)},
-	{"mac_tx_pfc_pri6_pkt_num",
+	{"mac_tx_pfc_pri6_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri6_pkt_num)},
-	{"mac_tx_pfc_pri7_pkt_num",
+	{"mac_tx_pfc_pri7_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri7_pkt_num)},
-	{"mac_rx_pfc_pkt_num",
+	{"mac_tx_pfc_pri0_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri0_xoff_time)},
+	{"mac_tx_pfc_pri1_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri1_xoff_time)},
+	{"mac_tx_pfc_pri2_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri2_xoff_time)},
+	{"mac_tx_pfc_pri3_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri3_xoff_time)},
+	{"mac_tx_pfc_pri4_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri4_xoff_time)},
+	{"mac_tx_pfc_pri5_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri5_xoff_time)},
+	{"mac_tx_pfc_pri6_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri6_xoff_time)},
+	{"mac_tx_pfc_pri7_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_pfc_pri7_xoff_time)},
+	{"mac_rx_pfc_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pause_pkt_num)},
-	{"mac_rx_pfc_pri0_pkt_num",
+	{"mac_rx_pfc_pri0_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri0_pkt_num)},
-	{"mac_rx_pfc_pri1_pkt_num",
+	{"mac_rx_pfc_pri1_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri1_pkt_num)},
-	{"mac_rx_pfc_pri2_pkt_num",
+	{"mac_rx_pfc_pri2_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri2_pkt_num)},
-	{"mac_rx_pfc_pri3_pkt_num",
+	{"mac_rx_pfc_pri3_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri3_pkt_num)},
-	{"mac_rx_pfc_pri4_pkt_num",
+	{"mac_rx_pfc_pri4_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri4_pkt_num)},
-	{"mac_rx_pfc_pri5_pkt_num",
+	{"mac_rx_pfc_pri5_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri5_pkt_num)},
-	{"mac_rx_pfc_pri6_pkt_num",
+	{"mac_rx_pfc_pri6_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri6_pkt_num)},
-	{"mac_rx_pfc_pri7_pkt_num",
+	{"mac_rx_pfc_pri7_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri7_pkt_num)},
-	{"mac_tx_total_pkt_num",
+	{"mac_rx_pfc_pri0_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri0_xoff_time)},
+	{"mac_rx_pfc_pri1_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri1_xoff_time)},
+	{"mac_rx_pfc_pri2_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri2_xoff_time)},
+	{"mac_rx_pfc_pri3_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri3_xoff_time)},
+	{"mac_rx_pfc_pri4_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri4_xoff_time)},
+	{"mac_rx_pfc_pri5_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri5_xoff_time)},
+	{"mac_rx_pfc_pri6_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri6_xoff_time)},
+	{"mac_rx_pfc_pri7_xoff_time", HCLGE_MAC_STATS_MAX_NUM_V2,
+		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_pfc_pri7_xoff_time)},
+	{"mac_tx_total_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_total_pkt_num)},
-	{"mac_tx_total_oct_num",
+	{"mac_tx_total_oct_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_total_oct_num)},
-	{"mac_tx_good_pkt_num",
+	{"mac_tx_good_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_good_pkt_num)},
-	{"mac_tx_bad_pkt_num",
+	{"mac_tx_bad_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_bad_pkt_num)},
-	{"mac_tx_good_oct_num",
+	{"mac_tx_good_oct_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_good_oct_num)},
-	{"mac_tx_bad_oct_num",
+	{"mac_tx_bad_oct_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_bad_oct_num)},
-	{"mac_tx_uni_pkt_num",
+	{"mac_tx_uni_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_uni_pkt_num)},
-	{"mac_tx_multi_pkt_num",
+	{"mac_tx_multi_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_multi_pkt_num)},
-	{"mac_tx_broad_pkt_num",
+	{"mac_tx_broad_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_broad_pkt_num)},
-	{"mac_tx_undersize_pkt_num",
+	{"mac_tx_undersize_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_undersize_pkt_num)},
-	{"mac_tx_oversize_pkt_num",
+	{"mac_tx_oversize_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_oversize_pkt_num)},
-	{"mac_tx_64_oct_pkt_num",
+	{"mac_tx_64_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_64_oct_pkt_num)},
-	{"mac_tx_65_127_oct_pkt_num",
+	{"mac_tx_65_127_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_65_127_oct_pkt_num)},
-	{"mac_tx_128_255_oct_pkt_num",
+	{"mac_tx_128_255_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_128_255_oct_pkt_num)},
-	{"mac_tx_256_511_oct_pkt_num",
+	{"mac_tx_256_511_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_256_511_oct_pkt_num)},
-	{"mac_tx_512_1023_oct_pkt_num",
+	{"mac_tx_512_1023_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_512_1023_oct_pkt_num)},
-	{"mac_tx_1024_1518_oct_pkt_num",
+	{"mac_tx_1024_1518_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_1024_1518_oct_pkt_num)},
-	{"mac_tx_1519_2047_oct_pkt_num",
+	{"mac_tx_1519_2047_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_1519_2047_oct_pkt_num)},
-	{"mac_tx_2048_4095_oct_pkt_num",
+	{"mac_tx_2048_4095_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_2048_4095_oct_pkt_num)},
-	{"mac_tx_4096_8191_oct_pkt_num",
+	{"mac_tx_4096_8191_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_4096_8191_oct_pkt_num)},
-	{"mac_tx_8192_9216_oct_pkt_num",
+	{"mac_tx_8192_9216_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_8192_9216_oct_pkt_num)},
-	{"mac_tx_9217_12287_oct_pkt_num",
+	{"mac_tx_9217_12287_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_9217_12287_oct_pkt_num)},
-	{"mac_tx_12288_16383_oct_pkt_num",
+	{"mac_tx_12288_16383_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_12288_16383_oct_pkt_num)},
-	{"mac_tx_1519_max_good_pkt_num",
+	{"mac_tx_1519_max_good_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_1519_max_good_oct_pkt_num)},
-	{"mac_tx_1519_max_bad_pkt_num",
+	{"mac_tx_1519_max_bad_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_1519_max_bad_oct_pkt_num)},
-	{"mac_rx_total_pkt_num",
+	{"mac_rx_total_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_total_pkt_num)},
-	{"mac_rx_total_oct_num",
+	{"mac_rx_total_oct_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_total_oct_num)},
-	{"mac_rx_good_pkt_num",
+	{"mac_rx_good_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_good_pkt_num)},
-	{"mac_rx_bad_pkt_num",
+	{"mac_rx_bad_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_bad_pkt_num)},
-	{"mac_rx_good_oct_num",
+	{"mac_rx_good_oct_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_good_oct_num)},
-	{"mac_rx_bad_oct_num",
+	{"mac_rx_bad_oct_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_bad_oct_num)},
-	{"mac_rx_uni_pkt_num",
+	{"mac_rx_uni_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_uni_pkt_num)},
-	{"mac_rx_multi_pkt_num",
+	{"mac_rx_multi_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_multi_pkt_num)},
-	{"mac_rx_broad_pkt_num",
+	{"mac_rx_broad_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_broad_pkt_num)},
-	{"mac_rx_undersize_pkt_num",
+	{"mac_rx_undersize_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_undersize_pkt_num)},
-	{"mac_rx_oversize_pkt_num",
+	{"mac_rx_oversize_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_oversize_pkt_num)},
-	{"mac_rx_64_oct_pkt_num",
+	{"mac_rx_64_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_64_oct_pkt_num)},
-	{"mac_rx_65_127_oct_pkt_num",
+	{"mac_rx_65_127_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_65_127_oct_pkt_num)},
-	{"mac_rx_128_255_oct_pkt_num",
+	{"mac_rx_128_255_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_128_255_oct_pkt_num)},
-	{"mac_rx_256_511_oct_pkt_num",
+	{"mac_rx_256_511_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_256_511_oct_pkt_num)},
-	{"mac_rx_512_1023_oct_pkt_num",
+	{"mac_rx_512_1023_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_512_1023_oct_pkt_num)},
-	{"mac_rx_1024_1518_oct_pkt_num",
+	{"mac_rx_1024_1518_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_1024_1518_oct_pkt_num)},
-	{"mac_rx_1519_2047_oct_pkt_num",
+	{"mac_rx_1519_2047_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_1519_2047_oct_pkt_num)},
-	{"mac_rx_2048_4095_oct_pkt_num",
+	{"mac_rx_2048_4095_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_2048_4095_oct_pkt_num)},
-	{"mac_rx_4096_8191_oct_pkt_num",
+	{"mac_rx_4096_8191_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_4096_8191_oct_pkt_num)},
-	{"mac_rx_8192_9216_oct_pkt_num",
+	{"mac_rx_8192_9216_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_8192_9216_oct_pkt_num)},
-	{"mac_rx_9217_12287_oct_pkt_num",
+	{"mac_rx_9217_12287_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_9217_12287_oct_pkt_num)},
-	{"mac_rx_12288_16383_oct_pkt_num",
+	{"mac_rx_12288_16383_oct_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_12288_16383_oct_pkt_num)},
-	{"mac_rx_1519_max_good_pkt_num",
+	{"mac_rx_1519_max_good_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_1519_max_good_oct_pkt_num)},
-	{"mac_rx_1519_max_bad_pkt_num",
+	{"mac_rx_1519_max_bad_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_1519_max_bad_oct_pkt_num)},
 
-	{"mac_tx_fragment_pkt_num",
+	{"mac_tx_fragment_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_fragment_pkt_num)},
-	{"mac_tx_undermin_pkt_num",
+	{"mac_tx_undermin_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_undermin_pkt_num)},
-	{"mac_tx_jabber_pkt_num",
+	{"mac_tx_jabber_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_jabber_pkt_num)},
-	{"mac_tx_err_all_pkt_num",
+	{"mac_tx_err_all_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_err_all_pkt_num)},
-	{"mac_tx_from_app_good_pkt_num",
+	{"mac_tx_from_app_good_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_from_app_good_pkt_num)},
-	{"mac_tx_from_app_bad_pkt_num",
+	{"mac_tx_from_app_bad_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_tx_from_app_bad_pkt_num)},
-	{"mac_rx_fragment_pkt_num",
+	{"mac_rx_fragment_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_fragment_pkt_num)},
-	{"mac_rx_undermin_pkt_num",
+	{"mac_rx_undermin_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_undermin_pkt_num)},
-	{"mac_rx_jabber_pkt_num",
+	{"mac_rx_jabber_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_jabber_pkt_num)},
-	{"mac_rx_fcs_err_pkt_num",
+	{"mac_rx_fcs_err_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_fcs_err_pkt_num)},
-	{"mac_rx_send_app_good_pkt_num",
+	{"mac_rx_send_app_good_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_send_app_good_pkt_num)},
-	{"mac_rx_send_app_bad_pkt_num",
+	{"mac_rx_send_app_bad_pkt_num", HCLGE_MAC_STATS_MAX_NUM_V1,
 		HCLGE_MAC_STATS_FIELD_OFF(mac_rx_send_app_bad_pkt_num)}
 };
 
@@ -665,20 +701,39 @@ static u8 *hclge_tqps_get_strings(struct hnae3_handle *handle, u8 *data)
 	return buff;
 }
 
-static u64 *hclge_comm_get_stats(const void *comm_stats,
+static int hclge_comm_get_count(struct hclge_dev *hdev,
+				const struct hclge_comm_stats_str strs[],
+				u32 size)
+{
+	int count = 0;
+	u32 i;
+
+	for (i = 0; i < size; i++)
+		if (strs[i].stats_num <= hdev->ae_dev->dev_specs.mac_stats_num)
+			count++;
+
+	return count;
+}
+
+static u64 *hclge_comm_get_stats(struct hclge_dev *hdev,
 				 const struct hclge_comm_stats_str strs[],
 				 int size, u64 *data)
 {
 	u64 *buf = data;
 	u32 i;
 
-	for (i = 0; i < size; i++)
-		buf[i] = HCLGE_STATS_READ(comm_stats, strs[i].offset);
+	for (i = 0; i < size; i++) {
+		if (strs[i].stats_num > hdev->ae_dev->dev_specs.mac_stats_num)
+			continue;
+
+		*buf = HCLGE_STATS_READ(&hdev->mac_stats, strs[i].offset);
+		buf++;
+	}
 
-	return buf + size;
+	return buf;
 }
 
-static u8 *hclge_comm_get_strings(u32 stringset,
+static u8 *hclge_comm_get_strings(struct hclge_dev *hdev, u32 stringset,
 				  const struct hclge_comm_stats_str strs[],
 				  int size, u8 *data)
 {
@@ -689,6 +744,9 @@ static u8 *hclge_comm_get_strings(u32 stringset,
 		return buff;
 
 	for (i = 0; i < size; i++) {
+		if (strs[i].stats_num > hdev->ae_dev->dev_specs.mac_stats_num)
+			continue;
+
 		snprintf(buff, ETH_GSTRING_LEN, "%s", strs[i].desc);
 		buff = buff + ETH_GSTRING_LEN;
 	}
@@ -780,7 +838,8 @@ static int hclge_get_sset_count(struct hnae3_handle *handle, int stringset)
 			handle->flags |= HNAE3_SUPPORT_PHY_LOOPBACK;
 		}
 	} else if (stringset == ETH_SS_STATS) {
-		count = ARRAY_SIZE(g_mac_stats_string) +
+		count = hclge_comm_get_count(hdev, g_mac_stats_string,
+					     ARRAY_SIZE(g_mac_stats_string)) +
 			hclge_tqps_get_sset_count(handle, stringset);
 	}
 
@@ -790,12 +849,14 @@ static int hclge_get_sset_count(struct hnae3_handle *handle, int stringset)
 static void hclge_get_strings(struct hnae3_handle *handle, u32 stringset,
 			      u8 *data)
 {
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
 	u8 *p = (char *)data;
 	int size;
 
 	if (stringset == ETH_SS_STATS) {
 		size = ARRAY_SIZE(g_mac_stats_string);
-		p = hclge_comm_get_strings(stringset, g_mac_stats_string,
+		p = hclge_comm_get_strings(hdev, stringset, g_mac_stats_string,
 					   size, p);
 		p = hclge_tqps_get_strings(handle, p);
 	} else if (stringset == ETH_SS_TEST) {
@@ -829,7 +890,7 @@ static void hclge_get_stats(struct hnae3_handle *handle, u64 *data)
 	struct hclge_dev *hdev = vport->back;
 	u64 *p;
 
-	p = hclge_comm_get_stats(&hdev->mac_stats, g_mac_stats_string,
+	p = hclge_comm_get_stats(hdev, g_mac_stats_string,
 				 ARRAY_SIZE(g_mac_stats_string), data);
 	p = hclge_tqps_get_stats(handle, p);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 36f1847b1c59..4f8403af84be 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -403,8 +403,13 @@ struct hclge_tm_info {
 	u8 pfc_en;	/* PFC enabled or not for user priority */
 };
 
+/* max number of mac statistics on each version */
+#define HCLGE_MAC_STATS_MAX_NUM_V1		84
+#define HCLGE_MAC_STATS_MAX_NUM_V2		105
+
 struct hclge_comm_stats_str {
 	char desc[ETH_GSTRING_LEN];
+	u32 stats_num;
 	unsigned long offset;
 };
 
@@ -499,6 +504,28 @@ struct hclge_mac_stats {
 	u64 mac_rx_pfc_pause_pkt_num;
 	u64 mac_tx_ctrl_pkt_num;
 	u64 mac_rx_ctrl_pkt_num;
+
+	/* duration of pfc */
+	u64 mac_tx_pfc_pri0_xoff_time;
+	u64 mac_tx_pfc_pri1_xoff_time;
+	u64 mac_tx_pfc_pri2_xoff_time;
+	u64 mac_tx_pfc_pri3_xoff_time;
+	u64 mac_tx_pfc_pri4_xoff_time;
+	u64 mac_tx_pfc_pri5_xoff_time;
+	u64 mac_tx_pfc_pri6_xoff_time;
+	u64 mac_tx_pfc_pri7_xoff_time;
+	u64 mac_rx_pfc_pri0_xoff_time;
+	u64 mac_rx_pfc_pri1_xoff_time;
+	u64 mac_rx_pfc_pri2_xoff_time;
+	u64 mac_rx_pfc_pri3_xoff_time;
+	u64 mac_rx_pfc_pri4_xoff_time;
+	u64 mac_rx_pfc_pri5_xoff_time;
+	u64 mac_rx_pfc_pri6_xoff_time;
+	u64 mac_rx_pfc_pri7_xoff_time;
+
+	/* duration of pause */
+	u64 mac_tx_pause_xoff_time;
+	u64 mac_rx_pause_xoff_time;
 };
 
 #define HCLGE_STATS_TIMER_INTERVAL	300UL
-- 
2.33.0

