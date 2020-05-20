Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802961DB587
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgETNsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:48:11 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36818 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726896AbgETNsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:48:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KDedBm003518;
        Wed, 20 May 2020 06:48:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=wMAwqdaPWVYlBmjB5j5JXwgnpFewiXhOOVZKaMCwmHE=;
 b=ZcwramplSNP4qNsAOQoO5d1gFd00uUgBA+YwQExbF7vrsWvUgsnSiJrV7YkGJ9OqQl6z
 sLYv0t5Ehd0eldP/3pbR8E6AYi4cneWpgLYYP7Cwc2Pf7W601F3lmQiMp/lSZzF7q9W5
 MdD3YQBJt+gOO4+vZVccjBYPda+QWmim3N85Xk6Q5SneqSaPpO6dG2bIE0eUKlDyyYnt
 nOfutPNz5xbvy4Ql4x6tzYHck4sLqiwhFzkaZSQyuV5ErNsB1Ab4NuZPtZl3X7O10KzY
 AxAJmbR4ZvL1IginiiONYltbxLausLG/RRKTG8ykMVFTjC9bd0oyr8NwO+gHy2PBLQVy fQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 312dhqs5b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 May 2020 06:48:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:48:04 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:48:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 May 2020 06:48:04 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id C0C533F7040;
        Wed, 20 May 2020 06:48:02 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 12/12] net: atlantic: proper rss_ctrl1 (54c0) initialization
Date:   Wed, 20 May 2020 16:47:34 +0300
Message-ID: <20200520134734.2014-13-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200520134734.2014-1-irusskikh@marvell.com>
References: <20200520134734.2014-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-20_09:2020-05-20,2020-05-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch fixes an inconsistency between code and spec, which
was found while working on the QoS implementation.

When 8TCs are used, 2 is the maximum supported number of index bits.
In a 4TC mode, we do support 3, but we shouldn't really use the bytes,
which are intended for the 8TC mode.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c         | 16 ++++++++++++++--
 .../aquantia/atlantic/hw_atl/hw_atl_b0.h         |  2 ++
 .../atlantic/hw_atl/hw_atl_b0_internal.h         |  4 ++++
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c |  4 +---
 .../aquantia/atlantic/hw_atl2/hw_atl2_internal.h |  3 ---
 5 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 320f3669305d..14d79f70cad7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -447,6 +447,19 @@ static int hw_atl_b0_hw_init_tx_path(struct aq_hw_s *self)
 	return aq_hw_err_from_flags(self);
 }
 
+void hw_atl_b0_hw_init_rx_rss_ctrl1(struct aq_hw_s *self)
+{
+	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
+	u32 rss_ctrl1 = HW_ATL_RSS_DISABLED;
+
+	if (cfg->is_rss)
+		rss_ctrl1 = (cfg->tc_mode == AQ_TC_MODE_8TCS) ?
+			    HW_ATL_RSS_ENABLED_8TCS_2INDEX_BITS :
+			    HW_ATL_RSS_ENABLED_4TCS_3INDEX_BITS;
+
+	hw_atl_reg_rx_flr_rss_control1set(self, rss_ctrl1);
+}
+
 static int hw_atl_b0_hw_init_rx_path(struct aq_hw_s *self)
 {
 	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
@@ -459,8 +472,7 @@ static int hw_atl_b0_hw_init_rx_path(struct aq_hw_s *self)
 	hw_atl_rpb_rx_flow_ctl_mode_set(self, 1U);
 
 	/* RSS Ring selection */
-	hw_atl_reg_rx_flr_rss_control1set(self, cfg->is_rss ?
-					0xB3333333U : 0x00000000U);
+	hw_atl_b0_hw_init_rx_rss_ctrl1(self);
 
 	/* Multicast filters */
 	for (i = HW_ATL_B0_MAC_MAX; i--;) {
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
index b855459272ca..30f468f2084d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
@@ -58,6 +58,8 @@ int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
 int hw_atl_b0_hw_ring_tx_stop(struct aq_hw_s *self, struct aq_ring_s *ring);
 int hw_atl_b0_hw_ring_rx_stop(struct aq_hw_s *self, struct aq_ring_s *ring);
 
+void hw_atl_b0_hw_init_rx_rss_ctrl1(struct aq_hw_s *self);
+
 int hw_atl_b0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr);
 
 int hw_atl_b0_hw_start(struct aq_hw_s *self);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0_internal.h
index 4fba4e0928c7..cf460d61a45e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0_internal.h
@@ -151,6 +151,10 @@
 #define HW_ATL_B0_MAX_RXD 8184U
 #define HW_ATL_B0_MAX_TXD 8184U
 
+#define HW_ATL_RSS_DISABLED 0x00000000U
+#define HW_ATL_RSS_ENABLED_8TCS_2INDEX_BITS 0xA2222222U
+#define HW_ATL_RSS_ENABLED_4TCS_3INDEX_BITS 0x80003333U
+
 /* HW layer capabilities */
 
 #endif /* HW_ATL_B0_INTERNAL_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index f941773b3e20..8df9d4ef36f0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -475,9 +475,7 @@ static int hw_atl2_hw_init_rx_path(struct aq_hw_s *self)
 	hw_atl2_rpf_rss_hash_type_set(self, HW_ATL2_RPF_RSS_HASH_TYPE_ALL);
 
 	/* RSS Ring selection */
-	hw_atl_reg_rx_flr_rss_control1set(self, cfg->is_rss ?
-						HW_ATL_RSS_ENABLED_3INDEX_BITS :
-						HW_ATL_RSS_DISABLED);
+	hw_atl_b0_hw_init_rx_rss_ctrl1(self);
 
 	/* Multicast filters */
 	for (i = HW_ATL2_MAC_MAX; i--;) {
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
index 9ac1979a4867..5a89bb8722f9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
@@ -117,9 +117,6 @@ enum HW_ATL2_RPF_RSS_HASH_TYPE {
 					HW_ATL2_RPF_RSS_HASH_TYPE_IPV6_EX_UDP,
 };
 
-#define HW_ATL_RSS_DISABLED 0x00000000U
-#define HW_ATL_RSS_ENABLED_3INDEX_BITS 0xB3333333U
-
 #define HW_ATL_MCAST_FLT_ANY_TO_HOST 0x00010FFFU
 
 struct hw_atl2_priv {
-- 
2.25.1

