Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074D265F0B2
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 17:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbjAEQBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 11:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbjAEQBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 11:01:35 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9BD1A389;
        Thu,  5 Jan 2023 08:01:33 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305Bx0FX028728;
        Thu, 5 Jan 2023 08:01:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=FGjVwz4OlBB20g+ribOPpXbmff/J4ltHusMxl046W3s=;
 b=iJFqe7ASVQZ951bbCihez+iHv9Eu6zZ3Sp6B9kGlm0k3lfZWFDochY0kuKZq7PpG8YT6
 cFKpzZ57CIOGPCUK9NjbS7wbgHz8sPNUZ2MMnRuEgyO/A3ipkGSRU3OwzV8jkhKlDot2
 alQ2D+K9hzosALRjLZBYKn0DP/BQIytm05tzQ12VO1y7n76vPdlGQaU/hMjEHWuSzkQr
 U0a+7ynNPqsmkXIa1RZ7p2JNq1Z7JJ9OZYRFaTH0OAALjzryL4aNjCeULxujQe2e+WXA
 6LM4iCau2WrnXfHhIiTJt1ng5+4acOl9LQbHLFDErvEE7f1ubyiLxMQHYGjIVCknAtu7 WQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3mwebc42x4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 08:01:17 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 5 Jan
 2023 08:01:12 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Thu, 5 Jan 2023 08:01:11 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id BAAD73F704A;
        Thu,  5 Jan 2023 08:01:08 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net PATCHV2] octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable
Date:   Thu, 5 Jan 2023 21:31:07 +0530
Message-ID: <20230105160107.17638-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Q8Tk9SliiVcHUPkx0HgR8V6U7e5Nmxqb
X-Proofpoint-GUID: Q8Tk9SliiVcHUPkx0HgR8V6U7e5Nmxqb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_07,2023-01-05_01,2022-06-22_01
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
v2 * remove unused macro define

 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

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
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index fb2d37676d84..5a20d93004c7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -26,7 +26,6 @@
 #define CMR_P2X_SEL_SHIFT		59ULL
 #define CMR_P2X_SEL_NIX0		1ULL
 #define CMR_P2X_SEL_NIX1		2ULL
-#define CMR_EN				BIT_ULL(55)
 #define DATA_PKT_TX_EN			BIT_ULL(53)
 #define DATA_PKT_RX_EN			BIT_ULL(54)
 #define CGX_LMAC_TYPE_SHIFT		40
--
2.17.1
