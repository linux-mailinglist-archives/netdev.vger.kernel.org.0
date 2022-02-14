Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34384B5E4E
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiBNXc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:32:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiBNXcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:32:19 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20028109A6A
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:32:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIWitI/Fur9vPRqQYSK7QYuHo0AVJAp+dUitdGDEfhKbxecwa6zhzemfYz8iUmB+2E7B/bO0Jb51ImIDdPGi5lqeAlY026hJPaTwiHEs+pWMFVGaCTvq3d7J5tH5aKU4CxWL0nI679z5TbVzh8gD9h+XM4JlRdcbVg5jNTvoiX6qGL+4jwl6BQXhYugJ3YD4I/p96eOD5Rmd7Avs7XBiVLqMaWGa26Y+sHgBSAQ2sRjObmxm116IXzoukhQMDL0Q1YkFLLWVYjxFHeXLgtQmDmpHyOZv79/1Chk7J57zCxfO4bWLaFlXMLMoOUmvhJQpbFkseCmfPqRJfjyWezSC4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RgDwrAcTW7mvTKGeOx3pVORn1o9G4K00k7nOvKJIf8c=;
 b=nlz2P7Al/h5Nb7hUvvzIk0/ug4BRbe5A+78iYLgHCmVLHa+FxU2C8c7qC321oqeow+qI+bKbLBiNjExahdVVksuhQqZEaIdCbDqOZ9BSnt+0AisOBZRFTTRlfAVhIDCesVCvW+uwfaWf5YJF15+yiyqzYpN5EUXE9luME2azE/nbJgdaoGssQVGaHEjXZh0KCl0dm6OlTWlWARsRRcUrBcF5vWHYQPecJ3yDwbQ62E0IRc0kwSYqsfvXF7jPPfDgw/Tt/ndekZhWR36QZbHaVDuHmtneISVx2gyIdUFkNh4O0hG+WDWvdVNLLfmsA1AKjsV35kkULoQfM1uyQCDKJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgDwrAcTW7mvTKGeOx3pVORn1o9G4K00k7nOvKJIf8c=;
 b=GFGNnfWdz5wSL7EV7KlX0J1FcEcVyZV1Om6DYJqcoc70mvzzZ8qU3bK/+gxTieW0VktcZEEP7zQgD0afw2Ze5DeLDTdE7+9ISLzdTF7g5QqJ4R0PdAUzltKHXuGsiFd92oOA9G8B9ILFYxwK9bdLCED9iJzit2/GXQ3dKL+nxt8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 23:32:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 23:32:08 +0000
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
Subject: [PATCH v2 net-next 4/8] net: bridge: switchdev: replay all VLAN groups
Date:   Tue, 15 Feb 2022 01:31:07 +0200
Message-Id: <20220214233111.1586715-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0377.eurprd06.prod.outlook.com
 (2603:10a6:20b:460::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c9ebea8-ef54-439b-5365-08d9f012375f
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB55049E3144D5B7C226285721E0339@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hMgy51/9FvF//1PKXo2o8AbS8/DefLh6nJbThEV7HhqxN57CtSOdhBxgGz88pgri/+8rX8PGJgmkqE17rKx6VZnHq/B3eRN9107LQ8dyXCjkd09BHKQXepSIZLQ8bcPAExxO9ImT/T/M4FXdvsvGFSLqiBf/g0IGnORIqWqHRtxoILtjXTwAfqOhr+/cNK7aWeOFla1H0u9RcA7Yut9i/EsthMlVpZLWABTwuKz1F/P5tEE4z9c1INcI73oTaxTaZ5NAEsE9s4OEAUzin7+RygCZ6958hCDyPf8A6TE+J8C7UvwRi81ie4ulbKRdvRL5ZBH7AZ+M1dJyzTwrh4hgQNPx/5AV1rDR/I6lW6T2fC9RWFEOeL8x8sGGJuhlVsmiRvpp1W+movQnTIEda4ZH+RE9iFUnRwx4feywlRorgvjGXhBhbHk9ImhQfKjRXNWl+JJQ+FOq5G0nEaIzlK1IE0DTwWfcaskvrq928ylw8/CIwYc9/mdlvFqqAEYa9Ivy2XqzaTkui0kRH57jg/NwkUCL17cOKeUHyBjKIQd933y3M5FEGEbE5UOmvaxs7wA+l4tLq2abTpGOEQ96xNw83w5y1s4z4iQDQ4Ku7iftBWpJJ2ACXIVzxQ38BuGaCTzK5VcN3+Y1qQU6nX8Gh5GJynIhuQaHp8ZjuidfO5mSaBsuz/NEpaPIHZTWy90ju57dVtIF2zV9zlSgql21OFpzIj4PPjca04zsFm1q/1h4fq1m6hTCrTq5uo/QJGJ1P519TUl7wYut4l7olnCR8ab/8D/d3pGut9or2bXDWfaaIGY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(5660300002)(66556008)(6512007)(2616005)(54906003)(508600001)(6506007)(52116002)(966005)(6486002)(8676002)(6916009)(2906002)(4326008)(44832011)(36756003)(83380400001)(316002)(26005)(186003)(1076003)(66476007)(86362001)(38350700002)(38100700002)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YKM/kAVc6Rm/7tDS0UAdu6deVjCBnkNl2pa3EloOGjFFmpJcwdE9BWURZZna?=
 =?us-ascii?Q?UCmwO2Lc4icn7A7TfjnvKExuiSO6jRPd/bP7Xyd8nUExuAij+A+t3aj/CdXx?=
 =?us-ascii?Q?BumTdemXoYr4/YVCakeBHRCsau59GGJzqiaN2iXTpNO7vnEC5Q3/oXKCApFS?=
 =?us-ascii?Q?zlD65fgPlssE+Ww8ieigIAURz9QY88rKCLkmOq9737as9FVGq1QsjtoUDvvv?=
 =?us-ascii?Q?Mss5MPBEk2x6waU42bBOXRfonxbY7BRSmpqjqUn1gTGFVySvk5pPf5mUzSjh?=
 =?us-ascii?Q?r+Qm7YSeFOyFljc3w/NJjOznN4ywwHLgXhVMSYn4+NSKruRobBrEpnQstRoW?=
 =?us-ascii?Q?XZhWRV80eIdoUYeQjQf2N3xJ4CjytkFTAtFw/Mjc8yka/mw2M1l2UizVvpnS?=
 =?us-ascii?Q?HqE79C9iBV+utSdWeASc2EfUYsXX0exVRG9tbSG/tZryLes+zkoQ8QUHGCbl?=
 =?us-ascii?Q?b0iaMYXflh9wgEmCk8y27W2YOmKTxx339Nt3RXe2xzQr7iGPDxOiAD2ZuCRw?=
 =?us-ascii?Q?OPSySpeth633m2A9r7leliwFT5wWJyRCke8Z0JnNJUWWeaUtwi6pTrRjJsNT?=
 =?us-ascii?Q?mdPWKWswYTD47mBpTxY2Ih2FRxEHcQvN2ZGNStyiAFfK7W+cg9QXQIjYWALe?=
 =?us-ascii?Q?l/+L/MTmMtdCv2nVfboU2z8lozd6TvCtJzWzy2pV5Vh14Hl8NS4SoqAN201h?=
 =?us-ascii?Q?Hz7luhLvmWY5fW4g329N4CNQvQ6PaE2uMPEfrV8LHrpSY6tnIvmSZf0G3I9o?=
 =?us-ascii?Q?mzV65Uwk27EbDt7qx9n5l9CbPyw3UwJoKz0OGOKAoDhDa5KmJ7sFpgh/x5O4?=
 =?us-ascii?Q?1EvWXNVSfMlgc95bveEA111VzkosreoCA+tFZRKpV854HxHWOMLHTz8Bm4VK?=
 =?us-ascii?Q?oCparPdeTnI0Lir+wpHP9BFANDMqhfiMZQbHQIS//5qCKC+Cwf5WAk4C2MxB?=
 =?us-ascii?Q?ZzhQOStNcZ9mTOESO+N3FLfNXLRkpgwDN40Ros0Rhg6XThenhxyWuHxlIxbd?=
 =?us-ascii?Q?j3J9I4P2klZ7kiAdOluRKtrXdHO9T/s6hntWScy2WV8batpWkODl4TtnsFuC?=
 =?us-ascii?Q?mmzxXB9kqVLR3ISr9dfG6HoxYwoL7Ieh384yWZWbZVsU3QU2LisORYB0upip?=
 =?us-ascii?Q?4XimAQRV5HE5bNCjG8U8DfAn4RfYCOLD/OHXjk2au8JfIbwVbu4CnZ/T2R21?=
 =?us-ascii?Q?XpY6cyTLWJX7aChUrbNK2kRDQsNH7ShPfYn01mgJ/xvD1ANVSXq2PjaoV96W?=
 =?us-ascii?Q?329zoJw0aoOceqj5NzTO+XSbp98MAOXvl1ftvrJq9zjXYlWp0U4LO9SQ0QZV?=
 =?us-ascii?Q?eF6HPYSHQ7DkvGWLwauJ28H2FjYPRIv31eoSH6zmA+Ky70p5VcL1pzxj1uRj?=
 =?us-ascii?Q?0/nk64YghZR9pELZ6+3733qKF8TmfNWIVBYyHK2ZVn5FOfBM0HVlsZ+wVm65?=
 =?us-ascii?Q?/Rr2DQig+dsay2Nv3yTZk5fNjPjg3XsRxT2CXGoQSbkyE7zh22fZP2oNZ3N1?=
 =?us-ascii?Q?PMSeh/eUxvH/plpRHY4dltw7SJ9THMMwxqeL5/2tz9TQFaTCipSp/X1WO0K/?=
 =?us-ascii?Q?9jXQICQDUrROujSA9a8IkVhgN8/HQl3vJUFDKfC9e5oWPHcEAWtE/jMX/bAt?=
 =?us-ascii?Q?lqgMekWgi5PzhdKp5X6SmEI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c9ebea8-ef54-439b-5365-08d9f012375f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 23:32:07.9801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PiKnnRJ4X8BigzieIICWRkyj4d32Z+ohXLt5GM5ii4m0+qLCa1dErLYoaLZLZjIHuq4RfA0cN20kmTo4jCzJOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
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
v1->v2: patch is new, logically replaces the need for "net: bridge:
        switchdev: replay VLANs present on the bridge device itself"

 net/bridge/br_switchdev.c | 90 +++++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 41 deletions(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index a8e201e73a34..f4b3160127bc 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -354,51 +354,19 @@ br_switchdev_vlan_replay_one(struct notifier_block *nb,
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
@@ -418,7 +386,48 @@ static int br_switchdev_vlan_replay(struct net_device *br_dev,
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
@@ -684,8 +693,7 @@ static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
 	struct net_device *dev = p->dev;
 	int err;
 
-	err = br_switchdev_vlan_replay(br_dev, dev, ctx, true, blocking_nb,
-				       extack);
+	err = br_switchdev_vlan_replay(br_dev, ctx, true, blocking_nb, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -713,7 +721,7 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
 
 	br_switchdev_mdb_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
 
-	br_switchdev_vlan_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
+	br_switchdev_vlan_replay(br_dev, ctx, false, blocking_nb, NULL);
 }
 
 /* Let the bridge know that this port is offloaded, so that it can assign a
-- 
2.25.1

