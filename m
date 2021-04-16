Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF32B36281A
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238843AbhDPSzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236467AbhDPSzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28CAB613CB;
        Fri, 16 Apr 2021 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599285;
        bh=Z4JqkV5Te88bftf+vn/D0UUUCgfSKF+eKh8XB91XV0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cfr2npCHcLM09GRxaGo4hFo/2/K82mAq7opE8BQllDIyF20U3qKnx2/2fGQAoCcfG
         esq9x6OBkwdf6UOgPrZ/cx/ZRtwAJl/XCCw6uBqjVCfVBSgbqkP+zyX9HS/4fAXJ0D
         dp3PjARAZVh5Kxpv2RK0E7Iu/zgVp8NyX0DDy2FmDiyHoKuBsr6D65m1UHE5JB2iuf
         fIEdBlOfueXOQn3KTYeQGXgrecNssrb05PasSHOKxTfS0nVq+CgRT6ghMeNeT7NLs8
         cjGgHQjRV5DjEP0KQnSr1MtD/Bsib6i9QddEtHaOT1PMCm/2+msGHHKnEdsnbMC0Hu
         nGbSs57GxD8NQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Moshe Tal <moshet@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/14] net/mlx5: Add register layout to support extended link state
Date:   Fri, 16 Apr 2021 11:54:27 -0700
Message-Id: <20210416185430.62584-12-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416185430.62584-1-saeed@kernel.org>
References: <20210416185430.62584-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Tal <moshet@nvidia.com>

Add needed structure layouts and defines for pddr register
(Port Diagnostics Database Register) and the troublshooting page.

This will be used to get extended link state from the monitor opcode
bits.

Signed-off-by: Moshe Tal <moshet@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/driver.h   |  1 +
 include/linux/mlx5/mlx5_ifc.h | 50 +++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 2da953ad02ed..4e531c2aab52 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -127,6 +127,7 @@ enum {
 	MLX5_REG_PELC		 = 0x500e,
 	MLX5_REG_PVLC		 = 0x500f,
 	MLX5_REG_PCMR		 = 0x5041,
+	MLX5_REG_PDDR		 = 0x5031,
 	MLX5_REG_PMLP		 = 0x5002,
 	MLX5_REG_PPLM		 = 0x5023,
 	MLX5_REG_PCAM		 = 0x507f,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1599deee0456..f2c51d6833c6 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9956,6 +9956,53 @@ struct mlx5_ifc_mirc_reg_bits {
 	u8         reserved_at_20[0x20];
 };
 
+struct mlx5_ifc_pddr_monitor_opcode_bits {
+	u8         reserved_at_0[0x10];
+	u8         monitor_opcode[0x10];
+};
+
+union mlx5_ifc_pddr_troubleshooting_page_status_opcode_auto_bits {
+	struct mlx5_ifc_pddr_monitor_opcode_bits pddr_monitor_opcode;
+	u8         reserved_at_0[0x20];
+};
+
+enum {
+	/* Monitor opcodes */
+	MLX5_PDDR_REG_TRBLSH_GROUP_OPCODE_MONITOR = 0x0,
+};
+
+struct mlx5_ifc_pddr_troubleshooting_page_bits {
+	u8         reserved_at_0[0x10];
+	u8         group_opcode[0x10];
+
+	union mlx5_ifc_pddr_troubleshooting_page_status_opcode_auto_bits status_opcode;
+
+	u8         reserved_at_40[0x20];
+
+	u8         status_message[59][0x20];
+};
+
+union mlx5_ifc_pddr_reg_page_data_auto_bits {
+	struct mlx5_ifc_pddr_troubleshooting_page_bits pddr_troubleshooting_page;
+	u8         reserved_at_0[0x7c0];
+};
+
+enum {
+	MLX5_PDDR_REG_PAGE_SELECT_TROUBLESHOOTING_INFO_PAGE      = 0x1,
+};
+
+struct mlx5_ifc_pddr_reg_bits {
+	u8         reserved_at_0[0x8];
+	u8         local_port[0x8];
+	u8         pnat[0x2];
+	u8         reserved_at_12[0xe];
+
+	u8         reserved_at_20[0x18];
+	u8         page_select[0x8];
+
+	union mlx5_ifc_pddr_reg_page_data_auto_bits page_data;
+};
+
 union mlx5_ifc_ports_control_registers_document_bits {
 	struct mlx5_ifc_bufferx_reg_bits bufferx_reg;
 	struct mlx5_ifc_eth_2819_cntrs_grp_data_layout_bits eth_2819_cntrs_grp_data_layout;
@@ -9970,6 +10017,9 @@ union mlx5_ifc_ports_control_registers_document_bits {
 	struct mlx5_ifc_pamp_reg_bits pamp_reg;
 	struct mlx5_ifc_paos_reg_bits paos_reg;
 	struct mlx5_ifc_pcap_reg_bits pcap_reg;
+	struct mlx5_ifc_pddr_monitor_opcode_bits pddr_monitor_opcode;
+	struct mlx5_ifc_pddr_reg_bits pddr_reg;
+	struct mlx5_ifc_pddr_troubleshooting_page_bits pddr_troubleshooting_page;
 	struct mlx5_ifc_peir_reg_bits peir_reg;
 	struct mlx5_ifc_pelc_reg_bits pelc_reg;
 	struct mlx5_ifc_pfcc_reg_bits pfcc_reg;
-- 
2.30.2

