Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F2D6EBE61
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 11:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjDWJz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 05:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjDWJzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 05:55:45 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FCD30E3;
        Sun, 23 Apr 2023 02:55:30 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33N6b0Ip030485;
        Sun, 23 Apr 2023 02:55:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=e1Em1n7pW0FkcSSGiRLG2OXf302x0TH/6iK2FYSOnHA=;
 b=PE6vrtnRo61/ByOdKvg2RP4WrUxXsCahJlDAfn8srEEMbAzod+CpYLbAXfuwLLGZGQbJ
 W5R1XJTm1XuibpvxvgzJibyjYXVdH7eK0TheesnQXJgoGN7IHiDKYN2z1Wd4fwvgaJBZ
 2Uc7W3TvzSU5gS+NRqdc6+aXgSHcgRRWqSRQ0pAY8oCz+ocNTc/l6ky46i7e2RB2gULf
 sthpVuKZfy0GZJ0pJZoVaC6cPj8+KwRE6u4gI3HfWAcIxJWBnhVUytHzLaLaE3HcmjQP
 ChLtn72YidSRLkqaYFLDDexHhjiHR4OjIkWXta2V34SvyOszpUr4i9lgLw/CA0cX3QWT tg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3p2pr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Apr 2023 02:55:24 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 23 Apr
 2023 02:55:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 23 Apr 2023 02:55:22 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id C3BCA3F706D;
        Sun, 23 Apr 2023 02:55:18 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 6/9] octeontx2-pf: mcs: Match macsec ethertype along with DMAC
Date:   Sun, 23 Apr 2023 15:24:51 +0530
Message-ID: <20230423095454.21049-7-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230423095454.21049-1-gakula@marvell.com>
References: <20230423095454.21049-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4hdNpOzlT8O62vCqIgnombZ2Rs2sNIPz
X-Proofpoint-GUID: 4hdNpOzlT8O62vCqIgnombZ2Rs2sNIPz
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

