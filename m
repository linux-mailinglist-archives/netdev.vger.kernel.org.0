Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904DD4FDCFA
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359422AbiDLKtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357201AbiDLKpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 06:45:52 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20079.outbound.protection.outlook.com [40.107.2.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E182615FC2
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 02:44:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQgOnxf97afBCUuhxPMUlxJdGwkyMyUSwj/pwDupCYrBfY2UUmeZe7uKRFbNL79HngJlnDuk6NA1O4aP/yEWy62izADgsDOex1t/o4VfL4OhByRWFakdUqEitFAsAG/Jp2QG63LnTABjpK8OK3djVgEb5QL3fhih+JI/SqvaiqVig/Dm7kqhjCEWvEKqZ+K2rcPSUoU0Zy+JDvqZ35BtQFRU4CM5siKqduHjiG5yhGqoDz7hOPQtrbDb2DHKmWx8kE+rhpL24LT60c3ngdagRci34apqZeZ2ticzhjV7Q6wI8CVCKqFqwCfrkhrFDzlHvD3spqA0OC/LVIemGGgDJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQUCR0NKB2eHEOYEc2MCLpJCZg5mK4nfNVgd93oUSdc=;
 b=WQ9/vAXGYenVmR5Sa8+TdgpxF8n+UzZj2+raTRLIv660ScsOJh65Ibqu1LuMpaI3MjAfmxXosx1THAv8YMZkFphGgFhAjJHlIk49yGvef9QWHCSNwRZYEU3ZTgFCcSGpi9pwmzSrdwqKrMZk6fKfAkTBkJiAmFuXkBZo2sfnh9nmX2TRsPPa2pCtZY8Csl6ULW1N0Td28GrhciBUMqAhGFfT7HtWsIbK6C0uGuKLB0ISYatmBF0iFti0VYId4woyUhhUbRwfqubn3KWUWfDnJQ0JCA/X/t/SVB6mh2Hs+LEA42tnhxeokQNTp6YTUSMYbdn51J/N51EvqzGXfvx30Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQUCR0NKB2eHEOYEc2MCLpJCZg5mK4nfNVgd93oUSdc=;
 b=fQbMfgEg/vlFQS16oER2D9D/jTHciBBl8s8i40kPF/rqx7tm1YamMnjaHUQBx9W+px2jc8q8v7eaOM+QMkH7T/5oUgRxgaC6mXJBKpWgRKPhk/bLBkzdweJ8x9uuJBKx+09Hna+6dDvb+i9j3/jdVnax0uAuxVOcF89Fo71SaH8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8487.eurprd04.prod.outlook.com (2603:10a6:20b:41a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Tue, 12 Apr
 2022 09:44:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 09:44:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] Revert "net: dsa: setup master before ports"
Date:   Tue, 12 Apr 2022 12:44:26 +0300
Message-Id: <20220412094426.2342043-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0195.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ceaacace-dac2-49f5-4f23-08da1c690ebc
X-MS-TrafficTypeDiagnostic: AM9PR04MB8487:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB8487EB94D402A5B107E078DCE0ED9@AM9PR04MB8487.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: epuwTZM3S4NRPVBl5oNOfUeOXyWKvUNQKiOTNo66P9jqfyggYMRfPprzszY6zGYZNkFhE5uMwR+UwTlmr9K4ehbl0DTokCQTsuTzmMVnNsW905XBraYYqAMp+dyeYwTm5pK2c1K7AEAKXRj3RMqwRCVgUByuFsIxbV9HuvgvwXl7wL+jUkgT0YZ6V7DaU8dr6h27dkxLUZUyLvwty9LzK6SwBdnl9H1VKxwN9wYum6EujIqnbGEYjpU30+QH7uEhH72FYE4h2wSarrEoXrw//qdLkwI6JLdmNv9WtZVJJV56ZV6xAab78A6mAPF9d8FJTFJ818QreOsZeaOsPuv6rLcN/gP5r03nldVHxyLmWI7E/X6g6rDifulgqZRjZajtxVQTC68eBCKOGSDvaChQEgLp6FfEAKZ14Ty3tEF7YsG45u2exuE5J3CPWsazzF3/tlUwU6FEfoXgR5wOJTkF4S96PBqLGYwgwK0JhKDR5c6lRTF9gKRVRyy83IYoPNEWF7NOo87mZTiLp603wEkcMHQeXn9bcxrTVHKwNBOXOqxDycWVR6qhj7OlmIU/s+FEJfZIWLViECCUQIycIc7bUMO9CvzitXlFCkB3A4/yVoHUT/+ONV4BEoOyfz37wkOJcVFz4aMWMzGJXQyhsWUaDXgGL+ReltrL963zvMhsPKNgXpGf8Ukvt+/bPm8ift7x+J3qYfK5c6ficw4/OI8cXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(26005)(186003)(6666004)(86362001)(44832011)(5660300002)(6512007)(316002)(2616005)(66476007)(66946007)(6506007)(8676002)(6486002)(8936002)(1076003)(66556008)(38350700002)(4326008)(38100700002)(52116002)(36756003)(54906003)(83380400001)(508600001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0qBaSOzQ0dzXuI3IgABK2SQhMHW2hEnV2ALoZvhCAT9lOBMpxSxSPlt2mPgQ?=
 =?us-ascii?Q?OQNhMdV4v5Acqq24ICeq7Imp+vWA+iPnce1mkQdW/UU+qjMbJf1xoC8QlQMa?=
 =?us-ascii?Q?fvHBb/yqQlVU9QJwJ1E4l2Nz96HPbeSIiunLR6VopcC5msQ4c+X0T1m7mAkG?=
 =?us-ascii?Q?NFdcOZOOG21aI6bPd5kniO1x2oXS9lo5v7fV7mHlhCjkEqap5BVoBVB0C6Jo?=
 =?us-ascii?Q?viRc54oUieo2FIxHgf4vIvmoWs3TJ6QDAJn0u37if6IhjR7LuOKA6toR9EiP?=
 =?us-ascii?Q?/U8EKalU9Toj5aETvO+e1SvE3A819XDHUahlfqbbib49RW7tmjTyt7HlxnQl?=
 =?us-ascii?Q?bBt331AcVxqmhPjdJMe86+Ms6cOgDcx0VASdgB4AIZ6Z9OiDOcpsiHVNqdeL?=
 =?us-ascii?Q?uOZQIVPLSolANicsKa7J0mzt74Z6jhFMgCcvACSDIhC3yehFQEUqprTjHntQ?=
 =?us-ascii?Q?0c9f4LsBAD3vQH7/+vlkzW7OVaFwUQZnBSV3769+E+hk0UIuxoc/Wp8D+3ki?=
 =?us-ascii?Q?OOCXZtVQLhrBlQ094x2Rm5SX7Bf35i7WkgR5eTkAQ4E7nb9Y3Vnenu15l46u?=
 =?us-ascii?Q?ZdvgYW98DfgsrSH6qzkss8kAyIidACaylGg+HqmkciE3waIFD0jDDWGRlbol?=
 =?us-ascii?Q?5okaxNmRuHzDKawSgykJeZ1GW7f/Td+lh0mug6vV32/ffd2szhSNtinJHXGN?=
 =?us-ascii?Q?xCYxKhVjiT3M0LkHAt5jF7RQWhQ0/niVvISWMXGyHBNauo236/ojl2ve7+dw?=
 =?us-ascii?Q?WDYa/zVObmpZ7/EjGDEY918s2GqC6qCl8ur59kn/nnlRYk6lN1482MPZgB2q?=
 =?us-ascii?Q?74N5FUS7LmU0bDj90XTH9XTuP4sEYaxdkf+Mqzk3bgruiyXBR1wxLMnKD4lP?=
 =?us-ascii?Q?EWT7BYkjzyyshUX3Glj+/3lAwho94yQqMub1tXhL6qcrqOLerbJH4NVVDBoC?=
 =?us-ascii?Q?0jlg5ONDmoxUxW/pTXdzo79Kmm2Ccg/tAS2p4H0Ff3FSN+oJ3am+zM5gnL5s?=
 =?us-ascii?Q?HlTRxIZ2xSLWAJswyA2Oi+W4H62MTR1WT/vE7bUYz5RAAATBBXro/zlQEqZg?=
 =?us-ascii?Q?K8r/BxyB8aucFbodj/HlRbI78VR9nQ6gGC9sshCEXvlFa9IGOlsVEjKbGd1H?=
 =?us-ascii?Q?aVkzGFxDlGnnFu7Dz8/ztBRm1ANmVzDzoEEMJ0ArdXY44IEO/taDyJ6la0lb?=
 =?us-ascii?Q?HR2kLeEBULEWapKwJBn7yryxTjDbPc8p0hIEDN8eSA8KatMeiNPaSmUumEgZ?=
 =?us-ascii?Q?cV0xkYceJASySqLIZOVuyyWsc0VwKLh/NyLJXiTjnOfAjblzZip2U0wsOF+W?=
 =?us-ascii?Q?FjolRLndgHVHs1gy0GmRhzJzVXqDe0YkjPLDiNOlI7NlK8V1rTQucbTzT9Nm?=
 =?us-ascii?Q?+7BwcayeHh/HWZIyBSNuiCS6RiZuYtPaA6F8F22UOwwHEsXos7jV7ADI0+EB?=
 =?us-ascii?Q?vHlrRJnZknmL1I5oU/1dgXxyBuT1jj0DmXnTXx/mH2UINk0m7RBUFCKevBCN?=
 =?us-ascii?Q?3fG8fSyN1IWqrs9dhX4nWvEoudZ8JDt8ywpJxfBmQ3pydX6BjYu9DGYBE9GT?=
 =?us-ascii?Q?3e8gbt5RK0GGgaq88voX7hMPzZuJbUyQcWVVeDWXvfMTJZliTX9gzP0HDKuq?=
 =?us-ascii?Q?02hJwDsUyl+kV1e1RouLnEt/oTYQzrgfUtSLOC6ruKYqMuaDVbjxX7nkTR5R?=
 =?us-ascii?Q?c6sHCRqW+e7m1RDyD7uHD/bQtaf7DKg++co+dxEcA8WHImxy8z5SkNfK9U+7?=
 =?us-ascii?Q?MhUqAMCWMPRvA28ZeRuZo5Q06x8IDh8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceaacace-dac2-49f5-4f23-08da1c690ebc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 09:44:37.2899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: udpC6zhA2awrhRcApnmQlGguIgjj95YsjLVj0wrw+21kMpt60sp05CrHqoVMvaZ7WXaQZAqILq05UhlUkSqumw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8487
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 11fd667dac315ea3f2469961f6d2869271a46cae.

dsa_slave_change_mtu() updates the MTU of the DSA master and of the
associated CPU port, but only if it detects a change to the master MTU.

The blamed commit in the Fixes: tag below addressed a regression where
dsa_slave_change_mtu() would return early and not do anything due to
ds->ops->port_change_mtu() not being implemented.

However, that commit also had the effect that the master MTU got set up
to the correct value by dsa_master_setup(), but the associated CPU port's
MTU did not get updated. This causes breakage for drivers that rely on
the ->port_change_mtu() DSA call to account for the tagging overhead on
the CPU port, and don't set up the initial MTU during the setup phase.

Things actually worked before because they were in a fragile equilibrium
where dsa_slave_change_mtu() was called before dsa_master_setup() was.
So dsa_slave_change_mtu() could actually detect a change and update the
CPU port MTU too.

Restore the code to the way things used to work by reverting the reorder
of dsa_tree_setup_master() and dsa_tree_setup_ports(). That change did
not have a concrete motivation going for it anyway, it just looked
better.

Fixes: 066dfc429040 ("Revert "net: dsa: stop updating master MTU from master.c"")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index ca6af86964bc..cf933225df32 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -562,7 +562,6 @@ static void dsa_port_teardown(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
 	struct dsa_switch *ds = dp->ds;
-	struct net_device *slave;
 
 	if (!dp->setup)
 		return;
@@ -584,11 +583,9 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		dsa_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_USER:
-		slave = dp->slave;
-
-		if (slave) {
+		if (dp->slave) {
+			dsa_slave_destroy(dp->slave);
 			dp->slave = NULL;
-			dsa_slave_destroy(slave);
 		}
 		break;
 	}
@@ -1147,17 +1144,17 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	if (err)
 		goto teardown_cpu_ports;
 
-	err = dsa_tree_setup_master(dst);
+	err = dsa_tree_setup_ports(dst);
 	if (err)
 		goto teardown_switches;
 
-	err = dsa_tree_setup_ports(dst);
+	err = dsa_tree_setup_master(dst);
 	if (err)
-		goto teardown_master;
+		goto teardown_ports;
 
 	err = dsa_tree_setup_lags(dst);
 	if (err)
-		goto teardown_ports;
+		goto teardown_master;
 
 	dst->setup = true;
 
@@ -1165,10 +1162,10 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 
 	return 0;
 
-teardown_ports:
-	dsa_tree_teardown_ports(dst);
 teardown_master:
 	dsa_tree_teardown_master(dst);
+teardown_ports:
+	dsa_tree_teardown_ports(dst);
 teardown_switches:
 	dsa_tree_teardown_switches(dst);
 teardown_cpu_ports:
@@ -1186,10 +1183,10 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 
 	dsa_tree_teardown_lags(dst);
 
-	dsa_tree_teardown_ports(dst);
-
 	dsa_tree_teardown_master(dst);
 
+	dsa_tree_teardown_ports(dst);
+
 	dsa_tree_teardown_switches(dst);
 
 	dsa_tree_teardown_cpu_ports(dst);
-- 
2.25.1

