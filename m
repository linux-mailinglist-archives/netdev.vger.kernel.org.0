Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA06B21D533
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbgGMLnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:43:17 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35556 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729748AbgGMLnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:43:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DBeeQb024228;
        Mon, 13 Jul 2020 04:43:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=OBl1ZZ/sHmP0bYX9kr4hIDPWB1iaFp5s1mEFq/oKRH8=;
 b=SVORW91eBJwkL0Yx6ejk00a4VgOTAc1TGZAQfYsxn8ysZ+j+wDfWMMlMJZ/ESrMziSL3
 i4l6H2nfAfAro/dskVAeqTy2QcDIyRo/MlQLIHxW36y8veqglsv9O6dtVcZXxNUML6N6
 Hm/AyLFbmnaOm7Z9zbyYEO7LbU0iKC2eRB63mCvXOYj7/tt7qQyoQvGJ9mlnenLvQMqi
 NpNcP3ldzPbdvhNf8YxgECQ0LsNzO1lKRL1DtO8CQFDxyNASvD/dN6+i2JFuQG/1E9/S
 fgyBby4eyTjalSnEE9QUfUuKqG0tgc22idvOBTIOqNinzd3dBl70Lb9Fda78E0ku8j58 GA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asn76nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Jul 2020 04:43:13 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 04:43:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Jul 2020 04:43:12 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.6.200.41])
        by maili.marvell.com (Postfix) with ESMTP id 242E03F703F;
        Mon, 13 Jul 2020 04:43:09 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 09/10] net: atlantic: A0 ntuple filters
Date:   Mon, 13 Jul 2020 14:42:32 +0300
Message-ID: <20200713114233.436-10-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713114233.436-1-irusskikh@marvell.com>
References: <20200713114233.436-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_10:2020-07-13,2020-07-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds support for ntuple filters on A0.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      | 116 +++++++++++++-----
 1 file changed, 88 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index e1877d520135..c38a4b8a14cb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -16,33 +16,35 @@
 #include "hw_atl_llh.h"
 #include "hw_atl_a0_internal.h"
 
-#define DEFAULT_A0_BOARD_BASIC_CAPABILITIES \
-	.is_64_dma = true,		  \
-	.op64bit = false,		  \
-	.msix_irqs = 4U,		  \
-	.irq_mask = ~0U,		  \
-	.vecs = HW_ATL_A0_RSS_MAX,	  \
-	.tcs_max = HW_ATL_A0_TC_MAX,	  \
-	.rxd_alignment = 1U,		  \
-	.rxd_size = HW_ATL_A0_RXD_SIZE,   \
-	.rxds_max = HW_ATL_A0_MAX_RXD,    \
-	.rxds_min = HW_ATL_A0_MIN_RXD,    \
-	.txd_alignment = 1U,		  \
-	.txd_size = HW_ATL_A0_TXD_SIZE,   \
-	.txds_max = HW_ATL_A0_MAX_TXD,    \
-	.txds_min = HW_ATL_A0_MIN_RXD,    \
-	.txhwb_alignment = 4096U,	  \
-	.tx_rings = HW_ATL_A0_TX_RINGS,   \
-	.rx_rings = HW_ATL_A0_RX_RINGS,   \
-	.hw_features = NETIF_F_HW_CSUM |  \
-			NETIF_F_RXHASH |  \
-			NETIF_F_RXCSUM |  \
-			NETIF_F_SG |	  \
-			NETIF_F_TSO,	  \
-	.hw_priv_flags = IFF_UNICAST_FLT, \
-	.flow_control = true,		  \
-	.mtu = HW_ATL_A0_MTU_JUMBO,       \
-	.mac_regs_count = 88,		  \
+#define DEFAULT_A0_BOARD_BASIC_CAPABILITIES	     \
+	.is_64_dma = true,			     \
+	.op64bit = false,			     \
+	.msix_irqs = 4U,			     \
+	.irq_mask = ~0U,			     \
+	.vecs = HW_ATL_A0_RSS_MAX,		     \
+	.tcs_max = HW_ATL_A0_TC_MAX,		     \
+	.rxd_alignment = 1U,			     \
+	.rxd_size = HW_ATL_A0_RXD_SIZE,		     \
+	.rxds_max = HW_ATL_A0_MAX_RXD,		     \
+	.rxds_min = HW_ATL_A0_MIN_RXD,		     \
+	.txd_alignment = 1U,			     \
+	.txd_size = HW_ATL_A0_TXD_SIZE,		     \
+	.txds_max = HW_ATL_A0_MAX_TXD,		     \
+	.txds_min = HW_ATL_A0_MIN_RXD,		     \
+	.txhwb_alignment = 4096U,		     \
+	.tx_rings = HW_ATL_A0_TX_RINGS,		     \
+	.rx_rings = HW_ATL_A0_RX_RINGS,		     \
+	.hw_features = NETIF_F_HW_CSUM |	     \
+			NETIF_F_RXHASH |	     \
+			NETIF_F_RXCSUM |	     \
+			NETIF_F_SG |		     \
+			NETIF_F_TSO |		     \
+			NETIF_F_NTUPLE |	     \
+			NETIF_F_HW_VLAN_CTAG_FILTER, \
+	.hw_priv_flags = IFF_UNICAST_FLT,	     \
+	.flow_control = true,			     \
+	.mtu = HW_ATL_A0_MTU_JUMBO,		     \
+	.mac_regs_count = 88,			     \
 	.hw_alive_check_addr = 0x10U
 
 const struct aq_hw_caps_s hw_atl_a0_caps_aqc100 = {
@@ -330,6 +332,7 @@ static int hw_atl_a0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr)
 		err = -EINVAL;
 		goto err_exit;
 	}
+
 	h = (mac_addr[0] << 8) | (mac_addr[1]);
 	l = (mac_addr[2] << 24) | (mac_addr[3] << 16) |
 	    (mac_addr[4] << 8) | mac_addr[5];
@@ -356,7 +359,6 @@ static int hw_atl_a0_hw_init(struct aq_hw_s *self, u8 *mac_addr)
 	struct aq_nic_cfg_s *aq_nic_cfg = self->aq_nic_cfg;
 	int err = 0;
 
-
 	hw_atl_a0_hw_init_tx_path(self);
 	hw_atl_a0_hw_init_rx_path(self);
 
@@ -885,6 +887,63 @@ static int hw_atl_a0_hw_ring_rx_stop(struct aq_hw_s *self,
 	return aq_hw_err_from_flags(self);
 }
 
+static int hw_atl_a0_hw_fl3l4_clear(struct aq_hw_s *self,
+				    struct aq_rx_filter_l3l4 *data)
+{
+	u8 location = data->location;
+
+	if (!data->is_ipv6) {
+		hw_atl_rpfl3l4_cmd_clear(self, location);
+		hw_atl_rpf_l4_spd_set(self, 0U, location);
+		hw_atl_rpf_l4_dpd_set(self, 0U, location);
+		hw_atl_rpfl3l4_ipv4_src_addr_clear(self, location);
+		hw_atl_rpfl3l4_ipv4_dest_addr_clear(self, location);
+	} else {
+		int i;
+
+		for (i = 0; i < HW_ATL_RX_CNT_REG_ADDR_IPV6; ++i) {
+			hw_atl_rpfl3l4_cmd_clear(self, location + i);
+			hw_atl_rpf_l4_spd_set(self, 0U, location + i);
+			hw_atl_rpf_l4_dpd_set(self, 0U, location + i);
+		}
+		hw_atl_rpfl3l4_ipv6_src_addr_clear(self, location);
+		hw_atl_rpfl3l4_ipv6_dest_addr_clear(self, location);
+	}
+
+	return aq_hw_err_from_flags(self);
+}
+
+static int hw_atl_a0_hw_fl3l4_set(struct aq_hw_s *self,
+				  struct aq_rx_filter_l3l4 *data)
+{
+	u8 location = data->location;
+
+	hw_atl_a0_hw_fl3l4_clear(self, data);
+
+	if (data->cmd) {
+		if (!data->is_ipv6) {
+			hw_atl_rpfl3l4_ipv4_dest_addr_set(self,
+							  location,
+							  data->ip_dst[0]);
+			hw_atl_rpfl3l4_ipv4_src_addr_set(self,
+							 location,
+							 data->ip_src[0]);
+		} else {
+			hw_atl_rpfl3l4_ipv6_dest_addr_set(self,
+							  location,
+							  data->ip_dst);
+			hw_atl_rpfl3l4_ipv6_src_addr_set(self,
+							 location,
+							 data->ip_src);
+		}
+	}
+	hw_atl_rpf_l4_dpd_set(self, data->p_dst, location);
+	hw_atl_rpf_l4_spd_set(self, data->p_src, location);
+	hw_atl_rpfl3l4_cmd_set(self, location, data->cmd);
+
+	return aq_hw_err_from_flags(self);
+}
+
 const struct aq_hw_ops hw_atl_ops_a0 = {
 	.hw_soft_reset        = hw_atl_utils_soft_reset,
 	.hw_prepare           = hw_atl_utils_initfw,
@@ -911,6 +970,7 @@ const struct aq_hw_ops hw_atl_ops_a0 = {
 	.hw_ring_rx_init             = hw_atl_a0_hw_ring_rx_init,
 	.hw_ring_tx_init             = hw_atl_a0_hw_ring_tx_init,
 	.hw_packet_filter_set        = hw_atl_a0_hw_packet_filter_set,
+	.hw_filter_l3l4_set          = hw_atl_a0_hw_fl3l4_set,
 	.hw_multicast_list_set       = hw_atl_a0_hw_multicast_list_set,
 	.hw_interrupt_moderation_set = hw_atl_a0_hw_interrupt_moderation_set,
 	.hw_rss_set                  = hw_atl_a0_hw_rss_set,
-- 
2.17.1

