Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1EC96EBE65
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 11:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjDWJ4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 05:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjDWJ4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 05:56:15 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431673C0B;
        Sun, 23 Apr 2023 02:55:41 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33N2Avvg020680;
        Sun, 23 Apr 2023 02:55:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=y0nSbKgLYAXVnOlzeNooX38NjkwQK/4wxEK98z8YRFg=;
 b=edolqvY0Mc7cwj9HG8tA+bkJrPBXeYNvJmIZl2PZXnQkpRzVDSG9D9bK0HRfm8kLpAuf
 SLcVyYv+OcL+6kzKcuAJ51pYPajDlxgHE9OTg/uUtfjb0JbX0cnTWA3M1zAGw2//ilNB
 hoCwLaMZ9wqfjt7jFFCORgurdynkBzH4/DjWR6QU0CXNfkUHeF7IWe0Lny43NdK3YarB
 HQ7c4+x5DxEMmf2cbyyc996Fn67Im6pvaCvrhAkJDZfsavAtBjv1S0xQ5benAeUFfCY1
 Hvh5Y0cV5l6LE5IPXgn0YMYZMx2p3ckNKiNdaNDP8ckOhXwVeyuUzcLvF6hcYSzHFyjS sA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3p2prf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Apr 2023 02:55:32 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 23 Apr
 2023 02:55:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 23 Apr 2023 02:55:30 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 922313F7071;
        Sun, 23 Apr 2023 02:55:26 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 8/9] octeontx2-pf: mcs: Fix shared counters logic
Date:   Sun, 23 Apr 2023 15:24:53 +0530
Message-ID: <20230423095454.21049-9-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230423095454.21049-1-gakula@marvell.com>
References: <20230423095454.21049-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4TOBsiDtQ2pRq8Adp-igy4ZLJ9HykhQU
X-Proofpoint-GUID: 4TOBsiDtQ2pRq8Adp-igy4ZLJ9HykhQU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-23_06,2023-04-21_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Macsec stats like InPktsLate and InPktsDelayed share
same counter in hardware. If SecY replay_protect is true
then counter represents InPktsLate otherwise InPktsDelayed.
This mode change was tracked based on protect_frames
instead of replay_protect mistakenly. Similarly InPktsUnchecked
and InPktsOk share same counter and mode change was tracked
based on validate_check instead of validate_disabled.
This patch fixes those problems.

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  | 14 +++++++-------
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index a108f986be50..0ef44faa1ee8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -1014,7 +1014,7 @@ static void cn10k_mcs_sync_stats(struct otx2_nic *pfvf, struct macsec_secy *secy
 
 	/* Check if sync is really needed */
 	if (secy->validate_frames == txsc->last_validate_frames &&
-	    secy->protect_frames == txsc->last_protect_frames)
+	    secy->replay_protect == txsc->last_replay_protect)
 		return;
 
 	cn10k_mcs_secy_stats(pfvf, txsc->hw_secy_id_rx, &rx_rsp, MCS_RX, true);
@@ -1036,19 +1036,19 @@ static void cn10k_mcs_sync_stats(struct otx2_nic *pfvf, struct macsec_secy *secy
 		rxsc->stats.InPktsInvalid += sc_rsp.pkt_invalid_cnt;
 		rxsc->stats.InPktsNotValid += sc_rsp.pkt_notvalid_cnt;
 
-		if (txsc->last_protect_frames)
+		if (txsc->last_replay_protect)
 			rxsc->stats.InPktsLate += sc_rsp.pkt_late_cnt;
 		else
 			rxsc->stats.InPktsDelayed += sc_rsp.pkt_late_cnt;
 
-		if (txsc->last_validate_frames == MACSEC_VALIDATE_CHECK)
+		if (txsc->last_validate_frames == MACSEC_VALIDATE_DISABLED)
 			rxsc->stats.InPktsUnchecked += sc_rsp.pkt_unchecked_cnt;
 		else
 			rxsc->stats.InPktsOK += sc_rsp.pkt_unchecked_cnt;
 	}
 
 	txsc->last_validate_frames = secy->validate_frames;
-	txsc->last_protect_frames = secy->protect_frames;
+	txsc->last_replay_protect = secy->replay_protect;
 }
 
 static int cn10k_mdo_open(struct macsec_context *ctx)
@@ -1120,7 +1120,7 @@ static int cn10k_mdo_add_secy(struct macsec_context *ctx)
 	txsc->sw_secy = secy;
 	txsc->encoding_sa = secy->tx_sc.encoding_sa;
 	txsc->last_validate_frames = secy->validate_frames;
-	txsc->last_protect_frames = secy->protect_frames;
+	txsc->last_replay_protect = secy->replay_protect;
 
 	list_add(&txsc->entry, &cfg->txsc_list);
 
@@ -1544,12 +1544,12 @@ static int cn10k_mdo_get_rx_sc_stats(struct macsec_context *ctx)
 	rxsc->stats.InPktsInvalid += rsp.pkt_invalid_cnt;
 	rxsc->stats.InPktsNotValid += rsp.pkt_notvalid_cnt;
 
-	if (secy->protect_frames)
+	if (secy->replay_protect)
 		rxsc->stats.InPktsLate += rsp.pkt_late_cnt;
 	else
 		rxsc->stats.InPktsDelayed += rsp.pkt_late_cnt;
 
-	if (secy->validate_frames == MACSEC_VALIDATE_CHECK)
+	if (secy->validate_frames == MACSEC_VALIDATE_DISABLED)
 		rxsc->stats.InPktsUnchecked += rsp.pkt_unchecked_cnt;
 	else
 		rxsc->stats.InPktsOK += rsp.pkt_unchecked_cnt;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 3d22cc6a2804..f42b2b65bfd7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -389,7 +389,7 @@ struct cn10k_mcs_txsc {
 	struct cn10k_txsc_stats stats;
 	struct list_head entry;
 	enum macsec_validation_type last_validate_frames;
-	bool last_protect_frames;
+	bool last_replay_protect;
 	u16 hw_secy_id_tx;
 	u16 hw_secy_id_rx;
 	u16 hw_flow_id;
-- 
2.25.1

