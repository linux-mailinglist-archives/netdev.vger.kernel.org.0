Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945A4106127
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbfKVFxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:53:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727227AbfKVFxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:53:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A51F2072E;
        Fri, 22 Nov 2019 05:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401982;
        bh=F6mI3fpoevkEWv6oQH2GUB/VH+t5TeKzlvJh2NgZyCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNTrk4owZD7VcUY4ublRzzv/VJzd1gnoHNPKAV/lglUF4wPb3rtxBTR8qiGOkbgSe
         pdXKfoFH6N/t+dWjfjs1MD2m1Sq91N/X1r03PNeITTftnPa8OcyTNlobIZaT+15oJF
         rvZ+zn6R6tNszaYjYcm1s0KcUKeWo4vfexas9qEg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 201/219] net: hns3: fix PFC not setting problem for DCB module
Date:   Fri, 22 Nov 2019 00:48:52 -0500
Message-Id: <20191122054911.1750-193-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit d3ad430ac531e65f29c9737f86744c425c9173ef ]

The PFC enabling is based on user priority, currently it is
based on TC, which may cause PFC not setting correctly when pri
to TC mapping is not one to one relation.

This patch adds pfc_en in tm_info to fix it.

Fixes: cacde272dd00 ("net: hns3: Add hclge_dcb module for the support of DCB feature")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c  | 7 ++++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c   | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 92f19384e2585..a75d7c826fc2b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -245,6 +245,9 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	    hdev->flag & HCLGE_FLAG_MQPRIO_ENABLE)
 		return -EINVAL;
 
+	if (pfc->pfc_en == hdev->tm_info.pfc_en)
+		return 0;
+
 	prio_tc = hdev->tm_info.prio_tc;
 	pfc_map = 0;
 
@@ -257,10 +260,8 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 		}
 	}
 
-	if (pfc_map == hdev->tm_info.hw_pfc_map)
-		return 0;
-
 	hdev->tm_info.hw_pfc_map = pfc_map;
+	hdev->tm_info.pfc_en = pfc->pfc_en;
 
 	return hclge_pause_setup_hw(hdev);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 1528fb3fa6be6..260b1e7796908 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -249,6 +249,7 @@ struct hclge_tm_info {
 	struct hclge_tc_info tc_info[HNAE3_MAX_TC];
 	enum hclge_fc_mode fc_mode;
 	u8 hw_pfc_map; /* Allow for packet drop or not on this TC */
+	u8 pfc_en;	/* PFC enabled or not for user priority */
 };
 
 struct hclge_comm_stats_str {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 11e9259ca0407..daf364e421b73 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1162,7 +1162,7 @@ static int hclge_pfc_setup_hw(struct hclge_dev *hdev)
 				HCLGE_RX_MAC_PAUSE_EN_MSK;
 
 	return hclge_pfc_pause_en_cfg(hdev, enable_bitmap,
-				      hdev->tm_info.hw_pfc_map);
+				      hdev->tm_info.pfc_en);
 }
 
 /* Each Tc has a 1024 queue sets to backpress, it divides to
-- 
2.20.1

