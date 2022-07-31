Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DBA585EED
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbiGaMlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236994AbiGaMl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:41:28 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00075.outbound.protection.outlook.com [40.107.0.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A07DEED
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 05:41:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKHcIocGTTYUo71eWqAPfrao8ZZKbyLasHzvVhbVQIJcCFohdQaqk81K+/LsL2sqtAFULHi7ZBI4PnZEMjS79elnsZ7MForu2JTCb3tSpFDzuBWtOloBffARw+J4GXlP2+MoFAYKcgZOXQq3whf4lNLoyNafsiBjqUq970WbZGVgV+6C50xAtfg/FW37Obfqe2757fvTUEBvjO5wF6vHEqJBRvOe6OVXQib6cOSkS1/ZaXpwc42WFYcsZ1m2BJvTULquDg/4lixcbM2EOE1XdmjA/pzHdfKNASNUcl4zj/mIDXUfRHmBWNcFKNU6gVJDG76WekAnq0BSihaZgvu0uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yN9gZBA3s1xAMXnB/DwIp0wMMccqreNQtqVxvPdhBIY=;
 b=h+XFHT2l/O5386B85pLPcncwBZxtmL6PLKWUAn34U30ms4MQ6vBsAvBoKkPUx1vulcLiHI3U+N67hYQxi+sqNyzffgfq0pxFWid6Oek5GDJQtYV+s7TwnRDziCR/I49wBl4oVCoFqd9uW+ZkowE+inQLXOwJQDoypcuX/mRU5rDNZSa7VmlO59e0O+0YUCyk2N/1FUgAtsfD67RIb8h9QWdAERg3nMUnmZi3Teb9YwFqkI2snG7c39l9NbK/BMJB617+OFfZnPju+W4CZ9ILWXWpJg5o9gofvpzOUJY4c51RHFnf7cuI9Sww/6SfbDkia+Q5zxRjwqebNmOh8RDyOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yN9gZBA3s1xAMXnB/DwIp0wMMccqreNQtqVxvPdhBIY=;
 b=f46lPmkjumQzSfnrkkacDhepr9ecG3+wpxblAgOGIbX+zX8bAEgZ4Wi1Y+IK9jgmqddzjaliwZpGxw1mLAj0LrJDJ8TWa9IxJiLwQFmOltWtuhI5jpnJVqstnGiCJWNvcBdQjvTmBQPmc1rcikiFmzVQRn2wUBy6jsHu4jzuqLM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6446.eurprd04.prod.outlook.com (2603:10a6:803:11f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Sun, 31 Jul
 2022 12:41:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.015; Sun, 31 Jul 2022
 12:41:22 +0000
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
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 net 2/4] net/sched: remove hacks added to dev_trans_start() for bonding to work
Date:   Sun, 31 Jul 2022 15:41:06 +0300
Message-Id: <20220731124108.2810233-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0191.eurprd07.prod.outlook.com
 (2603:10a6:802:3f::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2490e8d5-7d10-433b-fb5b-08da72f1f98a
X-MS-TrafficTypeDiagnostic: VE1PR04MB6446:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p9cTUoj1Rfc2WlRg9vHOds5TUuNZOtq4pLnrR1dql75tVBPDDNwUkCvXVuWqME8fqPI02cR5GUzdz1WyMkjIXJtulhhOq2LWjJlkEhcNhApfe9cYGf5jT0xuIJE5+D/AfEdaFlX5VCdTcPuiwWZwBbZxD0fwDxG1nJep3mHz3jG5yGEz/AfjG5DYgB/jTWF9RWSd+RQPBVO4PB4Q8Soq62f6/KAEZ7BxiNrRBno9z3OtKgZ4KHyVEMMd/0PxjjYsSsMypHQmHVZDBUxvJqjagScgc2+gJNT5ZDUpSdMTMKKJPlnjkWFh1ki8MWG7Cz3B/z/lggOS1T1x9uleiiuduq1GiJEO1Y4tNkr0ZcVzmhU2HeRgP+BHBOoTa6iuxbubRdF3os/D6yltZFn3Pil/s/KL6UED56LVqRf3/VjeEoFWxQX2UzUivVmvPuyVady5ReJfhS6JZZXbk+hrCD0BG8ctf/4M0Ga5/Ni+mwTgEm9P+Uc1xFLPM4c84B5wSqrpRgfmcoDE+fQjfi7JvuLAqhjh4irg3La20vk6r1Bf43ey34mGXjxpyVH6uBzmatPX52z3nDkm5htPBg20mddaZJ2X+cMgPCAtu66DMMBpqrYEZtc0wGLxek68FsMXhCX0A4OMrGKoq0FkjRqw9SPV7VbRysg8jGmExmig8h/219O7v1xXkbffC2Ag33NBTaZn/NlHCRlWWE4VWwHV9OTLT5FJDQsu/in/NL1Qot7FmdII7yTVj0AtwxGZNG8MkYnyfe2Il//v8mMk8OZ1b+MEkhNBKiz2CquFIQ3c2FI/Hwo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(39850400004)(346002)(376002)(316002)(7416002)(8676002)(4326008)(44832011)(66946007)(8936002)(36756003)(54906003)(6916009)(6486002)(5660300002)(66476007)(478600001)(66556008)(6512007)(6506007)(52116002)(186003)(38350700002)(2906002)(41300700001)(6666004)(26005)(2616005)(1076003)(83380400001)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L5Cmsh/6R/IUaQyxhrv/KtWvFGoDEraFnXfwbAWS8mqxqkRwyEzH2ordLAF3?=
 =?us-ascii?Q?b2H+WNtxog8vzi/xBEl24ghhx6++cydLfIoGPyfQCz7XX6QaZYjg2Fd15+Sa?=
 =?us-ascii?Q?Urxs8wsmFY1fHUqby+M4R3IUE9oV6a/5oiKPEQjUjYpcXxjhnwjSLqUV4V15?=
 =?us-ascii?Q?5FhJ6M8rDd/LduxeZewLP9di8rtrydnkP9j7RexebQ7Fg7MNQwjDTchl3n0C?=
 =?us-ascii?Q?0UJb/xyqpXgyrj1mQ0fFiemNbtHZQYRjZ+j5xu9sPNys/co7KlwgdXuVBcx9?=
 =?us-ascii?Q?b1E8RFqg3o1ebLRxf511TdK8wvhJ7uD3iHU3QUugBAiARF71aQ/gF7e3NuTJ?=
 =?us-ascii?Q?jdFkVN0QEQJ4VdxTmjE2m5EgqDT1ZEanWQo6jJqlNMOT1FQAyeVtHCVPp/iw?=
 =?us-ascii?Q?w41AIBLGxYnq1Zl6+Xg4Tr2cdQuiQpg0o1RWj9zLWoyZ4kwOW1NnczcQ5xBb?=
 =?us-ascii?Q?Oz9oOioDNeghfe4fO81HErlPWmwF0fiujkALTtVprqWm0urfK8n20YsNTf9o?=
 =?us-ascii?Q?XPbYKZi5CZcVuktE05v8jhYg6uCzXC3ZVe9AFg2LXaCFtVjadt8rOGQQXOSY?=
 =?us-ascii?Q?tvHBlW+v7lT+pC50zdQiiiWpc4AdkpnnRsW5bvq5SmGwz3GN033vL6OE/pOn?=
 =?us-ascii?Q?Oj38WYoBCt/VNqGKEcLmpo7gOY55z5qWHWh/6JFbLb4dsoAn9FiKKBoyWP1l?=
 =?us-ascii?Q?9wQZRbUDG51WUNFwZBHHCPb6Iw3qHLo8f2PTkmnFhtZhoyA/tGB0svuIxgZ2?=
 =?us-ascii?Q?/YqLb9MnR3q4tiyGqHDKx1452cAtO9G7gS/Gg8d5RAFal0BnjgHgjPmIOkLk?=
 =?us-ascii?Q?L++7Zsl4iCH5bE+mEQx0ZcULgt6hTjFzqeG6kuxqnXLKOzeD85jDx7OshUoG?=
 =?us-ascii?Q?YTcX4YASCptafdD3I8eY6MGQrdSv6qgBf0+t4vLDqSOFi/bqgQPLaG/rWU/G?=
 =?us-ascii?Q?26oyuXPUvNxXxHe3xuCzvjsxaL62LTqfT8MzjA1w7fronc+98eW3rKcZwFwP?=
 =?us-ascii?Q?LCTjWI1S08t+2Hx33uCyWeSVbYaGjzrONnJItM5XidB52NW6b4VTOxRUuq52?=
 =?us-ascii?Q?Zc5EEn6ZUuP33o1x7/FMFNxDKYP8A99i9+i2BIeGmwaZe2KUj5f73aCq7Iyk?=
 =?us-ascii?Q?7vuAMt1vjqIrc+ynek37INt80onL2hA7sFA83CvzpvxSSIRKY71nwrZIGNqx?=
 =?us-ascii?Q?oDsDkWMEjA9a8/C77f4aHCzQRUbUQpxIJFTs4ga/7zE0wy1YXtXi3h1YiiBm?=
 =?us-ascii?Q?loyVZYF3tKc9gnxuDsBSrvut+E+XysRlZ+xu+7D1u41ITjeCO1EYB0jMWbNV?=
 =?us-ascii?Q?6PKCkZ5ml8BQm8B+Vzb3Nr4n9jz6SA5wLmP0ymlVGHCR1055Sgv0uar0Nek0?=
 =?us-ascii?Q?CKLS1qWfDjmqINDC/IjS7rSdi14bZku9YceGqPlgpmQ9H0paUFt24N/wLwQp?=
 =?us-ascii?Q?VlUC9CP/OixM5RNKrbgnJYbUcrOjAa6OSu0HKcNbXEuNVDSl+yiHrcfChCDr?=
 =?us-ascii?Q?afyB4oNZwkfKR7GlWy6B1Jpd3jbftGHeoQ1TLoNssjglii6Gaw3be1PQ60/6?=
 =?us-ascii?Q?db9j2ovxStoXOBQR+kJZ2AN/FaGN2dInQWagM1Q90Go2UheauNQsVpwL20G6?=
 =?us-ascii?Q?jA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2490e8d5-7d10-433b-fb5b-08da72f1f98a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:41:22.6916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YEdsFJ7PwXManamnlq2WkE946xL5wuAaX0HfjC5dDpwVHb6gQ/9JdAaX3X+Y4spnQ2KwPRLD56DallRpJX9cIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6446
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the bonding driver keeps track of the last TX time of ARP and
NS probes, we effectively revert the following commits:

32d3e51a82d4 ("net_sched: use macvlan real dev trans_start in dev_trans_start()")
07ce76aa9bcf ("net_sched: make dev_trans_start return vlan's real dev trans_start")

Note that the approach of continuing to hack at this function would not
get us very far, hence the desire to take a different approach. DSA is
also a virtual device that uses NETIF_F_LLTX, but there, many uppers
share the same lower (DSA master, i.e. the physical host port of a
switch). By making dev_trans_start() on a DSA interface return the
dev_trans_start() of the master, we effectively assume that all other
DSA interfaces are silent, otherwise this corrupts the validity of the
probe timestamp data from the bonding driver's perspective.

Furthermore, the hacks didn't take into consideration the fact that the
lower interface of @dev may not have been physical either. For example,
VLAN over VLAN, or DSA with 2 masters in a LAG.

And even furthermore, there are NETIF_F_LLTX devices which are not
stacked, like veth. The hack here would not work with those, because it
would not have to provide the bonding driver something to chew at all.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_generic.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index dba0b3e24af5..f2bac6a1674d 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -427,14 +427,10 @@ void __qdisc_run(struct Qdisc *q)
 
 unsigned long dev_trans_start(struct net_device *dev)
 {
-	unsigned long val, res;
+	unsigned long res = READ_ONCE(netdev_get_tx_queue(dev, 0)->trans_start);
+	unsigned long val;
 	unsigned int i;
 
-	if (is_vlan_dev(dev))
-		dev = vlan_dev_real_dev(dev);
-	else if (netif_is_macvlan(dev))
-		dev = macvlan_dev_real_dev(dev);
-	res = READ_ONCE(netdev_get_tx_queue(dev, 0)->trans_start);
 	for (i = 1; i < dev->num_tx_queues; i++) {
 		val = READ_ONCE(netdev_get_tx_queue(dev, i)->trans_start);
 		if (val && time_after(val, res))
-- 
2.34.1

