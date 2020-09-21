Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8106273154
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgIUR5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:57:34 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30058 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbgIUR5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 13:57:33 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08LHtBBH030685;
        Mon, 21 Sep 2020 10:57:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=nE7oygH6t7hUI3JbhPPrnOHvRHlmU8ahvB9lfU4LeVM=;
 b=IufSumSG82ex9/A29673ib7NhFlNU0jY0W1DXOamrYDcqXckl26lzXICERL8ziZfTXIJ
 jPSGa9wVU2oG5G9/x8ho2sHToLBWL/2KsbpTkmwBE4ZVsvpNSieH9vFj1+Ab3F6I4xZV
 LLtIMXKskGvH0x8TymD98JH2luVgKW2i97tJsS1Jx1UI0qKRTWcM2bAIiaBunrO6mI/z
 lahG23Lkiomd+YIstK0I8lq7lw9u2n9HpLk+uUrk/9z8bq0iUAkHgaEMoA+O3ea2EsO+
 rgJe1o1Eu9+nBEFJ9D1vvfwpzuGuHiMAYBU436VczL1UA6Iq6uROVtsBgxQ0tHY+IF6E wQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33nfbpq3u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 10:57:31 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Sep
 2020 10:57:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 21 Sep 2020 10:57:30 -0700
Received: from yoga.marvell.com (unknown [10.95.131.144])
        by maili.marvell.com (Postfix) with ESMTP id 1D4893F703F;
        Mon, 21 Sep 2020 10:57:27 -0700 (PDT)
From:   Stanislaw Kardach <skardach@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     <kda@semihalf.com>, Stanislaw Kardach <skardach@marvell.com>
Subject: [PATCH net-next v2 1/3] octeontx2-af: fix LD CUSTOM LTYPE aliasing
Date:   Mon, 21 Sep 2020 19:54:40 +0200
Message-ID: <20200921175442.16789-2-skardach@marvell.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200921175442.16789-1-skardach@marvell.com>
References: <20200921175442.16789-1-skardach@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_06:2020-09-21,2020-09-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since LD contains LTYPE definitions tweaked toward efficient
NIX_AF_RX_FLOW_KEY_ALG(0..31)_FIELD(0..4) usage, the original location
of NPC_LT_LD_CUSTOM0/1 was aliased with MPLS_IN_* definitions.
Moving custom frame to value 6 and 7 removes the aliasing at the cost of
custom frames being also considered when TCP/UDP RSS algo is configured.

However since the goal of CUSTOM frames is to classify them to a
separate set of RQs, this cost is acceptable.

Change-Id: I7d545e97f2bd652a7da77789091f66378f3018e4
Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 95c646ae7e23..4f36e5cd8ced 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -77,6 +77,8 @@ enum npc_kpu_ld_ltype {
 	NPC_LT_LD_ICMP,
 	NPC_LT_LD_SCTP,
 	NPC_LT_LD_ICMP6,
+	NPC_LT_LD_CUSTOM0,
+	NPC_LT_LD_CUSTOM1,
 	NPC_LT_LD_IGMP = 8,
 	NPC_LT_LD_ESP,
 	NPC_LT_LD_AH,
@@ -85,8 +87,6 @@ enum npc_kpu_ld_ltype {
 	NPC_LT_LD_NSH,
 	NPC_LT_LD_TU_MPLS_IN_NSH,
 	NPC_LT_LD_TU_MPLS_IN_IP,
-	NPC_LT_LD_CUSTOM0 = 0xE,
-	NPC_LT_LD_CUSTOM1 = 0xF,
 };
 
 enum npc_kpu_le_ltype {
-- 
2.20.1

