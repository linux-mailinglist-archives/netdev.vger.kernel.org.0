Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F7865D9E2
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 17:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbjADQc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 11:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239864AbjADQco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 11:32:44 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3481ADB7;
        Wed,  4 Jan 2023 08:32:43 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3044wxe8031488;
        Wed, 4 Jan 2023 08:32:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=XvAZtcDafs9da5L8+27SQ+lEJe4BO27QZTE7M0uYv58=;
 b=MuWKP8kvKZkBPO12s8LzLk1ECrfYQ1oynMoi85JAUtX4AoBS57YfsqHE4fC0OsR+9Q2M
 xHMLD8Z4QpPhhMaplSxEz8M+rohRJEXuv2YRAdxPYHUcEk5vu1brypIhLaBfSv/Eqs+V
 2Bp3MMOGt2wjFzml67WqRLc71qdLpAu1nPcLzJ/+N3FwoaWconTHVN0ZMaPxqqG2+C/T
 vk9MVZppq52RFpPhqG6HElDSb5OxnGy5tF7fVluvfa8t1zQiu99gADIyGP5SQFn3Avvq
 oxmSHrnAjz9MHOHAOrthLDNMcS2f2QTAsQOOeX6BT/wSDwo5K6x1R0PY4WUV1OWaoQLV /Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3mtnftm9qk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 08:32:30 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 4 Jan
 2023 08:32:28 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 4 Jan 2023 08:32:28 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 620BB3F7076;
        Wed,  4 Jan 2023 08:32:24 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, "Angela Czubak" <aczubak@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: [net PATCH] octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable
Date:   Wed, 4 Jan 2023 22:02:20 +0530
Message-ID: <20230104163220.954-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: K6V-07CX3uGrjWPa79dfhtZu5kgBOOMy
X-Proofpoint-ORIG-GUID: K6V-07CX3uGrjWPa79dfhtZu5kgBOOMy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Angela Czubak <aczubak@marvell.com>

PF netdev can request AF to enable or disable reception and transmission
on assigned CGX::LMAC. The current code instead of disabling or enabling
'reception and transmission' also disables/enable the LMAC. This patch
fixes this issue.

Fixes: 1435f66a28b4 ("octeontx2-af: CGX Rx/Tx enable/disable mbox handlers")
Signed-off-by: Angela Czubak <aczubak@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index b2b71fe80d61..724df6398bbe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -774,9 +774,9 @@ int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable)
 
 	cfg = cgx_read(cgx, lmac_id, CGXX_CMRX_CFG);
 	if (enable)
-		cfg |= CMR_EN | DATA_PKT_RX_EN | DATA_PKT_TX_EN;
+		cfg |= DATA_PKT_RX_EN | DATA_PKT_TX_EN;
 	else
-		cfg &= ~(CMR_EN | DATA_PKT_RX_EN | DATA_PKT_TX_EN);
+		cfg &= ~(DATA_PKT_RX_EN | DATA_PKT_TX_EN);
 	cgx_write(cgx, lmac_id, CGXX_CMRX_CFG, cfg);
 	return 0;
 }
-- 
2.17.1

