Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41858526F34
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiENBaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 21:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiENBaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 21:30:20 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50079.outbound.protection.outlook.com [40.107.5.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9878E373C6C;
        Fri, 13 May 2022 16:37:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGKNT66ie6usLRrfXRfLbvdaBzBuSPlyiqigHCOt+2I2nrJ3bJQOfNKajFVRN5eQtsrWvM7pXhhOXe2OlCAUmv3qbtfuU4kS7RumnVyhar7kC/YEF/foszLTouJ0gSoWMZmtK2pPasekULxKlsFomypgMRlRKFkPnV7T7To6pxcmu5egdV0AsAGdaegV+PgZ90Yz3gUF93dWK1VwxICudCttgZA9lyy1eo+snNFd7RBpFNygHJ39aP95bt2wNpZjpzyzPMRJjSqE8iyKJGRiDiRpXpeT7PtjSpM0TUtS6c3CbJ2YwqWAy3+FO1KAKFGgIrcqNCPZ/ZX/rsw7kw5ErA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJnvsok4/O5C43WNG34rhSOKBJdmEiD4Y+CyjcACWKM=;
 b=P2AHxhGJjqjn9w2nolDp3PYPav9J2XUcv56T1H8+wmnhb6ttWPhbMsrxobGJDhD6KjxVxDHAl1Mh6BnbVAWyy1gmvRCT+24qmbWllbpdCv2TLPnmNXPNT7f7sry7YsCQCJHv+xNeOOJ6ZQjKseOy4sUw9D8oHepQs5cgoB/sISwFDO1/lnSw/+mcks+DddKgfQDrYaCECXF5oFL0ax4B1fniae6H+lV98RpRZ5Ndbgqm3/W1M2w5U4+WKavHuh27UXylQMFlgkUZ4ujW+2eKrJNQIUe5b2Pvdi3d4/aoB1a674w9oI2tkOjA+cyjVGtjTfDjfGJNkHZ3CTgHKg2GGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJnvsok4/O5C43WNG34rhSOKBJdmEiD4Y+CyjcACWKM=;
 b=J5RS7rF8SrqgHyF4F4daH2RcRtNw7p9dveW563vIFNX6cFmG+UestUUUkJh3J1m7TGxGjJsxcDtD8PCnS/vDjyYNzvYUm47gO2Tb7q/U10mcHN7peSga9/c4BRvxJTeMbW8LPTNndjK7VYUtPED8SJRdOXDxSi8rYJZvKUf30ow=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4972.eurprd04.prod.outlook.com (2603:10a6:10:1c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17; Fri, 13 May
 2022 23:36:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Fri, 13 May 2022
 23:36:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        John Stultz <jstultz@google.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC PATCH net 2/2] net: dsa: wait for PHY to defer probe
Date:   Sat, 14 May 2022 02:36:40 +0300
Message-Id: <20220513233640.2518337-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220513233640.2518337-1-vladimir.oltean@nxp.com>
References: <20220513233640.2518337-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0027.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 132ca0b2-9473-4f6f-5e84-08da35397953
X-MS-TrafficTypeDiagnostic: DB7PR04MB4972:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB497242DADC20DE50E8A367E4E0CA9@DB7PR04MB4972.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ExITxyUAVxaqYIx6yab7WMcZC1eggdOhpeZAiU4zZF2OwVWCfwQFPg+cJAd2pSy/1PkX86tvH0yrftgT67itLgpmKpPvq9TMx/qhf4DXFEjqUCf8kuNhX/1eN3BPwBKtTDyJY655lMZN9P4gOCCRzHI3EX8gYObn6nU0o8h9578iWrfXxwUBqvBuKbdx6glHpImtHqJQozdMXmRjV18wFg84kqAB+1Q+2XaJ1aCr427+0ltkn9+3RJrwHuH7qFOZcwGxRtatEhEeknqdmbp5Q9y/SE2MNi46ovUO9JjOf+uDn1tTQABBcmmnTcEmTt0Vrv54x8gMjpy4GRr1Cr8er/Bgw1UTfDTvlijfpW01EzmfoEvtHSVHgHQUuxigRn7s5hs47MQepbEEpLHfWY8dQj3Doly/GbPcW5JYjahwM+MUw6fSLva9y019qUEKyDemG2ykAQ5fRWTt802onc9+dcbz+0Dr02YvWW/5XIdz7E2Ri9/IHRu5up/K1hnrQbQuZHWbZMsoqQOROBbE997/rUUteyJAlFES4oQ4nzU1RECcImHrnsPhXQIVe8GhhBwJq1OkXHDMen319Gsmq4JZnyYdWGqiTmhjdgPyp0XbQouA4wBzCyZnoEJNPevbjtuXjWq14lPB3X66hmKDh8dhWKTAi6lBNT+/+soNlreucZKyOHmEIAly/LvN5CczqK0nb8T97VOfZLHZybppinzncQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(508600001)(38100700002)(38350700002)(6486002)(66556008)(8676002)(66946007)(4326008)(6916009)(83380400001)(54906003)(86362001)(186003)(316002)(1076003)(2616005)(6666004)(6506007)(52116002)(26005)(6512007)(36756003)(2906002)(5660300002)(7416002)(44832011)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Du5F/45MFvWvDB/+tWI5kyFPb4of/sUIUGBGEyMo06GLKD23dbgWpEnIc0Wc?=
 =?us-ascii?Q?TeHCxm7x/idjh4ikN9keO5k+pbXOMJ1zAF+fhjgrP2oeA3JiePZ3zQFx2W/w?=
 =?us-ascii?Q?j4Jtvl7Sb55+h/xhj3/W5ccdZzOsjNhgyaBx6uIXGUUW/3vJCBmZu+tl96Hk?=
 =?us-ascii?Q?PjQ5o+ArhfWeCMxUbpeLMMQfWYfjyFrHP/WhpgzDn0iMoNQgyiMCAYNpbyeY?=
 =?us-ascii?Q?+Ov2CG9Xm+wmRUH6Qk1/gXHO4jmRnWAV7Pxhy+w9E82W7QS5QKBumoMSa+ZL?=
 =?us-ascii?Q?AhOptXnbRccPqn2TvEL0E6xyIosfbDyFnfl3Z9sIaz3dWnRAxymaT6+a5K7o?=
 =?us-ascii?Q?AyNPXRPuBjvxM2xbau0sDfnhwhKuw+3K+KEI/T9ncqWwfEubvbpzhw7H+mY7?=
 =?us-ascii?Q?68BlMERjj879y/5fl4rvrZvvJSDWHLWdU+hBHaAYJE3HIvJNRoMQqx8QrEpe?=
 =?us-ascii?Q?1+Lepxs7FVUYvG+/I4JJEfZjwk27Q/o9bL79jWF5dsRA/b7oRp54IBeikDzx?=
 =?us-ascii?Q?rZvGj6KjerlmwDqIlLAf0FxsxeC/GkI9UYa/eDZSi3aa7f0N151/xUZeAsgp?=
 =?us-ascii?Q?eUlITDDVyLZ6Fo2o/vyeF4UHMC6LB3BBfnArKdSI2lGf5IErIvhcXHnaIhdx?=
 =?us-ascii?Q?GCbkZLRnXdFWedIQYHaSJPOhyBP60LIH5LGLPDMSnkYa9yYdjhnFZ6ruGCxb?=
 =?us-ascii?Q?jU/1zBskdvJhH6Sd5axx5jJY5TRD/a3ZX2ztxnEyQipv8J7KJiBIVUSNGwTz?=
 =?us-ascii?Q?JZq7CNPn4MshOxfGxKDVYvCbPu20/fSaMUbGfHKGM9R6JIooOpxmpV/tTM3R?=
 =?us-ascii?Q?9o1DM3e7tOpsYkltqJE/ErxrA4Kt7D+rxc1DMEHV98PRJh9gGRKvCN4XwU4o?=
 =?us-ascii?Q?JAZOXmIYnhG4i0GI+xfDoU6CBr7I0382iQfmBGxcO6J8x27Kd/0d1TxSRVSm?=
 =?us-ascii?Q?0ChkArrfEfLVym2o7ok6IA73XaN2FT889dgOLpum4zzFTu7ofHfLFErCgZ1w?=
 =?us-ascii?Q?0Dhsk8CyWFptwxm2TYmh3u/8ixpAaKjmMhgrj4dkfqq3blyzzmbl8jpEtpRf?=
 =?us-ascii?Q?Cg48ClRdDD+QVt6kRFKMqv3ExOQ3oq5Lxf9DAOHwG/XrC2asbOMVjpmU5E2h?=
 =?us-ascii?Q?77asEN6RKWGVQLTNRVezZEuTEMY5YQTWdzpJJVtRhaGKxRasMDZcGDwyUj4g?=
 =?us-ascii?Q?uGh55D4N5LpmGXxB1SQWIybuxbg9v4MW5/Q4uy0eo4c7s3FzL4XRwCoJXQf4?=
 =?us-ascii?Q?ctvggglpwoaT3IAxcK582mBUQ0Pa7mtVlkdu+DsFsR/rb+eE5M5bn66FYLH5?=
 =?us-ascii?Q?/0SBd/zP7aHKI2MEows7Ju6DfrFZVB+rvMO3Kz2d/LT4kEfX8QaY0Fn+e5N/?=
 =?us-ascii?Q?KBMNN1cwh9Lke29gJRj/Prnwqa8HlSnErgVOjQHegcyhOCzovG6nFJNS2Wi6?=
 =?us-ascii?Q?If5Lab6X5a92uUgI/7Ywe1Huh50OYbPvlUGTOWDMLoLOjCCVH7MqOOuUNAt5?=
 =?us-ascii?Q?sUeioncQk0wKCDegFaIBqX/uNr+ft0s5iOVuwCx7L2Hugso0mL6VX1za71iB?=
 =?us-ascii?Q?KjV0duTE8yN/36/GNUHB/MtvV5iv20ulf4OqcIXWpjc7wvMLsrBSvnM1zHaT?=
 =?us-ascii?Q?pZxLylSGL1c/d73yUdcRVCw79KQs49EHLkMOXMwZCISTZRlTxrkFU5ECPaLR?=
 =?us-ascii?Q?BjQUiEX4mrsebRTJC5t+g9am3Kk4wzVrVYTFyZZmXLujjPpnAkJ4o8eeOd6g?=
 =?us-ascii?Q?CvOWlj8+SONCFDA3STBwQr7iPa3zsas=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 132ca0b2-9473-4f6f-5e84-08da35397953
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 23:36:59.4857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V80YeT44aY3cJ3QePlENJgftsoymZkTajWdCd4me7BAwbxss90GFIqVN+Z1DgaMFZsrKjo6ET7JJXmmetNl48Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4972
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA is among the 3 drivers which call phylink.*phy_connect() during
probe time (vs 11 doing so during ndo_open). So there is no guarantee
that the PHY driver will have finished probing by the time we connect to
it.

Use the newly introduced phylink_of_phy_connect_probe() to wait for this
to happen, and propagate the error code all the way to dsa_register_switch(),
which switch drivers call from their own probe function.

Notably, in dsa_tree_setup_ports() we treat errors on slave interface
registration as "soft" and continue probing the ports that didn't fail.
This is useful on systems which have riser cards with PHYs, and some of
these cards can be missing. But this logic needs to be adapted, since
-EPROBE_DEFER is an error we want to propagate regardless.

Fixes: 25396f680dd6 ("net: phylink: introduce phylink_fwnode_phy_connect()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c  |  2 ++
 net/dsa/port.c  |  6 ++++--
 net/dsa/slave.c | 10 +++++-----
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cf933225df32..3a2983a1a7dd 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1011,6 +1011,8 @@ static int dsa_tree_setup_ports(struct dsa_switch_tree *dst)
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dsa_port_is_user(dp) || dsa_port_is_unused(dp)) {
 			err = dsa_port_setup(dp);
+			if (err == -EPROBE_DEFER)
+				goto teardown;
 			if (err) {
 				err = dsa_port_reinit_as_unused(dp);
 				if (err)
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 075a8db536c6..8a2fc99ca0ad 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1628,9 +1628,11 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 	if (err)
 		return err;
 
-	err = phylink_of_phy_connect(dp->pl, port_dn, 0);
+	err = phylink_of_phy_connect_probe(dp->pl, port_dn, 0);
 	if (err && err != -ENODEV) {
-		pr_err("could not attach to PHY: %d\n", err);
+		dev_err_probe(ds->dev, err,
+			      "DSA/CPU port %d could not attach to PHY: %pe\n",
+			      dp->index, ERR_PTR(err));
 		goto err_phy_connect;
 	}
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5ee0aced9410..a5407e717c68 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2252,18 +2252,18 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	if (ds->ops->get_phy_flags)
 		phy_flags = ds->ops->get_phy_flags(ds, dp->index);
 
-	ret = phylink_of_phy_connect(dp->pl, port_dn, phy_flags);
+	ret = phylink_of_phy_connect_probe(dp->pl, port_dn, phy_flags);
 	if (ret == -ENODEV && ds->slave_mii_bus) {
 		/* We could not connect to a designated PHY or SFP, so try to
 		 * use the switch internal MDIO bus instead
 		 */
 		ret = dsa_slave_phy_connect(slave_dev, dp->index, phy_flags);
 	}
-	if (ret) {
+	if (ret && ret != -EPROBE_DEFER)
 		netdev_err(slave_dev, "failed to connect to PHY: %pe\n",
 			   ERR_PTR(ret));
+	if (ret)
 		phylink_destroy(dp->pl);
-	}
 
 	return ret;
 }
@@ -2386,12 +2386,12 @@ int dsa_slave_create(struct dsa_port *port)
 	netif_carrier_off(slave_dev);
 
 	ret = dsa_slave_phy_setup(slave_dev);
-	if (ret) {
+	if (ret && ret != -EPROBE_DEFER)
 		netdev_err(slave_dev,
 			   "error %d setting up PHY for tree %d, switch %d, port %d\n",
 			   ret, ds->dst->index, ds->index, port->index);
+	if (ret)
 		goto out_gcells;
-	}
 
 	rtnl_lock();
 
-- 
2.25.1

