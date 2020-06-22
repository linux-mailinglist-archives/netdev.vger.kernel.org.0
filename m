Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B94E203A08
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgFVOx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:53:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17180 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729157AbgFVOx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 10:53:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MEZFAm003813;
        Mon, 22 Jun 2020 07:53:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=HJQX7r9PQXqRpJeYNeei1hmeVAwQxox9JL+9mKum+cw=;
 b=C9iEQk6LlUXplmOoOL9aCgc2ZHQ4Bq60uSxx53FVkthpt5wWAYmDK4JE3RxFjKtD9wbJ
 AkZIrgGnbyYnwIgUPjKEhWthivg07gXfaShjwZyDhTcjfLbAhUDWxyK/w9o9K1B6AkZx
 zrL6Ry7EqeATB0DzUq0+ct6TzvHCpDbHRJhqD++zYQU7q28yD/TV91CuRDef/e24fTAI
 eNkLq6D0WJuqXeLT2XXFcD4KADJtJcKDx49LMfSByTfj66JBTm3AMn6MpdHNzRAsGu7N
 sX8rOgczfxKokIRwmMrgpwXnjCBORAInw619PFGoHAwyXgyM60z8mQKAM4gE6bkd/Kgx Dw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 31shynrhqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 07:53:24 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 07:53:22 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 07:53:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 07:53:22 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id CF1053F703F;
        Mon, 22 Jun 2020 07:53:20 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>
Subject: [PATCH net-next 4/6] net: atlantic: A2: flow control support
Date:   Mon, 22 Jun 2020 17:53:07 +0300
Message-ID: <20200622145309.455-5-irusskikh@marvell.com>
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

This patch adds flow control support on A2.

Co-developed-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.h      |  2 ++
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |  3 ++
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 36 +++++++++++++++++++
 4 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 14d79f70cad7..8ed6fd845969 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -108,7 +108,7 @@ static int hw_atl_b0_hw_reset(struct aq_hw_s *self)
 	return err;
 }
 
-static int hw_atl_b0_set_fc(struct aq_hw_s *self, u32 fc, u32 tc)
+int hw_atl_b0_set_fc(struct aq_hw_s *self, u32 fc, u32 tc)
 {
 	hw_atl_rpb_rx_xoff_en_per_tc_set(self, !!(fc & AQ_NIC_FC_RX), tc);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
index 30f468f2084d..bd9a6fb005c9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
@@ -62,6 +62,8 @@ void hw_atl_b0_hw_init_rx_rss_ctrl1(struct aq_hw_s *self);
 
 int hw_atl_b0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr);
 
+int hw_atl_b0_set_fc(struct aq_hw_s *self, u32 fc, u32 tc);
+
 int hw_atl_b0_hw_start(struct aq_hw_s *self);
 
 int hw_atl_b0_hw_irq_enable(struct aq_hw_s *self, u64 mask);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index 239d077e21d7..c306c26e802b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -181,6 +181,8 @@ static int hw_atl2_hw_qos_set(struct aq_hw_s *self)
 
 		threshold = (rx_buff_size * (1024U / 32U) * 50U) / 100U;
 		hw_atl_rpb_rx_buff_lo_threshold_per_tc_set(self, threshold, tc);
+
+		hw_atl_b0_set_fc(self, self->aq_nic_cfg->fc.req, tc);
 	}
 
 	/* QoS 802.1p priority -> TC mapping */
@@ -841,4 +843,5 @@ const struct aq_hw_ops hw_atl2_ops = {
 	.hw_get_hw_stats             = hw_atl2_utils_get_hw_stats,
 	.hw_get_fw_version           = hw_atl2_utils_get_fw_version,
 	.hw_set_offload              = hw_atl_b0_hw_offload_set,
+	.hw_set_fc                   = hw_atl_b0_set_fc,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index 9216517f6e65..0edcc0253b2e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -190,6 +190,15 @@ static int aq_a2_fw_set_link_speed(struct aq_hw_s *self, u32 speed)
 	return hw_atl2_shared_buffer_finish_ack(self);
 }
 
+static void aq_a2_fw_set_mpi_flow_control(struct aq_hw_s *self,
+					  struct link_options_s *link_options)
+{
+	u32 flow_control = self->aq_nic_cfg->fc.req;
+
+	link_options->pause_rx = !!(flow_control & AQ_NIC_FC_RX);
+	link_options->pause_tx = !!(flow_control & AQ_NIC_FC_TX);
+}
+
 static void aq_a2_fw_upd_eee_rate_bits(struct aq_hw_s *self,
 				       struct link_options_s *link_options,
 				       u32 eee_speeds)
@@ -213,6 +222,7 @@ static int aq_a2_fw_set_state(struct aq_hw_s *self,
 		link_options.link_up = 1U;
 		aq_a2_fw_upd_eee_rate_bits(self, &link_options,
 					   self->aq_nic_cfg->eee_speeds);
+		aq_a2_fw_set_mpi_flow_control(self, &link_options);
 		break;
 	case MPI_DEINIT:
 		link_options.link_up = 0U;
@@ -363,6 +373,30 @@ static int aq_a2_fw_renegotiate(struct aq_hw_s *self)
 	return err;
 }
 
+static int aq_a2_fw_set_flow_control(struct aq_hw_s *self)
+{
+	struct link_options_s link_options;
+
+	hw_atl2_shared_buffer_get(self, link_options, link_options);
+
+	aq_a2_fw_set_mpi_flow_control(self, &link_options);
+
+	hw_atl2_shared_buffer_write(self, link_options, link_options);
+
+	return hw_atl2_shared_buffer_finish_ack(self);
+}
+
+static u32 aq_a2_fw_get_flow_control(struct aq_hw_s *self, u32 *fcmode)
+{
+	struct link_status_s link_status;
+
+	hw_atl2_shared_buffer_read(self, link_status, link_status);
+
+	*fcmode = ((link_status.pause_rx) ? AQ_NIC_FC_RX : 0) |
+		  ((link_status.pause_tx) ? AQ_NIC_FC_TX : 0);
+	return 0;
+}
+
 u32 hw_atl2_utils_get_fw_version(struct aq_hw_s *self)
 {
 	struct version_s version;
@@ -402,4 +436,6 @@ const struct aq_fw_ops aq_a2_fw_ops = {
 	.update_stats       = aq_a2_fw_update_stats,
 	.set_eee_rate       = aq_a2_fw_set_eee_rate,
 	.get_eee_rate       = aq_a2_fw_get_eee_rate,
+	.set_flow_control   = aq_a2_fw_set_flow_control,
+	.get_flow_control   = aq_a2_fw_get_flow_control,
 };
-- 
2.25.1

