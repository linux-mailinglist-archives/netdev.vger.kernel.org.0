Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0342E59974
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfF1Lwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:52:31 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56898 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726942AbfF1LwR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 07:52:17 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1B975946C79220174B22;
        Fri, 28 Jun 2019 19:52:11 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 28 Jun 2019 19:52:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 11/12] net: hns3: remove RXD_VLD check in hns3_handle_bdinfo
Date:   Fri, 28 Jun 2019 19:50:17 +0800
Message-ID: <1561722618-12168-12-git-send-email-tanhuazhong@huawei.com>
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

From: Yunsheng Lin <linyunsheng@huawei.com>

The HNS3_RXD_VLD_B bit has already been checked in hns3_add_frag
or hns3_handle_rx_bd before calling hns3_handle_bdinfo, so when
hns3_handle_bdinfo is called, the HNS3_RXD_VLD_B bit is always
set, which makes the checking in hns3_handle_bdinfo unnecessary.

This patch removes the RXD_VLD_B checking in hns3_handle_bdinfo.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 10 ----------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  1 -
 3 files changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 37f28bd..ab5a339 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1490,9 +1490,7 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 			start = u64_stats_fetch_begin_irq(&ring->syncp);
 			rx_bytes += ring->stats.rx_bytes;
 			rx_pkts += ring->stats.rx_pkts;
-			rx_drop += ring->stats.non_vld_descs;
 			rx_drop += ring->stats.l2_err;
-			rx_errors += ring->stats.non_vld_descs;
 			rx_errors += ring->stats.l2_err;
 			rx_errors += ring->stats.l3l4_csum_err;
 			rx_crc_errors += ring->stats.l2_err;
@@ -2769,14 +2767,6 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 					       vlan_tag);
 	}
 
-	if (unlikely(!(bd_base_info & BIT(HNS3_RXD_VLD_B)))) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.non_vld_descs++;
-		u64_stats_update_end(&ring->syncp);
-
-		return -EINVAL;
-	}
-
 	if (unlikely(!desc->rx.pkt_len || (l234info & (BIT(HNS3_RXD_TRUNCAT_B) |
 				  BIT(HNS3_RXD_L2E_B))))) {
 		u64_stats_update_begin(&ring->syncp);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index dd00640..a2b73d6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -384,7 +384,6 @@ struct ring_stats {
 			u64 rx_err_cnt;
 			u64 reuse_pg_cnt;
 			u64 err_pkt_len;
-			u64 non_vld_descs;
 			u64 err_bd_num;
 			u64 l2_err;
 			u64 l3l4_csum_err;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 16034af..5bff98a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -44,7 +44,6 @@ static const struct hns3_stats hns3_rxq_stats[] = {
 	HNS3_TQP_STAT("errors", rx_err_cnt),
 	HNS3_TQP_STAT("reuse_pg_cnt", reuse_pg_cnt),
 	HNS3_TQP_STAT("err_pkt_len", err_pkt_len),
-	HNS3_TQP_STAT("non_vld_descs", non_vld_descs),
 	HNS3_TQP_STAT("err_bd_num", err_bd_num),
 	HNS3_TQP_STAT("l2_err", l2_err),
 	HNS3_TQP_STAT("l3l4_csum_err", l3l4_csum_err),
-- 
2.7.4

