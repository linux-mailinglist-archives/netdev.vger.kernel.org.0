Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF06127C11B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgI2J2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:28:45 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29902 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727746AbgI2J2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 05:28:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T9QOIQ003560;
        Tue, 29 Sep 2020 02:28:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=ppC4oO3GRq3LEBptplyLOfYv+x/ofZgW8yVmt/cQmMI=;
 b=R8TKpKb43Gre9rPV17UAJqhEaw2bL5sHgMxtZVh4NR6VRjbD+dXFBtdWm5c+XVH8dKAn
 NLBUvYhh8liTHbv5QgUE+QHOvYcqUo5MWmYREN8vxaSKdeumjWV375biPYSWyAr7c8mc
 t9C8TCt2vTbpMbFiEyrZiJ64S0lR4GIP/Fyi1jZ9OCjJHqft6gSGcmUwK5yP0xxzCaI8
 0x0fdnwRMQJn9KD3M6/OCbsU1xf8TlK39Lw0gaR/IXbHgcne/N+d1a3JHi7m7PglrNGh
 Nw/UGF7Q2+kL/t5tpdo3TAjMQ3JGIqwRaC79+WxlIiuv0lf76ns+zMUGrZqtv4zzW7TX gA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55p5aqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 02:28:40 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 02:28:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 02:28:39 -0700
Received: from yoga.marvell.com (unknown [10.95.131.226])
        by maili.marvell.com (Postfix) with ESMTP id 0AFF03F703F;
        Tue, 29 Sep 2020 02:28:36 -0700 (PDT)
From:   Stanislaw Kardach <skardach@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     <kda@semihalf.com>, Stanislaw Kardach <skardach@marvell.com>
Subject: [PATCH net-next 1/7] octeontx2-af: fix LD CUSTOM LTYPE aliasing
Date:   Tue, 29 Sep 2020 11:28:14 +0200
Message-ID: <20200929092820.22487-2-skardach@marvell.com>
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

Since LD contains LTYPE definitions tweaked toward efficient
NIX_AF_RX_FLOW_KEY_ALG(0..31)_FIELD(0..4) usage, the original location
of NPC_LT_LD_CUSTOM0/1 was aliased with MPLS_IN_* definitions.
Moving custom frame to value 6 and 7 removes the aliasing at the cost of
custom frames being also considered when TCP/UDP RSS algo is configured.

However since the goal of CUSTOM frames is to classify them to a
separate set of RQs, this cost is acceptable.

Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
Acked-by: Sunil Goutham <sgoutham@marvell.com>
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

