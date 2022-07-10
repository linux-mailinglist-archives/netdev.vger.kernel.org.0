Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E258E56D06F
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 19:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiGJRWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 13:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiGJRWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 13:22:41 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60113.outbound.protection.outlook.com [40.107.6.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8310AFD0B;
        Sun, 10 Jul 2022 10:22:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFpMdaMWco2OHqT8VN8856lAE/usDX3d5s+OgQXlAS6O2XHR714afGaymvt4gTv4LasRLW3aaFsoNRzQZwm5CdaqbQNNFLZG5EfytusNZLXaY4XOWs+SvZsmE1hKtiUqrV8VJuillcns7JRnw7+1tzssAnJVOcQJB3kVNBMxW0sajHp0E9WKlTW7bTxYED9NqgwRTQ1w5d3B5LxTqH9jySiqARRUKTTXuAABAKvYtjKQXfm4Eu31N29mhPGLVyxBctrklsFKGeD+z4cbx+AQQ6pns/RTr1ZEGDsnehyw1ThYafsNTjXnc+vn/75CMCZU26hbRw+AWkSI2s+A7rJiXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFKnpnSOnlmOLKTwz7mLl8uNTKUF3f/Tk+CEAwA/go8=;
 b=m5JKiH9eCXx414Jmx98OeFch/XY5ks9XA17o7M1+hXXQxpcg4Ggk5Mg+pJOeWw2RTz31nPSDZkeYrJzk96TieMpQxm4UyF7cJQj2zE8lhqgVdTh7D3LyvG4p9lyfWRpkkCLoyEiNuYej9mnPmTyVX9vza9aIUpXcYK2+4UwZH5PREOBHX8vM/+6qOBfWh/xuXulFTXwGeUweRr1vvPDaP/bii3+ZO1OwJ2vrZV0sQ5heiNBWtWeJnq8W5dnrf2GO6fx3rAZwXyMya1EjdzEycZpkTlBGe4hS+4E/UnX7bx0BT2naiHxYW/dQ7gc4OhQ1tJkrhHuFyKVyGTcS7g7+Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFKnpnSOnlmOLKTwz7mLl8uNTKUF3f/Tk+CEAwA/go8=;
 b=wZS5nZuNG4eyyy8QlTIewFzKurPhSyqDBpfmktLKuBlrliLwSqGN6QB5LJkPTCk07A65AOmhhswOemDTbqG7SdLM97TFaVUNfS8kcoSaec5o1pEkC31Wqilg9dIaSRdvi6LXuSaGcub1UhM6grwwFZXVgnbYeGmrxs3RnDnJiuo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1109.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Sun, 10 Jul
 2022 17:22:37 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 17:22:37 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/9] net: marvell: prestera: Add strict cleanup of fib arbiter
Date:   Sun, 10 Jul 2022 20:22:01 +0300
Message-Id: <20220710172208.29851-4-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
References: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0058.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::28) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 504fc39c-d446-4af5-96ec-08da6298c8d9
X-MS-TrafficTypeDiagnostic: AS8P190MB1109:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CuP7Nd+k79gccCPXJjTC3/l0baUSuZFOajAtfVFkRSr7iQnvETK/pa7PbpbmDeaXyNcVO4HbPfkzGt1vvTbW45F6wkvbQiYcS6YnV6BTfRQnCRPnLIQrRFhn5KDe7lG8Io1t7rqRj+xsFbtP/rQw8SY0tGmiimjXolsBcLLhF6CcVxr+jCqYqvIQyAhEfrovNv+JnzkpmIYgr6hgZyUMwY/xWgxpifxgtZieLkcAYcfu663yAz2xmIij7wH8x3Gxh7CGGnwvWrfJk+S+S5pqNDcvMA/UWQS2F2pIU9gaVVbxaIb1dzwXFM///9c1D5pewPsyCjF3lrgZATYI309WdUt3YB0/bCxeQ+6STDaIqXOnfcNai7ZmcAPSyPMKmWq8ZmqR+nL901s/bFycUiwzStmfwD0DM2ho84b4aln7cyGmFy36tBQPccXspDZoIYDsUZPC3QjwHUSW8ExCkGYnm1Ni25kcYBHPsqrcRrfFiT1nPgq2E+gNX4gCBKyyWyitPWwKoNPOYqtRsz/atAOUy7OWB+6AWbBJ9lwE7XELwHreZAjXNSXF5+RO5yMybMNDgBbTJTh8N9U7e31j4wq0SKB84lPY+efRKwe2Pkf+/LDGkhBoS+3i66lAHWSOXxrJ+43w9cwaCXHLaHIn0eONeZXbSpJmJcPkn3bOaNHkOewUT6uBxwFhP17TvrejxNlFNehdxbXbKjNR4b/1xsxTOQnU22NP5TPyxt7xL3hHQUVw/Sy65SJV6vsyutl6BGGOXCrn/8pkS8rqJY2WtF95GIVCpCB4+wEhZZYWm8ffNpWJPNjqwiQ4hEBPKiXKOC+L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39830400003)(376002)(366004)(26005)(41300700001)(1076003)(6666004)(6486002)(83380400001)(6512007)(316002)(66574015)(2616005)(36756003)(52116002)(6506007)(186003)(38350700002)(2906002)(38100700002)(6916009)(54906003)(86362001)(5660300002)(478600001)(8936002)(66946007)(66556008)(4326008)(44832011)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0Dbin91z7m6BV/v42HZElwe1oicgfSAAukcNbUy3GLEW1P/MqCzReozZguFR?=
 =?us-ascii?Q?JC1BGRxV4OrY091c4u9LN0L7T7l/Pcfdf0H+mbyonZrAiVaZHPAckA2XXb8+?=
 =?us-ascii?Q?gJ8hh2kY1LmXVL9cg7wSemqWloTGFdsw3RemvDpdxKcN0lOXJJwRJgcXi8JW?=
 =?us-ascii?Q?TB5bkbuJa+8bGsdazqMed04wyBvnQ1JyYE5xRkEoK8QZDMgkYoKeTcGCS11m?=
 =?us-ascii?Q?J+G/kEoT7AX7ZF+TN9+6g+PCEA6i6S2QJsNnLZwymNdHu0DqOFwXP7+gn4us?=
 =?us-ascii?Q?jbHchiQ9WLC14MLmCwy0NsiKJ94y8UbM4F1O6FsyH3IFMhsBk/OZLJs3Y0wp?=
 =?us-ascii?Q?DoMsBI5e9TPWMef3yB/Tbpg8G+NQt8nxx4qERwFDk4rTZOQVA67bQSWMroOt?=
 =?us-ascii?Q?VyKKD6jkncNdEYkPGQ6m2GrGcryZ2svBuv+o9uzNIUfRlzjjo2oZJu3Nm1zK?=
 =?us-ascii?Q?MyK3Wutg6ap5F39rbfxsc84ySSzW84s4RWtJ1dZ2LaLEYi8yK1gW7Z18SlKZ?=
 =?us-ascii?Q?zlxDaubYQEZUf8Vhy4tt2JTkteczLE6QCcoIdZoJnamoN/sSN/9h67tvtV5R?=
 =?us-ascii?Q?ENkJLIkxsIzoSLVj/+6K5N/s6ex32ds2gu5O9q7HA6ZWEsyhhukjLndwOnYJ?=
 =?us-ascii?Q?7nd1Crm57vfM3GPnLU7lfLPDn9KrpSl31hjwss0Rp60BSUZ4nGeYhC0NURaG?=
 =?us-ascii?Q?6QfRvsTM1G6voUJwqc4MCTEXdlNXkfwx29HtD2PyqTKQ0dFW9SxXZ4Et/7fB?=
 =?us-ascii?Q?9JhwEnOYTqhoyQitIC5x4OSdO+guhllwydR8Pk9o97WNdbQtP5uy0DcvabwE?=
 =?us-ascii?Q?g7ur1bubDVLY1d+W93HoBHa0VY745J/LKq8ok+TlNBnD4qliLWzbgzFxdSJy?=
 =?us-ascii?Q?fmL9V3losfMPeUdR4NKzMpPZXv5Pc8DT1GMfB7CGT6aT/CKByiZLkYy7n+Yh?=
 =?us-ascii?Q?aRpgUI5azK7xLdqYOi5BDEuWbxNPSNVYo4oDEiJKTAs4DqUE7KBe+ea9GK7y?=
 =?us-ascii?Q?LySOeoT25w/qhTYn8d2e0q+b0cq0OfOwiJ8xRuPdvwLXl8o2kGJXgvGbzgyk?=
 =?us-ascii?Q?28I5Jz0rNirBlQhlbxFVf5JsT2P4+X/2M+EZmh7NX2XEoWExU45/KFQNKJCu?=
 =?us-ascii?Q?2Y8NtNPQQm4fZpO3vbEdZp44/0UeNedf2UnTHz4EQTv0pEBz3TCjwEvg3ucQ?=
 =?us-ascii?Q?7ODzlf5frmKhp7xJxE6+XXSjv5uab8PWk6RA3ZvtEl6P1hIYrzXmRr+wZWI1?=
 =?us-ascii?Q?UnRid4wcX4IjtaeVTPVM6zXwlh0h+JdqnmKzpX4hiH/cMFwdzlNHXiTyyaml?=
 =?us-ascii?Q?Z6cVxe2YLgQq2s+ASysKSds+ggKk6Eg1a02IE5ZX8cjQiXsxJropWlDCcXuR?=
 =?us-ascii?Q?1yzWJ9ZlUIAR7rc53DJ1/Yf9a2sJzurbbfq8MbGRe7/5h5jH2RaUypQ6Nd0g?=
 =?us-ascii?Q?RXi6tgXXGd61NkBuRKvmM2v8xDp4GKQIW5M6AK/vCBMHPV7V9KfONhanGzxb?=
 =?us-ascii?Q?YGR9a85e17Pg56pSYGQrHp8U1IhMnkrDqqRaby5/vhA8eSnSiY1+pG7yS3Ay?=
 =?us-ascii?Q?Pnu20jSTyJt6R0FjpyUCJxQEh2LylFJxMM/+5/hlQIell1doivslz+eTNoR0?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 504fc39c-d446-4af5-96ec-08da6298c8d9
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 17:22:37.1693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XYnEV7SrRhf3pM0LhP6ULHSilCYyfSxl25Ck+RCfqlWm9Nwfy43C354yGfFT+D3XoTTNLQg2ndsfLm9LcEUYIPHH9SJOmcGJOp9ztIA61Y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index e9b08b541aba..41955c7f8323 100644
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

