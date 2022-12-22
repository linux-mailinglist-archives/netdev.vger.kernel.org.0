Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDAB653C3C
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 07:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbiLVGnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 01:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiLVGns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 01:43:48 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7A6F5B5
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 22:43:46 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Nd0yv5r5PzqTK3;
        Thu, 22 Dec 2022 14:39:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 22 Dec 2022 14:43:45 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <huangguangbin2@huawei.com>,
        <wangjie125@huawei.com>, <shenjian15@huawei.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net 3/3] net: hns3: fix VF promisc mode not update when mac table full
Date:   Thu, 22 Dec 2022 14:43:43 +0800
Message-ID: <20221222064343.61537-4-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20221222064343.61537-1-lanhao@huawei.com>
References: <20221222064343.61537-1-lanhao@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, it missed set HCLGE_VPORT_STATE_PROMISC_CHANGE
flag for VF when vport->overflow_promisc_flags changed.
So the VF won't check whether to update promisc mode in
this case. So add it.

Fixes: 1e6e76101fd9 ("net: hns3: configure promisc mode for VF asynchronously")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 75 +++++++++++--------
 1 file changed, 43 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4e54f91f7a6c..6c2742f59c77 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12754,60 +12754,71 @@ static int hclge_gro_en(struct hnae3_handle *handle, bool enable)
 	return ret;
 }
 
-static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
+static int hclge_sync_vport_promisc_mode(struct hclge_vport *vport)
 {
-	struct hclge_vport *vport = &hdev->vport[0];
 	struct hnae3_handle *handle = &vport->nic;
+	struct hclge_dev *hdev = vport->back;
+	bool uc_en = false;
+	bool mc_en = false;
 	u8 tmp_flags;
+	bool bc_en;
 	int ret;
-	u16 i;
 
 	if (vport->last_promisc_flags != vport->overflow_promisc_flags) {
 		set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
 		vport->last_promisc_flags = vport->overflow_promisc_flags;
 	}
 
-	if (test_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state)) {
+	if (!test_and_clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
+				&vport->state))
+		return 0;
+
+	/* for PF */
+	if (!vport->vport_id) {
 		tmp_flags = handle->netdev_flags | vport->last_promisc_flags;
 		ret = hclge_set_promisc_mode(handle, tmp_flags & HNAE3_UPE,
 					     tmp_flags & HNAE3_MPE);
-		if (!ret) {
-			clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
-				  &vport->state);
+		if (!ret)
 			set_bit(HCLGE_VPORT_STATE_VLAN_FLTR_CHANGE,
 				&vport->state);
-		}
+		else
+			set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
+				&vport->state);
+		return ret;
 	}
 
-	for (i = 1; i < hdev->num_alloc_vport; i++) {
-		bool uc_en = false;
-		bool mc_en = false;
-		bool bc_en;
+	/* for VF */
+	if (vport->vf_info.trusted) {
+		uc_en = vport->vf_info.request_uc_en > 0 ||
+			vport->overflow_promisc_flags & HNAE3_OVERFLOW_UPE;
+		mc_en = vport->vf_info.request_mc_en > 0 ||
+			vport->overflow_promisc_flags & HNAE3_OVERFLOW_MPE;
+	}
+	bc_en = vport->vf_info.request_bc_en > 0;
 
-		vport = &hdev->vport[i];
+	ret = hclge_cmd_set_promisc_mode(hdev, vport->vport_id, uc_en,
+					 mc_en, bc_en);
+	if (ret) {
+		set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
+		return ret;
+	}
+	hclge_set_vport_vlan_fltr_change(vport);
 
-		if (!test_and_clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
-					&vport->state))
-			continue;
+	return 0;
+}
 
-		if (vport->vf_info.trusted) {
-			uc_en = vport->vf_info.request_uc_en > 0 ||
-				vport->overflow_promisc_flags &
-				HNAE3_OVERFLOW_UPE;
-			mc_en = vport->vf_info.request_mc_en > 0 ||
-				vport->overflow_promisc_flags &
-				HNAE3_OVERFLOW_MPE;
-		}
-		bc_en = vport->vf_info.request_bc_en > 0;
+static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
+{
+	struct hclge_vport *vport;
+	int ret;
+	u16 i;
 
-		ret = hclge_cmd_set_promisc_mode(hdev, vport->vport_id, uc_en,
-						 mc_en, bc_en);
-		if (ret) {
-			set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
-				&vport->state);
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		vport = &hdev->vport[i];
+
+		ret = hclge_sync_vport_promisc_mode(vport);
+		if (ret)
 			return;
-		}
-		hclge_set_vport_vlan_fltr_change(vport);
 	}
 }
 
-- 
2.30.0

