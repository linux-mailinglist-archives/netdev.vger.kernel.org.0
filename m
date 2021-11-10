Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA2644C26A
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhKJNuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:50:23 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15815 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbhKJNuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:50:17 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hq5kR1kJCz9129;
        Wed, 10 Nov 2021 21:47:11 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:26 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:25 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 5/8] net: hns3: fix kernel crash when unload VF while it is being reset
Date:   Wed, 10 Nov 2021 21:42:53 +0800
Message-ID: <20211110134256.25025-6-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211110134256.25025-1-huangguangbin2@huawei.com>
References: <20211110134256.25025-1-huangguangbin2@huawei.com>
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

From: Yufeng Mo <moyufeng@huawei.com>

When fully configure VLANs for a VF, then unload the VF while
triggering a reset to PF, will cause a kernel crash because the
irq is already uninit.

[ 293.177579] ------------[ cut here ]------------
[ 293.183502] kernel BUG at drivers/pci/msi.c:352!
[ 293.189547] Internal error: Oops - BUG: 0 [#1] SMP
......
[ 293.390124] Workqueue: hclgevf hclgevf_service_task [hclgevf]
[ 293.402627] pstate: 80c00009 (Nzcv daif +PAN +UAO)
[ 293.414324] pc : free_msi_irqs+0x19c/0x1b8
[ 293.425429] lr : free_msi_irqs+0x18c/0x1b8
[ 293.436545] sp : ffff00002716fbb0
[ 293.446950] x29: ffff00002716fbb0 x28: 0000000000000000
[ 293.459519] x27: 0000000000000000 x26: ffff45b91ea16b00
[ 293.472183] x25: 0000000000000000 x24: ffffa587b08f4700
[ 293.484717] x23: ffffc591ac30e000 x22: ffffa587b08f8428
[ 293.497190] x21: ffffc591ac30e300 x20: 0000000000000000
[ 293.509594] x19: ffffa58a062a8300 x18: 0000000000000000
[ 293.521949] x17: 0000000000000000 x16: ffff45b91dcc3f48
[ 293.534013] x15: 0000000000000000 x14: 0000000000000000
[ 293.545883] x13: 0000000000000040 x12: 0000000000000228
[ 293.557508] x11: 0000000000000020 x10: 0000000000000040
[ 293.568889] x9 : ffff45b91ea1e190 x8 : ffffc591802d0000
[ 293.580123] x7 : ffffc591802d0148 x6 : 0000000000000120
[ 293.591190] x5 : ffffc591802d0000 x4 : 0000000000000000
[ 293.602015] x3 : 0000000000000000 x2 : 0000000000000000
[ 293.612624] x1 : 00000000000004a4 x0 : ffffa58a1e0c6b80
[ 293.623028] Call trace:
[ 293.630340] free_msi_irqs+0x19c/0x1b8
[ 293.638849] pci_disable_msix+0x118/0x140
[ 293.647452] pci_free_irq_vectors+0x20/0x38
[ 293.656081] hclgevf_uninit_msi+0x44/0x58 [hclgevf]
[ 293.665309] hclgevf_reset_rebuild+0x1ac/0x2e0 [hclgevf]
[ 293.674866] hclgevf_reset+0x358/0x400 [hclgevf]
[ 293.683545] hclgevf_reset_service_task+0xd0/0x1b0 [hclgevf]
[ 293.693325] hclgevf_service_task+0x4c/0x2e8 [hclgevf]
[ 293.702307] process_one_work+0x1b0/0x448
[ 293.710034] worker_thread+0x54/0x468
[ 293.717331] kthread+0x134/0x138
[ 293.724114] ret_from_fork+0x10/0x18
[ 293.731324] Code: f940b000 b4ffff00 a903e7b8 f90017b6 (d4210000)

This patch fixes the problem by waiting for the VF reset done
while unloading the VF.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 5 +++++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 98332dad804d..25c419d40066 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3010,7 +3010,10 @@ static void hclgevf_uninit_client_instance(struct hnae3_client *client,
 
 	/* un-init roce, if it exists */
 	if (hdev->roce_client) {
+		while (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state))
+			msleep(HCLGEVF_WAIT_RESET_DONE);
 		clear_bit(HCLGEVF_STATE_ROCE_REGISTERED, &hdev->state);
+
 		hdev->roce_client->ops->uninit_instance(&hdev->roce, 0);
 		hdev->roce_client = NULL;
 		hdev->roce.client = NULL;
@@ -3019,6 +3022,8 @@ static void hclgevf_uninit_client_instance(struct hnae3_client *client,
 	/* un-init nic/unic, if this was not called by roce client */
 	if (client->ops->uninit_instance && hdev->nic_client &&
 	    client->type != HNAE3_CLIENT_ROCE) {
+		while (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state))
+			msleep(HCLGEVF_WAIT_RESET_DONE);
 		clear_bit(HCLGEVF_STATE_NIC_REGISTERED, &hdev->state);
 
 		client->ops->uninit_instance(&hdev->nic, 0);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 4bd922b47501..f6f736c0091c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -109,6 +109,8 @@
 #define HCLGEVF_VF_RST_ING		0x07008
 #define HCLGEVF_VF_RST_ING_BIT		BIT(16)
 
+#define HCLGEVF_WAIT_RESET_DONE		100
+
 #define HCLGEVF_RSS_IND_TBL_SIZE		512
 #define HCLGEVF_RSS_SET_BITMAP_MSK	0xffff
 #define HCLGEVF_RSS_KEY_SIZE		40
-- 
2.33.0

