Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1586B392B0B
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 11:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbhE0Jql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 05:46:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39120 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236030AbhE0Jqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 05:46:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14R9euDJ001399;
        Thu, 27 May 2021 02:44:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=2HhwnA2ZGzJy/Zo7i0Pa5H3LcMgnmgfHhDDpqtkF7/0=;
 b=SRucT9JJdJR1P1dbiSGL0+rSUuR7VR0LCX+KmsCNhn5WF4NPl2x6/x3qIxc+viGsLbHH
 KEasvbcZd5d5u2qc8HIIU/aKhC6h/xHcxQZBWebDD5SzBR+JEaVYl8AxmD+hI+L4HjaQ
 ueWZjxs3oPMHrI23AHLl3qIWM3Niv/+QU246dEoIYCQUNPazDJbMbqBJ5JXU5Iy48QTo
 3jMoehD6f52xV45KP8I8lC8LnrPkkIMSVJ0kJfZl41toKrL3LqtQsTec4/qe9IHfk59g
 NiaOQIf2uxmv+Yr7EO27WyYy7IGhhv2GfVKYzokOZr9OX7TA4O7MBSo2AFRSXXNkOU2N kg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38spf3c9gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 02:44:54 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 02:44:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 May 2021 02:44:51 -0700
Received: from hyd1584.marvell.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id CC27B3F703F;
        Thu, 27 May 2021 02:44:49 -0700 (PDT)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <gcherian@marvell.com>,
        <sgoutham@marvell.com>
Subject: [net-next PATCHv3 4/5] octeontx2-af: support for coalescing KPU profiles
Date:   Thu, 27 May 2021 15:14:38 +0530
Message-ID: <20210527094439.1910013-5-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527094439.1910013-1-george.cherian@marvell.com>
References: <20210527094439.1910013-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: l3rUJ4Jzt074p_dlr5X1_EKSZZroMryU
X-Proofpoint-ORIG-GUID: l3rUJ4Jzt074p_dlr5X1_EKSZZroMryU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_04:2021-05-26,2021-05-27 signatures=0
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
index 8114c5fb0c2c..8afa1c6691f6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -427,6 +427,17 @@ struct nix_tx_action {
 #define NIXLF_BCAST_ENTRY	1
 #define NIXLF_PROMISC_ENTRY	2
 
+struct npc_coalesced_kpu_prfl {
+#define NPC_SIGN	0x00666f727063706e
+#define NPC_PRFL_NAME   "npc_prfls_array"
+#define NPC_NAME_LEN	32
+	__le64 signature; /* "npcprof\0" (8 bytes/ASCII characters) */
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
index 52ee58ce9339..bd63305ba6d2 100644
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
+	void __iomem *kpu_prfl_addr;
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
+		kpu_prfl_addr = (void __iomem *)((uintptr_t)rvu->kpu_prfl_addr +
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

