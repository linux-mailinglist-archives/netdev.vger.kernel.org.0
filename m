Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BD84846C4
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbiADROw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:14:52 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234664AbiADROj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MD+25wmJQfxzaEv9adRs++owEv+9N+psXOvOPD90Oqg/IBcgURizgrt20dYth6LWQyvuk5mzlPYd0I1PcImybg4rxdTMHWDZjpEez6eadxSPYbysqkIin6D1qJwvZVnYgIeJ1NZJMMO9Q8BZ+YCdOrMAaC31MWf1LVcMv+hbOd/WonyQFq1hOPJXBQjlVwLdJAPpumFR0myOnvFJIDLQ4ipNTeWrC1cWcUn7Fmm8rX1G5XFZpHrgq2TrfjQeQA+zXIdV2HBfCts0mF4tBz6ToCKjK+9RK2P85HDFFTxEf9T7p5ZPIf8PMEFDY/diFrGW/7I0nEg76zEDMewQEhhAPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IE0nWSyN9SY7th6dNrW+vLPOcu4ZRMUzGGRo45+S744=;
 b=RNjW2J/5Zvxfa1e11iQ0yleNOPgRpL2v78QatD5a7R0HnTUxWis6q2Ko9/uyv4WD7FUSJN2/wAfTqaEivUKW3dXjnhkcqwqX3KkxhywND6GZqGeiEvUaycPtDKIxcGL5DErhgX3rPA9qtDqU5FLG0qhfhwedmfewhyUiNY3m13araXtEigvG3kMoieExDeiL1DTBugi9E5+QeXnxAlUtnPKF0J6O0SQNTMUKUtov57Y9ik7G1VjHm5jK+3ZJ9qScSus7YMn5g+DqjdNn3j6MVtKgeynr52WOOIyJgui6VXwddYrRvdxEAd3Eu5vgZSe/NTJjwrt6KY3U/+8Oe6Ewgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IE0nWSyN9SY7th6dNrW+vLPOcu4ZRMUzGGRo45+S744=;
 b=CheHdioRlZC+M/dX98jWWCBYurkkpwrLhJfHCoVOZQeTCgMtUU0/wf5SXC+PsHW3ZFxu7ARYq15S2q/HY73/eTcQdJpTfYQQVI12Z4CiLhycO5fN26NvkObv5sgv6h7x/3XkgjL06sTBZNBuvvZB6cn2cB+opzG7N3xOycxU8NM=
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
Subject: [PATCH net-next 05/15] net: dsa: first set up shared ports, then non-shared ports
Date:   Tue,  4 Jan 2022 19:14:03 +0200
Message-Id: <20220104171413.2293847-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 77ebb45b-5279-40d0-0469-08d9cfa5ae25
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB710472B2FD7DF734EFD38471E04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ufSDksvuebPle+yxenIHMaH/gp5OMcD2ISw4hAIWfLd7IWvPVCXgLAtXzEFkCk47Knt6VsP9HbDwHuv8uHhMsoMdo5dRNS7sX0yTH0XbPdGr8+D3pnGmoVGpRxQ1XFHGqCxuZqTCxTMhLJbk33gBRAC8l8XdR++6kaI6X79XCXXWCqnXwflNae+Oa0ddj3OHe4eDqjlQIXWN+6cWnGVym4L6Q2kK14ubF6dG5Ek74VWb3kHV9GCDEt3QzFly0LFGH49JgZV2gETLmFUVbAcFXgyG5VN4LW8ZcMdqRbpg07eRpOuOF16ImCAwY8gZTFYnEskjATIqNH/rCi1fmt76ssDrswHJnSUO+z1eN8lJvfBE/wwTcwEXPaWTm/LtJbD5g35+Nh9F01ybva0mBUY6hgfqecagKuARB0WL/uS2ntPUgrLZYwOnjJk+xD9wEg1StJvJSgJ/9RSMmmBIdxumnIrqgGaxhgpTD5vJaEQwSgI/O+RPb92ulsp1Wng9S+qvqlLAvV1o/2A7X9D0hxa7JU+cqFH3dX90uKxoY6BwbmShpOfoQ7FTuDVvl07Dhpmn6F9TRT0uJuKlGPsN9ds2cC0QVehLVmLjIMv09AESCqDA0ulSpaz0BQZsdQ+VnNErk/vqN185aUmujay9JPt/qHl2vL881mHj2xx4btZ5TlVX91Xh2swZvkizhg0fo1adRtBmX11zVE/vzlWADzLsfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EkCQBJnxzOPVCf67QBwpzB065PMOoi83PMAIwAfZwwmWq6wcyfbXCy/24Sm0?=
 =?us-ascii?Q?QW+5PVh+a49iwacLtRMF0mALrK1rjj4cR9yY64/ao3Z0Ds+WQARt7on4oI6u?=
 =?us-ascii?Q?gfug5ndtQw7U/0OblQNMgTwq1H0t+zEhXGbvT5XTdsjGl0h9q+a0pdeJytYV?=
 =?us-ascii?Q?FXhohQ0esNCMCvTZP9JGTuajGi+mh0V+SZU0iMoXQwOXKSGY5sKCIp8AdkrZ?=
 =?us-ascii?Q?jWnzAtgcUO8TadD1nlYolpqX1PG9+6gbJL34/q+H1inNpsSi76kJQngZRaOS?=
 =?us-ascii?Q?flcBtWSOURRqU/l8E2+c+TZkW5/XDReNtSoPqWp/5dEKAfasG15QMshyvLyz?=
 =?us-ascii?Q?g+br3CeTRnkZrZkXZKF7JAv5ZlbUw4eqENLXmZr9PSbgtxJKdeIfgrMgGbuE?=
 =?us-ascii?Q?V36E4v/oTMpxbDIKKak9/9nf+h4e4kZFdTyF2aF+vlpm2LkScBLxiALSnU9Y?=
 =?us-ascii?Q?atgBFR4RpOSNyRl2DdUZqc7G/4w9NrVnU/kn3I40zbRMoRnu9LEgUOfOydlf?=
 =?us-ascii?Q?ozjo1OFtQUr0JIGyPuXifVt23onYEZLi9+IHNkvCkf+luO4MDFQ+K3Brhmin?=
 =?us-ascii?Q?F3c4Le8Bf/xtdFuOy0FJIMh5OaqHzr2aPgGOmI+IbTsWYwzhdBhxb4Dp2bJg?=
 =?us-ascii?Q?oI+arQvjb4o8+/flf0iCwnH2G3NTfENBg69ugb0USC4kdCh7R1w5psvatrDz?=
 =?us-ascii?Q?UM7JHqE/X6ABmVt5QgQBBT6g5VwRFuUVVTuuhokzQNucmlizpnx9LBT+JV9K?=
 =?us-ascii?Q?cWq17nh7L0ahSJDPQzU/sHXeQP/pQxUTnSr18XrbXEH/3bQKtv4yI/E9liJ8?=
 =?us-ascii?Q?dyl60xLRWiYtF98vXA1cAENnZ83e2xwjg3MednAqGPwe8EsaGOUZCbNIdxVs?=
 =?us-ascii?Q?AJtn0RFzRr/RPjC7QF4/hfPQkrFwCBBS+ML6t/jbUUNxxi324x7jRHOokhx8?=
 =?us-ascii?Q?Gwuuzs0TSVdOyiyCG1mXqLRPM78H9VRzFMDp1nKC8vKQZNUDdljThff9ViDi?=
 =?us-ascii?Q?i+eulEm9JhOyqzhU4QcUh3SVGqrkmz4jknPh/UlymfHUJgEvMjo3mE1ykKiG?=
 =?us-ascii?Q?yaOmnavEuIHk9igsaM5SWsIt+xgH/xKiKtNNvTkM4Iw7HyKYA8pVHYTKgu4f?=
 =?us-ascii?Q?lglj8y6RSf5O+q8fueysGK/WT8IBkMMEZG6Idsl4gYhoWF4uzb30725ElqKK?=
 =?us-ascii?Q?zVuz0iy83VQ0DOQj4k8/TYIy+Wssc3Ip2Y7Kq1KnznMElY2Fm+a+0mYMHsEa?=
 =?us-ascii?Q?Jc4paVrK6frAcr8jl3+tWG5MtNKuW76QerVDopQhF2hqe6iLFhS7GLOkQm33?=
 =?us-ascii?Q?tSw4pNNBxGad4KnTlnAAMtgn7baAAnhvskwdcctMu9mS4l/HofxVXaQmdiAp?=
 =?us-ascii?Q?iyWKDirdRuXP1gcwqBTppZ6B1NJ/f5VBxmUeRCYcKUDyeZvF4JK5/46ngHdA?=
 =?us-ascii?Q?pYBSaGhUZfIMNx4qoqa+8vAki+nzBYhqJCYIIAHUeEgT6lg08iVwQZxP+eEi?=
 =?us-ascii?Q?q6PfovxRO2BJfjLfuSLY88j+Av45B8DqgWiilEatB2tp75+fQywPFGSDt3Wy?=
 =?us-ascii?Q?nvqDTBJxXOHZwbQeIyO9xP0uU1fT5dp0z6owc+ggOE4eWyDvwcZ3/viPupmD?=
 =?us-ascii?Q?/Umo1A47X5m8kMwjo55jFxs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ebb45b-5279-40d0-0469-08d9cfa5ae25
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:34.9569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GkX8p6jLNEVWf68Y8tb1E2SyrxQ92UQ65I0jx3cMcietfssKj4ilcg6XxY4ABix51jTYvklzWkgGnOPAaVAyoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit a57d8c217aad ("net: dsa: flush switchdev workqueue before
tearing down CPU/DSA ports"), the port setup and teardown procedure
became asymmetric.

The fact of the matter is that user ports need the shared ports to be up
before they can be used for CPU-initiated termination. And since we
register net devices for the user ports, those won't be functional until
we also call the setup for the shared (CPU, DSA) ports. But we may do
that later, depending on the port numbering scheme of the hardware we
are dealing with.

It just makes sense that all shared ports are brought up before any user
port is. I can't pinpoint any issue due to the current behavior, but
let's change it nonetheless, for consistency's sake.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 50 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index f044136f3625..1ca78d83fa39 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1003,23 +1003,28 @@ static void dsa_tree_teardown_switches(struct dsa_switch_tree *dst)
 		dsa_switch_teardown(dp->ds);
 }
 
-static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
+/* Bring shared ports up first, then non-shared ports */
+static int dsa_tree_setup_ports(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
-	int err;
+	int err = 0;
 
 	list_for_each_entry(dp, &dst->ports, list) {
-		err = dsa_switch_setup(dp->ds);
-		if (err)
-			goto teardown;
+		if (dsa_port_is_dsa(dp) || dsa_port_is_cpu(dp)) {
+			err = dsa_port_setup(dp);
+			if (err)
+				goto teardown;
+		}
 	}
 
 	list_for_each_entry(dp, &dst->ports, list) {
-		err = dsa_port_setup(dp);
-		if (err) {
-			err = dsa_port_reinit_as_unused(dp);
-			if (err)
-				goto teardown;
+		if (dsa_port_is_user(dp) || dsa_port_is_unused(dp)) {
+			err = dsa_port_setup(dp);
+			if (err) {
+				err = dsa_port_reinit_as_unused(dp);
+				if (err)
+					goto teardown;
+			}
 		}
 	}
 
@@ -1028,7 +1033,21 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 teardown:
 	dsa_tree_teardown_ports(dst);
 
-	dsa_tree_teardown_switches(dst);
+	return err;
+}
+
+static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
+{
+	struct dsa_port *dp;
+	int err = 0;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		err = dsa_switch_setup(dp->ds);
+		if (err) {
+			dsa_tree_teardown_switches(dst);
+			break;
+		}
+	}
 
 	return err;
 }
@@ -1115,10 +1134,14 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	if (err)
 		goto teardown_cpu_ports;
 
-	err = dsa_tree_setup_master(dst);
+	err = dsa_tree_setup_ports(dst);
 	if (err)
 		goto teardown_switches;
 
+	err = dsa_tree_setup_master(dst);
+	if (err)
+		goto teardown_ports;
+
 	err = dsa_tree_setup_lags(dst);
 	if (err)
 		goto teardown_master;
@@ -1131,8 +1154,9 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 
 teardown_master:
 	dsa_tree_teardown_master(dst);
-teardown_switches:
+teardown_ports:
 	dsa_tree_teardown_ports(dst);
+teardown_switches:
 	dsa_tree_teardown_switches(dst);
 teardown_cpu_ports:
 	dsa_tree_teardown_cpu_ports(dst);
-- 
2.25.1

