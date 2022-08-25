Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B86DE5A1A3E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243770AbiHYUYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243526AbiHYUYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:24:41 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2111.outbound.protection.outlook.com [40.107.20.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F3FC04E8;
        Thu, 25 Aug 2022 13:24:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0svE9Ivst/PPJSaTjFjmN+RoRWn0jvyP26lY/0Q1GczMQst0eGj1T8Muk+z6AbNuqbGGEOlV6kPFxCRN53nsAHr66Qez4LDqvSpoLd1V+fhI9QXOV5bKKw7cFjZuCNK0/O1WoggTJDNdEvVjr7DKNaqnU3jSlKaTIQLyrPMs+VN5cdoUBNATgTNPrHNcvQ/ZCDoM4wQCWd4LYroqt/SAeSCp3A7EnREskrkcwEmwemOgh9spJYSyUYGyOVHxlrOciYsb+yy7eEfKKKWu+B5ON2JljkXm4tGCLPdcxuTf8WVL4PmSdXXRlSg6f8U1YJ6zNzEh8cjF0mB6xP1tFzozA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ImaoqzgQ45KkSODBDK1vCqUIUTsIzLyxtWJ2ll9rLtQ=;
 b=YqA9iKnfxRr0wrI0il7C5beBPqtgCvj59KcxiMfCntwz2RgtWIaBPipud/CJombwblCRg+D7CVpmtoBLwTafp7oty9s8O8qrrrsN6xMLr6jD7uIFPmg8qml9PznCGpVKisEcfqmi4NfhXcFnoa03v7Vmr5M/pCj/GjXvE/Znpd7xAZAJaHS+yj3+H+s3yzPJrLe+8ofgVqqp5D5OP8IAV5tWRmM8ofw3HofXef5PXAvis/EE8MfteMjNvtBIbN1OC3Lhla8YGjAuc3VaybUTHYm3p1eSXFt01BBPRD3CcYq92EAQQESHyDU6lTe84mmzfjur/bqOv8FzmyEeoj9o1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImaoqzgQ45KkSODBDK1vCqUIUTsIzLyxtWJ2ll9rLtQ=;
 b=jJAoIetAsT3sW7en3BqkHuz/a1ORRNsITUykhFJjbO0QBuFVWpGet0CIDyt0nMROTP1ACOv/cb7L/8BOGFZteGIN8lpuRc96cJ2+wgeGAdPnPJAFQTvoaFq17TS3shYrTx5QEf+hL25m667aCyk7cvkbq6B9c6Vv7m8dhWFUwh0=
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
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v4 4/9] net: marvell: prestera: add delayed wq and flush wq on deinit
Date:   Thu, 25 Aug 2022 23:24:10 +0300
Message-Id: <20220825202415.16312-5-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
References: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e011d658-278b-4021-c6bc-08da86d7d0e7
X-MS-TrafficTypeDiagnostic: AS8P190MB1621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9nUL8qsbA6tSnKCagsh8lHZFBQNiEytrdEPzq/PQEWS+5hZirKCT/Q/uItxw0lJlPCSCS9e0Ui8TL62JyNwcDr20IwzxUS4s3XweyJbXt4uEGb3ycpnbiEWeZLme0/gQNlGUo/WLRlhtp1DZi8ONWW1TawJMMcm2ldv4mdu/TDH5eggfohpDQwwKIJr+vixpY3LiOZu60l4JN5GYPQu0XU8dngo2oQFdv3i+tvBWFInJQ2rDuQ/nvTQRab5vXcr1zz3+hAWReE3t/F0MgE+RlergcWHhsqwKAF4kLRx8LTg0dnt19SvlbbclRuMtvdsGOGO8dcVBx3Fl6i8XpuLaj71v+nWDdricKj0G9zWEgGmR1ddkd9S4C+Mc4qeOJzHWN9LvV7+IR3O4Jr4BfTZZgSneyZgklHduYZClNBgQAEiZqkQ0RufY42lRMytIbD8vlQ3LaNoQLz22ki+s1jMrmfz8PfaC+8FK2QmTlNX5bssuAKenNIXgWRySeifNR0nBHKiU1wxbScOXpNV5heMFzJCViY75VJf00+ZYvPd9YNxOSrB5IPeUICNLkyshGAfNYbUDbSeTEnSzBY6EXYFET91mEbqtSy5hVIlsRwiosAiBgcIswgZKN21ep5vlL6ZTCqQbUefi0gu3oV0EM9PIHWP/2G2U37dHOFnxZiui3RsnbOPYn9z/k7m7OVzUiqd3J31Ei4hwSRtnM6U9+HjLpIsrS5r/iaQCLKPr5FpIDtxMb7ZwtnpKF4fHb1BMsI7u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(376002)(34036004)(346002)(366004)(396003)(136003)(6916009)(41300700001)(26005)(4326008)(66556008)(8676002)(86362001)(508600001)(54906003)(2616005)(2906002)(8936002)(52116002)(6666004)(5660300002)(44832011)(36756003)(1076003)(6486002)(6512007)(186003)(66574015)(107886003)(7416002)(41320700001)(6506007)(316002)(66946007)(38100700002)(66476007)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hiyddAyaoOpYyeBuCXfLl3xdt9D/liy5TUJTL1jglRifNSE+IkiMXyLhuL9v?=
 =?us-ascii?Q?8L+AcN07u6VkztY722TXk1clnCkMEJV9kn8VSS/mwG/U9EPPzdxjgWZcBbAU?=
 =?us-ascii?Q?Ze41Ue/cASpSuYKyQToOdlTUnDUoUjBMWYEJLXdrac5Bu/xllAmfxhFnjmNU?=
 =?us-ascii?Q?6Qnu0vPJ89Lv01pWZOAznR8Z6lxtVnF5fQf8T7fXyD1pX2tnQ5ww7LKqbEKJ?=
 =?us-ascii?Q?FwWnlnUrSymJOw+6nu3+8A9Kjl7jcNARZtbxJWU1hD9/UwwqHxnwBROPHQsh?=
 =?us-ascii?Q?4PwXcvhoyVdHWpmgrCIH9Z0PP5Vspq/vAZMDwLi3MgPXMx7YMYciGTHL/V34?=
 =?us-ascii?Q?wZm9Z+WEQe/7lonZFYVdntMfHuwbK+cJ8eOfTLAkze/hlb1Um77HhyvONFl6?=
 =?us-ascii?Q?v/L82J9C/X/JAkoqc7hrLWFy8BBTRvlKnFCbhRttLqhCQ/FwjCWG2kGlR7Ma?=
 =?us-ascii?Q?l62UHtz6rsqFKsiVG0YK8dHJYngH9nDoN1m2/ZLI56ffQG/ma+mERn5kF6mt?=
 =?us-ascii?Q?6MeTQiIou6K/aNCavZvURH0MkKkSzL6Im/JAvxu/deXyz6UfXtuoRYPXwIJH?=
 =?us-ascii?Q?7FZzLK9zPSev7OjHHEiGQK690jH95WZFj7Yk26sh4ZWr3Vi4UiHUCJBhFaol?=
 =?us-ascii?Q?rDuWx+jxBnnq67xGX24uO8yNAuEFaMk/lynivQ8W276w+Hh/nPaD2rkcQrJe?=
 =?us-ascii?Q?GSVx+jGCb2IyAx/hFwyymbsr6VwU6TL63iPdsjRordNb+1QZZY2AnLcXQN9c?=
 =?us-ascii?Q?d0w2JnD0a9AwZ/r6zWP+KqVny0eo2oSkrfcEt8DbA0nbMAeQPeKvmM/KuAkb?=
 =?us-ascii?Q?UWCCCVaMcr0ogkh3S8zvVIhb0UQP9pkZ7CFbyTAWhmFDMNvS6F7JgdmMiwK8?=
 =?us-ascii?Q?YWKXk3GxSjkiHvPHxZ5oN7KY7V8Bs1YAEeaCcIHA6TAI0PO1sMdObz2xiC7d?=
 =?us-ascii?Q?x7QGd9fCDEiA5oa2OdzhbvZCI4iSq2Io807q+ZjkcFhZE2er5EACXRfLQVaQ?=
 =?us-ascii?Q?xqoW5w24S5EDhP6oOWDrGWmVVVO5svkbqJzTsYi8nYUi7pYaXHHt70s0dQP2?=
 =?us-ascii?Q?fkh2y6O+hCuFg3764bnZrBH5Tn7mMvjDYTDqZd8sCP5fDWYtMmeJzLz8WGEb?=
 =?us-ascii?Q?QDgivwn8juaYgNRHAl+7XTEBYq3/9LCl3Qw60EiFja+7UHriXS/uf6J2tfEX?=
 =?us-ascii?Q?aufMmbpqUp8IKJ/drA8a6FdUhgTzSCHn8v4iK0Y3F/Px4FMP/sUw3Rf3Abq2?=
 =?us-ascii?Q?YLLj4/+3TQyTSw7GUcr4ZgaSNVcj7sbiR87yi7XRzP71GKrtgLPhSXeurLH0?=
 =?us-ascii?Q?Vr7hLEKV63L/8MF+PQUFcANQmL3VmICP3t7JdHouaV3I1zSPhjTf01vYYWk3?=
 =?us-ascii?Q?Cp5liBDfqYCCaN9heFLl8WaemTgGMoYZw80p2i/dEsiKNCdpmEDRPlIyb9cU?=
 =?us-ascii?Q?okYjOe/S51TF43jXZYYKOEehq9dnlqMxDfzCSK21RQsXnCAydoKMvh+fqIvx?=
 =?us-ascii?Q?fmbW6Z7GXun3gYf6Vu8qyzbjRR5RHHpx7XOOFiCujb1VjtwE1TYn4rgxewsz?=
 =?us-ascii?Q?wzNw/QzwQt4CHwWRHfgfYtYbBphb8yG4R4W0g/KJ2UBhiXG5Mf6bwhft+mI3?=
 =?us-ascii?Q?cw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e011d658-278b-4021-c6bc-08da86d7d0e7
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 20:24:30.8381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OdBMogVosdIm3OQ6Fq39pBH3dbACS/8khU0BqQ144cwkaHteKSCelfq89QdC2NtW74iB71J9ixGgQClzvFHWZ4LSDgKxTYHYdn3uwrQ4o1U=
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

Flushing workqueues ensures, that no more pending works, related to just
unregistered or deinitialized notifiers. After that we can free memory.

Delayed wq will be used for neighbours in next patches.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera.h      |  2 ++
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 11 +++++++++++
 .../net/ethernet/marvell/prestera/prestera_router.c   |  1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 282db893a577..a808f1fe85af 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -367,6 +367,8 @@ int prestera_port_cfg_mac_write(struct prestera_port *port,
 struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
 
 void prestera_queue_work(struct work_struct *work);
+void prestera_queue_delayed_work(struct delayed_work *work, unsigned long delay);
+void prestera_queue_drain(void);
 
 int prestera_port_learning_set(struct prestera_port *port, bool learn_enable);
 int prestera_port_uc_flood_set(struct prestera_port *port, bool flood);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 3489b80ae0d6..27435c3e82e7 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -36,6 +36,17 @@ void prestera_queue_work(struct work_struct *work)
 	queue_work(prestera_owq, work);
 }
 
+void prestera_queue_delayed_work(struct delayed_work *work, unsigned long delay)
+{
+	queue_delayed_work(prestera_wq, work, delay);
+}
+
+void prestera_queue_drain(void)
+{
+	drain_workqueue(prestera_wq);
+	drain_workqueue(prestera_owq);
+}
+
 int prestera_port_learning_set(struct prestera_port *port, bool learn)
 {
 	return prestera_hw_port_learning_set(port, learn);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 22daff5d9975..fc118792487b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -643,6 +643,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	prestera_queue_drain();
 
 	prestera_k_arb_abort(sw);
 
-- 
2.17.1

