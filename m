Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3C5203A07
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbgFVOx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:53:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57754 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729244AbgFVOx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 10:53:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MEYq9Q032123;
        Mon, 22 Jun 2020 07:53:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=x+rsUlWER+unYieWAzsloD9hTKCBZ0uXWjypRl7JHq0=;
 b=pMi+pi9HdZJQm/cPqH029JTqwaj2769Pcs4GOJHaTtUEYpTXRMQQx/W/2XsW0SnU8iDC
 wwUbfNOYp9dvS5K0IXBy7OJ13H40/cIAgEPvunrmfSMVL7W9jTpQ+tI10ohcRZTp04Aw
 Dh0dto+JlL9EDvtyiNRt2NuqnCBvdUUI043FwWc/8J8G41gjIpfqwfrAGvXZt8qwbiPQ
 2hzTXLC+1NCU36YXvkGj9Y8Db/URbHoWpAYZ5jViOQQ5BE207yYot7FGu7A/5TViN3CO
 yNpHcKmT76Kz7d/DuR0pXuXJ1/jQD0WKvCWxS9gLsR0jZ/DOt66HoXcGnVzI8xXRXUO/ Nw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 31sftph244-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 07:53:25 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 07:53:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 07:53:24 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id E3FB33F703F;
        Mon, 22 Jun 2020 07:53:22 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 5/6] net: atlantic: A2: report link partner capabilities
Date:   Mon, 22 Jun 2020 17:53:08 +0300
Message-ID: <20200622145309.455-6-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200622145309.455-1-irusskikh@marvell.com>
References: <20200622145309.455-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_08:2020-06-22,2020-06-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds link partner capabilities reporting support on A2.
In particular, the following capabilities are available for reporting:
* link rate;
* EEE;
* flow control.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  2 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 49 +++++++++++++++++++
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 30 ++++++++++++
 3 files changed, 81 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index 1408a522eff1..f2663ad22209 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -71,6 +71,8 @@ struct aq_hw_caps_s {
 struct aq_hw_link_status_s {
 	unsigned int mbps;
 	bool full_duplex;
+	u32 lp_link_speed_msk;
+	u32 lp_flow_control;
 };
 
 struct aq_stats_s {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 49528fcdc947..647b22d89b1a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -935,6 +935,8 @@ static void aq_nic_update_ndev_stats(struct aq_nic_s *self)
 void aq_nic_get_link_ksettings(struct aq_nic_s *self,
 			       struct ethtool_link_ksettings *cmd)
 {
+	u32 lp_link_speed_msk;
+
 	if (self->aq_nic_cfg.aq_hw_caps->media_type == AQ_HW_MEDIA_TYPE_FIBRE)
 		cmd->base.port = PORT_FIBRE;
 	else
@@ -1053,6 +1055,53 @@ void aq_nic_get_link_ksettings(struct aq_nic_s *self,
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, FIBRE);
 	else
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, TP);
+
+	ethtool_link_ksettings_zero_link_mode(cmd, lp_advertising);
+	lp_link_speed_msk = self->aq_hw->aq_link_status.lp_link_speed_msk;
+
+	if (lp_link_speed_msk & AQ_NIC_RATE_10G)
+		ethtool_link_ksettings_add_link_mode(cmd, lp_advertising,
+						     10000baseT_Full);
+
+	if (lp_link_speed_msk & AQ_NIC_RATE_5G)
+		ethtool_link_ksettings_add_link_mode(cmd, lp_advertising,
+						     5000baseT_Full);
+
+	if (lp_link_speed_msk & AQ_NIC_RATE_2G5)
+		ethtool_link_ksettings_add_link_mode(cmd, lp_advertising,
+						     2500baseT_Full);
+
+	if (lp_link_speed_msk & AQ_NIC_RATE_1G)
+		ethtool_link_ksettings_add_link_mode(cmd, lp_advertising,
+						     1000baseT_Full);
+
+	if (lp_link_speed_msk & AQ_NIC_RATE_1G_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, lp_advertising,
+						     1000baseT_Half);
+
+	if (lp_link_speed_msk & AQ_NIC_RATE_100M)
+		ethtool_link_ksettings_add_link_mode(cmd, lp_advertising,
+						     100baseT_Full);
+
+	if (lp_link_speed_msk & AQ_NIC_RATE_100M_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, lp_advertising,
+						     100baseT_Half);
+
+	if (lp_link_speed_msk & AQ_NIC_RATE_10M)
+		ethtool_link_ksettings_add_link_mode(cmd, lp_advertising,
+						     10baseT_Full);
+
+	if (lp_link_speed_msk & AQ_NIC_RATE_10M_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, lp_advertising,
+						     10baseT_Half);
+
+	if (self->aq_hw->aq_link_status.lp_flow_control & AQ_NIC_FC_RX)
+		ethtool_link_ksettings_add_link_mode(cmd, lp_advertising,
+						     Pause);
+	if (!!(self->aq_hw->aq_link_status.lp_flow_control & AQ_NIC_FC_TX) ^
+	    !!(self->aq_hw->aq_link_status.lp_flow_control & AQ_NIC_FC_RX))
+		ethtool_link_ksettings_add_link_mode(cmd, lp_advertising,
+						     Asym_Pause);
 }
 
 int aq_nic_set_link_ksettings(struct aq_nic_s *self,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index 0edcc0253b2e..c5d1a1404042 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -164,6 +164,27 @@ static u32 a2_fw_lkp_to_mask(struct lkp_link_caps_s *lkp_link_caps)
 {
 	u32 rate = 0;
 
+	if (lkp_link_caps->rate_10G)
+		rate |= AQ_NIC_RATE_10G;
+	if (lkp_link_caps->rate_5G)
+		rate |= AQ_NIC_RATE_5G;
+	if (lkp_link_caps->rate_N5G)
+		rate |= AQ_NIC_RATE_5GSR;
+	if (lkp_link_caps->rate_2P5G)
+		rate |= AQ_NIC_RATE_2G5;
+	if (lkp_link_caps->rate_1G)
+		rate |= AQ_NIC_RATE_1G;
+	if (lkp_link_caps->rate_1G_hd)
+		rate |= AQ_NIC_RATE_1G_HALF;
+	if (lkp_link_caps->rate_100M)
+		rate |= AQ_NIC_RATE_100M;
+	if (lkp_link_caps->rate_100M_hd)
+		rate |= AQ_NIC_RATE_100M_HALF;
+	if (lkp_link_caps->rate_10M)
+		rate |= AQ_NIC_RATE_10M;
+	if (lkp_link_caps->rate_10M_hd)
+		rate |= AQ_NIC_RATE_10M_HALF;
+
 	if (lkp_link_caps->eee_10G)
 		rate |= AQ_NIC_RATE_EEE_10G;
 	if (lkp_link_caps->eee_5G)
@@ -240,6 +261,7 @@ static int aq_a2_fw_set_state(struct aq_hw_s *self,
 
 static int aq_a2_fw_update_link_status(struct aq_hw_s *self)
 {
+	struct lkp_link_caps_s lkp_link_caps;
 	struct link_status_s link_status;
 
 	hw_atl2_shared_buffer_read(self, link_status, link_status);
@@ -268,6 +290,14 @@ static int aq_a2_fw_update_link_status(struct aq_hw_s *self)
 	}
 	self->aq_link_status.full_duplex = link_status.duplex;
 
+	hw_atl2_shared_buffer_read(self, lkp_link_caps, lkp_link_caps);
+
+	self->aq_link_status.lp_link_speed_msk =
+				 a2_fw_lkp_to_mask(&lkp_link_caps);
+	self->aq_link_status.lp_flow_control =
+				((lkp_link_caps.pause_rx) ? AQ_NIC_FC_RX : 0) |
+				((lkp_link_caps.pause_tx) ? AQ_NIC_FC_TX : 0);
+
 	return 0;
 }
 
-- 
2.25.1

