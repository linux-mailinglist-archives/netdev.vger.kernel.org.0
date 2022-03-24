Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6034E63CC
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 14:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350376AbiCXNCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 09:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350340AbiCXNB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 09:01:56 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0A39026F;
        Thu, 24 Mar 2022 06:00:22 -0700 (PDT)
Received: from kwepemi100012.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KPQJ45xC4zCrGv;
        Thu, 24 Mar 2022 20:58:12 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100012.china.huawei.com (7.221.188.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 21:00:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 21:00:20 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 4/4] net: hns3: refine the process when PF set VF VLAN
Date:   Thu, 24 Mar 2022 20:54:50 +0800
Message-ID: <20220324125450.56417-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220324125450.56417-1-huangguangbin2@huawei.com>
References: <20220324125450.56417-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, when PF set VF VLAN, it sends notify mailbox to VF
if VF alive. VF stop its traffic, and send request mailbox
to PF, then PF updates VF VLAN. It's a bit complex. If VF is
killed before sending request, PF will not set VF VLAN without
any log.

This patch refines the process, PF can set VF VLAN direclty,
and then notify the VF. If VF is resetting at that time, the
notify may be dropped, so VF should query it after reset finished.

Fixes: 92f11ea177cd ("net: hns3: fix set port based VLAN issue for VF")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c         | 18 +++++++++++++-----
 .../hisilicon/hns3/hns3vf/hclgevf_main.c       |  5 +++++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9655a7d2c200..1fa13ae8c651 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8984,11 +8984,16 @@ static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
 
 	ether_addr_copy(vport->vf_info.mac, mac_addr);
 
+	/* there is a timewindow for PF to know VF unalive, it may
+	 * cause send mailbox fail, but it doesn't matter, VF will
+	 * query it when reinit.
+	 */
 	if (test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state)) {
 		dev_info(&hdev->pdev->dev,
 			 "MAC of VF %d has been set to %s, and it will be reinitialized!\n",
 			 vf, format_mac_addr);
-		return hclge_inform_reset_assert_to_vf(vport);
+		(void)hclge_inform_reset_assert_to_vf(vport);
+		return 0;
 	}
 
 	dev_info(&hdev->pdev->dev, "MAC of VF %d has been set to %s\n",
@@ -10241,14 +10246,17 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 		return ret;
 	}
 
-	/* for DEVICE_VERSION_V3, vf doesn't need to know about the port based
+	/* there is a timewindow for PF to know VF unalive, it may
+	 * cause send mailbox fail, but it doesn't matter, VF will
+	 * query it when reinit.
+	 * for DEVICE_VERSION_V3, vf doesn't need to know about the port based
 	 * VLAN state.
 	 */
 	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V3 &&
 	    test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
-		hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
-						  vport->vport_id, state,
-						  &vlan_info);
+		(void)hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
+							vport->vport_id,
+							state, &vlan_info);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 21442a9bb996..90c6197d9374 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2855,6 +2855,11 @@ static int hclgevf_reset_hdev(struct hclgevf_dev *hdev)
 		return ret;
 	}
 
+	/* get current port based vlan state from PF */
+	ret = hclgevf_get_port_base_vlan_filter_state(hdev);
+	if (ret)
+		return ret;
+
 	set_bit(HCLGEVF_STATE_PROMISC_CHANGED, &hdev->state);
 
 	hclgevf_init_rxd_adv_layout(hdev);
-- 
2.33.0

