Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF4A5814DE
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbiGZONX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiGZONS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:13:18 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E4D6543
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:13:17 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26Q9KxpB018765;
        Tue, 26 Jul 2022 07:13:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ZfxglUnfCqtIPR86iECejSrvsNIJ1mW6Ij6MQqNIYrg=;
 b=QFr0rLU7VxNRzhXlKMO49a03LrgeTXEYABhrEGXboMiN/HpRqwltd1Sv3CeUr95iv3CN
 Gv3dQnVkiazfbFCqRmhPs5QLYu+02MKewQYmk6Q+wbia6l2SGCIlInu+vhNK344ZSGvx
 PLlnFaQJBKHsO8s3woXpCHfDum6pvcv7SUHIebVZj50RJFbs24PzPCj1sYg2g6hUIk57
 n9iybO1oBYom7Yi8C2KA/lr/hthzd0E/0Sc7UfGV7td2V4QWZ7jFZHVFiwfKx73GpmqX
 GzMhdSkVUsGVf26cH2ZodGgCoc59ELTzsyeSU1LNsHsGMrSHUI6/BLeFYhfnlxopJoFq dQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hgggnabdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 07:13:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 26 Jul
 2022 07:13:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Jul 2022 07:13:04 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id A9AA15B6951;
        Tue, 26 Jul 2022 07:11:35 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net v2 PATCH 4/5] octeontx2-af: Fix mcam entry resource leak
Date:   Tue, 26 Jul 2022 19:41:21 +0530
Message-ID: <1658844682-12913-5-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1658844682-12913-1-git-send-email-sbhatta@marvell.com>
References: <1658844682-12913-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 9cnMi9xs1YdrUfNLoHYl0LEBDX3QN1-9
X-Proofpoint-ORIG-GUID: 9cnMi9xs1YdrUfNLoHYl0LEBDX3QN1-9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_04,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The teardown sequence in FLR handler returns if no NIX LF
is attached to PF/VF because it indicates that graceful
shutdown of resources already happened. But there is a
chance of all allocated MCAM entries not being freed by
PF/VF. Hence free mcam entries even in case of detached LF.

Fixes: c554f9c1574e ("octeontx2-af: Teardown NPA, NIX LF upon receiving FLR")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c     | 6 ++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 54e1b27..1484d33 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2564,6 +2564,12 @@ static void __rvu_flr_handler(struct rvu *rvu, u16 pcifunc)
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_NPA);
 	rvu_reset_lmt_map_tbl(rvu, pcifunc);
 	rvu_detach_rsrcs(rvu, NULL, pcifunc);
+	/* In scenarios where PF/VF drivers detach NIXLF without freeing MCAM
+	 * entries, check and free the MCAM entries explicitly to avoid leak.
+	 * Since LF is detached use LF number as -1.
+	 */
+	rvu_npc_free_mcam_entries(rvu, pcifunc, -1);
+
 	mutex_unlock(&rvu->flr_lock);
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 9404f86..4b39e13 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1096,6 +1096,9 @@ static void npc_enadis_default_entries(struct rvu *rvu, u16 pcifunc,
 
 void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 {
+	if (nixlf < 0)
+		return;
+
 	npc_enadis_default_entries(rvu, pcifunc, nixlf, false);
 
 	/* Delete multicast and promisc MCAM entries */
@@ -1107,6 +1110,9 @@ void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 
 void rvu_npc_enable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 {
+	if (nixlf < 0)
+		return;
+
 	/* Enables only broadcast match entry. Promisc/Allmulti are enabled
 	 * in set_rx_mode mbox handler.
 	 */
-- 
2.7.4

