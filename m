Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50157526D90
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 01:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiEMXra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 19:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiEMXr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 19:47:29 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50079.outbound.protection.outlook.com [40.107.5.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A62373C4B;
        Fri, 13 May 2022 16:37:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Up09vx+MVCYBtD9YwhumhJRhWqYRqvyktdKyFMLxLJBPngPl6BLBgWvdnhBFCcRwVNXLYRkvQ5YbJBQDdl1kXErnZ6hnJrzHUJlmt39uOf9dpK/J7i04xKcwxFcmc6OcH0wKFEXH9oD+qPt4r7Su119SBXmWDCE48QqD38sKPweecK39GmPuXrUqKBnjNtyE/E15y+rLRGjFHvdpgxTVrLFavJgWXj2kCm01w94z4ipyrZ4aYdC8+Do7q6lbWAcJd3Kkm3aj4+F+QkZea6j8bqxDRHHUxQ3yflNV7EpezDMVWfR6YFg8cZU/ekhvrzuxvBY8sTuPS6aexBR2kNNYRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgCj4l8CN4ztfrjsSDkKPcRLurrCHn5NOBSpKvBF0zg=;
 b=LSnhL/yTWVJOojnVXPhoUURtOdN/GGdbFntnsZRO9HKTLHLLZ6rD5aZQb6I6VXRiPaggHXWWCtK2x3/s25FtvkxT9xbAC6MlF8N0Kj+g87Mocjnq2UikT8IaT8o3w+t0Oy6Lbmd9guM5CFhL2WJ03jCQsKDOryIC9+GZhCAz01ptYny+bmBA128oc1d2iXWY88jYsvSsPrX+CcL2zUKgVd/tT8vrc5Ya4gwvFamshn76GqjNpGtIaeR8YFI5pYgrBQocOFXG9Y7zfvvLWmZuMZNWhgu41YjqsgZBZBa+pFbzUmpMZYFvgR673u+g8fS9tWpMzuJted3niNvlAsDQ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgCj4l8CN4ztfrjsSDkKPcRLurrCHn5NOBSpKvBF0zg=;
 b=OfBv9Th3hI/U7fHfnlpOIUqBB1Pg6EgB5ndzdrnuj/4Na+nWMCTBUoNv/+PLI5vAtZgTxHpTJtM4RjkPblFTQ00gkMDmefEE43WKW5p4Yu3fKsuHUW8XAO6LBSMnvpGYgJ02SvpUpdGgFoJCpPtPRwrx65nKV9eDFGs5veA7mHY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4972.eurprd04.prod.outlook.com (2603:10a6:10:1c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17; Fri, 13 May
 2022 23:36:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Fri, 13 May 2022
 23:36:57 +0000
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
Subject: [RFC PATCH net 1/2] net: phylink: allow PHY driver to defer probe when connecting via OF node
Date:   Sat, 14 May 2022 02:36:39 +0300
Message-Id: <20220513233640.2518337-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: ffa94e1a-341b-406b-24a5-08da3539780f
X-MS-TrafficTypeDiagnostic: DB7PR04MB4972:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4972312B7DE19E67ACF14CFCE0CA9@DB7PR04MB4972.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OBGR8k3+o1rX40A7cqhWAA2Qu8MVK0jwWVoRbAdoCiajXmoQXhiO0919a5A/CW5eL3hzju8FXSM+/98CkhIdTt3MEo8tHLmXqJigWyM3zQW9tOg/gxlSsBpc/93Hyiol6lZ9I4hBXQfXy7j05ADkgdSOSr0baJHrSMGR2fWaRgsw4qlqnFGO+xTMOhskIHI2JXOgLlPijURsgOFDh+vpDp/FraR5VA8IPNNbP6zdUtMiUHYhM6tkTgp37rhlw7/sL6xJqj04uysQq+ViI7nlKH9Q8DxNCQmtvxrcWiO7Tyut2QJpKDejq7Y1SxGp0E0c/lnrcHXG6ECfNWtzzezLqmk5jUCYNhWnVRBgSM2ALTPwaE8/StRMI3K83YjmGmRKCQJ7ogziV0nm/d8PJ30E8Ar03vMXUzvOE1an7HVe5AvBYh521RQG5Dh+WoK5utThIGZ4XvbgG8gNxWi8QsIApZzzUZdNaLrE13svSQIL77Z+oRhoQcGlZrTTU+TL02Eo1ZzsFuRkBN8E/dtux9Y6XHln0dhY2KIf3Z2juNXdaZ0uj9ok8uMA0alwX9SW8yjOSC0tV943RTyzAHHaXsETTT5DIkulE/FpKF7tICLtr0m6oOj+2cbE1/9e+vgP9cKtpstXdoQMBzoRSfN6Hg0gNPPoTICIBe7zJFRvC9BJzEyB32O7nvub3iE+KbIZefm0+gKrn7UeqXRI67lTWpFHFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(508600001)(38100700002)(38350700002)(6486002)(66556008)(8676002)(66946007)(4326008)(6916009)(83380400001)(54906003)(86362001)(186003)(316002)(1076003)(2616005)(6666004)(6506007)(52116002)(26005)(6512007)(36756003)(2906002)(5660300002)(7416002)(44832011)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UleyK5j9OQ0ihTwR1BqFEI6LcWry/fN68xlidSYAwvMhmqRoGsJbi4lr1LUC?=
 =?us-ascii?Q?XYcQLTM3zICibvjhbhysnGGZrD8Xk20WAiOiL6/8Tt6WQXO5a+GBndhnfvaf?=
 =?us-ascii?Q?gEpf+Cty9Mstw9Ji0S7vC73OW90KlV6Pft6kQZS0xS/4JRI7YyeG4YD9+dYz?=
 =?us-ascii?Q?UtpyPL6StnfP0HnSthab1XgnEKfK6PrbFDyqYQNQ3LAWtEx5w2XyId552fbW?=
 =?us-ascii?Q?peTI/xWKzoGWO1G4ZWJE12e7pwa4LrTWv8U9PoZyainq70qb89F1/0TBb92m?=
 =?us-ascii?Q?f6uInQJVAObM9VaQtMl9of2XyiYBB7izSXjVEsamkoYU5Z/D9e8XS99Uv3Ff?=
 =?us-ascii?Q?rx9ac4GITNXxlA7TV46FbDcVGJmLiDJ+6qWuW7sdXOzMpdIQwraA1akZiMyN?=
 =?us-ascii?Q?47OS2KnW8JLQSV7ZwZJT5LKitB8SLwppyRFBpaY9xO/HSPZh437DUoX2ovPd?=
 =?us-ascii?Q?eunGIHaj8s0bJl9P5MvcLEXm361TVZyR8cynNZ1jDiCdUBJRZAGxnDgVJBWz?=
 =?us-ascii?Q?4A1bsi938EgQijXT4QRq/dabbwHIHUwV2LcGjaMEtKkKN/90X9VIE6qlLFSt?=
 =?us-ascii?Q?FmWg05mZPni2+IubjGcPG9Pu/fIbSB61BK75HTqi2TaIfvxrE/xQh9rODBol?=
 =?us-ascii?Q?3SGyw7O9QbC+fX8VrFZwK5c1Okt7Y25zP0xvNh4Hs/upl6g6M66VmUYXecoK?=
 =?us-ascii?Q?LMU3QNhtTfVQVvtvW6pwVXtk4feQYmnR3jfIoALpGxx+UiBLpYcAmfOgJ1I9?=
 =?us-ascii?Q?jV0ZAV7rsZ629mfuptOJ6CMq8rVKTRwbvST+YALug/wTyBp1qER87L4lFwv+?=
 =?us-ascii?Q?4qmJik+7Gcxb8fa4QwcLvT/87Yy8u5PX4GT26Ks/A5kIKpwRP7aI0VFESW8s?=
 =?us-ascii?Q?2/fBDSXX11kbL6TdjrLXGDq7GWikWFhntXYxoVP+SLAvKETQ9mhSNZ61phe0?=
 =?us-ascii?Q?QcGoVlc9YssFArlO4DC0zuXxMbTkZyuJFHsiJ7XJ5DHXbiC7xwIOPKXYxMGC?=
 =?us-ascii?Q?xynHetX6VlU994op/Q8GT5xyv5B29ll4SkhXd7p+EFItwpPU7FWyHdLsikHD?=
 =?us-ascii?Q?LUNoC2PP+dVnobCfTVFsE4htamp0wF65uWw4hoIQGELOkpNopRBUW5v0hJgf?=
 =?us-ascii?Q?RcLQloR7CXvqDYbdqr+/X3+fVeu8RmZMZP+c5Lbc8UmjX2EqfkGsgfPZ9vd5?=
 =?us-ascii?Q?ZZigMYsVnwx1/NpZCakEwUWLXdONGSKo7dSAjmSeQTAE75o1xM0xVv901Ec0?=
 =?us-ascii?Q?0w8v2QkMcoeR2tgKKDCoBiMy4E7R1hLtnXSTLk3cH4OUnvePiRqjUaMGoago?=
 =?us-ascii?Q?/A72N2Lg/mzEKxOojrx7w8qV7PgGtupyYelAlwGArSX4m2cb+b1UYD/qoxvx?=
 =?us-ascii?Q?P3E5O1FajKyzSZ/YVPVsDZ7ejb/nY3tDotqNB3jUXRWeuHSECQEEDICCZWIJ?=
 =?us-ascii?Q?1evINPttiHFdfI1YXisRJJ4UG0E7gdyA4i716JUC2semXuh7W77nc2WLpTkM?=
 =?us-ascii?Q?GY2aQtFYlvMYCyL5w6ZsuUzgilChBTdJo11KkcNUqIsuENRDgOqZoiEdgQjF?=
 =?us-ascii?Q?X1zRmMlz6lLnddWvZ5vJ/uySQnWJHDgWC3klUxMCA12Dwgjd2eTLZFHrakD/?=
 =?us-ascii?Q?QrucFy0THjThMbfOVb+L7TBE06cmWTegiGc3Zr8X2aTvJSidwwxPd8Rs0wom?=
 =?us-ascii?Q?JkQQ5GAsTwajkjF56aI6IY0OdLop3Zrp9KfqErUiRFwyA/U3uN0aGuSbYkbt?=
 =?us-ascii?Q?39uo6I0bVH9hOwfzoGCOqVZqr2mHItQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffa94e1a-341b-406b-24a5-08da3539780f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 23:36:57.2668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KOCuDTBHAyw8yYz2XU67ydL3CxHWNM5/Vyg2itQIL5bCO62GvU7TPZXeqsgVADwk7XtXKhAUpeHALhaXrhqKUg==
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

phylink_fwnode_phy_connect() relies on fwnode_phy_find_device(), which
does not have insight into why a PHY is missing, it just returns NULL,
case in which the connect returns -ENODEV. So there seems to be no
handling of probe deferral for the MDIO bus driver, PHY driver, etc,
there is an implicit assumption that these have all been bound before
the phy_connect() call. This is probably why so many drivers do the PHY
connect operation from ndo_open() rather than at boot time, to maximize
the chances of the PHY driver having been probed.

Normally fw_devlink enforces automatic device links based on OF
phandles, and this simply blocks the consumer (Ethernet controller, user
of phylink) driver from probing, rather than letting it probe just to
get an -EPROBE_DEFER when the supplier (PHY driver) is unavailable).

However support for "phy-handle" is sporadic, most recently having been
removed in commit 3782326577d4 ("Revert "of: property: fw_devlink: Add
support for "phy-handle" property"").

So practically, rather than relying on fw_devlink, it is desirable for
callers of phylink_fwnode_phy_connect() to consider that PHY drivers
might defer probing, and apply backpressure on their own probe if they
can.

The approach we take is to use driver_deferred_probe_check_state(),
which basically decides whether to defer probe based on whether it is
still possible for a driver to become available. If not, we return the
same old -ENODEV as before (a return value some callers have come to
expect).

As a consequence of this change, during boot (up to the late_initcall
stage), we will wait slightly longer for a PHY that is truly missing
before declaring it absent.

Before, a phylink user that called phy_connect() from probe was worse
off than one who did so from ndo_open(). But with the change, it is
actually better, because PHY probe deferral during the nfsroot case is
better treated with connect-at-probe than with connect-at-open.

Russell King points out that -EPROBE_DEFER is not exported to user
space, and drivers who connect at probe may propagate the phylink
phy_connect() call to user space. So we need to create a new entry point
into phylink, used only by drivers which guarantee they do not propagate
this error to user space, only use it for backpressure purposes.

It's hard to put the blame on a commit since this functionality never
worked, but there is also a sense of urgency to backport this change to
stable kernels. The reason being new DT compatibility with old kernels.
A PHY may have a missing supplier (IRQ parent) described in DT which has
no driver on an old kernel. fwnode_mdiobus_phy_device_register() handles
this to the extent that the PHY defers probe until the late_initcall
stage, then it gives up and falls back to poll mode. We need to wait for
that PHY driver to fall back, and not return -ENODEV early while it is
still waiting for its IRQ to become available (which never will).
So the blamed commit chosen is the oldest one where this change will
apply.

Fixes: 25396f680dd6 ("net: phylink: introduce phylink_fwnode_phy_connect()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/phylink.c | 73 ++++++++++++++++++++++++++++++---------
 include/linux/phylink.h   |  2 ++
 2 files changed, 59 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 066684b80919..889c0efded51 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1495,20 +1495,9 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 }
 EXPORT_SYMBOL_GPL(phylink_of_phy_connect);
 
-/**
- * phylink_fwnode_phy_connect() - connect the PHY specified in the fwnode.
- * @pl: a pointer to a &struct phylink returned from phylink_create()
- * @fwnode: a pointer to a &struct fwnode_handle.
- * @flags: PHY-specific flags to communicate to the PHY device driver
- *
- * Connect the phy specified @fwnode to the phylink instance specified
- * by @pl.
- *
- * Returns 0 on success or a negative errno.
- */
-int phylink_fwnode_phy_connect(struct phylink *pl,
-			       struct fwnode_handle *fwnode,
-			       u32 flags)
+static int __phylink_fwnode_phy_connect(struct phylink *pl,
+					struct fwnode_handle *fwnode,
+					u32 flags, bool probe)
 {
 	struct fwnode_handle *phy_fwnode;
 	struct phy_device *phy_dev;
@@ -1530,8 +1519,21 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 	phy_dev = fwnode_phy_find_device(phy_fwnode);
 	/* We're done with the phy_node handle */
 	fwnode_handle_put(phy_fwnode);
-	if (!phy_dev)
-		return -ENODEV;
+	if (!phy_dev) {
+		/* Drivers that connect to the PHY from ndo_open do not support
+		 * waiting for the PHY to defer probe now, because doing so
+		 * would propagate -EPROBE_DEFER to user space, which is an
+		 * error code the kernel does not export.
+		 */
+		if (!probe)
+			return -ENODEV;
+
+		/* Allow the PHY driver to defer probing, and return -ENODEV if
+		 * it times out or if we know it will never become available.
+		 */
+		ret = driver_deferred_probe_check_state(pl->dev);
+		return ret == -EPROBE_DEFER ? ret : -ENODEV;
+	}
 
 	/* Use PHY device/driver interface */
 	if (pl->link_interface == PHY_INTERFACE_MODE_NA) {
@@ -1552,6 +1554,45 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 
 	return ret;
 }
+
+/**
+ * phylink_of_phy_connect_probe() - connect the PHY in the DT node during probe.
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @dn: a pointer to a &struct device_node.
+ * @flags: PHY-specific flags to communicate to the PHY device driver
+ *
+ * Performs the same action as %phylink_of_phy_connect(), but allows the PHY
+ * driver to defer probing, and propagates -EPROBE_DEFER to the caller.
+ * This function cannot be called from contexts that propagate the return code
+ * to user space.
+ *
+ * Returns 0 on success or a negative errno.
+ */
+int phylink_of_phy_connect_probe(struct phylink *pl, struct device_node *dn,
+				 u32 flags)
+{
+	return __phylink_fwnode_phy_connect(pl, of_fwnode_handle(dn), flags,
+					    true);
+}
+EXPORT_SYMBOL_GPL(phylink_of_phy_connect_probe);
+
+/**
+ * phylink_fwnode_phy_connect() - connect the PHY specified in the fwnode.
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @fwnode: a pointer to a &struct fwnode_handle.
+ * @flags: PHY-specific flags to communicate to the PHY device driver
+ *
+ * Connect the phy specified @fwnode to the phylink instance specified
+ * by @pl.
+ *
+ * Returns 0 on success or a negative errno.
+ */
+int phylink_fwnode_phy_connect(struct phylink *pl,
+			       struct fwnode_handle *fwnode,
+			       u32 flags)
+{
+	return __phylink_fwnode_phy_connect(pl, fwnode, flags, false);
+}
 EXPORT_SYMBOL_GPL(phylink_fwnode_phy_connect);
 
 /**
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..f38f8100c41d 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -531,6 +531,8 @@ void phylink_destroy(struct phylink *);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
 int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
+int phylink_of_phy_connect_probe(struct phylink *pl, struct device_node *dn,
+				 u32 flags);
 int phylink_fwnode_phy_connect(struct phylink *pl,
 			       struct fwnode_handle *fwnode,
 			       u32 flags);
-- 
2.25.1

