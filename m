Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07B84B769B
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242115AbiBORC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:02:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242111AbiBORCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:02:47 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10075.outbound.protection.outlook.com [40.107.1.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86950119F55
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:02:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbBYZCrFT6vX3OD55WHEnqAgTDcaHJ3dovaxe3lxckY/T1A7DLpaVt/37h4hpSyYwVqq9ajU34/yFjPq6PupisFO3s2J9bDm6lk6BaFmAsHbhAhmVkYYdYEbMd6c9/MmlfbRNVGFSkco342p5bUobimUQ+iln8IGfb4GHnS4IcMmPPPO7BPoM8WLFRZTJefUCk0AwAVPDQ7Eo2Q+Cd9PA86byq0CSNk4gSoq4qHdzNiCaF47wm9Z6jMc8K020kEq+crtk14x/I1s3W4oThBiytqbP2096ItS2NFSV0vcXFL+LrfN3QpYBa3G3g9v2qDG3glPJ80qUeBF+lBf2koLdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0NF63esgVXkrOCFrGBAHyRyAsdUSSem7GfV94f09Wro=;
 b=V0ceXzaC/UUxS4zbxW4lbJcD3DrowB4HcCtBqqb/pRuJ9htWotqasViELhVKb8/vAFhq+x427zDMn86Mc+cftorNVCfyUJVJTaoygHAquwQbdBidmRi1aZytdpt4yZnzuecJmXZVcKCfudPEIaaT54Pl6fQPbfNfMPU+ix4Gf4TwChVDEhrSSWK6W9pB/NeK4F4qmHpa04HQzxHN3GBLofIlQVYSGjBFLayJh6BQEwvnljXERb2LR0EF1n9r2AV9O85b4WzCuSMx9Vdi+XSVpwxM9gkCZ3Pw1a8p//+pVtNl2phBMxuw96VMGBtpt/vHAy94KifTLl2a4EePtIwx9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NF63esgVXkrOCFrGBAHyRyAsdUSSem7GfV94f09Wro=;
 b=P+zVMyLdflaEDqkP+0P0CLP9r2o+TI8KKEdBy/c1t7Vku22UtZEWUsVzjYtq4ndNDBX6t0IjV4PpvJ43SDQhkd3O+W/Hug83aQ1RdhTgzBNk1XOIM5gHhQvTwc50Giy7FrS9pEKKTxZVz+nI2YHO0WAso1a/t7/X99osHkfqeBg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 17:02:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 17:02:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v3 net-next 07/11] net: bridge: switchdev: replay all VLAN groups
Date:   Tue, 15 Feb 2022 19:02:14 +0200
Message-Id: <20220215170218.2032432-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fafae2d1-de49-4835-cc63-08d9f0a4f452
X-MS-TrafficTypeDiagnostic: VI1PR04MB5342:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB53420C7F16C055696B3A7906E0349@VI1PR04MB5342.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sLXAS2tXRx51z8coWrNX7mJpeIyL01+zOkNwC+MxV67DqPJ1mK2RFaFRfPYEpHU2XFhnKf4W5spt9Hn/pxQLTbvcf8DNHgWOMmyhjdEC/hsMUm/Pw/M+r/tJGRbfBfNhZ9zp6hxJo+OvDkRHzRq6P5tvUcA48HzxRDjKPz4qlSJGdGVeGSeMKdqDHX9c4X4N5cnDGOZfsA2x24szdANZAE0by9lyVPGdqIKe1raKo1aK0Gmvpx9pfMzg7IozPpUGRkWInegZ1X6SJ/kgACPXHmkiXMwXrChXytmYLfy0/M9HcJU7mu4YzJ+AFzax54MIjrrPdcnfAYVb6yiLp6rHx2+NOSHBnnxADSgcx3TxF6c2YQLp7Yc0Qi4HrKFaRhtRaLWrGwt2K1G0ZJ44pdZ/8zOTPXaabaYAwg/C8g2LiCSae7WcS4CB/FIpOKKB86CWendGznx6YmKJjyxXCHImru5S/DufpmamdxLWl5t79+KQv7ns2gGrBjNCZkA/Ck+uya2uC/MAwy85yGMwaec0qBE8F/Vb8/CMYPkiU/TsgmubbVsJ1XYCHuC88Y2s6YWpLSIfGt8PCWAmBQjpd2cL5+2ae8imwGEr1xmEJEMFMsrxWyKhgVY6u5NlN/TeuZiz1Z3P03o+zGLSI5xdCWnYxZ9cIua/69Qt4qNrVUx4Mt5p+u+Wul+xVIMFnMvac02VhsAo2h6MhvQj0pCR/bWkNXZZtiyGw9mMTFSeIJboxIaKd2L87HYpBDNu8Sue16sv8B+LLcEUv7mI7EMCE1Of+9xFCKxjAktketXI4mAkeTA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(508600001)(2616005)(316002)(26005)(6506007)(6512007)(54906003)(966005)(1076003)(38100700002)(6486002)(6916009)(52116002)(38350700002)(2906002)(66946007)(4326008)(44832011)(5660300002)(66556008)(8936002)(66476007)(7416002)(8676002)(6666004)(83380400001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9vYN6kMhRlG9BsLly2mLT5/EXKqXpSKSoFJEeoC1jlGSsb6ukTDmbkrglMY1?=
 =?us-ascii?Q?cL0WdG+5tVMQDOzjwoQOBnb6FTNjAsocUsCScwu5erPjwoHR4QH299Bd9izL?=
 =?us-ascii?Q?b0dFPdOiaLX59SssAjzJnRW+coz8KYQ3zUKFpzp+NsQ+3DG10YFErwuQ65Vn?=
 =?us-ascii?Q?WDXYWZifVSVVQtYYFCIZMzysuXfGs0SCY/QRbogXEXrAmTc3uhorhmEndUe3?=
 =?us-ascii?Q?q1ZKYpKzVDtCltyHvU2i++s83CBus17ynPFdsOHEOnZCw5VTHcMhSY/rUecM?=
 =?us-ascii?Q?QCuY33nnGrx6IYVOMqqMlOOxtH4dj20ilHE7oe9F3ZIDd3IC5QVQe0HBJH2E?=
 =?us-ascii?Q?9i76DSVxefv/qZDOj9/uFqOW1wERovxF7BkmBlEqX9LDxPflgX2ckHKtRz+0?=
 =?us-ascii?Q?DYde9AeTjEGLafPX3t9ooKKCAxVuew6w0VxUNamJGqZDEHpJzxUrRJ8GIMpC?=
 =?us-ascii?Q?+1Mk5DmDtFc192hP1KtwO458zBmpCplgdwU6NhOrLHUYKarpwNl/VkmNnR8U?=
 =?us-ascii?Q?ujSIcl9txNmB7Qn0y2wPA8KAYmBfyC9G8cvdk7XJXPnUC1wx0x7HUZTdzAmy?=
 =?us-ascii?Q?TDitFtFiXrV3zU+1iT3XI7/pcBhu6xFTE6MU5XWdZ0Gk/TsYnhtxmKkgMcCH?=
 =?us-ascii?Q?mv286ICBaSx6IMfRpUA7oi7Egi6VOJNenZRJuxypRSaOL6yausUmUO6uoJUe?=
 =?us-ascii?Q?5WLz6GRroAQ0FQwXHpPT+ZFVAzaCRsqzLiDgY4xyABa7F7GO7bYAeEYvLv22?=
 =?us-ascii?Q?o6gi4vqOyLjlk82dtUDJRzq7mPj0QR1NOaLu0l+qFluxPO+tFL3U8z+2pw0R?=
 =?us-ascii?Q?jHIkzu5xIepmV2BYVgQQ+3NrosnS1f0AGs2TVT3Djg0yIBhdOKcB0iVboLgb?=
 =?us-ascii?Q?5H3AT97Yr/377YhmieN2cCB/smobuVEPD/0a7DnyrxkRuwjJ0vf7d3d+ai5I?=
 =?us-ascii?Q?z+W3E/B2vknNXxZxNrbVYAyeT8Mf0/c1dldmYD1NAv06RwWxn1h4l1YazEga?=
 =?us-ascii?Q?VaTZ5etZHX/97XZi6kT8ABSdYCD6ZU0B6nmty8a7iEuNZBwgYt23ozQEojB0?=
 =?us-ascii?Q?6akwYt4MJjW+oaGriobZzdr61hgvXAoFWmTgsIwKmGupFQNtccdkoG2YxQ9N?=
 =?us-ascii?Q?uu7N4ze9PNP6jkT35nkL++KPdvBWFaeojktqp6VHTdfsUJVLM4rgublekXKG?=
 =?us-ascii?Q?0Tob27QSWUTSFQxUQ9O4EKnVI1KW0eBpgbnlG4+2tRrGMvAVoalntPvfJT7p?=
 =?us-ascii?Q?KiSrmTwtENPPxGcsP4ku2CwjLYMyAGWsasVywOP1tQlg6QxQvDOYoP21Dh7A?=
 =?us-ascii?Q?5LQI36FPz34Ba1JEkwN7aFUfQEBkvZ0AERhtI97tonwTEYfkmz7gX/oL6d33?=
 =?us-ascii?Q?kg1+Pbz6bLHlNO+7p1swA9rfR9kiCnLwvkk4FIei1hLPruwqrRntQM1/Nwv8?=
 =?us-ascii?Q?MbNI4iZpcLhLauaDIzLK8MMPuUEr+4EwnF8Gi9ozsT56JuA3mDrdL1voyDx8?=
 =?us-ascii?Q?qqeS6l6Kr1DsJkQvhV+vAEb0OgsDHsNIZS0kk1ZnydJTx3Iq04J9HcL9tRXV?=
 =?us-ascii?Q?sgjmLNKk0c3AqK4EjyyObD5fQEp2Iu7dp7t+KTHXVmU6XwynO5VsAur7ismv?=
 =?us-ascii?Q?ghXsAdGyNvumGsl6CJKA0BE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fafae2d1-de49-4835-cc63-08d9f0a4f452
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:02:31.5724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NxnlOcD36lTAi6QvrdVsh99ayg6x9ODOix7/9BGdk1qquavBotOEB9B9LO6okIiOjlJjOSZuzCXTPMPxtXyEfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The major user of replayed switchdev objects is DSA, and so far it
hasn't needed information about anything other than bridge port VLANs,
so this is all that br_switchdev_vlan_replay() knows to handle.

DSA has managed to get by through replicating every VLAN addition on a
user port such that the same VLAN is also added on all DSA and CPU
ports, but there is a corner case where this does not work.

The mv88e6xxx DSA driver currently prints this error message as soon as
the first port of a switch joins a bridge:

mv88e6085 0x0000000008b96000:00: port 0 failed to add a6:ef:77:c8:5f:3d vid 1 to fdb: -95

where a6:ef:77:c8:5f:3d vid 1 is a local FDB entry corresponding to the
bridge MAC address in the default_pvid.

The -EOPNOTSUPP is returned by mv88e6xxx_port_db_load_purge() because it
tries to map VID 1 to a FID (the ATU is indexed by FID not VID), but
fails to do so. This is because ->port_fdb_add() is called before
->port_vlan_add() for VID 1.

The abridged timeline of the calls is:

br_add_if
-> netdev_master_upper_dev_link
   -> dsa_port_bridge_join
      -> switchdev_bridge_port_offload
         -> br_switchdev_vlan_replay (*)
         -> br_switchdev_fdb_replay
            -> mv88e6xxx_port_fdb_add
-> nbp_vlan_init
   -> nbp_vlan_add
      -> mv88e6xxx_port_vlan_add

and the issue is that at the time of (*), the bridge port isn't in VID 1
(nbp_vlan_init hasn't been called), therefore br_switchdev_vlan_replay()
won't have anything to replay, therefore VID 1 won't be in the VTU by
the time mv88e6xxx_port_fdb_add() is called.

This happens only when the first port of a switch joins. For further
ports, the initial mv88e6xxx_port_vlan_add() is sufficient for VID 1 to
be loaded in the VTU (which is switch-wide, not per port).

The problem is somewhat unique to mv88e6xxx by chance, because most
other drivers offload an FDB entry by VID, so FDBs and VLANs can be
added asynchronously with respect to each other, but addressing the
issue at the bridge layer makes sense, since what mv88e6xxx requires
isn't absurd.

To fix this problem, we need to recognize that it isn't the VLAN group
of the port that we're interested in, but the VLAN group of the bridge
itself (so it isn't a timing issue, but rather insufficient information
being passed from switchdev to drivers).

As mentioned, currently nbp_switchdev_sync_objs() only calls
br_switchdev_vlan_replay() for VLANs corresponding to the port, but the
VLANs corresponding to the bridge itself, for local termination, also
need to be replayed. In this case, VID 1 is not (yet) present in the
port's VLAN group but is present in the bridge's VLAN group.

So to fix this bug, DSA is now obligated to explicitly handle VLANs
pointing towards the bridge in order to "close this race" (which isn't
really a race). As Tobias Waldekranz notices, this also implies that it
must explicitly handle port VLANs on foreign interfaces, something that
worked implicitly before:
https://patchwork.kernel.org/project/netdevbpf/patch/20220209213044.2353153-6-vladimir.oltean@nxp.com/#24735260

So in the end, br_switchdev_vlan_replay() must replay all VLANs from all
VLAN groups: all the ports, and the bridge itself.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: patch is new, logically replaces the need for "net: bridge:
        switchdev: replay VLANs present on the bridge device itself"

 net/bridge/br_switchdev.c | 90 +++++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 41 deletions(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index b7c13f8cfce5..59fcabd08ef1 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -352,51 +352,19 @@ br_switchdev_vlan_replay_one(struct notifier_block *nb,
 	return notifier_to_errno(err);
 }
 
-static int br_switchdev_vlan_replay(struct net_device *br_dev,
-				    struct net_device *dev,
-				    const void *ctx, bool adding,
-				    struct notifier_block *nb,
-				    struct netlink_ext_ack *extack)
+static int br_switchdev_vlan_replay_group(struct notifier_block *nb,
+					  struct net_device *dev,
+					  struct net_bridge_vlan_group *vg,
+					  const void *ctx, unsigned long action,
+					  struct netlink_ext_ack *extack)
 {
-	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *v;
-	struct net_bridge_port *p;
-	struct net_bridge *br;
-	unsigned long action;
 	int err = 0;
 	u16 pvid;
 
-	ASSERT_RTNL();
-
-	if (!nb)
-		return 0;
-
-	if (!netif_is_bridge_master(br_dev))
-		return -EINVAL;
-
-	if (!netif_is_bridge_master(dev) && !netif_is_bridge_port(dev))
-		return -EINVAL;
-
-	if (netif_is_bridge_master(dev)) {
-		br = netdev_priv(dev);
-		vg = br_vlan_group(br);
-		p = NULL;
-	} else {
-		p = br_port_get_rtnl(dev);
-		if (WARN_ON(!p))
-			return -EINVAL;
-		vg = nbp_vlan_group(p);
-		br = p->br;
-	}
-
 	if (!vg)
 		return 0;
 
-	if (adding)
-		action = SWITCHDEV_PORT_OBJ_ADD;
-	else
-		action = SWITCHDEV_PORT_OBJ_DEL;
-
 	pvid = br_get_pvid(vg);
 
 	list_for_each_entry(v, &vg->vlan_list, vlist) {
@@ -416,7 +384,48 @@ static int br_switchdev_vlan_replay(struct net_device *br_dev,
 			return err;
 	}
 
-	return err;
+	return 0;
+}
+
+static int br_switchdev_vlan_replay(struct net_device *br_dev,
+				    const void *ctx, bool adding,
+				    struct notifier_block *nb,
+				    struct netlink_ext_ack *extack)
+{
+	struct net_bridge *br = netdev_priv(br_dev);
+	struct net_bridge_port *p;
+	unsigned long action;
+	int err;
+
+	ASSERT_RTNL();
+
+	if (!nb)
+		return 0;
+
+	if (!netif_is_bridge_master(br_dev))
+		return -EINVAL;
+
+	if (adding)
+		action = SWITCHDEV_PORT_OBJ_ADD;
+	else
+		action = SWITCHDEV_PORT_OBJ_DEL;
+
+	err = br_switchdev_vlan_replay_group(nb, br_dev, br_vlan_group(br),
+					     ctx, action, extack);
+	if (err)
+		return err;
+
+	list_for_each_entry(p, &br->port_list, list) {
+		struct net_device *dev = p->dev;
+
+		err = br_switchdev_vlan_replay_group(nb, dev,
+						     nbp_vlan_group(p),
+						     ctx, action, extack);
+		if (err)
+			return err;
+	}
+
+	return 0;
 }
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
@@ -682,8 +691,7 @@ static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
 	struct net_device *dev = p->dev;
 	int err;
 
-	err = br_switchdev_vlan_replay(br_dev, dev, ctx, true, blocking_nb,
-				       extack);
+	err = br_switchdev_vlan_replay(br_dev, ctx, true, blocking_nb, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -711,7 +719,7 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
 
 	br_switchdev_mdb_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
 
-	br_switchdev_vlan_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
+	br_switchdev_vlan_replay(br_dev, ctx, false, blocking_nb, NULL);
 }
 
 /* Let the bridge know that this port is offloaded, so that it can assign a
-- 
2.25.1

