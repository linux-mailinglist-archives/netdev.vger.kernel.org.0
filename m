Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4DA6805D6
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 07:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235742AbjA3GFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 01:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235741AbjA3GFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 01:05:16 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C589F25E3B;
        Sun, 29 Jan 2023 22:05:04 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TMjZi6001917;
        Sun, 29 Jan 2023 22:04:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=kYVlg7M+LyeBMeTAwgARgGcLkO+r3DovFFIobZHuQK8=;
 b=GyaxQnW2f8UtwmT/Z3e2sqsKLPhmN9DEYPOtztIBquSHsPpd5DfMJi1rn0sK9aeCTyrb
 D8jrxaDPr7HvqEOQwUOHW3vPM2nj32t3dz5rzx4kLl/jjqP1lHT5NiYvTLYRPE8i8cRR
 1i7vrCbEaU5azwDxg4BqQoqTkxe7aZQFsI/uW8YT10/Q9gB0OsR3TqfovG40icdsRgfF
 kfUWdnmTd2r3eps1lfIO+n4dJvsqxwJz8zspLOpZVQxl5Z5wwFVKP/6gGKQiO0JLLOqv
 R/oYWs2rNsLEcGmAlwCi5mNTOAjPfYaVr5g+5o+QblP9kWkzvk6bnxrxwmozU/Rc2uMH LA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nd442fcxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 29 Jan 2023 22:04:51 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sun, 29 Jan
 2023 22:04:49 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Sun, 29 Jan 2023 22:04:49 -0800
Received: from localhost.localdomain (unknown [10.28.36.165])
        by maili.marvell.com (Postfix) with ESMTP id DA3D83F705F;
        Sun, 29 Jan 2023 22:04:46 -0800 (PST)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <leon@kernel.org>
CC:     <sgoutham@marvell.com>, Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net PATCH v1] octeontx2-af: Fix devlink unregister
Date:   Mon, 30 Jan 2023 11:34:43 +0530
Message-ID: <20230130060443.763564-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: iWt_V-wApo6oXHyd7meUhUUEy-2y7RPM
X-Proofpoint-ORIG-GUID: iWt_V-wApo6oXHyd7meUhUUEy-2y7RPM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-30_04,2023-01-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Exact match devlink entry is only for CN10K-B.
Unregistration devlink should subtract this
entry before invoking devlink unregistration

Fixes: 87e4ea29b030 ("octeontx2-af: Debugsfs support for exact match.")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../marvell/octeontx2/af/rvu_devlink.c        | 37 ++++++++++++++-----
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index bda1a6fa2ec4..4950eb13a79f 100644
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
@@ -1578,18 +1580,29 @@ int rvu_register_dl(struct rvu *rvu)
 		goto err_dl_health;
 	}
 
-	/* Register exact match devlink only for CN10K-B */
-	size = ARRAY_SIZE(rvu_af_dl_params);
-	if (!rvu_npc_exact_has_match_table(rvu))
-		size -= 1;
-
-	err = devlink_params_register(dl, rvu_af_dl_params, size);
+	err = devlink_params_register(dl, rvu_af_dl_params, ARRAY_SIZE(rvu_af_dl_params));
 	if (err) {
 		dev_err(rvu->dev,
 			"devlink params register failed with error %d", err);
 		goto err_dl_health;
 	}
 
+	/* Register exact match devlink only for CN10K-B */
+	if (!rvu_npc_exact_has_match_table(rvu))
+		goto done;
+
+	err = devlink_params_register(dl, rvu_af_dl_param_exact_match,
+				      ARRAY_SIZE(rvu_af_dl_param_exact_match));
+	if (!err)
+		goto done;
+
+	dev_err(rvu->dev,
+		"devlink exact match params register failed with error %d", err);
+
+	devlink_params_unregister(dl, rvu_af_dl_params, ARRAY_SIZE(rvu_af_dl_params));
+	goto err_dl_health;
+
+done:
 	devlink_register(dl);
 	return 0;
 
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

