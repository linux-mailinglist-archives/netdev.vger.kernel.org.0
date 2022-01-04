Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF864846C6
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbiADROy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:14:54 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235164AbiADROk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWXYHbvdRQV/wBgQvGkLREAJE/TF1Au4dfVYYbF+JjD4244mPrt3Vsv5XBr72z9es1qRBhM0TOruHTmahDqVz0tDIjMMaSXFjIXgEvUWqGV/Kpeen0d1LyRUmnW/MYFOT3HwUgfhHR1fE0MFcnwH8hrJtXeONvRVZJbPD2S/DlfSV379yLpxM9qgQ7lROqqkYT/Mi2wXqhFrRcOUT57FPs4s5dZfTH3cC7LrDz48FSpN54gMkKxXq0utFVXgG9IgGR8tnKlTKGohfhkYLeROpqGeGwNekznl2JXgifWKza5VveOdwkPUje8ljNAI1iwF9XjqxWrEWrfUMeW0U4RxiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xb1zDDpFMRhp132ds2IcotRd3mPrhUId3l/T8ApLK0s=;
 b=YUxxmGARQ/Zxn3t4493RLdVlHiQNM6OSFgcKd/rckb2KIlmxGnIfEGX3Kj+Nylx+u/q85azcMz4gYC9L/pjfgDL0Z8+/J95mV3DcDuX5IG0piZy5Lx0XDIL4EIJsGxTvTylBAckoretNDFhGh9gkCjarGKsF7yjhIWOQxYUupvsOr1Isylj3wIGZ8MERE/JrZ1mJCQ6EMGhLN28Qbg6YEnbo/e+CRQ2HDb8+2Z23DsAzXiPE56Ssz3Bs2IMcmjp6MMwDvc1UFGUr+1bDmA4MJQBv+TsypKKTW8ZmTqp9u5yHruTNCDwKzj5nzC8PeIFFyvqi8Bg3znNuagFG5CeOfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xb1zDDpFMRhp132ds2IcotRd3mPrhUId3l/T8ApLK0s=;
 b=KqAbWlJ9/4IFKf1r0nFGuKtx8IOJZ7biDNOt9YSbOJRt7JiE0awmAmPpfLfV2JKLDeFPtcqakxbrmGBhi64E4U7O7zX78Z+129df2Av9lzXxfYD8Ao+2Km8RJuYP+3uGoZcNGnlCv7GGhPS7VciwRhCP0R9OUtVBqCeVftuvEFc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 06/15] net: dsa: setup master before ports
Date:   Tue,  4 Jan 2022 19:14:04 +0200
Message-Id: <20220104171413.2293847-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
References: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0192.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3b33c43-fc74-4969-859e-08d9cfa5aeaa
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB71048E8A5338478B49140E48E04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d+k+u4h1GZIGSyTP4AEN5CLsYZIBHJK4V3FKkUSr6pmFaHNqXiknmu/2ljC9Kg5XfS8IhRpIUmb3jJaagYxKMyPVOB8IBASE+OOYQ8IZIhPc6PLM2HcmW9vHZ3AWQX1Mk9de5LGeqfZ4oECL7KNFS+EQwenyqGnBb4PmknovHITTYnzKbNm1czF1LYQSVObDnnWolPY7lLLQlr/MYBsm6pJWiID27LnQhk1bMzr6t5QxO2N5fAHAhLdHSkKWKNkYmBaNADPsBY9KbljTSoPTbjtSGAz9kI5K96VEeNPqcjDyBYGHrlQ/rt/0cu8kWPjs4vf3UzUxvaIi8yQ7YVbM/w4CAmy0vuLziuFtQOLb7WnIPTrusRnZOlRxKz7/OntsCDgTzeFSrVoceUCERtb6KrqOPPwWLCz06IleZNG24yvJl2YHaqXTJDHpuq3bE/97WBIdyz1ykKw48HnmnP6PFXx4s0Y1aXhY2OeqHekdVltcv7S3+ggtT6JGj2EgOmP2nituhJODM7M+q4ufyeh4ze25+3hFwUo4lpTn/DP9VN5Dg5cUsH9Rt1CUmcKUHqRAhVGlavpQvzCFZJazpE2+LgU5daE1RYtaNqui7v0bRe7xeXQGaGkbxfjihHQTj45ZtAEa4n7WMctm/EO58bx0JmP3xp2qM/9d8ClREosvZEpa9kCk7ddg2+SVzlQ3Q/qqdWDdigzf8/0OtCGVaxpvpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h7JRWaxiLt+NcWiOFr/aZoJ5LIRxWBWcQ05FcRxnfo/HsWQ6lYFd2mFHPqwM?=
 =?us-ascii?Q?F4Zz/FoqWMc2i0DqYrXb7RBNibBbEo4mJLfIHxj9mriVF6PONr3vyTHpPlwp?=
 =?us-ascii?Q?bcKy/lFKgtpsJXOzkDroOK0m6939Gnq02fqpMDCKVaRk9phLbzcE0yzmbihJ?=
 =?us-ascii?Q?GF2mbePmZyaDYFxNgBl29v3uRJHe3vtvXTT498r0iZfwH6AgT7lcmuDckErG?=
 =?us-ascii?Q?wie1VitDJDWAPCYKXmPlttqrqDGnAhfeqZFWzeGSGrJsAumhshwzBJk4LqOL?=
 =?us-ascii?Q?BUxVric6AIs2IVRXIcIR87/vOqR03/MET4E6APWtifLcbYgi8B67U00HBT2W?=
 =?us-ascii?Q?cJBRc5dJbhY/I/Z++6AnxlWvGbWzIpPgC5jsC8Jjsn9d4FuDL3Z3N98poXKc?=
 =?us-ascii?Q?kbGJXe4qbdolzcVvEd0ZeEPdQdOfVDD0ZuR5WgiMYXssGtJ4gY49xKbtx42E?=
 =?us-ascii?Q?JJrsWeeq14NLrcoq+e4QZXoX5+fuRSINe28zSuJS96QlQOT2HJ/02ykz/vKE?=
 =?us-ascii?Q?Ym6AFjHaVoNIaViVK6Vw2V+16veO5CVS6wsEqOvHM3QvoIN6bCyBH2lej3+M?=
 =?us-ascii?Q?PnQhyKSyMb/PP1YVUdA7n/ajaqj19ad98mSTJf71BXAMoiq7KrKVCl0o6doI?=
 =?us-ascii?Q?mpUQCdGn1ezUhFf8k14TImK+PS8MmWi2UXQfTNDyjZfskwj0Ze5smv94d0cR?=
 =?us-ascii?Q?rtudlLtfmywhhESZIggk+OJkf6WPZVAIBe9Slx7QuiiLcBhYYTGshpelb06d?=
 =?us-ascii?Q?YY6KNB34U2OCc/00AqWrq1KYzPd9l0dSaSU4Eb3zDSzzxKpFZebbquBfmmMt?=
 =?us-ascii?Q?dOlsKEDqKEogU3Kig3KCiSy0+RL8/K1R6yLjvt0C1ZvHLScAVJqxSxwtuUlT?=
 =?us-ascii?Q?a92ulHmI31QZmqw7LvL45H2PGuvolQrXIzKIEYxmb1l+uil78vdjwTJbZyJh?=
 =?us-ascii?Q?xkVZLkZIN07tNgwgW2GByWmSguZxEIrI6G/nzX3wi1/rrUi0fwRes9aQ9fLa?=
 =?us-ascii?Q?iTV6J2BR5UiMpzVuqBLzlpKj+0P4whmp3Yq5uzFfm+7YPgbUisae5klmkrQd?=
 =?us-ascii?Q?0afHmYR4OjqS7T2FZ+yfxDvfPTvkgbTStea3JjrUiZQVbU5/Wqxka57QJ5DD?=
 =?us-ascii?Q?ka6kKU6Mllsjd0MY1UZN6sLjYInzVudHez/jju2E6+EGqYVER1FYM0z1Wp+p?=
 =?us-ascii?Q?CpR9xTdx8mXy7u/mkdOTxxOdCTLk3dljQTp/05uDo1qqfyqBwX/ps6Aa8QIb?=
 =?us-ascii?Q?ZHYrH8eK+DKEOPVtAf6wM+fPCiOl09Tyjz+FYxh2GQsZofRYXgn6Z5kr7HNu?=
 =?us-ascii?Q?Du+GVczmf2FhrPq0T0OPHANZMnrz/ALp98QSu3d5ILbO789Mi1yoM1iA60pG?=
 =?us-ascii?Q?6SPHtVEGuvZ/7QL/rI/QLyxaSpmMbDeAEcj/6JorJAId9WMjCdGx2oGC1TaS?=
 =?us-ascii?Q?9nebLwhxMs6jhwxR3uruEwfsYOU3tsO5Tjc5ROPtkc/QgNaX9I8IlX0XAqCq?=
 =?us-ascii?Q?Y/YQeKthEEpqgh0nITu7vhNlgNOEsmmoUu7DRNBeXHJzFCrfgiypsWGIyxAs?=
 =?us-ascii?Q?oMc5jXaTWuMKtCqfOsD483uYurNlD5SRRkoih05uZOD9EakeOPwHnKTDan3X?=
 =?us-ascii?Q?puiviOa/rTPDnPDtw3pI6gA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b33c43-fc74-4969-859e-08d9cfa5aeaa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:35.8162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SdKHFgNqi5AWKCG8LvTpB1XcB28R/m5hWkdN8pvZ8Nnh4Db4GT/QVah/Bf3nHNDoymuXN/J7mCzwGVn/0XPTMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is said that as soon as a network interface is registered, all its
resources should have already been prepared, so that it is available for
sending and receiving traffic. One of the resources needed by a DSA
slave interface is the master.

dsa_tree_setup
-> dsa_tree_setup_ports
   -> dsa_port_setup
      -> dsa_slave_create
         -> register_netdevice
-> dsa_tree_setup_master
   -> dsa_master_setup
      -> sets up master->dsa_ptr, which enables reception

Therefore, there is a short period of time after register_netdevice()
during which the master isn't prepared to pass traffic to the DSA layer
(master->dsa_ptr is checked by eth_type_trans). Same thing during
unregistration, there is a time frame in which packets might be missed.

Note that this change opens us to another race: dsa_master_find_slave()
will get invoked potentially earlier than the slave creation, and later
than the slave deletion. Since dp->slave starts off as a NULL pointer,
the earlier calls aren't a problem, but the later calls are. To avoid
use-after-free, we should zeroize dp->slave before calling
dsa_slave_destroy().

In practice I cannot really test real life improvements brought by this
change, since in my systems, netdevice creation races with PHY autoneg
which takes a few seconds to complete, and that masks quite a few races.
Effects might be noticeable in a setup with fixed links all the way to
an external system.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 1ca78d83fa39..c1da813786a4 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -561,6 +561,7 @@ static void dsa_port_teardown(struct dsa_port *dp)
 	struct devlink_port *dlp = &dp->devlink_port;
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a, *tmp;
+	struct net_device *slave;
 
 	if (!dp->setup)
 		return;
@@ -582,9 +583,11 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		dsa_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_USER:
-		if (dp->slave) {
-			dsa_slave_destroy(dp->slave);
+		slave = dp->slave;
+
+		if (slave) {
 			dp->slave = NULL;
+			dsa_slave_destroy(slave);
 		}
 		break;
 	}
@@ -1134,17 +1137,17 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	if (err)
 		goto teardown_cpu_ports;
 
-	err = dsa_tree_setup_ports(dst);
+	err = dsa_tree_setup_master(dst);
 	if (err)
 		goto teardown_switches;
 
-	err = dsa_tree_setup_master(dst);
+	err = dsa_tree_setup_ports(dst);
 	if (err)
-		goto teardown_ports;
+		goto teardown_master;
 
 	err = dsa_tree_setup_lags(dst);
 	if (err)
-		goto teardown_master;
+		goto teardown_ports;
 
 	dst->setup = true;
 
@@ -1152,10 +1155,10 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 
 	return 0;
 
-teardown_master:
-	dsa_tree_teardown_master(dst);
 teardown_ports:
 	dsa_tree_teardown_ports(dst);
+teardown_master:
+	dsa_tree_teardown_master(dst);
 teardown_switches:
 	dsa_tree_teardown_switches(dst);
 teardown_cpu_ports:
@@ -1173,10 +1176,10 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 
 	dsa_tree_teardown_lags(dst);
 
-	dsa_tree_teardown_master(dst);
-
 	dsa_tree_teardown_ports(dst);
 
+	dsa_tree_teardown_master(dst);
+
 	dsa_tree_teardown_switches(dst);
 
 	dsa_tree_teardown_cpu_ports(dst);
-- 
2.25.1

