Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0008D35DA43
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 10:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243324AbhDMIqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 04:46:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18268 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229996AbhDMIqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 04:46:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13D8jDrB020392;
        Tue, 13 Apr 2021 01:45:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=uZj7vBPS9Fo+zSK1OVzPVDu4QBWUPw4f2HvnivIb/sM=;
 b=dXbV6r8av7oXXUF19wOFwHThdSoMvswu6QKvNvdrLKXYzDVDWYUaIxETDrmNMP3iWwEm
 NbkFrHk8F+K/6Jdh98vRZOBQL0kMgMOHRVU1Jc/5CjGDETKyzAMTBC/UJjT8L9EXWn4A
 Q2Gr9AHEAhUWNb7Os7LHM+f3fZDfBDRuC87nj8NLDCMC0D5aVzag8w05QPQ76+kK2E5T
 /nI+Q9l38//4sqj0WMpmj9Yql6pNpKqOezhRDLbe3OOsCu0e173i9JpcpNyADOeW6i/C
 XiCU8JslGfDeCeoOPx69BpLaexmOngtvFCAaeDnpaF4qi4Fk8U8NniKjmZaKO172SlUl vA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37w6vug7ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 01:45:48 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 13 Apr
 2021 01:45:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 13 Apr 2021 01:45:47 -0700
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 1E8023F703F;
        Tue, 13 Apr 2021 01:45:43 -0700 (PDT)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, <lironh@marvell.com>, <danat@marvell.com>
Subject: [PATCH net-next] net: mvpp2: Add parsing support for different IPv4 IHL values
Date:   Tue, 13 Apr 2021 11:45:31 +0300
Message-ID: <1618303531-16050-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: qSunugGfAAVbtJ_KYgTX1HFxdH5VmA-N
X-Proofpoint-ORIG-GUID: qSunugGfAAVbtJ_KYgTX1HFxdH5VmA-N
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_03:2021-04-13,2021-04-13 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Add parser entries for different IPv4 IHL values.
Each entry will set the L4 header offset according to the IPv4 IHL field.
L3 header offset will set during the parsing of the IPv4 protocol.

Suggested-by: Dana Vardi <danat@marvell.com>
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 107 ++++++++------------
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h |   3 +-
 2 files changed, 43 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index 4812cdb..7cc7d72 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -918,9 +918,8 @@ static int mvpp2_prs_ip4_proto(struct mvpp2 *priv, unsigned short proto,
 	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_FLOWS);
 	mvpp2_prs_sram_bits_set(&pe, MVPP2_PRS_SRAM_LU_GEN_BIT, 1);
 
-	/* Set L4 offset */
-	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L4,
-				  sizeof(struct iphdr) - 4,
+	/* Set L3 offset */
+	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3, -4,
 				  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
 	mvpp2_prs_sram_ai_update(&pe, 0, MVPP2_PRS_IPV4_DIP_AI_BIT);
 	mvpp2_prs_sram_ri_update(&pe, ri, ri_mask | MVPP2_PRS_RI_IP_FRAG_MASK);
@@ -1335,7 +1334,7 @@ static void mvpp2_prs_vid_init(struct mvpp2 *priv)
 static int mvpp2_prs_etype_init(struct mvpp2 *priv)
 {
 	struct mvpp2_prs_entry pe;
-	int tid;
+	int tid, ihl;
 
 	/* Ethertype: PPPoE */
 	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
@@ -1427,67 +1426,43 @@ static int mvpp2_prs_etype_init(struct mvpp2 *priv)
 				MVPP2_PRS_RI_UDF3_MASK);
 	mvpp2_prs_hw_write(priv, &pe);
 
-	/* Ethertype: IPv4 without options */
-	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
-					MVPP2_PE_LAST_FREE_TID);
-	if (tid < 0)
-		return tid;
-
-	memset(&pe, 0, sizeof(pe));
-	mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_L2);
-	pe.index = tid;
-
-	mvpp2_prs_match_etype(&pe, 0, ETH_P_IP);
-	mvpp2_prs_tcam_data_byte_set(&pe, MVPP2_ETH_TYPE_LEN,
-				     MVPP2_PRS_IPV4_HEAD | MVPP2_PRS_IPV4_IHL,
-				     MVPP2_PRS_IPV4_HEAD_MASK |
-				     MVPP2_PRS_IPV4_IHL_MASK);
-
-	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
-	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4,
-				 MVPP2_PRS_RI_L3_PROTO_MASK);
-	/* goto ipv4 dest-address (skip eth_type + IP-header-size - 4) */
-	mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN +
-				 sizeof(struct iphdr) - 4,
-				 MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
-	/* Set L3 offset */
-	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3,
-				  MVPP2_ETH_TYPE_LEN,
-				  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
-
-	/* Update shadow table and hw entry */
-	mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_L2);
-	priv->prs_shadow[pe.index].udf = MVPP2_PRS_UDF_L2_DEF;
-	priv->prs_shadow[pe.index].finish = false;
-	mvpp2_prs_shadow_ri_set(priv, pe.index, MVPP2_PRS_RI_L3_IP4,
-				MVPP2_PRS_RI_L3_PROTO_MASK);
-	mvpp2_prs_hw_write(priv, &pe);
-
-	/* Ethertype: IPv4 with options */
-	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
-					MVPP2_PE_LAST_FREE_TID);
-	if (tid < 0)
-		return tid;
-
-	pe.index = tid;
+	/* Ethertype: IPv4 with header length >= 5 */
+	for (ihl = MVPP2_PRS_IPV4_IHL_MIN; ihl <= MVPP2_PRS_IPV4_IHL_MAX; ihl++) {
+		tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
+						MVPP2_PE_LAST_FREE_TID);
+		if (tid < 0)
+			return tid;
 
-	mvpp2_prs_tcam_data_byte_set(&pe, MVPP2_ETH_TYPE_LEN,
-				     MVPP2_PRS_IPV4_HEAD,
-				     MVPP2_PRS_IPV4_HEAD_MASK);
+		memset(&pe, 0, sizeof(pe));
+		mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_L2);
+		pe.index = tid;
 
-	/* Clear ri before updating */
-	pe.sram[MVPP2_PRS_SRAM_RI_WORD] = 0x0;
-	pe.sram[MVPP2_PRS_SRAM_RI_CTRL_WORD] = 0x0;
-	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4_OPT,
-				 MVPP2_PRS_RI_L3_PROTO_MASK);
+		mvpp2_prs_match_etype(&pe, 0, ETH_P_IP);
+		mvpp2_prs_tcam_data_byte_set(&pe, MVPP2_ETH_TYPE_LEN,
+					     MVPP2_PRS_IPV4_HEAD | ihl,
+					     MVPP2_PRS_IPV4_HEAD_MASK |
+					     MVPP2_PRS_IPV4_IHL_MASK);
+
+		mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
+		mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4,
+					 MVPP2_PRS_RI_L3_PROTO_MASK);
+		/* goto ipv4 dst-address (skip eth_type + IP-header-size - 4) */
+		mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN +
+					 sizeof(struct iphdr) - 4,
+					 MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
+		/* Set L4 offset */
+		mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L4,
+					  MVPP2_ETH_TYPE_LEN + (ihl * 4),
+					  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
 
-	/* Update shadow table and hw entry */
-	mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_L2);
-	priv->prs_shadow[pe.index].udf = MVPP2_PRS_UDF_L2_DEF;
-	priv->prs_shadow[pe.index].finish = false;
-	mvpp2_prs_shadow_ri_set(priv, pe.index, MVPP2_PRS_RI_L3_IP4_OPT,
-				MVPP2_PRS_RI_L3_PROTO_MASK);
-	mvpp2_prs_hw_write(priv, &pe);
+		/* Update shadow table and hw entry */
+		mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_L2);
+		priv->prs_shadow[pe.index].udf = MVPP2_PRS_UDF_L2_DEF;
+		priv->prs_shadow[pe.index].finish = false;
+		mvpp2_prs_shadow_ri_set(priv, pe.index, MVPP2_PRS_RI_L3_IP4,
+					MVPP2_PRS_RI_L3_PROTO_MASK);
+		mvpp2_prs_hw_write(priv, &pe);
+	}
 
 	/* Ethertype: IPv6 without options */
 	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
@@ -1674,7 +1649,8 @@ static int mvpp2_prs_pppoe_init(struct mvpp2 *priv)
 	pe.index = tid;
 
 	mvpp2_prs_tcam_data_byte_set(&pe, MVPP2_ETH_TYPE_LEN,
-				     MVPP2_PRS_IPV4_HEAD | MVPP2_PRS_IPV4_IHL,
+				     MVPP2_PRS_IPV4_HEAD |
+				     MVPP2_PRS_IPV4_IHL_MIN,
 				     MVPP2_PRS_IPV4_HEAD_MASK |
 				     MVPP2_PRS_IPV4_IHL_MASK);
 
@@ -1788,9 +1764,8 @@ static int mvpp2_prs_ip4_init(struct mvpp2 *priv)
 	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_FLOWS);
 	mvpp2_prs_sram_bits_set(&pe, MVPP2_PRS_SRAM_LU_GEN_BIT, 1);
 
-	/* Set L4 offset */
-	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L4,
-				  sizeof(struct iphdr) - 4,
+	/* Set L3 offset */
+	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3, -4,
 				  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
 	mvpp2_prs_sram_ai_update(&pe, 0, MVPP2_PRS_IPV4_DIP_AI_BIT);
 	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L4_OTHER,
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h
index c16e5b9..5ce5907 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h
@@ -28,7 +28,8 @@
 #define MVPP2_PRS_IPV4_MC		0xe0
 #define MVPP2_PRS_IPV4_MC_MASK		0xf0
 #define MVPP2_PRS_IPV4_BC_MASK		0xff
-#define MVPP2_PRS_IPV4_IHL		0x5
+#define MVPP2_PRS_IPV4_IHL_MIN		0x5
+#define MVPP2_PRS_IPV4_IHL_MAX		0xf
 #define MVPP2_PRS_IPV4_IHL_MASK		0xf
 #define MVPP2_PRS_IPV6_MC		0xff
 #define MVPP2_PRS_IPV6_MC_MASK		0xff
-- 
1.9.1

