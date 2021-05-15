Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15415381770
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbhEOKDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:03:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:10492 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232249AbhEOKCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:02:55 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14FA01rw005851;
        Sat, 15 May 2021 10:01:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=U6eX34B2yzQy4+bs8Od93/S88vC8KKD9qpdYt49o18E=;
 b=W0q+KwKlG/aJtPoqPaDYkhxmx22haTjKgabtl7/C938qFPYWW5tav0C5mHSJaXXUQqm+
 jdzr2XlqxLU55Fw8pb+fmxvQvzuU0lR65yZy1l9XSrRSmgRkKX0VReJtrBJNxRnyIoe6
 yRaDTs3fwTTcvH1hVfL1L1UXEdnI0tlwfVTYbbozXaIYvqr4Z9aQEMOxmyiYr0tkca45
 XzH/GxUKyPdkqDYxGiJBuZuaEM1wQsER+kF17ct5OOTn6Hg+E0xkyFiUwwNdDSrNamQW
 7t6bkc29uSZr2Cg2+3+DRzW0vRm6TwDTKL4QfC/D1YxXA9t8J3HhkeTqsJTVMaO6sHeh 3w== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 38j5ws02p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 10:01:28 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14FA1RGf067003;
        Sat, 15 May 2021 10:01:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 38j4b9qxsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 10:01:27 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14FA1RG2066983;
        Sat, 15 May 2021 10:01:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 38j4b9qxrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 10:01:27 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14FA1IsA025334;
        Sat, 15 May 2021 10:01:18 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 15 May 2021 10:01:17 +0000
Date:   Sat, 15 May 2021 13:01:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: mdiobus: get rid of a BUG_ON()
Message-ID: <YJ+b52c5bGLdewFz@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-ORIG-GUID: En8Arx2MQrFBlJ5ORYFahP4nTljQ4rI1
X-Proofpoint-GUID: En8Arx2MQrFBlJ5ORYFahP4nTljQ4rI1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We spotted a bug recently during a review where a driver was
unregistering a bus that wasn't registered, which would trigger this
BUG_ON().  Let's handle that situation more gracefully, and just print
a warning and return.

Reported-by: Russell King <linux@armlinux.org.uk>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
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

