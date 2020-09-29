Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3F627C124
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgI2J3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:29:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25674 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728070AbgI2J25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 05:28:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T9OYJD010725;
        Tue, 29 Sep 2020 02:28:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=wymmcmuoythqCb3ZT2XUrqdPMzkkUdS1rn3CYg2gjUI=;
 b=A4XJYVpRYCnq+s2VtHbANCPJwPRpBPAARhIueHI2bg0pVpOTEHknoD7YQ88ZV5BG/JHG
 ASgrxY3GtrZXbvcjNMsOt79ss7YUarX0ywIBpyNuvVYWjHhTcteGZgEdZe27pkNGp+zo
 ryoB20oIw5iEe5vCxVePuMgD5Pvwo4chVtwq4F8E31I3BH9D15t3lnf/pxpr6UwnZCLW
 gCXzMS4qMCzjX9TCYO0RP5TmsS71oaiTte2dMk6j1rOUEp1tiijJzkqYZb5NsI0sY6cQ
 NjSfy46oXDkilPxcxy8laKntO3qCrwcWCGdJC+F4iQePHwkIK+ztACS1d37gBk/fS6wO 1g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemb7yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 02:28:54 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 02:28:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 02:28:53 -0700
Received: from yoga.marvell.com (unknown [10.95.131.226])
        by maili.marvell.com (Postfix) with ESMTP id 72B773F703F;
        Tue, 29 Sep 2020 02:28:51 -0700 (PDT)
From:   Stanislaw Kardach <skardach@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     <kda@semihalf.com>, Kiran Kumar K <kirankumark@marvell.com>
Subject: [PATCH net-next 7/7] octeontx2-af: add parser support for NAT-T-ESP
Date:   Tue, 29 Sep 2020 11:28:20 +0200
Message-ID: <20200929092820.22487-8-skardach@marvell.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200929092820.22487-1-skardach@marvell.com>
References: <20200929092820.22487-1-skardach@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kiran Kumar K <kirankumark@marvell.com>

Add support for NAT-T-ESP to KPU parser configuration. NAT ESP is a UDP
based protocol. So move ESP to LE so that both UDP and ESP can be
extracted.

Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
Acked-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   |  2 +-
 .../marvell/octeontx2/af/npc_profile.h        | 92 +++++++++++++------
 2 files changed, 65 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index e465da97598f..91a9d00e4fb5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -81,7 +81,6 @@ enum npc_kpu_ld_ltype {
 	NPC_LT_LD_CUSTOM0,
 	NPC_LT_LD_CUSTOM1,
 	NPC_LT_LD_IGMP = 8,
-	NPC_LT_LD_ESP,
 	NPC_LT_LD_AH,
 	NPC_LT_LD_GRE,
 	NPC_LT_LD_NVGRE,
@@ -93,6 +92,7 @@ enum npc_kpu_ld_ltype {
 enum npc_kpu_le_ltype {
 	NPC_LT_LE_VXLAN = 1,
 	NPC_LT_LE_GENEVE,
+	NPC_LT_LE_ESP,
 	NPC_LT_LE_GTPU = 4,
 	NPC_LT_LE_VXLANGPE,
 	NPC_LT_LE_GTPC,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index ce7096349cff..77bb4ed32600 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -63,6 +63,7 @@
 #define NPC_UDP_PORT_VXLANGPE	4790
 #define NPC_UDP_PORT_GENEVE	6081
 #define NPC_UDP_PORT_MPLS	6635
+#define NPC_UDP_PORT_ESP	4500
 
 #define NPC_VXLANGPE_NP_IP	0x1
 #define NPC_VXLANGPE_NP_IP6	0x2
@@ -197,7 +198,6 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU8_IGMP,
 	NPC_S_KPU8_ICMP6,
 	NPC_S_KPU8_GRE,
-	NPC_S_KPU8_ESP,
 	NPC_S_KPU8_AH,
 	NPC_S_KPU9_TU_MPLS_IN_GRE,
 	NPC_S_KPU9_TU_MPLS_IN_NSH,
@@ -209,6 +209,7 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU9_GENEVE,
 	NPC_S_KPU9_GTPC,
 	NPC_S_KPU9_GTPU,
+	NPC_S_KPU9_ESP,
 	NPC_S_KPU10_TU_MPLS_IN_VXLANGPE,
 	NPC_S_KPU10_TU_MPLS_PL,
 	NPC_S_KPU10_TU_MPLS,
@@ -4056,6 +4057,7 @@ static const struct npc_kpu_profile_cam kpu4_cam_entries[] = {
 		0x0000,
 		0x0000,
 		0x0000,
+		0x0000,
 	},
 	{
 		NPC_S_KPU4_FDSA, 0xff,
@@ -5421,15 +5423,24 @@ static const struct npc_kpu_profile_cam kpu8_cam_entries[] = {
 	},
 	{
 		NPC_S_KPU8_UDP, 0xff,
+		NPC_UDP_PORT_ESP,
+		0xffff,
 		0x0000,
 		0x0000,
 		0x0000,
 		0x0000,
+	},
+	{
+		NPC_S_KPU8_UDP, 0xff,
+		0x0000,
+		0x0000,
+		NPC_UDP_PORT_ESP,
+		0xffff,
 		0x0000,
 		0x0000,
 	},
 	{
-		NPC_S_KPU8_SCTP, 0xff,
+		NPC_S_KPU8_UDP, 0xff,
 		0x0000,
 		0x0000,
 		0x0000,
@@ -5438,7 +5449,7 @@ static const struct npc_kpu_profile_cam kpu8_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU8_ICMP, 0xff,
+		NPC_S_KPU8_SCTP, 0xff,
 		0x0000,
 		0x0000,
 		0x0000,
@@ -5447,7 +5458,7 @@ static const struct npc_kpu_profile_cam kpu8_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU8_IGMP, 0xff,
+		NPC_S_KPU8_ICMP, 0xff,
 		0x0000,
 		0x0000,
 		0x0000,
@@ -5456,7 +5467,7 @@ static const struct npc_kpu_profile_cam kpu8_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU8_ICMP6, 0xff,
+		NPC_S_KPU8_IGMP, 0xff,
 		0x0000,
 		0x0000,
 		0x0000,
@@ -5465,7 +5476,7 @@ static const struct npc_kpu_profile_cam kpu8_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU8_ESP, 0xff,
+		NPC_S_KPU8_ICMP6, 0xff,
 		0x0000,
 		0x0000,
 		0x0000,
@@ -6403,6 +6414,15 @@ static const struct npc_kpu_profile_cam kpu9_cam_entries[] = {
 		0x0000,
 		NPC_MPLS_S,
 	},
+	{
+		NPC_S_KPU9_ESP, 0xff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
 	{
 		NPC_S_NA, 0X00,
 		0x0000,
@@ -10246,8 +10266,8 @@ static const struct npc_kpu_profile_action kpu5_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 2, 0,
-		NPC_S_KPU8_ESP, 20, 1,
+		0, 0, 0, 3, 0,
+		NPC_S_KPU9_ESP, 20, 1,
 		NPC_LID_LC, NPC_LT_LC_IP,
 		0,
 		0, 0, 0, 0,
@@ -10350,8 +10370,8 @@ static const struct npc_kpu_profile_action kpu5_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 2, 0,
-		NPC_S_KPU8_ESP, 0, 1,
+		0, 0, 0, 3, 0,
+		NPC_S_KPU9_ESP, 0, 1,
 		NPC_LID_LC, NPC_LT_LC_IP_OPT,
 		0,
 		0, 0xf, 0, 2,
@@ -10558,8 +10578,8 @@ static const struct npc_kpu_profile_action kpu5_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 2, 0,
-		NPC_S_KPU8_ESP, 40, 1,
+		0, 0, 0, 3, 0,
+		NPC_S_KPU9_ESP, 40, 1,
 		NPC_LID_LC, NPC_LT_LC_IP6_EXT,
 		0,
 		0, 0, 0, 0,
@@ -10833,8 +10853,8 @@ static const struct npc_kpu_profile_action kpu6_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 1, 0,
-		NPC_S_KPU8_ESP, 8, 0,
+		0, 0, 0, 2, 0,
+		NPC_S_KPU9_ESP, 8, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		1, 0xff, 0, 3,
@@ -10937,8 +10957,8 @@ static const struct npc_kpu_profile_action kpu6_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 1, 0,
-		NPC_S_KPU8_ESP, 8, 0,
+		0, 0, 0, 2, 0,
+		NPC_S_KPU9_ESP, 8, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		1, 0xff, 0, 3,
@@ -11052,8 +11072,8 @@ static const struct npc_kpu_profile_action kpu7_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 0,
-		NPC_S_KPU8_ESP, 8, 0,
+		0, 0, 0, 1, 0,
+		NPC_S_KPU9_ESP, 8, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		1, 0xff, 0, 3,
@@ -11373,6 +11393,22 @@ static const struct npc_kpu_profile_action kpu8_action_entries[] = {
 		0,
 		0, 0, 0, 0,
 	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		0, 0, 0, 0, 0,
+		NPC_S_KPU9_ESP, 8, 1,
+		NPC_LID_LD, NPC_LT_LD_UDP,
+		0,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		0, 0, 0, 0, 0,
+		NPC_S_KPU9_ESP, 8, 1,
+		NPC_LID_LD, NPC_LT_LD_UDP,
+		0,
+		0, 0, 0, 0,
+	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 7, 0,
@@ -11413,14 +11449,6 @@ static const struct npc_kpu_profile_action kpu8_action_entries[] = {
 		0,
 		0, 0, 0, 0,
 	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 1,
-		NPC_S_NA, 0, 1,
-		NPC_LID_LD, NPC_LT_LD_ESP,
-		0,
-		0, 0, 0, 0,
-	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -12248,6 +12276,14 @@ static const struct npc_kpu_profile_action kpu9_action_entries[] = {
 		0,
 		0, 0, 0, 0,
 	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 1,
+		NPC_LID_LE, NPC_LT_LE_ESP,
+		0,
+		0, 0, 0, 0,
+	},
 	{
 		NPC_ERRLEV_LE, NPC_EC_UNK,
 		0, 0, 0, 0, 1,
@@ -13316,8 +13352,8 @@ static const struct npc_lt_def_cfg npc_lt_defaults = {
 	},
 	.rx_ipsec = {
 		{
-			.lid = NPC_LID_LD,
-			.ltype_match = NPC_LT_LD_ESP,
+			.lid = NPC_LID_LE,
+			.ltype_match = NPC_LT_LE_ESP,
 			.ltype_mask = 0x0F,
 		},
 		{
-- 
2.20.1

