Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9453582976
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 17:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbiG0PUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 11:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiG0PUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 11:20:19 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2069.outbound.protection.outlook.com [40.107.22.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8325F70
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 08:20:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZEYet2BW4WXSey9Ex0W0V8XP1ttThizGG81WdPu+mxgp2h6f5XrZxEY92W1GwVICz9R40zyIzJQPcKM8WK0FJCt+kteJyw40FN5FEYGV1M+AYs5LQ7HKbFmipwrkhQ28r1C4dqW821O/Lx64tSoVr9VSYmL03lIFmcMLo42ZK3nEai78QIuqrjTucWPF/8C+OrgmWGaaayUpSDmSTRZbOvhCiL9fm6LYthkh5/vSpGgy2NkCpR5lqphaQmlzXaqRbTdoxx+tkwLUcWGnot2iWGaYAKmaxWCNkr2eCsrLTHnBazCA4gpyBIQvbIlsGWdBulBVnKF3dpPXwTlAxLCHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iLEOgwO4d011PD6Xm/Z6aIW0MEtXE9ICvk1thHgQbmM=;
 b=m+7K/6t5DyFFLFeawe0mUpLg/9ddh95/HQfQm5zukbBey4Xe4KOqZHPsUkl8E2EVxX4GyqHjMgNOCDGi2A8QOZMzJmGXL2Lbr/ai64kHVQ1/XNJkB3/hLYKy12eN8zQUqoUAAGneEL0uESSzz/fz8zF2aghDifKXHycac669EnEbyZ0I4B4/LzuWNjNrEHhgY5DpOmzcdfVGF3gB1TohMV+Pdtzxd9ADwoOqyY22H+9h6gjmnvgoaI9Q2X03IjLxN9stgPR5iaSdNg4u5pVojAYO+mo5K/h7+ngL7WbsWOPsTqla6tvJH8yWBJHiCU4nXSInodDa4kLBHnRtzeZ0DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLEOgwO4d011PD6Xm/Z6aIW0MEtXE9ICvk1thHgQbmM=;
 b=snOz4dV/wWG4ReTCs480USZmjOCq9Ih6bLZzZgro+eVSEqgMd10I9ZmxmqhflBcqluujUXCSvPJn+Obyc11+mV4V3pmBFQdyqwwxzBHmpSEdxyzpAhWoM7wljDvCZMjP+VwP67xap+WCCZ+FezZg7m8/9RP7I41fzukQLbSpSD4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB8063.eurprd04.prod.outlook.com (2603:10a6:102:ba::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Wed, 27 Jul
 2022 15:20:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5458.019; Wed, 27 Jul 2022
 15:20:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: [PATCH v2 net] net/sched: make dev_trans_start() have a better chance of working with stacked interfaces
Date:   Wed, 27 Jul 2022 18:20:00 +0300
Message-Id: <20220727152000.3616086-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0036.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d06860c5-0ef2-42c7-3892-08da6fe381d2
X-MS-TrafficTypeDiagnostic: PA4PR04MB8063:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Az09ne/ooRGko5u9ENlhMZSw9og7NJmJiuxkD2Fbm++17PsCO2abbGUjW2y9yiBDKIyDvDhXcoZ9OJSjhjsVOVvx9qimvVmlV6Sne3tGbCjZZ8irof2Q+ND3f0URHOjlG4MNTzg09s1Fsg4VmV3poApDy2C91aHExoeo1nvAI5QGwUeNFhIriAdrDfaTjsZGRovy7KNWRLXyC643YNBF81Zgo8+KM9ipoL42oYQKlKn9V//ER8ZTpDDYXD5HdhXnrwKdPt7W1pO+krezQAUp5sE1wejMhKgN+5jXCeQ8Cr/YX9yDLApnyidM/JY+pncj19ieSWZSxSYPmUvi0PM99sMSumopXoRx0DWwuAsRKHOozebOFwavYDbj+aNopIA02f6Bom3LumMVcUL9HJKKvDmyd2eMamWzAgCrs2DUWjvbpVkuTtNMWaBA7IMMqt4IQmk0JJMdpfNsXDgZkhgAOGYPYIaSHrehE9HtIPr0rrah4r++XUjh7uP69RqbOmjWRUP8GDsphwC5AzFAaTNpVYmadjErRH0+M9XZntXmzjIHpXGLLQgcRlUnwlonShBBeXXnDSlH+j5azC9Syog6nJizqtUVK1YZQDeV7CvtdjTSijwCtvZQyFoidAryJmKK4PQCp59MX86UuycC0G4gcyrp6d3XfgTkrh2IZcgCsXgiSkvxTi4FXPd5X7pS3b3wPfPNBLqC54S9iJ4Rjjs9460TKpb3mSFll+LasSl2WCuZq7uL851aBF7SYWEp0FEo8ctk15qMiuQK9VVPHfC8U06Kv2JpmbC64bpE6aviO5ubOsAAl5fB1ECkZWl8IX9RssjCRGqXgbqYcgp26gDmOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(44832011)(4326008)(316002)(8676002)(7416002)(2616005)(66556008)(66476007)(6916009)(2906002)(38350700002)(66946007)(54906003)(478600001)(186003)(6506007)(966005)(41300700001)(38100700002)(6486002)(26005)(83380400001)(6666004)(1076003)(5660300002)(8936002)(6512007)(36756003)(86362001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4yle0jVzaU3SJA1Th2jrxRneKFwAwRtNIgNueNtWujFDBIssIswrwDAk3Hk4?=
 =?us-ascii?Q?7ByqbTJriyzhkms0jNi4ZSE6yHKBswiPSbM03cf/nGPJfti4tb5ivjC8+a/F?=
 =?us-ascii?Q?0GyhSTvFPqtWatJtPDqMnvcWRuy+J2oA+5JyLd3FXXaOWN+ne4Anw2Br6q6H?=
 =?us-ascii?Q?CDTJBYFiwI4GRz+DxN9pnYnSM0jfnTUlJF6ohe0i2B/w84LC7wIJUB7ELDQf?=
 =?us-ascii?Q?4fYWCf+fx+pVZ0nMpm4lidnlyM4pa2T/WMpl6SLBw5a8eOc55AHxWcEnjuiU?=
 =?us-ascii?Q?mmD8nLXkoI2MpnWV9dJZ+/j2Xazf31RVs07k4IoUhFzo3JuXaaDkr0DFQBG9?=
 =?us-ascii?Q?F4DZUGATtRwm8HaaXa/ULFvajzggMxsGf9h/u/qYn+bUG8dvPqVpYyu7JRlM?=
 =?us-ascii?Q?ga8f8WS3A6dA1TOJk/Q8sEC+CnpnODtW+wPxbc47gBGLO7Z5qwrcoUooAh0R?=
 =?us-ascii?Q?qFn0cQpVZsDmnynAiMzHQ8TOIfnUIhLs76prUFgWFH2OfF2X1CU1AMWbV6iw?=
 =?us-ascii?Q?wW4+FWFyObalixv+DuvLi91K8D7Fq+neP1T0Q8ufFAL4GFBc5U8jsc3vKFns?=
 =?us-ascii?Q?5S8Ar6W9zPMInPB3X1QezqN3VcWO+gefjV/6vbeM1l02qTQHHKq8wKPFst8+?=
 =?us-ascii?Q?dS+mGnfXIjpZaD5crr+GhwKiVF+9Zi4RAAVcn1DOiJktdxyxeRyCeVF5NHUk?=
 =?us-ascii?Q?yFZqxFZ+Xr5fxh0jOHlC3uO+P3X6ZC7N+tim7uE6ViWY/DAMXEhvyLRrePd3?=
 =?us-ascii?Q?UrnEXpTNc3pSiK66Vu6zq/cRRsFKr15n3Px+yi5xlzmpPLoGsdCsG63UL56u?=
 =?us-ascii?Q?OzvAtx+w130gqYecyQh9VC2AaVZUXYCk2syE3dDkAwuisjFI8kj1X7sKYwg8?=
 =?us-ascii?Q?g3JB0Q0//h/kftsEs/i70L05Cm4Z89ACSih1HRPFDY2Q5GNs8rUJp+uFAV6M?=
 =?us-ascii?Q?IZD8PGV30ssR5N3Aeb+rqL0XOmLI/PAb7fHfn/zOkioT7aOMzH8trelZly0E?=
 =?us-ascii?Q?P+F0bAnODG96N1od2S5crO61ZQbsrfeIH6DFTLe6Izfg/V4LKm6nRPVRyHC/?=
 =?us-ascii?Q?il/aFQpL5q3p+udKe9F70yVW7AV+WdRJlp6X4Gxiqpmtirs8CCk5V4g4I/hv?=
 =?us-ascii?Q?gqN8OuAOr4d3+FziDWRfOeGmKbMnMuWjB9IF2CQ5hV8R1hCW/m8R9TlZlhGZ?=
 =?us-ascii?Q?/hsPSFCpTFMNkLyNeARo2xmORI5Po0xKh+22FFI15IVUjlYMcGYCJuMljQ/9?=
 =?us-ascii?Q?3i+ahHkoCtDVac9RfeZrV2iBrwJxj2kk3QYWResPsw2v1d3bPnThwdEqUp0g?=
 =?us-ascii?Q?prv0rl6pMbgdN2uUhnisQZgU5BRT/wECUDxp3sp4bS5uSQRMRryTPBiIzVyS?=
 =?us-ascii?Q?Le1D1R6FgW7h9lwKIgJEtckEPsnAmEd6HXBfIVkPPWT8X67HmWxrOF2KQAjO?=
 =?us-ascii?Q?gQdL167/TrQJHQeYF+lSUtEW4xRLEy/2TZPlIChLz9MW5MaogQfZSxRFZUqw?=
 =?us-ascii?Q?4bWFAGDyg32us4kqbUV3Tj3do/Jd2i0FfBS1WPauveelw+d0hjuFNDSLdOi1?=
 =?us-ascii?Q?2uEyt4boe/7WKKveoDLr47xWxjz3Yruaxg+7MtqxXYWOvbfaTUtCZDjW4egv?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d06860c5-0ef2-42c7-3892-08da6fe381d2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 15:20:15.5768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AvEyfuhuNy0guCMDFcMB4rRFs2dOTS8MkBYkO/3kKUUSGCsYD+0uNBJxdc9KBh7bZMZekZZ+LPZgZat97ZWJUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB8063
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation/networking/bonding.rst points out that for ARP monitoring
to work, dev_trans_start() must be able to verify the latest trans_start
update of any slave_dev TX queue. However, with NETIF_F_LLTX,
dev_trans_start() simply doesn't make much sense.

DSA has declared NETIF_F_LLTX to be in line with other stackable
interfaces, and this has introduced a regression in the form of breaking
ARP monitoring with bonding.

There is a workaround already in place in dev_trans_start() to fix just
this kind of breakage for non-stacked cases of vlan and macvlan. Since
DSA doesn't export any flag which says "this interface is DSA", or "this
interface's master is this device", we need to generalize this logic by
traversing the netdev adjacency lists, so that DSA is also covered.

Link to the discussion on a previous approach:
https://patchwork.kernel.org/project/netdevbpf/patch/20220715232641.952532-1-vladimir.oltean@nxp.com/

Fixes: 2b86cb829976 ("net: dsa: declare lockless TX feature for slave ports")
Reported-by: Brian Hutchinson <b.hutchman@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_generic.c | 37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index cc6eabee2830..fb964e2b0436 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -427,20 +427,49 @@ void __qdisc_run(struct Qdisc *q)
 
 unsigned long dev_trans_start(struct net_device *dev)
 {
+	struct net_device *lower;
+	struct list_head *iter;
 	unsigned long val, res;
+	bool have_lowers;
 	unsigned int i;
 
-	if (is_vlan_dev(dev))
-		dev = vlan_dev_real_dev(dev);
-	else if (netif_is_macvlan(dev))
-		dev = macvlan_dev_real_dev(dev);
+	rcu_read_lock();
+
+	/* Stacked network interfaces usually have NETIF_F_LLTX so
+	 * netdev_start_xmit() -> txq_trans_update() fails to do anything,
+	 * because they don't lock the TX queue. Calling dev_trans_start() on a
+	 * virtual device makes little sense, since it is a mechanism intended
+	 * for the TX watchdog. That notwithstanding, layers such as the
+	 * bonding arp monitor may still use dev_trans_start() on slave
+	 * interfaces, probably to see if any transmission took place in the
+	 * last ARP interval. This use is antiquated, however we don't know
+	 * what to replace it with. While we can't solve the general case of
+	 * virtual interfaces, for stackable ones (vlan, macvlan, DSA or
+	 * potentially stacked combinations), we can work around by returning
+	 * the trans_start of the physical, real device backing them. In this
+	 * case, walk the adjacency lists all the way down, hoping that the
+	 * lower-most device won't have NETIF_F_LLTX.
+	 */
+	do {
+		have_lowers = false;
+
+		netdev_for_each_lower_dev(dev, lower, iter) {
+			have_lowers = true;
+			dev = lower;
+			break;
+		}
+	} while (have_lowers);
+
 	res = READ_ONCE(netdev_get_tx_queue(dev, 0)->trans_start);
+
 	for (i = 1; i < dev->num_tx_queues; i++) {
 		val = READ_ONCE(netdev_get_tx_queue(dev, i)->trans_start);
 		if (val && time_after(val, res))
 			res = val;
 	}
 
+	rcu_read_unlock();
+
 	return res;
 }
 EXPORT_SYMBOL(dev_trans_start);
-- 
2.34.1

