Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE7631F720
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 11:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhBSKMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 05:12:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48196 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhBSKMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 05:12:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JAAYF6079941;
        Fri, 19 Feb 2021 10:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=1KlOTwE6stmW/r/8pjnBmYp/QGEwbe6VuCS1AOwwzZc=;
 b=PWzYGFhl6nIwtAYBN2kNlswSXtQRzzP/X19lGvJq0WdMUQzklPAEPUJW/fJeXzv0eAfb
 NCr4/fVW47kZOjuxFhbitNphcC9SmAr82n5aHLDxk6GFr6Em3kOJ+u8VfxIoVjk9M9vW
 LawhU34PHW8RegEMJVp7jjHzEyLoHSbI+an6Q74KMZIeFO0pT+V0NUAqNyg6C3M+5S9N
 W0FCrsn9xUt7Tq8egm1cwG3R0pmnd3Y3m9voUxavW7uqKtAUTdeMP32N+3rVFdB++Ql5
 Xnl+jyJJdyh8obkFq63J4E+LxNNtjzNDL8K5cwk57iwhGo9axdPhf9h2IPNFIT+Xr94e cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36pd9agg33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 10:11:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JA9jkL079241;
        Fri, 19 Feb 2021 10:11:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 36prhvfvjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 10:11:06 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 11JAAsTF028190;
        Fri, 19 Feb 2021 10:10:55 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Feb 2021 02:10:54 -0800
Date:   Fri, 19 Feb 2021 13:10:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2 net-next] net: phy: icplus: call phy_restore_page() when
 phy_select_page() fails
Message-ID: <YC+OpFGsDPXPnXM5@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190079
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190079
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comments to phy_select_page() say that "phy_restore_page() must
always be called after this, irrespective of success or failure of this
call."  If we don't call phy_restore_page() then we are still holding
the phy_lock_mdio_bus() so it eventually leads to a dead lock.

Fixes: 32ab60e53920 ("net: phy: icplus: add MDI/MDIX support for IP101A/G")
Fixes: f9bc51e6cce2 ("net: phy: icplus: fix paged register access")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: fix a couple other instances I missed in v1

 drivers/net/phy/icplus.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index 3e431737c1ba..a00a667454a9 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -239,7 +239,7 @@ static int ip101a_g_config_intr_pin(struct phy_device *phydev)
 
 	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
 	if (oldpage < 0)
-		return oldpage;
+		goto out;
 
 	/* configure the RXER/INTR_32 pin of the 32-pin IP101GR if needed: */
 	switch (priv->sel_intr32) {
@@ -314,7 +314,7 @@ static int ip101a_g_read_status(struct phy_device *phydev)
 
 	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
 	if (oldpage < 0)
-		return oldpage;
+		goto out;
 
 	ret = __phy_read(phydev, IP10XX_SPEC_CTRL_STATUS);
 	if (ret < 0)
@@ -349,7 +349,8 @@ static int ip101a_g_read_status(struct phy_device *phydev)
 static int ip101a_g_config_mdix(struct phy_device *phydev)
 {
 	u16 ctrl = 0, ctrl2 = 0;
-	int oldpage, ret;
+	int oldpage;
+	int ret = 0;
 
 	switch (phydev->mdix_ctrl) {
 	case ETH_TP_MDI:
@@ -367,7 +368,7 @@ static int ip101a_g_config_mdix(struct phy_device *phydev)
 
 	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
 	if (oldpage < 0)
-		return oldpage;
+		goto out;
 
 	ret = __phy_modify(phydev, IP10XX_SPEC_CTRL_STATUS,
 			   IP101A_G_AUTO_MDIX_DIS, ctrl);
-- 
2.30.0

