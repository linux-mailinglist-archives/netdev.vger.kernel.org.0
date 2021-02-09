Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D61B31487D
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 07:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBIGKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 01:10:54 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:64318 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhBIGKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 01:10:53 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 11969tnP020147;
        Mon, 8 Feb 2021 22:09:56 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        bhelgaas@google.com, rajur@chelsio.com, alexander.duyck@gmail.com
Subject: [PATCH net-next v2] cxgb4: collect serial config version from register
Date:   Tue,  9 Feb 2021 11:22:38 +0530
Message-Id: <1612849958-25923-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Collect serial config version information directly from an internal
register, instead of explicitly resizing VPD.

v2:
- Add comments on info stored in PCIE_STATIC_SPARE2 register.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cudbg_entity.h |  3 ---
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 24 +++----------------
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h  |  6 +++++
 3 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h b/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
index 876f90e5795e..d5218e74284c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
@@ -220,9 +220,6 @@ struct cudbg_mps_tcam {
 	u8 reserved[2];
 };
 
-#define CUDBG_VPD_PF_SIZE 0x800
-#define CUDBG_SCFG_VER_ADDR 0x06
-#define CUDBG_SCFG_VER_LEN 4
 #define CUDBG_VPD_VER_ADDR 0x18c7
 #define CUDBG_VPD_VER_LEN 2
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index 75474f810249..6c85a10f465c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -2686,10 +2686,10 @@ int cudbg_collect_vpd_data(struct cudbg_init *pdbg_init,
 	struct adapter *padap = pdbg_init->adap;
 	struct cudbg_buffer temp_buff = { 0 };
 	char vpd_str[CUDBG_VPD_VER_LEN + 1];
-	u32 scfg_vers, vpd_vers, fw_vers;
 	struct cudbg_vpd_data *vpd_data;
 	struct vpd_params vpd = { 0 };
-	int rc, ret;
+	u32 vpd_vers, fw_vers;
+	int rc;
 
 	rc = t4_get_raw_vpd_params(padap, &vpd);
 	if (rc)
@@ -2699,24 +2699,6 @@ int cudbg_collect_vpd_data(struct cudbg_init *pdbg_init,
 	if (rc)
 		return rc;
 
-	/* Serial Configuration Version is located beyond the PF's vpd size.
-	 * Temporarily give access to entire EEPROM to get it.
-	 */
-	rc = pci_set_vpd_size(padap->pdev, EEPROMVSIZE);
-	if (rc < 0)
-		return rc;
-
-	ret = cudbg_read_vpd_reg(padap, CUDBG_SCFG_VER_ADDR, CUDBG_SCFG_VER_LEN,
-				 &scfg_vers);
-
-	/* Restore back to original PF's vpd size */
-	rc = pci_set_vpd_size(padap->pdev, CUDBG_VPD_PF_SIZE);
-	if (rc < 0)
-		return rc;
-
-	if (ret)
-		return ret;
-
 	rc = cudbg_read_vpd_reg(padap, CUDBG_VPD_VER_ADDR, CUDBG_VPD_VER_LEN,
 				vpd_str);
 	if (rc)
@@ -2737,7 +2719,7 @@ int cudbg_collect_vpd_data(struct cudbg_init *pdbg_init,
 	memcpy(vpd_data->bn, vpd.pn, PN_LEN + 1);
 	memcpy(vpd_data->na, vpd.na, MACADDR_LEN + 1);
 	memcpy(vpd_data->mn, vpd.id, ID_LEN + 1);
-	vpd_data->scfg_vers = scfg_vers;
+	vpd_data->scfg_vers = t4_read_reg(padap, PCIE_STATIC_SPARE2_A);
 	vpd_data->vpd_vers = vpd_vers;
 	vpd_data->fw_major = FW_HDR_FW_VER_MAJOR_G(fw_vers);
 	vpd_data->fw_minor = FW_HDR_FW_VER_MINOR_G(fw_vers);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
index b11a172b5174..695916ba0405 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
@@ -884,6 +884,12 @@
 #define TDUE_V(x) ((x) << TDUE_S)
 #define TDUE_F    TDUE_V(1U)
 
+/* SPARE2 register contains 32-bit value at offset 0x6 in Serial INIT
+ * Configuration flashed on EEPROM. This value corresponds to 32-bit
+ * Serial Configuration Version information.
+ */
+#define PCIE_STATIC_SPARE2_A	0x5bfc
+
 /* registers for module MC */
 #define MC_INT_CAUSE_A		0x7518
 #define MC_P_INT_CAUSE_A	0x41318
-- 
2.27.0

