Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0DB3953F2
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 04:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhEaClB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 22:41:01 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3296 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhEaCks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 22:40:48 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FtfWR5vr5z1BGjL;
        Mon, 31 May 2021 10:34:27 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:07 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:01 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/8] net: hns3: refine for hclge_push_vf_port_base_vlan_info()
Date:   Mon, 31 May 2021 10:38:39 +0800
Message-ID: <1622428725-30049-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622428725-30049-1-git-send-email-tanhuazhong@huawei.com>
References: <1622428725-30049-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Use struct "hclge_vlan_info" instead of separately parameters
for function hclge_push_vf_port_base_vlan_info(), to make it
more concise.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |  3 +--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h |  4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c  | 10 +++++-----
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index af5b278..7c6b51f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10258,8 +10258,7 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 	    test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
 		hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
 						  vport->vport_id, state,
-						  vlan, qos,
-						  ntohs(proto));
+						  &vlan_info);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 9e4d02d..e3dc216 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1084,8 +1084,8 @@ void hclge_restore_vport_vlan_table(struct hclge_vport *vport);
 int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 				    struct hclge_vlan_info *vlan_info);
 int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
-				      u16 state, u16 vlan_tag, u16 qos,
-				      u16 vlan_proto);
+				      u16 state,
+				      struct hclge_vlan_info *vlan_info);
 void hclge_task_schedule(struct hclge_dev *hdev, unsigned long delay_time);
 int hclge_query_bd_num_cmd_send(struct hclge_dev *hdev,
 				struct hclge_desc *desc);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 851408b..16b42ce 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -318,17 +318,17 @@ static int hclge_set_vf_mc_mac_addr(struct hclge_vport *vport,
 }
 
 int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
-				      u16 state, u16 vlan_tag, u16 qos,
-				      u16 vlan_proto)
+				      u16 state,
+				      struct hclge_vlan_info *vlan_info)
 {
 #define MSG_DATA_SIZE	8
 
 	u8 msg_data[MSG_DATA_SIZE];
 
 	memcpy(&msg_data[0], &state, sizeof(u16));
-	memcpy(&msg_data[2], &vlan_proto, sizeof(u16));
-	memcpy(&msg_data[4], &qos, sizeof(u16));
-	memcpy(&msg_data[6], &vlan_tag, sizeof(u16));
+	memcpy(&msg_data[2], &vlan_info->vlan_proto, sizeof(u16));
+	memcpy(&msg_data[4], &vlan_info->qos, sizeof(u16));
+	memcpy(&msg_data[6], &vlan_info->vlan_tag, sizeof(u16));
 
 	return hclge_send_mbx_msg(vport, msg_data, sizeof(msg_data),
 				  HCLGE_MBX_PUSH_VLAN_INFO, vfid);
-- 
2.7.4

