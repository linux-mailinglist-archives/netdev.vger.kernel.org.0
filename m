Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36216EEE5B
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 08:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbjDZG1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 02:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239597AbjDZG1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 02:27:17 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA373AAB;
        Tue, 25 Apr 2023 23:26:39 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q64EO5000793;
        Tue, 25 Apr 2023 23:26:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=4oeHPgFKJVUxQHp3g5Tc+JBCQQRS4AIR1GkiaUzw9x8=;
 b=To2ttArs4iw531JsHpPZFbAhy4ZTJQ3gm+XvZisHMqjETgD9dkVe9BRMkPRBOT5ggQHC
 vKNQy+aRstWqo6Gacll1qDVb1yBsk2pEBuwN72gY1ja/ozdzpKveTUvNQtI1o0JeW0/g
 wz5MANK0z34r3v/KLu/dDmnI6ZqvECGJ4SGEDoI8pS1SscTRZzzkSrZQzGSLHTdlHSD7
 Dzv8WCAlPYFUS/ozXsHEdrj/do5bQjc2B59HK1hUo6fN/w/7HnHmA9zINm5LcDHl1FBr
 +f3Gyc46hNcTEfsd+FisWV18j7BarIkIr/wXS6s1MoAtqHBn7xJzVl5q7XOYZqU54Y19 Zg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3pdcx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 23:26:07 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 25 Apr
 2023 23:26:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 25 Apr 2023 23:26:05 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 880933F707F;
        Tue, 25 Apr 2023 23:26:02 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH v2 9/9] octeontx2-pf: mcs: Do not reset PN while updating secy
Date:   Wed, 26 Apr 2023 11:55:28 +0530
Message-ID: <20230426062528.20575-10-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230426062528.20575-1-gakula@marvell.com>
References: <20230426062528.20575-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: V2qwY2fhzsJ4KV9_ZRd6W_-TOIdKD2M1
X-Proofpoint-GUID: V2qwY2fhzsJ4KV9_ZRd6W_-TOIdKD2M1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-25_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

After creating SecYs, SCs and SAs a SecY can be modified
to change attributes like validation mode, protect frames
mode etc. During this SecY update, packet number is reset to
initial user given value by mistake. Hence do not reset
PN when updating SecY parameters.

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 0ef44faa1ee8..9ef70980f786 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -1137,6 +1137,7 @@ static int cn10k_mdo_upd_secy(struct macsec_context *ctx)
 	struct macsec_secy *secy = ctx->secy;
 	struct macsec_tx_sa *sw_tx_sa;
 	struct cn10k_mcs_txsc *txsc;
+	bool active;
 	u8 sa_num;
 	int err;
 
@@ -1144,15 +1145,19 @@ static int cn10k_mdo_upd_secy(struct macsec_context *ctx)
 	if (!txsc)
 		return -ENOENT;
 
-	txsc->encoding_sa = secy->tx_sc.encoding_sa;
-
-	sa_num = txsc->encoding_sa;
-	sw_tx_sa = rcu_dereference_bh(secy->tx_sc.sa[sa_num]);
+	/* Encoding SA got changed */
+	if (txsc->encoding_sa != secy->tx_sc.encoding_sa) {
+		txsc->encoding_sa = secy->tx_sc.encoding_sa;
+		sa_num = txsc->encoding_sa;
+		sw_tx_sa = rcu_dereference_bh(secy->tx_sc.sa[sa_num]);
+		active = sw_tx_sa ? sw_tx_sa->active : false;
+		cn10k_mcs_link_tx_sa2sc(pfvf, secy, txsc, sa_num, active);
+	}
 
 	if (netif_running(secy->netdev)) {
 		cn10k_mcs_sync_stats(pfvf, secy, txsc);
 
-		err = cn10k_mcs_secy_tx_cfg(pfvf, secy, txsc, sw_tx_sa, sa_num);
+		err = cn10k_mcs_secy_tx_cfg(pfvf, secy, txsc, NULL, 0);
 		if (err)
 			return err;
 	}
-- 
2.25.1

