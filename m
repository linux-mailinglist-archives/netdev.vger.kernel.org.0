Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF505B29AD
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 00:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiIHWyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 18:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIHWyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 18:54:11 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2119.outbound.protection.outlook.com [40.107.20.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBF41316CF;
        Thu,  8 Sep 2022 15:53:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQlD8UyJM8Odr7NbAqnwKFNPpe7qIiZF6l55WSyEzTKy7wCDDWwBa4pVVeaapQil4spepKMyxnLXNqoZK5cRyEgxgHjheNNJ/pQxHSF/SMWUUDwrc3KK5sTUSB5citg0wEOSyRR6Dabhz5zb7AXpOG0/QeVLOdFZQnT7YRcq1DU0J+VttUPVXjoTkCBl1gVYmRFG5G61Pr8docZULyoPRRxE+dt/B7KCiR0FDNiCH3XBR96L6oEtm3ryJzYsmHoshU8tkuDdFDseynHm1gI1Aw+2XGJ3juQQQuHHHYdphTWIEN/YTRLfHBbzRtdn/0bgAnQWNRThKuy++tjcpJ1PSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8iQ/Uz7E7sgmCaWO1HuIMCTx2xdKxTxx1S2zYKZ5ynw=;
 b=DFKQctTy9KHEQb878W/drqWabXPRGs+9HNi/kKIG+rI+CqXT5ccABvD+W0u6gXzI0JMD+ocmwWwEd7Ui8k8DOebydC4Hlbq/nnaK+Q8QRZKniPzeh5brWPFuTPQcmSOzu42wx8aifodzyokXpVgA38AdXsAMTG16wnkPsGIMXl2wsPisvYiAT+nbOuFttphvsPgnlTu8Q43w9zBPHA12mMiQcF3GlE0Q7dldMKXNffVbOVFUbmTnCyaKHuMEBAbdLbPAK34IbFvQCl/sF2gaGI6soQ8NiSeZdpTtil0gR8M4PJQJgYDNQmT/1jYDf6/T4nOhbmUoGzb2zeMT7MAwPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8iQ/Uz7E7sgmCaWO1HuIMCTx2xdKxTxx1S2zYKZ5ynw=;
 b=XtVWAC0iIsyVJdQ9GVJPY+KoPUAKDueyVZsyMNS4CwCOQSlaZ0NB9arluyllSCALi8j4tm3+hpJvx/x14Z7HDr5bBb5Evr8ITPQDImK1cYKfuRI1BK1LaZdyAtf68ho3I8Rrycfxx6clQDb0mFOZZaYd0DYekTitbQ/8q6P1lCA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AM0P190MB0737.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:195::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Thu, 8 Sep
 2022 22:53:39 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae%9]) with mapi id 15.20.5588.014; Thu, 8 Sep 2022
 22:53:39 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v5 7/9] net: marvell: prestera: add stub handler neighbour events
Date:   Fri,  9 Sep 2022 01:52:09 +0300
Message-Id: <20220908225211.31482-8-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
References: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::19) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdff471b-029d-4e69-1c6f-08da91ecf834
X-MS-TrafficTypeDiagnostic: AM0P190MB0737:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6LyiXpsOIRR5yH7MdXZncscoK063SYIG2IE679lXKLry5EYqS4+Hogy3+4vRHwNrlTvro2Xgdr0lVWlJg2w8eM21tDXqe5aa1bAuZwbqiNNyq2bBgdPNjJq/hTKVRYDkqj60trOOUfy1R0JOAaYhTa+XEVCVgbkywcSLVDN9MrVJ0eVDZBz625BWoVdhf+HGawNMUb3P2aNeywIohk5oL0cDg4b+tdG9k5WXyMy5ACg5BLhvDpGbctUWnAaKqY7KZ2nP9A4bHjRXXwlmjI6hH77hiqLHgLYnyX0lBk3wFdnNgDie40sc4KJTBJnWDyxqIt6ZDy0S39ZQWVDEe153TVW/olnlR/EuwT2qZutyjkxvYM2RZ02uZLtQJIM0d0yziCB7p7g3Z1BxsDiUDUzPYEWajD5UiM7uuDO6H1pQgwDUJyN9ZzxosOQ+3FezJtB3VhRBZYVpiduNMvF20Wk/OS+TW9h7LiqbW+aVZTaQsv7M7zhKGtS1QzZhxUyoNc8RvS8+WpGXytRn3LxwScGfxHXpgz44XO7XrNOFtkk6snvzzm+49XrB2R3/uOLMn9e2vySuzaP5P26Cz4XscpSplSQuK9/OAx3l7EK2voulFHNJd+yVA4bDy0myGoxz7Ayd5rkH8cg3Lcm4/PaqpqL8mU5/blq0EXdU30n4WeUMoNjSLQkGjC+jwINvO1UCBH5uFc2AHTCy8eRdsKV+xc96jQnsjcGAFqooKnMUOBV+OLrF+WcPt9e53geDUI44ng+w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(34036004)(366004)(39830400003)(396003)(136003)(376002)(38100700002)(41320700001)(86362001)(38350700002)(66476007)(508600001)(66556008)(4326008)(8936002)(107886003)(5660300002)(6666004)(41300700001)(8676002)(66946007)(26005)(54906003)(6486002)(6916009)(316002)(66574015)(2616005)(186003)(1076003)(83380400001)(52116002)(2906002)(6512007)(7416002)(6506007)(44832011)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P2EAkgwFxhb7LXU0YFqPqbgqRWN/LQcNnlp36dDD5unuCJSd7UImUJ2gnLlv?=
 =?us-ascii?Q?HK8UvOQXYMdZX4vHLzHTmRPBQUNLgNWW5dNZY9mN2vbPldmI+gaM67Y2PVkO?=
 =?us-ascii?Q?NOSeLO26tHnem+KSIHYXT0/oGhLEzLWj7NSdfCfhW/ROTJ0PuyZGQ480YM8O?=
 =?us-ascii?Q?XnnYe7HhKTpPrPcxsv8nbR0QymBkHoO7LAyGn4Y4zc6ffsArTjKnaRHg2gsS?=
 =?us-ascii?Q?1BXd9QDHbNBegGXfRNn2WuTMOJnHtvEwZIM3jd4kOYYiv8F687wKqc828gX/?=
 =?us-ascii?Q?NELzQG7ibiI0yStfyfaQOabW8fvqJ2TFyxvfAcV7QaC/Dh515TIT2FHhwmKY?=
 =?us-ascii?Q?CZuqqm+nsVDpAV+430qyKDF5RyA9B5OpHa13f8zgkvIhLi6JyMXisRgINdXC?=
 =?us-ascii?Q?adq0ueb0vK01X0SfZvOdNmtz01Q4mkmntHe7BUNTPPTBSC58OwCQoH68eBBv?=
 =?us-ascii?Q?CYoQ7RmDBxoJfjcXW6fKVUJaO1SHijKoXfCHY3S8i4NDNbp1dWngeUyIuCuA?=
 =?us-ascii?Q?PtqnltXbQ3GgbItMewCwkBEj4Kb+neFx/HRUq5hls7VUdI8ZnzjhgtI5lE9T?=
 =?us-ascii?Q?AkRAgGIzvtdTF8kQBFto5fai3f74gee9AK582CZJ0gV76JVP5TaGUpedAmcz?=
 =?us-ascii?Q?85ZPI7BSZdLWNvwIqc+ALwzTgbZAFYdtMd3FE5rUZl+ny49X7h5/mY6d3A5A?=
 =?us-ascii?Q?a6jrBu6bwwvVsBHpQXZF3v6K2h4bWe5A4NvUiGWQvkQPZAp2kgyDLxBve25M?=
 =?us-ascii?Q?hf/1KUJ4nh6ht71LWs1/kAG7+KkdSydIaEfqaXQ9I2qGta6hhhX1bW0W88q5?=
 =?us-ascii?Q?v1pPNTnU7h8rJmGmCW9v3xNkVXvUVQr1vzUeWEbuc2AVptMGSHN1h0d92P/8?=
 =?us-ascii?Q?mRYvaT6uRvojDxLir43jren9r9qRHlttoeHY71xL4w3zPc1yOA02tSnoyVLR?=
 =?us-ascii?Q?dBrjNmg/lvY1RjnWsamV0qQkRoVzvw/Xzo+bdxikAjrXiR0RH5m6PVLb8NKV?=
 =?us-ascii?Q?fy79R69btk+IeJaprEdPwTxvutZnuDdIIJsym7LFkINuObnPzQCM7X6f03Sf?=
 =?us-ascii?Q?4FKVWJzK+dKmrB8iK+s9bod9WYqDozjkklKOgwsOOj11gNjS9w5Ri4HMES7E?=
 =?us-ascii?Q?P2pzz90kzpy49vuDfMA5YtIa0wFlg+7mA2X4ROLJWkPwWxwcx5IDP+2vLyhK?=
 =?us-ascii?Q?JM5YWhNTq+qFHcyByuw2THBiv6OJiiccnTVrTv3Yil/8TN8DPQadzVfbC3WQ?=
 =?us-ascii?Q?s40t0cZem7KBdWaVF5QKAGwbWSPED88ua63DCanIba9FrTQ/1Kh5CzXeoAy7?=
 =?us-ascii?Q?tObc9mS+JyxksVA9/W8dLxY3xVXvfqSr7mipPMRRMY74jCjyA2KC6xWv5r74?=
 =?us-ascii?Q?K3GS23J+rSOw71WGd/WCim41BET3y9sDX9Nmn+xWf0mcrSkOe8GPel7iiQ6s?=
 =?us-ascii?Q?DY3onog4chF/nUML+aaMDPqXsgnBriP0clchJein2+prYbgxCOUTU/USZO+4?=
 =?us-ascii?Q?Is+5jwD3N70GvCH+1X5CGkJGu8mcWWu5KzDXgQJao2WKYOufSieSR7/HfjjY?=
 =?us-ascii?Q?VYy6Rvy8q2CoZ90wS/iiS16YvDWTJgD5NqT+Uuapeole/33xrC+fQj/l2ikm?=
 =?us-ascii?Q?vA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: fdff471b-029d-4e69-1c6f-08da91ecf834
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 22:53:39.0082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JI26oUrczzicymnCmxMEFDCU69NKm+OU1e3umaZ94jWw/myiWv6yf/0LW2sRkUWEDrF17IouoPCuMnrR7P7w0+Gh5r+MU7OKRG2PS1uTw04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0737
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Actual handler will be added in next patches

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |  1 +
 .../marvell/prestera/prestera_router.c        | 59 +++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index fe0d6001a6b6..2f2f80e7e358 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -320,6 +320,7 @@ struct prestera_router {
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inetaddr_valid_nb;
 	struct notifier_block fib_nb;
+	struct notifier_block netevent_nb;
 	u8 *nhgrp_hw_state_cache; /* Bitmap cached hw state of nhs */
 	unsigned long nhgrp_hw_cache_kick; /* jiffies */
 };
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 15958f83107e..a6af3b53838e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -8,6 +8,7 @@
 #include <net/switchdev.h>
 #include <linux/rhashtable.h>
 #include <net/nexthop.h>
+#include <net/netevent.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
@@ -610,6 +611,56 @@ static int __prestera_router_fib_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+struct prestera_netevent_work {
+	struct work_struct work;
+	struct prestera_switch *sw;
+	struct neighbour *n;
+};
+
+static void prestera_router_neigh_event_work(struct work_struct *work)
+{
+	struct prestera_netevent_work *net_work =
+		container_of(work, struct prestera_netevent_work, work);
+	struct neighbour *n = net_work->n;
+
+	/* neigh - its not hw related object. It stored only in kernel. So... */
+	rtnl_lock();
+
+	/* TODO: handler */
+
+	neigh_release(n);
+	rtnl_unlock();
+	kfree(net_work);
+}
+
+static int prestera_router_netevent_event(struct notifier_block *nb,
+					  unsigned long event, void *ptr)
+{
+	struct prestera_netevent_work *net_work;
+	struct prestera_router *router;
+	struct neighbour *n = ptr;
+
+	router = container_of(nb, struct prestera_router, netevent_nb);
+
+	switch (event) {
+	case NETEVENT_NEIGH_UPDATE:
+		if (n->tbl->family != AF_INET)
+			return NOTIFY_DONE;
+
+		net_work = kzalloc(sizeof(*net_work), GFP_ATOMIC);
+		if (WARN_ON(!net_work))
+			return NOTIFY_BAD;
+
+		neigh_clone(n);
+		net_work->n = n;
+		net_work->sw = router->sw;
+		INIT_WORK(&net_work->work, prestera_router_neigh_event_work);
+		prestera_queue_work(&net_work->work);
+	}
+
+	return NOTIFY_DONE;
+}
+
 int prestera_router_init(struct prestera_switch *sw)
 {
 	struct prestera_router *router;
@@ -648,6 +699,11 @@ int prestera_router_init(struct prestera_switch *sw)
 	if (err)
 		goto err_register_inetaddr_notifier;
 
+	router->netevent_nb.notifier_call = prestera_router_netevent_event;
+	err = register_netevent_notifier(&router->netevent_nb);
+	if (err)
+		goto err_register_netevent_notifier;
+
 	router->fib_nb.notifier_call = __prestera_router_fib_event;
 	err = register_fib_notifier(&init_net, &router->fib_nb,
 				    /* TODO: flush fib entries */ NULL, NULL);
@@ -657,6 +713,8 @@ int prestera_router_init(struct prestera_switch *sw)
 	return 0;
 
 err_register_fib_notifier:
+	unregister_netevent_notifier(&router->netevent_nb);
+err_register_netevent_notifier:
 	unregister_inetaddr_notifier(&router->inetaddr_nb);
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
@@ -674,6 +732,7 @@ int prestera_router_init(struct prestera_switch *sw)
 void prestera_router_fini(struct prestera_switch *sw)
 {
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
+	unregister_netevent_notifier(&sw->router->netevent_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
 	prestera_queue_drain();
-- 
2.17.1

