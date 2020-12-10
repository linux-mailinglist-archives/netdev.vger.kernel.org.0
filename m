Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82AD2D51F8
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbgLJDnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:43:40 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9419 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730787AbgLJDn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:43:27 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cs08x5tSDz7CB9;
        Thu, 10 Dec 2020 11:42:09 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Dec 2020 11:42:35 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <huangdaode@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/7] net: hns3: add support for forwarding packet to queues of specified TC when flow director rule hit
Date:   Thu, 10 Dec 2020 11:42:08 +0800
Message-ID: <1607571732-24219-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
References: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

For some new device, it supports forwarding packet to queues
of specified TC when flow director rule hit. So extend the
command handle to support it.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c  |  2 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  |  3 +++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 21 +++++++++++++++++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h |  6 +++++-
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 85986c7..b728be4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -359,6 +359,8 @@ static void hclge_parse_capability(struct hclge_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGE_CAP_UDP_TUNNEL_CSUM_B))
 		set_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGE_CAP_FD_FORWARD_TC_B))
+		set_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps);
 }
 
 static enum hclge_cmd_status
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 52a6f9b..df5417d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1051,6 +1051,9 @@ struct hclge_fd_tcam_config_3_cmd {
 #define HCLGE_FD_AD_WR_RULE_ID_B	0
 #define HCLGE_FD_AD_RULE_ID_S		1
 #define HCLGE_FD_AD_RULE_ID_M		GENMASK(13, 1)
+#define HCLGE_FD_AD_TC_OVRD_B		16
+#define HCLGE_FD_AD_TC_SIZE_S		17
+#define HCLGE_FD_AD_TC_SIZE_M		GENMASK(20, 17)
 
 struct hclge_fd_ad_config_cmd {
 	u8 stage;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 366920b..0b6102e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5099,6 +5099,7 @@ static int hclge_fd_tcam_config(struct hclge_dev *hdev, u8 stage, bool sel_x,
 static int hclge_fd_ad_config(struct hclge_dev *hdev, u8 stage, int loc,
 			      struct hclge_fd_ad_data *action)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct hclge_fd_ad_config_cmd *req;
 	struct hclge_desc desc;
 	u64 ad_data = 0;
@@ -5114,6 +5115,12 @@ static int hclge_fd_ad_config(struct hclge_dev *hdev, u8 stage, int loc,
 		      action->write_rule_id_to_bd);
 	hnae3_set_field(ad_data, HCLGE_FD_AD_RULE_ID_M, HCLGE_FD_AD_RULE_ID_S,
 			action->rule_id);
+	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps)) {
+		hnae3_set_bit(ad_data, HCLGE_FD_AD_TC_OVRD_B,
+			      action->override_tc);
+		hnae3_set_field(ad_data, HCLGE_FD_AD_TC_SIZE_M,
+				HCLGE_FD_AD_TC_SIZE_S, (u32)action->tc_size);
+	}
 	ad_data <<= 32;
 	hnae3_set_bit(ad_data, HCLGE_FD_AD_DROP_B, action->drop_packet);
 	hnae3_set_bit(ad_data, HCLGE_FD_AD_DIRECT_QID_B,
@@ -5357,16 +5364,22 @@ static int hclge_config_key(struct hclge_dev *hdev, u8 stage,
 static int hclge_config_action(struct hclge_dev *hdev, u8 stage,
 			       struct hclge_fd_rule *rule)
 {
+	struct hclge_vport *vport = hdev->vport;
+	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
 	struct hclge_fd_ad_data ad_data;
 
+	memset(&ad_data, 0, sizeof(struct hclge_fd_ad_data));
 	ad_data.ad_id = rule->location;
 
 	if (rule->action == HCLGE_FD_ACTION_DROP_PACKET) {
 		ad_data.drop_packet = true;
-		ad_data.forward_to_direct_queue = false;
-		ad_data.queue_id = 0;
+	} else if (rule->action == HCLGE_FD_ACTION_SELECT_TC) {
+		ad_data.override_tc = true;
+		ad_data.queue_id =
+			kinfo->tc_info.tqp_offset[rule->tc];
+		ad_data.tc_size =
+			ilog2(kinfo->tc_info.tqp_count[rule->tc]);
 	} else {
-		ad_data.drop_packet = false;
 		ad_data.forward_to_direct_queue = true;
 		ad_data.queue_id = rule->queue_id;
 	}
@@ -5937,7 +5950,7 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 			return -EINVAL;
 		}
 
-		action = HCLGE_FD_ACTION_ACCEPT_PACKET;
+		action = HCLGE_FD_ACTION_SELECT_QUEUE;
 		q_index = ring;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index b3c1301..a481064 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -572,8 +572,9 @@ enum HCLGE_FD_PACKET_TYPE {
 };
 
 enum HCLGE_FD_ACTION {
-	HCLGE_FD_ACTION_ACCEPT_PACKET,
+	HCLGE_FD_ACTION_SELECT_QUEUE,
 	HCLGE_FD_ACTION_DROP_PACKET,
+	HCLGE_FD_ACTION_SELECT_TC,
 };
 
 struct hclge_fd_key_cfg {
@@ -619,6 +620,7 @@ struct hclge_fd_rule {
 	u32 unused_tuple;
 	u32 flow_type;
 	u8 action;
+	u8 tc;
 	u16 vf_id;
 	u16 queue_id;
 	u16 location;
@@ -637,6 +639,8 @@ struct hclge_fd_ad_data {
 	u8 write_rule_id_to_bd;
 	u8 next_input_key;
 	u16 rule_id;
+	u16 tc_size;
+	u8 override_tc;
 };
 
 enum HCLGE_MAC_NODE_STATE {
-- 
2.7.4

