Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADAF757D6A3
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 00:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbiGUWMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 18:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbiGUWMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 18:12:22 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60115.outbound.protection.outlook.com [40.107.6.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8A3951FC;
        Thu, 21 Jul 2022 15:12:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUP1+jC4KzNzNthGhfnywN5FXuViIF9fsExpJ6buhI4OMiZTFsQOubTEeVjZ5TSklfzKAQ9hF3JXY+aDobOgL4UXPp031NxpRo5tF7W/5V5wJKF6mCOh1F4iikLbKs1H5UTL3JDAozyyoVG4Iwdgb9/DJVB1AMdj8OKdd2X9OEjynew3wiAdpvsVT8fakKTOf0pMs3YBZU1Snu9Dtx3a+nER4Uu8PgZYvoaZYZgeR3WHc2UdXYJT+321M8moNhEmZowtVQChASTZbLi5yN+PwfYGel6cCYo/vcnMrjoCI5kcvEetwZC2EKnEylAPN9rbJJeKps1CPrKPF+EDW9+6Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/WbQyh/ZXgSS6dp2ML2jsnXHlR+ULoPghNRMwBnX/Qc=;
 b=ga2/J/4j/C8j2FTQafwB07eEnxhyQrePY2icmSdah3LJ4HPj7+qe1JpFzHGzkTSpm8qnFbl+f2CH7l/KtFHpxbdEPvU+XfJeiL7s/T5DsWrnPSsFe35xg3hcDArCOOWEgG9zLMrU1rNS3YD9p7QbSZ1kpbXrvsZspiayuHWIvLcWSYQ0murt+U4SZ7c0ejeV00e15HBiL5Pcn+eVu6B9tIgUvtWQzh768FkDY/0U8dLWYOTC2q5bUZq5FUJhHqV910Ydv5HJ9Up/nN8rfSD8vHfJbff6KhV9uRFbU9tR8eQNabwixUPh1rOP6hbk2JhbFNhsRzeNSfouwX62rcvPXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/WbQyh/ZXgSS6dp2ML2jsnXHlR+ULoPghNRMwBnX/Qc=;
 b=r7UXdDM7ck5Glym62Lc0r8FT82fByvLd31nuGBfOVR1AXxMIrKDFUZe7Avflho3jGjt1sGn7YmuMaLk32ySFlFtExhiHcZEVR9pXXw6lWZfm5ao1E6IS0LvcRLNq7rR4MvNUn7j2g2y/7Tfv9/herOJRVT0GnASIUOkMu87DGUs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0302.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:34::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Thu, 21 Jul
 2022 22:12:13 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%4]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 22:12:13 +0000
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
Subject: [PATCH net-next v2 7/9] net: marvell: prestera: add stub handler neighbour events
Date:   Fri, 22 Jul 2022 01:11:46 +0300
Message-Id: <20220721221148.18787-8-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
References: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0602CA0005.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::15) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f98bd797-8d4d-4ac4-4af1-08da6b661096
X-MS-TrafficTypeDiagnostic: VI1P190MB0302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mjRcYMadn0T+iifmKd/QOKG0RoyTcUPmPShd8P+NiEFRA1zZMS4Ne8+k4COVAGBOLqLb4Dm+Vf+J9QStX/8lEV0snN/rAZvSHdQqijUnnwzSBDmvs/CqlE+0UcvfI5dJCzkDt6epuOJu/tTqppC29zbhDg2XKQNGVbjUs6VWn12y03EVQ6RbAXA/evXDKqMrKI4aaQCFhwn2m5zxrhE7YKUuBrKHE7oGMbsFlTJOK302ktjgHNVCBizsmn0t6zdTpU8/uIb1chfvJem3NJY2I2+rnulBGuO/XM696Bs54aRdLCcU43Py8kFHTI8D3J+Vn+i5oubrXlMvsQ7f0gJmuLEklZv/PAMSw/y7fVBjjZqlzIZ0b2zLJYkXfUBmNB5dPrBKI1lumwvqO7XIu1W3CUsezfFYMrE6gUm7VNf185LV9pRKJ0mMKX0euhW/Xzbrue9dNuwWcdOJB+IALpXynxlFPsmd+km8RbZxsWZuF+CzBLMg4MfXxkZqySj+UrgHZuV9Y//OZEFPM50tfjkV/d4LnEuCePpaQvXZbEe6z8viYIlpxIsYDzvm+z/Tc4sTlq26UDDq7nfNVjKSVMH3ZyVL02cKC15RfAK443UnVH+5dL66jLfOPEJDIc7X17kAgHCn4FIuHSXbmSW+1tE6da9FO86j1dfBZbJR5xI8JvuMtsxbk5XyW1Jpng27KSyv7y6qSOTcjiln69fPPDfKy7ZkkTKUkP77vG7USGjD0GcFq45KV9OjItmOMEq/n2Xvk2xJgxLj2oL7cxnZMUjYxsdEjXpfddgP1eDatXPo4ws=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(396003)(39830400003)(346002)(8936002)(86362001)(4326008)(54906003)(66556008)(66476007)(8676002)(38350700002)(38100700002)(66946007)(6916009)(36756003)(52116002)(478600001)(44832011)(7416002)(6506007)(41300700001)(26005)(107886003)(186003)(316002)(6486002)(6666004)(2616005)(1076003)(6512007)(66574015)(83380400001)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HGLfgHe0JEM1K1zgKX1pa5XdzWUU/Pl0eXbjWnDwD3wvujQqbM+CisQe4+Ga?=
 =?us-ascii?Q?t4kcaOQvDx6Nq1bhIvicZm/ZkT9VTrZ4UHPZFbTJLVA0tiKNg+gIt7d0uWYv?=
 =?us-ascii?Q?so5InVdgnN566OGAbBLjhY2fsEcKDlZDdI7NnpPr0WqJ6mRIyW+40RNDrgsL?=
 =?us-ascii?Q?Mklpwk2/gnn66/ZFzA5LaZ5K9HCljyPtQioAVNKScukPY/KezyUg7NoNA2sF?=
 =?us-ascii?Q?Uua/OYJFJ+vbVAX9yjxG1WLbg5mhif7YTo9C6PwGBcONMlooNb87ityNNh4s?=
 =?us-ascii?Q?b/hdyA1qlp6ysAzydLZtKsO5nc1sJUEZGOq3pV3NgctVFyuoP/Lyeo8+rMlk?=
 =?us-ascii?Q?g4EzpXgOJPulrfC3zKEASzEsvX8hZ0430ScbxVehBFiO+nQBZmbvUx1JUr7i?=
 =?us-ascii?Q?iVFqSNustAGekq7ECyPFNKkKMWKuex5knntiWegViFiPDf+qWtAMo+NbVFqm?=
 =?us-ascii?Q?erP3f4PIRb2VBkgrmNke0cB35DYv5K+aip3ZcGK/+PVi5cyByx7VK5KTFvw/?=
 =?us-ascii?Q?vwawfbuzc+dGacp2tQBa70sHwmYdqYH3Cj8Sni3e1aATUSpq2zo1jQYcV7cZ?=
 =?us-ascii?Q?+Qt0qNvxsh54qEvQUjlDDE4HhcesdJbF3dVDBsn51M4B/oj9i9cjk2dD2su5?=
 =?us-ascii?Q?EgIP8CdLwvpECzd0jImJ5HwJcvtV9YsekESojbHAzZqe2dJm86/95Re2+DF7?=
 =?us-ascii?Q?MirQJc1rKUv77e2bq2Z/zE2qr+Fqo3NOyVEkdMCagmI8crdTkDPB9Jv5is71?=
 =?us-ascii?Q?gTILN/LJkgJuETfBoYcA4LomdYIdoA64p7EWMPcVV3BNttQu0LDlii5PE2wL?=
 =?us-ascii?Q?XSTqnGg9LMe3U+EnaUlRgZzMlqjJvQVxrHWKvyyTuk3WjWvBj+LiUDArrtk8?=
 =?us-ascii?Q?XzSHk3SDf71a3ezwMKPxyQ2scK2MAmQeRWekkch2v6EbXJfwuwwJ2eKIJhRd?=
 =?us-ascii?Q?Zq0F3qz7Vkan7MblVSepupTus3/LgQO/KadtFi90KwpQy3vD9c5/ixKu4gYW?=
 =?us-ascii?Q?/FOsqm1VoXbUgJrXdOEh0+pgg1fxfsRV2OaVfTjWpqa4oqsL241CiQMf8y3D?=
 =?us-ascii?Q?SBoaV6ICeGQ7fcEyx5Bc1pyWys9xm88F/MAF+XWKmwKXtD3EZKSc6RDwTfGj?=
 =?us-ascii?Q?LVA0/8dprllZyH9Hwqp5EOBjJ/cdCmKteZjt58c2pcvWLBcBhrKDFpHJyK6c?=
 =?us-ascii?Q?Oy2W2qvgpy8NjvwAsiKzvSKlwMDdMVBHldhe5jlOctVLfZzF0ABxqgKSkvim?=
 =?us-ascii?Q?9L/hz9FW1kiePLRYTgQ/L3Iv+cq9+gJuINxar2cmxQYPXbHYkh5t9NCe5d1x?=
 =?us-ascii?Q?NpZpQdTPn7wriXERzlN3NufDJnyynTCLXniJMeKqI0lJHBe8WgO5+BOSkS/O?=
 =?us-ascii?Q?FStyZehKwYfrRkNrAkw0XQ70PKQRuFFmhnwgPN85szqgNWpEhQER0Kj4Zhnd?=
 =?us-ascii?Q?F4jHb94EEFmiRBEc7OpSUAj8ZfeGVjVezmH2rh8XA68ioNjwCsxEOiByzgrW?=
 =?us-ascii?Q?bM3Vb3qcPwE2XJsaCRKrAZHkOiHBuATFuCML0xTGw0DHu36+hvC6lF7w+coA?=
 =?us-ascii?Q?/b3WgvXgpSZRF9FZ3mnjqgM2khj3HC1GY09PdF6J0m3z1JUJcJPRyyLj6ira?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f98bd797-8d4d-4ac4-4af1-08da6b661096
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 22:12:13.6717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ZueOiIsxK/jYdKVg0n8ghpj9GCyFzrCu3KOBRQ1gdFEvyIOY77J9ctQOf2YyFxJ861dYtUxxDsHsBUrKVR2ZZ5UyRMAtzqft++X1cWSJxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index a3a112f5c09e..33a0add529ba 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -310,6 +310,7 @@ struct prestera_router {
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inetaddr_valid_nb;
 	struct notifier_block fib_nb;
+	struct notifier_block netevent_nb;
 	u8 *nhgrp_hw_state_cache; /* Bitmap cached hw state of nhs */
 	unsigned long nhgrp_hw_cache_kick; /* jiffies */
 };
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 7e3117399432..e35ab79ba477 100644
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

