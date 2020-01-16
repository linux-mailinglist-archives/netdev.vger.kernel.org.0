Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6809713F77A
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394392AbgAPTMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:12:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387645AbgAPRAD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8839E2467E;
        Thu, 16 Jan 2020 17:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194002;
        bh=1Fec6hCpa53F8ruqlYEmIEx/ZjvkbUKr0KeKcqP+Fu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SxhkU2UJMNPexjTmPOTh6ljNtrlR+bnDOLzJItraAi9fl4FSfiiSfxzjHV+LAjika
         E2CnBlJo3lexncx2aRKF8KV+u+GMCfXU65nCQ4T1Ajn4FYQ2e0dtFUwMLg0c5FkWl+
         XBTnYDisv3NBeJnirEJrpLUkqAS+ZitgfZNq0MSw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 129/671] net: hns3: fix bug of ethtool_ops.get_channels for VF
Date:   Thu, 16 Jan 2020 11:50:38 -0500
Message-Id: <20200116165940.10720-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit 8be7362186bd5ccb5f6f72be49751ad2778e2636 ]

The current code returns the number of all queues that can be used and
the number of queues that have been allocated, which is incorrect.
What should be returned is the number of queues allocated for each enabled
TC and the number of queues that can be allocated.

This patch fixes it.

Fixes: 849e46077689 ("net: hns3: add ethtool_ops.get_channels support for VF")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 67db19709dea..fd5375b5991b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1957,7 +1957,8 @@ static u32 hclgevf_get_max_channels(struct hclgevf_dev *hdev)
 	struct hnae3_handle *nic = &hdev->nic;
 	struct hnae3_knic_private_info *kinfo = &nic->kinfo;
 
-	return min_t(u32, hdev->rss_size_max * kinfo->num_tc, hdev->num_tqps);
+	return min_t(u32, hdev->rss_size_max,
+		     hdev->num_tqps / kinfo->num_tc);
 }
 
 /**
@@ -1978,7 +1979,7 @@ static void hclgevf_get_channels(struct hnae3_handle *handle,
 	ch->max_combined = hclgevf_get_max_channels(hdev);
 	ch->other_count = 0;
 	ch->max_other = 0;
-	ch->combined_count = hdev->num_tqps;
+	ch->combined_count = handle->kinfo.rss_size;
 }
 
 static void hclgevf_get_tqps_and_rss_info(struct hnae3_handle *handle,
-- 
2.20.1

