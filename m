Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359A11E7A04
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 12:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgE2KEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 06:04:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60472 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgE2KEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 06:04:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04TA1gI7005187;
        Fri, 29 May 2020 10:04:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=zsGgvDiX1qXaPSxYfZ46b1Wbb+P88xQezVI7rTy6f6A=;
 b=Yoj+JVNpJPLCB2FIh6uzHikUow/ySIX/ipQYfwHjihm6k9Uu31CYykJOCYFFFlENipsC
 oDbEkMwi3izQPR1RkrcpDJ8148nrkVRAkN0ecfmcoimRZ9O/SDlEX/bGJ+j+KznMlCPr
 BFGEHGnjvzA3PVWRUCDeLPHBA8Czv2Qj8wuoqVQCsHQhxWGcoeykMu+Xj59aTGJFTsmO
 fKgF4o5bPak0M/YhQQe5S5MOrFMBxim/XcHnahEOdH1Kf1x+bXP+ysmtZrwx+bqSC5tc
 BiA7kcrhW+1f++fSo4W64ARzB0hpAH7fzjJQJchBkpiLuJcUx4xUGEEHA8bzoswpNzCs Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 316u8r9k60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 May 2020 10:04:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04T9xEDO054140;
        Fri, 29 May 2020 10:02:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31a9ku15k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 May 2020 10:02:23 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04TA2FtK014885;
        Fri, 29 May 2020 10:02:15 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 May 2020 03:02:15 -0700
Date:   Fri, 29 May 2020 13:02:07 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: phy: marvell: unlock after phy_select_page()
 failure
Message-ID: <20200529100207.GB1304852@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9635 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290079
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9635 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=0
 phishscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005290079
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to call phy_restore_page() even if phy_select_page() fails.
Otherwise we are holding the phy_lock_mdio_bus() lock.  This requirement
is documented at the start of the phy_select_page() function.

Fixes: a618e86da91d ("net : phy: marvell: Speedup TDR data retrieval by only changing page once")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/phy/marvell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 2c04e3b2b285f..4ea226566cec9 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1867,7 +1867,7 @@ static int marvell_vct5_amplitude_graph(struct phy_device *phydev)
 	 */
 	page = phy_select_page(phydev, MII_MARVELL_VCT5_PAGE);
 	if (page < 0)
-		return page;
+		goto restore_page;
 
 	for (distance = priv->first;
 	     distance <= priv->last;
-- 
2.26.2

