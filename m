Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7BE391C8E
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbhEZP7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:59:02 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9592 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233593AbhEZP6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:58:46 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QFtoRJ009158;
        Wed, 26 May 2021 08:57:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=JwFaYNLCveAy5xEs/P2klfSlNBvEHYigucKJ/zZ1eb0=;
 b=SVB15liE5ZsmaM0aIH1rzyJ206hwKmr2t9FNZET9z6foMXTAB5UU/WzXDwz+LWRVVGNZ
 kFCv8EaSrm65ndxmB3pz+iuoCD581ibdjf/TWBdZgjcP8v7iSuR5NhKu9gJcAIG7Ehz1
 w6BWLjzyhXU+LwJ0GmHni1Y3hVXDzR6hw4s424Z9hIsgRs2p6kjOp+sW+kemgcL3RPhC
 Ns0dbKC6bq1PEuS3dIS7VdRmEogHT2Q7CE+vggmVp4vHK/SgpY9FN+eKzz59+RB3jXoI
 ahetxUDW9ZFYUuiotW3LfWaEiKynA++krKRCpUDH+1bh/TRKIcs00KBkk3psRDSkLq3z HA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38s0dwdfp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 08:57:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 08:57:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 08:57:10 -0700
Received: from hyd1584.marvell.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id C19F23F703F;
        Wed, 26 May 2021 08:57:07 -0700 (PDT)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <gcherian@marvell.com>,
        <sgoutham@marvell.com>
Subject: [net-next PATCH 4/5] octeontx2-af: support for coalescing KPU profiles
Date:   Wed, 26 May 2021 21:26:55 +0530
Message-ID: <20210526155656.2689892-5-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210526155656.2689892-1-george.cherian@marvell.com>
References: <20210526155656.2689892-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Y-OQ8OQYh6EYMC2VxwEaipYMM_aq3h3F
X-Proofpoint-ORIG-GUID: Y-OQ8OQYh6EYMC2VxwEaipYMM_aq3h3F
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_10:2021-05-26,2021-05-26 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harman Kalra <hkalra@marvell.com>

Adding support to load a new type of KPU image, known as coalesced/
consolidated KPU image via firmware database. This image is a
consolidation of multiple KPU profiles into a single image.

During kernel bootup this coalesced image will be read via 
firmware database and only the relevant KPU profile will be loaded.
Existing functionality of loading single KPU/MKEX profile
is intact as the images are differentiated based on the image signature.

Signed-off-by: Harman Kalra <hkalra@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@marvell.com>
Signed-off-by: George Cherian <george.cherian@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   | 11 +++
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 83 +++++++++++++++----
 2 files changed, 79 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index d5837ec91d1e..948a41428237 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -427,6 +427,17 @@ struct nix_tx_action {
 #define NIXLF_BCAST_ENTRY	1
 #define NIXLF_PROMISC_ENTRY	2
 
+struct npc_coalesced_kpu_prfl {
+#define NPC_SIGN	0x00666f727063706e
+#define NPC_PRFL_NAME   "npc_prfls_array"
+#define NPC_NAME_LEN	32
+	u64 signature; /* "npcprof\0" (8 bytes/ASCII characters) */
+	u8 name[NPC_NAME_LEN]; /* KPU Profile name */
+	u64 version; /* KPU firmware/profile version */
+	u8 num_prfl; /* No of NPC profiles. */
+	u16 prfl_sz[0];
+};
+
 struct npc_mcam_kex {
 	/* MKEX Profle Header */
 	u64 mkex_sign; /* "mcam-kex-profile" (8 bytes/ASCII characters) */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index a5dc2ac8bc4a..8bcb760922ba 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -27,6 +27,8 @@
 #define NPC_KEX_CHAN_MASK		0xFFFULL
 #define NPC_KEX_PF_FUNC_MASK		0xFFFFULL
 
+#define ALIGN_8B_CEIL(__a)	(((__a) + 7) & (-8))
+
 static const char def_pfl_name[] = "default";
 
 static void npc_mcam_free_all_entries(struct rvu *rvu, struct npc_mcam *mcam,
@@ -1417,28 +1419,78 @@ static int npc_apply_custom_kpu(struct rvu *rvu,
 	return 0;
 }
 
+static int npc_load_kpu_prfl_img(struct rvu *rvu, void __iomem *prfl_addr,
+				 u64 prfl_sz, const char *kpu_profile)
+{
+	struct npc_kpu_profile_fwdata *kpu_data = NULL;
+	int rc = -EINVAL;
+
+	kpu_data = (struct npc_kpu_profile_fwdata __force *)prfl_addr;
+	if (le64_to_cpu(kpu_data->signature) == KPU_SIGN &&
+	    !strncmp(kpu_data->name, kpu_profile, KPU_NAME_LEN)) {
+		dev_info(rvu->dev, "Loading KPU profile from firmware db: %s\n",
+			 kpu_profile);
+		rvu->kpu_fwdata = kpu_data;
+		rvu->kpu_fwdata_sz = prfl_sz;
+		rvu->kpu_prfl_addr = prfl_addr;
+		rc = 0;
+	}
+
+	return rc;
+}
+
+static int npc_fwdb_detect_load_prfl_img(struct rvu *rvu, uint64_t prfl_sz,
+					 const char *kpu_profile)
+{
+	struct npc_coalesced_kpu_prfl *img_data = NULL;
+	int i = 0, rc = -EINVAL;
+	void *kpu_prfl_addr;
+	u16 offset;
+
+	img_data = (struct npc_coalesced_kpu_prfl __force *)rvu->kpu_prfl_addr;
+	if (le64_to_cpu(img_data->signature) == KPU_SIGN &&
+	    !strncmp(img_data->name, kpu_profile, KPU_NAME_LEN)) {
+		/* Loaded profile is a single KPU profile. */
+		rc = npc_load_kpu_prfl_img(rvu, rvu->kpu_prfl_addr,
+					   prfl_sz, kpu_profile);
+		goto done;
+	}
+
+	/* Loaded profile is coalesced image, offset of first KPU profile.*/
+	offset = offsetof(struct npc_coalesced_kpu_prfl, prfl_sz) +
+		(img_data->num_prfl * sizeof(uint16_t));
+	/* Check if mapped image is coalesced image. */
+	while (i < img_data->num_prfl) {
+		/* Profile image offsets are rounded up to next 8 multiple.*/
+		offset = ALIGN_8B_CEIL(offset);
+		kpu_prfl_addr = (void *)((uintptr_t)rvu->kpu_prfl_addr +
+					 offset);
+		rc = npc_load_kpu_prfl_img(rvu, kpu_prfl_addr,
+					   img_data->prfl_sz[i], kpu_profile);
+		if (!rc)
+			break;
+		/* Calculating offset of profile image based on profile size.*/
+		offset += img_data->prfl_sz[i];
+		i++;
+	}
+done:
+	return rc;
+}
+
 static int npc_load_kpu_profile_fwdb(struct rvu *rvu, const char *kpu_profile)
 {
-	struct npc_kpu_profile_fwdata *kpu_fw = NULL;
+	int ret = -EINVAL;
 	u64 prfl_sz;
-	int ret;
 
 	/* Setting up the mapping for NPC profile image */
 	ret = npc_fwdb_prfl_img_map(rvu, &rvu->kpu_prfl_addr, &prfl_sz);
 	if (ret < 0)
-		return ret;
+		goto done;
 
-	rvu->kpu_fwdata =
-		(struct npc_kpu_profile_fwdata __force *)rvu->kpu_prfl_addr;
-	rvu->kpu_fwdata_sz = prfl_sz;
-
-	kpu_fw = rvu->kpu_fwdata;
-	if (le64_to_cpu(kpu_fw->signature) == KPU_SIGN &&
-	    !strncmp(kpu_fw->name, kpu_profile, KPU_NAME_LEN)) {
-		dev_info(rvu->dev, "Loading KPU profile from firmware db: %s\n",
-			 kpu_profile);
-		return 0;
-	}
+	/* Detect if profile is coalesced or single KPU profile and load */
+	ret = npc_fwdb_detect_load_prfl_img(rvu, prfl_sz, kpu_profile);
+	if (ret == 0)
+		goto done;
 
 	/* Cleaning up if KPU profile image from fwdata is not valid. */
 	if (rvu->kpu_prfl_addr) {
@@ -1448,7 +1500,8 @@ static int npc_load_kpu_profile_fwdb(struct rvu *rvu, const char *kpu_profile)
 		rvu->kpu_fwdata = NULL;
 	}
 
-	return -EINVAL;
+done:
+	return ret;
 }
 
 static void npc_load_kpu_profile(struct rvu *rvu)
-- 
2.25.1

