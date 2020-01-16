Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA5B13E31B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgAPQ75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:59:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732814AbgAPQ7z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:59:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCB2824673;
        Thu, 16 Jan 2020 16:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193995;
        bh=U8xF5rETI1YMWglzEq/+RoBuIlqMzvNVf2Rjjzx3z5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WewXDdxbK61rdSx6sPmYXuvZV4625iVVJ+inWqPEON8Gw5qi+ltwaATbhlg7Oge2/
         agiGpTTTg5ukZZQQ/eLMRyK4sIkNpFcK/KzlfVMB5JZfhEJgSO3UdLmxTQEX3JRVVy
         87R4rysTJtYbJiDeBnODpionj3MpyRKuslLvGEpE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 124/671] net: hns3: fix wrong combined count returned by ethtool -l
Date:   Thu, 16 Jan 2020 11:50:33 -0500
Message-Id: <20200116165940.10720-7-sashal@kernel.org>
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

[ Upstream commit c3b9c50d1567aa12be4448fe85b09626eba2499c ]

The current code returns the number of all queues that can be used and
the number of queues that have been allocated, which is incorrect.
What should be returned is the number of queues allocated for each enabled
TC and the number of queues that can be allocated.

This patch fixes it.

Fixes: 482d2e9c1cc7 ("net: hns3: add support to query tqps number")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f8cc8d1f0b20..4b9f898a1620 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5922,18 +5922,17 @@ static u32 hclge_get_max_channels(struct hnae3_handle *handle)
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	return min_t(u32, hdev->rss_size_max * kinfo->num_tc, hdev->num_tqps);
+	return min_t(u32, hdev->rss_size_max,
+		     vport->alloc_tqps / kinfo->num_tc);
 }
 
 static void hclge_get_channels(struct hnae3_handle *handle,
 			       struct ethtool_channels *ch)
 {
-	struct hclge_vport *vport = hclge_get_vport(handle);
-
 	ch->max_combined = hclge_get_max_channels(handle);
 	ch->other_count = 1;
 	ch->max_other = 1;
-	ch->combined_count = vport->alloc_tqps;
+	ch->combined_count = handle->kinfo.rss_size;
 }
 
 static void hclge_get_tqps_and_rss_info(struct hnae3_handle *handle,
-- 
2.20.1

