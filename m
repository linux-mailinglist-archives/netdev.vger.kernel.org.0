Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AA25814DB
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiGZONR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGZONQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:13:16 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C08DF0E
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:13:14 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26Q9fjhx011485;
        Tue, 26 Jul 2022 07:13:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=8u5WWHqHJ9nIBFFr9a7uZivdq9wIYCi+MwxTPJSTSCs=;
 b=PZBjUHcBs5d36uZQR8ADrc+BhlrtAxpNbapjEv7pDpW6dtsM2NmPhs0REKl7EMkZyCgc
 arGjzVUkB+x88dDE9M1RiWpeNoXD6CwPfI93/u3Biq5HKDSQhaWQaKNlkyDTeJhggbyN
 9Kj6n3gpzL1RKpc6s9f4ICNLgRzP9sLf+aFty6JH5XTK+8+C5xyeB/jo+OZx/KzpPrmk
 OdmpLOuGA4ZUNt9SxajykQGU0P1aVl3UY5pRJ4sp3bzxxzazeC35h1X6/B9rADkQROBE
 blYGJqp+C0ioe+DrYrtisVlbFZfo8zFBfeVS4IsQQbulcNemM6a+93ft6zxmNoDbX8Lw yw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hgggnabdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 07:13:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 26 Jul
 2022 07:13:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 26 Jul 2022 07:13:00 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id D36F66267DC;
        Tue, 26 Jul 2022 07:11:26 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Stanislaw Kardach <skardach@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net v2 PATCH 1/5] octeontx2-af: Apply tx nibble fixup always
Date:   Tue, 26 Jul 2022 19:41:18 +0530
Message-ID: <1658844682-12913-2-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1658844682-12913-1-git-send-email-sbhatta@marvell.com>
References: <1658844682-12913-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 9e2AlMdOSRe0WlcTLEUfkDq-oKqBy5-I
X-Proofpoint-ORIG-GUID: 9e2AlMdOSRe0WlcTLEUfkDq-oKqBy5-I
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

From: Stanislaw Kardach <skardach@marvell.com>

NPC_PARSE_NIBBLE for TX interface has to be equal to the RX one for some
silicon revisions. Mistakenly this fixup was only applied to the default
MKEX profile while it should also be applied to any loaded profile.

Fixes: 1c1935c9945d ("octeontx2-af: Add NIX1 interfaces to NPC")
Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 3a31fb8..3d99cb9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1915,6 +1915,7 @@ static void rvu_npc_hw_init(struct rvu *rvu, int blkaddr)
 
 static void rvu_npc_setup_interfaces(struct rvu *rvu, int blkaddr)
 {
+	struct npc_mcam_kex *mkex = rvu->kpu.mkex;
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	struct rvu_hwinfo *hw = rvu->hw;
 	u64 nibble_ena, rx_kex, tx_kex;
@@ -1927,15 +1928,15 @@ static void rvu_npc_setup_interfaces(struct rvu *rvu, int blkaddr)
 	mcam->counters.max--;
 	mcam->rx_miss_act_cntr = mcam->counters.max;
 
-	rx_kex = npc_mkex_default.keyx_cfg[NIX_INTF_RX];
-	tx_kex = npc_mkex_default.keyx_cfg[NIX_INTF_TX];
+	rx_kex = mkex->keyx_cfg[NIX_INTF_RX];
+	tx_kex = mkex->keyx_cfg[NIX_INTF_TX];
 	nibble_ena = FIELD_GET(NPC_PARSE_NIBBLE, rx_kex);
 
 	nibble_ena = rvu_npc_get_tx_nibble_cfg(rvu, nibble_ena);
 	if (nibble_ena) {
 		tx_kex &= ~NPC_PARSE_NIBBLE;
 		tx_kex |= FIELD_PREP(NPC_PARSE_NIBBLE, nibble_ena);
-		npc_mkex_default.keyx_cfg[NIX_INTF_TX] = tx_kex;
+		mkex->keyx_cfg[NIX_INTF_TX] = tx_kex;
 	}
 
 	/* Configure RX interfaces */
-- 
2.7.4

