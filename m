Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5466EEE53
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 08:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239579AbjDZG0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 02:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239572AbjDZG0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 02:26:31 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1373270E;
        Tue, 25 Apr 2023 23:26:04 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q64BYU000622;
        Tue, 25 Apr 2023 23:25:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=DC4FEntqP+h36HU4/wOBP+tPLaCqz4WbTV4ovTQ3hW4=;
 b=MuIuLzUH3ZM8XrpnxR2rubwU/vwNqg2bGPgYLagYy/+zxlNSjBzpM1e0RuHK2Je2iGzX
 5r6+7t4HIpND8rbaGf7yWEb1R0DSf78Lsrs8aDOUj+myWebTCKA4b4ErEhGTw5LdP9GI
 DYpovopzY5pPJoXs43Wlqa7LKkCi0sEuRc1Qkk1sanKzITWVPtnI020n2l5+rbttcrUD
 tj3CM+QpCUDjoV9n+M9pqA34Z2+ptVpIvpiZCXtLXqOHKYnRDLgZzRu5yRSBL41i3yPl
 AhrquRQ9aPtw/YQbMWR1uBGWaxSIbnn7BF7r1BxxIBXJumPDiCrp0n+qhTwnKygmjrjB TQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3pdcwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 23:25:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 25 Apr
 2023 23:25:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 25 Apr 2023 23:25:54 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 6E9163F7072;
        Tue, 25 Apr 2023 23:25:51 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH v2 6/9] octeontx2-pf: mcs: Match macsec ethertype along with DMAC
Date:   Wed, 26 Apr 2023 11:55:25 +0530
Message-ID: <20230426062528.20575-7-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230426062528.20575-1-gakula@marvell.com>
References: <20230426062528.20575-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: SpvBK4hDbPWZeoSU6fPKSrJ9clLbzaET
X-Proofpoint-GUID: SpvBK4hDbPWZeoSU6fPKSrJ9clLbzaET
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

On CN10KB silicon a single hardware macsec block is
present and offloads macsec operations for all the
ethernet LMACs. TCAM match with macsec ethertype 0x88e5
alone at RX side is not sufficient to distinguish all the
macsec interfaces created on top of netdevs. Hence append
the DMAC of the macsec interface too. Otherwise the first
created macsec interface only receives all the macsec traffic.

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c  | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 5f4402f7b03e..f3140f466b37 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -9,6 +9,7 @@
 #include <net/macsec.h>
 #include "otx2_common.h"
 
+#define MCS_TCAM0_MAC_DA_MASK		GENMASK_ULL(47, 0)
 #define MCS_TCAM0_MAC_SA_MASK		GENMASK_ULL(63, 48)
 #define MCS_TCAM1_MAC_SA_MASK		GENMASK_ULL(31, 0)
 #define MCS_TCAM1_ETYPE_MASK		GENMASK_ULL(47, 32)
@@ -237,8 +238,10 @@ static int cn10k_mcs_write_rx_flowid(struct otx2_nic *pfvf,
 				     struct cn10k_mcs_rxsc *rxsc, u8 hw_secy_id)
 {
 	struct macsec_rx_sc *sw_rx_sc = rxsc->sw_rxsc;
+	struct macsec_secy *secy = rxsc->sw_secy;
 	struct mcs_flowid_entry_write_req *req;
 	struct mbox *mbox = &pfvf->mbox;
+	u64 mac_da;
 	int ret;
 
 	mutex_lock(&mbox->lock);
@@ -249,11 +252,16 @@ static int cn10k_mcs_write_rx_flowid(struct otx2_nic *pfvf,
 		goto fail;
 	}
 
+	mac_da = ether_addr_to_u64(secy->netdev->dev_addr);
+
+	req->data[0] = FIELD_PREP(MCS_TCAM0_MAC_DA_MASK, mac_da);
+	req->mask[0] = ~0ULL;
+	req->mask[0] = ~MCS_TCAM0_MAC_DA_MASK;
+
 	req->data[1] = FIELD_PREP(MCS_TCAM1_ETYPE_MASK, ETH_P_MACSEC);
 	req->mask[1] = ~0ULL;
 	req->mask[1] &= ~MCS_TCAM1_ETYPE_MASK;
 
-	req->mask[0] = ~0ULL;
 	req->mask[2] = ~0ULL;
 	req->mask[3] = ~0ULL;
 
-- 
2.25.1

