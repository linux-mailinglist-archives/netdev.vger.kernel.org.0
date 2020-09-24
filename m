Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95272765DE
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgIXBac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:30:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14266 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725273AbgIXBac (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 21:30:32 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A5CBDF4800612618B408;
        Thu, 24 Sep 2020 09:30:29 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 24 Sep 2020 09:30:23 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>, <zengweiliang.zengweiliang@huawei.com>
Subject: [PATCH net] hinic: fix wrong return value of mac-set cmd
Date:   Thu, 24 Sep 2020 09:31:51 +0800
Message-ID: <20200924013151.25754-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should also be regarded as an error when hw return status=4 for PF's
setting mac cmd. Only if PF return status=4 to VF should this cmd be
taken special treatment.

Fixes: 7dd29ee12865 ("hinic: add sriov feature support")
Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_port.c  |  6 +++---
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c | 12 ++----------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 02cd635d6914..eb97f2d6b1ad 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -58,9 +58,9 @@ static int change_mac(struct hinic_dev *nic_dev, const u8 *addr,
 				 sizeof(port_mac_cmd),
 				 &port_mac_cmd, &out_size);
 	if (err || out_size != sizeof(port_mac_cmd) ||
-	    (port_mac_cmd.status  &&
-	    port_mac_cmd.status != HINIC_PF_SET_VF_ALREADY &&
-	    port_mac_cmd.status != HINIC_MGMT_STATUS_EXIST)) {
+	    (port_mac_cmd.status &&
+	     (port_mac_cmd.status != HINIC_PF_SET_VF_ALREADY || !HINIC_IS_VF(hwif)) &&
+	     port_mac_cmd.status != HINIC_MGMT_STATUS_EXIST)) {
 		dev_err(&pdev->dev, "Failed to change MAC, err: %d, status: 0x%x, out size: 0x%x\n",
 			err, port_mac_cmd.status, out_size);
 		return -EFAULT;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index 4d63680f2143..f8a26459ff65 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -38,8 +38,7 @@ static int hinic_set_mac(struct hinic_hwdev *hwdev, const u8 *mac_addr,
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_MAC, &mac_info,
 				 sizeof(mac_info), &mac_info, &out_size);
 	if (err || out_size != sizeof(mac_info) ||
-	    (mac_info.status && mac_info.status != HINIC_PF_SET_VF_ALREADY &&
-	    mac_info.status != HINIC_MGMT_STATUS_EXIST)) {
+	    (mac_info.status && mac_info.status != HINIC_MGMT_STATUS_EXIST)) {
 		dev_err(&hwdev->func_to_io.hwif->pdev->dev, "Failed to set MAC, err: %d, status: 0x%x, out size: 0x%x\n",
 			err, mac_info.status, out_size);
 		return -EIO;
@@ -503,8 +502,7 @@ struct hinic_sriov_info *hinic_get_sriov_info_by_pcidev(struct pci_dev *pdev)
 
 static int hinic_check_mac_info(u8 status, u16 vlan_id)
 {
-	if ((status && status != HINIC_MGMT_STATUS_EXIST &&
-	     status != HINIC_PF_SET_VF_ALREADY) ||
+	if ((status && status != HINIC_MGMT_STATUS_EXIST) ||
 	    (vlan_id & CHECK_IPSU_15BIT &&
 	     status == HINIC_MGMT_STATUS_EXIST))
 		return -EINVAL;
@@ -546,12 +544,6 @@ static int hinic_update_mac(struct hinic_hwdev *hwdev, u8 *old_mac,
 		return -EINVAL;
 	}
 
-	if (mac_info.status == HINIC_PF_SET_VF_ALREADY) {
-		dev_warn(&hwdev->hwif->pdev->dev,
-			 "PF has already set VF MAC. Ignore update operation\n");
-		return HINIC_PF_SET_VF_ALREADY;
-	}
-
 	if (mac_info.status == HINIC_MGMT_STATUS_EXIST)
 		dev_warn(&hwdev->hwif->pdev->dev, "MAC is repeated. Ignore update operation\n");
 
-- 
2.17.1

