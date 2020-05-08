Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0433B1CBD1F
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgEIECW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:02:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4362 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725385AbgEIECV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 00:02:21 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7D87A24E1450EB37C86D;
        Sat,  9 May 2020 12:02:19 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 12:02:10 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net v2] hinic: fix a bug of ndo_stop
Date:   Fri, 8 May 2020 20:19:33 +0000
Message-ID: <20200508201933.5054-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if some function in ndo_stop interface returns failure because of
hardware fault, must go on excuting rest steps rather than return
failure directly, otherwise will cause memory leak.And bump the
timeout for SET_FUNC_STATE to ensure that cmd won't return failure
when hw is busy. Otherwise hw may stomp host memory if we free
memory regardless of the return value of SET_FUNC_STATE.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.c | 28 ++++++++++++++-----
 .../net/ethernet/huawei/hinic/hinic_main.c    | 16 ++---------
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index eef855f11a01..e66659bab012 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -45,6 +45,10 @@
 
 #define MGMT_MSG_TIMEOUT                5000
 
+#define SET_FUNC_PORT_MBOX_TIMEOUT	30000
+
+#define SET_FUNC_PORT_MGMT_TIMEOUT	25000
+
 #define mgmt_to_pfhwdev(pf_mgmt)        \
 		container_of(pf_mgmt, struct hinic_pfhwdev, pf_to_mgmt)
 
@@ -238,12 +242,13 @@ static int msg_to_mgmt_sync(struct hinic_pf_to_mgmt *pf_to_mgmt,
 			    u8 *buf_in, u16 in_size,
 			    u8 *buf_out, u16 *out_size,
 			    enum mgmt_direction_type direction,
-			    u16 resp_msg_id)
+			    u16 resp_msg_id, u32 timeout)
 {
 	struct hinic_hwif *hwif = pf_to_mgmt->hwif;
 	struct pci_dev *pdev = hwif->pdev;
 	struct hinic_recv_msg *recv_msg;
 	struct completion *recv_done;
+	unsigned long timeo;
 	u16 msg_id;
 	int err;
 
@@ -267,8 +272,9 @@ static int msg_to_mgmt_sync(struct hinic_pf_to_mgmt *pf_to_mgmt,
 		goto unlock_sync_msg;
 	}
 
-	if (!wait_for_completion_timeout(recv_done,
-					 msecs_to_jiffies(MGMT_MSG_TIMEOUT))) {
+	timeo = msecs_to_jiffies(timeout ? timeout : MGMT_MSG_TIMEOUT);
+
+	if (!wait_for_completion_timeout(recv_done, timeo)) {
 		dev_err(&pdev->dev, "MGMT timeout, MSG id = %d\n", msg_id);
 		err = -ETIMEDOUT;
 		goto unlock_sync_msg;
@@ -342,6 +348,7 @@ int hinic_msg_to_mgmt(struct hinic_pf_to_mgmt *pf_to_mgmt,
 {
 	struct hinic_hwif *hwif = pf_to_mgmt->hwif;
 	struct pci_dev *pdev = hwif->pdev;
+	u32 timeout = 0;
 
 	if (sync != HINIC_MGMT_MSG_SYNC) {
 		dev_err(&pdev->dev, "Invalid MGMT msg type\n");
@@ -353,13 +360,20 @@ int hinic_msg_to_mgmt(struct hinic_pf_to_mgmt *pf_to_mgmt,
 		return -EINVAL;
 	}
 
-	if (HINIC_IS_VF(hwif))
+	if (HINIC_IS_VF(hwif)) {
+		if (cmd == HINIC_PORT_CMD_SET_FUNC_STATE)
+			timeout = SET_FUNC_PORT_MBOX_TIMEOUT;
+
 		return hinic_mbox_to_pf(pf_to_mgmt->hwdev, mod, cmd, buf_in,
-					in_size, buf_out, out_size, 0);
-	else
+					in_size, buf_out, out_size, timeout);
+	} else {
+		if (cmd == HINIC_PORT_CMD_SET_FUNC_STATE)
+			timeout = SET_FUNC_PORT_MGMT_TIMEOUT;
+
 		return msg_to_mgmt_sync(pf_to_mgmt, mod, cmd, buf_in, in_size,
 				buf_out, out_size, MGMT_DIRECT_SEND,
-				MSG_NOT_RESP);
+				MSG_NOT_RESP, timeout);
+	}
 }
 
 /**
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 3d6569d7bac8..22ee868dd11e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -487,7 +487,6 @@ static int hinic_close(struct net_device *netdev)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	unsigned int flags;
-	int err;
 
 	down(&nic_dev->mgmt_lock);
 
@@ -504,20 +503,9 @@ static int hinic_close(struct net_device *netdev)
 	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
 		hinic_notify_all_vfs_link_changed(nic_dev->hwdev, 0);
 
-	err = hinic_port_set_func_state(nic_dev, HINIC_FUNC_PORT_DISABLE);
-	if (err) {
-		netif_err(nic_dev, drv, netdev,
-			  "Failed to set func port state\n");
-		nic_dev->flags |= (flags & HINIC_INTF_UP);
-		return err;
-	}
+	hinic_port_set_state(nic_dev, HINIC_PORT_DISABLE);
 
-	err = hinic_port_set_state(nic_dev, HINIC_PORT_DISABLE);
-	if (err) {
-		netif_err(nic_dev, drv, netdev, "Failed to set port state\n");
-		nic_dev->flags |= (flags & HINIC_INTF_UP);
-		return err;
-	}
+	hinic_port_set_func_state(nic_dev, HINIC_FUNC_PORT_DISABLE);
 
 	if (nic_dev->flags & HINIC_RSS_ENABLE) {
 		hinic_rss_deinit(nic_dev);
-- 
2.17.1

