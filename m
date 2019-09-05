Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E83AA95B
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 18:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389927AbfIEQvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 12:51:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22694 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728254AbfIEQvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 12:51:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x85GnkQW017634;
        Thu, 5 Sep 2019 09:51:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=rGedHOMhJxIv5wsoRhSUDwCkoFiwDYdiTNiFNc7zNWM=;
 b=iJrRPtoU120prmj1gvSEvIi/YKJr8iwxDkhFj3VkOABv2imw6CE21ZEiOOomAUeloYK2
 Iizx95F2XAlqd1v+RV8vhE+oC9F6xbh60HvTZILICRQ40ZVeXeOKEzJbVyuBYwGVfnwG
 j7avdN/h//0NbJPG9dcHbvt5NzbDHvoelG2wfOqMGXe0JdADFfTluqx+j1Ko3Pqy11Xr
 968iKQpxpeF4AWaNWcIS9OSPg8sOM2XL+9M9p6m5wh4eUdhhfN+CUZl148hleMB7Ee/5
 R37xckyT8SUY8RUGlRMsQTDUrLlY8KXa96t/i1h9awNFVk3axc+qAfAHYM8HqW4HkTAf IQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uqrdmkdn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 05 Sep 2019 09:51:32 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 5 Sep
 2019 09:51:29 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 5 Sep 2019 09:51:29 -0700
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 8DCF63F7044;
        Thu,  5 Sep 2019 09:51:26 -0700 (PDT)
From:   <stefanc@marvell.com>
To:     <davem@davemloft.net>
CC:     <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stefanc@marvell.com>, <shaulb@marvell.com>, <nadavh@marvell.com>,
        <ymarkman@marvell.com>, <marcin@marvell.com>
Subject: [PATCH] net: phylink: Fix flow control resolution
Date:   Thu, 5 Sep 2019 19:46:18 +0300
Message-ID: <1567701978-16056-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_05:2019-09-04,2019-09-05 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Regarding to IEEE 802.3-2015 standard section 2
28B.3 Priority resolution - Table 28-3 - Pause resolution

In case of Local device Pause=1 AsymDir=0, Link partner
Pause=1 AsymDir=1, Local device resolution should be enable PAUSE
transmit, disable PAUSE receive.
And in case of Local device Pause=1 AsymDir=1, Link partner
Pause=1 AsymDir=0, Local device resolution should be enable PAUSE
receive, disable PAUSE transmit.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Reported-by: Shaul Ben-Mayor <shaulb@marvell.com>
---
 drivers/net/phy/phylink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a45c5de..a5a57ca 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -376,8 +376,8 @@ static void phylink_get_fixed_state(struct phylink *pl, struct phylink_link_stat
  *  Local device  Link partner
  *  Pause AsymDir Pause AsymDir Result
  *    1     X       1     X     TX+RX
- *    0     1       1     1     RX
- *    1     1       0     1     TX
+ *    0     1       1     1     TX
+ *    1     1       0     1     RX
  */
 static void phylink_resolve_flow(struct phylink *pl,
 				 struct phylink_link_state *state)
@@ -398,7 +398,7 @@ static void phylink_resolve_flow(struct phylink *pl,
 			new_pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
 		else if (pause & MLO_PAUSE_ASYM)
 			new_pause = state->pause & MLO_PAUSE_SYM ?
-				 MLO_PAUSE_RX : MLO_PAUSE_TX;
+				 MLO_PAUSE_TX : MLO_PAUSE_RX;
 	} else {
 		new_pause = pl->link_config.pause & MLO_PAUSE_TXRX_MASK;
 	}
-- 
1.9.1

