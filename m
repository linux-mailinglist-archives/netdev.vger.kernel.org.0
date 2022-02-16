Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E77C4B8B78
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiBPOdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:33:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbiBPOc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:32:56 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A008F106B02
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+4MbdKvNerZN2BD6VURklW3fJ+QbcnW/oxGXuYKiMQFjl6TlUB5Eims53TmIsFHncnuBJj3xxwTDORgRnG5DL4MITPn7IAIXEpqeGsEaxPmjiyXgila5MedLfG2j00b/1cPwOTcDI269mjRm+aoHl48FxB7OD63Pk/SXVMPjh5ckLdAbolLAuH3ajem87xWkBZPrZzAL8Neq/5fuO/+4bjefwvAPsGRMY+bAdJIXsSjiZADeUJwHM2C7Ov7vAe262aWSNGUUSKOu9v5rL+O/ig0MFAOh+0j6wqCq/65+u8qaTpwISrDyn1eqJEdBgwKo/rO+AnelmNc2lzx7/apQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CwVZvf6t6cYUFMDKQL1eXs71ol4vCUAjcbt9UKsHeaw=;
 b=BNTNzqSbKS6SV3dBqAvz+RWVe9M2emeCKqUejMYpOKBxJIf2cFDZMNxL9y2u2UUv91Tn306u6pDk2oA3VMs+6CLO0CwkHbVddHutHUTUpUjG4k14z/xdQT2+IJQCo1L15nmhcSBBWZuOrq6xsFiSZGew8RaVdpjuSYGAMY1vJ7oXL/pZNm3TWhJjcV84qmIFOm14RvF48NQNm08chCZ6xLriXD9oWJQX44Upr8yNQcqWC+16rwMQAIEcVZbz6tqRPvYMfr385wXmnSDK0ihN1vCHmc76VxBIy7Mkh0rjIIusJuIinzEU2GAY44JrAL4rlTIxI+EqZ2jpEZcAwNfyZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwVZvf6t6cYUFMDKQL1eXs71ol4vCUAjcbt9UKsHeaw=;
 b=Ed9HTyycnQojOLWZmjv8/3Jx1BsAb2DZjdBbXnUXZ/74xR9USH48YJmkM2sFSV9tWu6tcJjLpSkatjSucC2AD0UD1kW3KUYLmvhKwRhBreeTvbZVeKj6XE3jZ/0S9Njn/CIUdIBZj5PLyXXNPgNWVpzAg9DC5oYeLd+i59V9f2M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6815.eurprd04.prod.outlook.com (2603:10a6:803:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 14:32:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 14:32:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 04/11] net: mscc: ocelot: use a single VCAP filter for all MRP traps
Date:   Wed, 16 Feb 2022 16:30:07 +0200
Message-Id: <20220216143014.2603461-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
References: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:208:be::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98de35c4-1394-4807-3623-08d9f1592f84
X-MS-TrafficTypeDiagnostic: VI1PR04MB6815:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6815FBE1CC0C421D6D6BE81EE0359@VI1PR04MB6815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wYWlMdgycvoqGw6g4/7b3u8vawZex7LhTRIFF9H4L1CoeA/fta7Ljp/onEsQPeSfKTQPEi+Xx/2Qbu9j8ymd4O+1/amS68BWPJJK/mo7OeEl5d0WbNvZVkHvLfadtugZrKdhELNvvDz0JGoLq8fy931cEM7GfmCifCYwda5n2KQMmwZ4nJRacOHnKP7HZJvo44b1Qcnj+zmC/uR4ECDjpRvvAjlQApll0cdkEBjJm5+HPoDyMuGcNNMCuw/+oIDqYFLPjq2V5wzr7NLYD12WIg3aJwA3IVi+a5YPfzcYR0EI+gFZc8LAkvyfrBMT04cScUa2rXcJ9OxwZ94jAxuqAvP0H+8MewoCZlUMZiin7LMmUvmQUArWvwPkHubL7+pGGmWo7jh4A9aJKmuxCCOQHIF2Z9pxbghHqRJz5z0Q2D635rk+ZaaGPlwG2tsYXflDRepFazlylIv6Xakkjs9RDSzWjPyD+UJ3OnjEsV5M+OI1xbexKaatrqY7/GzwzpEHa4fRh6vALk1g86xZv5XXkG64GpxPMO2CvfL4gcL/lJbyxCaIpbJRw6RkJ46y+YN+OXykDgLj3W8+EFkHTPLjdrsy5mkNYYFStYuVyOZa8FuYhNNdK2q+I8FQXvpHeGDFCgGwvTvGGmyXbZDABOhH+1F5NlZyXXgP12YER/vq6/s4KjZVk3ggehkmAvQA+fl//LdFxbvaDh9MJypJEetwsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(8936002)(36756003)(5660300002)(44832011)(26005)(6916009)(7416002)(316002)(83380400001)(2616005)(186003)(6512007)(1076003)(6666004)(52116002)(66946007)(38350700002)(38100700002)(4326008)(2906002)(8676002)(66556008)(66476007)(86362001)(508600001)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PT58VTIYeylAgmh2hSNeLg6hyfdVvsTuwDhVh7/fzoAZxbDWZpfvAJFOseNX?=
 =?us-ascii?Q?xW6/hpqkyT5p0/W0d8iKNKentMEOG588BhzJhNtB11J93ycCxC1+57D5GbGE?=
 =?us-ascii?Q?LEGgWr+HqimzLtybfMmygE0UNBmUpPvRvEmZ1sinbNtGnaqM0+robP1LwNOZ?=
 =?us-ascii?Q?ItJB7WDStaQNQb4MWFkCFPIwgAdkurytFOnLmjhdjOtD5CIaW8VvgmIxCoRC?=
 =?us-ascii?Q?iK9A4aHKAn4/ExaPDGhAOnDkgKp8Az8+HbQAxKB6OCTcwvSrib+JvckRSxb8?=
 =?us-ascii?Q?JGu+pvX3hNCgBtCtcQ+uB15nBx+5M6HyKD+lblGfKInO4YfiNhGZyqpPcQ4E?=
 =?us-ascii?Q?/3Pr+yFpaPdVCD6hP4cbGYaEc68PslMk7+KdF8v6YVyO4O1HbddiTEukW2aF?=
 =?us-ascii?Q?98YNHQ/sogIpeuvf7OsIT+30ClFELTC/xLaDeP4AgbK+QuVpBmGVrUYTfA2n?=
 =?us-ascii?Q?jeOW7ifkyg5pfjNhJGScvYVGWH1Y6x3uQ3tEfEey4DWyqKCiMQ/zAet9D8KF?=
 =?us-ascii?Q?yLD7w89lnnyM21HN9h3yjQ8wPnkFEldQRqmbLCG3YgCYzdBCuTrBTSt5fbTC?=
 =?us-ascii?Q?wTWIRgr+reOLs0pAPtPqDxEJ4CFoEA+FW50j3QIHfnWVYmFiJFfev4BH6QLu?=
 =?us-ascii?Q?BG69wbZeb01cIch0H1bhi10jKcbwziFaCRw9aRxsD6RJI8I1PUmzJO58kXkb?=
 =?us-ascii?Q?Lf8AJWyDAhMzLsE0T/DyA9xZtUhkCYZ+OymT0GhGsVHbxr2IlvBwA0FfTRK0?=
 =?us-ascii?Q?KTAaO6BsMcFxOSFxYwnTA2WJHv0SheIleI1+2ARDYuXDX8Z+hcReJAXFmIGo?=
 =?us-ascii?Q?3/D4pYODUdOuCUpzDpjmLfMhRNUTasGU6D/SS0R+QMUO4UjIY/9u8RWcYFT2?=
 =?us-ascii?Q?EmmoUEQ9vKkoeDVD/pCQXGqc2lvE6/BY3AKKDNX1xoO7JESEyjWR0zO0/hTW?=
 =?us-ascii?Q?q2JWC2KeNTpu/IWLfUH5o2CQ+wgehzRyCGEGkzPtBjcPJ7wPK/TYKUV+8QSh?=
 =?us-ascii?Q?kCUtahT7QdDwCTpNruINslWrph5N9EOJlrlSBgI/B4xUz3tULSz+PrLux6iL?=
 =?us-ascii?Q?b6cNkI5syS1DE9KYGVkILtvvrusSxt0G7V3GulWPE/j/EcUxqYp4vdb/lbz1?=
 =?us-ascii?Q?8KXWyT54ob07YerRlTecrEIdNUAwisJDvPPA/yLH2wa9wlLXj+Zk54d59tPP?=
 =?us-ascii?Q?rHe1jHyTmUg3fRMaExzphyCFbFapBH48OPxnefsDkHv6WLtAsxEwbD5MF6f7?=
 =?us-ascii?Q?UbFUMh32DD0eUUjmH79a9OOMGOc2s1t5+B5AkpllmjkpR4eJKWK/fthlkn0H?=
 =?us-ascii?Q?PG780pP+H+YrLDz6CZsIBRPByTcf+GhLo86CAzcsIJ+L7reEY0ZLSEYVofES?=
 =?us-ascii?Q?uYLFu+Fz+cnIqTVDaGBs9xmkwTgOkttqplkWCcAg0H4jmSp2i43K5cdtawqo?=
 =?us-ascii?Q?8ZFFfhVGXsXfBnqDHFt+hnVWGmEhk4ZnFEJkRl9IWc1M6JPb/97kRnHM993m?=
 =?us-ascii?Q?THlOO0AumqAJbYfYjlifXNHs4phxSHXOLFPltpaDE2WJUqN5qtCqLPxHZT/T?=
 =?us-ascii?Q?TLGC9guxjAQlW1Vr6Tm+mZy9SRssBkZ0zVPDhBylzHwTtS1K58qXv36ALorK?=
 =?us-ascii?Q?UUfzNVe8x+dxhBA3pbM3+bM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98de35c4-1394-4807-3623-08d9f1592f84
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:32:40.2462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /i5AXpx1aCEz/nAhhmQf05sqn+N0cCWC02QwUIwZzZ3NdhTF4F7xXxT7IJRoRAHVyhAbS0rHnoKXR5t4zpeMPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MRP assist code installs a VCAP IS2 trapping rule for each port, but
since the key and the action is the same, just the ingress port mask
differs, there isn't any need to do this. We can save some space in the
TCAM by using a single filter and adjusting the ingress port mask.

Reuse the ocelot_trap_add() and ocelot_trap_del() functions for this
purpose.

Now that the cookies are no longer per port, we need to change the
allocation scheme such that MRP traps use a fixed number.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c     |  8 ++---
 drivers/net/ethernet/mscc/ocelot.h     |  5 +++
 drivers/net/ethernet/mscc/ocelot_mrp.c | 46 ++++++++++++--------------
 include/soc/mscc/ocelot_vcap.h         |  2 +-
 4 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 6fe6bf88bdec..850ded118d86 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1472,9 +1472,8 @@ ocelot_populate_ipv6_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
 	trap->key.ipv6.dport.mask = 0xffff;
 }
 
-static int ocelot_trap_add(struct ocelot *ocelot, int port,
-			   unsigned long cookie,
-			   void (*populate)(struct ocelot_vcap_filter *f))
+int ocelot_trap_add(struct ocelot *ocelot, int port, unsigned long cookie,
+		    void (*populate)(struct ocelot_vcap_filter *f))
 {
 	struct ocelot_vcap_block *block_vcap_is2;
 	struct ocelot_vcap_filter *trap;
@@ -1519,8 +1518,7 @@ static int ocelot_trap_add(struct ocelot *ocelot, int port,
 	return 0;
 }
 
-static int ocelot_trap_del(struct ocelot *ocelot, int port,
-			   unsigned long cookie)
+int ocelot_trap_del(struct ocelot *ocelot, int port, unsigned long cookie)
 {
 	struct ocelot_vcap_block *block_vcap_is2;
 	struct ocelot_vcap_filter *trap;
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index bf4eff6d7086..674043cd9088 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -21,6 +21,7 @@
 #include <soc/mscc/ocelot_dev.h>
 #include <soc/mscc/ocelot_ana.h>
 #include <soc/mscc/ocelot_ptp.h>
+#include <soc/mscc/ocelot_vcap.h>
 #include <soc/mscc/ocelot.h>
 #include "ocelot_rew.h"
 #include "ocelot_qs.h"
@@ -102,6 +103,10 @@ int ocelot_port_devlink_init(struct ocelot *ocelot, int port,
 			     enum devlink_port_flavour flavour);
 void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port);
 
+int ocelot_trap_add(struct ocelot *ocelot, int port, unsigned long cookie,
+		    void (*populate)(struct ocelot_vcap_filter *f));
+int ocelot_trap_del(struct ocelot *ocelot, int port, unsigned long cookie);
+
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
 extern struct notifier_block ocelot_switchdev_blocking_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
index dc28736e2eb3..68fa833f4aaa 100644
--- a/drivers/net/ethernet/mscc/ocelot_mrp.c
+++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
@@ -77,37 +77,30 @@ static int ocelot_mrp_redirect_add_vcap(struct ocelot *ocelot, int src_port,
 	return err;
 }
 
-static int ocelot_mrp_copy_add_vcap(struct ocelot *ocelot, int port, int prio)
+static void ocelot_populate_mrp_trap_key(struct ocelot_vcap_filter *filter)
 {
 	const u8 mrp_mask[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0x00 };
-	struct ocelot_vcap_filter *filter;
-	int err;
-
-	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
-	if (!filter)
-		return -ENOMEM;
 
-	filter->key_type = OCELOT_VCAP_KEY_ETYPE;
-	filter->prio = prio;
-	filter->id.cookie = OCELOT_VCAP_IS2_MRP_TRAP(ocelot, port);
-	filter->id.tc_offload = false;
-	filter->block_id = VCAP_IS2;
-	filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
-	filter->ingress_port_mask = BIT(port);
 	/* Here is possible to use control or test dmac because the mask
 	 * doesn't cover the LSB
 	 */
 	ether_addr_copy(filter->key.etype.dmac.value, mrp_test_dmac);
 	ether_addr_copy(filter->key.etype.dmac.mask, mrp_mask);
-	filter->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
-	filter->action.port_mask = 0x0;
-	filter->action.cpu_copy_ena = true;
+}
 
-	err = ocelot_vcap_filter_add(ocelot, filter, NULL);
-	if (err)
-		kfree(filter);
+static int ocelot_mrp_trap_add(struct ocelot *ocelot, int port)
+{
+	unsigned long cookie = OCELOT_VCAP_IS2_MRP_TRAP(ocelot);
 
-	return err;
+	return ocelot_trap_add(ocelot, port, cookie,
+			       ocelot_populate_mrp_trap_key);
+}
+
+static int ocelot_mrp_trap_del(struct ocelot *ocelot, int port)
+{
+	unsigned long cookie = OCELOT_VCAP_IS2_MRP_TRAP(ocelot);
+
+	return ocelot_trap_del(ocelot, port, cookie);
 }
 
 static void ocelot_mrp_save_mac(struct ocelot *ocelot,
@@ -184,7 +177,7 @@ int ocelot_mrp_add_ring_role(struct ocelot *ocelot, int port,
 	ocelot_mrp_save_mac(ocelot, ocelot_port);
 
 	if (mrp->ring_role != BR_MRP_RING_ROLE_MRC)
-		return ocelot_mrp_copy_add_vcap(ocelot, port, 1);
+		return ocelot_mrp_trap_add(ocelot, port);
 
 	dst_port = ocelot_mrp_find_partner_port(ocelot, ocelot_port);
 	if (dst_port == -1)
@@ -194,7 +187,7 @@ int ocelot_mrp_add_ring_role(struct ocelot *ocelot, int port,
 	if (err)
 		return err;
 
-	err = ocelot_mrp_copy_add_vcap(ocelot, port, 2);
+	err = ocelot_mrp_trap_add(ocelot, port);
 	if (err) {
 		ocelot_mrp_del_vcap(ocelot,
 				    OCELOT_VCAP_IS2_MRP_REDIRECT(ocelot, port));
@@ -209,7 +202,7 @@ int ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
 			     const struct switchdev_obj_ring_role_mrp *mrp)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	int i;
+	int err, i;
 
 	if (!ocelot_port)
 		return -EOPNOTSUPP;
@@ -220,8 +213,11 @@ int ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
 	if (ocelot_port->mrp_ring_id != mrp->ring_id)
 		return 0;
 
+	err = ocelot_mrp_trap_del(ocelot, port);
+	if (err)
+		return err;
+
 	ocelot_mrp_del_vcap(ocelot, OCELOT_VCAP_IS2_MRP_REDIRECT(ocelot, port));
-	ocelot_mrp_del_vcap(ocelot, OCELOT_VCAP_IS2_MRP_TRAP(ocelot, port));
 
 	for (i = 0; i < ocelot->num_phys_ports; ++i) {
 		ocelot_port = ocelot->ports[i];
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 562bcd972132..14ada097db0b 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -21,8 +21,8 @@
 #define OCELOT_VCAP_IS2_IPV4_EV_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports + 3)
 #define OCELOT_VCAP_IS2_IPV6_GEN_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports + 4)
 #define OCELOT_VCAP_IS2_IPV6_EV_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports + 5)
+#define OCELOT_VCAP_IS2_MRP_TRAP(ocelot)			((ocelot)->num_phys_ports + 6)
 #define OCELOT_VCAP_IS2_MRP_REDIRECT(ocelot, port)		(port)
-#define OCELOT_VCAP_IS2_MRP_TRAP(ocelot, port)			((ocelot)->num_phys_ports + (port))
 
 /* =================================================================
  *  VCAP Common
-- 
2.25.1

