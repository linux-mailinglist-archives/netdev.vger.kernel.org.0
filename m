Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7436469648
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388262AbfGOPDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 11:03:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731342AbfGOOJG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:09:06 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87E1221537;
        Mon, 15 Jul 2019 14:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199745;
        bh=CFGl4+O3ZTYIhz4Kf84ckCwmTrKaCP86jowfIG1yew8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6j20K+BmowJWQ/lGPGsKQsntcsRHfkZCrIh8m49pikCq5QTSrD26RrK5I5esGgI2
         E8M/hyANxcFKrcMaw7Sfge1G0h3YkrXXvDp3wG9jPrEcTa2Ae6KCfdqdFz9oZeVVWb
         oHrXD3MhiM8X5+N5GB8vA0C+CZYoxeI7ELfu7tnI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 092/219] net: hns3: fix for dereferencing before null checking
Date:   Mon, 15 Jul 2019 10:01:33 -0400
Message-Id: <20190715140341.6443-92-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 757188005f905664b0186b88cf26a7e844190a63 ]

The netdev is dereferenced before null checking in the function
hns3_setup_tc.

This patch moves the dereferencing after the null checking.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index cac17152157d..6afdd376bc03 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1497,12 +1497,12 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 static int hns3_setup_tc(struct net_device *netdev, void *type_data)
 {
 	struct tc_mqprio_qopt_offload *mqprio_qopt = type_data;
-	struct hnae3_handle *h = hns3_get_handle(netdev);
-	struct hnae3_knic_private_info *kinfo = &h->kinfo;
 	u8 *prio_tc = mqprio_qopt->qopt.prio_tc_map;
+	struct hnae3_knic_private_info *kinfo;
 	u8 tc = mqprio_qopt->qopt.num_tc;
 	u16 mode = mqprio_qopt->mode;
 	u8 hw = mqprio_qopt->qopt.hw;
+	struct hnae3_handle *h;
 
 	if (!((hw == TC_MQPRIO_HW_OFFLOAD_TCS &&
 	       mode == TC_MQPRIO_MODE_CHANNEL) || (!hw && tc == 0)))
@@ -1514,6 +1514,9 @@ static int hns3_setup_tc(struct net_device *netdev, void *type_data)
 	if (!netdev)
 		return -EINVAL;
 
+	h = hns3_get_handle(netdev);
+	kinfo = &h->kinfo;
+
 	return (kinfo->dcb_ops && kinfo->dcb_ops->setup_tc) ?
 		kinfo->dcb_ops->setup_tc(h, tc, prio_tc) : -EOPNOTSUPP;
 }
-- 
2.20.1

