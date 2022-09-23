Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E2E5E7DCC
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 16:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiIWO7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 10:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiIWO7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 10:59:37 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50063.outbound.protection.outlook.com [40.107.5.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC01B1CC;
        Fri, 23 Sep 2022 07:59:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XG8qNZb2CcHHVOFzWfXVVlJC2Tp4vw383x0COcgaHkVlCbrG8UYc2L9C3fDPIqU2SUEXrGWgf4Yu8OA5BXu5D6ClvDT83ShX7DaNfQwd87x0wjGZOgG5ZSJoa1prQm17+MKAZ+R48FFjpUmO2rcq3Ff6XjClIn9yeZz6cuNdEAHGHFThe4OnC0ovKZoKQ6o2XsGnXO4AMe8bm960Gc5LmwYvSTnxsDLnKdzfC36fyWJiu64MhRrxmEiWThg7Uwp0RdK4Mp3rBmGDYk7R+wBhQPhodUTHg5XQcu4QH6nMqsVaaSBhCzJkCNqGZcM3RVf3Gmp4ywPMabVjz9bg21MEDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1z16iGkCVpiZmg5Qtp3a12RY/nxZdbVjL4xQg1uwkNY=;
 b=YKHooXwMtfcBpQnJYnwhL+5qhiM11Xe24dWJTb6OsOlmuipBK4CsejcF1c3li9QpvOyp+HM2VUI+mLII7VYeiQDR7ntMm0ooMw7vsdy7uVDD6CCG2vJw744a6zaTKNtomV8YtYdLi+SPHXnDgYZkugRSDIWcp1KLgxculgFCHT6fa0SLoaINi+7Nt1YO/Z+3voG6d4j7vfO5ME6SJI33Tb/Y95SX3PlqJWT+piZja0sQUErMNFz/WU3I4lnb29caEElocFZwd6h6qsd7AApB2R4rBF890p1F1yVPK61MswVcaixqkFWbEv+UjYHjoyhyfqyjax5U6ZBxiHm5pP/7Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1z16iGkCVpiZmg5Qtp3a12RY/nxZdbVjL4xQg1uwkNY=;
 b=LkF0+/uBKli0TjsG5Xwn9NQPrlqEJMxKx6WeBy5mxmld8etXDlICXBGs1vM8XgSI3DpC9pqgP7ldzEmZGw3vCtjLmfiK+MlepvnNee6hq+vQ2/i7GRLiRzIe327mUqHhKqmXl4C4N4s9iPexeZhITnp5Uj0dbd8WDz9kEf/SX3s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7436.eurprd04.prod.outlook.com (2603:10a6:102:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 14:59:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 14:59:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net/sched: taprio: simplify list iteration in taprio_dev_notifier()
Date:   Fri, 23 Sep 2022 17:59:21 +0300
Message-Id: <20220923145921.3038904-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0006.eurprd02.prod.outlook.com
 (2603:10a6:200:89::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: d7899da7-a05c-45cd-0d1a-08da9d7438c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1HYazr9l35nwL3yFtyYcRFJ1bhpkFSSJLCvHuYrzG9EFQvkC2E64e20ypdRE8QOTceEBemod1UgdN28hXK2WOUr5vW6PjNZtBPU0S1Al2Qlp/VRoGcYGwB1MFnMyIScmZbN6H1zj0vW5xrZZlR7t8ruU4gJxRgDRtAgQPbHYiV7/Ug5jnjNEq+Y4Tvsni1EjnVZCaJ64ONfSjFlD+eKvU4z6xgbFN4iDmm0FjsFxuajXJEZTmcpkHSgys6gctUoPK4P8TTPAnTNsZ6fAkXuO9GPB3mTcn5h00NsRoP75WsVVnMDfSQTfaImaepTNlDPHkHeou7QzKXbt3wctiL94rRQb4ZNfndfpLOSUjgvyQaBDMsT271dlTJpp3R96jA90a/rMiQtHoFl+5BdrfM4/JbYsJAMgiBctef1GYA0vG+A4yQ9o20jYjRKpnxOgKqexssTnEITtyEq0bn4C5si1iAdTOKFOmRXinICvJbcXCTCOnFgBPftQdlf2c38ZmRsAf2f3pN3U3E5KlrjiLl5GqDQKeHD/xxkMQqkQYcsHO+0pXz5Aiw2l87Zrnf7CXHkshi/EYqpnB2sWZGRDJNf6V1iqExb7wt99AkyM3s77d3OFSAvf0wvv4UnJVwjt2JoeTUF4vCNoSY36omeCkAALpCC94gpsDl6pxlBqZiH+rZnKHI2qgKOasjdBiSEZW8guxjg9pq2AZpqLPjfZm0NPLof23r259Rsc/5rzl5Hky2YkAIV6N2RUrBQp4fr6cZfv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(451199015)(83380400001)(6506007)(5660300002)(7416002)(38100700002)(38350700002)(52116002)(66476007)(6916009)(1076003)(66946007)(316002)(6512007)(44832011)(478600001)(36756003)(2906002)(54906003)(26005)(6666004)(66556008)(41300700001)(186003)(2616005)(6486002)(8676002)(4326008)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Isrde4GfdU6zxr/F0b7z4NYrXXXHdlwe8zAohsNc0aBmFJnWMFk0kQz9e12H?=
 =?us-ascii?Q?9nGMr60K7HI48/nHKzHCq/9ZpPXmoaqpX4G3DWzm5gXjnjBIjRe/0voDrjLP?=
 =?us-ascii?Q?CuYxIT5Xt+qoMLXzFFfpZ7x92t+/328VqWLwfqGaY1uBrpQVer1R9Rhb3TCJ?=
 =?us-ascii?Q?bhmggdut1Cgk+Q0nQf4UfhjFHzdrwv0c32xiYsC8TPiiIOGIrCXURSD/+BBe?=
 =?us-ascii?Q?uXu2FLUaEqgNrdld3xjIZIRMnZytft+OpWOLJUCpAnpBdQ2ffrkVpbzLba1k?=
 =?us-ascii?Q?Dn7nwo8pA/AnWd0a6McoTyZkx33SfT1gRejhBsIRrdmBVDDOAmdFplZKZQY/?=
 =?us-ascii?Q?wIMqow4sr4SqB03QWUaGePTLzW41hlxai3QEeEbki8XzbbrEAC57IknsBz2A?=
 =?us-ascii?Q?dTX9EmlMmXE8WDdL/WwdFHrcPMazPYpMb/VMOp8gheLiIJwHMsgJD0L8K1b9?=
 =?us-ascii?Q?DsbvZyAzssRIX3qudrgCRB4gVAObtrYZrvgCSxLwyIJHHhQknHc8O6h+PIB8?=
 =?us-ascii?Q?gPsmxRz1nD+5kUzOZL8F7lJQFFpda46ow8B2iG31q6dAmR+50Ebu4yi73//i?=
 =?us-ascii?Q?1KV7Sm/LUWCLfVpyW6wLRjFzB2u423Clm+qMTUWLEPkWbcvcMvTHng5cpbKt?=
 =?us-ascii?Q?Ohc31MCNebyWfWU7HB6w8p4/JJDp3uXz5a+2ARe+zr9UOU0ETtnJz3N+rUPn?=
 =?us-ascii?Q?6/8C667ETK4ZQPEb4ffWKNMPtxaaA15i3DXgOeS1GWfF7QoZP80VO9LzOZCt?=
 =?us-ascii?Q?geu5+pBp0OfNy7N2DXpFwEIxaqOpLp+bHgqtyRFe2Y02b6ky96t8G3UTf8Bm?=
 =?us-ascii?Q?YGbctdG17MjBzxr2AKXoWMSXOLCg6OfRWmsvR5NWYnm3Pz87JQbN5jMhBQH5?=
 =?us-ascii?Q?qyXRaTryvLM42zVtT2noEw0ncIUCoz9k77fTnRh8k5V2sT9aCwoQaxhcfsjS?=
 =?us-ascii?Q?ZgclS56FxI4ajoY/MBRHHiWgHQTkmFBu989pHKyijmymzqqkY4iZCohYVoPM?=
 =?us-ascii?Q?R5TlhaUQhtxgsMrLCyutK0smqOpAhheIhwQ7d1tsOATrI4w72PgQotF4vO41?=
 =?us-ascii?Q?eZYwxnRq+7yoG9np/IN0ws8DA1Vb4DQCWPxJOD6fe2IapYG9QHMr2TPFryq6?=
 =?us-ascii?Q?xhLinTHwanNBLhaqw+mUnZ8gIM8y1nTzWh6n54W9iOkRrZZ65hD3jnCjrSrn?=
 =?us-ascii?Q?lgnHUo3OCixW1LRZmpLCLB+Ws/svwaFZPcqJqgVnM1WhsOoVsJhM2U6FNZR4?=
 =?us-ascii?Q?vjCXZVzQd5oKRVz6YcMqZ0fpEr5ZlKXlXMRQB43zNWozdsBRqKo1H5x4oykA?=
 =?us-ascii?Q?5uBprGPj0E3igK/zJoCbb1VYSOuRBnR39J/UdVGIbBDTQH8treDgYwNHXZN3?=
 =?us-ascii?Q?Gud9BuEGaJsbJ4HTvAgrNfIwE5mM6BZnp5jLcyLjOpFqAVrcG6TnuiDkYudQ?=
 =?us-ascii?Q?K4ehJUbeBQSvR6q3R3o1JY5haGrpX/g9FLgxjohZBVwoUE0Iklv3NASmtnPh?=
 =?us-ascii?Q?rvFVebBNYIPrlRpBp1sNYtiyneKpIjyOpijAecv2OZBEAKlW5BX40P0xRM26?=
 =?us-ascii?Q?WL3zVuRD3kr9rCFODgiRBLyTDCnjZUp6GcunK1rT8pAWj5S6Q3yh0pfdNsaI?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7899da7-a05c-45cd-0d1a-08da9d7438c3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 14:59:32.1826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YBk6amYyU7NEgNJxK6mDl38MQ67jSB0SGA8rmBQ3piqyEc4KYscpAe+XtNKqOjzoOr7Uua+pb7vM9rI7yrKGrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

taprio_dev_notifier() subscribes to netdev state changes in order to
determine whether interfaces which have a taprio root qdisc have changed
their link speed, so the internal calculations can be adapted properly.

The 'qdev' temporary variable serves no purpose, because we just use it
only once, and can just as well use qdisc_dev(q->root) directly (or the
"dev" that comes from the netdev notifier; this is because qdev is only
interesting if it was the subject of the state change, _and_ its root
qdisc belongs in the taprio list).

The 'found' variable also doesn't really serve too much of a purpose
either; we can just call taprio_set_picos_per_byte() within the loop,
and exit immediately afterwards.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 136ae21ebce9..0bc6d90e1e51 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1072,9 +1072,7 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 			       void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct net_device *qdev;
 	struct taprio_sched *q;
-	bool found = false;
 
 	ASSERT_RTNL();
 
@@ -1082,15 +1080,12 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 		return NOTIFY_DONE;
 
 	list_for_each_entry(q, &taprio_list, taprio_list) {
-		qdev = qdisc_dev(q->root);
-		if (qdev == dev) {
-			found = true;
-			break;
-		}
-	}
+		if (dev != qdisc_dev(q->root))
+			continue;
 
-	if (found)
 		taprio_set_picos_per_byte(dev, q);
+		break;
+	}
 
 	return NOTIFY_DONE;
 }
-- 
2.34.1

