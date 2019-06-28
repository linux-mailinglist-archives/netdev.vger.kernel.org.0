Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67595997F
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfF1Lww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:52:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56896 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726934AbfF1LwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 07:52:15 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 178D43636D5F6DF16C35;
        Fri, 28 Jun 2019 19:52:11 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 28 Jun 2019 19:52:01 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 09/12] net: hns3: fix a statistics issue about l3l4 checksum error
Date:   Fri, 28 Jun 2019 19:50:15 +0800
Message-ID: <1561722618-12168-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
References: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

The frame column is based on rx_crc_errors and rx_frame_errors. So
l3l4 checksum error should not be counted by rx_crc_errors. Instead,
l3l4 checksum error should be counted in ifconfig error column.

Fixes: d3ec4ef66937 ("net: hns3: refactor the statistics updating for netdev")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a5d46f0..37f28bd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1494,8 +1494,8 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 			rx_drop += ring->stats.l2_err;
 			rx_errors += ring->stats.non_vld_descs;
 			rx_errors += ring->stats.l2_err;
+			rx_errors += ring->stats.l3l4_csum_err;
 			rx_crc_errors += ring->stats.l2_err;
-			rx_crc_errors += ring->stats.l3l4_csum_err;
 			rx_multicast += ring->stats.rx_multicast;
 			rx_length_errors += ring->stats.err_pkt_len;
 		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
-- 
2.7.4

