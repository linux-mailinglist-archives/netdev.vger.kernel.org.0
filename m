Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C412A5A1A44
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240638AbiHYUYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243273AbiHYUYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:24:41 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2111.outbound.protection.outlook.com [40.107.20.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11769C04F7;
        Thu, 25 Aug 2022 13:24:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYdMtxONTy6TVgVatzUnFOSS9nFtflKcwK+vavdWJ7r20+19fXvuEeIKn0K5ieKZVyFWSi3qW2qTZal2fzZxNbLoBSqdDugnH6UMF3IjOemSIb/my/jPKP1XUJu2gDBRl9N8CgBNPFMHWngHwqlwvLUGsCId+4jyY5AoK3MM2K/6xJnHdH23t1IiRL5NYZcTLMqLB6cHsbb/7CWlPCILl7aIFrM8EO2STvwxiUI+IZw3BsnjEoJyE9x1gnSnQ3enN3DV/v2Xmhlb96qtIzQFNeys0xqGu8ZHCkVjnpp0Tk7qAJ0DwYWCdjNtIsEbpIfRe0/Fz3S2hQCPUxT/qhM3sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+0eVYtFeD15gG7q6WqI5+kSy3bTuZWpQn2150PIGwI=;
 b=gckQPlVhY/8S8ClfqDfKgSElRPm0vTZGtbYyfpsGJvtY+vilMuMH9TPpc1iPBg28H1CwW6S70A+h/VXSEHWnfXtclHlDmGf5ZPNUeoC10K4JjGMQ8sUUxjE8AbN8yeqyPH/Gjx/RTDSAsHxsUYyHyuCcROS7ehXsOaRu4mM0AUCIWyYIQNlEcjRYKE71LIIXGDA/JR9pNSrRpvgO0B2b3Gc9oi8hX5RizN0P+ueDtMKBSmgPCmppT1VDglabSsCGMcV3gdTLnF6CUN3dEeEuwhBMaNhaMCSsAk4xwVWH0/39UFFd478FD0cu3fwXobcT3AGsFvcmB53dkDMaF5AAIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+0eVYtFeD15gG7q6WqI5+kSy3bTuZWpQn2150PIGwI=;
 b=HVuytFfiCi6y1I824B3vSyDvP+glTSlaiM+c5ifL4RG0o2kZ+2Jtv0AsIPZSFwAL1rF6MtkLk1ZHMmkyyhBRhwM3mB+pqTYkKUkrRia+k8aEXP1/7kJ4eOVDHCAHExeSgmiqLVzGgEuWtS6B95FcSxmRJ+GHOZrzK372ec6BCrM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1621.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Thu, 25 Aug
 2022 20:24:30 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 20:24:30 +0000
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
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH net-next v4 3/9] net: marvell: prestera: Add strict cleanup of fib arbiter
Date:   Thu, 25 Aug 2022 23:24:09 +0300
Message-Id: <20220825202415.16312-4-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
References: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60a2a5bd-5978-4452-184c-08da86d7d062
X-MS-TrafficTypeDiagnostic: AS8P190MB1621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EuJ2H5nQVyBjk5LJ4vYVjWjVkjquZvabss9cgcXFNTzoKoSasLTLQtVy+mWdktSzfT2rX8CryZ4Zpm0bnbPRIIYzoCsDoO0P1OD5bKiYv0/GNwtIUbsqIKeSyLL35eENr70MnFiwcqZwxBalip6mc6ZPyOuzSA8ohsFDzp3n6o7YAXdbFNBGREeNDEvvthP2pxhXhvTcE4wRhWuEeR1wQBNc/U+JAVKteQRqlJ0bk9/HQnYOnW9brhFNcaFD/kSH9M8M4rYs8yGW2ylrDKvn2vP5GXT7GvWNah8pXOHviqeN93QHzfsfvh4QSX5UaMqFwOQ8sCysOqYbM1wqRzm5ky+J9XiafICH7Ga8EIOmOGMqOkgjpFNAMk78OqtvSHWYQGJMp8b2ufLFKU4EdB64KUS9nxZeKMJ7IUg5Qw6XTMmBObvp4RXINhw2ZeqiJLaDCw+ETgin9BzvHzpGNIeeStLTeW8HRNaJ54SsBBHFALLIQ4JlydcS3GtynuEJ76/bN9PQRGGfsNZy3rKTH4vKtaT6iAtEurzeRT/VDkcvC8QFUuRZ73QF9ZHRtx/w5ZYh5P4mvnAuoDfBX7vQbYW/ZN73EOPi7ntIj/6AgkzQQFCZKT2z0FVOEMq/bGCMDW4MP1WZKQb+zDl0mWJ0hW5qVHryqFbAePCuDjKzHIVIm+PtE9QK8bFWDJ7QdY/GjCLtjBJAHR5j2T1lzQHtn16giSf6XIdUkAQnR5ZnHy1ARAFWiOUXPowq+Sa+1D9azQKZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(376002)(34036004)(346002)(366004)(396003)(136003)(6916009)(41300700001)(26005)(4326008)(66556008)(8676002)(86362001)(508600001)(54906003)(2616005)(2906002)(8936002)(52116002)(6666004)(5660300002)(44832011)(36756003)(1076003)(6486002)(6512007)(186003)(66574015)(107886003)(41320700001)(6506007)(83380400001)(316002)(66946007)(38100700002)(66476007)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ro2UA21UxaQGRDhLTPlakB/xjW1pLyWOBNNWQeXobOW8GfhFoZvSaQgBMcY8?=
 =?us-ascii?Q?3OTJqCsvccGQ8IYt003knBXmYG7ulzd1vGElUbFI8TlS1UemkFRejuVqRpBe?=
 =?us-ascii?Q?12SrcrdqJt7xLlas/ZRfNlTgV8WXPwv+ymeeVyGXPSVZVwiVOgvVxX+iXeyR?=
 =?us-ascii?Q?+mYyb5XbpMKzO7XFafif+sLUMLEwbh7qYbvKGEiOvlct9xD8t2+7iAtZFLlT?=
 =?us-ascii?Q?UDUyAOYkzHT2R+BecSzuaAyPdvksC3FFj/qcJGZh4JEjCbqG0lsUnar2tyWl?=
 =?us-ascii?Q?flocx02JQkzf7eI+aS74xpGIdIyAkt5WJR6+RJZ/QxaMk/j1tjuAx69lFCjH?=
 =?us-ascii?Q?Rf0/D8InJYaUkix/TW8olFioZ8sWGGr19dVsEaIk3gDzzGI3UJnQhWxoTkPY?=
 =?us-ascii?Q?o6jCljElcvrH4vLURRUVojnPUgNnjIVqCNYbCS4BRTkK1JuB8EOyNILqv+0j?=
 =?us-ascii?Q?a+6TyUj24s8VcetTpzaj1h6Wag6PDeUVHqCY3YyOg4xG0wOpiZH2HrTCgT1v?=
 =?us-ascii?Q?lwukbE0pHMeDoHG8WnbzETgbo6Zrh76D/1wKJmfQSkS6aLAA7GqQ27HEENu0?=
 =?us-ascii?Q?IBPNhUV01GOyP9UnVBmcEQO5/fhuLyRzxZQ5OrceHKOQniKij2QZwg1ZzwJZ?=
 =?us-ascii?Q?jL0qRN6H50SX73lq3rRDnQsEPiCyuUw4SJT1ARB4K+D7AIF0niYhlWRbiDwf?=
 =?us-ascii?Q?3ypQf0vsfFquIzxaaV9Tk6ENCRP7ydQN2BK8wYWvxGpp6bdWNubyeRILLmUQ?=
 =?us-ascii?Q?WkcyCr40jyUiublRXjGtzcR1b8CCEEYM9PmikmRAWuarqxvT2udtU8fkxtX5?=
 =?us-ascii?Q?OymKOE9UaYxEj/uYhuMz/wCYhUELHiLUTdd+lEfKATonnx7iKETvxq8bXd6x?=
 =?us-ascii?Q?ruiVk629otRaqg8BH8i3HQz0TFd6P67iGoCzy/3dLaqGq94yGYNU1BOTFElE?=
 =?us-ascii?Q?lOBBEz8TUzBsQzAmqlrMU5A1Q5OPcQCX9tkO53lNJ9qmBQi3Owa/aa+3VxbU?=
 =?us-ascii?Q?uJQIR8tz/9gu6z6xB++ZgNeMRtU2smjAwmudsMKzwE45Xg3nP5PG3TKfKxkJ?=
 =?us-ascii?Q?wY1k7UjKRSiaQnzaFX+fmkIATeEDa2Blg6ILBq59ELwSitZzLXYp+dOZeT4+?=
 =?us-ascii?Q?ngiebRPuEgg+/wHjRK8643X1ef+a6+QKI1ETwXitnN3Wb/n8ZG21STutfUOD?=
 =?us-ascii?Q?HpQax2e2ps1By1jKUDmFdCGaZPRnOIXekcT6cRQJMKyrjwmgjEAcGt/8oHJX?=
 =?us-ascii?Q?nX7zP7xYMqZo4UeZwlg/MIq16C2+lPV//Shc97SUAHKzv+QgsCMrXv4rKa6+?=
 =?us-ascii?Q?aTB3qg/kx7g8bwV9ekLAIIausGwsfFT24KtVCuIHO0wG/imq1dR0EV9fpQ0H?=
 =?us-ascii?Q?ZrgZ3nU2MYTwgRJEyJ5l3xwjldqUM/eHn0G3e16V+VtcQ0XgJpCx9yBBGmXx?=
 =?us-ascii?Q?3EFqsYkcz+UXR0ZDm4N4ROD6outXO0hpMCDcughvWVco/fGBDBZVxmtOcE0T?=
 =?us-ascii?Q?yImOREajd+cA2xYnq1DSbfBtsTKMJvdQWvyPTtsIXqCi6SZ+A3LUlcl9x6bR?=
 =?us-ascii?Q?N7apkudZgjACVIC5xk+TYRkg0BjkkjGGrWdhS0V5FdLd96SKHEGjV1txdP73?=
 =?us-ascii?Q?WQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 60a2a5bd-5978-4452-184c-08da86d7d062
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 20:24:29.9776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9YcDCS53iLtGHRAtjyO4G4TNGEPP7vabiUS37cO6QAfxPvk2XS7mj6MiEhe1zhIy5nD4dwW+cp20PKSpZKsf0kOoradYBt+W3hEJAW822Sk=
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

This will, ensure, that there is no more, preciously allocated fib_cache
entries left after deinit.
Will be used to free allocated resources of nexthop routes, that points
to "not our" port (e.g. eth0).

Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../marvell/prestera/prestera_router.c        | 46 +++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 3e9e2bfcdc52..22daff5d9975 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -334,6 +334,49 @@ prestera_k_arb_fib_evt(struct prestera_switch *sw,
 	return 0;
 }
 
+static void __prestera_k_arb_abort_fib(struct prestera_switch *sw)
+{
+	struct prestera_kern_fib_cache *fib_cache;
+	struct rhashtable_iter iter;
+
+	while (1) {
+		rhashtable_walk_enter(&sw->router->kern_fib_cache_ht, &iter);
+		rhashtable_walk_start(&iter);
+
+		fib_cache = rhashtable_walk_next(&iter);
+
+		rhashtable_walk_stop(&iter);
+		rhashtable_walk_exit(&iter);
+
+		if (!fib_cache) {
+			break;
+		} else if (IS_ERR(fib_cache)) {
+			continue;
+		} else if (fib_cache) {
+			__prestera_k_arb_fib_lpm_offload_set(sw, fib_cache,
+							     false, false,
+							     false);
+			/* No need to destroy lpm.
+			 * It will be aborted by destroy_ht
+			 */
+			prestera_kern_fib_cache_destroy(sw, fib_cache);
+		}
+	}
+}
+
+static void prestera_k_arb_abort(struct prestera_switch *sw)
+{
+	/* Function to remove all arbiter entries and related hw objects. */
+	/* Sequence:
+	 *   1) Clear arbiter tables, but don't touch hw
+	 *   2) Clear hw
+	 * We use such approach, because arbiter object is not directly mapped
+	 * to hw. So deletion of one arbiter object may even lead to creation of
+	 * hw object (e.g. in case of overlapped routes).
+	 */
+	__prestera_k_arb_abort_fib(sw);
+}
+
 static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 					  unsigned long event,
 					  struct netlink_ext_ack *extack)
@@ -600,6 +643,9 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+
+	prestera_k_arb_abort(sw);
+
 	kfree(sw->router->nhgrp_hw_state_cache);
 	rhashtable_destroy(&sw->router->kern_fib_cache_ht);
 	prestera_router_hw_fini(sw);
-- 
2.17.1

