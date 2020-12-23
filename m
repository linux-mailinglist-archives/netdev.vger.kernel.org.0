Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AFC2E20A3
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgLWS5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:57:34 -0500
Received: from mx0a-001ae601.pphosted.com ([67.231.149.25]:9310 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728043AbgLWS5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 13:57:34 -0500
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
        by mx0a-001ae601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BNIfYKa028397;
        Wed, 23 Dec 2020 12:56:49 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type;
 s=PODMain02222019; bh=qyNrue/iCzO70L4Xj5oxIr3Ph5DauK8YTGORDoIgvAA=;
 b=KQSu+TztzcWLGQzz8ql54xNAlaZQhiuduzo3iD6dIAvSeDb0Kq1yGSJupyjMWlx5tumZ
 t9y4YhxYamFpvvgsTmMdfBhfPYzwFsacONwD1CtHe6BHNPtN2PjZQQ1NTskkU7GpxYOs
 Fzs7fb7pVgsdDETd2zW2xeI1Qq3OwZiYXbaxJWSnDxRQV9dV7gScy5UMfz+E8advOdso
 RyNsFcGWlp0GT+nmUmrU6O3CCQGPbj9DgsNq8mJVcrsCpwonsXTYHoQ1U7AxWWPILfQd
 GOOkyg/FJ4+2x9YUvba5EOg2eZbs24EmrggRs1Xot8AshDfaxXH5pYkdGzGX/706rOO/ MA== 
Received: from ediex01.ad.cirrus.com ([87.246.76.36])
        by mx0a-001ae601.pphosted.com with ESMTP id 35k0edtf8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Dec 2020 12:56:49 -0600
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Wed, 23 Dec
 2020 18:41:44 +0000
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.1913.5 via Frontend
 Transport; Wed, 23 Dec 2020 18:41:44 +0000
Received: from algalon.ad.cirrus.com (algalon.ad.cirrus.com [198.90.251.122])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id E32AE11CB;
        Wed, 23 Dec 2020 18:41:44 +0000 (UTC)
From:   Charles Keepax <ckeepax@opensource.cirrus.com>
To:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG flag on Zynq
Date:   Wed, 23 Dec 2020 18:41:44 +0000
Message-ID: <20201223184144.7428-1-ckeepax@opensource.cirrus.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1011
 bulkscore=0 priorityscore=1501 suspectscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=931 impostorscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012230134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new flag MACB_CAPS_CLK_HW_CHG was added and all callers of
macb_set_tx_clk were gated on the presence of this flag.

if (!bp->tx_clk || !(bp->caps & MACB_CAPS_CLK_HW_CHG))

However the flag was not added to anything other than the new
sama7g5_gem, turning that function call into a no op for all other
systems. This breaks the networking on Zynq.

This patch adds that flag to Zynq config, it is probably needed on other
systems as well but it is hard to know that without having access to
those systems, so I guess we just have to wait to see who else spots
breakage here.

Fixes: daafa1d33cc9 ("net: macb: add capability to not set the clock rate")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d5d910916c2e8..590116b236ef7 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4536,7 +4536,7 @@ static const struct macb_config zynqmp_config = {
 
 static const struct macb_config zynq_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_NO_GIGABIT_HALF |
-		MACB_CAPS_NEEDS_RSTONUBR,
+		MACB_CAPS_NEEDS_RSTONUBR | MACB_CAPS_CLK_HW_CHG,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
-- 
2.11.0

