Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043BB569BB4
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbiGGHfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbiGGHfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:35:19 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B4631DC9;
        Thu,  7 Jul 2022 00:35:19 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266NFmg3010476;
        Thu, 7 Jul 2022 00:35:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=J+mscuq0rzFRLGU3vTYZUj9ry4jl2MpZU5AsMJ/RLd0=;
 b=kIONoPxGjB8h4diDKOOC5kysTHCcrJpM2koWwoUkkuvWgbqdTimyg3a3Vf8sOBbXNAwV
 4apZh9AkojMnwmzR2BHvEOjMXKEognzq+Oxcz2HCJGbYPWFQeakeGm4/AZPc0ionet4J
 g7kuzQyeSJnnHdrsb5dW7MYsy9yCxNMT/mJq/2Qnf9M6+ciBe0HJd3v2bDnD7O+gacP+
 zRG78rDHCodp4VUc/XBxfWMvbd0pSfww6iMHsyV/BjRC4G3/Fx8mpzt4Z5E7gRIL+DMY
 jJRAJ/VcyTjfcuTnePyg/tkFOouefLJ2hE9j1Fgfwhq+chHwa5U8dqWg8MREOUOLYpYQ wg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3h5kwj1gu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 00:35:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Jul
 2022 00:35:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 Jul 2022 00:35:06 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id 641893F7089;
        Thu,  7 Jul 2022 00:35:04 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net-next PATCH V3 05/12] octeontx2-af: FLR handler for exact match table.
Date:   Thu, 7 Jul 2022 13:03:46 +0530
Message-ID: <20220707073353.2752279-6-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220707073353.2752279-1-rkannoth@marvell.com>
References: <20220707073353.2752279-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: h9wnJHnYq0JRVjpMPM_JEt1M8bf5KwHB
X-Proofpoint-GUID: h9wnJHnYq0JRVjpMPM_JEt1M8bf5KwHB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_05,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FLR handler should remove/free all exact match table resources
corresponding to each interface.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  3 +++
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 27 +++++++++++++++++++
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  1 +
 3 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 1b6e9efbb8ec..88b9856a7b39 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2555,6 +2555,9 @@ static void rvu_blklf_teardown(struct rvu *rvu, u16 pcifunc, u8 blkaddr)
 
 static void __rvu_flr_handler(struct rvu *rvu, u16 pcifunc)
 {
+	if (rvu_npc_exact_has_match_table(rvu))
+		rvu_npc_exact_reset(rvu, pcifunc);
+
 	mutex_lock(&rvu->flr_lock);
 	/* Reset order should reflect inter-block dependencies:
 	 * 1. Reset any packet/work sources (NIX, CPT, TIM)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 444d2b9a4b29..96fc56924042 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1183,6 +1183,33 @@ void rvu_npc_exact_disable_feature(struct rvu *rvu)
 	rvu->hw->cap.npc_exact_match_enabled = false;
 }
 
+/**
+ *	rvu_npc_exact_reset - Delete and free all entry which match pcifunc.
+ *      @rvu: resource virtualization unit.
+ *	@pcifunc: PCI func to match.
+ */
+void rvu_npc_exact_reset(struct rvu *rvu, u16 pcifunc)
+{
+	struct npc_exact_table *table = rvu->hw->table;
+	struct npc_exact_table_entry *tmp, *iter;
+	u32 seq_id;
+
+	mutex_lock(&table->lock);
+	list_for_each_entry_safe(iter, tmp, &table->lhead_gbl, glist) {
+		if (pcifunc != iter->pcifunc)
+			continue;
+
+		seq_id = iter->seq_id;
+		dev_dbg(rvu->dev, "%s: resetting pcifun=%d seq_id=%u\n", __func__,
+			pcifunc, seq_id);
+
+		mutex_unlock(&table->lock);
+		rvu_npc_exact_del_table_entry_by_id(rvu, seq_id);
+		mutex_lock(&table->lock);
+	}
+	mutex_unlock(&table->lock);
+}
+
 /**
  *      rvu_npc_exact_init - initialize exact match table
  *      @rvu: resource virtualization unit.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
index 7adb5c5c5082..0a4aeddbadca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
@@ -187,5 +187,6 @@ int rvu_npc_exact_init(struct rvu *rvu);
 
 bool rvu_npc_exact_can_disable_feature(struct rvu *rvu);
 void rvu_npc_exact_disable_feature(struct rvu *rvu);
+void rvu_npc_exact_reset(struct rvu *rvu, u16 pcifunc);
 
 #endif /* RVU_NPC_HASH_H */
-- 
2.25.1

