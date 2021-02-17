Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5980C31D557
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 07:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhBQGTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 01:19:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35056 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbhBQGTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 01:19:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11H6FAOM179844;
        Wed, 17 Feb 2021 06:18:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=uDCLPCIO9dcfZ98mvYluRmR2Vohmodd48NPFEiMAni8=;
 b=piZQNv6h3IQYetmyQvDOQXxJq2RTvNC7YIW1x6QNluVQeWnw7W1v5xm0vOkZmbMZb+7A
 JtmTrkfTwb8Of5Z7TECqm/H+7cFUlKGNF2xnPAO08hMi+ox4AnmFZTqljTWeuLlu0aTa
 bc/dkBvEnN8OPdOqSGts5M8HryEPmbxPWbKvV3mVa0E0e6BjCyhLXCSrAn75Rh6LdGZa
 jOCkkK/hbXfLXn/h/JgXBNRr9VshydzhnbqeEmRVzrPoNKivVbQLGyKjb2LHaG4XLqtG
 M9QZyp7xYt6uJ5slx3U1oevnlhbADLMobQ2qJRhTeMsT5wD499pDAR5XLLzRRXbkz/OZ iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36p66r16r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 06:18:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11H6G51i172317;
        Wed, 17 Feb 2021 06:18:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 36prpxr3hq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 06:18:17 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11H6I8DP024672;
        Wed, 17 Feb 2021 06:18:08 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Feb 2021 22:18:07 -0800
Date:   Wed, 17 Feb 2021 09:17:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: phy: icplus: Call phy_restore_page() when
 phy_select_page() fails
Message-ID: <YCy1F5xKFJAaLBFw@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170047
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1011 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170047
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch warns that there is a locking issue in this function:

drivers/net/phy/icplus.c:273 ip101a_g_config_intr_pin()
warn: inconsistent returns '&phydev->mdio.bus->mdio_lock'.
  Locked on  : 242
  Unlocked on: 273

It turns out that the comments in phy_select_page() say we have to call
phy_restore_page() even if the call to phy_select_page() fails.

Fixes: f9bc51e6cce2 ("net: phy: icplus: fix paged register access")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/phy/icplus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index 4e15d4d02488..015b7b5aa776 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -239,7 +239,7 @@ static int ip101a_g_config_intr_pin(struct phy_device *phydev)
 
 	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
 	if (oldpage < 0)
-		return oldpage;
+		goto out;
 
 	/* configure the RXER/INTR_32 pin of the 32-pin IP101GR if needed: */
 	switch (priv->sel_intr32) {
-- 
2.30.0

