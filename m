Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B8434C25C
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 06:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhC2D7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 23:59:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15030 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhC2D6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 23:58:21 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F7zJH3Cf6zNr02;
        Mon, 29 Mar 2021 11:55:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 11:58:14 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/9] net: hns3: remove the rss_size limitation by vector num
Date:   Mon, 29 Mar 2021 11:57:48 +0800
Message-ID: <1616990273-46426-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
References: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, if user hasn't change channel number, the rss_size
is limited to be no more than the vector number, in order to
keep one vector only being mapped to one queue. But the queue
number of each tc can be different, and one vector also can
be mapped by multiple queues. So remove this limitation.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index aa81b8c..ebb962b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -664,15 +664,6 @@ static void hclge_tm_update_kinfo_rss_size(struct hclge_vport *vport)
 		kinfo->rss_size = kinfo->req_rss_size;
 	} else if (kinfo->rss_size > max_rss_size ||
 		   (!kinfo->req_rss_size && kinfo->rss_size < max_rss_size)) {
-		/* if user not set rss, the rss_size should compare with the
-		 * valid msi numbers to ensure one to one map between tqp and
-		 * irq as default.
-		 */
-		if (!kinfo->req_rss_size)
-			max_rss_size = min_t(u16, max_rss_size,
-					     (hdev->num_nic_msi - 1) /
-					     kinfo->tc_info.num_tc);
-
 		/* Set to the maximum specification value (max_rss_size). */
 		kinfo->rss_size = max_rss_size;
 	}
-- 
2.7.4

