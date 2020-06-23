Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA90B2060C3
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 22:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390179AbgFWUqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:46:19 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:43985 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392823AbgFWUqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:46:14 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKkBal019587;
        Tue, 23 Jun 2020 13:46:12 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 2/2] cxgb4: move device dump arrays in header to C file
Date:   Wed, 24 Jun 2020 02:03:23 +0530
Message-Id: <590a1e0a1d870de4dec23516bff65fa436a4cc76.1592941598.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1592941598.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592941598.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1592941598.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592941598.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move all arrays related to device dump in header file to C file.
Also, move the function that shares the arrays to the same C file.

Fixes following warnings reported by make W=1 in several places:
cudbg_entity.h:513:18: warning: 't6_hma_ireg_array' defined but not
used [-Wunused-const-variable=]
  513 | static const u32 t6_hma_ireg_array[][IREG_NUM_ELEM] = {

Fixes: a7975a2f9a79 ("cxgb4: collect register dump")
Fixes: 17b332f48074 ("cxgb4: add support to read serial flash")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cudbg_entity.h | 161 -------
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 406 ++++++++++++++++++
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.h    |   2 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c  | 248 +----------
 4 files changed, 410 insertions(+), 407 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h b/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
index dcab94cc2dee..876f90e5795e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
@@ -350,167 +350,6 @@ struct cudbg_qdesc_info {
 
 #define IREG_NUM_ELEM 4
 
-static const u32 t6_tp_pio_array[][IREG_NUM_ELEM] = {
-	{0x7e40, 0x7e44, 0x020, 28}, /* t6_tp_pio_regs_20_to_3b */
-	{0x7e40, 0x7e44, 0x040, 10}, /* t6_tp_pio_regs_40_to_49 */
-	{0x7e40, 0x7e44, 0x050, 10}, /* t6_tp_pio_regs_50_to_59 */
-	{0x7e40, 0x7e44, 0x060, 14}, /* t6_tp_pio_regs_60_to_6d */
-	{0x7e40, 0x7e44, 0x06F, 1}, /* t6_tp_pio_regs_6f */
-	{0x7e40, 0x7e44, 0x070, 6}, /* t6_tp_pio_regs_70_to_75 */
-	{0x7e40, 0x7e44, 0x130, 18}, /* t6_tp_pio_regs_130_to_141 */
-	{0x7e40, 0x7e44, 0x145, 19}, /* t6_tp_pio_regs_145_to_157 */
-	{0x7e40, 0x7e44, 0x160, 1}, /* t6_tp_pio_regs_160 */
-	{0x7e40, 0x7e44, 0x230, 25}, /* t6_tp_pio_regs_230_to_248 */
-	{0x7e40, 0x7e44, 0x24a, 3}, /* t6_tp_pio_regs_24c */
-	{0x7e40, 0x7e44, 0x8C0, 1} /* t6_tp_pio_regs_8c0 */
-};
-
-static const u32 t5_tp_pio_array[][IREG_NUM_ELEM] = {
-	{0x7e40, 0x7e44, 0x020, 28}, /* t5_tp_pio_regs_20_to_3b */
-	{0x7e40, 0x7e44, 0x040, 19}, /* t5_tp_pio_regs_40_to_52 */
-	{0x7e40, 0x7e44, 0x054, 2}, /* t5_tp_pio_regs_54_to_55 */
-	{0x7e40, 0x7e44, 0x060, 13}, /* t5_tp_pio_regs_60_to_6c */
-	{0x7e40, 0x7e44, 0x06F, 1}, /* t5_tp_pio_regs_6f */
-	{0x7e40, 0x7e44, 0x120, 4}, /* t5_tp_pio_regs_120_to_123 */
-	{0x7e40, 0x7e44, 0x12b, 2}, /* t5_tp_pio_regs_12b_to_12c */
-	{0x7e40, 0x7e44, 0x12f, 21}, /* t5_tp_pio_regs_12f_to_143 */
-	{0x7e40, 0x7e44, 0x145, 19}, /* t5_tp_pio_regs_145_to_157 */
-	{0x7e40, 0x7e44, 0x230, 25}, /* t5_tp_pio_regs_230_to_248 */
-	{0x7e40, 0x7e44, 0x8C0, 1} /* t5_tp_pio_regs_8c0 */
-};
-
-static const u32 t6_tp_tm_pio_array[][IREG_NUM_ELEM] = {
-	{0x7e18, 0x7e1c, 0x0, 12}
-};
-
-static const u32 t5_tp_tm_pio_array[][IREG_NUM_ELEM] = {
-	{0x7e18, 0x7e1c, 0x0, 12}
-};
-
-static const u32 t6_tp_mib_index_array[6][IREG_NUM_ELEM] = {
-	{0x7e50, 0x7e54, 0x0, 13},
-	{0x7e50, 0x7e54, 0x10, 6},
-	{0x7e50, 0x7e54, 0x18, 21},
-	{0x7e50, 0x7e54, 0x30, 32},
-	{0x7e50, 0x7e54, 0x50, 22},
-	{0x7e50, 0x7e54, 0x68, 12}
-};
-
-static const u32 t5_tp_mib_index_array[9][IREG_NUM_ELEM] = {
-	{0x7e50, 0x7e54, 0x0, 13},
-	{0x7e50, 0x7e54, 0x10, 6},
-	{0x7e50, 0x7e54, 0x18, 8},
-	{0x7e50, 0x7e54, 0x20, 13},
-	{0x7e50, 0x7e54, 0x30, 16},
-	{0x7e50, 0x7e54, 0x40, 16},
-	{0x7e50, 0x7e54, 0x50, 16},
-	{0x7e50, 0x7e54, 0x60, 6},
-	{0x7e50, 0x7e54, 0x68, 4}
-};
-
-static const u32 t5_sge_dbg_index_array[2][IREG_NUM_ELEM] = {
-	{0x10cc, 0x10d0, 0x0, 16},
-	{0x10cc, 0x10d4, 0x0, 16},
-};
-
-static const u32 t6_sge_qbase_index_array[] = {
-	/* 1 addr reg SGE_QBASE_INDEX and 4 data reg SGE_QBASE_MAP[0-3] */
-	0x1250, 0x1240, 0x1244, 0x1248, 0x124c,
-};
-
-static const u32 t5_pcie_pdbg_array[][IREG_NUM_ELEM] = {
-	{0x5a04, 0x5a0c, 0x00, 0x20}, /* t5_pcie_pdbg_regs_00_to_20 */
-	{0x5a04, 0x5a0c, 0x21, 0x20}, /* t5_pcie_pdbg_regs_21_to_40 */
-	{0x5a04, 0x5a0c, 0x41, 0x10}, /* t5_pcie_pdbg_regs_41_to_50 */
-};
-
-static const u32 t5_pcie_cdbg_array[][IREG_NUM_ELEM] = {
-	{0x5a10, 0x5a18, 0x00, 0x20}, /* t5_pcie_cdbg_regs_00_to_20 */
-	{0x5a10, 0x5a18, 0x21, 0x18}, /* t5_pcie_cdbg_regs_21_to_37 */
-};
-
-static const u32 t5_pm_rx_array[][IREG_NUM_ELEM] = {
-	{0x8FD0, 0x8FD4, 0x10000, 0x20}, /* t5_pm_rx_regs_10000_to_10020 */
-	{0x8FD0, 0x8FD4, 0x10021, 0x0D}, /* t5_pm_rx_regs_10021_to_1002c */
-};
-
-static const u32 t5_pm_tx_array[][IREG_NUM_ELEM] = {
-	{0x8FF0, 0x8FF4, 0x10000, 0x20}, /* t5_pm_tx_regs_10000_to_10020 */
-	{0x8FF0, 0x8FF4, 0x10021, 0x1D}, /* t5_pm_tx_regs_10021_to_1003c */
-};
-
 #define CUDBG_NUM_PCIE_CONFIG_REGS 0x61
 
-static const u32 t5_pcie_config_array[][2] = {
-	{0x0, 0x34},
-	{0x3c, 0x40},
-	{0x50, 0x64},
-	{0x70, 0x80},
-	{0x94, 0xa0},
-	{0xb0, 0xb8},
-	{0xd0, 0xd4},
-	{0x100, 0x128},
-	{0x140, 0x148},
-	{0x150, 0x164},
-	{0x170, 0x178},
-	{0x180, 0x194},
-	{0x1a0, 0x1b8},
-	{0x1c0, 0x208},
-};
-
-static const u32 t6_ma_ireg_array[][IREG_NUM_ELEM] = {
-	{0x78f8, 0x78fc, 0xa000, 23}, /* t6_ma_regs_a000_to_a016 */
-	{0x78f8, 0x78fc, 0xa400, 30}, /* t6_ma_regs_a400_to_a41e */
-	{0x78f8, 0x78fc, 0xa800, 20} /* t6_ma_regs_a800_to_a813 */
-};
-
-static const u32 t6_ma_ireg_array2[][IREG_NUM_ELEM] = {
-	{0x78f8, 0x78fc, 0xe400, 17}, /* t6_ma_regs_e400_to_e600 */
-	{0x78f8, 0x78fc, 0xe640, 13} /* t6_ma_regs_e640_to_e7c0 */
-};
-
-static const u32 t6_up_cim_reg_array[][IREG_NUM_ELEM + 1] = {
-	{0x7b50, 0x7b54, 0x2000, 0x20, 0}, /* up_cim_2000_to_207c */
-	{0x7b50, 0x7b54, 0x2080, 0x1d, 0}, /* up_cim_2080_to_20fc */
-	{0x7b50, 0x7b54, 0x00, 0x20, 0}, /* up_cim_00_to_7c */
-	{0x7b50, 0x7b54, 0x80, 0x20, 0}, /* up_cim_80_to_fc */
-	{0x7b50, 0x7b54, 0x100, 0x11, 0}, /* up_cim_100_to_14c */
-	{0x7b50, 0x7b54, 0x200, 0x10, 0}, /* up_cim_200_to_23c */
-	{0x7b50, 0x7b54, 0x240, 0x2, 0}, /* up_cim_240_to_244 */
-	{0x7b50, 0x7b54, 0x250, 0x2, 0}, /* up_cim_250_to_254 */
-	{0x7b50, 0x7b54, 0x260, 0x2, 0}, /* up_cim_260_to_264 */
-	{0x7b50, 0x7b54, 0x270, 0x2, 0}, /* up_cim_270_to_274 */
-	{0x7b50, 0x7b54, 0x280, 0x20, 0}, /* up_cim_280_to_2fc */
-	{0x7b50, 0x7b54, 0x300, 0x20, 0}, /* up_cim_300_to_37c */
-	{0x7b50, 0x7b54, 0x380, 0x14, 0}, /* up_cim_380_to_3cc */
-	{0x7b50, 0x7b54, 0x4900, 0x4, 0x4}, /* up_cim_4900_to_4c60 */
-	{0x7b50, 0x7b54, 0x4904, 0x4, 0x4}, /* up_cim_4904_to_4c64 */
-	{0x7b50, 0x7b54, 0x4908, 0x4, 0x4}, /* up_cim_4908_to_4c68 */
-	{0x7b50, 0x7b54, 0x4910, 0x4, 0x4}, /* up_cim_4910_to_4c70 */
-	{0x7b50, 0x7b54, 0x4914, 0x4, 0x4}, /* up_cim_4914_to_4c74 */
-	{0x7b50, 0x7b54, 0x4920, 0x10, 0x10}, /* up_cim_4920_to_4a10 */
-	{0x7b50, 0x7b54, 0x4924, 0x10, 0x10}, /* up_cim_4924_to_4a14 */
-	{0x7b50, 0x7b54, 0x4928, 0x10, 0x10}, /* up_cim_4928_to_4a18 */
-	{0x7b50, 0x7b54, 0x492c, 0x10, 0x10}, /* up_cim_492c_to_4a1c */
-};
-
-static const u32 t5_up_cim_reg_array[][IREG_NUM_ELEM + 1] = {
-	{0x7b50, 0x7b54, 0x2000, 0x20, 0}, /* up_cim_2000_to_207c */
-	{0x7b50, 0x7b54, 0x2080, 0x19, 0}, /* up_cim_2080_to_20ec */
-	{0x7b50, 0x7b54, 0x00, 0x20, 0}, /* up_cim_00_to_7c */
-	{0x7b50, 0x7b54, 0x80, 0x20, 0}, /* up_cim_80_to_fc */
-	{0x7b50, 0x7b54, 0x100, 0x11, 0}, /* up_cim_100_to_14c */
-	{0x7b50, 0x7b54, 0x200, 0x10, 0}, /* up_cim_200_to_23c */
-	{0x7b50, 0x7b54, 0x240, 0x2, 0}, /* up_cim_240_to_244 */
-	{0x7b50, 0x7b54, 0x250, 0x2, 0}, /* up_cim_250_to_254 */
-	{0x7b50, 0x7b54, 0x260, 0x2, 0}, /* up_cim_260_to_264 */
-	{0x7b50, 0x7b54, 0x270, 0x2, 0}, /* up_cim_270_to_274 */
-	{0x7b50, 0x7b54, 0x280, 0x20, 0}, /* up_cim_280_to_2fc */
-	{0x7b50, 0x7b54, 0x300, 0x20, 0}, /* up_cim_300_to_37c */
-	{0x7b50, 0x7b54, 0x380, 0x14, 0}, /* up_cim_380_to_3cc */
-};
-
-static const u32 t6_hma_ireg_array[][IREG_NUM_ELEM] = {
-	{0x51320, 0x51324, 0xa000, 32} /* t6_hma_regs_a000_to_a01f */
-};
 #endif /* __CUDBG_ENTITY_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index cd9494c5ff37..9960e9d206fc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -15,6 +15,412 @@
 #include "cudbg_lib.h"
 #include "cudbg_zlib.h"
 
+static const u32 t6_tp_pio_array[][IREG_NUM_ELEM] = {
+	{0x7e40, 0x7e44, 0x020, 28}, /* t6_tp_pio_regs_20_to_3b */
+	{0x7e40, 0x7e44, 0x040, 10}, /* t6_tp_pio_regs_40_to_49 */
+	{0x7e40, 0x7e44, 0x050, 10}, /* t6_tp_pio_regs_50_to_59 */
+	{0x7e40, 0x7e44, 0x060, 14}, /* t6_tp_pio_regs_60_to_6d */
+	{0x7e40, 0x7e44, 0x06F, 1}, /* t6_tp_pio_regs_6f */
+	{0x7e40, 0x7e44, 0x070, 6}, /* t6_tp_pio_regs_70_to_75 */
+	{0x7e40, 0x7e44, 0x130, 18}, /* t6_tp_pio_regs_130_to_141 */
+	{0x7e40, 0x7e44, 0x145, 19}, /* t6_tp_pio_regs_145_to_157 */
+	{0x7e40, 0x7e44, 0x160, 1}, /* t6_tp_pio_regs_160 */
+	{0x7e40, 0x7e44, 0x230, 25}, /* t6_tp_pio_regs_230_to_248 */
+	{0x7e40, 0x7e44, 0x24a, 3}, /* t6_tp_pio_regs_24c */
+	{0x7e40, 0x7e44, 0x8C0, 1} /* t6_tp_pio_regs_8c0 */
+};
+
+static const u32 t5_tp_pio_array[][IREG_NUM_ELEM] = {
+	{0x7e40, 0x7e44, 0x020, 28}, /* t5_tp_pio_regs_20_to_3b */
+	{0x7e40, 0x7e44, 0x040, 19}, /* t5_tp_pio_regs_40_to_52 */
+	{0x7e40, 0x7e44, 0x054, 2}, /* t5_tp_pio_regs_54_to_55 */
+	{0x7e40, 0x7e44, 0x060, 13}, /* t5_tp_pio_regs_60_to_6c */
+	{0x7e40, 0x7e44, 0x06F, 1}, /* t5_tp_pio_regs_6f */
+	{0x7e40, 0x7e44, 0x120, 4}, /* t5_tp_pio_regs_120_to_123 */
+	{0x7e40, 0x7e44, 0x12b, 2}, /* t5_tp_pio_regs_12b_to_12c */
+	{0x7e40, 0x7e44, 0x12f, 21}, /* t5_tp_pio_regs_12f_to_143 */
+	{0x7e40, 0x7e44, 0x145, 19}, /* t5_tp_pio_regs_145_to_157 */
+	{0x7e40, 0x7e44, 0x230, 25}, /* t5_tp_pio_regs_230_to_248 */
+	{0x7e40, 0x7e44, 0x8C0, 1} /* t5_tp_pio_regs_8c0 */
+};
+
+static const u32 t6_tp_tm_pio_array[][IREG_NUM_ELEM] = {
+	{0x7e18, 0x7e1c, 0x0, 12}
+};
+
+static const u32 t5_tp_tm_pio_array[][IREG_NUM_ELEM] = {
+	{0x7e18, 0x7e1c, 0x0, 12}
+};
+
+static const u32 t6_tp_mib_index_array[6][IREG_NUM_ELEM] = {
+	{0x7e50, 0x7e54, 0x0, 13},
+	{0x7e50, 0x7e54, 0x10, 6},
+	{0x7e50, 0x7e54, 0x18, 21},
+	{0x7e50, 0x7e54, 0x30, 32},
+	{0x7e50, 0x7e54, 0x50, 22},
+	{0x7e50, 0x7e54, 0x68, 12}
+};
+
+static const u32 t5_tp_mib_index_array[9][IREG_NUM_ELEM] = {
+	{0x7e50, 0x7e54, 0x0, 13},
+	{0x7e50, 0x7e54, 0x10, 6},
+	{0x7e50, 0x7e54, 0x18, 8},
+	{0x7e50, 0x7e54, 0x20, 13},
+	{0x7e50, 0x7e54, 0x30, 16},
+	{0x7e50, 0x7e54, 0x40, 16},
+	{0x7e50, 0x7e54, 0x50, 16},
+	{0x7e50, 0x7e54, 0x60, 6},
+	{0x7e50, 0x7e54, 0x68, 4}
+};
+
+static const u32 t5_sge_dbg_index_array[2][IREG_NUM_ELEM] = {
+	{0x10cc, 0x10d0, 0x0, 16},
+	{0x10cc, 0x10d4, 0x0, 16},
+};
+
+static const u32 t6_sge_qbase_index_array[] = {
+	/* 1 addr reg SGE_QBASE_INDEX and 4 data reg SGE_QBASE_MAP[0-3] */
+	0x1250, 0x1240, 0x1244, 0x1248, 0x124c,
+};
+
+static const u32 t5_pcie_pdbg_array[][IREG_NUM_ELEM] = {
+	{0x5a04, 0x5a0c, 0x00, 0x20}, /* t5_pcie_pdbg_regs_00_to_20 */
+	{0x5a04, 0x5a0c, 0x21, 0x20}, /* t5_pcie_pdbg_regs_21_to_40 */
+	{0x5a04, 0x5a0c, 0x41, 0x10}, /* t5_pcie_pdbg_regs_41_to_50 */
+};
+
+static const u32 t5_pcie_cdbg_array[][IREG_NUM_ELEM] = {
+	{0x5a10, 0x5a18, 0x00, 0x20}, /* t5_pcie_cdbg_regs_00_to_20 */
+	{0x5a10, 0x5a18, 0x21, 0x18}, /* t5_pcie_cdbg_regs_21_to_37 */
+};
+
+static const u32 t5_pm_rx_array[][IREG_NUM_ELEM] = {
+	{0x8FD0, 0x8FD4, 0x10000, 0x20}, /* t5_pm_rx_regs_10000_to_10020 */
+	{0x8FD0, 0x8FD4, 0x10021, 0x0D}, /* t5_pm_rx_regs_10021_to_1002c */
+};
+
+static const u32 t5_pm_tx_array[][IREG_NUM_ELEM] = {
+	{0x8FF0, 0x8FF4, 0x10000, 0x20}, /* t5_pm_tx_regs_10000_to_10020 */
+	{0x8FF0, 0x8FF4, 0x10021, 0x1D}, /* t5_pm_tx_regs_10021_to_1003c */
+};
+
+static const u32 t5_pcie_config_array[][2] = {
+	{0x0, 0x34},
+	{0x3c, 0x40},
+	{0x50, 0x64},
+	{0x70, 0x80},
+	{0x94, 0xa0},
+	{0xb0, 0xb8},
+	{0xd0, 0xd4},
+	{0x100, 0x128},
+	{0x140, 0x148},
+	{0x150, 0x164},
+	{0x170, 0x178},
+	{0x180, 0x194},
+	{0x1a0, 0x1b8},
+	{0x1c0, 0x208},
+};
+
+static const u32 t6_ma_ireg_array[][IREG_NUM_ELEM] = {
+	{0x78f8, 0x78fc, 0xa000, 23}, /* t6_ma_regs_a000_to_a016 */
+	{0x78f8, 0x78fc, 0xa400, 30}, /* t6_ma_regs_a400_to_a41e */
+	{0x78f8, 0x78fc, 0xa800, 20} /* t6_ma_regs_a800_to_a813 */
+};
+
+static const u32 t6_ma_ireg_array2[][IREG_NUM_ELEM] = {
+	{0x78f8, 0x78fc, 0xe400, 17}, /* t6_ma_regs_e400_to_e600 */
+	{0x78f8, 0x78fc, 0xe640, 13} /* t6_ma_regs_e640_to_e7c0 */
+};
+
+static const u32 t6_up_cim_reg_array[][IREG_NUM_ELEM + 1] = {
+	{0x7b50, 0x7b54, 0x2000, 0x20, 0}, /* up_cim_2000_to_207c */
+	{0x7b50, 0x7b54, 0x2080, 0x1d, 0}, /* up_cim_2080_to_20fc */
+	{0x7b50, 0x7b54, 0x00, 0x20, 0}, /* up_cim_00_to_7c */
+	{0x7b50, 0x7b54, 0x80, 0x20, 0}, /* up_cim_80_to_fc */
+	{0x7b50, 0x7b54, 0x100, 0x11, 0}, /* up_cim_100_to_14c */
+	{0x7b50, 0x7b54, 0x200, 0x10, 0}, /* up_cim_200_to_23c */
+	{0x7b50, 0x7b54, 0x240, 0x2, 0}, /* up_cim_240_to_244 */
+	{0x7b50, 0x7b54, 0x250, 0x2, 0}, /* up_cim_250_to_254 */
+	{0x7b50, 0x7b54, 0x260, 0x2, 0}, /* up_cim_260_to_264 */
+	{0x7b50, 0x7b54, 0x270, 0x2, 0}, /* up_cim_270_to_274 */
+	{0x7b50, 0x7b54, 0x280, 0x20, 0}, /* up_cim_280_to_2fc */
+	{0x7b50, 0x7b54, 0x300, 0x20, 0}, /* up_cim_300_to_37c */
+	{0x7b50, 0x7b54, 0x380, 0x14, 0}, /* up_cim_380_to_3cc */
+	{0x7b50, 0x7b54, 0x4900, 0x4, 0x4}, /* up_cim_4900_to_4c60 */
+	{0x7b50, 0x7b54, 0x4904, 0x4, 0x4}, /* up_cim_4904_to_4c64 */
+	{0x7b50, 0x7b54, 0x4908, 0x4, 0x4}, /* up_cim_4908_to_4c68 */
+	{0x7b50, 0x7b54, 0x4910, 0x4, 0x4}, /* up_cim_4910_to_4c70 */
+	{0x7b50, 0x7b54, 0x4914, 0x4, 0x4}, /* up_cim_4914_to_4c74 */
+	{0x7b50, 0x7b54, 0x4920, 0x10, 0x10}, /* up_cim_4920_to_4a10 */
+	{0x7b50, 0x7b54, 0x4924, 0x10, 0x10}, /* up_cim_4924_to_4a14 */
+	{0x7b50, 0x7b54, 0x4928, 0x10, 0x10}, /* up_cim_4928_to_4a18 */
+	{0x7b50, 0x7b54, 0x492c, 0x10, 0x10}, /* up_cim_492c_to_4a1c */
+};
+
+static const u32 t5_up_cim_reg_array[][IREG_NUM_ELEM + 1] = {
+	{0x7b50, 0x7b54, 0x2000, 0x20, 0}, /* up_cim_2000_to_207c */
+	{0x7b50, 0x7b54, 0x2080, 0x19, 0}, /* up_cim_2080_to_20ec */
+	{0x7b50, 0x7b54, 0x00, 0x20, 0}, /* up_cim_00_to_7c */
+	{0x7b50, 0x7b54, 0x80, 0x20, 0}, /* up_cim_80_to_fc */
+	{0x7b50, 0x7b54, 0x100, 0x11, 0}, /* up_cim_100_to_14c */
+	{0x7b50, 0x7b54, 0x200, 0x10, 0}, /* up_cim_200_to_23c */
+	{0x7b50, 0x7b54, 0x240, 0x2, 0}, /* up_cim_240_to_244 */
+	{0x7b50, 0x7b54, 0x250, 0x2, 0}, /* up_cim_250_to_254 */
+	{0x7b50, 0x7b54, 0x260, 0x2, 0}, /* up_cim_260_to_264 */
+	{0x7b50, 0x7b54, 0x270, 0x2, 0}, /* up_cim_270_to_274 */
+	{0x7b50, 0x7b54, 0x280, 0x20, 0}, /* up_cim_280_to_2fc */
+	{0x7b50, 0x7b54, 0x300, 0x20, 0}, /* up_cim_300_to_37c */
+	{0x7b50, 0x7b54, 0x380, 0x14, 0}, /* up_cim_380_to_3cc */
+};
+
+static const u32 t6_hma_ireg_array[][IREG_NUM_ELEM] = {
+	{0x51320, 0x51324, 0xa000, 32} /* t6_hma_regs_a000_to_a01f */
+};
+
+u32 cudbg_get_entity_length(struct adapter *adap, u32 entity)
+{
+	struct cudbg_tcam tcam_region = { 0 };
+	u32 value, n = 0, len = 0;
+
+	switch (entity) {
+	case CUDBG_REG_DUMP:
+		switch (CHELSIO_CHIP_VERSION(adap->params.chip)) {
+		case CHELSIO_T4:
+			len = T4_REGMAP_SIZE;
+			break;
+		case CHELSIO_T5:
+		case CHELSIO_T6:
+			len = T5_REGMAP_SIZE;
+			break;
+		default:
+			break;
+		}
+		break;
+	case CUDBG_DEV_LOG:
+		len = adap->params.devlog.size;
+		break;
+	case CUDBG_CIM_LA:
+		if (is_t6(adap->params.chip)) {
+			len = adap->params.cim_la_size / 10 + 1;
+			len *= 10 * sizeof(u32);
+		} else {
+			len = adap->params.cim_la_size / 8;
+			len *= 8 * sizeof(u32);
+		}
+		len += sizeof(u32); /* for reading CIM LA configuration */
+		break;
+	case CUDBG_CIM_MA_LA:
+		len = 2 * CIM_MALA_SIZE * 5 * sizeof(u32);
+		break;
+	case CUDBG_CIM_QCFG:
+		len = sizeof(struct cudbg_cim_qcfg);
+		break;
+	case CUDBG_CIM_IBQ_TP0:
+	case CUDBG_CIM_IBQ_TP1:
+	case CUDBG_CIM_IBQ_ULP:
+	case CUDBG_CIM_IBQ_SGE0:
+	case CUDBG_CIM_IBQ_SGE1:
+	case CUDBG_CIM_IBQ_NCSI:
+		len = CIM_IBQ_SIZE * 4 * sizeof(u32);
+		break;
+	case CUDBG_CIM_OBQ_ULP0:
+		len = cudbg_cim_obq_size(adap, 0);
+		break;
+	case CUDBG_CIM_OBQ_ULP1:
+		len = cudbg_cim_obq_size(adap, 1);
+		break;
+	case CUDBG_CIM_OBQ_ULP2:
+		len = cudbg_cim_obq_size(adap, 2);
+		break;
+	case CUDBG_CIM_OBQ_ULP3:
+		len = cudbg_cim_obq_size(adap, 3);
+		break;
+	case CUDBG_CIM_OBQ_SGE:
+		len = cudbg_cim_obq_size(adap, 4);
+		break;
+	case CUDBG_CIM_OBQ_NCSI:
+		len = cudbg_cim_obq_size(adap, 5);
+		break;
+	case CUDBG_CIM_OBQ_RXQ0:
+		len = cudbg_cim_obq_size(adap, 6);
+		break;
+	case CUDBG_CIM_OBQ_RXQ1:
+		len = cudbg_cim_obq_size(adap, 7);
+		break;
+	case CUDBG_EDC0:
+		value = t4_read_reg(adap, MA_TARGET_MEM_ENABLE_A);
+		if (value & EDRAM0_ENABLE_F) {
+			value = t4_read_reg(adap, MA_EDRAM0_BAR_A);
+			len = EDRAM0_SIZE_G(value);
+		}
+		len = cudbg_mbytes_to_bytes(len);
+		break;
+	case CUDBG_EDC1:
+		value = t4_read_reg(adap, MA_TARGET_MEM_ENABLE_A);
+		if (value & EDRAM1_ENABLE_F) {
+			value = t4_read_reg(adap, MA_EDRAM1_BAR_A);
+			len = EDRAM1_SIZE_G(value);
+		}
+		len = cudbg_mbytes_to_bytes(len);
+		break;
+	case CUDBG_MC0:
+		value = t4_read_reg(adap, MA_TARGET_MEM_ENABLE_A);
+		if (value & EXT_MEM0_ENABLE_F) {
+			value = t4_read_reg(adap, MA_EXT_MEMORY0_BAR_A);
+			len = EXT_MEM0_SIZE_G(value);
+		}
+		len = cudbg_mbytes_to_bytes(len);
+		break;
+	case CUDBG_MC1:
+		value = t4_read_reg(adap, MA_TARGET_MEM_ENABLE_A);
+		if (value & EXT_MEM1_ENABLE_F) {
+			value = t4_read_reg(adap, MA_EXT_MEMORY1_BAR_A);
+			len = EXT_MEM1_SIZE_G(value);
+		}
+		len = cudbg_mbytes_to_bytes(len);
+		break;
+	case CUDBG_RSS:
+		len = t4_chip_rss_size(adap) * sizeof(u16);
+		break;
+	case CUDBG_RSS_VF_CONF:
+		len = adap->params.arch.vfcount *
+		      sizeof(struct cudbg_rss_vf_conf);
+		break;
+	case CUDBG_PATH_MTU:
+		len = NMTUS * sizeof(u16);
+		break;
+	case CUDBG_PM_STATS:
+		len = sizeof(struct cudbg_pm_stats);
+		break;
+	case CUDBG_HW_SCHED:
+		len = sizeof(struct cudbg_hw_sched);
+		break;
+	case CUDBG_TP_INDIRECT:
+		switch (CHELSIO_CHIP_VERSION(adap->params.chip)) {
+		case CHELSIO_T5:
+			n = sizeof(t5_tp_pio_array) +
+			    sizeof(t5_tp_tm_pio_array) +
+			    sizeof(t5_tp_mib_index_array);
+			break;
+		case CHELSIO_T6:
+			n = sizeof(t6_tp_pio_array) +
+			    sizeof(t6_tp_tm_pio_array) +
+			    sizeof(t6_tp_mib_index_array);
+			break;
+		default:
+			break;
+		}
+		n = n / (IREG_NUM_ELEM * sizeof(u32));
+		len = sizeof(struct ireg_buf) * n;
+		break;
+	case CUDBG_SGE_INDIRECT:
+		len = sizeof(struct ireg_buf) * 2 +
+		      sizeof(struct sge_qbase_reg_field);
+		break;
+	case CUDBG_ULPRX_LA:
+		len = sizeof(struct cudbg_ulprx_la);
+		break;
+	case CUDBG_TP_LA:
+		len = sizeof(struct cudbg_tp_la) + TPLA_SIZE * sizeof(u64);
+		break;
+	case CUDBG_MEMINFO:
+		len = sizeof(struct cudbg_ver_hdr) +
+		      sizeof(struct cudbg_meminfo);
+		break;
+	case CUDBG_CIM_PIF_LA:
+		len = sizeof(struct cudbg_cim_pif_la);
+		len += 2 * CIM_PIFLA_SIZE * 6 * sizeof(u32);
+		break;
+	case CUDBG_CLK:
+		len = sizeof(struct cudbg_clk_info);
+		break;
+	case CUDBG_PCIE_INDIRECT:
+		n = sizeof(t5_pcie_pdbg_array) / (IREG_NUM_ELEM * sizeof(u32));
+		len = sizeof(struct ireg_buf) * n * 2;
+		break;
+	case CUDBG_PM_INDIRECT:
+		n = sizeof(t5_pm_rx_array) / (IREG_NUM_ELEM * sizeof(u32));
+		len = sizeof(struct ireg_buf) * n * 2;
+		break;
+	case CUDBG_TID_INFO:
+		len = sizeof(struct cudbg_tid_info_region_rev1);
+		break;
+	case CUDBG_PCIE_CONFIG:
+		len = sizeof(u32) * CUDBG_NUM_PCIE_CONFIG_REGS;
+		break;
+	case CUDBG_DUMP_CONTEXT:
+		len = cudbg_dump_context_size(adap);
+		break;
+	case CUDBG_MPS_TCAM:
+		len = sizeof(struct cudbg_mps_tcam) *
+		      adap->params.arch.mps_tcam_size;
+		break;
+	case CUDBG_VPD_DATA:
+		len = sizeof(struct cudbg_vpd_data);
+		break;
+	case CUDBG_LE_TCAM:
+		cudbg_fill_le_tcam_info(adap, &tcam_region);
+		len = sizeof(struct cudbg_tcam) +
+		      sizeof(struct cudbg_tid_data) * tcam_region.max_tid;
+		break;
+	case CUDBG_CCTRL:
+		len = sizeof(u16) * NMTUS * NCCTRL_WIN;
+		break;
+	case CUDBG_MA_INDIRECT:
+		if (CHELSIO_CHIP_VERSION(adap->params.chip) > CHELSIO_T5) {
+			n = sizeof(t6_ma_ireg_array) /
+			    (IREG_NUM_ELEM * sizeof(u32));
+			len = sizeof(struct ireg_buf) * n * 2;
+		}
+		break;
+	case CUDBG_ULPTX_LA:
+		len = sizeof(struct cudbg_ver_hdr) +
+		      sizeof(struct cudbg_ulptx_la);
+		break;
+	case CUDBG_UP_CIM_INDIRECT:
+		n = 0;
+		if (is_t5(adap->params.chip))
+			n = sizeof(t5_up_cim_reg_array) /
+			    ((IREG_NUM_ELEM + 1) * sizeof(u32));
+		else if (is_t6(adap->params.chip))
+			n = sizeof(t6_up_cim_reg_array) /
+			    ((IREG_NUM_ELEM + 1) * sizeof(u32));
+		len = sizeof(struct ireg_buf) * n;
+		break;
+	case CUDBG_PBT_TABLE:
+		len = sizeof(struct cudbg_pbt_tables);
+		break;
+	case CUDBG_MBOX_LOG:
+		len = sizeof(struct cudbg_mbox_log) * adap->mbox_log->size;
+		break;
+	case CUDBG_HMA_INDIRECT:
+		if (CHELSIO_CHIP_VERSION(adap->params.chip) > CHELSIO_T5) {
+			n = sizeof(t6_hma_ireg_array) /
+			    (IREG_NUM_ELEM * sizeof(u32));
+			len = sizeof(struct ireg_buf) * n;
+		}
+		break;
+	case CUDBG_HMA:
+		value = t4_read_reg(adap, MA_TARGET_MEM_ENABLE_A);
+		if (value & HMA_MUX_F) {
+			/* In T6, there's no MC1.  So, HMA shares MC1
+			 * address space.
+			 */
+			value = t4_read_reg(adap, MA_EXT_MEMORY1_BAR_A);
+			len = EXT_MEM1_SIZE_G(value);
+		}
+		len = cudbg_mbytes_to_bytes(len);
+		break;
+	case CUDBG_QDESC:
+		cudbg_fill_qdesc_num_and_size(adap, NULL, &len);
+		break;
+	default:
+		break;
+	}
+
+	return len;
+}
+
 static int cudbg_do_compression(struct cudbg_init *pdbg_init,
 				struct cudbg_buffer *pin_buff,
 				struct cudbg_buffer *dbg_buff)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.h b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.h
index 0f488d52797b..d6d6cd298930 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.h
@@ -165,6 +165,8 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 int cudbg_collect_flash(struct cudbg_init *pdbg_init,
 			struct cudbg_buffer *dbg_buff,
 			struct cudbg_error *cudbg_err);
+
+u32 cudbg_get_entity_length(struct adapter *adap, u32 entity);
 struct cudbg_entity_hdr *cudbg_get_entity_hdr(void *outbuf, int i);
 void cudbg_align_debug_buffer(struct cudbg_buffer *dbg_buff,
 			      struct cudbg_entity_hdr *entity_hdr);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
index d7afe0746878..77648e4ab4cc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
@@ -70,250 +70,6 @@ static const struct cxgb4_collect_entity cxgb4_collect_flash_dump[] = {
 	{ CUDBG_FLASH, cudbg_collect_flash },
 };
 
-static u32 cxgb4_get_entity_length(struct adapter *adap, u32 entity)
-{
-	struct cudbg_tcam tcam_region = { 0 };
-	u32 value, n = 0, len = 0;
-
-	switch (entity) {
-	case CUDBG_REG_DUMP:
-		switch (CHELSIO_CHIP_VERSION(adap->params.chip)) {
-		case CHELSIO_T4:
-			len = T4_REGMAP_SIZE;
-			break;
-		case CHELSIO_T5:
-		case CHELSIO_T6:
-			len = T5_REGMAP_SIZE;
-			break;
-		default:
-			break;
-		}
-		break;
-	case CUDBG_DEV_LOG:
-		len = adap->params.devlog.size;
-		break;
-	case CUDBG_CIM_LA:
-		if (is_t6(adap->params.chip)) {
-			len = adap->params.cim_la_size / 10 + 1;
-			len *= 10 * sizeof(u32);
-		} else {
-			len = adap->params.cim_la_size / 8;
-			len *= 8 * sizeof(u32);
-		}
-		len += sizeof(u32); /* for reading CIM LA configuration */
-		break;
-	case CUDBG_CIM_MA_LA:
-		len = 2 * CIM_MALA_SIZE * 5 * sizeof(u32);
-		break;
-	case CUDBG_CIM_QCFG:
-		len = sizeof(struct cudbg_cim_qcfg);
-		break;
-	case CUDBG_CIM_IBQ_TP0:
-	case CUDBG_CIM_IBQ_TP1:
-	case CUDBG_CIM_IBQ_ULP:
-	case CUDBG_CIM_IBQ_SGE0:
-	case CUDBG_CIM_IBQ_SGE1:
-	case CUDBG_CIM_IBQ_NCSI:
-		len = CIM_IBQ_SIZE * 4 * sizeof(u32);
-		break;
-	case CUDBG_CIM_OBQ_ULP0:
-		len = cudbg_cim_obq_size(adap, 0);
-		break;
-	case CUDBG_CIM_OBQ_ULP1:
-		len = cudbg_cim_obq_size(adap, 1);
-		break;
-	case CUDBG_CIM_OBQ_ULP2:
-		len = cudbg_cim_obq_size(adap, 2);
-		break;
-	case CUDBG_CIM_OBQ_ULP3:
-		len = cudbg_cim_obq_size(adap, 3);
-		break;
-	case CUDBG_CIM_OBQ_SGE:
-		len = cudbg_cim_obq_size(adap, 4);
-		break;
-	case CUDBG_CIM_OBQ_NCSI:
-		len = cudbg_cim_obq_size(adap, 5);
-		break;
-	case CUDBG_CIM_OBQ_RXQ0:
-		len = cudbg_cim_obq_size(adap, 6);
-		break;
-	case CUDBG_CIM_OBQ_RXQ1:
-		len = cudbg_cim_obq_size(adap, 7);
-		break;
-	case CUDBG_EDC0:
-		value = t4_read_reg(adap, MA_TARGET_MEM_ENABLE_A);
-		if (value & EDRAM0_ENABLE_F) {
-			value = t4_read_reg(adap, MA_EDRAM0_BAR_A);
-			len = EDRAM0_SIZE_G(value);
-		}
-		len = cudbg_mbytes_to_bytes(len);
-		break;
-	case CUDBG_EDC1:
-		value = t4_read_reg(adap, MA_TARGET_MEM_ENABLE_A);
-		if (value & EDRAM1_ENABLE_F) {
-			value = t4_read_reg(adap, MA_EDRAM1_BAR_A);
-			len = EDRAM1_SIZE_G(value);
-		}
-		len = cudbg_mbytes_to_bytes(len);
-		break;
-	case CUDBG_MC0:
-		value = t4_read_reg(adap, MA_TARGET_MEM_ENABLE_A);
-		if (value & EXT_MEM0_ENABLE_F) {
-			value = t4_read_reg(adap, MA_EXT_MEMORY0_BAR_A);
-			len = EXT_MEM0_SIZE_G(value);
-		}
-		len = cudbg_mbytes_to_bytes(len);
-		break;
-	case CUDBG_MC1:
-		value = t4_read_reg(adap, MA_TARGET_MEM_ENABLE_A);
-		if (value & EXT_MEM1_ENABLE_F) {
-			value = t4_read_reg(adap, MA_EXT_MEMORY1_BAR_A);
-			len = EXT_MEM1_SIZE_G(value);
-		}
-		len = cudbg_mbytes_to_bytes(len);
-		break;
-	case CUDBG_RSS:
-		len = t4_chip_rss_size(adap) * sizeof(u16);
-		break;
-	case CUDBG_RSS_VF_CONF:
-		len = adap->params.arch.vfcount *
-		      sizeof(struct cudbg_rss_vf_conf);
-		break;
-	case CUDBG_PATH_MTU:
-		len = NMTUS * sizeof(u16);
-		break;
-	case CUDBG_PM_STATS:
-		len = sizeof(struct cudbg_pm_stats);
-		break;
-	case CUDBG_HW_SCHED:
-		len = sizeof(struct cudbg_hw_sched);
-		break;
-	case CUDBG_TP_INDIRECT:
-		switch (CHELSIO_CHIP_VERSION(adap->params.chip)) {
-		case CHELSIO_T5:
-			n = sizeof(t5_tp_pio_array) +
-			    sizeof(t5_tp_tm_pio_array) +
-			    sizeof(t5_tp_mib_index_array);
-			break;
-		case CHELSIO_T6:
-			n = sizeof(t6_tp_pio_array) +
-			    sizeof(t6_tp_tm_pio_array) +
-			    sizeof(t6_tp_mib_index_array);
-			break;
-		default:
-			break;
-		}
-		n = n / (IREG_NUM_ELEM * sizeof(u32));
-		len = sizeof(struct ireg_buf) * n;
-		break;
-	case CUDBG_SGE_INDIRECT:
-		len = sizeof(struct ireg_buf) * 2 +
-		      sizeof(struct sge_qbase_reg_field);
-		break;
-	case CUDBG_ULPRX_LA:
-		len = sizeof(struct cudbg_ulprx_la);
-		break;
-	case CUDBG_TP_LA:
-		len = sizeof(struct cudbg_tp_la) + TPLA_SIZE * sizeof(u64);
-		break;
-	case CUDBG_MEMINFO:
-		len = sizeof(struct cudbg_ver_hdr) +
-		      sizeof(struct cudbg_meminfo);
-		break;
-	case CUDBG_CIM_PIF_LA:
-		len = sizeof(struct cudbg_cim_pif_la);
-		len += 2 * CIM_PIFLA_SIZE * 6 * sizeof(u32);
-		break;
-	case CUDBG_CLK:
-		len = sizeof(struct cudbg_clk_info);
-		break;
-	case CUDBG_PCIE_INDIRECT:
-		n = sizeof(t5_pcie_pdbg_array) / (IREG_NUM_ELEM * sizeof(u32));
-		len = sizeof(struct ireg_buf) * n * 2;
-		break;
-	case CUDBG_PM_INDIRECT:
-		n = sizeof(t5_pm_rx_array) / (IREG_NUM_ELEM * sizeof(u32));
-		len = sizeof(struct ireg_buf) * n * 2;
-		break;
-	case CUDBG_TID_INFO:
-		len = sizeof(struct cudbg_tid_info_region_rev1);
-		break;
-	case CUDBG_PCIE_CONFIG:
-		len = sizeof(u32) * CUDBG_NUM_PCIE_CONFIG_REGS;
-		break;
-	case CUDBG_DUMP_CONTEXT:
-		len = cudbg_dump_context_size(adap);
-		break;
-	case CUDBG_MPS_TCAM:
-		len = sizeof(struct cudbg_mps_tcam) *
-		      adap->params.arch.mps_tcam_size;
-		break;
-	case CUDBG_VPD_DATA:
-		len = sizeof(struct cudbg_vpd_data);
-		break;
-	case CUDBG_LE_TCAM:
-		cudbg_fill_le_tcam_info(adap, &tcam_region);
-		len = sizeof(struct cudbg_tcam) +
-		      sizeof(struct cudbg_tid_data) * tcam_region.max_tid;
-		break;
-	case CUDBG_CCTRL:
-		len = sizeof(u16) * NMTUS * NCCTRL_WIN;
-		break;
-	case CUDBG_MA_INDIRECT:
-		if (CHELSIO_CHIP_VERSION(adap->params.chip) > CHELSIO_T5) {
-			n = sizeof(t6_ma_ireg_array) /
-			    (IREG_NUM_ELEM * sizeof(u32));
-			len = sizeof(struct ireg_buf) * n * 2;
-		}
-		break;
-	case CUDBG_ULPTX_LA:
-		len = sizeof(struct cudbg_ver_hdr) +
-		      sizeof(struct cudbg_ulptx_la);
-		break;
-	case CUDBG_UP_CIM_INDIRECT:
-		n = 0;
-		if (is_t5(adap->params.chip))
-			n = sizeof(t5_up_cim_reg_array) /
-			    ((IREG_NUM_ELEM + 1) * sizeof(u32));
-		else if (is_t6(adap->params.chip))
-			n = sizeof(t6_up_cim_reg_array) /
-			    ((IREG_NUM_ELEM + 1) * sizeof(u32));
-		len = sizeof(struct ireg_buf) * n;
-		break;
-	case CUDBG_PBT_TABLE:
-		len = sizeof(struct cudbg_pbt_tables);
-		break;
-	case CUDBG_MBOX_LOG:
-		len = sizeof(struct cudbg_mbox_log) * adap->mbox_log->size;
-		break;
-	case CUDBG_HMA_INDIRECT:
-		if (CHELSIO_CHIP_VERSION(adap->params.chip) > CHELSIO_T5) {
-			n = sizeof(t6_hma_ireg_array) /
-			    (IREG_NUM_ELEM * sizeof(u32));
-			len = sizeof(struct ireg_buf) * n;
-		}
-		break;
-	case CUDBG_HMA:
-		value = t4_read_reg(adap, MA_TARGET_MEM_ENABLE_A);
-		if (value & HMA_MUX_F) {
-			/* In T6, there's no MC1.  So, HMA shares MC1
-			 * address space.
-			 */
-			value = t4_read_reg(adap, MA_EXT_MEMORY1_BAR_A);
-			len = EXT_MEM1_SIZE_G(value);
-		}
-		len = cudbg_mbytes_to_bytes(len);
-		break;
-	case CUDBG_QDESC:
-		cudbg_fill_qdesc_num_and_size(adap, NULL, &len);
-		break;
-	default:
-		break;
-	}
-
-	return len;
-}
-
 u32 cxgb4_get_dump_length(struct adapter *adap, u32 flag)
 {
 	u32 i, entity;
@@ -323,14 +79,14 @@ u32 cxgb4_get_dump_length(struct adapter *adap, u32 flag)
 	if (flag & CXGB4_ETH_DUMP_HW) {
 		for (i = 0; i < ARRAY_SIZE(cxgb4_collect_hw_dump); i++) {
 			entity = cxgb4_collect_hw_dump[i].entity;
-			len += cxgb4_get_entity_length(adap, entity);
+			len += cudbg_get_entity_length(adap, entity);
 		}
 	}
 
 	if (flag & CXGB4_ETH_DUMP_MEM) {
 		for (i = 0; i < ARRAY_SIZE(cxgb4_collect_mem_dump); i++) {
 			entity = cxgb4_collect_mem_dump[i].entity;
-			len += cxgb4_get_entity_length(adap, entity);
+			len += cudbg_get_entity_length(adap, entity);
 		}
 	}
 
-- 
2.24.0

