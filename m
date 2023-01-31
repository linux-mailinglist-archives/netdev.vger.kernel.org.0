Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025BE68245D
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 07:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjAaGRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 01:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjAaGRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 01:17:22 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83573B672;
        Mon, 30 Jan 2023 22:17:20 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ULNuSD024707;
        Mon, 30 Jan 2023 22:17:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=l2L3cisvEjmiAD01KHy6Fs1+AkDIVGzwS00H0AHdScM=;
 b=TI6Jy8DyQ/zHSGV8FKddcg8pzLvcRe/FxNuhJ17Y8WRmoSCIQPX61cEXOi/EJ00C6S3Q
 SvhCRyoM13Ew5nMvY11AaL66n4Bed0/RHnJn9KYh7xN/pfNaJm/zSjaMKJM46aehGpGO
 /HKyiGd2OK8IL58rHTTyEBWTF9ZaPwC/mhbwt435rWV1U1cczHLvHhLRDF7/ujKcIx/y
 rGVONokb4h+txXtCkW2Zxri/6jukqs2AqPly/9i13bmc3G53qf/4NOwmDzbVtqWG9upJ
 1cOOJWdCT38n2a497Cb91RP3naIMFmGHvCGz42KRrZecGvoeRUcTzGuYyDDUXhH+qpLk gg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3nd1xurc5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Jan 2023 22:17:07 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 30 Jan
 2023 22:17:06 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 30 Jan 2023 22:17:06 -0800
Received: from localhost.localdomain (unknown [10.28.36.165])
        by maili.marvell.com (Postfix) with ESMTP id 1F0C23F7078;
        Mon, 30 Jan 2023 22:17:02 -0800 (PST)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <leon@kernel.org>, <jiri@resnulli.us>
CC:     <sgoutham@marvell.com>, Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net PATCH v2] octeontx2-af: Fix devlink unregister
Date:   Tue, 31 Jan 2023 11:46:59 +0530
Message-ID: <20230131061659.1025137-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: pK-3cuWDnJGWAUzTtPi0N8klhnIr_qSw
X-Proofpoint-GUID: pK-3cuWDnJGWAUzTtPi0N8klhnIr_qSw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_02,2023-01-30_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Exact match feature is only available in CN10K-B.
Unregister exact match devlink entry only for
this silicon variant.

Fixes: 87e4ea29b030 ("octeontx2-af: Debugsfs support for exact match.")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../marvell/octeontx2/af/rvu_devlink.c        | 35 ++++++++++++++-----
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index bda1a6fa2ec4..e4407f09c9d3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1500,6 +1500,9 @@ static const struct devlink_param rvu_af_dl_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     rvu_af_dl_dwrr_mtu_get, rvu_af_dl_dwrr_mtu_set,
 			     rvu_af_dl_dwrr_mtu_validate),
+};
+
+static const struct devlink_param rvu_af_dl_param_exact_match[] = {
 	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_NPC_EXACT_FEATURE_DISABLE,
 			     "npc_exact_feature_disable", DEVLINK_PARAM_TYPE_STRING,
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
@@ -1556,7 +1559,6 @@ int rvu_register_dl(struct rvu *rvu)
 {
 	struct rvu_devlink *rvu_dl;
 	struct devlink *dl;
-	size_t size;
 	int err;
 
 	dl = devlink_alloc(&rvu_devlink_ops, sizeof(struct rvu_devlink),
@@ -1578,21 +1580,32 @@ int rvu_register_dl(struct rvu *rvu)
 		goto err_dl_health;
 	}
 
+	err = devlink_params_register(dl, rvu_af_dl_params, ARRAY_SIZE(rvu_af_dl_params));
+	if (err) {
+		dev_err(rvu->dev,
+			"devlink params register failed with error %d", err);
+		goto err_dl_health;
+	}
+
 	/* Register exact match devlink only for CN10K-B */
-	size = ARRAY_SIZE(rvu_af_dl_params);
 	if (!rvu_npc_exact_has_match_table(rvu))
-		size -= 1;
+		goto done;
 
-	err = devlink_params_register(dl, rvu_af_dl_params, size);
+	err = devlink_params_register(dl, rvu_af_dl_param_exact_match,
+				      ARRAY_SIZE(rvu_af_dl_param_exact_match));
 	if (err) {
 		dev_err(rvu->dev,
-			"devlink params register failed with error %d", err);
-		goto err_dl_health;
+			"devlink exact match params register failed with error %d", err);
+		goto err_dl_exact_match;
 	}
 
+done:
 	devlink_register(dl);
 	return 0;
 
+err_dl_exact_match:
+	devlink_params_unregister(dl, rvu_af_dl_params, ARRAY_SIZE(rvu_af_dl_params));
+
 err_dl_health:
 	rvu_health_reporters_destroy(rvu);
 	devlink_free(dl);
@@ -1605,8 +1618,14 @@ void rvu_unregister_dl(struct rvu *rvu)
 	struct devlink *dl = rvu_dl->dl;
 
 	devlink_unregister(dl);
-	devlink_params_unregister(dl, rvu_af_dl_params,
-				  ARRAY_SIZE(rvu_af_dl_params));
+
+	devlink_params_unregister(dl, rvu_af_dl_params, ARRAY_SIZE(rvu_af_dl_params));
+
+	/* Unregister exact match devlink only for CN10K-B */
+	if (rvu_npc_exact_has_match_table(rvu))
+		devlink_params_unregister(dl, rvu_af_dl_param_exact_match,
+					  ARRAY_SIZE(rvu_af_dl_param_exact_match));
+
 	rvu_health_reporters_destroy(rvu);
 	devlink_free(dl);
 }
-- 
2.25.1

