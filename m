Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8D4304AE0
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbhAZE4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:56:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33410 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbhAYK3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 05:29:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10P8AVSE101478;
        Mon, 25 Jan 2021 08:12:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=3v5ov03CgWGnjGR/strYEROcXrL34Fr8nIjtf5Iguwg=;
 b=x7axNsTK9ZqhnGkiPnDz8khmaU8wLifzrx6bT35UZDfZQm9BtVPMr64o7QJN4MBntudN
 Bn8SXcp08lGBr5mZb9w9AxkNNcYr4XBgwk2fC9hcHneKJnVe+yZz0PQiyVt1ZWj+Ymqb
 7cPk0vlb6kTigZC49pC18Btt66nPz9GoeFdHcME42sZihdT4ijuQdKeMnS0enPrDI4xk
 YSJxStU3mne0kpgmSPAKk+gGB2AqKTSg+NACbrjROgDk/Oj2t0DgK7WKWIyGqSVdu/IA
 QebbqlDTKYTng7+wD3wWuhqb3BVCaI/wBOMID3Xxfb4+r9WNQNDdta/sUkLfXKThPt0h fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 368brkc06h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 08:12:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10P8BSCX003702;
        Mon, 25 Jan 2021 08:12:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 368wjpctkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 08:12:57 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10P8CpgI020970;
        Mon, 25 Jan 2021 08:12:51 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Jan 2021 00:12:50 -0800
Date:   Mon, 25 Jan 2021 11:12:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2 net-next] net: mscc: ocelot: fix error handling bugs in
 mscc_ocelot_init_ports()
Message-ID: <YA59en4lJCiYsPHv@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9874 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101250048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9874 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101250048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several error handling bugs in mscc_ocelot_init_ports().  I
went through the code, and carefully audited it and made fixes and
cleanups.

1) The ocelot_probe_port() function didn't have a mirror release function
   so it was hard to follow.  I created the ocelot_release_port()
   function.
2) In the ocelot_probe_port() function, if the register_netdev() call
   failed, then it lead to a double free_netdev(dev) bug.  Fix this
   by moving the "ocelot->ports[port] = ocelot_port;" assignment to the
   end of the function after everything has succeeded.
3) I was concerned that the "port" which comes from of_property_read_u32()
   might be out of bounds so I added a check for that.
4) In the original code if ocelot_regmap_init() failed then the driver
   tried to continue but I think that should be a fatal error.
5) If ocelot_probe_port() failed then the most recent devlink was leaked.
   Fix this by moving the "registered_ports[port] = true;" assignment
   earlier.
6) The error handling if the final ocelot_port_devlink_init() failed had
   two problems.  The "while (port-- >= 0)" loop should have been
   "--port" pre-op instead of a post-op to avoid a buffer underflow.
   The "if (!registered_ports[port])" condition was reversed leading to
   resource leaks and double frees.

Fixes: 6c30384eb1de ("net: mscc: ocelot: register devlink ports")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 39 +++++++++-------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 30a38df08a21..2c82ffe2c611 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1064,7 +1064,6 @@ static void mscc_ocelot_release_ports(struct ocelot *ocelot)
 	int port;
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
 
 		ocelot_port = ocelot->ports[port];
@@ -1072,12 +1071,7 @@ static void mscc_ocelot_release_ports(struct ocelot *ocelot)
 			continue;
 
 		ocelot_deinit_port(ocelot, port);
-
-		priv = container_of(ocelot_port, struct ocelot_port_private,
-				    port);
-
-		unregister_netdev(priv->dev);
-		free_netdev(priv->dev);
+		ocelot_release_port(ocelot_port);
 	}
 }
 
@@ -1123,14 +1117,22 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 			continue;
 
 		port = reg;
+		if (port < 0 || port >= ocelot->num_phys_ports) {
+			dev_err(ocelot->dev,
+				"invalid port number: %d >= %d\n", port,
+				ocelot->num_phys_ports);
+			continue;
+		}
 
 		snprintf(res_name, sizeof(res_name), "port%d", port);
 
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 						   res_name);
 		target = ocelot_regmap_init(ocelot, res);
-		if (IS_ERR(target))
-			continue;
+		if (IS_ERR(target)) {
+			err = PTR_ERR(target);
+			goto out_teardown;
+		}
 
 		phy_node = of_parse_phandle(portnp, "phy-handle", 0);
 		if (!phy_node)
@@ -1147,6 +1149,7 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 			of_node_put(portnp);
 			goto out_teardown;
 		}
+		registered_ports[port] = true;
 
 		err = ocelot_probe_port(ocelot, port, target, phy);
 		if (err) {
@@ -1154,8 +1157,6 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 			goto out_teardown;
 		}
 
-		registered_ports[port] = true;
-
 		ocelot_port = ocelot->ports[port];
 		priv = container_of(ocelot_port, struct ocelot_port_private,
 				    port);
@@ -1213,15 +1214,9 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 
 		err = ocelot_port_devlink_init(ocelot, port,
 					       DEVLINK_PORT_FLAVOUR_UNUSED);
-		if (err) {
-			while (port-- >= 0) {
-				if (!registered_ports[port])
-					continue;
-				ocelot_port_devlink_teardown(ocelot, port);
-			}
-
+		if (err)
 			goto out_teardown;
-		}
+		registered_ports[port] = true;
 	}
 
 	kfree(registered_ports);
@@ -1233,10 +1228,8 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 	mscc_ocelot_release_ports(ocelot);
 	/* Tear down devlink ports for the registered network interfaces */
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (!registered_ports[port])
-			continue;
-
-		ocelot_port_devlink_teardown(ocelot, port);
+		if (registered_ports[port])
+			ocelot_port_devlink_teardown(ocelot, port);
 	}
 	kfree(registered_ports);
 	return err;
-- 
2.29.2

