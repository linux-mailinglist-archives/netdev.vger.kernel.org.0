Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39753827C3
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 11:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbhEQJGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:06:09 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31682 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbhEQJGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 05:06:08 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14H926mm018652;
        Mon, 17 May 2021 09:04:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=OITtMnOQqFatshRwK/G3cSME8UfYiuTbecRPw4JvaYQ=;
 b=rvXSzhOqaSNxmoXYQ0Sy4E0sk9Q7pzYyLGi5pg0hmU4/wtC1q6rZyHatai6JdhcIG99D
 DCwo/fGS/srO8PwIyB3W2YeYXu63R0vFLbTxfqD2ng0XuB5lmTZQ6XPE8Y+dVjaOwcpC
 0+BpSpk9jfhgtzmU5hlS0oGWZWeU7UOmO6l8/DiJwDEaHua1Bq6LG0rBTjbEZ1LGdRNk
 /AV0M8xFM9kFq/M8jNvRjGCksvT8kUePbJywjF73rxcKnSdilPqfYpajaoVbB/0BAeas
 ziL1Yt5OCzfOJ/WqzkBc1WKlpkar5Bimur4+EDSN2eeWHsnHSPBDwkFWSUxVf1BGT1h6 Bw== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 38kjp6g26x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 09:04:29 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14H93qxP064798;
        Mon, 17 May 2021 09:04:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 38j644u58k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 09:04:28 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14H94Mgt025989;
        Mon, 17 May 2021 09:04:22 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 May 2021 09:04:21 +0000
Date:   Mon, 17 May 2021 12:04:13 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net v2] net: mdiobus: get rid of a BUG_ON()
Message-ID: <20210517090413.GC1955@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210515101522.GM12395@shell.armlinux.org.uk>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9986 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105170064
X-Proofpoint-ORIG-GUID: tjSKhXC8lCcUCFRVPsLh710U9N5CiUY6
X-Proofpoint-GUID: tjSKhXC8lCcUCFRVPsLh710U9N5CiUY6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We spotted a bug recently during a review where a driver was
unregistering a bus that wasn't registered, which would trigger this
BUG_ON().  Let's handle that situation more gracefully, and just print
a warning and return.

Reported-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v2: Update the Reported-by tag.

 drivers/net/phy/mdio_bus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index dadf75ff3ab9..6045ad3def12 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -607,7 +607,8 @@ void mdiobus_unregister(struct mii_bus *bus)
 	struct mdio_device *mdiodev;
 	int i;
 
-	BUG_ON(bus->state != MDIOBUS_REGISTERED);
+	if (WARN_ON_ONCE(bus->state != MDIOBUS_REGISTERED))
+		return;
 	bus->state = MDIOBUS_UNREGISTERED;
 
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
-- 
2.30.2
