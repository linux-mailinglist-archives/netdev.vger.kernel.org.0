Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9F35B991C
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiIOKvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiIOKvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:51:03 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E55E6E2E1;
        Thu, 15 Sep 2022 03:51:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBQxmG5+RfWg3SMyC2A4H5ndRL/WHD8wXjbkYcoeKO2i/VHGPriFSjTkISK9yjQ3J45uJQSwLaD3MS6eZcnK1CPeykXEtTGOptkCYZ5WA95QdJfmKS9xhUXkLvnSqwC80MtcljbQR6GlAeDXwaqKG6RioqPvWmKjA4J7/AiQSZFKO17OiYYqKB77LjWyifMsE8DxKP9vOs/ECavDX+uIXuyWUr1FIuXvLoP7rAX58VatzJa4LKAEdd/ym2msFhVFjbIQbzdiPzD5ubaCUwm6dlAqpkZRZBBC8qXBiO3a8ywR1yf6DjVpj63/b0QMrpa3ZZak8X2vylgxCz9KlaC4wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQr7htZxbs9XrBwAIu1MKm2/7liV/D5w6P1xmCEZWLY=;
 b=FxHzOiSxzWF9oiHsf5OrnVQM0ER+HF6tfuFPKDvhQX746HRg3IdgG+7oEmESsGGoQ7wXRSCyFhI2x4b+LxqEU56pHiSm1mjJroFeM/E7cf2pkltK6AD0LI9NWkmMsy8LHcF83rq8MD7mlW6Bc5OfseUImJb15jAWGTE4YAVHF3+7Ol56zstvMhsMCiVCNQ+gBAOddXlYJmScj+3/ciKheDKkMYd9bNp74KbrxSyB68cdlukvsw4WlPtvzM7AM0P6PYP3EJy87mHfpPZMtjyOGfVqf8eh+laI8sxZ0yol4/mtb6PT4NHR5B+6DNLtCa8juUgtZCTjNmVs9nUWHi54KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQr7htZxbs9XrBwAIu1MKm2/7liV/D5w6P1xmCEZWLY=;
 b=Sxpd98piiP0JwLXPPjy1AGz5fMBPm1EXDT3durKdJ8bj/YSVleR0n9nqkx4zH0Xty5XoYdTxHEJOZc0a2nFw/vi1rEjGVaQK2Z/9Q0oVzZcXpK9f+AwvJHQfQkMQh53ibCQEhBr3SulGHf6jgHK9k5A1SBtn/CMBNeqlHTK01Bg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7163.eurprd04.prod.outlook.com (2603:10a6:10:fe::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 10:50:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 10:50:58 +0000
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
Subject: [PATCH v2 net-next 2/7] net/sched: taprio: taprio_dump and taprio_change are protected by rtnl_mutex
Date:   Thu, 15 Sep 2022 13:50:41 +0300
Message-Id: <20220915105046.2404072-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
References: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0052.eurprd09.prod.outlook.com
 (2603:10a6:802:28::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB7163:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a1e846d-14fb-49b0-7366-08da97082bfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aKDPg/KtB/mEyHJ3XRv8zBTeaKk8BugZ3H/NYRANXlc2/9KSqTQdGnNfQk9mj8akpxC/gj55bnxBQGG9EpJEA4VPFI482auZnZmw6M0y8VkadckgNDJnOqofArdN4oqTxxDrR4n7V7KCixKlrha/cg4r53mO4ZKov6ZZOAP2SPJojvls22w+wC0qksT5AXJ2BUtKjxQxfEFesArRjWPdJyKW7oPTB1Up9RGGTVT4tgo0HsXP73ATNf0MC3wSr7hrsus24kjzYOe3McENJl73Zrhj4yHGClOMSsctY/2fAoPKypjX5obXg0/jZVAgsnlhVBgXEL1+loVxppsaHp+LBUh82ZIELYuBh+kh+kJYenoBO5SHtHJ5Bu3yCRkAX/X/te7uc1epyIi2D6VGbn0VybNjX7GSBjwuXvcnCeohcNqcDLyyvhL1MrYrVmbznlIxiMn7conXrfmJLb0jOG0DLAJz+sVF7wSWCLH8BLJLZzxz4lmkVtf+lPLpEJW1Fm86li3gOs4IAQsAm0rgtqt6SrQYU0x7jy/N6XcgAtUjKnoZ7ab4efPPE6I3d/827UgN03EoTJOtAXfw4aiY+OX3Lc5Sv+UjkjXNfkaZIiR7n1AEhO5ClpeYeI6/2Hj8yfxk/8crBveusiXCfmZxvjvCQH0rrQMe3FlAjGrriaqWofpwJhuC1q224rDl5fwVb/3ZeuHk9BZYz4/9UjRVHWhkXJ+oC4FOxN3iIwG4h6RW5kRo9S6SFGfZILkBxk+bJ4MySt+f4B6aDc4AggECk1GK+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199015)(6916009)(5660300002)(6486002)(7416002)(2906002)(478600001)(66476007)(36756003)(54906003)(44832011)(38350700002)(8676002)(38100700002)(6666004)(316002)(2616005)(83380400001)(1076003)(186003)(66946007)(41300700001)(6512007)(86362001)(4326008)(6506007)(8936002)(66556008)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e+tPblQxeUUjEzzO8gpNuNssSPVZmW6JjC1grBhhjsZsbXfKiAAOVKzBDzTw?=
 =?us-ascii?Q?mrwnjYqfue/J1nB3lX47MEYbbUMTZG/fy9oKZRaKqE9u0M9529GytHeCIlmk?=
 =?us-ascii?Q?BdE5yDb41yWaYsxNS2f91fE5zc661LSapEVRs6Byqd4OBqNyX3Wiof/mu9qt?=
 =?us-ascii?Q?7OyZVvxWoctiMC8MfABF2rqIpU4KwOchiC1ghXpTguCfuPYCfvjTWmNG1z/f?=
 =?us-ascii?Q?kkTVxt4ABQ6tty/Ry+7NQaeyBE3G0JU41fQPHHovn/wPL59z8ll24lp/2Mix?=
 =?us-ascii?Q?yWAmkIRTsxvKMyk1VGLO+yDj5dQQ3DLIu4Xo9RiSb1cG5ZsKprfR6/faT3Yv?=
 =?us-ascii?Q?PVYmwXtryl27hSmNGLlBQSAJ2iPKndrA1U9+x40PCpMw6GQNkYGTlECswWtd?=
 =?us-ascii?Q?ofNR0RmmcWoeLAMdz/wHYQVyHqtUGTbB/n/3dbLfE4tAfNAPkQyNByZSpcHt?=
 =?us-ascii?Q?qV01oD/SKrBsskbg1ReqCWUN0VBJNg94TjuEyvnwa7tzFKVGhqiWyuSxamz+?=
 =?us-ascii?Q?LyyUksptmm7K4kjPbzafa6aPKP3+Jr9V6dqa/HU6Cr6mVawThykH+5Zu9gV0?=
 =?us-ascii?Q?+JS/rboxM2rVkhI63xU//0h42FcWlRbYJ//wrD23MBh1Me35E+AnLDhwNb4d?=
 =?us-ascii?Q?rr4kmMofSz9aU7rl1zxNttvel5tKhlXMJ3QjN1lbBraKsho9E3LPFTV2O/Bf?=
 =?us-ascii?Q?KL70b/HkwfKxH10yW9Z4ILs4JmsCU3l4Dgt1F/XnVrSVdIzcjB0GmJ2oUT9o?=
 =?us-ascii?Q?Z9pnc62gcWDulKZ5R4SkLH5OjJHaJH/4zepxow+QuvX99gEZ6GThhBIp4IHT?=
 =?us-ascii?Q?UZNXD8fibWk6bBeZiCgNWEaIqV7BWGyJkQcW1Meug8AHwCcpwNvuqRxMLF6J?=
 =?us-ascii?Q?WqXmSgzDYO46uh1F61IPfmk/Rg1dGWeEWnbRF0MmZg3C6Ze4h7q4CpcbpCYT?=
 =?us-ascii?Q?VKGBIY627i+bTHPPRWddQQ4zzOLnPisu/dVv1vvdxMjESC3QR/hwsAT4sXMm?=
 =?us-ascii?Q?v7xvtAIVjWZvw4dcnWRgKgE5hYajE4NZk+YZWvmgg+jt7xiS7jYOpBLTzydE?=
 =?us-ascii?Q?PgyK9tHhK/qtwulayG/8Q/wBXXdJ48WrCboudzG77HxeU57X+MgTOjOBUPmn?=
 =?us-ascii?Q?XX/Gko+CiaDhdv1nFoZyveC8mH+moVgyHstLwuMJ6qt/8/TfKzix8SaoCo13?=
 =?us-ascii?Q?w4VgwaCDhIKy/IcYR0KRdjzeW84Jm7WL+nL+ROD8EXtoZDZ8jiB3jv/J9J7S?=
 =?us-ascii?Q?n6G4Pm6ELg1S4LBbH/QLgRYcOZ6rwG5u9FZpvLzcyw7MOCWjsbsCtlMkZHg4?=
 =?us-ascii?Q?UmZuWelqndBx8LIrBi+caevA/Acvjo7Zm5XZWzcW3BuGGk5GDIVQF6Rqoyp1?=
 =?us-ascii?Q?DMBSNcAUlaDm4Dm13drdvaDxY7aFPTSloRGkMWmsYh/06AA33IZhi0E4AZCi?=
 =?us-ascii?Q?bVmR8NukW4WWW28a1l2W5Bcma10SgFtUomD2D/+/NmAbYPGNU1jGhI2efPyy?=
 =?us-ascii?Q?2wdJLzfG/+Ns1gcJbUCuOyHvyN72JPCJG/O3ch8my8XH/ZnBoyPfTDm5K36D?=
 =?us-ascii?Q?YhTzHCQTo6bdNiIT02IDllJiuJsXn+qVMqcnUZduV4LhdruSGXeuButWUj8T?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a1e846d-14fb-49b0-7366-08da97082bfa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:50:58.1743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z8hKyS9zZbTgk73Wyvb6F7+Pd2K2cvnmoy22Srues+TA8cHnhy69rJXBzVTb4du7Bl2t0vlf6bv/8i3I9HsfVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7163
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the writer-side lock is taken here, we do not need to open an RCU
read-side critical section, instead we can use rtnl_dereference() to
tell lockdep we are serialized with concurrent writes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 net/sched/sch_taprio.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 550afbbae8bc..63cbf856894a 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1486,10 +1486,8 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	}
 	INIT_LIST_HEAD(&new_admin->entries);
 
-	rcu_read_lock();
-	oper = rcu_dereference(q->oper_sched);
-	admin = rcu_dereference(q->admin_sched);
-	rcu_read_unlock();
+	oper = rtnl_dereference(q->oper_sched);
+	admin = rtnl_dereference(q->admin_sched);
 
 	/* no changes - no new mqprio settings */
 	if (!taprio_mqprio_cmp(dev, mqprio))
@@ -1880,9 +1878,8 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct nlattr *nest, *sched_nest;
 	unsigned int i;
 
-	rcu_read_lock();
-	oper = rcu_dereference(q->oper_sched);
-	admin = rcu_dereference(q->admin_sched);
+	oper = rtnl_dereference(q->oper_sched);
+	admin = rtnl_dereference(q->admin_sched);
 
 	opt.num_tc = netdev_get_num_tc(dev);
 	memcpy(opt.prio_tc_map, dev->prio_tc_map, sizeof(opt.prio_tc_map));
@@ -1926,8 +1923,6 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	nla_nest_end(skb, sched_nest);
 
 done:
-	rcu_read_unlock();
-
 	return nla_nest_end(skb, nest);
 
 admin_error:
@@ -1937,7 +1932,6 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	nla_nest_cancel(skb, nest);
 
 start_error:
-	rcu_read_unlock();
 	return -ENOSPC;
 }
 
-- 
2.34.1

