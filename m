Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B814CA0A
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731171AbfFTIzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:55:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56130 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731340AbfFTIyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 04:54:31 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8AEB5817B27D8A01806F;
        Thu, 20 Jun 2019 16:54:28 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 16:54:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/11] net: hns3: sync VLAN filter entries when kill VLAN ID failed
Date:   Thu, 20 Jun 2019 16:52:37 +0800
Message-ID: <1561020765-14481-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
References: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

When HW is resetting, firmware is unable to handle commands
from driver. So if remove VLAN device from stack at this time,
it will fail to remove the VLAN ID from HW VLAN filter, then
the VLAN filter status is unsynced with stack.

This patch fixes it by recording the VLAN ID delete failed,
and removes them again when reset complete.

Fixes: 44e626f720c3 ("net: hns3: fix VLAN offload handle for VLAN inserted by port")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 74 ++++++++++++++++++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 50 ++++++++++++++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  3 +
 4 files changed, 112 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 90cbdbe..6e97837 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -35,6 +35,7 @@
 
 static int hclge_set_mac_mtu(struct hclge_dev *hdev, int new_mps);
 static int hclge_init_vlan_config(struct hclge_dev *hdev);
+static void hclge_sync_vlan_filter(struct hclge_dev *hdev);
 static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev);
 static bool hclge_get_hw_reset_stat(struct hnae3_handle *handle);
 static int hclge_set_umv_space(struct hclge_dev *hdev, u16 space_size,
@@ -3539,6 +3540,7 @@ static void hclge_service_task(struct work_struct *work)
 	hclge_update_port_info(hdev);
 	hclge_update_link_status(hdev);
 	hclge_update_vport_alive(hdev);
+	hclge_sync_vlan_filter(hdev);
 	if (hdev->fd_arfs_expire_timer >= HCLGE_FD_ARFS_EXPIRE_TIMER_INTERVAL) {
 		hclge_rfs_filter_expire(hdev);
 		hdev->fd_arfs_expire_timer = 0;
@@ -7742,11 +7744,20 @@ int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 	bool writen_to_tbl = false;
 	int ret = 0;
 
-	/* when port based VLAN enabled, we use port based VLAN as the VLAN
-	 * filter entry. In this case, we don't update VLAN filter table
-	 * when user add new VLAN or remove exist VLAN, just update the vport
-	 * VLAN list. The VLAN id in VLAN list won't be writen in VLAN filter
-	 * table until port based VLAN disabled
+	/* When device is resetting, firmware is unable to handle
+	 * mailbox. Just record the vlan id, and remove it after
+	 * reset finished.
+	 */
+	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) && is_kill) {
+		set_bit(vlan_id, vport->vlan_del_fail_bmap);
+		return -EBUSY;
+	}
+
+	/* When port base vlan enabled, we use port base vlan as the vlan
+	 * filter entry. In this case, we don't update vlan filter table
+	 * when user add new vlan or remove exist vlan, just update the vport
+	 * vlan list. The vlan id in vlan list will be writen in vlan filter
+	 * table until port base vlan disabled
 	 */
 	if (handle->port_base_vlan_state == HNAE3_PORT_BASE_VLAN_DISABLE) {
 		ret = hclge_set_vlan_filter_hw(hdev, proto, vport->vport_id,
@@ -7754,16 +7765,53 @@ int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 		writen_to_tbl = true;
 	}
 
-	if (ret)
-		return ret;
+	if (!ret) {
+		if (is_kill)
+			hclge_rm_vport_vlan_table(vport, vlan_id, false);
+		else
+			hclge_add_vport_vlan_table(vport, vlan_id,
+						   writen_to_tbl);
+	} else if (is_kill) {
+		/* When remove hw vlan filter failed, record the vlan id,
+		 * and try to remove it from hw later, to be consistence
+		 * with stack
+		 */
+		set_bit(vlan_id, vport->vlan_del_fail_bmap);
+	}
+	return ret;
+}
 
-	if (is_kill)
-		hclge_rm_vport_vlan_table(vport, vlan_id, false);
-	else
-		hclge_add_vport_vlan_table(vport, vlan_id,
-					   writen_to_tbl);
+static void hclge_sync_vlan_filter(struct hclge_dev *hdev)
+{
+#define HCLGE_MAX_SYNC_COUNT	60
 
-	return 0;
+	int i, ret, sync_cnt = 0;
+	u16 vlan_id;
+
+	/* start from vport 1 for PF is always alive */
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		struct hclge_vport *vport = &hdev->vport[i];
+
+		vlan_id = find_first_bit(vport->vlan_del_fail_bmap,
+					 VLAN_N_VID);
+		while (vlan_id != VLAN_N_VID) {
+			ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
+						       vport->vport_id, vlan_id,
+						       0, true);
+			if (ret && ret != -EINVAL)
+				return;
+
+			clear_bit(vlan_id, vport->vlan_del_fail_bmap);
+			hclge_rm_vport_vlan_table(vport, vlan_id, false);
+
+			sync_cnt++;
+			if (sync_cnt >= HCLGE_MAX_SYNC_COUNT)
+				return;
+
+			vlan_id = find_first_bit(vport->vlan_del_fail_bmap,
+						 VLAN_N_VID);
+		}
+	}
 }
 
 static int hclge_set_mac_mtu(struct hclge_dev *hdev, int new_mps)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index c55fd61..8c4e47a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -929,6 +929,7 @@ struct hclge_vport {
 	u32 bw_limit;		/* VSI BW Limit (0 = disabled) */
 	u8  dwrr;
 
+	unsigned long vlan_del_fail_bmap[BITS_TO_LONGS(VLAN_N_VID)];
 	struct hclge_port_base_vlan_config port_base_vlan_cfg;
 	struct hclge_tx_vtag_cfg  txvlan_cfg;
 	struct hclge_rx_vtag_cfg  rxvlan_cfg;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 270447e..21736e5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1244,6 +1244,7 @@ static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 #define HCLGEVF_VLAN_MBX_MSG_LEN 5
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	u8 msg_data[HCLGEVF_VLAN_MBX_MSG_LEN];
+	int ret;
 
 	if (vlan_id > HCLGEVF_MAX_VLAN_ID)
 		return -EINVAL;
@@ -1251,12 +1252,53 @@ static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 	if (proto != htons(ETH_P_8021Q))
 		return -EPROTONOSUPPORT;
 
+	/* When device is resetting, firmware is unable to handle
+	 * mailbox. Just record the vlan id, and remove it after
+	 * reset finished.
+	 */
+	if (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state) && is_kill) {
+		set_bit(vlan_id, hdev->vlan_del_fail_bmap);
+		return -EBUSY;
+	}
+
 	msg_data[0] = is_kill;
 	memcpy(&msg_data[1], &vlan_id, sizeof(vlan_id));
 	memcpy(&msg_data[3], &proto, sizeof(proto));
-	return hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_VLAN,
-				    HCLGE_MBX_VLAN_FILTER, msg_data,
-				    HCLGEVF_VLAN_MBX_MSG_LEN, false, NULL, 0);
+	ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_VLAN,
+				   HCLGE_MBX_VLAN_FILTER, msg_data,
+				   HCLGEVF_VLAN_MBX_MSG_LEN, false, NULL, 0);
+
+	/* When remove hw vlan filter failed, record the vlan id,
+	 * and try to remove it from hw later, to be consistence
+	 * with stack.
+	 */
+	if (is_kill && ret)
+		set_bit(vlan_id, hdev->vlan_del_fail_bmap);
+
+	return ret;
+}
+
+static void hclgevf_sync_vlan_filter(struct hclgevf_dev *hdev)
+{
+#define HCLGEVF_MAX_SYNC_COUNT	60
+	struct hnae3_handle *handle = &hdev->nic;
+	int ret, sync_cnt = 0;
+	u16 vlan_id;
+
+	vlan_id = find_first_bit(hdev->vlan_del_fail_bmap, VLAN_N_VID);
+	while (vlan_id != VLAN_N_VID) {
+		ret = hclgevf_set_vlan_filter(handle, htons(ETH_P_8021Q),
+					      vlan_id, true);
+		if (ret)
+			return;
+
+		clear_bit(vlan_id, hdev->vlan_del_fail_bmap);
+		sync_cnt++;
+		if (sync_cnt >= HCLGEVF_MAX_SYNC_COUNT)
+			return;
+
+		vlan_id = find_first_bit(hdev->vlan_del_fail_bmap, VLAN_N_VID);
+	}
 }
 
 static int hclgevf_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
@@ -1797,6 +1839,8 @@ static void hclgevf_service_task(struct work_struct *work)
 
 	hclgevf_update_link_mode(hdev);
 
+	hclgevf_sync_vlan_filter(hdev);
+
 	hclgevf_deferred_task_schedule(hdev);
 
 	clear_bit(HCLGEVF_STATE_SERVICE_SCHED, &hdev->state);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 4f86c87..b0ee986 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -4,6 +4,7 @@
 #ifndef __HCLGEVF_MAIN_H
 #define __HCLGEVF_MAIN_H
 #include <linux/fs.h>
+#include <linux/if_vlan.h>
 #include <linux/types.h>
 #include "hclge_mbx.h"
 #include "hclgevf_cmd.h"
@@ -270,6 +271,8 @@ struct hclgevf_dev {
 	u16 *vector_status;
 	int *vector_irq;
 
+	unsigned long vlan_del_fail_bmap[BITS_TO_LONGS(VLAN_N_VID)];
+
 	bool mbx_event_pending;
 	struct hclgevf_mbx_resp_status mbx_resp; /* mailbox response */
 	struct hclgevf_mbx_arq_ring arq; /* mailbox async rx queue */
-- 
2.7.4

