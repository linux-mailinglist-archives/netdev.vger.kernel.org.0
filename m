Return-Path: <netdev+bounces-79-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 628006F50CD
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BAA3280F6F
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B252D4A0F;
	Wed,  3 May 2023 07:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CB44A0E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:10:22 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50065272A;
	Wed,  3 May 2023 00:10:18 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3436ACSu003519;
	Wed, 3 May 2023 00:10:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=oeASTIACqjLqjgo40S/3synelPRRKm5Hez+ARr3FyuI=;
 b=K1zeGR+Ze2e6EVuRB8VBScy+D1zT9DwVQ7IjsLHvApDGvr1QIHAE7gqb3fZKQkXFRs7A
 lDtCu1N/ObIy1Pty883QadcvHIWhSOKvLrYU3/K1ShNMkEXDhgO/XN5VasH0maZgywBh
 njJv8KeGNul1b2hxUPnS6nTLiyfL7Lh0V3IWGnBwxharGbK+8xNoaEpu5PmQnVulZqSW
 +ZUiCCIKr7eYiMNAGUGTenyVVGxxLiNaJ45660I/9AqeOTSDqmSaGJvNi1yzGLZP6x8o
 KM1zC1xN106yjSGi+i2lj79li3f+2g0n78ta9lxn9O/Y3JF9Fd7Ddz3rxUBGfDUXOGPd 8A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q92rp3m7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Wed, 03 May 2023 00:10:10 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 3 May
 2023 00:10:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 3 May 2023 00:10:07 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
	by maili.marvell.com (Postfix) with ESMTP id 68EE73F70B1;
	Wed,  3 May 2023 00:10:01 -0700 (PDT)
From: Sai Krishna <saikrishnag@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <simon.horman@corigine.com>,
        <leon@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC: Ratheesh Kannoth <rkannoth@marvell.com>,
        Sai Krishna
	<saikrishnag@marvell.com>
Subject: [net PATCH v5 03/11] octeontx2-af: Fix depth of cam and mem table.
Date: Wed, 3 May 2023 12:39:36 +0530
Message-ID: <20230503070944.960190-4-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230503070944.960190-1-saikrishnag@marvell.com>
References: <20230503070944.960190-1-saikrishnag@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: BhsQlXW0er5M99E_iJ6uOqggZ91SIv2i
X-Proofpoint-GUID: BhsQlXW0er5M99E_iJ6uOqggZ91SIv2i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_04,2023-04-27_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Ratheesh Kannoth <rkannoth@marvell.com>

In current driver, NPC cam and mem table sizes are read from wrong
register offset. This patch fixes the register offset so that correct
values are populated on read.

Fixes: b747923afff8 ("octeontx2-af: Exact match support")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 20ebb9c95c73..6597af84aa36 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1868,9 +1868,9 @@ int rvu_npc_exact_init(struct rvu *rvu)
 	rvu->hw->table = table;
 
 	/* Read table size, ways and depth */
-	table->mem_table.depth = FIELD_GET(GENMASK_ULL(31, 24), npc_const3);
 	table->mem_table.ways = FIELD_GET(GENMASK_ULL(19, 16), npc_const3);
-	table->cam_table.depth = FIELD_GET(GENMASK_ULL(15, 0), npc_const3);
+	table->mem_table.depth = FIELD_GET(GENMASK_ULL(15, 0), npc_const3);
+	table->cam_table.depth = FIELD_GET(GENMASK_ULL(31, 24), npc_const3);
 
 	dev_dbg(rvu->dev, "%s: NPC exact match 4way_2k table(ways=%d, depth=%d)\n",
 		__func__,  table->mem_table.ways, table->cam_table.depth);
-- 
2.25.1


