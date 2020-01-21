Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C67C2143885
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgAUImb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:42:31 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10114 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726920AbgAUImb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 03:42:31 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CA9BF432EBA6D1B25098;
        Tue, 21 Jan 2020 16:42:29 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Tue, 21 Jan 2020 16:42:20 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/9] net: hns3: limit the error logging in the hns3_clean_tx_ring()
Date:   Tue, 21 Jan 2020 16:42:05 +0800
Message-ID: <1579596133-54842-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
References: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

The error log printed by netdev_err() in the hns3_clean_tx_ring()
may spam the kernel log.

This patch uses hns3_rl_err() to ratelimit the error log in the
hns3_clean_tx_ring().

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 914a763..f579028 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2540,8 +2540,8 @@ void hns3_clean_tx_ring(struct hns3_enet_ring *ring)
 	rmb(); /* Make sure head is ready before touch any data */
 
 	if (unlikely(!is_valid_clean_head(ring, head))) {
-		netdev_err(netdev, "wrong head (%d, %d-%d)\n", head,
-			   ring->next_to_use, ring->next_to_clean);
+		hns3_rl_err(netdev, "wrong head (%d, %d-%d)\n", head,
+			    ring->next_to_use, ring->next_to_clean);
 
 		u64_stats_update_begin(&ring->syncp);
 		ring->stats.io_err_cnt++;
-- 
2.7.4

