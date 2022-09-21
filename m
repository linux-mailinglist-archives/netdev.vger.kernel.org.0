Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8D45BFBCB
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiIUJ4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiIUJ4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:56:51 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20065.outbound.protection.outlook.com [40.107.2.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2CF111D;
        Wed, 21 Sep 2022 02:56:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOpSbErnE8uXGgvRpkXEKYtlnPwPUKomrzf2THL8ByueyNHnWj6FGVh+32r74IrztLs3IR4OoY0pL9PeeVJ4COAerrpwzu3OBHnFsqM/+t0avijjMepootvqpPEQWroXvR0uqZg13aD0oK2BJZkWpiZ0NEnfDqXN/LWKaZJ1fQPbxu+iN9j/qSsx2eVjhm8TQgVLKyEWNVaAcC/KDg38ztLOCX11+h9jD+TOAYOLfdXZu63B3NKX9tCLDADjE7G7SOPl8AeMV8qLfGTZL18x6JiJCHhaLXSWwsxkqDkOsAjsj05pB2Y93zRhvZK7D36XLAk7bE/3WFRFpvbEkMUMeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8ev4+Nh0k4rNpxqrgTEfFvpwB/+XSnYrJXddrYllpA=;
 b=EqxgCFFBz7Q+NzNfKwBfzCsquZb7VoNcchrRMTiVytEysxM7b6V0fD8pSM3cOsCsS6PpGI4qFjuRsWw49l5P8P3xcveHp4wG5Ut55lTtAMrWjkqscvbBW6bRivfUOSi6loBzA2P5CjquxpNgptD10GdpYxbttvIdirBUww/YaAf1ZsgSNyKRjzlc/MPDaCxgIbpp2E2fh36/GkElgzMbCXwg2ae7KNIKtXdl+AUpncGU2TcesEt3zwErl8ER4kld2jfNCN0AudH60T5kyHpXT8MQo5QuVvxVF3T0kTd+b7/x0cwJjrAp42RVN2mFP1l6b2o3id6DJqVbo4SHIcZybQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8ev4+Nh0k4rNpxqrgTEfFvpwB/+XSnYrJXddrYllpA=;
 b=N8cBoiIBABS4DCNzTHtVYM81jGmDyvhK/mlhieDDoee775OOiUFybBNn3gpVCyLioDWAtvBpanp3OfS/0wg/7MC5S4bQnhqbTUhD1xcC9gbnFBAbF+EjSGbYxTz2Szn8l4eXmtT/LBNeCrYohYfCf+4EseVH4fDb3bdpFGswNIk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB7490.eurprd04.prod.outlook.com (2603:10a6:20b:2d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 09:56:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 09:56:44 +0000
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
Subject: [PATCH net-next] net/sched: taprio: remove unnecessary taprio_list_lock
Date:   Wed, 21 Sep 2022 12:56:31 +0300
Message-Id: <20220921095632.1379251-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P193CA0022.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB7490:EE_
X-MS-Office365-Filtering-Correlation-Id: 81935b54-66de-409b-c254-08da9bb796ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NOdij3/KtZH4KCSDJe2BUhDGJV+gWvzva5fOye+XNxSJY5wqhKL3a0OUqujwPIgt4iF04MIx9ZoZ7HElVTujQrhtdBJr45Vzmhghuh+0PIxrAheaovpsMUEB0s57E7r0jH67M81LC7fmWceIIObX7UuOarb8NOgTdsXamP1ntWeEy4WXxXopnTAGBIrtu5PwN55pKJt75M6VgXA6W7vxKDH0lpgTq9XTaEKODmTulRkTeHZnBXZVZ5cte7GZ64577isRZ31XyDL0TMtqAc3mBnjZaPWwmxVaXGMgrUOxmoTOh8og/F9WnAogmIqrCX56B70UWf2b4ueBGwYNWJexa682/ucDWINh3+d6wh8dmi4ApWGyR1vwg5jHnwmFphr74QfAwyNdGXW/5RQdEclEgmhWJF7c+A7tiv2l14z/WNh7DDkIu7ne6EP73FaKKx3o5El8kaWmU+GxgKBTtNkR3FgaiK2/CfZOPOVeeYxM+Xh4hnRDFK/soY24cHWp/KlZwSU0lH/sotTiLn2D14Z7opdaTewRMS+qOc7P+vvqOquiJ9NIP3TWky/UUX+myT4DGuZGYmB5ep/R/GkdwBc9ja0aIoXZc4dqWvEYTynVkLN5OmW98bdXo+r4YsBtH4bh8HuF44F9802zhnmymK6fsALAK8loXvRkqbP0zDaIvpKIlNREVk6BABPlBt9YA1evn4p0ibAgSFlVb/dzMx/o4H4qY4vesKL1uBQrgLsrHs7Dzxhfrw8uvwT4I+FC5q4T+uZFP0EB+3cTqZJ4tl4qLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199015)(6916009)(86362001)(186003)(83380400001)(1076003)(38350700002)(38100700002)(6486002)(6512007)(6506007)(2906002)(6666004)(52116002)(26005)(478600001)(2616005)(54906003)(66946007)(316002)(66556008)(41300700001)(44832011)(4326008)(66476007)(8676002)(7416002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uJLpnAC+wBcmROSKmD7zeGROvs2uXLaqIZ1Bate6b+O804izF3VHI8RSoVWi?=
 =?us-ascii?Q?n9IT9pGBWXtkEjU537JbDdXEbXdJSdxGb+dV9EGH9zbtSVUgXRwEdtMiGMt2?=
 =?us-ascii?Q?qyFRGdaRU6QzwlkZr9TDBka55ZEekGXdz69yBIqJq58f5vW/ieOkKEfVcwL1?=
 =?us-ascii?Q?dez3Xu9lJ3VovPtCURsTZU5nrgYxpIn82Q2aKMdh/8F/n1h+9oELqO1lkhlN?=
 =?us-ascii?Q?ov4RlqW8f3cZpxMP9QsOiVvKa6siewvbZaW6nS9D99VMDUC5briEATsxHlgI?=
 =?us-ascii?Q?FI1lWsnu4iK/4D50NDeMRjEIBIMALpB1MoV/3hRfl8iEqkCVH2qbY2tA+NhT?=
 =?us-ascii?Q?jId0C+/RmmX80Ji3t+xU6iHrBwLo99GIpzulRi01A4yrRginh71ml5h8r8S/?=
 =?us-ascii?Q?bvogrrisjlFY5cyS6cxlkiDhBj7uXGpBSwsur6tjfBWZznstTH5mzfQAAmWb?=
 =?us-ascii?Q?9M7GAv7ki0R4WAx7iMYZZRhg+ZyEBfe0DHX6RlQdjuKvx0awqWcfjy2n1ZuE?=
 =?us-ascii?Q?J1phuDZv5H3/NszxYFjAfV5bYZBdW2bQsQcxDDPTQlYoD73LBONC3u08Ek1s?=
 =?us-ascii?Q?r2XkKpVQvSgESGRHN1rw1QHfHAIWnQDd39FYJg2iF49BagDT218iezQgvl3A?=
 =?us-ascii?Q?h68Lch9twKfLE6WUNuJPuSs3/CgbrDSx8Sw3WctcYFXyF4RDDl7JiDPrrT/2?=
 =?us-ascii?Q?q8Sc94Z58O9lcMgTTZp/97LfJkp7szEXpbq5C9/fiRkE8Yl7eyDPlclexH9/?=
 =?us-ascii?Q?BihVYyajT+MPwjJdGjFBTWalgzaLdacNzyJdhuHVmnCh5IdWYdUX1FPxIZLw?=
 =?us-ascii?Q?o+Y3lx6y+FnYOtY7cI00UrSLsFYeYbP1aGcAntzSd8/Yx88R30nzj+LdEkd3?=
 =?us-ascii?Q?g0RjJtIJ08B5turyhpUBUFn+0wr7OXH0bHo9+MYwNx6DjnIKMA5yhF3ehwt9?=
 =?us-ascii?Q?6I+yjVwjtbupYTwU8F0g7NnnG2TrzhfEHkgilqzsgoTFkiustWpM5xPW140R?=
 =?us-ascii?Q?qG1uJrTRPS461IA58A8HZhsG68BKQ3Krw4/2CtGZrorHwN5slmryjn2fb82r?=
 =?us-ascii?Q?Yn6IPmhZWlsNOCkf8MxCwVdtzw0yzxsxslI3Voo27SebOyhuxhaYdoPnDasA?=
 =?us-ascii?Q?V21FtzPa9KASbv9VCvd66xEEMpEDn9sn0PZ3T0AIGGEKXLbzs0VU8Jcn+YnS?=
 =?us-ascii?Q?ZQcLLYINCnUHZqHjhqdGatVVUWaOFBg5cBrUR3dMZasLq5NH5Nzp/vu7h62a?=
 =?us-ascii?Q?15F6tyE4ZqP+veGtkcDCPT1TewvqPcEtsgSE8pd6mANAfJWjDLXrp4+7WvDV?=
 =?us-ascii?Q?vN6/bniomMkPNTMHdbkO2ilBV1sUdrtxMQKVn2+dbOTsXM+UUNsnAWzUiwgw?=
 =?us-ascii?Q?WUpFCgF30alm4DIrN4IJ9TAttIXuLCMBfZ4Imyx/EhsSy+f6QI6n/E+i9Bup?=
 =?us-ascii?Q?6YAZWngQcQjY8ld1Ro6O2cgqudc7iXlaliI/WaobumI4rinODEy1nUPaO2i8?=
 =?us-ascii?Q?qT1+aFHQaBQIvHmw8GMdbOf8UtueNBl1baq3DEI/E7gaoUfo6YXJRAxkH0oF?=
 =?us-ascii?Q?latWLdDAJdX5GsjxN4NizmPM01SxXK/Jv4JFJK+6FW4DnkNlX5tBbNA+pmJ0?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81935b54-66de-409b-c254-08da9bb796ed
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 09:56:44.2643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rrIl365MJ0zPE/+GkeIlauWnOQHsKDGdopjqBMei4C3ZWQeiMwsd2pdHm998cbaPOmmooRqXqqsDvVHAxHmhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7490
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 3 functions that want access to the taprio_list:
taprio_dev_notifier(), taprio_destroy() and taprio_init() are all called
with the rtnl_mutex held, therefore implicitly serialized with respect
to each other. A spin lock serves no purpose.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 1ab92968c1e3..163255e0cd77 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -27,7 +27,6 @@
 #include <net/tcp.h>
 
 static LIST_HEAD(taprio_list);
-static DEFINE_SPINLOCK(taprio_list_lock);
 
 #define TAPRIO_ALL_GATES_OPEN -1
 
@@ -1082,7 +1081,6 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 	if (event != NETDEV_UP && event != NETDEV_CHANGE)
 		return NOTIFY_DONE;
 
-	spin_lock(&taprio_list_lock);
 	list_for_each_entry(q, &taprio_list, taprio_list) {
 		qdev = qdisc_dev(q->root);
 		if (qdev == dev) {
@@ -1090,7 +1088,6 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 			break;
 		}
 	}
-	spin_unlock(&taprio_list_lock);
 
 	if (found)
 		taprio_set_picos_per_byte(dev, q);
@@ -1602,9 +1599,7 @@ static void taprio_destroy(struct Qdisc *sch)
 	struct sched_gate_list *oper, *admin;
 	unsigned int i;
 
-	spin_lock(&taprio_list_lock);
 	list_del(&q->taprio_list);
-	spin_unlock(&taprio_list_lock);
 
 	/* Note that taprio_reset() might not be called if an error
 	 * happens in qdisc_create(), after taprio_init() has been called.
@@ -1653,9 +1648,7 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	q->clockid = -1;
 	q->flags = TAPRIO_FLAGS_INVALID;
 
-	spin_lock(&taprio_list_lock);
 	list_add(&q->taprio_list, &taprio_list);
-	spin_unlock(&taprio_list_lock);
 
 	if (sch->parent != TC_H_ROOT) {
 		NL_SET_ERR_MSG_MOD(extack, "Can only be attached as root qdisc");
-- 
2.34.1

