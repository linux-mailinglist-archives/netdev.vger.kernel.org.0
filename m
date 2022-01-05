Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DC1485C2A
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 00:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245344AbiAEXLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 18:11:47 -0500
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:32794
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245328AbiAEXLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 18:11:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSgjr0SE6kG2D9Tsw/DEMX1FEzX3VvoifzDvy4uB7sq2TGEvw9svGJ8vRAZ6GAg1Y6vtrxTSWdr+l3/lt7L+SQdg4B0OsvyvEG0is+KVZC1HnCo79jRVft7N6QLfEpGf7zK+zjsS/5kLtepXmqIfouRWCBLmp/ADrcFmFhLltl8RhOW8qqABxGFFx7MsHTeAUEUYrT2j4grY2UHgaI2xOBSekJxODwg1J6//oggutyl0TGUCDG+PDYwjrbWKUZ3gUB/PBsKO/uLPFTlsmqVMbSHMsHjKTNv+OuousSCQ39JlaODEnAYHlSSXNXQmvY1afhCOrOBwPIpPmQ93NCsdrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ff/gympwX/tGVXjXNAxcGVVfpkaP7KstavuzW5YfPMs=;
 b=JLdELHcMAk880YIgCtp+FVvxFsrzgdQn+I/HeuZ7i212veHGed89qNYjLVuhEGXj3Wz2VgW3z5NjP2IVXYxjIaR18PNquNSOJFty+nmFKZVtLJFDZCNEntvm5QGDdU6mhWtgptt+xNtryR0hwhl7TE5MYCK0jTZGoaAqyhWsgYFVZMsK0g6VENe/PlOam9lkpYMF1twu6vg9NNIZubu0sCeV/C3Nnw78vPidZ1gcdlVs8w9OoRZfCuWWmSE2fvJFQyFylu4k12SMtWq9IsghubSKDLwRfgCO5AYTYb9bZeEaGRxx9nwzHSOjOQubeY+8rlAQAys1Bb+ZHS0lRDtsnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ff/gympwX/tGVXjXNAxcGVVfpkaP7KstavuzW5YfPMs=;
 b=gkTfpfgKRluVAdadDOB/RTPJz/XDkF3/wxKCE3xiOpyvRpqvmKdgPbiBcI23OxEM9vp+pzW59PtXiPaqrvVwTUvK0wS3tAWz0aB9wT52xwjB2TTbzaEORpEpTyvf4eY1mm261PB3KsOOsnPXhFhNYdDVecd3u/sy2/3ZMHS1ljQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3069.eurprd04.prod.outlook.com (2603:10a6:802:9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 23:11:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 23:11:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 6/6] net: dsa: setup master before ports
Date:   Thu,  6 Jan 2022 01:11:17 +0200
Message-Id: <20220105231117.3219039-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
References: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P191CA0081.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5cab5ad-f569-4050-cd99-08d9d0a0b800
X-MS-TrafficTypeDiagnostic: VI1PR04MB3069:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB3069D90E4E983ED61F991318E04B9@VI1PR04MB3069.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V8WQNOWhVr4gdN5Yaw5Gx5lhCQGGB3G7V18IW/z9rCwYENn/1/NArzcquU9xigm4n0SljKau+bdPxn0MQFUykWrEbQR5aJr6AOpOM3tKhLLamYL0ugsATI5EXUTbNtGP1DlkI+FlQGHuCHtAE5nCouRxK60DcfXbsms0Gbf+HK07tXlOu3uNr7kgLZpMeJuU1huAp6MZyKdz8x9qieBgBfW/fPOSFZ6XpRcZa/8MkALwJo3IsNQNvOwPghHYa8PqUsxfksD9kd7GVXBz3zJ+o/L11h/fH1Ksjk8T+G+LQatFdXM4g/Yv/0MVI7RlUqWVIv5zzOzXpbzGQPJI41UsNKaU8f5s8pMvOgCDTe9rytqYjS1iGNPA9R1aX+8A+V1tHUVSP7wKSoJ2zQOh0ksnMRbYSfNTMwSMM2YJRdjZy2vw+XrVP1p4j0c6QheCckP7rFHs0nIUFK53XmF7wb7ReL2TjGD8Sj1DkcICypVSryZplnv+6cvYr40tWplqDyjQLUpLMLH+qoJhIvwqO9VX7VCjqZ1jmlkBDkG4Ftm5gfLJZIvLD6bHRk4+J4QSXXk/ICspR6MGKpapgE7nofA9YS8KTuTygbhbRIeLX+AYi/mtIwzQL9fKLA+SeZyiiToIWavtUoBQqIvf4GVCUExo7vTSn57TC8sNmVc1sh3pjls17ncrt8bqAI0H+XZkEXZ8VkxHKZvBZ+N1QbKXw0JOWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(66476007)(66556008)(66946007)(36756003)(1076003)(38350700002)(38100700002)(54906003)(508600001)(6486002)(6916009)(8676002)(4326008)(6512007)(316002)(2616005)(2906002)(6666004)(44832011)(6506007)(52116002)(8936002)(26005)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fN09vW5pdb60139gRnA599jjVssY7ybwK2/YQ3RcTmR4J0oUZF8Vdmhphakd?=
 =?us-ascii?Q?gh2CF3sq/MKcYf6WXnkHFffK2dw7WN7gKAN8V1ZKWypI0b0cOA8Fx4yL8jFN?=
 =?us-ascii?Q?JbPg/RmDAqSHNnZFE/oq9nV+LN0oB+OFAJhrmTOIvUrFoiurxtLGH2UpCEZd?=
 =?us-ascii?Q?gC/7avdKD8Y3CGYDwa+d4gU2RYHVZmRL/iBRNiE2Dl0mjPTWvbDLTgCmldpl?=
 =?us-ascii?Q?T/ZHcdoGLrD71ItkysJ2GZnYb8HwyM/REysWILeRqwPHRpRQryq9NVQsUrjx?=
 =?us-ascii?Q?qs9Wf0qai3D8It3Av+G4X6gwz+1W9SkeOHKHNSPrFRDL0ikQ60vKH78oTRC8?=
 =?us-ascii?Q?0/wKB+a/7IH4b+BLL/d1sg/bfMw/IjsEB9fdCeD5MIyfgFDHD/5UbC2Ce4CN?=
 =?us-ascii?Q?Q4g81O3VL7DZhyR5U7cNlGqAYa22sBsrydHbETO+2iVta89K7lvprl6+SYpe?=
 =?us-ascii?Q?zy0BR3HW11eVnyS0gXx6WFMiDD0rkhYHaArXveYwpG0jrvAgy7WI4C1DG0EX?=
 =?us-ascii?Q?MNyny4o1hcVVhYVo497+sALbiPjAPeeJx1XKMoEIgoV3AuB7PYUlOpaVKHEI?=
 =?us-ascii?Q?vaAJdW2KChO717YMC6aeJH3n7pMKf0NyN5lUiTQJJPrEBw0RYctBnOXhPlh3?=
 =?us-ascii?Q?sev8iIPzeSg0ikjTkle3RBQU0bioY3Fx3DL1vc/D7YQ5czjs/UFy5HSV4tWr?=
 =?us-ascii?Q?T9b7Ztq3LOfZJsQ5fEHmzEJHrSRentjyoRI3llVz2nHQQ3JY8F2e5hbbenUU?=
 =?us-ascii?Q?WoVDZ6HjHDwEWRhmoLmsmr9Eraf/IQbz2cbxBRAy96zrVHBH7x8YswqJiAYZ?=
 =?us-ascii?Q?asvgK/Lnv6Xyk8BMzYzI0MkiIjzn9H3ZTyGp6gN2CoygXhwZHMlc0/GAc13I?=
 =?us-ascii?Q?nWftHBRrhDubiPgRAC0MpXsXMSR/lUGiobKaxEKRN7kgzPrNsMFe7oelykxG?=
 =?us-ascii?Q?24l3GX8LDFEz2V8wd2aPouNNLV03vSThwxNe8RylfqENCotxUUcmql5kCrMJ?=
 =?us-ascii?Q?glf+oBEphAzM4Uio00h45G0X1IPrGcfL+8MnooZsmXyb7q+rys7ld7vuSjhS?=
 =?us-ascii?Q?d3aPL/dwC53y/eS1jDk/MpLjDHjPNfSH1ZZ2wfsac77n1BqKyD3D5JvmV39i?=
 =?us-ascii?Q?v3VcuQ8hl2HeY5vHmlWNo4NAHQ+Qhd25kQ5s7GOAYmyLItx5Mx1SWmSU1lak?=
 =?us-ascii?Q?5GKKhRKKrUnHeFs7K/at6hbuk+UwRTrC4iSAvG/K3H5IEtn2+oLXWQWCHU+j?=
 =?us-ascii?Q?EDQFypzhhnGczIac5h2hA5iAVAnNXHQ4Gg4chkpaTaa6qobqLgaoCUejoq1e?=
 =?us-ascii?Q?u94f+lmPVgAlhO5KpK/NNwx1++ah9d9ge5cIZUBdvmxkBObe0Egvf4jLLy2+?=
 =?us-ascii?Q?u3MbYWuN34Fxh4PSmIK3c9n8NQlqnm+igedIV4auyzP+XdLipd0LGiW+poYE?=
 =?us-ascii?Q?0NCqcGJ/KNZPs/mO+dfRL48wRxTwq8jJG921ADrPL84sTQIu2y1wmXI12TUG?=
 =?us-ascii?Q?VtYMG2KqD8RmmTyd63M01W0R9lxhWrcsDAaJU+YiAdLSEMI+G/kveNyh/Qa9?=
 =?us-ascii?Q?Ibhj28GpQ93hd/kk2tuPDHM0+NJorQyb+5c0rgGYbztUxgtknd41g7vVOcH7?=
 =?us-ascii?Q?AFuCeVbDOe3o+gkFLvw2jig=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5cab5ad-f569-4050-cd99-08d9d0a0b800
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 23:11:35.2072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HtXCmdL5vFvDQi7u0vcWRAhC12WhBgCnwDjRl8E9K1i/cO+CFVNw2dH6E/m/WmwIuG8JSaeCd7ix1xXiSVO+LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3069
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
index ea0f02a24b8b..3d21521453fe 100644
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

