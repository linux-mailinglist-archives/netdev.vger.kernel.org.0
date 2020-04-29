Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED461BD370
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 06:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgD2ELm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 00:11:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3332 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725497AbgD2ELm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 00:11:42 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EE75AB21C9CFFC900FED;
        Wed, 29 Apr 2020 12:11:39 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Wed, 29 Apr 2020 12:11:32 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <aviad.krawczyk@huawei.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next v2] hinic: Use ARRAY_SIZE for nic_vf_cmd_msg_handler
Date:   Wed, 29 Apr 2020 12:17:40 +0800
Message-ID: <1588133860-55722-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix coccinelle warning, use ARRAY_SIZE

drivers/net/ethernet/huawei/hinic/hinic_sriov.c:713:43-44: WARNING: Use ARRAY_SIZE

----------
v1-->v2:
   remove cmd_number

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index b24788e..af70cca 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -704,17 +704,15 @@ int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
 	struct hinic_hwdev *dev = hwdev;
 	struct hinic_func_to_io *nic_io;
 	struct hinic_pfhwdev *pfhwdev;
-	u32 i, cmd_number;
+	u32 i;
 	int err = 0;
 
 	if (!hwdev)
 		return -EFAULT;
 
-	cmd_number = sizeof(nic_vf_cmd_msg_handler) /
-			    sizeof(struct vf_cmd_msg_handle);
 	pfhwdev = container_of(dev, struct hinic_pfhwdev, hwdev);
 	nic_io = &dev->func_to_io;
-	for (i = 0; i < cmd_number; i++) {
+	for (i = 0; i < ARRAY_SIZE(nic_vf_cmd_msg_handler); i++) {
 		vf_msg_handle = &nic_vf_cmd_msg_handler[i];
 		if (cmd == vf_msg_handle->cmd &&
 		    vf_msg_handle->cmd_msg_handler) {
@@ -725,7 +723,7 @@ int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
 			break;
 		}
 	}
-	if (i == cmd_number)
+	if (i == ARRAY_SIZE(nic_vf_cmd_msg_handler))
 		err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_L2NIC,
 					cmd, buf_in, in_size, buf_out,
 					out_size, HINIC_MGMT_MSG_SYNC);
-- 
2.6.2

