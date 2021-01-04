Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BA32E937D
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 11:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbhADKiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 05:38:55 -0500
Received: from mx0a-001ae601.pphosted.com ([67.231.149.25]:35962 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726308AbhADKiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 05:38:54 -0500
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
        by mx0a-001ae601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 104AWLln003664;
        Mon, 4 Jan 2021 04:38:05 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type;
 s=PODMain02222019; bh=Uk9lYMm9ey65BqE/Wih2VZhcmr4l+5ucfmFMpGEBb/E=;
 b=QPeQZqx6qc9a4sZwoeSI2nQaLuCT6WnUD7nqd8dNjuhZJtDxrefFqWFpmB0Ye7cb+nWQ
 IUPYeUBSh2Wtg4UMdJ9xYiOKGQ9DyjBwr9Bgj7O6/DvYTcEifmxLueJnkp89vxdUla57
 sNROnd0T0O0qBZu7OjhQQk+zLkFmyEtZg6U2OVqoKLgjsZLlqcx6yqp2DPoCbDA2JKGa
 uST3kvHilv44wLY63yHzt3CCVHG5XAMQjUAK/vAfztAKGyYoY4KOw01eeLdLQunZTdST
 9qhBURCZAN+zYIx8eW7X8XHA+XHAFJbsSeFgUhZ/yZev0wfDM4UJlI2gnOrdQTo13vgD pA== 
Received: from ediex01.ad.cirrus.com ([87.246.76.36])
        by mx0a-001ae601.pphosted.com with ESMTP id 35tq479aq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 04 Jan 2021 04:38:05 -0600
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 4 Jan 2021
 10:38:03 +0000
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.1913.5 via Frontend
 Transport; Mon, 4 Jan 2021 10:38:03 +0000
Received: from algalon.ad.cirrus.com (algalon.ad.cirrus.com [198.90.251.122])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id 06F052AB;
        Mon,  4 Jan 2021 10:38:03 +0000 (UTC)
From:   Charles Keepax <ckeepax@opensource.cirrus.com>
To:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net v3] net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG flag
Date:   Mon, 4 Jan 2021 10:38:02 +0000
Message-ID: <20210104103802.13091-1-ckeepax@opensource.cirrus.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040069
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

Changes since v2:
 - Adding "net" to the subject line

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

