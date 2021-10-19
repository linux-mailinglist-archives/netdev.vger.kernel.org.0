Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E323643384F
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbhJSOXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:23:18 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13956 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbhJSOXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 10:23:08 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HYbTR0Z1xzZcFJ;
        Tue, 19 Oct 2021 22:19:07 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:52 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:51 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 4/8] net: hns3: fix the max tx size according to user manual
Date:   Tue, 19 Oct 2021 22:16:31 +0800
Message-ID: <20211019141635.43695-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211019141635.43695-1-huangguangbin2@huawei.com>
References: <20211019141635.43695-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Currently the max tx size supported by the hw is calculated by
using the max BD num supported by the hw. According to the hw
user manual, the max tx size is fixed value for both non-TSO and
TSO skb.

This patch updates the max tx size according to the manual.

Fixes: 8ae10cfb5089("net: hns3: support tx-scatter-gather-fraglist feature")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 7 ++-----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 6 ++----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 468b8f07bf47..ea89772e8952 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1847,7 +1847,6 @@ void hns3_shinfo_pack(struct skb_shared_info *shinfo, __u32 *size)
 
 static int hns3_skb_linearize(struct hns3_enet_ring *ring,
 			      struct sk_buff *skb,
-			      u8 max_non_tso_bd_num,
 			      unsigned int bd_num)
 {
 	/* 'bd_num == UINT_MAX' means the skb' fraglist has a
@@ -1864,8 +1863,7 @@ static int hns3_skb_linearize(struct hns3_enet_ring *ring,
 	 * will not help.
 	 */
 	if (skb->len > HNS3_MAX_TSO_SIZE ||
-	    (!skb_is_gso(skb) && skb->len >
-	     HNS3_MAX_NON_TSO_SIZE(max_non_tso_bd_num))) {
+	    (!skb_is_gso(skb) && skb->len > HNS3_MAX_NON_TSO_SIZE)) {
 		u64_stats_update_begin(&ring->syncp);
 		ring->stats.hw_limitation++;
 		u64_stats_update_end(&ring->syncp);
@@ -1900,8 +1898,7 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 			goto out;
 		}
 
-		if (hns3_skb_linearize(ring, skb, max_non_tso_bd_num,
-				       bd_num))
+		if (hns3_skb_linearize(ring, skb, bd_num))
 			return -ENOMEM;
 
 		bd_num = hns3_tx_bd_count(skb->len);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 6162d9f88e37..9d9be3665bb1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -186,11 +186,9 @@ enum hns3_nic_state {
 
 #define HNS3_MAX_BD_SIZE			65535
 #define HNS3_MAX_TSO_BD_NUM			63U
-#define HNS3_MAX_TSO_SIZE \
-	(HNS3_MAX_BD_SIZE * HNS3_MAX_TSO_BD_NUM)
+#define HNS3_MAX_TSO_SIZE			1048576U
+#define HNS3_MAX_NON_TSO_SIZE			9728U
 
-#define HNS3_MAX_NON_TSO_SIZE(max_non_tso_bd_num) \
-	(HNS3_MAX_BD_SIZE * (max_non_tso_bd_num))
 
 #define HNS3_VECTOR_GL0_OFFSET			0x100
 #define HNS3_VECTOR_GL1_OFFSET			0x200
-- 
2.33.0

