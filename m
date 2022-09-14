Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772905B8AAE
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 16:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiINOfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 10:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiINOfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 10:35:04 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20070.outbound.protection.outlook.com [40.107.2.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D95F10FE0;
        Wed, 14 Sep 2022 07:35:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jB3TJW3ymddT2liHQHOyReNH+hY75yZDTlQgQICPLJ4cMdZYRM+ZqGquIRrtzP4bGtWAzAAAGZ9I1w5F2U9r7UbpUYVj/oAsafykAX1WXYCBmj1i35bV9otgrmSR7uAXOMVAo0B7TPTQmu9x38dQqgt/c7fTWQPP9+2kqu9p/dSMu7q783KBHX953Aj1s7NpV77Mfa1iw3d6b+Wz9QzPzUF+5MSRzKMG5KsW8/2Bbc3cXErbeWw8evCho46E5uUTrh4jCNk4CiDbe5eSWIsBeW9b90e8IYhlrjcsACXfFkuN2XAA3eOxiKUCnVfZoOSfgra/afmk2EIhEPFAKHHCwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NlEx7DorBo9JZzmjK9Tch7zzB7uYgY8zPVfFGZvlrKk=;
 b=Hw4oO/vXPwMmoFR8/CDUip4NpLCNU9mSYCDArLj0fCmndVf+KtUta6VqOYIEj1lmFpwvHpdsbY9Stub38ql1ezPnO1EhSYR12103wPNltVCQsUglYMdQnptLzLh67M+KsxEDdzXFPNA1hYTnm5s7hkxHRnvb+uZDj7COCMcynkWL708GMT3q6/m1eobvWA5O/7Hh8BB292Tt6RybKsW8m9JoykiGC+B2tIoevx11iiPZSo5ft3Lk26xCttJzYTFCtGdpIAvq/EwvbGdKRVGeuNV7o7qAY6PgcRIQc4u8X/Y+zTjcgNsUkVyDkPyxBj5pV3khPfyT+HdknVch2bc5Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NlEx7DorBo9JZzmjK9Tch7zzB7uYgY8zPVfFGZvlrKk=;
 b=W59dNEgsntshKo/DaaFTLiXnLTUgs76LzQLcZgtXgZ1/3JPzGXgkNxjp1q0VgNzj5c3XpPM/+7KGHhuVs69hvk7qJ6VFftD/SoAhblGW4FMv8DHJzfQLuph0W+9aKmvNaHgOl48WVzBsjMOUUGqWOE+08RskJS2oqIBBrP/elxo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6777.eurprd04.prod.outlook.com (2603:10a6:10:11f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 14:35:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 14:35:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/3] net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs
Date:   Wed, 14 Sep 2022 17:34:38 +0300
Message-Id: <20220914143439.1544363-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914143439.1544363-1-vladimir.oltean@nxp.com>
References: <20220914143439.1544363-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0029.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB6777:EE_
X-MS-Office365-Filtering-Correlation-Id: 5356dda9-1239-44b7-1a3a-08da965e4dcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SGcsq//ZM9s4UKqSOhteXlkeC7os9fBO7ZC45kqGf/lkX2Yh78cnuraax4f+KFamtKbJNgAtmlXYO47xiETn5/d0Pnx6xiejAxIBs6rbadp7LQhavmzSECFD1dhW30mlsr90H9paNTxGA4CG1CKatf8hwgIupn8kpfttQBx7zA0IITEk9xwLwKyrkUDuO33LsHC8bxKDnlZcRzJoP1QlZiSYb8XSlP9mDDCPSiJOcGNVjKF4YNoYsDdmhBOMxL9m4uVwS/OQwrjaJBSMRLCnVcRmZGe3SowMoG1bpfe2RHjbvH55n19A2K09P42sCqDO1A6iD8czbSZMt5sWkEnY2HA4j4aEScGNsLb6QT8NrD/hcRHVfmErkvdmspLfF/PwbZzdl0op4FyMkQdm7EG553H975Q3+49PcU7FAuCbJ+QHkUSpKZIhXKgwYShPJeqZ4h9+nV4vA7E+/TjSWnU3aqbQBgydiA5jNBRdXT3Nke3NuBHiSEz1kRSS6bAsNAbMgULCtdE1aNMIdOH1FmaZyBedtQcyw4gU8cPfJ5yMQ1e8nMqXyUobr79tlM43+u4/ctcciDIVSBQSYigShGDRGR92NwwCHvAlzrk+QGKGHenmdEr5FbmFJdg56D658RP6PbsauPt7HTlZ9OsvsF5g7g9cad/YN+9wjpOytc4EJZgBHL9hsZiUrzlTgDygaFxX3bOJf//ybCK0PmAHfc8peN//J4r+Fs+p+8Dh/qt9RukYSY7l22EW3EPqDuVfScFKLY+qjhUS8bodh+gIbEhQoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199015)(6486002)(4326008)(38350700002)(66946007)(5660300002)(6916009)(6512007)(7416002)(6506007)(2616005)(1076003)(66556008)(52116002)(36756003)(41300700001)(26005)(83380400001)(86362001)(66476007)(186003)(8936002)(44832011)(8676002)(38100700002)(2906002)(316002)(6666004)(478600001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fe8ILetIorOYp9WBZwc9IIdX4lt7TuuIJz9mJhjohMQQgMSWxqEiFgXTFnrH?=
 =?us-ascii?Q?2bSAuGP2UduGbIHdv0gVDuPO9ObMv9W/HmANlqzxhqdiK2UpIJz0j/ANARtA?=
 =?us-ascii?Q?yImmvKKUbSy0Xr9M+kdeh0uup0croRtx0az5sYkQpI56ebW3zupPW/FGNSHV?=
 =?us-ascii?Q?nn4BJs+KeZ499GlJeaA8gploFigmgNTYFNEz1Ijm78x73TqzxBQXM64PBEIV?=
 =?us-ascii?Q?90Ecb+F9zA7gmPl8ZCeJ828n9s7pvWhswKx5+UNl/KcrWP5mDHQkc2LczxEL?=
 =?us-ascii?Q?ACFPalqn2Jme7gEIfrpXvfYfQo2xTg9vR7TX6srLCiai+2xbiD29SHiW5eJF?=
 =?us-ascii?Q?yCfSTCWLbI4BcpUhV5RAQLQP/4RgJqaS1TXalNan39U7Ov6a4NZBlUmN3zaP?=
 =?us-ascii?Q?dY4oKW2hA0pFPCgPGmip5fUQTDQ8DWOL83hkmgzWrwhUepbAgIpE3bCaViF4?=
 =?us-ascii?Q?dzg6R7SwUPz2gcjl0dZerfiiQkUVOhdzDOT2xPDssjIOi5y5ITCF0BtM2Qky?=
 =?us-ascii?Q?wYKbOljde5uXasVfuFec9nKhV53yqQnSSqUBrqBNuXlaC5K88Fu9IrT0B/N2?=
 =?us-ascii?Q?Me3rGf3VIxjxhTqJDMy73mYxAMXN9XAC8GHGXXXEgk5DPFvKqo+ARW25kO2F?=
 =?us-ascii?Q?kG9//0E4ezmk8Mta1bKfJo4bV6X0/bVNPm4Ur6t8gRAE9oJt9cIB/VOQJ1Xm?=
 =?us-ascii?Q?R2cBfzWtz7x3U2qy8T4cgjoi8q+gXgD5xR2RBgXwghBD1f1FTeFWes5UZ79f?=
 =?us-ascii?Q?r1lsRHyvVbr29jLJHi1ohxB+Y/dM/DTPCEPLF26ZJSFKlCSOOBshnWMXys5a?=
 =?us-ascii?Q?vDoxG8L7bm0yfesVPG4u1+ppEMCKlje7kh6DCKn1amdrHDOYTbqsaLLb9Uun?=
 =?us-ascii?Q?cefz36/9d27UQ3G8D4ezda6dhz6fNhQ5aywskkP6ypK+CdBmeXTr9knoBrJH?=
 =?us-ascii?Q?akXq3E7ZWUpAWojOBuBpA/U/my8MW4BrdK2PiTAAhP2Nlfs8bcMVEou0fIKB?=
 =?us-ascii?Q?cL4dFUXMsPqN1TomKP/mI4gPQfi6Du/+6KI0v7uIoVqjHPCFw2tPFDEisc9n?=
 =?us-ascii?Q?GpXgg5zCRj/eL36hZL3mthYs7mXqhMYrADHTNxoajlcqIcvZ4XKpUH7TW+cw?=
 =?us-ascii?Q?miWfb9Wh8I1z5s5q6njGzsSTbDPMBpnADr6d5Kb9X9YDpb9WmFjfscSF+5xc?=
 =?us-ascii?Q?o1LJVQv7lJBsCU07hthAyU+44gjGqKCw0dT7zxgYj/EpXS8gmsEgvnPenUAt?=
 =?us-ascii?Q?GS/DqWpYnY2bU1J1XLX2OU8WADS3YjXlnd5f8dgignRAsbSKpTJ6glPNZCms?=
 =?us-ascii?Q?Ccc3uxMpLEcq324uTY8DEdIfo70/rf4j8vfNXLVdAiEsHKwN6WtaMLaQB+BR?=
 =?us-ascii?Q?zEzOuP33ip8MussjO425sfRNjsZi5JeJL/sQwoOK3jeRSJ4POWUcOvpnqBCh?=
 =?us-ascii?Q?bPkEaHqvBPdIOJVg/3BCNdHZRnl0omBFYyKBmU6uxVvuGjD8Xm7nN9q3Uds3?=
 =?us-ascii?Q?biy1ZAd/nmxklqI79BUbQEoEFQgGacGdd1eeGGkPa9LL0eeFLrXbbCl8owPc?=
 =?us-ascii?Q?Vb5GX90/eyoses90KdueewXk/0KUlzntcLGxWQeGc5YpNcQeSx4ekFdsGK5S?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5356dda9-1239-44b7-1a3a-08da965e4dcb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 14:35:00.4938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eNtPFGWV6C1x4mkzARSZ96wBGfcRfYCszoksf5h8rngDui9O90Gelvycg3zVc7qHMseoXlwiW8FVohYSdnag2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6777
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

taprio can only operate as root qdisc, and to that end, there exists the
following check in taprio_init(), just as in mqprio:

	if (sch->parent != TC_H_ROOT)
		return -EOPNOTSUPP;

And indeed, when we try to attach taprio to an mqprio child, it fails as
expected:

$ tc qdisc add dev swp0 root handle 1: mqprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
$ tc qdisc replace dev swp0 parent 1:2 taprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
	flags 0x0 clockid CLOCK_TAI
Error: sch_taprio: Can only be attached as root qdisc.

(extack message added by me)

But when we try to attach a taprio child to a taprio root qdisc,
surprisingly it doesn't fail:

$ tc qdisc replace dev swp0 root handle 1: taprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
	flags 0x0 clockid CLOCK_TAI
$ tc qdisc replace dev swp0 parent 1:2 taprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
	flags 0x0 clockid CLOCK_TAI

This is because tc_modify_qdisc() behaves differently when mqprio is
root, vs when taprio is root.

In the mqprio case, it finds the parent qdisc through
p = qdisc_lookup(dev, TC_H_MAJ(clid)), and then the child qdisc through
q = qdisc_leaf(p, clid). This leaf qdisc q has handle 0, so it is
ignored according to the comment right below ("It may be default qdisc,
ignore it"). As a result, tc_modify_qdisc() goes through the
qdisc_create() code path, and this gives taprio_init() a chance to check
for sch_parent != TC_H_ROOT and error out.

Whereas in the taprio case, the returned q = qdisc_leaf(p, clid) is
different. It is not the default qdisc created for each netdev queue
(both taprio and mqprio call qdisc_create_dflt() and keep them in
a private q->qdiscs[], or priv->qdiscs[], respectively). Instead, taprio
makes qdisc_leaf() return the _root_ qdisc, aka itself.

When taprio does that, tc_modify_qdisc() goes through the qdisc_change()
code path, because the qdisc layer never finds out about the child qdisc
of the root. And through the ->change() ops, taprio has no reason to
check whether its parent is root or not, just through ->init(), which is
not called.

The problem is the taprio_leaf() implementation. Even though code wise,
it does the exact same thing as mqprio_leaf() which it is copied from,
it works with different input data. This is because mqprio does not
attach itself (the root) to each device TX queue, but one of the default
qdiscs from its private array.

In fact, since commit 13511704f8d7 ("net: taprio offload: enforce qdisc
to netdev queue mapping"), taprio does this too, but just for the full
offload case. So if we tried to attach a taprio child to a fully
offloaded taprio root qdisc, it would properly fail too; just not to a
software root taprio.

To fix the problem, stop looking at the Qdisc that's attached to the TX
queue, and instead, always return the default qdiscs that we've
allocated (and to which we privately enqueue and dequeue, in software
scheduling mode).

Since Qdisc_class_ops :: leaf  is only called from tc_modify_qdisc(),
the risk of unforeseen side effects introduced by this change is
minimal.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index a3b4f92a9937..5bffc37022e0 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1949,12 +1949,14 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 
 static struct Qdisc *taprio_leaf(struct Qdisc *sch, unsigned long cl)
 {
-	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	unsigned int ntx = cl - 1;
 
-	if (!dev_queue)
+	if (ntx >= dev->num_tx_queues)
 		return NULL;
 
-	return dev_queue->qdisc_sleeping;
+	return q->qdiscs[ntx];
 }
 
 static unsigned long taprio_find(struct Qdisc *sch, u32 classid)
-- 
2.34.1

