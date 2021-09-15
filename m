Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8DA40C6DB
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 15:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbhION5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 09:57:52 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19984 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234561AbhION5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 09:57:39 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H8hV11Pg0zYlLt;
        Wed, 15 Sep 2021 21:52:09 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 21:56:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 21:56:15 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 3/6] net: hns3: fix misuse vf id and vport id in some logs
Date:   Wed, 15 Sep 2021 21:52:08 +0800
Message-ID: <20210915135211.9129-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915135211.9129-1-huangguangbin2@huawei.com>
References: <20210915135211.9129-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

vport_id include PF and VFs, vport_id = 0 means PF, other values mean VFs.
So the actual vf id is equal to vport_id minus 1.

Some VF print logs are actually vport, and logs of vf id actually use
vport id, so this patch fixes them.

Fixes: ac887be5b0fe ("net: hns3: change print level of RAS error log from warning to error")
Fixes: adcf738b804b ("net: hns3: cleanup some print format warning")
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  8 ++++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 10 ++++++----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  2 +-
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 718c16d686fa..bb9b026ae88e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -2445,12 +2445,12 @@ static void hclge_handle_over_8bd_err(struct hclge_dev *hdev,
 		return;
 	}
 
-	dev_err(dev, "PPU_PF_ABNORMAL_INT_ST over_8bd_no_fe found, vf_id(%u), queue_id(%u)\n",
+	dev_err(dev, "PPU_PF_ABNORMAL_INT_ST over_8bd_no_fe found, vport(%u), queue_id(%u)\n",
 		vf_id, q_id);
 
 	if (vf_id) {
 		if (vf_id >= hdev->num_alloc_vport) {
-			dev_err(dev, "invalid vf id(%u)\n", vf_id);
+			dev_err(dev, "invalid vport(%u)\n", vf_id);
 			return;
 		}
 
@@ -2463,8 +2463,8 @@ static void hclge_handle_over_8bd_err(struct hclge_dev *hdev,
 
 		ret = hclge_inform_reset_assert_to_vf(&hdev->vport[vf_id]);
 		if (ret)
-			dev_err(dev, "inform reset to vf(%u) failed %d!\n",
-				hdev->vport->vport_id, ret);
+			dev_err(dev, "inform reset to vport(%u) failed %d!\n",
+				vf_id, ret);
 	} else {
 		set_bit(HNAE3_FUNC_RESET, reset_requests);
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c0f25ea043b0..afc88a41a89c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3661,7 +3661,8 @@ static int hclge_set_all_vf_rst(struct hclge_dev *hdev, bool reset)
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
 				"set vf(%u) rst failed %d!\n",
-				vport->vport_id, ret);
+				vport->vport_id - HCLGE_VF_VPORT_START_NUM,
+				ret);
 			return ret;
 		}
 
@@ -3676,7 +3677,8 @@ static int hclge_set_all_vf_rst(struct hclge_dev *hdev, bool reset)
 		if (ret)
 			dev_warn(&hdev->pdev->dev,
 				 "inform reset to vf(%u) failed %d!\n",
-				 vport->vport_id, ret);
+				 vport->vport_id - HCLGE_VF_VPORT_START_NUM,
+				 ret);
 	}
 
 	return 0;
@@ -11467,11 +11469,11 @@ static void hclge_clear_resetting_state(struct hclge_dev *hdev)
 		struct hclge_vport *vport = &hdev->vport[i];
 		int ret;
 
-		 /* Send cmd to clear VF's FUNC_RST_ING */
+		 /* Send cmd to clear vport's FUNC_RST_ING */
 		ret = hclge_set_vf_rst(hdev, vport->vport_id, false);
 		if (ret)
 			dev_warn(&hdev->pdev->dev,
-				 "clear vf(%u) rst failed %d!\n",
+				 "clear vport(%u) rst failed %d!\n",
 				 vport->vport_id, ret);
 	}
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 2ce5302c5956..07aa6ada4fdb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -566,7 +566,7 @@ static int hclge_reset_vf(struct hclge_vport *vport)
 	struct hclge_dev *hdev = vport->back;
 
 	dev_warn(&hdev->pdev->dev, "PF received VF reset request from VF %u!",
-		 vport->vport_id);
+		 vport->vport_id - HCLGE_VF_VPORT_START_NUM);
 
 	return hclge_func_reset_cmd(hdev, vport->vport_id);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 78d5bf1ea561..44618cc4cca1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -581,7 +581,7 @@ int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate)
 		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
-				"vf%u, qs%u failed to set tx_rate:%d, ret=%d\n",
+				"vport%u, qs%u failed to set tx_rate:%d, ret=%d\n",
 				vport->vport_id, shap_cfg_cmd->qs_id,
 				max_tx_rate, ret);
 			return ret;
-- 
2.33.0

