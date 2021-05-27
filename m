Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DF0392561
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 05:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbhE0D0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 23:26:33 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10652 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234025AbhE0D0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 23:26:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14R3OvP1015447;
        Wed, 26 May 2021 20:24:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=lAyfz0g8Plbi7kl2/qWxwrQa4loQgORCPJ4RIFO8J1g=;
 b=V8FC7BbJrRbdaBYNagaUotppISyj75VcEw0SR3OaXkSGj3z03mHQqJV1Ash6z43VE2Db
 SfgM5DwQuvjWzuVK7lTzTppyWoJfFdeakLNOatEL6E6Ovq9miEz+eCiQYiOMGHzpWRzg
 neKzzeT+lKSdI8SSdhjNFtnQJlNdETJdORV5Ql12d6v+WYPN0T0rHbNa4NajOaiGmQNB
 4RJIuvyKaRXmNXbqBaIVlYv3ja4ns1Pf+mEq4poJTIzH5tDBp416jTfEwyCcObD4/1Yg
 R/DmQerGgY04iBfkgRQi3tdaxhHwQasagdwb31/crZC9m7izjlDG/EPOTJw+DRAsoXXr MQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 38spf3b394-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 20:24:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 20:24:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 20:24:51 -0700
Received: from hyd1584.marvell.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id F13843F703F;
        Wed, 26 May 2021 20:24:49 -0700 (PDT)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <gcherian@marvell.com>,
        <sgoutham@marvell.com>
Subject: [net-next PATCHv2 2/5] octeontx2-af: load NPC profile via firmware database
Date:   Thu, 27 May 2021 08:54:41 +0530
Message-ID: <20210527032444.3204054-3-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527032444.3204054-1-george.cherian@marvell.com>
References: <20210527032444.3204054-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: ViwWylBvJuIlw4CI4APLof4XH3o1d8-e
X-Proofpoint-ORIG-GUID: ViwWylBvJuIlw4CI4APLof4XH3o1d8-e
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_01:2021-05-26,2021-05-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harman Kalra <hkalra@marvell.com>

Currently NPC profile (KPU + MKEX) can be loaded using firmware
binary in filesystem scheme. Enhancing the functionality to load
NPC profile image from system firmware database. It uses the same
technique as used for loading MKEX profile. Firstly firmware binary
in kernel is checked for a valid image else tries to load NPC profile
from firmware database and at last uses default profile if no proper
image found.

Signed-off-by: Harman Kalra <hkalra@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@marvell.com>
Signed-off-by: George Cherian <george.cherian@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   1 +
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 113 +++++++++++++++---
 2 files changed, 99 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index fb142520e309..74ed929f101b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -442,6 +442,7 @@ struct rvu {
 	struct rvu_fwdata	*fwdata;
 	void			*kpu_fwdata;
 	size_t			kpu_fwdata_sz;
+	void __iomem		*kpu_prfl_addr;
 
 	/* NPC KPU data */
 	struct npc_kpu_profile_adapter kpu;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 254b768155cd..61df80cfed1a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1134,6 +1134,30 @@ static void npc_program_mkex_profile(struct rvu *rvu, int blkaddr,
 	}
 }
 
+static int npc_fwdb_prfl_img_map(struct rvu *rvu, void __iomem **prfl_img_addr,
+				 u64 *size)
+{
+	u64 prfl_addr, prfl_sz;
+
+	if (!rvu->fwdata)
+		return -EINVAL;
+
+	prfl_addr = rvu->fwdata->mcam_addr;
+	prfl_sz = rvu->fwdata->mcam_sz;
+
+	if (!prfl_addr || !prfl_sz)
+		return -EINVAL;
+
+	*prfl_img_addr = ioremap_wc(prfl_addr, prfl_sz);
+	if (!(*prfl_img_addr))
+		return -ENOMEM;
+
+	*size = prfl_sz;
+
+	return 0;
+}
+
+/* strtoull of "mkexprof" with base:36 */
 #define MKEX_END_SIGN  0xdeadbeef
 
 static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr,
@@ -1142,26 +1166,20 @@ static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr,
 	struct device *dev = &rvu->pdev->dev;
 	struct npc_mcam_kex *mcam_kex;
 	void *mkex_prfl_addr = NULL;
-	u64 prfl_addr, prfl_sz;
+	u64 prfl_sz;
+	int ret;
 
 	/* If user not selected mkex profile */
 	if (rvu->kpu_fwdata_sz ||
 	    !strncmp(mkex_profile, def_pfl_name, MKEX_NAME_LEN))
 		goto program_mkex;
 
-	if (!rvu->fwdata)
-		goto program_mkex;
-	prfl_addr = rvu->fwdata->mcam_addr;
-	prfl_sz = rvu->fwdata->mcam_sz;
-
-	if (!prfl_addr || !prfl_sz)
-		goto program_mkex;
-
-	mkex_prfl_addr = memremap(prfl_addr, prfl_sz, MEMREMAP_WC);
-	if (!mkex_prfl_addr)
+	/* Setting up the mapping for mkex profile image */
+	ret = npc_fwdb_prfl_img_map(rvu, &mkex_prfl_addr, &prfl_sz);
+	if (ret < 0)
 		goto program_mkex;
 
-	mcam_kex = (struct npc_mcam_kex *)mkex_prfl_addr;
+	mcam_kex = (struct npc_mcam_kex __force *)mkex_prfl_addr;
 
 	while (((s64)prfl_sz > 0) && (mcam_kex->mkex_sign != MKEX_END_SIGN)) {
 		/* Compare with mkex mod_param name string */
@@ -1386,6 +1404,40 @@ static int npc_apply_custom_kpu(struct rvu *rvu,
 	return 0;
 }
 
+static int npc_load_kpu_profile_fwdb(struct rvu *rvu, const char *kpu_profile)
+{
+	struct npc_kpu_profile_fwdata *kpu_fw = NULL;
+	u64 prfl_sz;
+	int ret;
+
+	/* Setting up the mapping for NPC profile image */
+	ret = npc_fwdb_prfl_img_map(rvu, &rvu->kpu_prfl_addr, &prfl_sz);
+	if (ret < 0)
+		return ret;
+
+	rvu->kpu_fwdata =
+		(struct npc_kpu_profile_fwdata __force *)rvu->kpu_prfl_addr;
+	rvu->kpu_fwdata_sz = prfl_sz;
+
+	kpu_fw = rvu->kpu_fwdata;
+	if (le64_to_cpu(kpu_fw->signature) == KPU_SIGN &&
+	    !strncmp(kpu_fw->name, kpu_profile, KPU_NAME_LEN)) {
+		dev_info(rvu->dev, "Loading KPU profile from firmware db: %s\n",
+			 kpu_profile);
+		return 0;
+	}
+
+	/* Cleaning up if KPU profile image from fwdata is not valid. */
+	if (rvu->kpu_prfl_addr) {
+		iounmap(rvu->kpu_prfl_addr);
+		rvu->kpu_prfl_addr = NULL;
+		rvu->kpu_fwdata_sz = 0;
+		rvu->kpu_fwdata = NULL;
+	}
+
+	return -EINVAL;
+}
+
 static void npc_load_kpu_profile(struct rvu *rvu)
 {
 	struct npc_kpu_profile_adapter *profile = &rvu->kpu;
@@ -1398,19 +1450,47 @@ static void npc_load_kpu_profile(struct rvu *rvu)
 	/* First prepare default KPU, then we'll customize top entries. */
 	npc_prepare_default_kpu(profile);
 
-	dev_info(rvu->dev, "Loading KPU profile from firmware: %s\n",
-		 kpu_profile);
+	/* Order of preceedence for load loading NPC profile (high to low)
+	 * Firmware binary in filesystem.
+	 * Firmware database method.
+	 * Default KPU profile.
+	 */
 	if (!request_firmware(&fw, kpu_profile, rvu->dev)) {
+		dev_info(rvu->dev, "Loading KPU profile from firmware: %s\n",
+			 kpu_profile);
 		rvu->kpu_fwdata = kzalloc(fw->size, GFP_KERNEL);
 		if (rvu->kpu_fwdata) {
 			memcpy(rvu->kpu_fwdata, fw->data, fw->size);
 			rvu->kpu_fwdata_sz = fw->size;
 		}
 		release_firmware(fw);
+		goto program_kpu;
 	}
 
+load_image_fwdb:
+	/* Loading the KPU profile using firmware database */
+	if (npc_load_kpu_profile_fwdb(rvu, kpu_profile))
+		goto revert_to_default;
+
+program_kpu:
 	/* Apply profile customization if firmware was loaded. */
 	if (!rvu->kpu_fwdata_sz || npc_apply_custom_kpu(rvu, profile)) {
+		/* If image from firmware filesystem fails to load or invalid
+		 * retry with firmware database method.
+		 */
+		if (rvu->kpu_fwdata || rvu->kpu_fwdata_sz) {
+			/* Loading image from firmware database failed. */
+			if (rvu->kpu_prfl_addr) {
+				iounmap(rvu->kpu_prfl_addr);
+				rvu->kpu_prfl_addr = NULL;
+			} else {
+				kfree(rvu->kpu_fwdata);
+			}
+			rvu->kpu_fwdata = NULL;
+			rvu->kpu_fwdata_sz = 0;
+			goto load_image_fwdb;
+		}
+
 		dev_warn(rvu->dev,
 			 "Can't load KPU profile %s. Using default.\n",
 			 kpu_profile);
@@ -1765,7 +1845,10 @@ void rvu_npc_freemem(struct rvu *rvu)
 
 	kfree(pkind->rsrc.bmap);
 	kfree(mcam->counters.bmap);
-	kfree(rvu->kpu_fwdata);
+	if (rvu->kpu_prfl_addr)
+		iounmap(rvu->kpu_prfl_addr);
+	else
+		kfree(rvu->kpu_fwdata);
 	mutex_destroy(&mcam->lock);
 }
 
-- 
2.25.1

