Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCEB13F37D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390275AbgAPRLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:11:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390253AbgAPRLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 371BB24684;
        Thu, 16 Jan 2020 17:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194691;
        bh=KOLbhxaodayYM2csLNYym7rLN3GPpuwOd0/ucyao8HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BlamzF+Ov2eCrIoiyVoTwnOMOHBILYpPwD91sKefsMmF6lHjtzElOnZSbDeeHgzjw
         fhYa2/n5ymlJHnSbXdzEXTczsbnLdaqFjZSd+HVV4lowH1xxdF+knZC+0qSYeb/907
         nT0IKBtWL0DbtUKW7lHcKI3A4KjjYoXeFezGW6bA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 533/671] net: hns3: fix error VF index when setting VLAN offload
Date:   Thu, 16 Jan 2020 12:02:51 -0500
Message-Id: <20200116170509.12787-270-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit d9c0f2756a33833b2653f7a3612814fa5f52a568 ]

In original codes, the VF index used incorrectly in function
hclge_set_vlan_rx_offload_cfg() and hclge_set_vlan_rx_offload_cfg().
When VF id is greater than 8, for example 9, it will set the
same bit with VF id 1.

This patch fixes it by using  vport->vport_id % HCLGE_VF_NUM_PER_CMD /
HCLGE_VF_NUM_PER_BYTE as the array index, instead of vport->vport_id /
HCLGE_VF_NUM_PER_CMD.

Fixes: 052ece6dc19c ("net: hns3: add ethtool related offload command")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4b9f898a1620..d575dd9a329d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4833,6 +4833,7 @@ static int hclge_set_vlan_tx_offload_cfg(struct hclge_vport *vport)
 	struct hclge_vport_vtag_tx_cfg_cmd *req;
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_desc desc;
+	u16 bmap_index;
 	int status;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_VLAN_PORT_TX_CFG, false);
@@ -4855,8 +4856,10 @@ static int hclge_set_vlan_tx_offload_cfg(struct hclge_vport *vport)
 	hnae3_set_bit(req->vport_vlan_cfg, HCLGE_CFG_NIC_ROCE_SEL_B, 0);
 
 	req->vf_offset = vport->vport_id / HCLGE_VF_NUM_PER_CMD;
-	req->vf_bitmap[req->vf_offset] =
-		1 << (vport->vport_id % HCLGE_VF_NUM_PER_BYTE);
+	bmap_index = vport->vport_id % HCLGE_VF_NUM_PER_CMD /
+			HCLGE_VF_NUM_PER_BYTE;
+	req->vf_bitmap[bmap_index] =
+		1U << (vport->vport_id % HCLGE_VF_NUM_PER_BYTE);
 
 	status = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (status)
@@ -4873,6 +4876,7 @@ static int hclge_set_vlan_rx_offload_cfg(struct hclge_vport *vport)
 	struct hclge_vport_vtag_rx_cfg_cmd *req;
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_desc desc;
+	u16 bmap_index;
 	int status;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_VLAN_PORT_RX_CFG, false);
@@ -4888,8 +4892,10 @@ static int hclge_set_vlan_rx_offload_cfg(struct hclge_vport *vport)
 		      vcfg->vlan2_vlan_prionly ? 1 : 0);
 
 	req->vf_offset = vport->vport_id / HCLGE_VF_NUM_PER_CMD;
-	req->vf_bitmap[req->vf_offset] =
-		1 << (vport->vport_id % HCLGE_VF_NUM_PER_BYTE);
+	bmap_index = vport->vport_id % HCLGE_VF_NUM_PER_CMD /
+			HCLGE_VF_NUM_PER_BYTE;
+	req->vf_bitmap[bmap_index] =
+		1U << (vport->vport_id % HCLGE_VF_NUM_PER_BYTE);
 
 	status = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (status)
-- 
2.20.1

