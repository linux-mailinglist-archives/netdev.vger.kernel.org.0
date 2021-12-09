Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BEE46F23B
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242508AbhLIRnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:43:22 -0500
Received: from mail-eopbgr140077.outbound.protection.outlook.com ([40.107.14.77]:38495
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234299AbhLIRnW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 12:43:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNjg5movpOnmbGoYZj4Sro9rnWfc2FaEBnKS91GzoQGSfeFyZq++K0TbSAsxFbFziBujMuQ9nM+JOTm/N1u2WWBMHcZNMIUob9dzU6/FuHCcmg26b/Gy6CZ6B2spjvbO6UJmPupt3JMqgs/Fnqyp/HOqdvOlIGsWtvzg3lFAyxjnCHbHnziHp0VBaG6ugC2tcoRm6qiPBZsJGvNZb/D+UV2EeHtnRrJYyLcPQXU0rsj4F83Fzs7HfUGiFM6kiUqsxNiFL+iu1EWXOKASdYatJHjDbGe5kUxyhCc+1H1PWAVntBK2kujpjiJtfk0BQp8hfhZar3j+OnWTi1X0VFu3yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SY+g35FTBieEkdMhirQqE3gBm6opIjDP56txAucuvdI=;
 b=L5hbBv/X3YlZMouVskX4DZcajEqGl/HmZuEYm93Zqg+dugN2Jz+qGZpXVsuIfsxH36eYBQLZB1N8C3+y6IS21kEnYCdSTSrWmsHtKcoM4ZtIXCSeVuW19v9AwKXtJn+rJWytKhBEuRs+h+qNk/PPaEUu1RSuRIr4OQtEpfcv3Yp4KQZMfZoWQrgm1CxndXw8fgfU/p0glu72OYjr6YqVEBGbv+e+bW5/8VR060zNWx1vdL1XMSJ7wHqNOEu3hSRsNtliqA3RY9dSJ27IgSAUugrcw1PD9m2xuELhusaJ754xJrbqkB/VM/Z/MkAuuH0O5NkzmawoRR6a+ueFgmnReQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SY+g35FTBieEkdMhirQqE3gBm6opIjDP56txAucuvdI=;
 b=bm94fM799oI4o3OadgZLhIboE45f0qyhx1NgL+QVYFnO43rJohnmQORM33h0M7qwr/eejN40IK5aozgz9mCeQm65t27KEP3QIBIZ9e6YTkrxY9C0/ug0Lh1uUDjVljKroibw7kOCODclb4rca0BgaA39wdGzgbBTHT2M62BEhi8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7216.eurprd04.prod.outlook.com (2603:10a6:800:1b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 17:39:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 17:39:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v2 net-next 3/4] net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
Date:   Thu,  9 Dec 2021 19:39:26 +0200
Message-Id: <20211209173927.4179375-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
References: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0059.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by VI1P195CA0059.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Thu, 9 Dec 2021 17:39:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd1f994d-f456-4689-2ca8-08d9bb3ae3af
X-MS-TrafficTypeDiagnostic: VE1PR04MB7216:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB721668985CCE0BDB36EF6369E0709@VE1PR04MB7216.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ISuCW261qJ2mQaxTTgdtMq5Va4zehK+7Q9Ok1PVPvA89gQ0ATgcFEQnVANz0T4aboMElFNxI3weAeW4zqGZw0QlUKmSlMUw/cnDyc3vfYfHrZhn93p2DIv948MmnrcVKchjMLG8lJAb9i1YsP7tJvN5PZbEritjL/5VCjMV07NxvcQlaSR9tj+wrEHU0UK/8rxeCBSeRayjFO705SbjmiyErspkEhUyCSoZsgiDcTITFUrnVJwv0nxO9u4jSsDgFqAjktG3Ecxll4AJ+qCixHT40rB2Ke5/HNMT2+3QNJeFjt8k1YLtPsqHTrgfc6iQ15TEw7K8PJFR5Hp98gOP/6A7iU3QXDzm5DH4BSw7ioPUM3oFeWAn9vmofYNde+hxxfub6LZZIJCffnxMCWpP3DkiQFGxuqxtbjTMuVXCB9v37T4MtMoggtrpuSiZdFLnH/NdkiasQRxs5HGNyxcP7FxRVHxtZqypVoCDclRZHjXvrundtqKEYQO9SFY/BE4bRrSPPH/SvpjJQEYkGmsdfwCk8JS/mLcWKvYLZr30NrLECTNcm0OOuLyQfhK+p3mKWZRRMG3fo8tObNnM3YUqd3Mo7SV4YT3WhH/6jsntPYaKuyeiHdJYSmcm8Z02alA9qcbBUt/EdROpMqWGv4IKPygHf1Icmi/vCkwuhIqvKtvBpzIMe87S2GcwZFbf5eQuVhmIpUksk9ICyjAAbh5Upiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6666004)(5660300002)(1076003)(44832011)(508600001)(6916009)(8936002)(956004)(8676002)(66946007)(4326008)(66476007)(66556008)(86362001)(2616005)(6486002)(26005)(186003)(83380400001)(6512007)(54906003)(38100700002)(38350700002)(2906002)(36756003)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?asRS2uCKHyOgrjusPW7IevB61hF9is8IIuFlZAyLzhU3fcAILWfsoecUHuy9?=
 =?us-ascii?Q?LtrugKXHnxHPU+yo62ml4r0wdMqHehiMRc2tklX7JYC2BE5Og91W4HmM07Ev?=
 =?us-ascii?Q?ZLNTYPa9L4R5gdcejK9gKofhKfPWmoNnE/RKB3VfvJjSTyvuQC6JIe013ljc?=
 =?us-ascii?Q?uDpygF10wl3uB9KXQOVh4IA7Y6rKewMQsjnyOhTP5JP0oJE3pFLTvXLwfoge?=
 =?us-ascii?Q?rckRKOCZEphkhSzdgoA8rSRzovs7T50a21PhB1glTj3zUHOBWE2nY23T4+Nw?=
 =?us-ascii?Q?qSq/Nd2+JtEW/iCwDeC2/vGYfw/MwMmKzq2YLeBiO3v1T0NXVsneAV8FgYxK?=
 =?us-ascii?Q?4SQqszE0GAoHaPl6J8N1eZwbRSfrBwFHqYFPDFhu1spk/PRVirsCEOxmwomJ?=
 =?us-ascii?Q?4E+3lOyOmw0brTvuxQNwMLg5dGuNB+WqlX/lyuxjG+TZ0rwurUXX0t6VjWP7?=
 =?us-ascii?Q?SUg2qAPiCqJV6CY9tI7Gq7MQV073CJpqsSJ2PJ0oJ7mZC/9sY+YbW08elu5A?=
 =?us-ascii?Q?L9uWNPZLdy3qFnKG95tic7a8gs2KUk5QtXhUnr3n8+doP538MByfRdOBoy8C?=
 =?us-ascii?Q?bxdbtYK1lExveJrP6pETQLs5YjH+lngLrhhHHJIdd/QVVZR+78mqlBxTBvcz?=
 =?us-ascii?Q?TJasQcLoiEaRvfqTIolpe56+XV4qzyA9tw0OHMMUCWCgVnfwNhPNDP/wKxaO?=
 =?us-ascii?Q?WBMUYBjhNh6MiaW1XU28LReCQj3Msv6A95xBtzwa+3k0xBFCq71W6ERHTISe?=
 =?us-ascii?Q?gVZ1sTOg0vhLeu0z271K8W6EloEP1HFVFc/HpYWbjpCVaKg84qv/zknyCTjk?=
 =?us-ascii?Q?pTItdozkUug1CVJrN/nHifWKToh75mBKecpW1YnC6NKA3kOaJzfzH6NhctIJ?=
 =?us-ascii?Q?itbBd+BnRjYbQZw59yyQyzTdDCMdoX0gOK1NMwD9QL1ZPoiJn+lN0aS9vwKB?=
 =?us-ascii?Q?rcx7K/fgRS11eJBdISCvG4SNPuiusm1Ul/XBna+zcr94a6zJSk1KSalhr+cX?=
 =?us-ascii?Q?qS2e20jbfCurmwrnTAfPvv3AUIaB0NTBPvqRACa/uDyW78JpgycuMSu+Pe/7?=
 =?us-ascii?Q?fLOtx4+DdBffFWnzotS0c1NJwCbirCcB4Cz8wGjJ0+IsJcLYb+Md+00RrDir?=
 =?us-ascii?Q?DT3wEPDy1cM2Qg2AuLelQLPcWJw7in78H1U4udZ5KOt5jZbVlsBee9Aef/UP?=
 =?us-ascii?Q?Wz29YAwBTZvy08ILQ6mLTu7fyGldJN1ElL9nBvidc7pPDFsLAItMgIhP6yO8?=
 =?us-ascii?Q?mPpJ4jUw7CRjbi1RqUmKMzhJFi4I5Xw9Xcr2d5mLIGVEwIOy315qEHOaP5sy?=
 =?us-ascii?Q?VNWE+r82+DiDJWKIKeQ/kzmRUbTr9K6ZidCzvN+foBkn8MBNZ1CmgC1IPenN?=
 =?us-ascii?Q?xbufjEXGM91zta9pRYSgO+dOZfVVZdv+gWsjPpVNpK9COq3+LeQJt8EIjUhB?=
 =?us-ascii?Q?18/xz6zooZA+d0ed2jKzbG7kN5DLABpbgd3mI4UUKLKLRRBdNnG2vi3ySyg5?=
 =?us-ascii?Q?LuZpqr5p7stC7yIhfD3J0qa/vL94001h+jAWZoBZtFmzVODMR+sJQ9XyVeDE?=
 =?us-ascii?Q?O+sPowzRYpGBNdvtngD/I9ua6BVrf/NPEFjm37rPvVJf5vZDdoO1E9n6R6Yb?=
 =?us-ascii?Q?WKAX2p7OHkx7vqOilfEOzw8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd1f994d-f456-4689-2ca8-08d9bb3ae3af
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 17:39:45.3447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61PCt2CLnSeoh8RAyIRmOMCeqpRA/XNap7orxtvwmB3WTZWo3tCq0dFqfDP/ghoPXTpiYxiwGEqLK95W/SyYHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA needs to simulate master tracking events when a binding is first
with a DSA master established and torn down, in order to give drivers
the simplifying guarantee that ->master_up and ->master_going_down calls
are made in exactly this order. To avoid races, we need to block the
reception of NETDEV_UP/NETDEV_GOING_DOWN events in the netdev notifier
chain while we are changing the master's dev->dsa_ptr (this changes what
netdev_uses_dsa(dev) reports).

The dsa_master_setup() and dsa_master_teardown() functions optionally
require the rtnl_mutex to be held, if the tagger needs the master to be
promiscuous, these functions call dev_set_promiscuity(). Move the
rtnl_lock() from that function and make it top-level.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c   | 8 ++++++++
 net/dsa/master.c | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index a6cb3470face..6d4422c9e334 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1015,6 +1015,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 	struct dsa_port *dp;
 	int err;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dsa_port_is_cpu(dp)) {
 			err = dsa_master_setup(dp->master, dp);
@@ -1023,6 +1025,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 		}
 	}
 
+	rtnl_unlock();
+
 	return 0;
 }
 
@@ -1030,9 +1034,13 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list)
 		if (dsa_port_is_cpu(dp))
 			dsa_master_teardown(dp->master);
+
+	rtnl_unlock();
 }
 
 static int dsa_tree_setup_lags(struct dsa_switch_tree *dst)
diff --git a/net/dsa/master.c b/net/dsa/master.c
index f4efb244f91d..2199104ca7df 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -267,9 +267,9 @@ static void dsa_master_set_promiscuity(struct net_device *dev, int inc)
 	if (!ops->promisc_on_master)
 		return;
 
-	rtnl_lock();
+	ASSERT_RTNL();
+
 	dev_set_promiscuity(dev, inc);
-	rtnl_unlock();
 }
 
 static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
-- 
2.25.1

