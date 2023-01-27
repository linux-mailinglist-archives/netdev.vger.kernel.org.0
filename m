Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B047E67E0A4
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 10:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbjA0Jra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 04:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbjA0Jr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 04:47:26 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8691F820D5;
        Fri, 27 Jan 2023 01:47:15 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30R8DXKb008739;
        Fri, 27 Jan 2023 01:47:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=dWEQlKD2N/GWjzPpyA6igcLD4DJYmaN1imBKpCSJ7KY=;
 b=VB10rQ1XIKfCp7EDu6WvVo3kkNCP7Cu/8hOkorOfza2EPSALoc7uQ//qUNUyquo7PgE8
 v7XEKVVaw7UJYCYzsu6wYbW+qoDRY7labuzS1g1xo4SQym8UzL2/H0ZWvFBPFl/Z27bN
 oucmHk/Xc7K+0Bb6qUzgCDS9vUF042BythYdx10l3vyrclIGm2Te2qbVizlxlin/MOb8
 1luGdp8iOQXbrMNrTMknybAowodbORW6C35xTjSZR/8SvVHfnrRWp1VVKReMjs/yaJKp
 XWTnaQJq5+fe7lq047WkTZ+mzPXNDiokQ6jQOfZMihjz76U5yrwuLhj/CLS1HpZWuTZq GA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3nbpc93xrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 01:47:01 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 27 Jan
 2023 01:47:00 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Fri, 27 Jan 2023 01:47:00 -0800
Received: from localhost.localdomain (unknown [10.28.36.165])
        by maili.marvell.com (Postfix) with ESMTP id 827443F704B;
        Fri, 27 Jan 2023 01:46:57 -0800 (PST)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <sgoutham@marvell.com>, Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net PATCH] octeontx2-af: Fix devlink unregister
Date:   Fri, 27 Jan 2023 15:16:51 +0530
Message-ID: <20230127094652.666693-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: ZSjgpadXWnJ85W3thCSE0MEvhqANkmRj
X-Proofpoint-ORIG-GUID: ZSjgpadXWnJ85W3thCSE0MEvhqANkmRj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_05,2023-01-27_01,2022-06-22_01
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
 .../net/ethernet/marvell/octeontx2/af/rvu_devlink.c    | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index bda1a6fa2ec4..d058eeadb23f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1603,10 +1603,16 @@ void rvu_unregister_dl(struct rvu *rvu)
 {
 	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
 	struct devlink *dl = rvu_dl->dl;
+	size_t size;
 
 	devlink_unregister(dl);
-	devlink_params_unregister(dl, rvu_af_dl_params,
-				  ARRAY_SIZE(rvu_af_dl_params));
+	/* Unregister exact match devlink only for CN10K-B */
+	size = ARRAY_SIZE(rvu_af_dl_params);
+	if (!rvu_npc_exact_has_match_table(rvu))
+		size -= 1;
+
+	devlink_params_unregister(dl, rvu_af_dl_params, size);
+
 	rvu_health_reporters_destroy(rvu);
 	devlink_free(dl);
 }
-- 
2.25.1

