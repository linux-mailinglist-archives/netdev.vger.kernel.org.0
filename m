Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E33326C1B
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 08:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhB0HZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 02:25:24 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12653 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhB0HZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 02:25:07 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DndJT1SGJzlPr5;
        Sat, 27 Feb 2021 15:22:17 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Feb 2021 15:24:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RESEND net 3/3] net: hns3: fix bug when calculating the TCAM table info
Date:   Sat, 27 Feb 2021 15:24:53 +0800
Message-ID: <1614410693-8107-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614410693-8107-1-git-send-email-tanhuazhong@huawei.com>
References: <1614410693-8107-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

The function hclge_fd_convert_tuple() is used to convert tuples
and tuples mask to TCAM x and y.  But it misuses the source mac
as source mac mask when convert INNER_SRC_MAC, which may cause
the flow director rule works unexpectedly. So fix it.

Fixes: 117328680288 ("net: hns3: Add input key and action config support for flow director")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 932cfd1..e3f81c7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5245,9 +5245,9 @@ static bool hclge_fd_convert_tuple(u32 tuple_bit, u8 *key_x, u8 *key_y,
 	case BIT(INNER_SRC_MAC):
 		for (i = 0; i < ETH_ALEN; i++) {
 			calc_x(key_x[ETH_ALEN - 1 - i], rule->tuples.src_mac[i],
-			       rule->tuples.src_mac[i]);
+			       rule->tuples_mask.src_mac[i]);
 			calc_y(key_y[ETH_ALEN - 1 - i], rule->tuples.src_mac[i],
-			       rule->tuples.src_mac[i]);
+			       rule->tuples_mask.src_mac[i]);
 		}
 
 		return true;
-- 
2.7.4

