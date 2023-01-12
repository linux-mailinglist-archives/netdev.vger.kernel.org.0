Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1B9666A80
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 05:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjALEoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 23:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbjALEmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 23:42:36 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442FE10070
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 20:42:21 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C3wHjV002937;
        Wed, 11 Jan 2023 20:42:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=jerIKPcBXMZOatrJD0ZvBQ9s9yoxfZL8SyXRBj19Duc=;
 b=gRknyyXl2ZLMhETlNwqNwj1sDHc2cP/2HCjipM/k/K261m0ueS/IiEIQa0z92e85SSHi
 ALRTPRwvLTE9G8AhriPbZdckrq7Hxzm2EtIhGEiSu94mgu4680qBnhcWwMxmH/TP9UtI
 AjM5jjvx9+ZuJBO0auwG64kyI192JrYriHPuqJfKDWKxb98DWK95IpQq26PEyFGJko3o
 5n8ea3kKoyp10UwV2luEKWBrqHn0YaMInYnS37bTcgtZmHDwMygGmHUpUTmfwNqxH57H
 boISsgTDwbrS8Al71FXFkHICl0caTZLy4qTzq70bFv4EiLbDvA05RgLuzcbNLqcNEBz1 eQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3n23b2gsde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 20:42:16 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 11 Jan
 2023 20:42:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 11 Jan 2023 20:42:14 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 73F893F7051;
        Wed, 11 Jan 2023 20:42:11 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v2 net-next,6/8] octeontx2-af: update CPT inbound inline IPsec config mailbox
Date:   Thu, 12 Jan 2023 10:11:45 +0530
Message-ID: <20230112044147.931159-7-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112044147.931159-1-schalla@marvell.com>
References: <20230112044147.931159-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: FTBGrG3gWCqiPyZZs8yCt8UyEYSl38jj
X-Proofpoint-ORIG-GUID: FTBGrG3gWCqiPyZZs8yCt8UyEYSl38jj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_02,2023-01-11_03,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updates CPT inbound inline IPsec configure mailbox to take
CPT credit, opcode, credit_th and bpid from VF.
This patch also adds a mailbox to read inbound IPsec
configuration.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  6 ++-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 46 +++++++++++++++++--
 2 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index b121e3d9f561..9eac73bfc9cb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -298,6 +298,8 @@ M(NIX_BANDPROF_FREE,	0x801e, nix_bandprof_free, nix_bandprof_free_req,   \
 				msg_rsp)				    \
 M(NIX_BANDPROF_GET_HWINFO, 0x801f, nix_bandprof_get_hwinfo, msg_req,		\
 				nix_bandprof_get_hwinfo_rsp)		    \
+M(NIX_READ_INLINE_IPSEC_CFG, 0x8023, nix_read_inline_ipsec_cfg,		\
+				msg_req, nix_inline_ipsec_cfg)		\
 /* MCS mbox IDs (range 0xA000 - 0xBFFF) */					\
 M(MCS_ALLOC_RESOURCES,	0xa000, mcs_alloc_resources, mcs_alloc_rsrc_req,	\
 				mcs_alloc_rsrc_rsp)				\
@@ -1197,7 +1199,7 @@ struct nix_inline_ipsec_cfg {
 	u32 cpt_credit;
 	struct {
 		u8 egrp;
-		u8 opcode;
+		u16 opcode;
 		u16 param1;
 		u16 param2;
 	} gen_cfg;
@@ -1206,6 +1208,8 @@ struct nix_inline_ipsec_cfg {
 		u8 cpt_slot;
 	} inst_qsel;
 	u8 enable;
+	u16 bpid;
+	u32 credit_th;
 };
 
 /* Per NIX LF inline IPSec configuration */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 6b8747ebc08c..89e94569e74c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4731,6 +4731,10 @@ int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
 #define CPT_INST_QSEL_PF_FUNC GENMASK_ULL(23, 8)
 #define CPT_INST_QSEL_SLOT    GENMASK_ULL(7, 0)
 
+#define CPT_INST_CREDIT_TH    GENMASK_ULL(53, 32)
+#define CPT_INST_CREDIT_BPID  GENMASK_ULL(30, 22)
+#define CPT_INST_CREDIT_CNT   GENMASK_ULL(21, 0)
+
 static void nix_inline_ipsec_cfg(struct rvu *rvu, struct nix_inline_ipsec_cfg *req,
 				 int blkaddr)
 {
@@ -4767,14 +4771,23 @@ static void nix_inline_ipsec_cfg(struct rvu *rvu, struct nix_inline_ipsec_cfg *r
 			    val);
 
 		/* Set CPT credit */
-		rvu_write64(rvu, blkaddr, NIX_AF_RX_CPTX_CREDIT(cpt_idx),
-			    req->cpt_credit);
+		val = rvu_read64(rvu, blkaddr, NIX_AF_RX_CPTX_CREDIT(cpt_idx));
+		if ((val & 0x3FFFFF) != 0x3FFFFF)
+			rvu_write64(rvu, blkaddr, NIX_AF_RX_CPTX_CREDIT(cpt_idx),
+				    0x3FFFFF - val);
+
+		val = FIELD_PREP(CPT_INST_CREDIT_CNT, req->cpt_credit);
+		val |= FIELD_PREP(CPT_INST_CREDIT_BPID, req->bpid);
+		val |= FIELD_PREP(CPT_INST_CREDIT_TH, req->credit_th);
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_CPTX_CREDIT(cpt_idx), val);
 	} else {
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_IPSEC_GEN_CFG, 0x0);
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_CPTX_INST_QSEL(cpt_idx),
 			    0x0);
-		rvu_write64(rvu, blkaddr, NIX_AF_RX_CPTX_CREDIT(cpt_idx),
-			    0x3FFFFF);
+		val = rvu_read64(rvu, blkaddr, NIX_AF_RX_CPTX_CREDIT(cpt_idx));
+		if ((val & 0x3FFFFF) != 0x3FFFFF)
+			rvu_write64(rvu, blkaddr, NIX_AF_RX_CPTX_CREDIT(cpt_idx),
+				    0x3FFFFF - val);
 	}
 }
 
@@ -4792,6 +4805,30 @@ int rvu_mbox_handler_nix_inline_ipsec_cfg(struct rvu *rvu,
 	return 0;
 }
 
+int rvu_mbox_handler_nix_read_inline_ipsec_cfg(struct rvu *rvu,
+					       struct msg_req *req,
+					       struct nix_inline_ipsec_cfg *rsp)
+
+{
+	u64 val;
+
+	if (!is_block_implemented(rvu->hw, BLKADDR_CPT0))
+		return 0;
+
+	val = rvu_read64(rvu, BLKADDR_NIX0, NIX_AF_RX_IPSEC_GEN_CFG);
+	rsp->gen_cfg.egrp = FIELD_GET(IPSEC_GEN_CFG_EGRP, val);
+	rsp->gen_cfg.opcode = FIELD_GET(IPSEC_GEN_CFG_OPCODE, val);
+	rsp->gen_cfg.param1 = FIELD_GET(IPSEC_GEN_CFG_PARAM1, val);
+	rsp->gen_cfg.param2 = FIELD_GET(IPSEC_GEN_CFG_PARAM2, val);
+
+	val = rvu_read64(rvu, BLKADDR_NIX0, NIX_AF_RX_CPTX_CREDIT(0));
+	rsp->cpt_credit = FIELD_GET(CPT_INST_CREDIT_CNT, val);
+	rsp->credit_th = FIELD_GET(CPT_INST_CREDIT_TH, val);
+	rsp->bpid = FIELD_GET(CPT_INST_CREDIT_BPID, val);
+
+	return 0;
+}
+
 int rvu_mbox_handler_nix_inline_ipsec_lf_cfg(struct rvu *rvu,
 					     struct nix_inline_ipsec_lf_cfg *req,
 					     struct msg_rsp *rsp)
@@ -4835,6 +4872,7 @@ int rvu_mbox_handler_nix_inline_ipsec_lf_cfg(struct rvu *rvu,
 
 	return 0;
 }
+
 void rvu_nix_reset_mac(struct rvu_pfvf *pfvf, int pcifunc)
 {
 	bool from_vf = !!(pcifunc & RVU_PFVF_FUNC_MASK);
-- 
2.25.1

