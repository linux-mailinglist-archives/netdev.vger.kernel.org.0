Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0EC94DAECB
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 12:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355295AbiCPLVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 07:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348129AbiCPLVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 07:21:38 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335A2403EA
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 04:20:24 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22GAKFwp027716;
        Wed, 16 Mar 2022 04:19:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=H6pLLa8llS9PvTlJmSjsVR3R8pzL5sCmpkscrmI73wA=;
 b=FGmKS9PTfoIX91Iag7Yr8FT4g/9J2wqDyFvAJgVhjOmmUKaUrqkySSQbz8I4I4TA3UUH
 +P5UfAukJ3UiKYnuyzgoxVXMCL7Z2sIrYbWOM2Blo5siypGlzf+voD8CTNiURteZWSFA
 Ui6VUaJdsY6B6rw9mzA4E2+qIX6DPKEzcPROOf5Mj0xp15lFgq1DQNS4bEGMQBfuMVEG
 1IZPpNZVBj0YgCxb9Lwde0GnmvoAILNhBw2J+lyOqC1fHEdXrf0wbJ9ez3bnLOAN6rLn
 0VsbrP1sKnEVLn/g2YhnhD1itjMh9fu2NO6+xvxLicQUbnCkvp28am/3jtex+o4Koexn lg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3eue23g78t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 16 Mar 2022 04:19:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Mar
 2022 04:19:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Mar 2022 04:19:57 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5BC3E3F7044;
        Wed, 16 Mar 2022 04:19:57 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 22GBJQ99028665;
        Wed, 16 Mar 2022 04:19:31 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 22GBImYG028664;
        Wed, 16 Mar 2022 04:18:48 -0700
From:   Manish Chopra <manishc@marvell.com>
To:     <pmenzel@molgen.mpg.de>
CC:     <buczek@molgen.mpg.de>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <it+netdev@molgen.mpg.de>, <regressions@lists.linux.dev>
Subject: [RFC net] bnx2x: fix built-in kernel driver load failure
Date:   Wed, 16 Mar 2022 04:18:42 -0700
Message-ID: <20220316111842.28628-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: ZfUGy4_EeHrltZDmZly6Q4iT5G1NnJWS
X-Proofpoint-ORIG-GUID: ZfUGy4_EeHrltZDmZly6Q4iT5G1NnJWS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-16_04,2022-03-15_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0")
added request_firmware() logic in probe() which caused
built-in kernel driver load failure as access to firmware
file is not feasible during the probe time.

This patch fixes this issue by -

1. Removing request_firmware() logic from the probe() such
   that open() handle it as it used to handle it earlier

2. Relaxing a bit FW version comparisons against the loaded FW
   (to allow many close/compatible FWs to run together now)

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Fixes: b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---

Note that this patch is just for test and get feedback
from Paul Menzel about the issue reported by him on built-in
driver probe failure due to firmware files not found

 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  2 --
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 28 +++++++++++--------
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 15 ++--------
 3 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index a19dd6797070..2209d99b3404 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -2533,6 +2533,4 @@ void bnx2x_register_phc(struct bnx2x *bp);
  * Meant for implicit re-load flows.
  */
 int bnx2x_vlan_reconfigure_vid(struct bnx2x *bp);
-int bnx2x_init_firmware(struct bnx2x *bp);
-void bnx2x_release_firmware(struct bnx2x *bp);
 #endif /* bnx2x.h */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 8d36ebbf08e1..5729a5ab059d 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2364,24 +2364,30 @@ int bnx2x_compare_fw_ver(struct bnx2x *bp, u32 load_code, bool print_err)
 	/* is another pf loaded on this engine? */
 	if (load_code != FW_MSG_CODE_DRV_LOAD_COMMON_CHIP &&
 	    load_code != FW_MSG_CODE_DRV_LOAD_COMMON) {
-		/* build my FW version dword */
-		u32 my_fw = (bp->fw_major) + (bp->fw_minor << 8) +
-				(bp->fw_rev << 16) + (bp->fw_eng << 24);
+		u8 loaded_fw_major, loaded_fw_minor, loaded_fw_rev, loaded_fw_eng;
+		u32 loaded_fw;

 		/* read loaded FW from chip */
-		u32 loaded_fw = REG_RD(bp, XSEM_REG_PRAM);
+		loaded_fw = REG_RD(bp, XSEM_REG_PRAM);

-		DP(BNX2X_MSG_SP, "loaded fw %x, my fw %x\n",
-		   loaded_fw, my_fw);
+		loaded_fw_major = loaded_fw & 0xff;
+		loaded_fw_minor = (loaded_fw >> 8) & 0xff;
+		loaded_fw_rev = (loaded_fw >> 16) & 0xff;
+		loaded_fw_eng = (loaded_fw >> 24) & 0xff;
+
+		DP(BNX2X_MSG_SP, "loaded fw 0x%x major 0x%x minor 0x%x rev 0x%x eng 0x%x\n",
+		   loaded_fw, loaded_fw_major, loaded_fw_minor, loaded_fw_rev, loaded_fw_eng);

 		/* abort nic load if version mismatch */
-		if (my_fw != loaded_fw) {
+		if (loaded_fw_major != BCM_5710_FW_MAJOR_VERSION ||
+		    loaded_fw_minor != BCM_5710_FW_MINOR_VERSION ||
+		    loaded_fw_eng != BCM_5710_FW_ENGINEERING_VERSION ||
+		    loaded_fw_rev < BCM_5710_FW_REVISION_VERSION_V15) {
 			if (print_err)
-				BNX2X_ERR("bnx2x with FW %x was already loaded which mismatches my %x FW. Aborting\n",
-					  loaded_fw, my_fw);
+				BNX2X_ERR("loaded FW incompatible. Aborting\n");
 			else
-				BNX2X_DEV_INFO("bnx2x with FW %x was already loaded which mismatches my %x FW, possibly due to MF UNDI\n",
-					       loaded_fw, my_fw);
+				BNX2X_DEV_INFO("loaded FW incompatible, possibly due to MF UNDI\n");
+
 			return -EBUSY;
 		}
 	}
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index eedb48d945ed..c19b072f3a23 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12319,15 +12319,6 @@ static int bnx2x_init_bp(struct bnx2x *bp)

 	bnx2x_read_fwinfo(bp);

-	if (IS_PF(bp)) {
-		rc = bnx2x_init_firmware(bp);
-
-		if (rc) {
-			bnx2x_free_mem_bp(bp);
-			return rc;
-		}
-	}
-
 	func = BP_FUNC(bp);

 	/* need to reset chip if undi was active */
@@ -12340,7 +12331,6 @@ static int bnx2x_init_bp(struct bnx2x *bp)

 		rc = bnx2x_prev_unload(bp);
 		if (rc) {
-			bnx2x_release_firmware(bp);
 			bnx2x_free_mem_bp(bp);
 			return rc;
 		}
@@ -13409,7 +13399,7 @@ do {									\
 	     (u8 *)bp->arr, len);					\
 } while (0)

-int bnx2x_init_firmware(struct bnx2x *bp)
+static int bnx2x_init_firmware(struct bnx2x *bp)
 {
 	const char *fw_file_name, *fw_file_name_v15;
 	struct bnx2x_fw_file_hdr *fw_hdr;
@@ -13509,7 +13499,7 @@ int bnx2x_init_firmware(struct bnx2x *bp)
 	return rc;
 }

-void bnx2x_release_firmware(struct bnx2x *bp)
+static void bnx2x_release_firmware(struct bnx2x *bp)
 {
 	kfree(bp->init_ops_offsets);
 	kfree(bp->init_ops);
@@ -14026,7 +14016,6 @@ static int bnx2x_init_one(struct pci_dev *pdev,
 	return 0;

 init_one_freemem:
-	bnx2x_release_firmware(bp);
 	bnx2x_free_mem_bp(bp);

 init_one_exit:
--
2.35.1.273.ge6ebfd0

