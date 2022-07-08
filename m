Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC1B56B1A2
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 06:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237183AbiGHEcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 00:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237136AbiGHEbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 00:31:52 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1AA2B1BC;
        Thu,  7 Jul 2022 21:31:51 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26846Yhd007300;
        Thu, 7 Jul 2022 21:31:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=ylH+XGv/uILbf/9+uXxFjt7npgeE1+6CuR46gAD+KK4=;
 b=h3e2TikVkU/a4GpBI7u2rsGw5BVfZjPXmP9M9W9Jsw68k4BIbVyYbgrpf6DCI+a3Ka5R
 E4gSbLyvIRs6A4YjlU8d4zPbYS3+/9p9eQjVIvlNB+NehCk6VyqlX5r38eYZVG0ZkCLA
 fyMWW6nAl6n3u84ryMLiTh7L5V/8JUHs047wFWPYWau5RUwZDrgvG8B6OH7h3aasbzgU
 I9orH10uPWQZu/+ppL9qzhqNik/R3Swe/rKNhwTeZtZMHSddCFZQPWlhCi+gCqUKtnKI
 RavYQ8qbyJBoHf6mr9JyrmDPXFzwtSaSBsI4nU2wRih7GQ64qp8D+XZFQd9rKhdp8KK/ Mg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h635w2c3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 21:31:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Jul
 2022 21:31:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 Jul 2022 21:31:32 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id AFDA83F7079;
        Thu,  7 Jul 2022 21:31:29 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net-next PATCH v4 04/12] octeontx2-af: devlink configuration support
Date:   Fri, 8 Jul 2022 10:00:52 +0530
Message-ID: <20220708043100.2971020-5-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708043100.2971020-1-rkannoth@marvell.com>
References: <20220708043100.2971020-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: zh7h1R2VsF0DcNJmL-7O2Rql5lSiimtv
X-Proofpoint-ORIG-GUID: zh7h1R2VsF0DcNJmL-7O2Rql5lSiimtv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_02,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CN10KB silicon supports Exact match feature. This feature can be disabled
through devlink configuration. Devlink command fails if DMAC filter rules
are already present. Once disabled, legacy RPM based DMAC filters will be
configured.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../marvell/octeontx2/af/rvu_devlink.c        | 71 ++++++++++++++++++-
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 29 ++++++++
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  3 +
 3 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index d0ab8f233a02..88dee589cb21 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -10,6 +10,7 @@
 #include "rvu.h"
 #include "rvu_reg.h"
 #include "rvu_struct.h"
+#include "rvu_npc_hash.h"
 
 #define DRV_NAME "octeontx2-af"
 
@@ -1436,14 +1437,75 @@ static int rvu_af_dl_dwrr_mtu_get(struct devlink *devlink, u32 id,
 enum rvu_af_dl_param_id {
 	RVU_AF_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	RVU_AF_DEVLINK_PARAM_ID_DWRR_MTU,
+	RVU_AF_DEVLINK_PARAM_ID_NPC_EXACT_FEATURE_DISABLE,
 };
 
+static int rvu_af_npc_exact_feature_get(struct devlink *devlink, u32 id,
+					struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	bool enabled;
+
+	enabled = rvu_npc_exact_has_match_table(rvu);
+
+	snprintf(ctx->val.vstr, sizeof(ctx->val.vstr), "%s",
+		 enabled ? "enabled" : "disabled");
+
+	return 0;
+}
+
+static int rvu_af_npc_exact_feature_disable(struct devlink *devlink, u32 id,
+					    struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+
+	rvu_npc_exact_disable_feature(rvu);
+
+	return 0;
+}
+
+static int rvu_af_npc_exact_feature_validate(struct devlink *devlink, u32 id,
+					     union devlink_param_value val,
+					     struct netlink_ext_ack *extack)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	u64 enable;
+
+	if (kstrtoull(val.vstr, 10, &enable)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only 1 value is supported");
+		return -EINVAL;
+	}
+
+	if (enable != 1) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only disabling exact match feature is supported");
+		return -EINVAL;
+	}
+
+	if (rvu_npc_exact_can_disable_feature(rvu))
+		return 0;
+
+	NL_SET_ERR_MSG_MOD(extack,
+			   "Can't disable exact match feature; Please try before any configuration");
+	return -EFAULT;
+}
+
 static const struct devlink_param rvu_af_dl_params[] = {
 	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_DWRR_MTU,
 			     "dwrr_mtu", DEVLINK_PARAM_TYPE_U32,
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     rvu_af_dl_dwrr_mtu_get, rvu_af_dl_dwrr_mtu_set,
 			     rvu_af_dl_dwrr_mtu_validate),
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_NPC_EXACT_FEATURE_DISABLE,
+			     "npc_exact_feature_disable", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_npc_exact_feature_get,
+			     rvu_af_npc_exact_feature_disable,
+			     rvu_af_npc_exact_feature_validate),
 };
 
 /* Devlink switch mode */
@@ -1501,6 +1563,7 @@ int rvu_register_dl(struct rvu *rvu)
 {
 	struct rvu_devlink *rvu_dl;
 	struct devlink *dl;
+	size_t size;
 	int err;
 
 	dl = devlink_alloc(&rvu_devlink_ops, sizeof(struct rvu_devlink),
@@ -1522,8 +1585,12 @@ int rvu_register_dl(struct rvu *rvu)
 		goto err_dl_health;
 	}
 
-	err = devlink_params_register(dl, rvu_af_dl_params,
-				      ARRAY_SIZE(rvu_af_dl_params));
+	/* Register exact match devlink only for CN10K-B */
+	size = ARRAY_SIZE(rvu_af_dl_params);
+	if (!rvu_npc_exact_has_match_table(rvu))
+		size -= 1;
+
+	err = devlink_params_register(dl, rvu_af_dl_params, size);
 	if (err) {
 		dev_err(rvu->dev,
 			"devlink params register failed with error %d", err);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 273f4b648c73..fc18f543ca25 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1154,6 +1154,35 @@ static int __maybe_unused rvu_npc_exact_update_table_entry(struct rvu *rvu, u8 c
 	return 0;
 }
 
+/**
+ *	rvu_npc_exact_can_disable_feature - Check if feature can be disabled.
+ *      @rvu: resource virtualization unit.
+ *	Return: True if exact match feature is supported.
+ */
+bool rvu_npc_exact_can_disable_feature(struct rvu *rvu)
+{
+	struct npc_exact_table *table = rvu->hw->table;
+	bool empty;
+
+	if (!rvu->hw->cap.npc_exact_match_enabled)
+		return false;
+
+	mutex_lock(&table->lock);
+	empty = list_empty(&table->lhead_gbl);
+	mutex_unlock(&table->lock);
+
+	return empty;
+}
+
+/**
+ *	rvu_npc_exact_disable_feature - Disable feature.
+ *      @rvu: resource virtualization unit.
+ */
+void rvu_npc_exact_disable_feature(struct rvu *rvu)
+{
+	rvu->hw->cap.npc_exact_match_enabled = false;
+}
+
 /**
  *      rvu_npc_exact_init - initialize exact match table
  *      @rvu: resource virtualization unit.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
index f2346aa79ce2..7adb5c5c5082 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
@@ -185,4 +185,7 @@ int rvu_npc_exact_del_table_entry_by_id(struct rvu *rvu, u32 seq_id);
 u32 rvu_npc_exact_get_max_entries(struct rvu *rvu);
 int rvu_npc_exact_init(struct rvu *rvu);
 
+bool rvu_npc_exact_can_disable_feature(struct rvu *rvu);
+void rvu_npc_exact_disable_feature(struct rvu *rvu);
+
 #endif /* RVU_NPC_HASH_H */
-- 
2.25.1

