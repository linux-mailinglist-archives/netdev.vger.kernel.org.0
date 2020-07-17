Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3412242C2
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgGQSC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:02:26 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5408 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbgGQSCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 14:02:25 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HHvr04010403;
        Fri, 17 Jul 2020 11:02:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=Y0JG0d5UCHa40hpSKWhXQ2DsNzhJ1eArQsZl9B1qsXM=;
 b=MqQ+hdoWdnYaypC8Oxe3q2d1P9P+gUAecpEobSpDHJgOgfrexk9B1cacsrkOlerAddPk
 yh6R8nnHfMu+F34JkgLWK3x+X+ZwK4XrAoMG8hkBqilDrPvB9K5U5iUEPOPHwgZcN6kL
 SficQpVZqY8seeQ7TmNlPT37Ys/bpq1fNoOve52rzEBVKx8KwqMqNJW0iZbMFsxgbtvY
 OaOHC71bfW4rP9jzwWhwICgVAH1LvmjK1VakUfWOhhXF1hcJsPwBDWJcwvVgkUm1uU1R
 13y+G/vpIiITHGXviM7oYXZqDUp1W3KBZkwDaz2pkfomnvKDPZR+YX3MoljOAtRoLOUk Bw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmj5hhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 11:02:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Jul
 2020 11:02:20 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Jul
 2020 11:02:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 17 Jul 2020 11:02:19 -0700
Received: from NN-LT0044.marvell.com (unknown [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id 804443F704B;
        Fri, 17 Jul 2020 11:02:16 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
Subject: [PATCH net-next 2/2] net: atlantic: add support for FW 4.x
Date:   Fri, 17 Jul 2020 21:01:47 +0300
Message-ID: <20200717180147.8854-3-mstarovoitov@marvell.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200717180147.8854-1-mstarovoitov@marvell.com>
References: <20200717180147.8854-1-mstarovoitov@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_09:2020-07-17,2020-07-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds support for FW 4.x, which is about to get into the
production for some products.
4.x is mostly compatible with 3.x, save for soft reset, which requires
the acquisition of 2 additional semaphores.
Other differences (e.g. absence of PTP support) are handled via
capabilities.

Note: 4.x targets specific products only. 3.x is still the main firmware
branch, which should be used by most users (at least for now).

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     | 17 +++++++--
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     | 10 ++++--
 .../atlantic/hw_atl/hw_atl_llh_internal.h     | 11 ++++--
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   | 35 +++++++++++++++----
 4 files changed, 58 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index d775b23025c1..9c3debae425f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File hw_atl_llh.c: Definitions of bitfield and register access functions for
@@ -1724,6 +1725,16 @@ u32 hw_atl_sem_mdio_get(struct aq_hw_s *self)
 	return hw_atl_reg_glb_cpu_sem_get(self, HW_ATL_FW_SM_MDIO);
 }
 
+u32 hw_atl_sem_reset1_get(struct aq_hw_s *self)
+{
+	return hw_atl_reg_glb_cpu_sem_get(self, HW_ATL_FW_SM_RESET1);
+}
+
+u32 hw_atl_sem_reset2_get(struct aq_hw_s *self)
+{
+	return hw_atl_reg_glb_cpu_sem_get(self, HW_ATL_FW_SM_RESET2);
+}
+
 u32 hw_atl_scrpad_get(struct aq_hw_s *aq_hw, u32 scratch_scp)
 {
 	return aq_hw_read_reg(aq_hw,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
index 61a6f70c51cd..f0954711df24 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File hw_atl_llh.h: Declarations of bitfield and register access functions for
@@ -838,6 +839,9 @@ u32 hw_atl_sem_ram_get(struct aq_hw_s *self);
 /* get global microprocessor mdio semaphore */
 u32 hw_atl_sem_mdio_get(struct aq_hw_s *self);
 
+u32 hw_atl_sem_reset1_get(struct aq_hw_s *self);
+u32 hw_atl_sem_reset2_get(struct aq_hw_s *self);
+
 /* get global microprocessor scratch pad register */
 u32 hw_atl_scrpad_get(struct aq_hw_s *aq_hw, u32 scratch_scp);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
index 7430ff025134..ee11cb88325e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File hw_atl_llh_internal.h: Preprocessor definitions
@@ -2837,7 +2838,11 @@
 /* Default value of bitfield MDIO Address [F:0] */
 #define HW_ATL_MDIO_ADDRESS_DEFAULT 0x0
 
+#define HW_ATL_MIF_RESET_TIMEOUT_ADR 0x00000348
+
 #define HW_ATL_FW_SM_MDIO       0x0U
 #define HW_ATL_FW_SM_RAM        0x2U
+#define HW_ATL_FW_SM_RESET1     0x3U
+#define HW_ATL_FW_SM_RESET2     0x4U
 
 #endif /* HW_ATL_LLH_INTERNAL_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 22f68e4a638c..cacab3352cb8 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -46,6 +46,7 @@
 #define HW_ATL_FW_VER_1X 0x01050006U
 #define HW_ATL_FW_VER_2X 0x02000000U
 #define HW_ATL_FW_VER_3X 0x03000000U
+#define HW_ATL_FW_VER_4X 0x04000000U
 
 #define FORCE_FLASHLESS 0
 
@@ -78,6 +79,8 @@ int hw_atl_utils_initfw(struct aq_hw_s *self, const struct aq_fw_ops **fw_ops)
 		*fw_ops = &aq_fw_2x_ops;
 	} else if (hw_atl_utils_ver_match(HW_ATL_FW_VER_3X, self->fw_ver_actual)) {
 		*fw_ops = &aq_fw_2x_ops;
+	} else if (hw_atl_utils_ver_match(HW_ATL_FW_VER_4X, self->fw_ver_actual)) {
+		*fw_ops = &aq_fw_2x_ops;
 	} else {
 		aq_pr_err("Bad FW version detected: %x\n",
 			  self->fw_ver_actual);
@@ -236,6 +239,7 @@ static int hw_atl_utils_soft_reset_rbl(struct aq_hw_s *self)
 
 int hw_atl_utils_soft_reset(struct aq_hw_s *self)
 {
+	int ver = hw_atl_utils_get_fw_version(self);
 	u32 boot_exit_code = 0;
 	u32 val;
 	int k;
@@ -256,14 +260,12 @@ int hw_atl_utils_soft_reset(struct aq_hw_s *self)
 
 	self->rbl_enabled = (boot_exit_code != 0);
 
-	/* FW 1.x may bootup in an invalid POWER state (WOL feature).
-	 * We should work around this by forcing its state back to DEINIT
-	 */
-	if (hw_atl_utils_ver_match(HW_ATL_FW_VER_1X,
-				   aq_hw_read_reg(self,
-						  HW_ATL_MPI_FW_VERSION))) {
+	if (hw_atl_utils_ver_match(HW_ATL_FW_VER_1X, ver)) {
 		int err = 0;
 
+		/* FW 1.x may bootup in an invalid POWER state (WOL feature).
+		 * We should work around this by forcing its state back to DEINIT
+		 */
 		hw_atl_utils_mpi_set_state(self, MPI_DEINIT);
 		err = readx_poll_timeout_atomic(hw_atl_utils_mpi_get_state,
 						self, val,
@@ -272,6 +274,27 @@ int hw_atl_utils_soft_reset(struct aq_hw_s *self)
 						10, 10000U);
 		if (err)
 			return err;
+	} else if (hw_atl_utils_ver_match(HW_ATL_FW_VER_4X, ver)) {
+		u64 sem_timeout = aq_hw_read_reg(self, HW_ATL_MIF_RESET_TIMEOUT_ADR);
+
+		/* Acquire 2 semaphores before issuing reset for FW 4.x */
+		if (sem_timeout > 3000)
+			sem_timeout = 3000;
+		sem_timeout = sem_timeout * 1000;
+
+		if (sem_timeout != 0) {
+			int err;
+
+			err = readx_poll_timeout_atomic(hw_atl_sem_reset1_get, self, val,
+							val == 1U, 1U, sem_timeout);
+			if (err)
+				aq_pr_err("reset sema1 timeout");
+
+			err = readx_poll_timeout_atomic(hw_atl_sem_reset2_get, self, val,
+							val == 1U, 1U, sem_timeout);
+			if (err)
+				aq_pr_err("reset sema2 timeout");
+		}
 	}
 
 	if (self->rbl_enabled)
-- 
2.25.1

