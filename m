Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E99569959
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 06:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbiGGEp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 00:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbiGGEpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 00:45:25 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B883630566;
        Wed,  6 Jul 2022 21:45:21 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2674gQ5a017857;
        Wed, 6 Jul 2022 21:45:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=a51kSL5pP0Arjd3xQWuFH6EnupWV13FhDA9OUm5CtYc=;
 b=YwB9Wcx1H/HnZ2zNPY4OCcToFLpiixRCGN99iFAt5d3Vdm/2DO/Ce0MkAUxS+gNAGPRF
 qp9A0/00LGGg6ekvwGTdtun2d43hpjw88Y0igCxAZoPLdV/OqHXRm+FOqE4HC3zJCEvk
 49NFP/LTgFENdggwJeygJ9Lt+NA83TXcqwILGtxurHdOps0Jq/vLMLialXH1p6XsIhP9
 0mTam6GUNR0cscYuPKa0kvENERf5hMW9iNwu/AcTllbd62XlNyZPnW0bMfKTRL4GWGVK
 1P4az3wGQ8yOvXEJukFUXsej3nfJ9noHqUgftNbdkkk3xaS14kKjlFJg2YLJekaSEshv lA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h56wt48fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 21:45:10 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 Jul
 2022 21:45:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 6 Jul 2022 21:45:08 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id EE7EE3F706D;
        Wed,  6 Jul 2022 21:45:05 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [PATCH V2 03/12] octeontx2-af: Exact match scan from kex profile
Date:   Thu, 7 Jul 2022 10:13:55 +0530
Message-ID: <20220707044404.2723378-4-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220707044404.2723378-1-rkannoth@marvell.com>
References: <20220707044404.2723378-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Yj_pz0eD1CEMxPLYWZr1k0qRjkg7kRvx
X-Proofpoint-GUID: Yj_pz0eD1CEMxPLYWZr1k0qRjkg7kRvx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_02,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CN10KB silicon supports exact match table. Scanning KEX
profile should check for exact match feature is enabled
and then set profile masks properly.

These kex profile masks are required to configure NPC
MCAM drop rules. If there is a miss in exact match table,
these drop rules will drop those packets.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   |  1 +
 .../marvell/octeontx2/af/rvu_npc_fs.c         | 37 +++++++++++++++++--
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 69f9517c61f4..f187293e3e08 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -208,6 +208,7 @@ enum key_fields {
 	NPC_ERRLEV,
 	NPC_ERRCODE,
 	NPC_LXMB,
+	NPC_EXACT_RESULT,
 	NPC_LA,
 	NPC_LB,
 	NPC_LC,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 08a0fa44857e..4a8618731fc6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -229,6 +229,25 @@ static bool npc_check_field(struct rvu *rvu, int blkaddr, enum key_fields type,
 	return true;
 }
 
+static void npc_scan_exact_result(struct npc_mcam *mcam, u8 bit_number,
+				  u8 key_nibble, u8 intf)
+{
+	u8 offset = (key_nibble * 4) % 64; /* offset within key word */
+	u8 kwi = (key_nibble * 4) / 64; /* which word in key */
+	u8 nr_bits = 4; /* bits in a nibble */
+	u8 type;
+
+	switch (bit_number) {
+	case 40 ... 43:
+		type = NPC_EXACT_RESULT;
+		break;
+
+	default:
+		return;
+	}
+	npc_set_kw_masks(mcam, type, nr_bits, kwi, offset, intf);
+}
+
 static void npc_scan_parse_result(struct npc_mcam *mcam, u8 bit_number,
 				  u8 key_nibble, u8 intf)
 {
@@ -511,8 +530,8 @@ static int npc_scan_kex(struct rvu *rvu, int blkaddr, u8 intf)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u8 lid, lt, ld, bitnr;
+	u64 cfg, masked_cfg;
 	u8 key_nibble = 0;
-	u64 cfg;
 
 	/* Scan and note how parse result is going to be in key.
 	 * A bit set in PARSE_NIBBLE_ENA corresponds to a nibble from
@@ -520,12 +539,24 @@ static int npc_scan_kex(struct rvu *rvu, int blkaddr, u8 intf)
 	 * will be concatenated in key.
 	 */
 	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(intf));
-	cfg &= NPC_PARSE_NIBBLE;
-	for_each_set_bit(bitnr, (unsigned long *)&cfg, 31) {
+	masked_cfg = cfg & NPC_PARSE_NIBBLE;
+	for_each_set_bit(bitnr, (unsigned long *)&masked_cfg, 31) {
 		npc_scan_parse_result(mcam, bitnr, key_nibble, intf);
 		key_nibble++;
 	}
 
+	/* Ignore exact match bits for mcam entries except the first rule
+	 * which is drop on hit. This first rule is configured explitcitly by
+	 * exact match code.
+	 */
+	masked_cfg = cfg & NPC_EXACT_NIBBLE;
+	bitnr = NPC_EXACT_NIBBLE_START;
+	for_each_set_bit_from(bitnr, (unsigned long *)&masked_cfg,
+			      NPC_EXACT_NIBBLE_START) {
+		npc_scan_exact_result(mcam, bitnr, key_nibble, intf);
+		key_nibble++;
+	}
+
 	/* Scan and note how layer data is going to be in key */
 	for (lid = 0; lid < NPC_MAX_LID; lid++) {
 		for (lt = 0; lt < NPC_MAX_LT; lt++) {
-- 
2.25.1

