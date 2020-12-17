Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215482DD4FB
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 17:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgLQQLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 11:11:36 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10869 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbgLQQLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 11:11:35 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BHG5Bcd024387;
        Thu, 17 Dec 2020 08:08:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=XCAW/nUK0AqsYCHlhDLr5vrqNA+IzYS7C8hKYpqIFBY=;
 b=UJxgVdrontMzLoUgyuEdgcIQcmTXafH6VPpmiLOub5Laj6m2vVNKv7acFrPhi5vlOZcJ
 NwKEU2oXp3TADGhNZWpyPl5S4bPGJxx0D3MPZj/XpqHV2sAto5KufV1hqp8ZfjsvEir8
 X31qVYugoqCO4bI/bJwojTzUplJuXCeoQKUHWxmxtPxFUYsnSEjY1wxqAbJGC7z/RIEJ
 +jMnRzPRgQDRDDFHnKfrfiT+sRXT4ypKflHe9Yy3wbm7CMSTNQyNZr2D2OTaqamUEX/M
 UZbLX18mgnR09sP9EDPvbvCO9l5kqKh5y1PJ0XjQNAQbNSrAugCMJN/ig62cdsbdmBYF +w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 35cx8tg3ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 08:08:33 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 08:08:26 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 08:08:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 08:08:25 -0800
Received: from stefan-pc.marvell.com (unknown [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 44C273F703F;
        Thu, 17 Dec 2020 08:08:22 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <lironh@marvell.com>
Subject: [PATCH net-next] net: mvpp2: prs: improve ipv4 parse flow
Date:   Thu, 17 Dec 2020 18:07:58 +0200
Message-ID: <1608221278-15043-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_10:2020-12-15,2020-12-17 signatures=0
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

Suggested-by: Liron Himi <lironh@marvell.com>
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 64 ++++++++++++++++----------
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

