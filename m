Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415B638288
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 04:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbfFGCF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 22:05:27 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58478 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728171AbfFGCFX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 22:05:23 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EAE5F6BA527E71A03347;
        Fri,  7 Jun 2019 10:05:17 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 7 Jun 2019 10:05:09 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 05/12] net: hns3: refactor hns3_get_new_int_gl function
Date:   Fri, 7 Jun 2019 10:03:06 +0800
Message-ID: <1559872993-14507-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559872993-14507-1-git-send-email-tanhuazhong@huawei.com>
References: <1559872993-14507-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

This patch adds a new hns3_get_new_flow_lvl function to calculate
the packet flow level, which is used to decide the interrupt
coalescence parameter, in order to make the flow level calculation
code more readable and make the future calculation ajdustment easier.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 77 +++++++++++++++----------
 1 file changed, 45 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 969d4c1..0ef4470 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2938,36 +2938,20 @@ int hns3_clean_rx_ring(
 	return recv_pkts;
 }
 
-static bool hns3_get_new_int_gl(struct hns3_enet_ring_group *ring_group)
+static bool hns3_get_new_flow_lvl(struct hns3_enet_ring_group *ring_group)
 {
-	struct hns3_enet_tqp_vector *tqp_vector =
-					ring_group->ring->tqp_vector;
+#define HNS3_RX_LOW_BYTE_RATE 10000
+#define HNS3_RX_MID_BYTE_RATE 20000
+#define HNS3_RX_ULTRA_PACKET_RATE 40
+
 	enum hns3_flow_level_range new_flow_level;
-	int packets_per_msecs;
-	int bytes_per_msecs;
+	struct hns3_enet_tqp_vector *tqp_vector;
+	int packets_per_msecs, bytes_per_msecs;
 	u32 time_passed_ms;
-	u16 new_int_gl;
-
-	if (!tqp_vector->last_jiffies)
-		return false;
-
-	if (ring_group->total_packets == 0) {
-		ring_group->coal.int_gl = HNS3_INT_GL_50K;
-		ring_group->coal.flow_level = HNS3_FLOW_LOW;
-		return true;
-	}
 
-	/* Simple throttlerate management
-	 * 0-10MB/s   lower     (50000 ints/s)
-	 * 10-20MB/s   middle    (20000 ints/s)
-	 * 20-1249MB/s high      (18000 ints/s)
-	 * > 40000pps  ultra     (8000 ints/s)
-	 */
-	new_flow_level = ring_group->coal.flow_level;
-	new_int_gl = ring_group->coal.int_gl;
+	tqp_vector = ring_group->ring->tqp_vector;
 	time_passed_ms =
 		jiffies_to_msecs(jiffies - tqp_vector->last_jiffies);
-
 	if (!time_passed_ms)
 		return false;
 
@@ -2977,9 +2961,14 @@ static bool hns3_get_new_int_gl(struct hns3_enet_ring_group *ring_group)
 	do_div(ring_group->total_bytes, time_passed_ms);
 	bytes_per_msecs = ring_group->total_bytes;
 
-#define HNS3_RX_LOW_BYTE_RATE 10000
-#define HNS3_RX_MID_BYTE_RATE 20000
+	new_flow_level = ring_group->coal.flow_level;
 
+	/* Simple throttlerate management
+	 * 0-10MB/s   lower     (50000 ints/s)
+	 * 10-20MB/s   middle    (20000 ints/s)
+	 * 20-1249MB/s high      (18000 ints/s)
+	 * > 40000pps  ultra     (8000 ints/s)
+	 */
 	switch (new_flow_level) {
 	case HNS3_FLOW_LOW:
 		if (bytes_per_msecs > HNS3_RX_LOW_BYTE_RATE)
@@ -2999,13 +2988,40 @@ static bool hns3_get_new_int_gl(struct hns3_enet_ring_group *ring_group)
 		break;
 	}
 
-#define HNS3_RX_ULTRA_PACKET_RATE 40
-
 	if (packets_per_msecs > HNS3_RX_ULTRA_PACKET_RATE &&
 	    &tqp_vector->rx_group == ring_group)
 		new_flow_level = HNS3_FLOW_ULTRA;
 
-	switch (new_flow_level) {
+	ring_group->total_bytes = 0;
+	ring_group->total_packets = 0;
+	ring_group->coal.flow_level = new_flow_level;
+
+	return true;
+}
+
+static bool hns3_get_new_int_gl(struct hns3_enet_ring_group *ring_group)
+{
+	struct hns3_enet_tqp_vector *tqp_vector;
+	u16 new_int_gl;
+
+	if (!ring_group->ring)
+		return false;
+
+	tqp_vector = ring_group->ring->tqp_vector;
+	if (!tqp_vector->last_jiffies)
+		return false;
+
+	if (ring_group->total_packets == 0) {
+		ring_group->coal.int_gl = HNS3_INT_GL_50K;
+		ring_group->coal.flow_level = HNS3_FLOW_LOW;
+		return true;
+	}
+
+	if (!hns3_get_new_flow_lvl(ring_group))
+		return false;
+
+	new_int_gl = ring_group->coal.int_gl;
+	switch (ring_group->coal.flow_level) {
 	case HNS3_FLOW_LOW:
 		new_int_gl = HNS3_INT_GL_50K;
 		break;
@@ -3022,9 +3038,6 @@ static bool hns3_get_new_int_gl(struct hns3_enet_ring_group *ring_group)
 		break;
 	}
 
-	ring_group->total_bytes = 0;
-	ring_group->total_packets = 0;
-	ring_group->coal.flow_level = new_flow_level;
 	if (new_int_gl != ring_group->coal.int_gl) {
 		ring_group->coal.int_gl = new_int_gl;
 		return true;
-- 
2.7.4

