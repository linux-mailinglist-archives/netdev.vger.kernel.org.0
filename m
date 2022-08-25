Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307915A1A42
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243780AbiHYUY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242770AbiHYUYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:24:42 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2111.outbound.protection.outlook.com [40.107.20.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B47C04FA;
        Thu, 25 Aug 2022 13:24:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/N/Q4DBxgX31zz6rwjhXH2CcymSlYGFIteVyZaO2nGKipi2yHp9a2h/F52EiUa34zr0Kr/nPtuzrd58OtYmCvZNoXE094QZ0LCDnF/XZefiuw4Ld7TGgY3TPyfZsEgp1dacwYF329S+U7ncIrBtpF2oe6jjiETCKCZcQCgofKkzKr5sOB8FPc5d8AYw/LDOoq6HSn8m1qxbPmaYzZ6TDc3NKO6gGvZqVc+x/JrM0t20vNKhQKGU4brFXixC03vljbSQIrG01z07O9m16eaY92WX1nt3vPXyZYp7l/Cv0rkN8PNq5CMNn2U7nk4ldINNLeClu069DuLsJesjlO/OHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aShTzfH4tPkaX6WRgjiULUNgOvcP4Pzmcq8JlODhLKs=;
 b=YcIK4QyqZ6ryAfm+5LUgAg4AAh2gcf7gKhtX7qLyXTkEj2gB32leiewGOxql9kyOUI8nZNSZ2Gdf9k/f7EFjLmLKtHsRNIGqpY3+ilsxBSoLFayBa6g3vrW2gwkOmjTg0zPGfwpUp1nQkDUEtFOCrX/E9ogNEF8rFxDjO1jpYaarz9j3JCiX3BwWHxnc44YqmR/itqcZyDucJQsnPiH+OkMD484gM3XBZ0cNg2uEKKE66T5iZii2cwFmsLavTxPOG3P0zFNVI0h5f3LEEXjUFiEoaHJtbGpyXjmwd5l0eN+vEhp8ND5c2xKdM3K17dFGz/oSn/RuPy0WGEmf3Uf2Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aShTzfH4tPkaX6WRgjiULUNgOvcP4Pzmcq8JlODhLKs=;
 b=ucDOTjF9abS7NRB3zl3x5T1N1RByoqMcCWBzx+Fof4Q5Z80tVIVvUqRXAHmot+LwdvCjQB65/roT08oE8G6MlVkpVnlIIaqNNaKezw+vpoA2zRtgyBiZcUMW+y8+ss0T8jLdWrm9TQQZpmh/NqJ4WGTnlvMJh3aEKZ3g4NbhxCs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1621.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Thu, 25 Aug
 2022 20:24:33 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 20:24:33 +0000
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
Subject: [PATCH net-next v4 7/9] net: marvell: prestera: add stub handler neighbour events
Date:   Thu, 25 Aug 2022 23:24:13 +0300
Message-Id: <20220825202415.16312-8-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
References: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96cd3c83-6e46-48ea-50d1-08da86d7d233
X-MS-TrafficTypeDiagnostic: AS8P190MB1621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +tJx9F5mEXml/snGP4YeELUKJsVhLKCmmIBnTfePrOqfcHEIbhRrnnDZA3p6Bvx89pkfII/bP/r6qUinbdAQtc6AoLbkNNQ0D7wXMlNe253UXhPQrFPJWmRkFqC9kgFTUjKzRRbN9z7OtbCn4e64ZS6x8gGp5aJowaVbSDLQEAOdld0CY8EgfojgVGMN/6+WEy4q73p+NjjNGDx4BiC0OMi3bwwtLT1PZsxqkBkx0qYEvoNtOUnsawKWh1OM90iENn19mnKlViUWY5j05n/ai9xOiTgUjmL4ml0dQ+OIhWrRRoylGzhWFW5ci5W1b2BNrQhjwMp9Zf+MGY4y3EVhKybwdyp+bt8wm+4ExMl7EfDGFc01QiUA0b3w5Hf469N9Jrz1cNnZIQ8eTxB/kk01QofeHtcq+l6yww2U/uccdWsJPh37N2rDG9wke78ZkeRP4x+uQxDjGqCHW5utTDw2K7mWZE5LsbRPSXD8ZP3304IQAa3GwM8OWJ6laUoA5YPP11vhfLPfR/GIkKDE/JMCoyTDarL6gu2OqmFMaNHZEyCkKB2rlrJHtZNLwdvDc8aeAZO68vEGsw+Iv9pCF7ThX00n1tDsE7XOKfiN3ZdauZQ9hNV67HbCzpReXosgURE4Vl2h+J4ZkiGdfB9Pev8Hk1pgIhKukIG/o+4zY8qd3pyVoWtCvxWVmyx/ki/cn4uExwnkntTafp6mJPTEPGds9jCmcr3iDPdG5mjmdZYQlSuBSXqkQqBK1BiU1zTIxITs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(376002)(34036004)(346002)(366004)(396003)(136003)(6916009)(41300700001)(26005)(4326008)(66556008)(8676002)(86362001)(508600001)(54906003)(2616005)(2906002)(8936002)(52116002)(6666004)(5660300002)(44832011)(36756003)(1076003)(6486002)(6512007)(186003)(66574015)(107886003)(7416002)(41320700001)(6506007)(83380400001)(316002)(66946007)(38100700002)(66476007)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RDtPqvPBqZDhx7DcWdrGDtlnFJBiPkgJJEznfERO2nOtibK8Bkqdw7dOQyA+?=
 =?us-ascii?Q?YaMr/tSrEm/tIcvuPcZ0kY8KwPD4SXfTq5VmEKrx7qJRo+isgh2JtfH+seqP?=
 =?us-ascii?Q?ERxq1REPuRAaJ5QJjtprg+O56Oig9GbKlVcQQKTQtGZ9mYahyrjF72brbmW0?=
 =?us-ascii?Q?/uL7u+akT2cI/bCynuNUi5J+GfciN3q0+w95+JUQdygN+n3K0LmmlWSloGk0?=
 =?us-ascii?Q?jHoJp+XjDkhn4g9wDTnA1Kx0Oph/JGDww778TcM/fCpQnSc3SkHk2OTR3XWP?=
 =?us-ascii?Q?OiL8ABx3j2Xs+A18LaTqSw+59iaO7oInHT4lpZPKvyrk0411k/V9odfI+K4I?=
 =?us-ascii?Q?Czm12pmG0eT7X0I58VBTKdod/N2eGeobgvCqOUp/jihTU2yGPq71EQav3tDr?=
 =?us-ascii?Q?grDdZax+Qg+tGm8+s249C0puK80yyd/Lii8B1+V4oHC8Np0mN6nXGrhk2NQB?=
 =?us-ascii?Q?LeFsAVcXyM2VCgh7glkSixQU/LrJk1wsCpcar6q8Fpov6siMWHKdOdeDesjM?=
 =?us-ascii?Q?vbV2BS72OObKBZemoDkRGWRZX1KJc85DKedbKEN9BtfamvFIauFtgTfJ3hun?=
 =?us-ascii?Q?OnSTDCJfXeL4eDf55nxS33+e7fyJBFdy6+lltWHl4p1GYNO5r9nEx+91OBjc?=
 =?us-ascii?Q?EbNrXRntCd6awf0GHfTtkZK+v+jHKGvz0wQRH2BH/KHImG25rS/3iljEUHIF?=
 =?us-ascii?Q?ZC+4elWNAXUzLmt+WC129guT+NsDgbKNRsOaDBdD0Gf7cGRjv4UqTk+0yNuR?=
 =?us-ascii?Q?hydVXWS/1b5PGve2cAX63Ybljxdgfz0d9PrjUROf5n1Eueryi1bRWXXFDT1p?=
 =?us-ascii?Q?CaX6hV8Y5UKOyAappLf39hDQY7tVP75Dxf/ku2EY1CRAapVynYrAxmdXEq6Z?=
 =?us-ascii?Q?7DuUabvCbBsFacCkjqwEhKJslDL/C7+pdkvdnDIOwKGir6S+FuDy57AfDexe?=
 =?us-ascii?Q?JYJdcOpSyl8o+O8kMglGuDw2pQfZJGEotH5V6/e25udqJFIwhHirA5VCUMC/?=
 =?us-ascii?Q?3919r8GCQ2bcLc+w1rngVnLHZ9M9os7eDG76gzJ5BiFxCa/JTv3hTYG/B+y9?=
 =?us-ascii?Q?5jcYoOJIguvdMwgGRdrPRVo5ZbGrGQdDAOf13YLwC6ltPiLb9G3JEU6hIJ2z?=
 =?us-ascii?Q?YeYh1KJlk6gGv5AZz1851YRe+4VhyFqzmksufKyTzDHrtWH9y17SIlbGGJZZ?=
 =?us-ascii?Q?THfDd3pOSWj+B2Mp+4hCvlizSqN1nTKMlFxzYm4PWXefU3agRT29vn5zPIIy?=
 =?us-ascii?Q?7eppGST7uNvKTlFPTptIT7Lsda9mI0kvpRvF7kH3SIzfUiRUK/tCxq0yf+mL?=
 =?us-ascii?Q?SyRdGATP/+6SqbCpKb/33iTo1XLGlSAsz1oBOY7cfcR3XXuUj8MLa/Q5Os+k?=
 =?us-ascii?Q?t6PpwmfLBm4GbSTjW5rlmaHdNvZduqSwMr94wm8DdUU+ZoHQQxo4n+EKFpE2?=
 =?us-ascii?Q?ANLyxWXCFvDUCyk3W25KtTCSorYkGDkhEF0gk7HvdFtptyXSgU1FaKrkJzSN?=
 =?us-ascii?Q?ssrdaQ3MzGWBbGixS8DcKBWmNfPJAcEO/tLCKRNiJmjSFFi+aeC0DwAS0Rl5?=
 =?us-ascii?Q?+uTk5oVL52i8PVoGVyImNsLrkzCzFrxruX78Ij2g8vfR4U3MOAH0ZaAfsI2C?=
 =?us-ascii?Q?/A=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 96cd3c83-6e46-48ea-50d1-08da86d7d233
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 20:24:32.9953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmuCq9zBfkkWCbTB+DbTx2f2HVNQ/gfP0seLYVS2pZIBqiic3dKI/p3yf/B97ILs8DtmYPFIb5bE2lVWzL3IcM84s6HVc0cmrrKzPLXG6eU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 .../marvell/prestera/prestera_router.c        | 60 +++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index a808f1fe85af..9fe37bafb42c 100644
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
index 15958f83107e..8b91213bb25a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -8,6 +8,7 @@
 #include <net/switchdev.h>
 #include <linux/rhashtable.h>
 #include <net/nexthop.h>
+#include <net/netevent.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
@@ -610,6 +611,57 @@ static int __prestera_router_fib_event(struct notifier_block *nb,
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
+	struct prestera_switch *sw = net_work->sw;
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
@@ -648,6 +700,11 @@ int prestera_router_init(struct prestera_switch *sw)
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
@@ -657,6 +714,8 @@ int prestera_router_init(struct prestera_switch *sw)
 	return 0;
 
 err_register_fib_notifier:
+	unregister_netevent_notifier(&router->netevent_nb);
+err_register_netevent_notifier:
 	unregister_inetaddr_notifier(&router->inetaddr_nb);
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
@@ -674,6 +733,7 @@ int prestera_router_init(struct prestera_switch *sw)
 void prestera_router_fini(struct prestera_switch *sw)
 {
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
+	unregister_netevent_notifier(&sw->router->netevent_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
 	prestera_queue_drain();
-- 
2.17.1

