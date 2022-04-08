Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AA54F9DF0
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239363AbiDHUHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239350AbiDHUHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:07:08 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B143504BB
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:05:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/8qX6VfOnBHxEq15aU4iAxlOKRALFIasKPJLNS8HWWzLaEtWWzruJ6XLnMHLRzHnKyjBh0JMSnRYZQrWreuMRhZriHqqDwZwYjEM9sWfNxGmqq7WAgvA4HlhvHgF0uph4UKx36fraeu5zR/tas8eN6dk8EWFTxP5eutTSHe5nBXoF33i+KvKjTw/M90EIgSHAvqqZAVWiY+Z1nzkXwhQf8ZJ1nkol0VUQLnAa0gI8pIZ3+41dtPVpYspUW2YMFVhTUI43fhEabCsio/7MNCHZlfFMcKlRX7ljcXDLVivSW0qTvlSmwpGlVcM981xSyF6VL5tofbt2/CJXDSpQ2hGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1DLMDrCvOn+xNTJg4HofzvnQprFK9EkV5l/OpxuH1Y=;
 b=DvKVuzO4eKU4CVhyUVClrFbWBQ0LUGVGADtGy9blrNjTwwK211yCDy2PrgXTg9ya62f/7TeudlWB1uVVVsCy6HF94CE7KeH4pckwK/N1gMKyxWPIW0Xi3PpP/dkcSAkDAVuOAkFwepCds4W/nVM7n17Bb0NFGdMv8O1HSedxowV2t60QsRAU3gJ1aK2uLSPiAE10oIa5VUxkXvMsCXYepoNVjxYvBohlbAuqY5rzMBtJeZLCHMFs/UioZ/iKIpIrG24ktud82+8u1bqRHdTfXoAISBiZCLACAig1UHFV/yTiqX9xEy2rvB4EYuUYHxEtLPMpTCoQ0Ng5gGjl8H8y8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1DLMDrCvOn+xNTJg4HofzvnQprFK9EkV5l/OpxuH1Y=;
 b=RWDYmAvPTJRGxI3qEpWgL1wtYSJMK4XuTL1eg1zFpRSTcY/uN3v7fT2DPuzl4CyXyH7BHgwFKso5HhnWajjml67YfTdz0/LNF9QpFTfYRdvZ4SIbSn3U1dODR7tQxaVB460irpkpZ8G+vXa+AOGGPMGcb1nXSxTNG4sCJWmMwlM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4275.eurprd04.prod.outlook.com (2603:10a6:208:58::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 20:05:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Fri, 8 Apr 2022
 20:05:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next 4/6] net: dsa: track whether bridges have foreign interfaces in them
Date:   Fri,  8 Apr 2022 23:03:35 +0300
Message-Id: <20220408200337.718067-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408200337.718067-1-vladimir.oltean@nxp.com>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02dc0c14-4b13-48d0-4da2-08da199b1019
X-MS-TrafficTypeDiagnostic: AM0PR04MB4275:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB427595C64E234FF0CE22E5D6E0E99@AM0PR04MB4275.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2aMupR1genfOkAWoShk7W2bMi5uHvVy8XOFeIqA4xlQthOqhsrbVlU9h5vL19tROQJj8N0VBY1Tej6hOMnzpH7/Zd2aBZHoYaegX39Vr+XH3GUWtcWO32JBR5XhhhQBZrQlCoTCFWgu6JOb1uzUZsDQFkB0qTEL2yZN4ZcNMWz/PzGY5l1O4Y7FvDEdM4lIw27q8p44gK7CbTLMHA3uGiWCzZXwdlpxAtWuvjnQQHpxYCATwuwZ+J4WW9Q+ZWLuAkAx4cB/G+5vhuCPu8VCupNFbFwuwKRISzrjLVM8ejsdVOJUBVdYoFWf0g/VTmYXmcfowUdprTkH/fvrKkwgZkw/wVdzD8WrFr35g2eWsUDPBMfxkNB+iZ0I4+kcKJhs/ydHfqmec/mri4zd10E8ERznOpcIilEqdsJbbbvjot5L26MBYQ/C5eUCjIrF0lOsDbHUMIwUYuXR5HdTl4ZJ1d/SuJrbURykLG06QqRsdzCKgfhZSYjauGQO1v8pOz/ZXqnl5QxsrigM8jc/llImjm5WauAnC6u/j2ZxpWnUJ66wKfjrmuUvj7tvRUyxxkkI1wWUM8iD9wB+PrYcE8DAFtw+40yypIqmd9KDnAK2WbBwgNk2wgSTArOD1++nC+WdXM4GHIw+noGab21Hntd3gRvJYKXrCOciYyjSnoN6alPD5qlVQ66BTxCeei0Ym1ISzbyiL5ey9zdZrpG6phztrYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(44832011)(54906003)(66476007)(66556008)(7416002)(6916009)(5660300002)(86362001)(6486002)(508600001)(4326008)(52116002)(38100700002)(6512007)(66946007)(6666004)(6506007)(26005)(38350700002)(186003)(36756003)(2906002)(1076003)(316002)(2616005)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mye0zLBdIZ1QyZumausKl9RE3c4Z2KwpR8y/IsLOhrs9za8WbvvnrWmb3/Dq?=
 =?us-ascii?Q?VpHwCtIjflGTl0rlXxD8PJFXqmNnPmODwIpX9BTYm/D+1XvVHDiJhcpv9LIY?=
 =?us-ascii?Q?oYO+bpFE0Q9D6ueB4NL1hrlQs8UR4yVyV8QIOOQUVukTnRbNrrPyEYXHjRcy?=
 =?us-ascii?Q?pqMPYpIf7u4qzbaGWwMh0yuCPkmUEHsxpasaGaUpUTy9s/IJx2R2I5ZrQpZ6?=
 =?us-ascii?Q?DudcQ393BndgvtkwceIjFsPro8Qi/4qYUYhHMWY2yWBO26q9uJpdr9uMWVe+?=
 =?us-ascii?Q?/wMcLugje7THKpnrHmHWYRsU68t1DrQlJ0GhdSepYuTkU0rPcP40dFgJ2Gfc?=
 =?us-ascii?Q?G7DqqIfNJ7GloGieiyGSD4Z/Q8D+jWGYWmegbnBoxenYMRoG8Lcr91TKPhqD?=
 =?us-ascii?Q?IkHOfYxgPeAaxwWu2GJoN6iw3XqZ44n2zOsND99qb0jvdntxsuYb59Z3UblE?=
 =?us-ascii?Q?doA8VXLxVhaX+iGNf2TL94J/VIiEnpjQO5VQsteeUH+R+4ftXAcoxwYc3Dmr?=
 =?us-ascii?Q?JZldg0afnkjqURZYxXCD8HOVhn7xM2dENV7fXJsMbEZ17nYzBUTG35VHzka7?=
 =?us-ascii?Q?NzmfsO/rvp4c4tNGlyHNEViNgkK+QE8MXsVhQ5lTNUcjxJP2i5tlLAgcc6jK?=
 =?us-ascii?Q?tw46K/wwO2Avrw59o6HmoouYLd8Irvlzt3pmmNj4pnJMQCnUIahfqIMI23Ax?=
 =?us-ascii?Q?jnCtgi9MaU32seM9p5dMveCG53M2ARsRteoxaDUgqQwIfyWi7C8cjs2LMw6e?=
 =?us-ascii?Q?44h1Mkqk8fjtpL2v4qA17vgkSH+RGa6JVdMxPgJwZpjVblK5tVSZ68Q3sYz+?=
 =?us-ascii?Q?KCmNM8yqH2KzGj4q5MiGfLS0WpHU566ErNB0hqkVtfV8J9TKjWPWWgyjQpCO?=
 =?us-ascii?Q?H4gkYyus1gNuI1q4JUEu7tdTf0CMQT0DHbZTXIf8auh4GzuPgQg2lo491TYC?=
 =?us-ascii?Q?vfm7lr3Uyu6pBMRd4sPXzFmOT7AccF2QQSgjoDgXJ/pTGkoP9hORwj6JP3KF?=
 =?us-ascii?Q?fRRloilJjN4dhwFilLGTDxqaKBX+ELed6EFVc5gjBxl5d95BF4CyTiZ7CoIB?=
 =?us-ascii?Q?3h3HCmpfcMPfdWSm3KK0lumXPqYgXgqqAkHuB8YO6gaIAJY7aT3xX/R22EKm?=
 =?us-ascii?Q?9boJmp6S+49RSEB1C3c1OkWjRSH47r0gRd+0G3r7F2hydxnXy99rz0MA/nNw?=
 =?us-ascii?Q?JMj1nJUKQo6pTqn/SE2bLd02buKR/Ep79pmXSkmzLJ8kVMNfOMBdJ+82eBMp?=
 =?us-ascii?Q?yUVHXh/pbUQatFYPO5hMHrJnlP1ooZvHWY0fXphyYjamNpXEhjwVXsFGgXOr?=
 =?us-ascii?Q?4WuwodWnJQDwRHygCdfgoV5sf1pji5yUJXxHeezClwR24yOgMr0Yk0OLu4nd?=
 =?us-ascii?Q?vKJBbVjTycNAfYzIjjBbf3eK4tz7U6ljmPYfncI5LznxScXA3NnYg/G5n/7t?=
 =?us-ascii?Q?MPhz2BD5y9Q8BQjoDnKHA3dBCDK5K0yR9iDSyrrY/g7OmOtrUkfIS8ScdNsB?=
 =?us-ascii?Q?/WPdX6JoJW/7rIuXZZYEqjuoccu8x35BlwWeUioYlDnwmcuFQX0DCPsZQ+Jl?=
 =?us-ascii?Q?aJI+yYW3SuuA7p85Thwv/t7yMqLy7JyXM8HnRvompMP1ydQQML8dLFDraMmJ?=
 =?us-ascii?Q?KDkgUWEFMpEUrQbb4NJeGdYoURAQKwzQLSDSzsD2XAx5djI6wiLIAJmX422D?=
 =?us-ascii?Q?3AWIbRvFERH2bpaVWLkKGUNE5v9KhgUpAfD0C/L1bKJwx25Bf/AZ++/8zgCh?=
 =?us-ascii?Q?vPzmcZQ5O9z6G13FDTffygwWm+6tjYY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02dc0c14-4b13-48d0-4da2-08da199b1019
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 20:05:00.9877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIUtPn7w5iv4HFWvRJ551FAR7z3tE83vubLDBavpqQhv9F1SyJPR50x/8VAjHpC/W1uIDtc9Y/HM/0Mk1jFq2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA switches send packets to the CPU for 2 reasons, either for local
termination or for software forwarding.

If the switch driver satisfies the requirements for IFF_UNICAST_FLT and
also offloads the bridge local FDB entries, then there is no reason to
send unknown traffic to the CPU for the purpose of local termination.

This leaves software forwarding as the sole concern, and a place where
certain optimizations can be made. In the case of a bridge where all
bridge ports are offloaded DSA interfaces, there isn't any need to do
software forwarding (and therefore, to enable host flooding).

We approximate the need for a DSA port to enable host flooding by managing
IFF_PROMISC, which ends up triggering dsa_port_manage_cpu_flood().
This isn't ideal, because IFF_PROMISC/dev->uc/dev->mc deal only with the
standalone address database of a port, and not with the bridging
database, but right now DSA doesn't have the poster-child hardware where
flooding is a per-FID setting rather than per-port. So in current
practice, there is no reason to make dsa_port_manage_cpu_flood() more
complex by looking at anything other than IFF_PROMISC.

To enable those optimizations, create a function called
dsa_bridge_foreign_dev_update() which updates a new boolean of struct
dsa_bridge called "have_foreign" whenever a DSA port joins/leaves a
bridge, or a LAG that is already in a bridge, or any other interface
joins/leaves a bridge in which a DSA port or LAG offloaded by a DSA port
exists.

Note that when dsa_port_bridge_create() is first called,
dsa_bridge_foreign_dev_update() is not called right away. It is called
slightly later (still under rtnl_mutex), leading to some DSA switch
callbacks (->port_bridge_join) being called with a potentially not
up-to-date "have_foreign" property. This can be changed if necessary,
I deem it as "not a problem" for now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |  3 +-
 net/dsa/dsa_priv.h |  1 +
 net/dsa/port.c     |  7 ++++
 net/dsa/slave.c    | 80 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f2352d82e37b..0ea45a4acc80 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -240,8 +240,9 @@ struct dsa_mall_tc_entry {
 struct dsa_bridge {
 	struct net_device *dev;
 	unsigned int num;
-	bool tx_fwd_offload;
 	refcount_t refcount;
+	u8 tx_fwd_offload:1;
+	u8 have_foreign:1;
 };
 
 struct dsa_port {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 5d3f4a67dce1..d610776ecd76 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -320,6 +320,7 @@ void dsa_slave_setup_tagger(struct net_device *slave);
 int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
 int dsa_slave_manage_vlan_filtering(struct net_device *dev,
 				    bool vlan_filtering);
+int dsa_bridge_foreign_dev_update(struct net_device *bridge_dev);
 
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index af9a815c2639..cbee564e1c22 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -656,8 +656,15 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 	if (err)
 		goto err_bridge_join;
 
+	err = dsa_bridge_foreign_dev_update(bridge_dev);
+	if (err)
+		goto err_foreign_update;
+
 	return 0;
 
+err_foreign_update:
+	dsa_port_pre_bridge_leave(dp, bridge_dev);
+	dsa_port_bridge_leave(dp, bridge_dev);
 err_bridge_join:
 	dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
 err_lag_join:
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f87109e7696d..1bc8d830fb46 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2595,6 +2595,18 @@ dsa_slave_lag_prechangeupper(struct net_device *dev,
 	return err;
 }
 
+static int dsa_bridge_changelower(struct net_device *dev,
+				  struct netdev_notifier_changeupper_info *info)
+{
+	int err;
+
+	if (!netif_is_bridge_master(info->upper_dev))
+		return NOTIFY_DONE;
+
+	err = dsa_bridge_foreign_dev_update(info->upper_dev);
+	return notifier_from_errno(err);
+}
+
 static int
 dsa_prevent_bridging_8021q_upper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
@@ -2720,6 +2732,10 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (notifier_to_errno(err))
 			return err;
 
+		err = dsa_bridge_changelower(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
+
 		break;
 	}
 	case NETDEV_CHANGELOWERSTATE: {
@@ -2874,6 +2890,70 @@ static bool dsa_foreign_dev_check(const struct net_device *dev,
 	return true;
 }
 
+/* We need to keep flooding towards the CPU enabled as long as software
+ * forwarding is required.
+ */
+static void dsa_bridge_host_flood_change(struct dsa_bridge *bridge,
+					 bool have_foreign)
+{
+	bool host_flood_was_enabled = bridge->have_foreign;
+	bool host_flood_enabled = have_foreign;
+	int inc = host_flood_enabled ? 1 : -1;
+	struct net_device *brport_dev;
+	struct dsa_switch_tree *dst;
+	struct dsa_port *dp;
+
+	if (host_flood_was_enabled == host_flood_enabled)
+		goto out;
+
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		dsa_tree_for_each_user_port(dp, dst) {
+			if (dsa_port_offloads_bridge(dp, bridge)) {
+				brport_dev = dsa_port_to_bridge_port(dp);
+				dev_set_promiscuity(brport_dev, inc);
+			}
+		}
+	}
+
+out:
+	bridge->have_foreign = have_foreign;
+}
+
+int dsa_bridge_foreign_dev_update(struct net_device *bridge_dev)
+{
+	struct net_device *first_slave, *lower;
+	struct dsa_bridge *bridge = NULL;
+	struct dsa_switch_tree *dst;
+	bool have_foreign = false;
+	struct list_head *iter;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		dsa_tree_for_each_user_port(dp, dst) {
+			if (dsa_port_offloads_bridge_dev(dp, bridge_dev)) {
+				bridge = dp->bridge;
+				first_slave = dp->slave;
+				break;
+			}
+		}
+	}
+
+	/* Bridge with no DSA interface in it */
+	if (!bridge)
+		return 0;
+
+	netdev_for_each_lower_dev(bridge_dev, lower, iter) {
+		if (dsa_foreign_dev_check(first_slave, lower)) {
+			have_foreign = true;
+			break;
+		}
+	}
+
+	dsa_bridge_host_flood_change(bridge, have_foreign);
+
+	return 0;
+}
+
 static int dsa_slave_fdb_event(struct net_device *dev,
 			       struct net_device *orig_dev,
 			       unsigned long event, const void *ctx,
-- 
2.25.1

