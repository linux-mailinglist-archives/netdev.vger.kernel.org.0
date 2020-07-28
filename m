Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336E622FF7A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 04:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgG1CTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 22:19:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8285 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726313AbgG1CTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 22:19:09 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8757C2CEB9A94E21F62C;
        Tue, 28 Jul 2020 10:19:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 28 Jul 2020 10:19:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 5/5] net: hns3: fix for VLAN config when reset failed
Date:   Tue, 28 Jul 2020 10:16:52 +0800
Message-ID: <1595902612-12880-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595902612-12880-1-git-send-email-tanhuazhong@huawei.com>
References: <1595902612-12880-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

When device is resetting or reset failed, firmware is unable to
handle mailbox. VLAN should not be configured in this case.

Fixes: fe4144d47eef ("net: hns3: sync VLAN filter entries when kill VLAN ID failed")
Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   |  7 ++++---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 10 ++++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index cee84e7..36575e7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9042,11 +9042,12 @@ int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 	bool writen_to_tbl = false;
 	int ret = 0;
 
-	/* When device is resetting, firmware is unable to handle
-	 * mailbox. Just record the vlan id, and remove it after
+	/* When device is resetting or reset failed, firmware is unable to
+	 * handle mailbox. Just record the vlan id, and remove it after
 	 * reset finished.
 	 */
-	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) && is_kill) {
+	if ((test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) ||
+	     test_bit(HCLGE_STATE_RST_FAIL, &hdev->state)) && is_kill) {
 		set_bit(vlan_id, vport->vlan_del_fail_bmap);
 		return -EBUSY;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index b8b72ac..9162856d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1592,11 +1592,12 @@ static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 	if (proto != htons(ETH_P_8021Q))
 		return -EPROTONOSUPPORT;
 
-	/* When device is resetting, firmware is unable to handle
-	 * mailbox. Just record the vlan id, and remove it after
+	/* When device is resetting or reset failed, firmware is unable to
+	 * handle mailbox. Just record the vlan id, and remove it after
 	 * reset finished.
 	 */
-	if (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state) && is_kill) {
+	if ((test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state) ||
+	     test_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state)) && is_kill) {
 		set_bit(vlan_id, hdev->vlan_del_fail_bmap);
 		return -EBUSY;
 	}
@@ -3443,7 +3444,8 @@ void hclgevf_update_port_base_vlan_info(struct hclgevf_dev *hdev, u16 state,
 
 	rtnl_lock();
 
-	if (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state)) {
+	if (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state) ||
+	    test_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state)) {
 		dev_warn(&hdev->pdev->dev,
 			 "is resetting when updating port based vlan info\n");
 		rtnl_unlock();
-- 
2.7.4

