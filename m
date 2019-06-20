Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412F14C9FB
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731573AbfFTIyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:54:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42464 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731468AbfFTIyg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 04:54:36 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A1B1A7EE6B2A5DB35A89;
        Thu, 20 Jun 2019 16:54:33 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 16:54:23 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/11] net: hns3: remove override_pci_need_reset
Date:   Thu, 20 Jun 2019 16:52:41 +0800
Message-ID: <1561020765-14481-8-git-send-email-tanhuazhong@huawei.com>
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

From: Weihang Li <liweihang@hisilicon.com>

We add override_pci_need_reset to prevent redundant and unwanted PF
resets if a RAS error occurs in commit 69b51bbb03f7 ("net: hns3: fix
to stop multiple HNS reset due to the AER changes").

Now in HNS3 driver, we use hw_err_reset_req to record reset level that
we need to recover from a RAS error. This variable cans solve above
issue as override_pci_need_reset, so this patch removes
override_pci_need_reset.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h            | 1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c        | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 5 +----
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index d78a5f6..48c7b70 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -213,7 +213,6 @@ struct hnae3_ae_dev {
 	const struct hnae3_ae_ops *ops;
 	struct list_head node;
 	u32 flag;
-	u8 override_pci_need_reset; /* fix to stop multiple reset happening */
 	unsigned long hw_err_reset_req;
 	enum hnae3_reset_type reset_type;
 	void *priv;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 58633cd..4dee7fe 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1950,7 +1950,7 @@ static pci_ers_result_t hns3_slot_reset(struct pci_dev *pdev)
 	ops = ae_dev->ops;
 	/* request the reset */
 	if (ops->reset_event) {
-		if (!ae_dev->override_pci_need_reset) {
+		if (ae_dev->hw_err_reset_req) {
 			reset_type = ops->get_reset_level(ae_dev,
 						&ae_dev->hw_err_reset_req);
 			ops->set_default_reset_request(ae_dev, reset_type);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index dd7b8a8..3d8985f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1627,13 +1627,10 @@ pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev)
 	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
 		goto out;
 
-	if (ae_dev->hw_err_reset_req) {
-		ae_dev->override_pci_need_reset = 0;
+	if (ae_dev->hw_err_reset_req)
 		return PCI_ERS_RESULT_NEED_RESET;
-	}
 
 out:
-	ae_dev->override_pci_need_reset = 1;
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
-- 
2.7.4

