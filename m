Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451522E77C5
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 11:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgL3KeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 05:34:01 -0500
Received: from mx0b-001ae601.pphosted.com ([67.231.152.168]:11844 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726203AbgL3KeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 05:34:01 -0500
Received: from pps.filterd (m0077474.ppops.net [127.0.0.1])
        by mx0b-001ae601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BUASpjX014943;
        Wed, 30 Dec 2020 04:33:11 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type;
 s=PODMain02222019; bh=Dj3uGFpCas2ZcpTl/fagKZPqCx58KdfIZrGAnDfbp9o=;
 b=JiCGweW+zMJQhkKnitr6790PAyG6BXYzAWSZZwZoDKMXSa6NQB9JZpITRKwQpBBffhLb
 HNuT0TGu8TbqB/I4mD9NneD3ytxzbiwCiXnc4IQ2SSAc3Iwm1qlzaz6RilQ41g7LZXuU
 y7eo5mCCZeLc10GI3CZjoUQIgQH2Zwj9LH9IBr1uAY72aXuuEp733E44Q3uuX6lPu4D8
 ApopV4sQ0dCan5Hz1v9EWMIC1xeh9xnULGip64pXUjhD0/+R3gGzvLczcPx1Q/SZlyci
 GzkxI+0r5qCxOjP9rSuoIF2H/2C9D8vCpduIv7IC6H1SkRBAUiIG5TyFVSSDJYLUo5Sv pQ== 
Received: from ediex02.ad.cirrus.com ([87.246.76.36])
        by mx0b-001ae601.pphosted.com with ESMTP id 35p2fs372g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Dec 2020 04:33:11 -0600
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX02.ad.cirrus.com
 (198.61.84.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Wed, 30 Dec
 2020 10:33:09 +0000
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.1913.5 via Frontend
 Transport; Wed, 30 Dec 2020 10:33:09 +0000
Received: from algalon.ad.cirrus.com (algalon.ad.cirrus.com [198.90.251.122])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id 6EF5A45;
        Wed, 30 Dec 2020 10:33:09 +0000 (UTC)
From:   Charles Keepax <ckeepax@opensource.cirrus.com>
To:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG flag
Date:   Wed, 30 Dec 2020 10:33:09 +0000
Message-ID: <20201230103309.8956-1-ckeepax@opensource.cirrus.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012300063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new flag MACB_CAPS_CLK_HW_CHG was added and all callers of
macb_set_tx_clk were gated on the presence of this flag.

-   if (!clk)
+ if (!bp->tx_clk || !(bp->caps & MACB_CAPS_CLK_HW_CHG))

However the flag was not added to anything other than the new
sama7g5_gem, turning that function call into a no op for all other
systems. This breaks the networking on Zynq.

The commit message adding this states: a new capability so that
macb_set_tx_clock() to not be called for IPs having this
capability

This strongly implies that present of the flag was intended to skip
the function not absence of the flag. Update the if statement to
this effect, which repairs the existing users.

Fixes: daafa1d33cc9 ("net: macb: add capability to not set the clock rate")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
---

Changes since v1:
 - Updated flag semantics to skip function, as appears to have been
   intended by the initial commit.

Thanks,
Charles

 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d5d910916c2e8..814a5b10141d1 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -467,7 +467,7 @@ static void macb_set_tx_clk(struct macb *bp, int speed)
 {
 	long ferr, rate, rate_rounded;
 
-	if (!bp->tx_clk || !(bp->caps & MACB_CAPS_CLK_HW_CHG))
+	if (!bp->tx_clk || (bp->caps & MACB_CAPS_CLK_HW_CHG))
 		return;
 
 	switch (speed) {
-- 
2.11.0

