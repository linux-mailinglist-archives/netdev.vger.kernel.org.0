Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7A651EE8C
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbiEHPbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbiEHPbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:31:32 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10053.outbound.protection.outlook.com [40.107.1.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A1A1125
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:27:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GF7dAuhjmyQQDdUK4O7ni+RS0W3eYiSmLLUr0+eptsKm0o1tpbE9DUjt3Ci85x6IlnjGfhYJwzAJ7UGFGgFvp2qKY3r27tFbs+cE6QQux9yu3gLjLUfuYxaJ74ZCXmF5oLWXFDVwZWJHVPNELhabi2oL8nrDE2xmUsX+ap5tcDXC7u9OmSodxQoGrehGmt6KvXhkIo1eORt6A/NezBfrcSCmYcrSkn2qYkNfjQy336KklTw1LXSlGbVMK22x6Ve+92LWh7P6Hd/Akvzk9nRzQ6YU7SHD3j22pLHh6gONyQH0szvgkWU+fiSXWPDC0BaPuJr+nR3Sih76FujLrdCSkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6r3RwTVx0dlSr+oJvUb3AnEuTlbv6nqsS6TOJHP810A=;
 b=D/2Hf9OhzfK8rzA/wYh7p/dA2MlX1OTaTW7T9Dkf/VhEQX1+LZa1bZK2dQhG145M+DjJQJ/vwNvqtKzRY/+K4GbX7Lr9h1JhQLFGFTTo11YR3Z41f5yDrFFD2nqH6jmYN+4mIMmrL3uCkoIFdhNIz7uEaD4GqU/JxmJH2+JAMhTV0fGH2yZnjshZlb8RUVDY7XQHV0Y5FIufVkvXw+yOhGJYAvTTwg0FSXTlbAuonePh1hGkxrUjq/B8KxX6Pe+9mJg1Ajk77lcJPIk4iDNmq4GzMrQcFjTb3t54eWusUhbL6zAkrhPjy3lDKrIM9d0xSRMYihuP4f2JxIJOHcq0ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6r3RwTVx0dlSr+oJvUb3AnEuTlbv6nqsS6TOJHP810A=;
 b=hJH9YLhkGZuY+a7YCYUaPVd3H826ed2A5nrRx/oQgLP2XcG7kwR0d3G4Jkfp6mpQKGFvL6zITY2p+YjfEUs8A4S1LtbkH+QRxRxbrUyd8KKZBBhAxlNg22yW+A5bXsPp7sqKGlZDz3F7p53VLOzfezQcySMekaqlFCKlU3FbTPA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB6PR0402MB2806.eurprd04.prod.outlook.com (2603:10a6:4:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sun, 8 May
 2022 15:27:37 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Sun, 8 May 2022
 15:27:37 +0000
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
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [RFC PATCH net-next 7/8] net: dsa: felix: dynamically determine tag_8021q CPU port for traps
Date:   Sun,  8 May 2022 18:27:12 +0300
Message-Id: <20220508152713.2704662-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
References: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0205.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::30) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54aee72d-0c69-4234-3f20-08da31074833
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2806:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2806B0D974EF7922E9B95374E0C79@DB6PR0402MB2806.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fFVp5cWaYLvc4ZC49qK8ZaCi4qnlQCs8GbOgYiwrc5/Ye+adHGWjA0K+luuCXZUODwnO/tal29q649tnLzrBtgwOUe2UHoYp57139T53G8JqYAbGAHNUJlyFt1wBoD16DRvqxjT5pxiAoHaEq28nrGpf3ZnAUtva0YxVj4+JgOYJ1TmIDTA5dSyaPzBDxkr6UqICpLzbC3EKlTh/+AOqpWBJNBCSrgA2pZlOGtAvJ/KQqn6NZNaz/hsuXBJXXRYMzvsoJCAB6IkdGi1WkUrz4rIYRMFPVUN3PE135oGc5rmxrZ8BakF7cbJ83shtTOjqxreD8fuWF0n4pZilQc2mKCoQfDCdC+ShdZ0P57CK04FwTm4/Umao0mFeUUXyD4nkEKp03g5yEHseoqOtcNUH31Tan50gdz0p+qFY1JBmo90PxFZiIxrzR5vwBYoKtGCvC14mLq0S7D90oKydW2NAT8uNVetz2YeqaDvpzjRuMT/R+ZNSLlzJUNgGMOsmvXKuKv9d4d07ezFedOR+ZkPKF3V5IizJsp+cYrpgMJ69pUf+KO673VZhrsH3JhW0g152G8efD7NESELbOFOKEA1oHxNtWq1rA5Rbm+ZPQ/Jq/4kbsXVpwikcj+oZKo9+E4jwVf1l7sUiK2p9XDcdziyJjbssZP5LngMkmYE+yRplYoMeHv8ruO5+Fysj7evVtmDaK/70LgvFHml7MD3jg77TFCfENsAHbLrjuu7ig/7h9AM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6666004)(6506007)(36756003)(186003)(508600001)(6486002)(2906002)(38100700002)(38350700002)(5660300002)(6916009)(66946007)(26005)(1076003)(44832011)(7416002)(8936002)(54906003)(66556008)(8676002)(4326008)(83380400001)(86362001)(66476007)(6512007)(2616005)(316002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dA6buF1c6IGrBXsYn6eIq8WDpiBYoiikxoVhxtqAwFg/jl6621m28RyoJW3x?=
 =?us-ascii?Q?6T+TPypk46xsTuDIpmoxQBvBHPs0H9WNrg+zGfVWUcAnf0C4+SxSaQgUQc2U?=
 =?us-ascii?Q?cBQOVoEhGELQjYz6fy1PpzgjzKGeuIlZ/SCuJ4u//RKQ6rl61xoprk8jEOfY?=
 =?us-ascii?Q?p5Aqc+5Fc9SUpS/+dJSISzNt2+KcwXH9B/4HjMio4uMBPVPMEmg6/Acd9DfY?=
 =?us-ascii?Q?Cr0tsDpHERlH05ng4QExYCQGumeAGto/z4CoE1VbVfwWH8Oyrfkqvdkhhjxm?=
 =?us-ascii?Q?F1EKamcOc0egJ0ct1YevX++cY9EPQJUbKbV1EfK+f0FYnCiCo8wh3b+8JSBG?=
 =?us-ascii?Q?fBldke947qiehAtRkS5zXSHFKM6kz52cKfouyHVJ+SPbsqggPWPyAyMtej0c?=
 =?us-ascii?Q?2v8ZnNwR/Lk9PXFEMyeMjNqq2XtKq2wGbwd3kDI+tNVAhqAnRgZA686K9vmN?=
 =?us-ascii?Q?KPbJd0QizxXp1blB4XKkDVBXMYDxUT5Gcla1e2Ea/rLeSWGHW1HAmqyeOGzi?=
 =?us-ascii?Q?TU6Vghyy1OZORUiAdbjroFK8b3yttY2MujbcmRlj/mFv5+nQ9GjRDbVAGLO0?=
 =?us-ascii?Q?AzBQMA2BGmbsQYMuBWhoNLRjQQnf2lej+PnQPW5rl9Qzk3St1MdxEJWTJ1hy?=
 =?us-ascii?Q?3+K3wcxLv/OsuOYNiooBJegOY+fQMjlevn1vDQznNvY0PyjbIFTv5PHM8n6h?=
 =?us-ascii?Q?5ZhL+ZH7cYlZzM/WXFwfPpl5trVqVj0QoPGUNxsZm42n3K7e5zvb1mj+VOE5?=
 =?us-ascii?Q?MGFxiNKLX0ftHkuv5+naQEAB8Em252ufMCuM37HKziAPSg2OtD3FJyIy4TiK?=
 =?us-ascii?Q?0z9AmG7ovsIIXGnDwm2riQXvrWJbmJ5isemdkcxLc4VoSsGfHBLZ2+SWut9P?=
 =?us-ascii?Q?JZWEPm4Zxn/lTQ1KAotVhR7GaDvdklYGroNIsHdJjD4URiqOk40Vki46/on0?=
 =?us-ascii?Q?qVFt+7WSsvlSzkQrMS16JOeVTniYwKdnezB0O2DDFtUYGvQZ6tIsmHLdwbTK?=
 =?us-ascii?Q?3OT1nzo4FaCK1TIA8iGolX8ZtQpcqataGBO0NzNNuGD9m7UCmdaszBBEsY1k?=
 =?us-ascii?Q?aplsINx8KHb51BImeW7Q3MxN+rKNaNQFHuNcN0KJCXAFbFRkAu6TxE/4NC81?=
 =?us-ascii?Q?p687rKz3tiBkUNGElfFoa3UnLdJY/F0PYHeQvORtpvGZKgUbTBDxhDD8SG2e?=
 =?us-ascii?Q?Wryf1jea9a5+cUziIU+wmGQwMf4+QXK8OYXvVlT0qOdTw85juJyMHwv8sOO+?=
 =?us-ascii?Q?uX4SrEHbOmjeopGbXC34tNrekjI6USkZYtmHhZqt4TJ71Xv9WRGvuA1wZRds?=
 =?us-ascii?Q?yw7yuk3hjJpDU7ZtBD6+mViMfB52YCHiRerR3/QDY1M8loa5n24Rds3ghsP0?=
 =?us-ascii?Q?sDrYaGfz60DqqRiBi7yPnv/BQuyFH94/+VAoSSitsZ8BywbtO43/xQsX7vcF?=
 =?us-ascii?Q?7VNDuRMrDgIayRziw28rhVr2SHkY+7Hwo+HqDebjue2LcYe5sgWC9L8qQiDN?=
 =?us-ascii?Q?uctp+pXzPQdIHweJy390jecnEZQS75vH1dQ5Ud8ROrXPS+PaJhXnHd5Sq+R2?=
 =?us-ascii?Q?8LDiz9y7JQ9gWL1S1wXf36cYzaEDBX73g4pnKBD9M2aGXEr0wD8SY07xbEHQ?=
 =?us-ascii?Q?NM/EV4U1gr5Ourv47HYHzHOR2zt3bZ1FQQESZhXgT70NSwgU6qdolaBkzcYH?=
 =?us-ascii?Q?TFyuRkowWyHvxLEomQ2Vrzqf3PswoGoVHKW3BcMyVZGoqO7z+P/TCcWTd+3N?=
 =?us-ascii?Q?Lnl4ah6X6Ar1N9D9PXwImb59dIVHLts=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54aee72d-0c69-4234-3f20-08da31074833
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:27:37.3759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EHpvmZRlGyDKFT/ywQpuhVG0s/XggP5iHiiMxnPuiohUED/vlw+kHCf7IP/6ECyjKQQ+IbI9kWsA2tVBoj8zQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot switches support a single active CPU port at a time (at least as
a trapping destination, i.e. for control traffic). This is true
regardless of whether we are using the native copy-to-CPU-port-module
functionality, or a redirect action towards the software-defined
tag_8021q CPU port.

Currently we assume that the trapping destination in tag_8021q mode is
the first CPU port, yet in the future we may want to migrate the user
ports to the second CPU port.

For that to work, we need to make sure that the tag_8021q trapping
destination is a CPU port that is active, i.e. is used by at least some
user port on which the trap was added. Otherwise, we may end up
redirecting the traffic to a CPU port which isn't even up.

Note that due to the current design where we simply choose the CPU port
of the first port from the trap's ingress port mask, it may be that a
CPU port absorbes control traffic from user ports which aren't affine to
it as per user space's request. This isn't ideal, but is the lesser of
two evils. Following the user-configured affinity for traps would mean
that we can no longer reuse a single TCAM entry for multiple traps,
which is what we actually do for e.g. PTP. Either we duplicate and
deduplicate TCAM entries on the fly when user-to-CPU-port mappings
change (which is unnecessarily complicated), or we redirect trapped
traffic to all tag_8021q CPU ports if multiple such ports are in use.
The latter would have actually been nice, if it actually worked, but it
doesn't, since a OCELOT_MASK_MODE_REDIRECT action towards multiple ports
would not take PGID_SRC into consideration, and it would just duplicate
the packet towards each (CPU) port, leading to duplicates in software.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4430495a4d21..68187d7904a7 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -313,6 +313,21 @@ static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
 	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 
+static int felix_trap_get_cpu_port(struct dsa_switch *ds,
+				   const struct ocelot_vcap_filter *trap)
+{
+	struct dsa_port *dp;
+	int first_port;
+
+	if (WARN_ON(!trap->ingress_port_mask))
+		return -1;
+
+	first_port = __ffs(trap->ingress_port_mask);
+	dp = dsa_to_port(ds, first_port);
+
+	return dp->cpu_dp->index;
+}
+
 /* On switches with no extraction IRQ wired, trapped packets need to be
  * replicated over Ethernet as well, otherwise we'd get no notification of
  * their arrival when using the ocelot-8021q tagging protocol.
@@ -326,19 +341,12 @@ static int felix_update_trapping_destinations(struct dsa_switch *ds,
 	struct ocelot_vcap_filter *trap;
 	enum ocelot_mask_mode mask_mode;
 	unsigned long port_mask;
-	struct dsa_port *dp;
 	bool cpu_copy_ena;
-	int cpu = -1, err;
+	int err;
 
 	if (!felix->info->quirk_no_xtr_irq)
 		return 0;
 
-	/* Figure out the current CPU port */
-	dsa_switch_for_each_cpu_port(dp, ds) {
-		cpu = dp->index;
-		break;
-	}
-
 	/* We are sure that "cpu" was found, otherwise
 	 * dsa_tree_setup_default_cpu() would have failed earlier.
 	 */
@@ -356,7 +364,7 @@ static int felix_update_trapping_destinations(struct dsa_switch *ds,
 			 * port module.
 			 */
 			mask_mode = OCELOT_MASK_MODE_REDIRECT;
-			port_mask = BIT(cpu);
+			port_mask = BIT(felix_trap_get_cpu_port(ds, trap));
 			cpu_copy_ena = !!trap->take_ts;
 		} else {
 			/* Trap packets only to the CPU port module, which is
-- 
2.25.1

