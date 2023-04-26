Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0CD76EEF8E
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 09:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240030AbjDZHoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 03:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240051AbjDZHob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 03:44:31 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9C144A3;
        Wed, 26 Apr 2023 00:44:17 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q6rMgL001960;
        Wed, 26 Apr 2023 00:44:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=oeASTIACqjLqjgo40S/3synelPRRKm5Hez+ARr3FyuI=;
 b=BK5lVq3wHhT4NP9KvHF4LdhUlj9KQBaRT4SAQG9y/CpSiwjfdNCIcIqtFpOBub43jr89
 4FDbjjEKu/oRHXxpsGwcrYSt7NW5GQq0mTm8nDxsRxOj9MXQHNnDKeJzYkdyeFv2lNVq
 WQd4lj1ifEIIZ3cMZuQj39NLQdzFuD6roeyfEKKeXSjDUjxkdnaPz7N0GnalAb1R4ICX
 zhXgEdVeqiv+DOPqFEZqvL9Ut/qwD6Am8LPMVWGw+6lUtl0BKuAOGfTqBR7xoSDbUMr/
 BWllfLfKvHk2bGN+GKboRB2dtm+PIoxLKJWklx6MPh0vcHA9cBc6Vh90VbVwKkeOzB/V XQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3pdm8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 00:44:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 26 Apr
 2023 00:44:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 26 Apr 2023 00:44:07 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id 8F0C95B693A;
        Wed, 26 Apr 2023 00:44:02 -0700 (PDT)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <simon.horman@corigine.com>,
        <leon@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC:     Ratheesh Kannoth <rkannoth@marvell.com>,
        Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v4 03/10] octeontx2-af: Fix depth of cam and mem table.
Date:   Wed, 26 Apr 2023 13:13:38 +0530
Message-ID: <20230426074345.750135-4-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230426074345.750135-1-saikrishnag@marvell.com>
References: <20230426074345.750135-1-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: UN1FoLhxF_AhTSUDX0VRye8CBweSb5EC
X-Proofpoint-GUID: UN1FoLhxF_AhTSUDX0VRye8CBweSb5EC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-26_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

