Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4C82F0796
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 15:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbhAJOeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 09:34:15 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13382 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbhAJOeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 09:34:15 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AEVGUQ021798;
        Sun, 10 Jan 2021 06:31:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=ogBkTpr2Qi/hlmXTap9lkebABE1yx9CRrueYdJjOdM8=;
 b=ehvXr4R/FT4B+eZpVOHDiLApOqTRBNeRHtvTnNisxvs/11Kr9plfDMHIrlhfjXMCT+1l
 MBgDmigO3xLsVdr0cA2S/lHjl4/paMWKHBf6LsmnpKbiX2iw+sPqECFsedn5SdQDKCv/
 Eayj/YWWgrZzQtlCk/5fxNGRicay7t9xaMYDqNk5dClJBcHNnKspaGuyzNcoFcUZUWmH
 7EF1RpMrqtpO8Vc8YH1iPNv3ey7+TwLmMkcCCfJBBxH1OI/8Gho22DVIQIGOuAJoQeqL
 jndoqs+QawzQ7G2fSXG/R4H9iqKQLEywY5EsEw5kon3sQ9tVnah8j/t1JLmz8wtMOiKm Ww== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvphstr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 06:31:16 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 06:31:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 10 Jan 2021 06:31:13 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id C49DA3F7040;
        Sun, 10 Jan 2021 06:31:10 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, <liron@marvell.com>
Subject: [PATCH net-next] net: mvpp2: prs: improve ipv4 parse flow
Date:   Sun, 10 Jan 2021 16:30:59 +0200
Message-ID: <1610289059-14962-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Patch didn't fix any issue, just improve parse flow
and align ipv4 parse flow with ipv6 parse flow.

Currently ipv4 kenguru parser first check IP protocol(TCP/UDP)
and then destination IP address.
Patch introduce reverse ipv4 parse, first destination IP address parsed
and only then IP protocol.
This would allow extend capability for packet L4 parsing and align ipv4
parsing flow with ipv6.

Suggested-by: Liron Himi <liron@marvell.com>
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 64 ++++++++++++--------
 1 file changed, 39 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index 5692c60..b9e5b08 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -882,15 +882,15 @@ static int mvpp2_prs_ip4_proto(struct mvpp2 *priv, unsigned short proto,
 	mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_IP4);
 	pe.index = tid;
 
-	/* Set next lu to IPv4 */
-	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
-	mvpp2_prs_sram_shift_set(&pe, 12, MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
+	/* Finished: go to flowid generation */
+	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_FLOWS);
+	mvpp2_prs_sram_bits_set(&pe, MVPP2_PRS_SRAM_LU_GEN_BIT, 1);
+
 	/* Set L4 offset */
 	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L4,
 				  sizeof(struct iphdr) - 4,
 				  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
-	mvpp2_prs_sram_ai_update(&pe, MVPP2_PRS_IPV4_DIP_AI_BIT,
-				 MVPP2_PRS_IPV4_DIP_AI_BIT);
+	mvpp2_prs_sram_ai_update(&pe, 0, MVPP2_PRS_IPV4_DIP_AI_BIT);
 	mvpp2_prs_sram_ri_update(&pe, ri, ri_mask | MVPP2_PRS_RI_IP_FRAG_MASK);
 
 	mvpp2_prs_tcam_data_byte_set(&pe, 2, 0x00,
@@ -899,7 +899,8 @@ static int mvpp2_prs_ip4_proto(struct mvpp2 *priv, unsigned short proto,
 				     MVPP2_PRS_TCAM_PROTO_MASK);
 
 	mvpp2_prs_tcam_data_byte_set(&pe, 5, proto, MVPP2_PRS_TCAM_PROTO_MASK);
-	mvpp2_prs_tcam_ai_update(&pe, 0, MVPP2_PRS_IPV4_DIP_AI_BIT);
+	mvpp2_prs_tcam_ai_update(&pe, MVPP2_PRS_IPV4_DIP_AI_BIT,
+				 MVPP2_PRS_IPV4_DIP_AI_BIT);
 	/* Unmask all ports */
 	mvpp2_prs_tcam_port_map_set(&pe, MVPP2_PRS_PORT_MASK);
 
@@ -967,12 +968,17 @@ static int mvpp2_prs_ip4_cast(struct mvpp2 *priv, unsigned short l3_cast)
 		return -EINVAL;
 	}
 
-	/* Finished: go to flowid generation */
-	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_FLOWS);
-	mvpp2_prs_sram_bits_set(&pe, MVPP2_PRS_SRAM_LU_GEN_BIT, 1);
+	/* Go again to ipv4 */
+	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
 
-	mvpp2_prs_tcam_ai_update(&pe, MVPP2_PRS_IPV4_DIP_AI_BIT,
+	mvpp2_prs_sram_ai_update(&pe, MVPP2_PRS_IPV4_DIP_AI_BIT,
 				 MVPP2_PRS_IPV4_DIP_AI_BIT);
+
+	/* Shift back to IPv4 proto */
+	mvpp2_prs_sram_shift_set(&pe, -12, MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
+
+	mvpp2_prs_tcam_ai_update(&pe, 0, MVPP2_PRS_IPV4_DIP_AI_BIT);
+
 	/* Unmask all ports */
 	mvpp2_prs_tcam_port_map_set(&pe, MVPP2_PRS_PORT_MASK);
 
@@ -1392,8 +1398,9 @@ static int mvpp2_prs_etype_init(struct mvpp2 *priv)
 	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
 	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4,
 				 MVPP2_PRS_RI_L3_PROTO_MASK);
-	/* Skip eth_type + 4 bytes of IP header */
-	mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN + 4,
+	/* goto ipv4 dest-address (skip eth_type + IP-header-size - 4) */
+	mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN +
+				 sizeof(struct iphdr) - 4,
 				 MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
 	/* Set L3 offset */
 	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3,
@@ -1597,8 +1604,9 @@ static int mvpp2_prs_pppoe_init(struct mvpp2 *priv)
 	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
 	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4_OPT,
 				 MVPP2_PRS_RI_L3_PROTO_MASK);
-	/* Skip eth_type + 4 bytes of IP header */
-	mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN + 4,
+	/* goto ipv4 dest-address (skip eth_type + IP-header-size - 4) */
+	mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN +
+				 sizeof(struct iphdr) - 4,
 				 MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
 	/* Set L3 offset */
 	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3,
@@ -1727,19 +1735,20 @@ static int mvpp2_prs_ip4_init(struct mvpp2 *priv)
 	mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_IP4);
 	pe.index = MVPP2_PE_IP4_PROTO_UN;
 
-	/* Set next lu to IPv4 */
-	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
-	mvpp2_prs_sram_shift_set(&pe, 12, MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
+	/* Finished: go to flowid generation */
+	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_FLOWS);
+	mvpp2_prs_sram_bits_set(&pe, MVPP2_PRS_SRAM_LU_GEN_BIT, 1);
+
 	/* Set L4 offset */
 	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L4,
 				  sizeof(struct iphdr) - 4,
 				  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
-	mvpp2_prs_sram_ai_update(&pe, MVPP2_PRS_IPV4_DIP_AI_BIT,
-				 MVPP2_PRS_IPV4_DIP_AI_BIT);
+	mvpp2_prs_sram_ai_update(&pe, 0, MVPP2_PRS_IPV4_DIP_AI_BIT);
 	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L4_OTHER,
 				 MVPP2_PRS_RI_L4_PROTO_MASK);
 
-	mvpp2_prs_tcam_ai_update(&pe, 0, MVPP2_PRS_IPV4_DIP_AI_BIT);
+	mvpp2_prs_tcam_ai_update(&pe, MVPP2_PRS_IPV4_DIP_AI_BIT,
+				 MVPP2_PRS_IPV4_DIP_AI_BIT);
 	/* Unmask all ports */
 	mvpp2_prs_tcam_port_map_set(&pe, MVPP2_PRS_PORT_MASK);
 
@@ -1752,14 +1761,19 @@ static int mvpp2_prs_ip4_init(struct mvpp2 *priv)
 	mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_IP4);
 	pe.index = MVPP2_PE_IP4_ADDR_UN;
 
-	/* Finished: go to flowid generation */
-	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_FLOWS);
-	mvpp2_prs_sram_bits_set(&pe, MVPP2_PRS_SRAM_LU_GEN_BIT, 1);
+	/* Go again to ipv4 */
+	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
+
+	mvpp2_prs_sram_ai_update(&pe, MVPP2_PRS_IPV4_DIP_AI_BIT,
+				 MVPP2_PRS_IPV4_DIP_AI_BIT);
+
+	/* Shift back to IPv4 proto */
+	mvpp2_prs_sram_shift_set(&pe, -12, MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
+
 	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_UCAST,
 				 MVPP2_PRS_RI_L3_ADDR_MASK);
+	mvpp2_prs_tcam_ai_update(&pe, 0, MVPP2_PRS_IPV4_DIP_AI_BIT);
 
-	mvpp2_prs_tcam_ai_update(&pe, MVPP2_PRS_IPV4_DIP_AI_BIT,
-				 MVPP2_PRS_IPV4_DIP_AI_BIT);
 	/* Unmask all ports */
 	mvpp2_prs_tcam_port_map_set(&pe, MVPP2_PRS_PORT_MASK);
 
-- 
1.9.1

