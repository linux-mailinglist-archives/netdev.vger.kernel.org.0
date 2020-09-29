Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4650327C122
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgI2J27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:28:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42300 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727960AbgI2J24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 05:28:56 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T9Qcjn003775;
        Tue, 29 Sep 2020 02:28:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=974XstMV+tU6sH1xj0nacVQlH7BnhJq0PFguUpSohIQ=;
 b=cb8/iyaPC+YbmMnnPvMukN2hgm04rBNZs3TlYJAMBFx1g+mTFF6WKgiPteNdZ9BQBqdh
 27jn8roYSyUPnbLp9+/IFFZssDul9cB6SAx3r3gq2+rYz4gJw1rb68HrBF6J37fjR3VP
 mZAqZ+rNVHFy2T5umNixUw98KZscEpm55Yv1JLlwEHkpHJaQOsOvQDsdbi5GSSg2yzkF
 iM7hxQAwLEQnQtrIjSdyThQNHuYIp9pD51GTJ4THWBzO/cKH+LLzyg4HH95En0qlaZvP
 KP3c/T6WKhV9qdAmJYAnaIZGK96Yx+oc/F0CoCRZKPgHsGE0f/K1zz16glPpxpG1eBP7 bQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55p5arw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 02:28:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 02:28:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 02:28:51 -0700
Received: from yoga.marvell.com (unknown [10.95.131.226])
        by maili.marvell.com (Postfix) with ESMTP id 1EE0F3F7040;
        Tue, 29 Sep 2020 02:28:48 -0700 (PDT)
From:   Stanislaw Kardach <skardach@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     <kda@semihalf.com>, Abhijit Ayarekar <aayarekar@marvell.com>
Subject: [PATCH net-next 6/7] octeontx2-af: optimize parsing of IPv6 fragments
Date:   Tue, 29 Sep 2020 11:28:19 +0200
Message-ID: <20200929092820.22487-7-skardach@marvell.com>
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

From: Abhijit Ayarekar <aayarekar@marvell.com>

IPv6 fragmented packet may not contain completed layer 4 information.
So stop KPU parsing after setting ipv6 fragmentation flag.

Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
Acked-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/af/npc_profile.h        | 80 +++++++++----------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 5f71d3ccd6c8..ce7096349cff 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -10705,80 +10705,80 @@ static const struct npc_kpu_profile_action kpu6_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 12, 0, 1, 0,
-		NPC_S_KPU8_TCP, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 8, 10, 1, 0,
-		NPC_S_KPU8_UDP, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 1, 0,
-		NPC_S_KPU8_SCTP, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 1, 0,
-		NPC_S_KPU8_ICMP, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 1, 0,
-		NPC_S_KPU8_ICMP6, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 1, 0,
-		NPC_S_KPU8_ESP, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 1, 0,
-		NPC_S_KPU8_AH, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 1, 0,
-		NPC_S_KPU8_GRE, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		6, 0, 0, 5, 0,
-		NPC_S_KPU12_TU_IP6, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 6, 10, 2, 0,
-		NPC_S_KPU9_TU_MPLS_IN_IP, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
@@ -11100,80 +11100,80 @@ static const struct npc_kpu_profile_action kpu7_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 12, 0, 0, 0,
-		NPC_S_KPU8_TCP, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 8, 10, 0, 0,
-		NPC_S_KPU8_UDP, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 0,
-		NPC_S_KPU8_SCTP, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 0,
-		NPC_S_KPU8_ICMP, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 0,
-		NPC_S_KPU8_ICMP6, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 0,
-		NPC_S_KPU8_ESP, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 0,
-		NPC_S_KPU8_AH, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 0,
-		NPC_S_KPU8_GRE, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		6, 0, 0, 4, 0,
-		NPC_S_KPU12_TU_IP6, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 6, 10, 1, 0,
-		NPC_S_KPU9_TU_MPLS_IN_IP, 8, 0,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 0,
 		NPC_LID_LC, NPC_LT_NA,
 		0,
 		0, 0, 0, 0,
-- 
2.20.1

