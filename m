Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A55856D06E
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 19:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiGJRWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 13:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiGJRWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 13:22:42 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60113.outbound.protection.outlook.com [40.107.6.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AEBFD0D;
        Sun, 10 Jul 2022 10:22:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TH98JJS7UK6SbA9newl5f1GT/lBt9tnM/9mxvNpI5YiZ6Snz/1ZPCPMU29pwJa1AexHzV2XKU7DIfOVEyRWTkoLnkH71hmrm8gmFYXUjxWO8yPRVkVX2kZ61f5idSJ0f4ihkaP2Bqhdyu3+O98duL+fhBCtfqpD5F8aDnhV7bh+LISutuR90YBxGQPbU5LH7TQP7fzd+kTHZoypHfZpuyZXEBMU69sGtBabAHpPHiyUk5sB4bH1mw2hDNF7f2kA2qHEmpmA1V+o0wgbgvBx26Baan0iFbr3pywOQSnGNhsys50Rw+ktfFOGbSCmw9dZc30ZfTWE2XF6zkreUI1EaAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+rum06F2lmcibRv+HevzGMuqRw68ESUCMkUSqRGGf0=;
 b=X16ms23M3vfOTKJTD2P0JnWo3ZlC7kWTCq7OhqzDLVD5ol3WdGx6J+LeA7lvl4ObVkJ8Efjl4LmJ1WMpnQalgyyDnQkV8JbODimpmAGB3ZGNNb/DaLyrthmaE1DLIQNEtT6b1ejOqcWWCSBKcSVuzapodvj+7M4rShJt1eRSRXqMQO5dBG4ymnM9vGkWDWHkrW5qiIjfqHlFIIAODJgnUPdF0KniXNKO6Lybzjjq/37s1toSxc0i/goo7lbjSFjDxr4NztVaMi+uwadq5ia5U1/FaDdwMvev6AMkANCSc+1QG2ESl835fQ6DpyzIn8ebv1VQj2Bxb509DdupMCkveA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+rum06F2lmcibRv+HevzGMuqRw68ESUCMkUSqRGGf0=;
 b=yoMvuHyJUSSv6YOda1DOgHEcVlD6yajwRx23bJsXHBO76r2XvQ93auEtaV/hMCH1cgjU63zcYTxKmA+POAhPRuZsTXYKpfeknxviWHVngMwJPZ/ra/YUp3bygszPub3mEe1Bsxm7zupRSBrLAWIUc58Fs/LzCeOalfCjIfjaIYw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1109.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Sun, 10 Jul
 2022 17:22:39 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 17:22:39 +0000
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
Subject: [PATCH net-next 4/9] net: marvell: prestera: add delayed wq and flush wq on deinit
Date:   Sun, 10 Jul 2022 20:22:02 +0300
Message-Id: <20220710172208.29851-5-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
References: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0058.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::28) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3aea9de1-abaa-42b9-b840-08da6298ca0a
X-MS-TrafficTypeDiagnostic: AS8P190MB1109:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: enQ0J2eexKv2zXzHRgr5lXcjYnu1Z95idwqazkxpYZtE9gL0QEIbDOGGCBfBYBCYMi+9/B3BT1JKuy+Z6IFPcU49OKs9BZ8q7LfbROyrjJJzTvUDC2tP/Y5eAvO6TX9YsIxh15ncf1ASrG74N/d5wcaypB3JWNtZ0WpQ6DRTDeh2mbR9ICEP9KiZuML8o7VrOEFshNspdaIO38BeY5vSVzj8IOokNUV+9tRggg9/WXwkl3d0yoX8A1Xc0NJsycRRuuRrI6vC7SQ9nq2T0MzhBnEgxmJG6huWHBO3CdFiZo/w14jdvK0iqjTw4OuO6vvBWK546+jv0huqjyeLR0DosDBtSHMWFXMxe0kgjQQ5Gntx8D+7Jj3OSdCbvP6Cn8xMQIfyzM/69OAT5QvmwZbPx7+LniYeU/Ujd50tAaEH7W2JE5zduuu5gBErTvXLWRXwlJ6q+CmjYR/eEN8UYjiaSgnwyak5VF3eotDdLg1yxqBOwpkmHLTdkFOILNJ+6cboCwb2Rdt+6TZaK5WwhhyYbATVHFK0VFtEwRyhqLtJPiqpJT2wnitzhFJyS6VmVoYXHvxjKOqdaoyOIVJC1UeSnfwRGx2SjPF6agkegt4LOm6VxFrRC/pixi6b1z7LhCQt7vk1eK/SzGiz1X1ii19eNLBkfDihFciUrBUIk0Q4SQooQYIXkBl83P/sYR+/Z5qv43rP4C8ylahTum9xngRo88yCbRNR4Kgjun/6qRdUor9UfTDV3wlXMaoIwmb3T3mf9s+sgZdggZBTLGtcGqrjco7E0q6LQnzWS4lAb0Lws9esjrim852uCNFUwxi6zEph
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39830400003)(376002)(366004)(26005)(41300700001)(1076003)(6666004)(6486002)(6512007)(316002)(66574015)(2616005)(36756003)(52116002)(6506007)(186003)(38350700002)(2906002)(38100700002)(6916009)(54906003)(86362001)(5660300002)(478600001)(8936002)(66946007)(66556008)(4326008)(44832011)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lVIwF51L9p37YsMd7hrN+qHsOUTu83iP+cmw94wSZV9f6jjVeVxoUd/WS/cD?=
 =?us-ascii?Q?LSIF2mzoCZ0M7M2JUTBgKSJKCOV9G3MIBA0PWH7hletnkZWPIgDHsiH9sWkR?=
 =?us-ascii?Q?ArInfDKbC1MrId+/xwIPID6ubowzE9d9vOKMoGrCSBWuZR2pO5NNUfkRh0cp?=
 =?us-ascii?Q?2dTuwwTDWSqndiv5fxNeF6dT7/EaelNYowlG0sHI/b3eN+hpd/rC1yqenaI/?=
 =?us-ascii?Q?CZCc3X2D3CyAOWEfC45s9kQHqRflNPPtryoXQrQAUD8Bzn7NOvumVsh4HbiL?=
 =?us-ascii?Q?EbrQ4lam/O6ZLcL2k3RLX5CSkiGC35M4r3RTCEcoEUcpde/01iZQp0Iy+KT6?=
 =?us-ascii?Q?aElZNCQciiAGMQbvdvKlmkhlopc9RSUdVx0N5A/jHpQ37WES73L3q6+BDgbG?=
 =?us-ascii?Q?lnkr2nKeteFhNzZlY4kVeCnyHEDCbtRv9rGJDDVaM1iomDGP5ebap+Owj09s?=
 =?us-ascii?Q?WzkVwDDLnAnYdO74ucGNCXNl6AhdKlKR1tDm9v7BTL0VQ7niD4JesMoo/UVx?=
 =?us-ascii?Q?CdxILo9pZGarFxCEEOrCseehYGjVsX6kusAhS+YVjDIqWx4cWRJFVCoVa4x/?=
 =?us-ascii?Q?KoxA4S4gdBwMoWyumX7PeAfQU700VDEKKpN+EH14PYZJ+ounlciFI5hyCeUR?=
 =?us-ascii?Q?AC1yBd21P8IzGPd+9um5KLIYiGV0DMDtxsA+xaWNAGxx+aWnYX50cCppGhAP?=
 =?us-ascii?Q?CP3AokCtvZtIuGVUbB2oJH/9Lnux7JlHmF4toDVCAgvrFPK7Img3TGk66ULj?=
 =?us-ascii?Q?pn+j1ajvlNYsxJc8xRcHgVx45qwd6vFubNpB0ytqganbkLyGFGJ3ilJoWX8W?=
 =?us-ascii?Q?gQnQskI3s6FoNz7Xeeu9xrsmUa4DHANiehP9CnkQs02gjdvAXNKg68YZpqkz?=
 =?us-ascii?Q?ZEXWDKn7JNRx4kJsUKn91V1lmu+ywBSaC8r/DknRTkx5DTJMbBCiy6Sp9XOC?=
 =?us-ascii?Q?zCKA1jHtsZzu3UMjQe+WyoI00V7wmmz5LN3YQIxvfkHpMK0TIR929WB1W64R?=
 =?us-ascii?Q?hT6Rb7vmoI0T0HJhz/gH/HDjO+Pbnv/44XYyrixSr/B9Vvh4BtYR1XzzUDI2?=
 =?us-ascii?Q?o1qvTpuzJ4dVJW35/ba79c7tnphKVLVBLhpa3tIJeTtYW/jV8yanKGUWDxho?=
 =?us-ascii?Q?PCh/zWx4+JKo+jiqXOsr0/iDac1/AHyfJ9hMK9dMo/GkDHVCyxrPRcYOAVg3?=
 =?us-ascii?Q?oN2OLZXjkG/FXmWr59iMf/dRNtpIHkVeQxVEJlobfPozw8WgZCO75OCThlQ5?=
 =?us-ascii?Q?F6ygmHwRMQyPCEiDTvNAX8KyDIztSGSx+Z3JGXaSJfIz7IuG8FSMREuf/zkj?=
 =?us-ascii?Q?GoejEebde1fFhddOi/XJlvQ4WCbgJGtE8mPwUI/TEUe8jTtM7p9nM8GnnHSl?=
 =?us-ascii?Q?xgVXFyRe55TZuxCQ9bv6ZquW/aVBBIE66T71RLKjYv7XPxe0UMTDQihKaxr6?=
 =?us-ascii?Q?BXDN5QEGAlBIxyU2TsCf8h7NUuKgo7u67HtlnHOoJz4Uo9JSGt4GkIfpnxV1?=
 =?us-ascii?Q?fd1knD1i15dI4XAkv+RtN+bg9xe/fsMjOM7lf/+HxVdkyQUDiLGhHEGLbUUD?=
 =?us-ascii?Q?bHuulKKsgYMkeQeA1udRes1Wv3423MjN2wByaxXN5hT5pAyFvaBA5+N2GAA9?=
 =?us-ascii?Q?hg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aea9de1-abaa-42b9-b840-08da6298ca0a
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 17:22:39.1691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzTPwPsx+SFKoh6UXzh0mB8/L+EPr48GFZfWTAGoby5d2PuwuW4issbHQkfNhhxQK9oqPrsVC3rrudss7N2XjGWxfuFdV8ZsA2kYbovuXBA=
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
index 7edb51f1aa45..e53e5826e620 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -335,6 +335,8 @@ int prestera_port_cfg_mac_write(struct prestera_port *port,
 struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
 
 void prestera_queue_work(struct work_struct *work);
+void prestera_queue_delayed_work(struct delayed_work *work, unsigned long delay);
+void prestera_queue_drain(void);
 
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 3952fdcc9240..e76548e194a0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -35,6 +35,17 @@ void prestera_queue_work(struct work_struct *work)
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
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid)
 {
 	enum prestera_accept_frm_type frm_type;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 41955c7f8323..db327ab4a072 100644
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

