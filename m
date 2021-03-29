Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AB734D237
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 16:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhC2ONy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 10:13:54 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:21626 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbhC2ONg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 10:13:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617027216; x=1648563216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xm/QN71ZAdvUwQ3x6+KH2oQUY9COy/or46DUhqjrUvc=;
  b=eSLgMuhRd0vWn3gHMyyrDZVAxOCgV2h3GEYoGAkC1YpASjmAgNyqi/Da
   NK5PhVloTwbYTdw6nYhrThQ0Hh5SfaRNJUj5uVWFTdFTWObZ1WUhy3sX2
   kJRO4keKtst4rbvSvHQ97XcwtrvuRIZihml2diZAohNelSE3o+x74nNys
   rz7HXFlBeE3iPLuuPd2RJn5y1gBLA5KCNGIqDKXJn1S2ZG07W2tZqE/PY
   gCHjNJ3GaFb0EKhgzhpRP4glEtdGAOuEmErBzY+fT8m6BgiMlKX81lL4R
   GopZwW0EBv+PgfoQigSTmzqSMBnWJBFvD3FLckKkPWTU+MS/0Fek2ecDA
   Q==;
IronPort-SDR: qpZf4qqqrAKJ/v1k12es+DK96B6+gGBtRiBDX3yqZiDihPJ7OnSGq1QZq9KnLLMD1VouZ2rUKZ
 BoYh7WMnSxhPS+IiC8tK8YewYUTSw98xwekv06wjzCJp8elcqS0BIDzwVDe7DFz/JlqsDbk62u
 ko4tmvEVPWbAsM64gzjXSK8GPSTLvNkgFwtsWHahUhMEpDw+PAmTHi8MAeiX5SBKxNRe+dIlVi
 4UamlEqQnnc1AEI2dE/rDr8lzN0uXOrMl/K7BoOL5UOlOLptUMpzJ5ST9qeTVnaZGvkifDxn/1
 y6I=
X-IronPort-AV: E=Sophos;i="5.81,288,1610434800"; 
   d="scan'208";a="111722412"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2021 07:13:24 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 07:13:21 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Mon, 29 Mar 2021 07:13:19 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH linux-next v2 1/1] phy: Sparx5 Eth SerDes: Use direct register operations
Date:   Mon, 29 Mar 2021 16:13:09 +0200
Message-ID: <20210329141309.612459-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329141309.612459-1-steen.hegelund@microchip.com>
References: <20210329141309.612459-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use direct register operations instead of a table of register
information to lower the stack usage.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/phy/microchip/sparx5_serdes.c | 1869 +++++++++++++------------
 1 file changed, 951 insertions(+), 918 deletions(-)

diff --git a/drivers/phy/microchip/sparx5_serdes.c b/drivers/phy/microchip/sparx5_serdes.c
index 06bcf0c166cf..338a4220b45f 100644
--- a/drivers/phy/microchip/sparx5_serdes.c
+++ b/drivers/phy/microchip/sparx5_serdes.c
@@ -343,12 +343,6 @@ struct sparx5_sd10g28_params {
 	u8 fx_100;
 };
 
-struct sparx5_serdes_regval {
-	u32 value;
-	u32 mask;
-	void __iomem *addr;
-};
-
 static struct sparx5_sd25g28_media_preset media_presets_25g[] = {
 	{ /* ETH_MEDIA_DEFAULT */
 		.cfg_en_adv               = 0,
@@ -945,431 +939,411 @@ static void sparx5_sd25g28_reset(void __iomem *regs[],
 	}
 }
 
-static int sparx5_sd25g28_apply_params(struct device *dev,
-				       void __iomem *regs[],
-				       struct sparx5_sd25g28_params *params,
-				       u32 sd_index)
+static int sparx5_sd25g28_apply_params(struct sparx5_serdes_macro *macro,
+				       struct sparx5_sd25g28_params *params)
 {
-	struct sparx5_serdes_regval item[] = {
-		{
-			SD_LANE_25G_SD_LANE_CFG_MACRO_RST_SET(1),
-			SD_LANE_25G_SD_LANE_CFG_MACRO_RST,
-			sdx5_addr(regs, SD_LANE_25G_SD_LANE_CFG(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0xFF),
-			SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
-			sdx5_addr(regs, SD25G_LANE_CMU_FF(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_1A_R_DWIDTHCTRL_FROM_HWT_SET
-				(params->r_d_width_ctrl_from_hwt) |
-			SD25G_LANE_CMU_1A_R_REG_MANUAL_SET(params->r_reg_manual),
-			SD25G_LANE_CMU_1A_R_DWIDTHCTRL_FROM_HWT |
-			SD25G_LANE_CMU_1A_R_REG_MANUAL,
-			sdx5_addr(regs, SD25G_LANE_CMU_1A(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_31_CFG_COMMON_RESERVE_7_0_SET
-				(params->cfg_common_reserve_7_0),
-			SD25G_LANE_CMU_31_CFG_COMMON_RESERVE_7_0,
-			sdx5_addr(regs, SD25G_LANE_CMU_31(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_09_CFG_EN_DUMMY_SET(params->cfg_en_dummy),
-			SD25G_LANE_CMU_09_CFG_EN_DUMMY,
-			sdx5_addr(regs, SD25G_LANE_CMU_09(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_13_CFG_PLL_RESERVE_3_0_SET(params->cfg_pll_reserve_3_0),
-			SD25G_LANE_CMU_13_CFG_PLL_RESERVE_3_0,
-			sdx5_addr(regs, SD25G_LANE_CMU_13(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_40_L0_CFG_TXCAL_EN_SET(params->l0_cfg_txcal_en),
-			SD25G_LANE_CMU_40_L0_CFG_TXCAL_EN,
-			sdx5_addr(regs, SD25G_LANE_CMU_40(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_46_L0_CFG_TX_RESERVE_15_8_SET
-				(params->l0_cfg_tx_reserve_15_8),
-			SD25G_LANE_CMU_46_L0_CFG_TX_RESERVE_15_8,
-			sdx5_addr(regs, SD25G_LANE_CMU_46(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_45_L0_CFG_TX_RESERVE_7_0_SET(params->l0_cfg_tx_reserve_7_0),
-			SD25G_LANE_CMU_45_L0_CFG_TX_RESERVE_7_0,
-			sdx5_addr(regs, SD25G_LANE_CMU_45(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN_SET(0),
-			SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN,
-			sdx5_addr(regs, SD25G_LANE_CMU_0B(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN_SET(1),
-			SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN,
-			sdx5_addr(regs, SD25G_LANE_CMU_0B(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_19_R_CK_RESETB_SET(0),
-			SD25G_LANE_CMU_19_R_CK_RESETB,
-			sdx5_addr(regs, SD25G_LANE_CMU_19(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_19_R_CK_RESETB_SET(1),
-			SD25G_LANE_CMU_19_R_CK_RESETB,
-			sdx5_addr(regs, SD25G_LANE_CMU_19(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_18_R_PLL_RSTN_SET(0),
-			SD25G_LANE_CMU_18_R_PLL_RSTN,
-			sdx5_addr(regs, SD25G_LANE_CMU_18(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_18_R_PLL_RSTN_SET(1),
-			SD25G_LANE_CMU_18_R_PLL_RSTN,
-			sdx5_addr(regs, SD25G_LANE_CMU_18(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_1A_R_DWIDTHCTRL_2_0_SET(params->r_d_width_ctrl_2_0),
-			SD25G_LANE_CMU_1A_R_DWIDTHCTRL_2_0,
-			sdx5_addr(regs, SD25G_LANE_CMU_1A(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_30_R_TXFIFO_CK_DIV_PMAD_2_0_SET
-				(params->r_txfifo_ck_div_pmad_2_0) |
-			SD25G_LANE_CMU_30_R_RXFIFO_CK_DIV_PMAD_2_0_SET
-			(params->r_rxfifo_ck_div_pmad_2_0),
-			SD25G_LANE_CMU_30_R_TXFIFO_CK_DIV_PMAD_2_0 |
-			SD25G_LANE_CMU_30_R_RXFIFO_CK_DIV_PMAD_2_0,
-			sdx5_addr(regs, SD25G_LANE_CMU_30(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_0C_CFG_PLL_LOL_SET_SET(params->cfg_pll_lol_set) |
-			SD25G_LANE_CMU_0C_CFG_VCO_DIV_MODE_1_0_SET(params->cfg_vco_div_mode_1_0),
-			SD25G_LANE_CMU_0C_CFG_PLL_LOL_SET |
-			SD25G_LANE_CMU_0C_CFG_VCO_DIV_MODE_1_0,
-			sdx5_addr(regs, SD25G_LANE_CMU_0C(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_0D_CFG_PRE_DIVSEL_1_0_SET(params->cfg_pre_divsel_1_0),
-			SD25G_LANE_CMU_0D_CFG_PRE_DIVSEL_1_0,
-			sdx5_addr(regs, SD25G_LANE_CMU_0D(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_0E_CFG_SEL_DIV_3_0_SET(params->cfg_sel_div_3_0),
-			SD25G_LANE_CMU_0E_CFG_SEL_DIV_3_0,
-			sdx5_addr(regs, SD25G_LANE_CMU_0E(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0x00),
-			SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
-			sdx5_addr(regs, SD25G_LANE_CMU_FF(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_0C_LN_CFG_PMA_TX_CK_BITWIDTH_2_0_SET
-				(params->cfg_pma_tx_ck_bitwidth_2_0),
-			SD25G_LANE_LANE_0C_LN_CFG_PMA_TX_CK_BITWIDTH_2_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_0C(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_01_LN_CFG_TX_PREDIV_1_0_SET(params->cfg_tx_prediv_1_0),
-			SD25G_LANE_LANE_01_LN_CFG_TX_PREDIV_1_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_01(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_18_LN_CFG_RXDIV_SEL_2_0_SET(params->cfg_rxdiv_sel_2_0),
-			SD25G_LANE_LANE_18_LN_CFG_RXDIV_SEL_2_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_18(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_2C_LN_CFG_TX_SUBRATE_2_0_SET(params->cfg_tx_subrate_2_0),
-			SD25G_LANE_LANE_2C_LN_CFG_TX_SUBRATE_2_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_2C(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_28_LN_CFG_RX_SUBRATE_2_0_SET(params->cfg_rx_subrate_2_0),
-			SD25G_LANE_LANE_28_LN_CFG_RX_SUBRATE_2_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_28(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_18_LN_CFG_CDRCK_EN_SET(params->cfg_cdrck_en),
-			SD25G_LANE_LANE_18_LN_CFG_CDRCK_EN,
-			sdx5_addr(regs, SD25G_LANE_LANE_18(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_0F_LN_CFG_DFETAP_EN_5_1_SET(params->cfg_dfetap_en_5_1),
-			SD25G_LANE_LANE_0F_LN_CFG_DFETAP_EN_5_1,
-			sdx5_addr(regs, SD25G_LANE_LANE_0F(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD_SET(params->cfg_erramp_pd),
-			SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD,
-			sdx5_addr(regs, SD25G_LANE_LANE_18(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_1D_LN_CFG_PI_DFE_EN_SET(params->cfg_pi_dfe_en),
-			SD25G_LANE_LANE_1D_LN_CFG_PI_DFE_EN,
-			sdx5_addr(regs, SD25G_LANE_LANE_1D(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_19_LN_CFG_ECDR_PD_SET(params->cfg_ecdr_pd),
-			SD25G_LANE_LANE_19_LN_CFG_ECDR_PD,
-			sdx5_addr(regs, SD25G_LANE_LANE_19(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_01_LN_CFG_ITX_IPDRIVER_BASE_2_0_SET
-				(params->cfg_itx_ipdriver_base_2_0),
-			SD25G_LANE_LANE_01_LN_CFG_ITX_IPDRIVER_BASE_2_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_01(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_03_LN_CFG_TAP_DLY_4_0_SET(params->cfg_tap_dly_4_0),
-			SD25G_LANE_LANE_03_LN_CFG_TAP_DLY_4_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_03(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_06_LN_CFG_TAP_ADV_3_0_SET(params->cfg_tap_adv_3_0),
-			SD25G_LANE_LANE_06_LN_CFG_TAP_ADV_3_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_06(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_07_LN_CFG_EN_ADV_SET(params->cfg_en_adv) |
-			SD25G_LANE_LANE_07_LN_CFG_EN_DLY_SET(params->cfg_en_dly),
-			SD25G_LANE_LANE_07_LN_CFG_EN_ADV |
-			SD25G_LANE_LANE_07_LN_CFG_EN_DLY,
-			sdx5_addr(regs, SD25G_LANE_LANE_07(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_43_LN_CFG_TX_RESERVE_15_8_SET(params->cfg_tx_reserve_15_8),
-			SD25G_LANE_LANE_43_LN_CFG_TX_RESERVE_15_8,
-			sdx5_addr(regs, SD25G_LANE_LANE_43(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_42_LN_CFG_TX_RESERVE_7_0_SET(params->cfg_tx_reserve_7_0),
-			SD25G_LANE_LANE_42_LN_CFG_TX_RESERVE_7_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_42(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_05_LN_CFG_BW_1_0_SET(params->cfg_bw_1_0),
-			SD25G_LANE_LANE_05_LN_CFG_BW_1_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_05(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_0B_LN_CFG_TXCAL_MAN_EN_SET(params->cfg_txcal_man_en),
-			SD25G_LANE_LANE_0B_LN_CFG_TXCAL_MAN_EN,
-			sdx5_addr(regs, SD25G_LANE_LANE_0B(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_0A_LN_CFG_TXCAL_SHIFT_CODE_5_0_SET
-				(params->cfg_txcal_shift_code_5_0),
-			SD25G_LANE_LANE_0A_LN_CFG_TXCAL_SHIFT_CODE_5_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_0A(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_09_LN_CFG_TXCAL_VALID_SEL_3_0_SET
-				(params->cfg_txcal_valid_sel_3_0),
-			SD25G_LANE_LANE_09_LN_CFG_TXCAL_VALID_SEL_3_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_09(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_1A_LN_CFG_CDR_KF_2_0_SET(params->cfg_cdr_kf_2_0),
-			SD25G_LANE_LANE_1A_LN_CFG_CDR_KF_2_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_1A(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_1B_LN_CFG_CDR_M_7_0_SET(params->cfg_cdr_m_7_0),
-			SD25G_LANE_LANE_1B_LN_CFG_CDR_M_7_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_1B(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_2B_LN_CFG_PI_BW_3_0_SET(params->cfg_pi_bw_3_0),
-			SD25G_LANE_LANE_2B_LN_CFG_PI_BW_3_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_2B(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_2C_LN_CFG_DIS_2NDORDER_SET(params->cfg_dis_2ndorder),
-			SD25G_LANE_LANE_2C_LN_CFG_DIS_2NDORDER,
-			sdx5_addr(regs, SD25G_LANE_LANE_2C(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_2E_LN_CFG_CTLE_RSTN_SET(params->cfg_ctle_rstn),
-			SD25G_LANE_LANE_2E_LN_CFG_CTLE_RSTN,
-			sdx5_addr(regs, SD25G_LANE_LANE_2E(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_00_LN_CFG_ITX_IPCML_BASE_1_0_SET
-				(params->cfg_itx_ipcml_base_1_0),
-			SD25G_LANE_LANE_00_LN_CFG_ITX_IPCML_BASE_1_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_00(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_44_LN_CFG_RX_RESERVE_7_0_SET(params->cfg_rx_reserve_7_0),
-			SD25G_LANE_LANE_44_LN_CFG_RX_RESERVE_7_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_44(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_45_LN_CFG_RX_RESERVE_15_8_SET(params->cfg_rx_reserve_15_8),
-			SD25G_LANE_LANE_45_LN_CFG_RX_RESERVE_15_8,
-			sdx5_addr(regs, SD25G_LANE_LANE_45(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_0D_LN_CFG_DFECK_EN_SET(params->cfg_dfeck_en) |
-			SD25G_LANE_LANE_0D_LN_CFG_RXTERM_2_0_SET(params->cfg_rxterm_2_0),
-			SD25G_LANE_LANE_0D_LN_CFG_DFECK_EN |
-			SD25G_LANE_LANE_0D_LN_CFG_RXTERM_2_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_0D(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_21_LN_CFG_VGA_CTRL_BYP_4_0_SET
-				(params->cfg_vga_ctrl_byp_4_0),
-			SD25G_LANE_LANE_21_LN_CFG_VGA_CTRL_BYP_4_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_21(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_22_LN_CFG_EQR_FORCE_3_0_SET(params->cfg_eqr_force_3_0),
-			SD25G_LANE_LANE_22_LN_CFG_EQR_FORCE_3_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_22(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_1C_LN_CFG_EQC_FORCE_3_0_SET(params->cfg_eqc_force_3_0) |
-			SD25G_LANE_LANE_1C_LN_CFG_DFE_PD_SET(params->cfg_dfe_pd),
-			SD25G_LANE_LANE_1C_LN_CFG_EQC_FORCE_3_0 |
-			SD25G_LANE_LANE_1C_LN_CFG_DFE_PD,
-			sdx5_addr(regs, SD25G_LANE_LANE_1C(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_1E_LN_CFG_SUM_SETCM_EN_SET(params->cfg_sum_setcm_en),
-			SD25G_LANE_LANE_1E_LN_CFG_SUM_SETCM_EN,
-			sdx5_addr(regs, SD25G_LANE_LANE_1E(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_25_LN_CFG_INIT_POS_ISCAN_6_0_SET
-				(params->cfg_init_pos_iscan_6_0),
-			SD25G_LANE_LANE_25_LN_CFG_INIT_POS_ISCAN_6_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_25(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_26_LN_CFG_INIT_POS_IPI_6_0_SET
-				(params->cfg_init_pos_ipi_6_0),
-			SD25G_LANE_LANE_26_LN_CFG_INIT_POS_IPI_6_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_26(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD_SET(params->cfg_erramp_pd),
-			SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD,
-			sdx5_addr(regs, SD25G_LANE_LANE_18(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_0E_LN_CFG_DFEDIG_M_2_0_SET(params->cfg_dfedig_m_2_0),
-			SD25G_LANE_LANE_0E_LN_CFG_DFEDIG_M_2_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_0E(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_0E_LN_CFG_EN_DFEDIG_SET(params->cfg_en_dfedig),
-			SD25G_LANE_LANE_0E_LN_CFG_EN_DFEDIG,
-			sdx5_addr(regs, SD25G_LANE_LANE_0E(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_40_LN_R_TX_POL_INV_SET(params->r_tx_pol_inv) |
-			SD25G_LANE_LANE_40_LN_R_RX_POL_INV_SET(params->r_rx_pol_inv),
-			SD25G_LANE_LANE_40_LN_R_TX_POL_INV |
-			SD25G_LANE_LANE_40_LN_R_RX_POL_INV,
-			sdx5_addr(regs, SD25G_LANE_LANE_40(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_04_LN_CFG_RX2TX_LP_EN_SET(params->cfg_rx2tx_lp_en) |
-			SD25G_LANE_LANE_04_LN_CFG_TX2RX_LP_EN_SET(params->cfg_tx2rx_lp_en),
-			SD25G_LANE_LANE_04_LN_CFG_RX2TX_LP_EN |
-			SD25G_LANE_LANE_04_LN_CFG_TX2RX_LP_EN,
-			sdx5_addr(regs, SD25G_LANE_LANE_04(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN_SET(params->cfg_rxlb_en),
-			SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN,
-			sdx5_addr(regs, SD25G_LANE_LANE_1E(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_19_LN_CFG_TXLB_EN_SET(params->cfg_txlb_en),
-			SD25G_LANE_LANE_19_LN_CFG_TXLB_EN,
-			sdx5_addr(regs, SD25G_LANE_LANE_19(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG_SET(0),
-			SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG,
-			sdx5_addr(regs, SD25G_LANE_LANE_2E(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG_SET(1),
-			SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG,
-			sdx5_addr(regs, SD25G_LANE_LANE_2E(sd_index))
-		},
-		{
-			SD_LANE_25G_SD_LANE_CFG_MACRO_RST_SET(0),
-			SD_LANE_25G_SD_LANE_CFG_MACRO_RST,
-			sdx5_addr(regs, SD_LANE_25G_SD_LANE_CFG(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN_SET(0),
-			SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN,
-			sdx5_addr(regs, SD25G_LANE_LANE_1C(sd_index))
-		},
-	};
-	struct sparx5_serdes_regval item2[] = {
-		{
-			SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS_SET(0x1),
-			SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS,
-			sdx5_addr(regs, SD25G_LANE_CMU_2A(sd_index))
-		},
-		{
-			SD_LANE_25G_SD_SER_RST_SER_RST_SET(0x0),
-			SD_LANE_25G_SD_SER_RST_SER_RST,
-			sdx5_addr(regs, SD_LANE_25G_SD_SER_RST(sd_index))
-		},
-		{
-			SD_LANE_25G_SD_DES_RST_DES_RST_SET(0x0),
-			SD_LANE_25G_SD_DES_RST_DES_RST,
-			sdx5_addr(regs, SD_LANE_25G_SD_DES_RST(sd_index))
-		},
-		{
-			SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0),
-			SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
-			sdx5_addr(regs, SD25G_LANE_CMU_FF(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_2D_LN_CFG_ALOS_THR_2_0_SET(params->cfg_alos_thr_2_0),
-			SD25G_LANE_LANE_2D_LN_CFG_ALOS_THR_2_0,
-			sdx5_addr(regs, SD25G_LANE_LANE_2D(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_2E_LN_CFG_DIS_SQ_SET(0),
-			SD25G_LANE_LANE_2E_LN_CFG_DIS_SQ,
-			sdx5_addr(regs, SD25G_LANE_LANE_2E(sd_index))
-		},
-		{
-			SD25G_LANE_LANE_2E_LN_CFG_PD_SQ_SET(0),
-			SD25G_LANE_LANE_2E_LN_CFG_PD_SQ,
-			sdx5_addr(regs, SD25G_LANE_LANE_2E(sd_index))
-		},
-
-	};
+	struct sparx5_serdes_private *priv = macro->priv;
+	void __iomem **regs = priv->regs;
+	struct device *dev = priv->dev;
+	u32 sd_index = macro->stpidx;
 	u32 value;
-	int idx;
 
-	for (idx = 0; idx < ARRAY_SIZE(item); ++idx)
-		sdx5_rmw_addr(item[idx].value, item[idx].mask, item[idx].addr);
+	sdx5_rmw(SD_LANE_25G_SD_LANE_CFG_MACRO_RST_SET(1),
+		 SD_LANE_25G_SD_LANE_CFG_MACRO_RST,
+		 priv,
+		 SD_LANE_25G_SD_LANE_CFG(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0xFF),
+		 SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
+		 priv,
+		 SD25G_LANE_CMU_FF(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_1A_R_DWIDTHCTRL_FROM_HWT_SET
+		 (params->r_d_width_ctrl_from_hwt) |
+		 SD25G_LANE_CMU_1A_R_REG_MANUAL_SET(params->r_reg_manual),
+		 SD25G_LANE_CMU_1A_R_DWIDTHCTRL_FROM_HWT |
+		 SD25G_LANE_CMU_1A_R_REG_MANUAL,
+		 priv,
+		 SD25G_LANE_CMU_1A(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_31_CFG_COMMON_RESERVE_7_0_SET
+		 (params->cfg_common_reserve_7_0),
+		 SD25G_LANE_CMU_31_CFG_COMMON_RESERVE_7_0,
+		 priv,
+		 SD25G_LANE_CMU_31(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_09_CFG_EN_DUMMY_SET(params->cfg_en_dummy),
+		 SD25G_LANE_CMU_09_CFG_EN_DUMMY,
+		 priv,
+		 SD25G_LANE_CMU_09(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_13_CFG_PLL_RESERVE_3_0_SET
+		 (params->cfg_pll_reserve_3_0),
+		 SD25G_LANE_CMU_13_CFG_PLL_RESERVE_3_0,
+		 priv,
+		 SD25G_LANE_CMU_13(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_40_L0_CFG_TXCAL_EN_SET(params->l0_cfg_txcal_en),
+		 SD25G_LANE_CMU_40_L0_CFG_TXCAL_EN,
+		 priv,
+		 SD25G_LANE_CMU_40(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_46_L0_CFG_TX_RESERVE_15_8_SET
+		 (params->l0_cfg_tx_reserve_15_8),
+		 SD25G_LANE_CMU_46_L0_CFG_TX_RESERVE_15_8,
+		 priv,
+		 SD25G_LANE_CMU_46(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_45_L0_CFG_TX_RESERVE_7_0_SET
+		 (params->l0_cfg_tx_reserve_7_0),
+		 SD25G_LANE_CMU_45_L0_CFG_TX_RESERVE_7_0,
+		 priv,
+		 SD25G_LANE_CMU_45(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN_SET(0),
+		 SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN,
+		 priv,
+		 SD25G_LANE_CMU_0B(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN_SET(1),
+		 SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN,
+		 priv,
+		 SD25G_LANE_CMU_0B(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_19_R_CK_RESETB_SET(0),
+		 SD25G_LANE_CMU_19_R_CK_RESETB,
+		 priv,
+		 SD25G_LANE_CMU_19(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_19_R_CK_RESETB_SET(1),
+		 SD25G_LANE_CMU_19_R_CK_RESETB,
+		 priv,
+		 SD25G_LANE_CMU_19(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_18_R_PLL_RSTN_SET(0),
+		 SD25G_LANE_CMU_18_R_PLL_RSTN,
+		 priv,
+		 SD25G_LANE_CMU_18(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_18_R_PLL_RSTN_SET(1),
+		 SD25G_LANE_CMU_18_R_PLL_RSTN,
+		 priv,
+		 SD25G_LANE_CMU_18(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_1A_R_DWIDTHCTRL_2_0_SET(params->r_d_width_ctrl_2_0),
+		 SD25G_LANE_CMU_1A_R_DWIDTHCTRL_2_0,
+		 priv,
+		 SD25G_LANE_CMU_1A(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_30_R_TXFIFO_CK_DIV_PMAD_2_0_SET
+		 (params->r_txfifo_ck_div_pmad_2_0) |
+		 SD25G_LANE_CMU_30_R_RXFIFO_CK_DIV_PMAD_2_0_SET
+		 (params->r_rxfifo_ck_div_pmad_2_0),
+		 SD25G_LANE_CMU_30_R_TXFIFO_CK_DIV_PMAD_2_0 |
+		 SD25G_LANE_CMU_30_R_RXFIFO_CK_DIV_PMAD_2_0,
+		 priv,
+		 SD25G_LANE_CMU_30(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_0C_CFG_PLL_LOL_SET_SET(params->cfg_pll_lol_set) |
+		 SD25G_LANE_CMU_0C_CFG_VCO_DIV_MODE_1_0_SET
+		 (params->cfg_vco_div_mode_1_0),
+		 SD25G_LANE_CMU_0C_CFG_PLL_LOL_SET |
+		 SD25G_LANE_CMU_0C_CFG_VCO_DIV_MODE_1_0,
+		 priv,
+		 SD25G_LANE_CMU_0C(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_0D_CFG_PRE_DIVSEL_1_0_SET
+		 (params->cfg_pre_divsel_1_0),
+		 SD25G_LANE_CMU_0D_CFG_PRE_DIVSEL_1_0,
+		 priv,
+		 SD25G_LANE_CMU_0D(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_0E_CFG_SEL_DIV_3_0_SET(params->cfg_sel_div_3_0),
+		 SD25G_LANE_CMU_0E_CFG_SEL_DIV_3_0,
+		 priv,
+		 SD25G_LANE_CMU_0E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0x00),
+		 SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
+		 priv,
+		 SD25G_LANE_CMU_FF(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_0C_LN_CFG_PMA_TX_CK_BITWIDTH_2_0_SET
+		 (params->cfg_pma_tx_ck_bitwidth_2_0),
+		 SD25G_LANE_LANE_0C_LN_CFG_PMA_TX_CK_BITWIDTH_2_0,
+		 priv,
+		 SD25G_LANE_LANE_0C(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_01_LN_CFG_TX_PREDIV_1_0_SET
+		 (params->cfg_tx_prediv_1_0),
+		 SD25G_LANE_LANE_01_LN_CFG_TX_PREDIV_1_0,
+		 priv,
+		 SD25G_LANE_LANE_01(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_18_LN_CFG_RXDIV_SEL_2_0_SET
+		 (params->cfg_rxdiv_sel_2_0),
+		 SD25G_LANE_LANE_18_LN_CFG_RXDIV_SEL_2_0,
+		 priv,
+		 SD25G_LANE_LANE_18(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2C_LN_CFG_TX_SUBRATE_2_0_SET
+		 (params->cfg_tx_subrate_2_0),
+		 SD25G_LANE_LANE_2C_LN_CFG_TX_SUBRATE_2_0,
+		 priv,
+		 SD25G_LANE_LANE_2C(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_28_LN_CFG_RX_SUBRATE_2_0_SET
+		 (params->cfg_rx_subrate_2_0),
+		 SD25G_LANE_LANE_28_LN_CFG_RX_SUBRATE_2_0,
+		 priv,
+		 SD25G_LANE_LANE_28(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_18_LN_CFG_CDRCK_EN_SET(params->cfg_cdrck_en),
+		 SD25G_LANE_LANE_18_LN_CFG_CDRCK_EN,
+		 priv,
+		 SD25G_LANE_LANE_18(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_0F_LN_CFG_DFETAP_EN_5_1_SET
+		 (params->cfg_dfetap_en_5_1),
+		 SD25G_LANE_LANE_0F_LN_CFG_DFETAP_EN_5_1,
+		 priv,
+		 SD25G_LANE_LANE_0F(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD_SET(params->cfg_erramp_pd),
+		 SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD,
+		 priv,
+		 SD25G_LANE_LANE_18(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_1D_LN_CFG_PI_DFE_EN_SET(params->cfg_pi_dfe_en),
+		 SD25G_LANE_LANE_1D_LN_CFG_PI_DFE_EN,
+		 priv,
+		 SD25G_LANE_LANE_1D(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_19_LN_CFG_ECDR_PD_SET(params->cfg_ecdr_pd),
+		 SD25G_LANE_LANE_19_LN_CFG_ECDR_PD,
+		 priv,
+		 SD25G_LANE_LANE_19(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_01_LN_CFG_ITX_IPDRIVER_BASE_2_0_SET
+		 (params->cfg_itx_ipdriver_base_2_0),
+		 SD25G_LANE_LANE_01_LN_CFG_ITX_IPDRIVER_BASE_2_0,
+		 priv,
+		 SD25G_LANE_LANE_01(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_03_LN_CFG_TAP_DLY_4_0_SET(params->cfg_tap_dly_4_0),
+		 SD25G_LANE_LANE_03_LN_CFG_TAP_DLY_4_0,
+		 priv,
+		 SD25G_LANE_LANE_03(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_06_LN_CFG_TAP_ADV_3_0_SET(params->cfg_tap_adv_3_0),
+		 SD25G_LANE_LANE_06_LN_CFG_TAP_ADV_3_0,
+		 priv,
+		 SD25G_LANE_LANE_06(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_07_LN_CFG_EN_ADV_SET(params->cfg_en_adv) |
+		 SD25G_LANE_LANE_07_LN_CFG_EN_DLY_SET(params->cfg_en_dly),
+		 SD25G_LANE_LANE_07_LN_CFG_EN_ADV |
+		 SD25G_LANE_LANE_07_LN_CFG_EN_DLY,
+		 priv,
+		 SD25G_LANE_LANE_07(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_43_LN_CFG_TX_RESERVE_15_8_SET
+		 (params->cfg_tx_reserve_15_8),
+		 SD25G_LANE_LANE_43_LN_CFG_TX_RESERVE_15_8,
+		 priv,
+		 SD25G_LANE_LANE_43(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_42_LN_CFG_TX_RESERVE_7_0_SET
+		 (params->cfg_tx_reserve_7_0),
+		 SD25G_LANE_LANE_42_LN_CFG_TX_RESERVE_7_0,
+		 priv,
+		 SD25G_LANE_LANE_42(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_05_LN_CFG_BW_1_0_SET(params->cfg_bw_1_0),
+		 SD25G_LANE_LANE_05_LN_CFG_BW_1_0,
+		 priv,
+		 SD25G_LANE_LANE_05(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_0B_LN_CFG_TXCAL_MAN_EN_SET
+		 (params->cfg_txcal_man_en),
+		 SD25G_LANE_LANE_0B_LN_CFG_TXCAL_MAN_EN,
+		 priv,
+		 SD25G_LANE_LANE_0B(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_0A_LN_CFG_TXCAL_SHIFT_CODE_5_0_SET
+		 (params->cfg_txcal_shift_code_5_0),
+		 SD25G_LANE_LANE_0A_LN_CFG_TXCAL_SHIFT_CODE_5_0,
+		 priv,
+		 SD25G_LANE_LANE_0A(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_09_LN_CFG_TXCAL_VALID_SEL_3_0_SET
+		 (params->cfg_txcal_valid_sel_3_0),
+		 SD25G_LANE_LANE_09_LN_CFG_TXCAL_VALID_SEL_3_0,
+		 priv,
+		 SD25G_LANE_LANE_09(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_1A_LN_CFG_CDR_KF_2_0_SET(params->cfg_cdr_kf_2_0),
+		 SD25G_LANE_LANE_1A_LN_CFG_CDR_KF_2_0,
+		 priv,
+		 SD25G_LANE_LANE_1A(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_1B_LN_CFG_CDR_M_7_0_SET(params->cfg_cdr_m_7_0),
+		 SD25G_LANE_LANE_1B_LN_CFG_CDR_M_7_0,
+		 priv,
+		 SD25G_LANE_LANE_1B(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2B_LN_CFG_PI_BW_3_0_SET(params->cfg_pi_bw_3_0),
+		 SD25G_LANE_LANE_2B_LN_CFG_PI_BW_3_0,
+		 priv,
+		 SD25G_LANE_LANE_2B(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2C_LN_CFG_DIS_2NDORDER_SET
+		 (params->cfg_dis_2ndorder),
+		 SD25G_LANE_LANE_2C_LN_CFG_DIS_2NDORDER,
+		 priv,
+		 SD25G_LANE_LANE_2C(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_CTLE_RSTN_SET(params->cfg_ctle_rstn),
+		 SD25G_LANE_LANE_2E_LN_CFG_CTLE_RSTN,
+		 priv,
+		 SD25G_LANE_LANE_2E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_00_LN_CFG_ITX_IPCML_BASE_1_0_SET
+		 (params->cfg_itx_ipcml_base_1_0),
+		 SD25G_LANE_LANE_00_LN_CFG_ITX_IPCML_BASE_1_0,
+		 priv,
+		 SD25G_LANE_LANE_00(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_44_LN_CFG_RX_RESERVE_7_0_SET
+		 (params->cfg_rx_reserve_7_0),
+		 SD25G_LANE_LANE_44_LN_CFG_RX_RESERVE_7_0,
+		 priv,
+		 SD25G_LANE_LANE_44(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_45_LN_CFG_RX_RESERVE_15_8_SET
+		 (params->cfg_rx_reserve_15_8),
+		 SD25G_LANE_LANE_45_LN_CFG_RX_RESERVE_15_8,
+		 priv,
+		 SD25G_LANE_LANE_45(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_0D_LN_CFG_DFECK_EN_SET(params->cfg_dfeck_en) |
+		 SD25G_LANE_LANE_0D_LN_CFG_RXTERM_2_0_SET(params->cfg_rxterm_2_0),
+		 SD25G_LANE_LANE_0D_LN_CFG_DFECK_EN |
+		 SD25G_LANE_LANE_0D_LN_CFG_RXTERM_2_0,
+		 priv,
+		 SD25G_LANE_LANE_0D(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_21_LN_CFG_VGA_CTRL_BYP_4_0_SET
+		 (params->cfg_vga_ctrl_byp_4_0),
+		 SD25G_LANE_LANE_21_LN_CFG_VGA_CTRL_BYP_4_0,
+		 priv,
+		 SD25G_LANE_LANE_21(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_22_LN_CFG_EQR_FORCE_3_0_SET
+		 (params->cfg_eqr_force_3_0),
+		 SD25G_LANE_LANE_22_LN_CFG_EQR_FORCE_3_0,
+		 priv,
+		 SD25G_LANE_LANE_22(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_1C_LN_CFG_EQC_FORCE_3_0_SET
+		 (params->cfg_eqc_force_3_0) |
+		 SD25G_LANE_LANE_1C_LN_CFG_DFE_PD_SET(params->cfg_dfe_pd),
+		 SD25G_LANE_LANE_1C_LN_CFG_EQC_FORCE_3_0 |
+		 SD25G_LANE_LANE_1C_LN_CFG_DFE_PD,
+		 priv,
+		 SD25G_LANE_LANE_1C(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_1E_LN_CFG_SUM_SETCM_EN_SET
+		 (params->cfg_sum_setcm_en),
+		 SD25G_LANE_LANE_1E_LN_CFG_SUM_SETCM_EN,
+		 priv,
+		 SD25G_LANE_LANE_1E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_25_LN_CFG_INIT_POS_ISCAN_6_0_SET
+		 (params->cfg_init_pos_iscan_6_0),
+		 SD25G_LANE_LANE_25_LN_CFG_INIT_POS_ISCAN_6_0,
+		 priv,
+		 SD25G_LANE_LANE_25(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_26_LN_CFG_INIT_POS_IPI_6_0_SET
+		 (params->cfg_init_pos_ipi_6_0),
+		 SD25G_LANE_LANE_26_LN_CFG_INIT_POS_IPI_6_0,
+		 priv,
+		 SD25G_LANE_LANE_26(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD_SET(params->cfg_erramp_pd),
+		 SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD,
+		 priv,
+		 SD25G_LANE_LANE_18(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_0E_LN_CFG_DFEDIG_M_2_0_SET
+		 (params->cfg_dfedig_m_2_0),
+		 SD25G_LANE_LANE_0E_LN_CFG_DFEDIG_M_2_0,
+		 priv,
+		 SD25G_LANE_LANE_0E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_0E_LN_CFG_EN_DFEDIG_SET(params->cfg_en_dfedig),
+		 SD25G_LANE_LANE_0E_LN_CFG_EN_DFEDIG,
+		 priv,
+		 SD25G_LANE_LANE_0E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_40_LN_R_TX_POL_INV_SET(params->r_tx_pol_inv) |
+		 SD25G_LANE_LANE_40_LN_R_RX_POL_INV_SET(params->r_rx_pol_inv),
+		 SD25G_LANE_LANE_40_LN_R_TX_POL_INV |
+		 SD25G_LANE_LANE_40_LN_R_RX_POL_INV,
+		 priv,
+		 SD25G_LANE_LANE_40(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_04_LN_CFG_RX2TX_LP_EN_SET(params->cfg_rx2tx_lp_en) |
+		 SD25G_LANE_LANE_04_LN_CFG_TX2RX_LP_EN_SET(params->cfg_tx2rx_lp_en),
+		 SD25G_LANE_LANE_04_LN_CFG_RX2TX_LP_EN |
+		 SD25G_LANE_LANE_04_LN_CFG_TX2RX_LP_EN,
+		 priv,
+		 SD25G_LANE_LANE_04(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN_SET(params->cfg_rxlb_en),
+		 SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN,
+		 priv,
+		 SD25G_LANE_LANE_1E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_19_LN_CFG_TXLB_EN_SET(params->cfg_txlb_en),
+		 SD25G_LANE_LANE_19_LN_CFG_TXLB_EN,
+		 priv,
+		 SD25G_LANE_LANE_19(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG_SET(0),
+		 SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG,
+		 priv,
+		 SD25G_LANE_LANE_2E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG_SET(1),
+		 SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG,
+		 priv,
+		 SD25G_LANE_LANE_2E(sd_index));
+
+	sdx5_rmw(SD_LANE_25G_SD_LANE_CFG_MACRO_RST_SET(0),
+		 SD_LANE_25G_SD_LANE_CFG_MACRO_RST,
+		 priv,
+		 SD_LANE_25G_SD_LANE_CFG(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN_SET(0),
+		 SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN,
+		 priv,
+		 SD25G_LANE_LANE_1C(sd_index));
+
 	usleep_range(1000, 2000);
 
-	sdx5_rmw_addr(SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN_SET(1),
+	sdx5_rmw(SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN_SET(1),
 		 SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN,
-		 sdx5_addr(regs, SD25G_LANE_LANE_1C(sd_index)));
+		 priv,
+		 SD25G_LANE_LANE_1C(sd_index));
 
 	usleep_range(10000, 20000);
 
-	sdx5_rmw_addr(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0xff),
+	sdx5_rmw(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0xff),
 		 SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
-		 sdx5_addr(regs, SD25G_LANE_CMU_FF(sd_index)));
+		 priv,
+		 SD25G_LANE_CMU_FF(sd_index));
 
 	value = readl(sdx5_addr(regs, SD25G_LANE_CMU_C0(sd_index)));
 	value = SD25G_LANE_CMU_C0_PLL_LOL_UDL_GET(value);
@@ -1386,15 +1360,46 @@ static int sparx5_sd25g28_apply_params(struct device *dev,
 		dev_err(dev, "25G PMA Reset failed: 0x%x\n", value);
 		return -EINVAL;
 	}
-	for (idx = 0; idx < ARRAY_SIZE(item2); ++idx)
-		sdx5_rmw_addr(item2[idx].value, item2[idx].mask, item2[idx].addr);
+	sdx5_rmw(SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS_SET(0x1),
+		 SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS,
+		 priv,
+		 SD25G_LANE_CMU_2A(sd_index));
+
+	sdx5_rmw(SD_LANE_25G_SD_SER_RST_SER_RST_SET(0x0),
+		 SD_LANE_25G_SD_SER_RST_SER_RST,
+		 priv,
+		 SD_LANE_25G_SD_SER_RST(sd_index));
+
+	sdx5_rmw(SD_LANE_25G_SD_DES_RST_DES_RST_SET(0x0),
+		 SD_LANE_25G_SD_DES_RST_DES_RST,
+		 priv,
+		 SD_LANE_25G_SD_DES_RST(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0),
+		 SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
+		 priv,
+		 SD25G_LANE_CMU_FF(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2D_LN_CFG_ALOS_THR_2_0_SET
+		 (params->cfg_alos_thr_2_0),
+		 SD25G_LANE_LANE_2D_LN_CFG_ALOS_THR_2_0,
+		 priv,
+		 SD25G_LANE_LANE_2D(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_DIS_SQ_SET(0),
+		 SD25G_LANE_LANE_2E_LN_CFG_DIS_SQ,
+		 priv,
+		 SD25G_LANE_LANE_2E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_PD_SQ_SET(0),
+		 SD25G_LANE_LANE_2E_LN_CFG_PD_SQ,
+		 priv,
+		 SD25G_LANE_LANE_2E(sd_index));
+
 	return 0;
 }
 
-static void sparx5_sd10g28_reset(void __iomem *regs[],
-				 struct sparx5_sd10g28_params *params,
-				 u32 lane_index,
-				 u32 sd_index)
+static void sparx5_sd10g28_reset(void __iomem *regs[], u32 lane_index)
 {
 	/* Note: SerDes SD10G_LANE_1 is configured in 10G_LAN mode */
 	sdx5_rmw_addr(SD_LANE_SD_LANE_CFG_EXT_CFG_RST_SET(1),
@@ -1402,388 +1407,428 @@ static void sparx5_sd10g28_reset(void __iomem *regs[],
 		      sdx5_addr(regs, SD_LANE_SD_LANE_CFG(lane_index)));
 
 	usleep_range(1000, 2000);
+
+	sdx5_rmw_addr(SD_LANE_SD_LANE_CFG_EXT_CFG_RST_SET(0),
+		      SD_LANE_SD_LANE_CFG_EXT_CFG_RST,
+		      sdx5_addr(regs, SD_LANE_SD_LANE_CFG(lane_index)));
 }
 
-static int sparx5_sd10g28_apply_params(struct device *dev,
-				       void __iomem *regs[],
-				       struct sparx5_sd10g28_params *params,
-				       void __iomem *sd_inst,
-				       u32 lane_index,
-				       u32 sd_index)
+static int sparx5_sd10g28_apply_params(struct sparx5_serdes_macro *macro,
+				       struct sparx5_sd10g28_params *params)
 {
-	struct sparx5_serdes_regval item[] = {
-		{
-			SD_LANE_SD_LANE_CFG_EXT_CFG_RST_SET(0),
-			SD_LANE_SD_LANE_CFG_EXT_CFG_RST,
-			sdx5_addr(regs, SD_LANE_SD_LANE_CFG(lane_index))
-		},
-		{
-			SD_LANE_SD_LANE_CFG_MACRO_RST_SET(1),
-			SD_LANE_SD_LANE_CFG_MACRO_RST,
-			sdx5_addr(regs, SD_LANE_SD_LANE_CFG(lane_index))
-		},
-		{
-			SD10G_LANE_LANE_93_R_DWIDTHCTRL_FROM_HWT_SET(0x0) |
-			SD10G_LANE_LANE_93_R_REG_MANUAL_SET(0x1) |
-			SD10G_LANE_LANE_93_R_AUXCKSEL_FROM_HWT_SET(0x1) |
-			SD10G_LANE_LANE_93_R_LANE_ID_FROM_HWT_SET(0x1) |
-			SD10G_LANE_LANE_93_R_EN_RATECHG_CTRL_SET(0x0),
-			SD10G_LANE_LANE_93_R_DWIDTHCTRL_FROM_HWT |
-			SD10G_LANE_LANE_93_R_REG_MANUAL |
-			SD10G_LANE_LANE_93_R_AUXCKSEL_FROM_HWT |
-			SD10G_LANE_LANE_93_R_LANE_ID_FROM_HWT |
-			SD10G_LANE_LANE_93_R_EN_RATECHG_CTRL,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_93(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_94_R_ISCAN_REG_SET(0x1) |
-			SD10G_LANE_LANE_94_R_TXEQ_REG_SET(0x1) |
-			SD10G_LANE_LANE_94_R_MISC_REG_SET(0x1) |
-			SD10G_LANE_LANE_94_R_SWING_REG_SET(0x1),
-			SD10G_LANE_LANE_94_R_ISCAN_REG |
-			SD10G_LANE_LANE_94_R_TXEQ_REG |
-			SD10G_LANE_LANE_94_R_MISC_REG |
-			SD10G_LANE_LANE_94_R_SWING_REG,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_94(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_9E_R_RXEQ_REG_SET(0x1),
-			SD10G_LANE_LANE_9E_R_RXEQ_REG,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_9E(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_A1_R_SSC_FROM_HWT_SET(0x0) |
-			SD10G_LANE_LANE_A1_R_CDR_FROM_HWT_SET(0x0) |
-			SD10G_LANE_LANE_A1_R_PCLK_GATING_FROM_HWT_SET(0x1),
-			SD10G_LANE_LANE_A1_R_SSC_FROM_HWT |
-			SD10G_LANE_LANE_A1_R_CDR_FROM_HWT |
-			SD10G_LANE_LANE_A1_R_PCLK_GATING_FROM_HWT,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_A1(sd_index))
-		},
-		{
-			SD_LANE_SD_LANE_CFG_RX_REF_SEL_SET(params->cmu_sel) |
-			SD_LANE_SD_LANE_CFG_TX_REF_SEL_SET(params->cmu_sel),
-			SD_LANE_SD_LANE_CFG_RX_REF_SEL |
-			SD_LANE_SD_LANE_CFG_TX_REF_SEL,
-			sdx5_addr(regs, SD_LANE_SD_LANE_CFG(lane_index))
-		},
-		{
-			SD10G_LANE_LANE_40_CFG_LANE_RESERVE_7_0_SET(params->cfg_lane_reserve_7_0),
-			SD10G_LANE_LANE_40_CFG_LANE_RESERVE_7_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_40(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_50_CFG_SSC_RTL_CLK_SEL_SET(params->cfg_ssc_rtl_clk_sel),
-			SD10G_LANE_LANE_50_CFG_SSC_RTL_CLK_SEL,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_50(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_35_CFG_TXRATE_1_0_SET(params->cfg_txrate_1_0) |
-			SD10G_LANE_LANE_35_CFG_RXRATE_1_0_SET(params->cfg_rxrate_1_0),
-			SD10G_LANE_LANE_35_CFG_TXRATE_1_0 |
-			SD10G_LANE_LANE_35_CFG_RXRATE_1_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_35(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_94_R_DWIDTHCTRL_2_0_SET(params->r_d_width_ctrl_2_0),
-			SD10G_LANE_LANE_94_R_DWIDTHCTRL_2_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_94(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_01_CFG_PMA_TX_CK_BITWIDTH_2_0_SET
-				(params->cfg_pma_tx_ck_bitwidth_2_0),
-			SD10G_LANE_LANE_01_CFG_PMA_TX_CK_BITWIDTH_2_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_01(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_30_CFG_RXDIV_SEL_2_0_SET(params->cfg_rxdiv_sel_2_0),
-			SD10G_LANE_LANE_30_CFG_RXDIV_SEL_2_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_30(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_A2_R_PCS2PMA_PHYMODE_4_0_SET
-				(params->r_pcs2pma_phymode_4_0),
-			SD10G_LANE_LANE_A2_R_PCS2PMA_PHYMODE_4_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_A2(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_13_CFG_CDRCK_EN_SET(params->cfg_cdrck_en),
-			SD10G_LANE_LANE_13_CFG_CDRCK_EN,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_13(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_23_CFG_DFECK_EN_SET(params->cfg_dfeck_en) |
-			SD10G_LANE_LANE_23_CFG_DFE_PD_SET(params->cfg_dfe_pd) |
-			SD10G_LANE_LANE_23_CFG_ERRAMP_PD_SET(params->cfg_erramp_pd),
-			SD10G_LANE_LANE_23_CFG_DFECK_EN |
-			SD10G_LANE_LANE_23_CFG_DFE_PD |
-			SD10G_LANE_LANE_23_CFG_ERRAMP_PD,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_23(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_22_CFG_DFETAP_EN_5_1_SET(params->cfg_dfetap_en_5_1),
-			SD10G_LANE_LANE_22_CFG_DFETAP_EN_5_1,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_22(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_1A_CFG_PI_DFE_EN_SET(params->cfg_pi_DFE_en),
-			SD10G_LANE_LANE_1A_CFG_PI_DFE_EN,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_1A(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_02_CFG_EN_ADV_SET(params->cfg_en_adv) |
-			SD10G_LANE_LANE_02_CFG_EN_MAIN_SET(params->cfg_en_main) |
-			SD10G_LANE_LANE_02_CFG_EN_DLY_SET(params->cfg_en_dly) |
-			SD10G_LANE_LANE_02_CFG_TAP_ADV_3_0_SET(params->cfg_tap_adv_3_0),
-			SD10G_LANE_LANE_02_CFG_EN_ADV |
-			SD10G_LANE_LANE_02_CFG_EN_MAIN |
-			SD10G_LANE_LANE_02_CFG_EN_DLY |
-			SD10G_LANE_LANE_02_CFG_TAP_ADV_3_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_02(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_03_CFG_TAP_MAIN_SET(params->cfg_tap_main),
-			SD10G_LANE_LANE_03_CFG_TAP_MAIN,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_03(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_04_CFG_TAP_DLY_4_0_SET(params->cfg_tap_dly_4_0),
-			SD10G_LANE_LANE_04_CFG_TAP_DLY_4_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_04(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_2F_CFG_VGA_CTRL_3_0_SET(params->cfg_vga_ctrl_3_0),
-			SD10G_LANE_LANE_2F_CFG_VGA_CTRL_3_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_2F(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_2F_CFG_VGA_CP_2_0_SET(params->cfg_vga_cp_2_0),
-			SD10G_LANE_LANE_2F_CFG_VGA_CP_2_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_2F(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_0B_CFG_EQ_RES_3_0_SET(params->cfg_eq_res_3_0),
-			SD10G_LANE_LANE_0B_CFG_EQ_RES_3_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_0B(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_0D_CFG_EQR_BYP_SET(params->cfg_eq_r_byp),
-			SD10G_LANE_LANE_0D_CFG_EQR_BYP,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_0D(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_0E_CFG_EQC_FORCE_3_0_SET(params->cfg_eq_c_force_3_0) |
-			SD10G_LANE_LANE_0E_CFG_SUM_SETCM_EN_SET(params->cfg_sum_setcm_en),
-			SD10G_LANE_LANE_0E_CFG_EQC_FORCE_3_0 |
-			SD10G_LANE_LANE_0E_CFG_SUM_SETCM_EN,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_0E(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_23_CFG_EN_DFEDIG_SET(params->cfg_en_dfedig),
-			SD10G_LANE_LANE_23_CFG_EN_DFEDIG,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_23(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_06_CFG_EN_PREEMPH_SET(params->cfg_en_preemph),
-			SD10G_LANE_LANE_06_CFG_EN_PREEMPH,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_06(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_33_CFG_ITX_IPPREEMP_BASE_1_0_SET
-				(params->cfg_itx_ippreemp_base_1_0) |
-			SD10G_LANE_LANE_33_CFG_ITX_IPDRIVER_BASE_2_0_SET
-			(params->cfg_itx_ipdriver_base_2_0),
-			SD10G_LANE_LANE_33_CFG_ITX_IPPREEMP_BASE_1_0 |
-			SD10G_LANE_LANE_33_CFG_ITX_IPDRIVER_BASE_2_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_33(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_52_CFG_IBIAS_TUNE_RESERVE_5_0_SET
-				(params->cfg_ibias_tune_reserve_5_0),
-			SD10G_LANE_LANE_52_CFG_IBIAS_TUNE_RESERVE_5_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_52(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_37_CFG_TXSWING_HALF_SET(params->cfg_txswing_half),
-			SD10G_LANE_LANE_37_CFG_TXSWING_HALF,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_37(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_3C_CFG_DIS_2NDORDER_SET(params->cfg_dis_2nd_order),
-			SD10G_LANE_LANE_3C_CFG_DIS_2NDORDER,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_3C(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_39_CFG_RX_SSC_LH_SET(params->cfg_rx_ssc_lh),
-			SD10G_LANE_LANE_39_CFG_RX_SSC_LH,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_39(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_1A_CFG_PI_FLOOP_STEPS_1_0_SET
-				(params->cfg_pi_floop_steps_1_0),
-			SD10G_LANE_LANE_1A_CFG_PI_FLOOP_STEPS_1_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_1A(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_16_CFG_PI_EXT_DAC_23_16_SET(params->cfg_pi_ext_dac_23_16),
-			SD10G_LANE_LANE_16_CFG_PI_EXT_DAC_23_16,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_16(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_15_CFG_PI_EXT_DAC_15_8_SET(params->cfg_pi_ext_dac_15_8),
-			SD10G_LANE_LANE_15_CFG_PI_EXT_DAC_15_8,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_15(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_26_CFG_ISCAN_EXT_DAC_7_0_SET
-				(params->cfg_iscan_ext_dac_7_0),
-			SD10G_LANE_LANE_26_CFG_ISCAN_EXT_DAC_7_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_26(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_42_CFG_CDR_KF_GEN1_2_0_SET(params->cfg_cdr_kf_gen1_2_0),
-			SD10G_LANE_LANE_42_CFG_CDR_KF_GEN1_2_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_42(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_0F_R_CDR_M_GEN1_7_0_SET(params->r_cdr_m_gen1_7_0),
-			SD10G_LANE_LANE_0F_R_CDR_M_GEN1_7_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_0F(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_24_CFG_PI_BW_GEN1_3_0_SET(params->cfg_pi_bw_gen1_3_0),
-			SD10G_LANE_LANE_24_CFG_PI_BW_GEN1_3_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_24(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_14_CFG_PI_EXT_DAC_7_0_SET(params->cfg_pi_ext_dac_7_0),
-			SD10G_LANE_LANE_14_CFG_PI_EXT_DAC_7_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_14(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_1A_CFG_PI_STEPS_SET(params->cfg_pi_steps),
-			SD10G_LANE_LANE_1A_CFG_PI_STEPS,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_1A(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_3A_CFG_MP_MAX_3_0_SET(params->cfg_mp_max_3_0),
-			SD10G_LANE_LANE_3A_CFG_MP_MAX_3_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_3A(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_31_CFG_RSTN_DFEDIG_SET(params->cfg_rstn_dfedig),
-			SD10G_LANE_LANE_31_CFG_RSTN_DFEDIG,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_31(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_48_CFG_ALOS_THR_3_0_SET(params->cfg_alos_thr_3_0),
-			SD10G_LANE_LANE_48_CFG_ALOS_THR_3_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_48(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_36_CFG_PREDRV_SLEWRATE_1_0_SET
-				(params->cfg_predrv_slewrate_1_0),
-			SD10G_LANE_LANE_36_CFG_PREDRV_SLEWRATE_1_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_36(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_32_CFG_ITX_IPCML_BASE_1_0_SET
-				(params->cfg_itx_ipcml_base_1_0),
-			SD10G_LANE_LANE_32_CFG_ITX_IPCML_BASE_1_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_32(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_37_CFG_IP_PRE_BASE_1_0_SET(params->cfg_ip_pre_base_1_0),
-			SD10G_LANE_LANE_37_CFG_IP_PRE_BASE_1_0,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_37(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_41_CFG_LANE_RESERVE_15_8_SET
-				(params->cfg_lane_reserve_15_8),
-			SD10G_LANE_LANE_41_CFG_LANE_RESERVE_15_8,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_41(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_9E_R_EN_AUTO_CDR_RSTN_SET(params->r_en_auto_cdr_rstn),
-			SD10G_LANE_LANE_9E_R_EN_AUTO_CDR_RSTN,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_9E(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_0C_CFG_OSCAL_AFE_SET(params->cfg_oscal_afe) |
-			SD10G_LANE_LANE_0C_CFG_PD_OSDAC_AFE_SET(params->cfg_pd_osdac_afe),
-			SD10G_LANE_LANE_0C_CFG_OSCAL_AFE |
-			SD10G_LANE_LANE_0C_CFG_PD_OSDAC_AFE,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_0C(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE_SET
-				(params->cfg_resetb_oscal_afe[0]),
-			SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_0B(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE_SET
-				(params->cfg_resetb_oscal_afe[1]),
-			SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_0B(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_83_R_TX_POL_INV_SET(params->r_tx_pol_inv) |
-			SD10G_LANE_LANE_83_R_RX_POL_INV_SET(params->r_rx_pol_inv),
-			SD10G_LANE_LANE_83_R_TX_POL_INV |
-			SD10G_LANE_LANE_83_R_RX_POL_INV,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_83(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_06_CFG_RX2TX_LP_EN_SET(params->cfg_rx2tx_lp_en) |
-			SD10G_LANE_LANE_06_CFG_TX2RX_LP_EN_SET(params->cfg_tx2rx_lp_en),
-			SD10G_LANE_LANE_06_CFG_RX2TX_LP_EN |
-			SD10G_LANE_LANE_06_CFG_TX2RX_LP_EN,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_06(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_0E_CFG_RXLB_EN_SET(params->cfg_rxlb_en) |
-			SD10G_LANE_LANE_0E_CFG_TXLB_EN_SET(params->cfg_txlb_en),
-			SD10G_LANE_LANE_0E_CFG_RXLB_EN |
-			SD10G_LANE_LANE_0E_CFG_TXLB_EN,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_0E(sd_index))
-		},
-		{
-			SD_LANE_SD_LANE_CFG_MACRO_RST_SET(0),
-			SD_LANE_SD_LANE_CFG_MACRO_RST,
-			sdx5_addr(regs, SD_LANE_SD_LANE_CFG(lane_index))
-		},
-		{
-			SD10G_LANE_LANE_50_CFG_SSC_RESETB_SET(1),
-			SD10G_LANE_LANE_50_CFG_SSC_RESETB,
-			sdx5_inst_addr(sd_inst, SD10G_LANE_LANE_50(sd_index))
-		},
-		{
-			SD10G_LANE_LANE_50_CFG_SSC_RESETB_SET(1),
-			SD10G_LANE_LANE_50_CFG_SSC_RESETB,
-			sdx5_addr(regs, SD10G_LANE_LANE_50(sd_index))
-		},
-		{
-			SD_LANE_MISC_SD_125_RST_DIS_SET(params->fx_100),
-			SD_LANE_MISC_SD_125_RST_DIS,
-			sdx5_addr(regs, SD_LANE_MISC(lane_index))
-		},
-		{
-			SD_LANE_MISC_RX_ENA_SET(params->fx_100),
-			SD_LANE_MISC_RX_ENA,
-			sdx5_addr(regs, SD_LANE_MISC(lane_index))
-		},
-		{
-			SD_LANE_MISC_MUX_ENA_SET(params->fx_100),
-			SD_LANE_MISC_MUX_ENA,
-			sdx5_addr(regs, SD_LANE_MISC(lane_index))
-		},
-	};
+	struct sparx5_serdes_private *priv = macro->priv;
+	void __iomem **regs = priv->regs;
+	struct device *dev = priv->dev;
+	u32 lane_index = macro->sidx;
+	u32 sd_index = macro->stpidx;
+	void __iomem *sd_inst;
 	u32 value;
-	int idx;
 
-	for (idx = 0; idx < ARRAY_SIZE(item); ++idx)
-		sdx5_rmw_addr(item[idx].value, item[idx].mask, item[idx].addr);
+	if (params->is_6g)
+		sd_inst = sdx5_inst_get(priv, TARGET_SD6G_LANE, sd_index);
+	else
+		sd_inst = sdx5_inst_get(priv, TARGET_SD10G_LANE, sd_index);
+
+	sdx5_rmw(SD_LANE_SD_LANE_CFG_MACRO_RST_SET(1),
+		 SD_LANE_SD_LANE_CFG_MACRO_RST,
+		 priv,
+		 SD_LANE_SD_LANE_CFG(lane_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_93_R_DWIDTHCTRL_FROM_HWT_SET(0x0) |
+		      SD10G_LANE_LANE_93_R_REG_MANUAL_SET(0x1) |
+		      SD10G_LANE_LANE_93_R_AUXCKSEL_FROM_HWT_SET(0x1) |
+		      SD10G_LANE_LANE_93_R_LANE_ID_FROM_HWT_SET(0x1) |
+		      SD10G_LANE_LANE_93_R_EN_RATECHG_CTRL_SET(0x0),
+		      SD10G_LANE_LANE_93_R_DWIDTHCTRL_FROM_HWT |
+		      SD10G_LANE_LANE_93_R_REG_MANUAL |
+		      SD10G_LANE_LANE_93_R_AUXCKSEL_FROM_HWT |
+		      SD10G_LANE_LANE_93_R_LANE_ID_FROM_HWT |
+		      SD10G_LANE_LANE_93_R_EN_RATECHG_CTRL,
+		      sd_inst,
+		      SD10G_LANE_LANE_93(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_94_R_ISCAN_REG_SET(0x1) |
+		      SD10G_LANE_LANE_94_R_TXEQ_REG_SET(0x1) |
+		      SD10G_LANE_LANE_94_R_MISC_REG_SET(0x1) |
+		      SD10G_LANE_LANE_94_R_SWING_REG_SET(0x1),
+		      SD10G_LANE_LANE_94_R_ISCAN_REG |
+		      SD10G_LANE_LANE_94_R_TXEQ_REG |
+		      SD10G_LANE_LANE_94_R_MISC_REG |
+		      SD10G_LANE_LANE_94_R_SWING_REG,
+		      sd_inst,
+		      SD10G_LANE_LANE_94(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_9E_R_RXEQ_REG_SET(0x1),
+		      SD10G_LANE_LANE_9E_R_RXEQ_REG,
+		      sd_inst,
+		      SD10G_LANE_LANE_9E(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_A1_R_SSC_FROM_HWT_SET(0x0) |
+		      SD10G_LANE_LANE_A1_R_CDR_FROM_HWT_SET(0x0) |
+		      SD10G_LANE_LANE_A1_R_PCLK_GATING_FROM_HWT_SET(0x1),
+		      SD10G_LANE_LANE_A1_R_SSC_FROM_HWT |
+		      SD10G_LANE_LANE_A1_R_CDR_FROM_HWT |
+		      SD10G_LANE_LANE_A1_R_PCLK_GATING_FROM_HWT,
+		      sd_inst,
+		      SD10G_LANE_LANE_A1(sd_index));
+
+	sdx5_rmw(SD_LANE_SD_LANE_CFG_RX_REF_SEL_SET(params->cmu_sel) |
+		 SD_LANE_SD_LANE_CFG_TX_REF_SEL_SET(params->cmu_sel),
+		 SD_LANE_SD_LANE_CFG_RX_REF_SEL |
+		 SD_LANE_SD_LANE_CFG_TX_REF_SEL,
+		 priv,
+		 SD_LANE_SD_LANE_CFG(lane_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_40_CFG_LANE_RESERVE_7_0_SET
+		      (params->cfg_lane_reserve_7_0),
+		      SD10G_LANE_LANE_40_CFG_LANE_RESERVE_7_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_40(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_50_CFG_SSC_RTL_CLK_SEL_SET
+		      (params->cfg_ssc_rtl_clk_sel),
+		      SD10G_LANE_LANE_50_CFG_SSC_RTL_CLK_SEL,
+		      sd_inst,
+		      SD10G_LANE_LANE_50(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_35_CFG_TXRATE_1_0_SET
+		      (params->cfg_txrate_1_0) |
+		      SD10G_LANE_LANE_35_CFG_RXRATE_1_0_SET
+		      (params->cfg_rxrate_1_0),
+		      SD10G_LANE_LANE_35_CFG_TXRATE_1_0 |
+		      SD10G_LANE_LANE_35_CFG_RXRATE_1_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_35(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_94_R_DWIDTHCTRL_2_0_SET
+		      (params->r_d_width_ctrl_2_0),
+		      SD10G_LANE_LANE_94_R_DWIDTHCTRL_2_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_94(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_01_CFG_PMA_TX_CK_BITWIDTH_2_0_SET
+		      (params->cfg_pma_tx_ck_bitwidth_2_0),
+		      SD10G_LANE_LANE_01_CFG_PMA_TX_CK_BITWIDTH_2_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_01(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_30_CFG_RXDIV_SEL_2_0_SET
+		      (params->cfg_rxdiv_sel_2_0),
+		      SD10G_LANE_LANE_30_CFG_RXDIV_SEL_2_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_30(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_A2_R_PCS2PMA_PHYMODE_4_0_SET
+		      (params->r_pcs2pma_phymode_4_0),
+		      SD10G_LANE_LANE_A2_R_PCS2PMA_PHYMODE_4_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_A2(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_13_CFG_CDRCK_EN_SET(params->cfg_cdrck_en),
+		      SD10G_LANE_LANE_13_CFG_CDRCK_EN,
+		      sd_inst,
+		      SD10G_LANE_LANE_13(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_23_CFG_DFECK_EN_SET
+		      (params->cfg_dfeck_en) |
+		      SD10G_LANE_LANE_23_CFG_DFE_PD_SET(params->cfg_dfe_pd) |
+		      SD10G_LANE_LANE_23_CFG_ERRAMP_PD_SET
+		      (params->cfg_erramp_pd),
+		      SD10G_LANE_LANE_23_CFG_DFECK_EN |
+		      SD10G_LANE_LANE_23_CFG_DFE_PD |
+		      SD10G_LANE_LANE_23_CFG_ERRAMP_PD,
+		      sd_inst,
+		      SD10G_LANE_LANE_23(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_22_CFG_DFETAP_EN_5_1_SET
+		      (params->cfg_dfetap_en_5_1),
+		      SD10G_LANE_LANE_22_CFG_DFETAP_EN_5_1,
+		      sd_inst,
+		      SD10G_LANE_LANE_22(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_1A_CFG_PI_DFE_EN_SET
+		      (params->cfg_pi_DFE_en),
+		      SD10G_LANE_LANE_1A_CFG_PI_DFE_EN,
+		      sd_inst,
+		      SD10G_LANE_LANE_1A(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_02_CFG_EN_ADV_SET(params->cfg_en_adv) |
+		      SD10G_LANE_LANE_02_CFG_EN_MAIN_SET(params->cfg_en_main) |
+		      SD10G_LANE_LANE_02_CFG_EN_DLY_SET(params->cfg_en_dly) |
+		      SD10G_LANE_LANE_02_CFG_TAP_ADV_3_0_SET
+		      (params->cfg_tap_adv_3_0),
+		      SD10G_LANE_LANE_02_CFG_EN_ADV |
+		      SD10G_LANE_LANE_02_CFG_EN_MAIN |
+		      SD10G_LANE_LANE_02_CFG_EN_DLY |
+		      SD10G_LANE_LANE_02_CFG_TAP_ADV_3_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_02(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_03_CFG_TAP_MAIN_SET(params->cfg_tap_main),
+		      SD10G_LANE_LANE_03_CFG_TAP_MAIN,
+		      sd_inst,
+		      SD10G_LANE_LANE_03(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_04_CFG_TAP_DLY_4_0_SET
+		      (params->cfg_tap_dly_4_0),
+		      SD10G_LANE_LANE_04_CFG_TAP_DLY_4_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_04(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_2F_CFG_VGA_CTRL_3_0_SET
+		      (params->cfg_vga_ctrl_3_0),
+		      SD10G_LANE_LANE_2F_CFG_VGA_CTRL_3_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_2F(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_2F_CFG_VGA_CP_2_0_SET
+		      (params->cfg_vga_cp_2_0),
+		      SD10G_LANE_LANE_2F_CFG_VGA_CP_2_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_2F(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0B_CFG_EQ_RES_3_0_SET
+		      (params->cfg_eq_res_3_0),
+		      SD10G_LANE_LANE_0B_CFG_EQ_RES_3_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_0B(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0D_CFG_EQR_BYP_SET(params->cfg_eq_r_byp),
+		      SD10G_LANE_LANE_0D_CFG_EQR_BYP,
+		      sd_inst,
+		      SD10G_LANE_LANE_0D(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0E_CFG_EQC_FORCE_3_0_SET
+		      (params->cfg_eq_c_force_3_0) |
+		      SD10G_LANE_LANE_0E_CFG_SUM_SETCM_EN_SET
+		      (params->cfg_sum_setcm_en),
+		      SD10G_LANE_LANE_0E_CFG_EQC_FORCE_3_0 |
+		      SD10G_LANE_LANE_0E_CFG_SUM_SETCM_EN,
+		      sd_inst,
+		      SD10G_LANE_LANE_0E(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_23_CFG_EN_DFEDIG_SET
+		      (params->cfg_en_dfedig),
+		      SD10G_LANE_LANE_23_CFG_EN_DFEDIG,
+		      sd_inst,
+		      SD10G_LANE_LANE_23(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_06_CFG_EN_PREEMPH_SET
+		      (params->cfg_en_preemph),
+		      SD10G_LANE_LANE_06_CFG_EN_PREEMPH,
+		      sd_inst,
+		      SD10G_LANE_LANE_06(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_33_CFG_ITX_IPPREEMP_BASE_1_0_SET
+		      (params->cfg_itx_ippreemp_base_1_0) |
+		      SD10G_LANE_LANE_33_CFG_ITX_IPDRIVER_BASE_2_0_SET
+		      (params->cfg_itx_ipdriver_base_2_0),
+		      SD10G_LANE_LANE_33_CFG_ITX_IPPREEMP_BASE_1_0 |
+		      SD10G_LANE_LANE_33_CFG_ITX_IPDRIVER_BASE_2_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_33(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_52_CFG_IBIAS_TUNE_RESERVE_5_0_SET
+		      (params->cfg_ibias_tune_reserve_5_0),
+		      SD10G_LANE_LANE_52_CFG_IBIAS_TUNE_RESERVE_5_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_52(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_37_CFG_TXSWING_HALF_SET
+		      (params->cfg_txswing_half),
+		      SD10G_LANE_LANE_37_CFG_TXSWING_HALF,
+		      sd_inst,
+		      SD10G_LANE_LANE_37(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_3C_CFG_DIS_2NDORDER_SET
+		      (params->cfg_dis_2nd_order),
+		      SD10G_LANE_LANE_3C_CFG_DIS_2NDORDER,
+		      sd_inst,
+		      SD10G_LANE_LANE_3C(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_39_CFG_RX_SSC_LH_SET
+		      (params->cfg_rx_ssc_lh),
+		      SD10G_LANE_LANE_39_CFG_RX_SSC_LH,
+		      sd_inst,
+		      SD10G_LANE_LANE_39(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_1A_CFG_PI_FLOOP_STEPS_1_0_SET
+		      (params->cfg_pi_floop_steps_1_0),
+		      SD10G_LANE_LANE_1A_CFG_PI_FLOOP_STEPS_1_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_1A(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_16_CFG_PI_EXT_DAC_23_16_SET
+		      (params->cfg_pi_ext_dac_23_16),
+		      SD10G_LANE_LANE_16_CFG_PI_EXT_DAC_23_16,
+		      sd_inst,
+		      SD10G_LANE_LANE_16(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_15_CFG_PI_EXT_DAC_15_8_SET
+		      (params->cfg_pi_ext_dac_15_8),
+		      SD10G_LANE_LANE_15_CFG_PI_EXT_DAC_15_8,
+		      sd_inst,
+		      SD10G_LANE_LANE_15(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_26_CFG_ISCAN_EXT_DAC_7_0_SET
+		      (params->cfg_iscan_ext_dac_7_0),
+		      SD10G_LANE_LANE_26_CFG_ISCAN_EXT_DAC_7_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_26(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_42_CFG_CDR_KF_GEN1_2_0_SET
+		      (params->cfg_cdr_kf_gen1_2_0),
+		      SD10G_LANE_LANE_42_CFG_CDR_KF_GEN1_2_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_42(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0F_R_CDR_M_GEN1_7_0_SET
+		      (params->r_cdr_m_gen1_7_0),
+		      SD10G_LANE_LANE_0F_R_CDR_M_GEN1_7_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_0F(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_24_CFG_PI_BW_GEN1_3_0_SET
+		      (params->cfg_pi_bw_gen1_3_0),
+		      SD10G_LANE_LANE_24_CFG_PI_BW_GEN1_3_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_24(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_14_CFG_PI_EXT_DAC_7_0_SET
+		      (params->cfg_pi_ext_dac_7_0),
+		      SD10G_LANE_LANE_14_CFG_PI_EXT_DAC_7_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_14(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_1A_CFG_PI_STEPS_SET(params->cfg_pi_steps),
+		      SD10G_LANE_LANE_1A_CFG_PI_STEPS,
+		      sd_inst,
+		      SD10G_LANE_LANE_1A(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_3A_CFG_MP_MAX_3_0_SET
+		      (params->cfg_mp_max_3_0),
+		      SD10G_LANE_LANE_3A_CFG_MP_MAX_3_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_3A(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_31_CFG_RSTN_DFEDIG_SET
+		      (params->cfg_rstn_dfedig),
+		      SD10G_LANE_LANE_31_CFG_RSTN_DFEDIG,
+		      sd_inst,
+		      SD10G_LANE_LANE_31(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_48_CFG_ALOS_THR_3_0_SET
+		      (params->cfg_alos_thr_3_0),
+		      SD10G_LANE_LANE_48_CFG_ALOS_THR_3_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_48(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_36_CFG_PREDRV_SLEWRATE_1_0_SET
+		      (params->cfg_predrv_slewrate_1_0),
+		      SD10G_LANE_LANE_36_CFG_PREDRV_SLEWRATE_1_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_36(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_32_CFG_ITX_IPCML_BASE_1_0_SET
+		      (params->cfg_itx_ipcml_base_1_0),
+		      SD10G_LANE_LANE_32_CFG_ITX_IPCML_BASE_1_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_32(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_37_CFG_IP_PRE_BASE_1_0_SET
+		      (params->cfg_ip_pre_base_1_0),
+		      SD10G_LANE_LANE_37_CFG_IP_PRE_BASE_1_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_37(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_41_CFG_LANE_RESERVE_15_8_SET
+		      (params->cfg_lane_reserve_15_8),
+		      SD10G_LANE_LANE_41_CFG_LANE_RESERVE_15_8,
+		      sd_inst,
+		      SD10G_LANE_LANE_41(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_9E_R_EN_AUTO_CDR_RSTN_SET
+		      (params->r_en_auto_cdr_rstn),
+		      SD10G_LANE_LANE_9E_R_EN_AUTO_CDR_RSTN,
+		      sd_inst,
+		      SD10G_LANE_LANE_9E(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0C_CFG_OSCAL_AFE_SET
+		      (params->cfg_oscal_afe) |
+		      SD10G_LANE_LANE_0C_CFG_PD_OSDAC_AFE_SET
+		      (params->cfg_pd_osdac_afe),
+		      SD10G_LANE_LANE_0C_CFG_OSCAL_AFE |
+		      SD10G_LANE_LANE_0C_CFG_PD_OSDAC_AFE,
+		      sd_inst,
+		      SD10G_LANE_LANE_0C(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE_SET
+		      (params->cfg_resetb_oscal_afe[0]),
+		      SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE,
+		      sd_inst,
+		      SD10G_LANE_LANE_0B(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE_SET
+		      (params->cfg_resetb_oscal_afe[1]),
+		      SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE,
+		      sd_inst,
+		      SD10G_LANE_LANE_0B(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_83_R_TX_POL_INV_SET
+		      (params->r_tx_pol_inv) |
+		      SD10G_LANE_LANE_83_R_RX_POL_INV_SET
+		      (params->r_rx_pol_inv),
+		      SD10G_LANE_LANE_83_R_TX_POL_INV |
+		      SD10G_LANE_LANE_83_R_RX_POL_INV,
+		      sd_inst,
+		      SD10G_LANE_LANE_83(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_06_CFG_RX2TX_LP_EN_SET
+		      (params->cfg_rx2tx_lp_en) |
+		      SD10G_LANE_LANE_06_CFG_TX2RX_LP_EN_SET
+		      (params->cfg_tx2rx_lp_en),
+		      SD10G_LANE_LANE_06_CFG_RX2TX_LP_EN |
+		      SD10G_LANE_LANE_06_CFG_TX2RX_LP_EN,
+		      sd_inst,
+		      SD10G_LANE_LANE_06(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0E_CFG_RXLB_EN_SET(params->cfg_rxlb_en) |
+		      SD10G_LANE_LANE_0E_CFG_TXLB_EN_SET(params->cfg_txlb_en),
+		      SD10G_LANE_LANE_0E_CFG_RXLB_EN |
+		      SD10G_LANE_LANE_0E_CFG_TXLB_EN,
+		      sd_inst,
+		      SD10G_LANE_LANE_0E(sd_index));
+
+	sdx5_rmw(SD_LANE_SD_LANE_CFG_MACRO_RST_SET(0),
+		 SD_LANE_SD_LANE_CFG_MACRO_RST,
+		 priv,
+		 SD_LANE_SD_LANE_CFG(lane_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_50_CFG_SSC_RESETB_SET(1),
+		      SD10G_LANE_LANE_50_CFG_SSC_RESETB,
+		      sd_inst,
+		      SD10G_LANE_LANE_50(sd_index));
+
+	sdx5_rmw(SD10G_LANE_LANE_50_CFG_SSC_RESETB_SET(1),
+		 SD10G_LANE_LANE_50_CFG_SSC_RESETB,
+		 priv,
+		 SD10G_LANE_LANE_50(sd_index));
+
+	sdx5_rmw(SD_LANE_MISC_SD_125_RST_DIS_SET(params->fx_100),
+		 SD_LANE_MISC_SD_125_RST_DIS,
+		 priv,
+		 SD_LANE_MISC(lane_index));
+
+	sdx5_rmw(SD_LANE_MISC_RX_ENA_SET(params->fx_100),
+		 SD_LANE_MISC_RX_ENA,
+		 priv,
+		 SD_LANE_MISC(lane_index));
+
+	sdx5_rmw(SD_LANE_MISC_MUX_ENA_SET(params->fx_100),
+		 SD_LANE_MISC_MUX_ENA,
+		 priv,
+		 SD_LANE_MISC(lane_index));
+
 	usleep_range(3000, 6000);
 
 	value = readl(sdx5_addr(regs, SD_LANE_SD_LANE_STAT(lane_index)));
@@ -1793,21 +1838,23 @@ static int sparx5_sd10g28_apply_params(struct device *dev,
 		return -EINVAL;
 	}
 
-	sdx5_rmw_addr(SD_LANE_SD_SER_RST_SER_RST_SET(0x0),
+	sdx5_rmw(SD_LANE_SD_SER_RST_SER_RST_SET(0x0),
 		 SD_LANE_SD_SER_RST_SER_RST,
-		 sdx5_addr(regs, SD_LANE_SD_SER_RST(lane_index)));
+		 priv,
+		 SD_LANE_SD_SER_RST(lane_index));
 
-	sdx5_rmw_addr(SD_LANE_SD_DES_RST_DES_RST_SET(0x0),
+	sdx5_rmw(SD_LANE_SD_DES_RST_DES_RST_SET(0x0),
 		 SD_LANE_SD_DES_RST_DES_RST,
-		 sdx5_addr(regs, SD_LANE_SD_DES_RST(lane_index)));
+		 priv,
+		 SD_LANE_SD_DES_RST(lane_index));
 
 	return 0;
 }
 
 static int sparx5_sd25g28_config(struct sparx5_serdes_macro *macro, bool reset)
 {
-	struct sparx5_sd25g28_mode_preset mode;
 	struct sparx5_sd25g28_media_preset media = media_presets_25g[macro->media];
+	struct sparx5_sd25g28_mode_preset mode;
 	struct sparx5_sd25g28_args args = {
 		.rxinvert = 1,
 		.txinvert = 0,
@@ -1823,16 +1870,14 @@ static int sparx5_sd25g28_config(struct sparx5_serdes_macro *macro, bool reset)
 		return err;
 	sparx5_sd25g28_get_params(macro, &media, &mode, &args, &params);
 	sparx5_sd25g28_reset(macro->priv->regs, &params, macro->stpidx);
-	return sparx5_sd25g28_apply_params(macro->priv->dev,
-					   macro->priv->regs,
-					   &params,
-					   macro->stpidx);
+	return sparx5_sd25g28_apply_params(macro, &params);
 }
 
 static int sparx5_sd10g28_config(struct sparx5_serdes_macro *macro, bool reset)
 {
-	struct sparx5_sd10g28_mode_preset mode;
 	struct sparx5_sd10g28_media_preset media = media_presets_10g[macro->media];
+	struct sparx5_sd10g28_mode_preset mode;
+	struct sparx5_sd10g28_params params;
 	struct sparx5_sd10g28_args args = {
 		.is_6g = (macro->serdestype == SPX5_SDT_6G),
 		.txinvert = 0,
@@ -1840,36 +1885,21 @@ static int sparx5_sd10g28_config(struct sparx5_serdes_macro *macro, bool reset)
 		.txswing = 240,
 		.reg_rst = reset,
 	};
-	struct sparx5_sd10g28_params params;
-	u32 sd_index = macro->stpidx;
-	void __iomem *sd_inst;
 	int err;
 
 	err = sparx5_sd10g28_get_mode_preset(macro, &mode, &args);
 	if (err)
 		return err;
 	sparx5_sd10g28_get_params(macro, &media, &mode, &args, &params);
-	sparx5_sd10g28_reset(macro->priv->regs,
-				    &params,
-				    macro->sidx,
-				    macro->stpidx);
-	if (macro->serdestype == SPX5_SDT_6G)
-		sd_inst = macro->priv->regs[TARGET_SD6G_LANE + sd_index];
-	else
-		sd_inst = macro->priv->regs[TARGET_SD10G_LANE + sd_index];
-	return sparx5_sd10g28_apply_params(macro->priv->dev,
-					   macro->priv->regs,
-					   &params,
-					   sd_inst,
-					   macro->sidx,
-					   sd_index);
+	sparx5_sd10g28_reset(macro->priv->regs, macro->sidx);
+	return sparx5_sd10g28_apply_params(macro, &params);
 }
 
 /* Power down serdes TX driver */
 static int sparx5_serdes_power_save(struct sparx5_serdes_macro *macro, u32 pwdn)
 {
-	void __iomem *sd_inst;
 	struct sparx5_serdes_private *priv = macro->priv;
+	void __iomem *sd_inst;
 
 	if (macro->serdestype == SPX5_SDT_6G)
 		sd_inst = sdx5_inst_get(priv, TARGET_SD6G_LANE, macro->stpidx);
@@ -1909,93 +1939,97 @@ static int sparx5_serdes_clock_config(struct sparx5_serdes_macro *macro)
 	return 0;
 }
 
-static int sparx5_cmu_apply_cfg(struct device *dev,
-			       void __iomem *regs[],
-			       u32 cmu_idx,
-			       void __iomem *cmu_tgt,
-			       void __iomem *cmu_cfg_tgt,
-			       u32 spd10g)
+static int sparx5_cmu_apply_cfg(struct sparx5_serdes_private *priv,
+				u32 cmu_idx,
+				void __iomem *cmu_tgt,
+				void __iomem *cmu_cfg_tgt,
+				u32 spd10g)
 {
-	struct sparx5_serdes_regval item[] = {
-		{
-			SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST_SET(1),
-			SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST,
-			sdx5_inst_addr(cmu_cfg_tgt, SD_CMU_CFG_SD_CMU_CFG(cmu_idx))
-		},
-		{
-			SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST_SET(0),
-			SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST,
-			sdx5_inst_addr(cmu_cfg_tgt, SD_CMU_CFG_SD_CMU_CFG(cmu_idx))
-		},
-		{
-			SD_CMU_CFG_SD_CMU_CFG_CMU_RST_SET(1),
-			SD_CMU_CFG_SD_CMU_CFG_CMU_RST,
-			sdx5_inst_addr(cmu_cfg_tgt, SD_CMU_CFG_SD_CMU_CFG(cmu_idx))
-		},
-		{
-			SD_CMU_CMU_45_R_DWIDTHCTRL_FROM_HWT_SET(0x1) |
-			SD_CMU_CMU_45_R_REFCK_SSC_EN_FROM_HWT_SET(0x1) |
-			SD_CMU_CMU_45_R_LINK_BUF_EN_FROM_HWT_SET(0x1) |
-			SD_CMU_CMU_45_R_BIAS_EN_FROM_HWT_SET(0x1) |
-			SD_CMU_CMU_45_R_EN_RATECHG_CTRL_SET(0x0),
-			SD_CMU_CMU_45_R_DWIDTHCTRL_FROM_HWT |
-			SD_CMU_CMU_45_R_REFCK_SSC_EN_FROM_HWT |
-			SD_CMU_CMU_45_R_LINK_BUF_EN_FROM_HWT |
-			SD_CMU_CMU_45_R_BIAS_EN_FROM_HWT |
-			SD_CMU_CMU_45_R_EN_RATECHG_CTRL,
-			sdx5_inst_addr(cmu_tgt, SD_CMU_CMU_45(cmu_idx))
-		},
-		{
-			SD_CMU_CMU_47_R_PCS2PMA_PHYMODE_4_0_SET(0),
-			SD_CMU_CMU_47_R_PCS2PMA_PHYMODE_4_0,
-			sdx5_inst_addr(cmu_tgt, SD_CMU_CMU_47(cmu_idx))
-		},
-		{
-			SD_CMU_CMU_1B_CFG_RESERVE_7_0_SET(0),
-			SD_CMU_CMU_1B_CFG_RESERVE_7_0,
-			sdx5_inst_addr(cmu_tgt, SD_CMU_CMU_1B(cmu_idx))
-		},
-		{
-			SD_CMU_CMU_0D_CFG_JC_BYP_SET(0x1),
-			SD_CMU_CMU_0D_CFG_JC_BYP,
-			sdx5_inst_addr(cmu_tgt, SD_CMU_CMU_0D(cmu_idx))
-		},
-		{
-			SD_CMU_CMU_1F_CFG_VTUNE_SEL_SET(1),
-			SD_CMU_CMU_1F_CFG_VTUNE_SEL,
-			sdx5_inst_addr(cmu_tgt, SD_CMU_CMU_1F(cmu_idx))
-		},
-		{
-			SD_CMU_CMU_00_CFG_PLL_TP_SEL_1_0_SET(3),
-			SD_CMU_CMU_00_CFG_PLL_TP_SEL_1_0,
-			sdx5_inst_addr(cmu_tgt, SD_CMU_CMU_00(cmu_idx))
-		},
-		{
-			SD_CMU_CMU_05_CFG_BIAS_TP_SEL_1_0_SET(3),
-			SD_CMU_CMU_05_CFG_BIAS_TP_SEL_1_0,
-			sdx5_inst_addr(cmu_tgt, SD_CMU_CMU_05(cmu_idx))
-		},
-		{
-			SD_CMU_CMU_30_R_PLL_DLOL_EN_SET(1),
-			SD_CMU_CMU_30_R_PLL_DLOL_EN,
-			sdx5_inst_addr(cmu_tgt, SD_CMU_CMU_30(cmu_idx))
-		},
-		{
-			SD_CMU_CMU_09_CFG_SW_10G_SET(spd10g),
-			SD_CMU_CMU_09_CFG_SW_10G,
-			sdx5_inst_addr(cmu_tgt, SD_CMU_CMU_09(cmu_idx))
-		},
-		{
-			SD_CMU_CFG_SD_CMU_CFG_CMU_RST_SET(0),
-			SD_CMU_CFG_SD_CMU_CFG_CMU_RST,
-			sdx5_inst_addr(cmu_cfg_tgt, SD_CMU_CFG_SD_CMU_CFG(cmu_idx))
-		},
-	};
+	void __iomem **regs = priv->regs;
+	struct device *dev = priv->dev;
 	int value;
-	int idx;
 
-	for (idx = 0; idx < ARRAY_SIZE(item); ++idx)
-		sdx5_rmw_addr(item[idx].value, item[idx].mask, item[idx].addr);
+	cmu_tgt = sdx5_inst_get(priv, TARGET_SD_CMU, cmu_idx);
+	cmu_cfg_tgt = sdx5_inst_get(priv, TARGET_SD_CMU_CFG, cmu_idx);
+
+	if (cmu_idx == 1 || cmu_idx == 4 || cmu_idx == 7 ||
+	    cmu_idx == 10 || cmu_idx == 13) {
+		spd10g = 0;
+	}
+
+	sdx5_inst_rmw(SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST_SET(1),
+		      SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST,
+		      cmu_cfg_tgt,
+		      SD_CMU_CFG_SD_CMU_CFG(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST_SET(0),
+		      SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST,
+		      cmu_cfg_tgt,
+		      SD_CMU_CFG_SD_CMU_CFG(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CFG_SD_CMU_CFG_CMU_RST_SET(1),
+		      SD_CMU_CFG_SD_CMU_CFG_CMU_RST,
+		      cmu_cfg_tgt,
+		      SD_CMU_CFG_SD_CMU_CFG(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_45_R_DWIDTHCTRL_FROM_HWT_SET(0x1) |
+		      SD_CMU_CMU_45_R_REFCK_SSC_EN_FROM_HWT_SET(0x1) |
+		      SD_CMU_CMU_45_R_LINK_BUF_EN_FROM_HWT_SET(0x1) |
+		      SD_CMU_CMU_45_R_BIAS_EN_FROM_HWT_SET(0x1) |
+		      SD_CMU_CMU_45_R_EN_RATECHG_CTRL_SET(0x0),
+		      SD_CMU_CMU_45_R_DWIDTHCTRL_FROM_HWT |
+		      SD_CMU_CMU_45_R_REFCK_SSC_EN_FROM_HWT |
+		      SD_CMU_CMU_45_R_LINK_BUF_EN_FROM_HWT |
+		      SD_CMU_CMU_45_R_BIAS_EN_FROM_HWT |
+		      SD_CMU_CMU_45_R_EN_RATECHG_CTRL,
+		      cmu_tgt,
+		      SD_CMU_CMU_45(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_47_R_PCS2PMA_PHYMODE_4_0_SET(0),
+		      SD_CMU_CMU_47_R_PCS2PMA_PHYMODE_4_0,
+		      cmu_tgt,
+		      SD_CMU_CMU_47(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_1B_CFG_RESERVE_7_0_SET(0),
+		      SD_CMU_CMU_1B_CFG_RESERVE_7_0,
+		      cmu_tgt,
+		      SD_CMU_CMU_1B(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_0D_CFG_JC_BYP_SET(0x1),
+		      SD_CMU_CMU_0D_CFG_JC_BYP,
+		      cmu_tgt,
+		      SD_CMU_CMU_0D(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_1F_CFG_VTUNE_SEL_SET(1),
+		      SD_CMU_CMU_1F_CFG_VTUNE_SEL,
+		      cmu_tgt,
+		      SD_CMU_CMU_1F(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_00_CFG_PLL_TP_SEL_1_0_SET(3),
+		      SD_CMU_CMU_00_CFG_PLL_TP_SEL_1_0,
+		      cmu_tgt,
+		      SD_CMU_CMU_00(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_05_CFG_BIAS_TP_SEL_1_0_SET(3),
+		      SD_CMU_CMU_05_CFG_BIAS_TP_SEL_1_0,
+		      cmu_tgt,
+		      SD_CMU_CMU_05(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_30_R_PLL_DLOL_EN_SET(1),
+		      SD_CMU_CMU_30_R_PLL_DLOL_EN,
+		      cmu_tgt,
+		      SD_CMU_CMU_30(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_09_CFG_SW_10G_SET(spd10g),
+		      SD_CMU_CMU_09_CFG_SW_10G,
+		      cmu_tgt,
+		      SD_CMU_CMU_09(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CFG_SD_CMU_CFG_CMU_RST_SET(0),
+		      SD_CMU_CFG_SD_CMU_CFG_CMU_RST,
+		      cmu_cfg_tgt,
+		      SD_CMU_CFG_SD_CMU_CFG(cmu_idx));
+
 	msleep(20);
 
 	sdx5_inst_rmw(SD_CMU_CMU_44_R_PLL_RSTN_SET(0),
@@ -2037,8 +2071,7 @@ static int sparx5_cmu_cfg(struct sparx5_serdes_private *priv, u32 cmu_idx)
 	cmu_tgt = sdx5_inst_get(priv, TARGET_SD_CMU, cmu_idx);
 	cmu_cfg_tgt = sdx5_inst_get(priv, TARGET_SD_CMU_CFG, cmu_idx);
 
-	return sparx5_cmu_apply_cfg(priv->dev, priv->regs, cmu_idx, cmu_tgt,
-				    cmu_cfg_tgt, spd10g);
+	return sparx5_cmu_apply_cfg(priv, cmu_idx, cmu_tgt, cmu_cfg_tgt, spd10g);
 }
 
 static int sparx5_serdes_cmu_enable(struct sparx5_serdes_private *priv)
-- 
2.31.1

