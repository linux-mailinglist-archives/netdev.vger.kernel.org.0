Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B2256D07C
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 19:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiGJRXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 13:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiGJRXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 13:23:14 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60092.outbound.protection.outlook.com [40.107.6.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D82814038;
        Sun, 10 Jul 2022 10:22:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrdeJ5gPMk9CfHcvo6AEUFjRJke8dWSVedJv0B66PGBswYtxuAIgCx1WcoOpaiLMLQRwMSrpWBOi6Svfh1YvEp59cOAMP+WB4D4WX1WMOAEQAiCsWdAimSFlJHYxaA8fYHXHZVBI/2zA/I3/CzYJXclvvCK0xRd44T12RXugju1BitSUOL1yxqOCnSB+axipmW9+WS/1bQVuDj5imYKbFHWNXwnas+nhOfTAcKftobIaeTqpVw1i6IZeG+AvCGu6dJes+nptIxay+s2A3hin3v11GHByY8Xemm2QSMN/Zh2J3WZhHcP9Nzu4Vtv5qDUFOIBSpn33fTVY+Bock4dThA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3PHIbCjF79lXJGcu7qcX1X5xnwLFZ7frRqY5RTCkvfE=;
 b=lHGVHoVj1nkGQPoP0FQriRZ/HG/6mmKQOp+4VZyE/k4KTGu0sJoCCbFDFe7Lyu8mE4N2PnulsuktKPrPWFPy6IdzJSPDSb49CpnGS4k+IpbJ0z0iI/sk+pFSojmLm9UYVF05aaVXb3Mxr6RNur6WFASHdi8udDyP6DNYVr+w22VJ8L4Q/B7/TnvtkTJZA9b9ly6efifuk+nNST1G+qu+rC1yWiFhddzE+xcpdeS+jKsAdizNH4kRyDvXdkPGx2mjAfxjgFE255QOAh/QVTZS9ZZqjS5qwskFBFfvUEMcP3zlwHPYMir/DN7PUCGJ8WiBPirIi4eF9Q50F5+Wy6XViQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PHIbCjF79lXJGcu7qcX1X5xnwLFZ7frRqY5RTCkvfE=;
 b=O7a954ro3Ns+v8FvtxtoZIVsHBbp1HFP57hw5gQqYnxCtMdTv4gcfLtZKeI/KQ/J3oWrx2iZazj0tFughO8S82CIEzigiyRuTkOzNl/YW8NO/cMjvyYurnmXaXt1v00r/qs/XazCr+7Wqqnkn/GOiDMjEjFvW75ynTyK5HIdtoY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1109.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Sun, 10 Jul
 2022 17:22:45 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 17:22:45 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/9] net: marvell: prestera: add stub handler neighbour events
Date:   Sun, 10 Jul 2022 20:22:05 +0300
Message-Id: <20220710172208.29851-8-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
References: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0058.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::28) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fda83587-1018-4388-05e2-08da6298cdd8
X-MS-TrafficTypeDiagnostic: AS8P190MB1109:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zYvcDgcY6Cpy1V+iX8oYnt8W1ao6Q8UCCfFxZFAk37ef6hrIoICEMmlSmrIWIBNSHWnfuBkyt1Kgl4NYbR109eIspgTuEkCH9HZRYt9YMO2ImJ64dzDP4+yRYELg8IQWG6yO9peY79EinpTEudaQcYQ6NSEwPvZxNC95EeonWga/PmMriETU/TAkXUd4lXoKBKtIGekzlgYrB1s1P0aY7oo59u9qqXm2xtltskljodsqIEBj7WXGTQqwVNs1uJMLejFDAPkFSKLGbZOokHK5FHOYXI0l7yhWMyiFT6m+KLDDGr1Y/lQNCp9e2sL/KGJMuD2R7hWNQpLIKuqT8qnDFpe5rgx+sAni6xVzUwM72LacmJ0G+CaVjso4BqyUOaG8FYxPVP5a1qfkzt2XfbSV5IJwRB4/6jGK9ggO/WkwTezl/3kJIg/cZXRuEY6o/TPPWAC4anWt0YBnGgo7fSPliQmociVj4OF0WTSAztgvnf5drbmYO4i+fLX4LYg+IXQVl6Wgt9cSuQ8zI7anTi7DlJvp2/gDsuyTlMenDMRfMoHzTMwMb9H4yqMXEMuY2kkD0pdt5CrVphuHKpSKyMyMolbOiTWC3pjU0U7NJFd2gEWytXlsKsNvNPDiLCMlYjTulNzTaw9nH0Fh+pwyMYMpqdU7zY0lRRjF0+8PyskhVkjqGC+OEsE7Itn0Rk+2DdxExdpAkeUQN7dLR3WzuYh2/OGh4doA+hVXU4BOiPcK46fB+2ysKtSFcQ2mRS/8Mme7P0KkzdjEa7ctJlP6Ot+VZNCSUtCl6DPD2G0tU3zr9aUhcjKwRcsNINlXtMdvBFTP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39830400003)(376002)(366004)(26005)(41300700001)(1076003)(6666004)(6486002)(83380400001)(6512007)(316002)(66574015)(2616005)(36756003)(52116002)(6506007)(186003)(38350700002)(2906002)(38100700002)(6916009)(54906003)(86362001)(5660300002)(478600001)(8936002)(66946007)(66556008)(4326008)(44832011)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gwHHMrQg0hhf1A8ahP3XsOV+eHVDzRx6F0Tb7zsewudRMxPxGBM7rsmSCreT?=
 =?us-ascii?Q?wT9iQASuJf6ftsEpnhpXUJ4BBUObcZrqEiA37eDQSQ9WoJdPIUFwwM6wbNpk?=
 =?us-ascii?Q?cGylsqK7B1pH+5CO84MBwydhcO8w+/xM+x38cAoSCmOB5w/diZ+uK4KnDeyw?=
 =?us-ascii?Q?UPTOa0azJGikXuiQ2ri9GHLBYy3wOvI/wRzOY5vlPPTCSOq5d+zbWfXjyCur?=
 =?us-ascii?Q?ZeU7f9PIKSFD0cx/C7EMtBPGGIN8GkK4lbOgZ8vuUlpCYVTyjuLkBMTjfNCC?=
 =?us-ascii?Q?I6IRlNwVqTc0sCJ4+xqx+5vUk8ysaU8TdMauD/Vdswm5XGo2C2LrKNFLY/H+?=
 =?us-ascii?Q?8o647JWk7r2V2BCCJehFgTK+opW4Lz18r3uiKNIbE1GtlwhY2iP6xUgqSAmP?=
 =?us-ascii?Q?4/SAZswNRSoSGqnNeXw+bvytXRt4VdzLnHdLhrRrBh+WzJZ8VHu5FntZ25tH?=
 =?us-ascii?Q?2DqaAVV2yN5VMjYNLGg/dJzduegl2ahvcigbr6+ea9DR3ySTpk5AgZPui28L?=
 =?us-ascii?Q?/KBV8eSTM9zjbItEKv7C6kS1vO1LVixKjh0oWFWKl/NtpMMncPf4rWpDWWJb?=
 =?us-ascii?Q?TRg50rnpMp+9XGqCAyRlstdPrEVT3vz5+0w68/vctB6Ay1eCxz8kemSvDOBW?=
 =?us-ascii?Q?6W/4GxoKhqmg9iarg5ICgNDHNqylyYP8XF30B3R+gxzw3phj3v+4bFo7wmsO?=
 =?us-ascii?Q?TK8w73Ru8Bp3N5M6v95Yd6rDDLRwDkpnCVQiwXdiDY80phYXCSYS7jq/Ju1a?=
 =?us-ascii?Q?WpBkduo77gLnolm7XPS5gGnSaNcAFA8+6wzSpdMO8qGXK22lzqF1gfWpilZX?=
 =?us-ascii?Q?fZDw43amYRLaNvTGm0skUeHQpIKcXbyr2AIOJHNw6NQgEJUPO9SmCqtRG+g8?=
 =?us-ascii?Q?Ti4mEmem8YEYbQR/PwkUZ1aizGLokwFu9amCh+YjQBcCHjW4oduAaPgxL6YT?=
 =?us-ascii?Q?a8b/YDzyvkPxQaaS09vjTicmz4Vd7BNoCkO5LBBaale9pHYnaFxN108yBhcM?=
 =?us-ascii?Q?uBLDwkL8sRnI6GO5HYg4EmAY7cbZ2NvvcwUaTROUj8cLrzTSX5CO92ydkuBI?=
 =?us-ascii?Q?g+sIDPdqwsCzI6EtxksyeUkWykxVsulG1fIUBIjeKYpiI63gzjnayRgjoPjH?=
 =?us-ascii?Q?LdL1bIRbDywc2YuU8zDg5m8E3BwJZKd3YVd2sPohxDEL1UPuUadxXr+Rkgq3?=
 =?us-ascii?Q?kt49B7b/iQQRNc5hA9ht7dJoqCiEjyN0Cn/44iTPnQG2VfBer4VtOQSLcY1t?=
 =?us-ascii?Q?wXjMr6/1us5ARBIMHIigVP4kI63DRlQ2ssLQtOMajlYGQ7z3+6v4AYRnMe9D?=
 =?us-ascii?Q?NxKZtKE3wr2XqFxkj6Xqa5ZxFGfoQl0EKz43ooN3fvPS8UGJ4bdQws1iAQfF?=
 =?us-ascii?Q?j6HF2rj9GlB/eN1PLK4h8wFeWIrKVXzkDugwu5EPQBrR8dmXMrTV9WVj9ar8?=
 =?us-ascii?Q?fXQ/dtvQ/hyhiAN9inYbrpXiXUH/gMtIyJbp+0IT0vNhu2NJQMrXCIhyM6DB?=
 =?us-ascii?Q?rMZ4V8n0/3BJilHFlJdxNDGZhRZbkmovITa4Sts7htPRGzGwxHgeg+SoEhaa?=
 =?us-ascii?Q?qlJoxbTMYYBRiiLO780GYaeiwuiYE6oYlT4M4jtRt+BUxELWcd+g1KzUuDR5?=
 =?us-ascii?Q?ag=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: fda83587-1018-4388-05e2-08da6298cdd8
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 17:22:45.5477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWfX01FgM2RXUbHvnDJkMZ9Huz5NMRnMm1BKs/q7RU9B81iR9wBdf2ChQVTkmhjXXqE3A4U1fqjRW1tWY/SB19INAhjEQD7g9JX7ODYLqCk=
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
index e53e5826e620..b464cf46b122 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -290,6 +290,7 @@ struct prestera_router {
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inetaddr_valid_nb;
 	struct notifier_block fib_nb;
+	struct notifier_block netevent_nb;
 	u8 *nhgrp_hw_state_cache; /* Bitmap cached hw state of nhs */
 	unsigned long nhgrp_hw_cache_kick; /* jiffies */
 };
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 0150aa33c958..570469a99e47 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -8,6 +8,7 @@
 #include <net/switchdev.h>
 #include <linux/rhashtable.h>
 #include <net/nexthop.h>
+#include <net/netevent.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
@@ -820,6 +821,57 @@ static int __prestera_router_fib_event(struct notifier_block *nb,
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
@@ -858,6 +910,11 @@ int prestera_router_init(struct prestera_switch *sw)
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
@@ -867,6 +924,8 @@ int prestera_router_init(struct prestera_switch *sw)
 	return 0;
 
 err_register_fib_notifier:
+	unregister_netevent_notifier(&router->netevent_nb);
+err_register_netevent_notifier:
 	unregister_inetaddr_notifier(&router->inetaddr_nb);
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
@@ -884,6 +943,7 @@ int prestera_router_init(struct prestera_switch *sw)
 void prestera_router_fini(struct prestera_switch *sw)
 {
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
+	unregister_netevent_notifier(&sw->router->netevent_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
 	prestera_queue_drain();
-- 
2.17.1

