Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4ED5BBF8D
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 21:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiIRTrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 15:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiIRTr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 15:47:27 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80102.outbound.protection.outlook.com [40.107.8.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDED17AAD;
        Sun, 18 Sep 2022 12:47:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9wRCY6IAUcOQTH3an25Un8KbzdUTIf/zJcWNYySq3eKBKz9lu8RqBI16h9hK9Xo/hLUtpVXJwWJ0jL2rWocjk0aYYk8hDGEdZYC3N1YSYMvml0HcvNHe+5CLmSqhQSdCmoLfUKJ5YTxKq0MSi1oUfHvXMs5grmixEG/g5lOeUJNPHZaa3GaEPdy0YUyDa86zGSN8WjXg+CfLoxc3uhsjFYNz+hO0rmX8vitW9B9iYXR7mNuwCdXjDqjgwSJEDO7uq4g0eDtJ4XIwOJA3Y6eKcqdG/w/lkLJepK8RTkmTYbsYpNdzxx92DRTRoFtaG8foTYrfSSubUUxR01Ai2uAew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H+d13HuuiJuhC6xOlB1N15/82FVK3LEbjcNI1Io4CUA=;
 b=eSPe2+tSh7cWxHKFp/PKsASrUUskzkdIwlfe5q9tX7/9wXVeLcpj0zB1hJTPfCISPTcDygcDd20n2KTe/ZPmDpMIZNWfvdGUc9yWJHvLReh7SrLPuDhzXswA55NbR/n3XWTVWCCp4nFsoq9kHmwmBnMMD47m+XtePHmfWR79vOhsZB7V0Agxdi5/62+1CZCZT77BXj8zYygPJXjoovdnpEQ2EL/ZwXEpClgiyTiqN8b8gqfmuEFLAvbjEndMi4f4rAMRJKTDfAmxbtq9R1LvFdPsdFL6OKm2YrJroqSVNuonX6j+JZvrztXMN6eo9VrQbKY/AgvYmqCWSplG0/39hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+d13HuuiJuhC6xOlB1N15/82FVK3LEbjcNI1Io4CUA=;
 b=rc99juD+CbAjtg3ZXc+R1e24JKGOXPT87JnIhTh+/Bjy0DVI2dyzUfsSVrc0QhJRXP9AJOL2/K/KaBqFqcfAO7M9NGnHyUdn5Mv4/cnvxOeVR4897XhCT459c/Cw0dxHJQwz/ebXjhYjg6V/uXD/F6NcKNSiI3LhB/TigPyRR30=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS4P190MB1927.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:513::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Sun, 18 Sep
 2022 19:47:21 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f%5]) with mapi id 15.20.5632.018; Sun, 18 Sep 2022
 19:47:21 +0000
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
Subject: [PATCH net-next v6 4/9] net: marvell: prestera: add delayed wq and flush wq on deinit
Date:   Sun, 18 Sep 2022 22:46:55 +0300
Message-Id: <20220918194700.19905-5-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
References: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0006.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::18) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|AS4P190MB1927:EE_
X-MS-Office365-Filtering-Correlation-Id: 59b38e52-faed-4881-59e0-08da99ae99d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pkN4+4Mk9faycHswhb0RtICf8S76vLo16WLKpa3nWyDXUW0utF3GGAXIxlXejo1GDO7dl17cXIXFMK5H380eDWPLeG2r9lIP9WXUNF42cHysLY+ZvR9BoW2ADD6VqVsXDqdjNC441KhIwxGLvWcZoVH+GtKoHDvh041zhdXwKOD7qd1/DtMGNLWEeMiy/numpZiqsW5/QKWBBJg6fKRD9g54jNc3dkvqVzEwO8pBeY4oPVcr3IGsoNXdxuyFm5Kh/LPfCQntFRjgF2HkV7ASFk0klEEvjWBDDB0753shSNYR5dW/OE6eS00GAaqRqHvc9NCdZazj0mFjkciDQ+M4raHlxoWjX9vaRwofKYkLCrPGuz+eW5Yf+7dFhqPbwOICE2m37Pvwn9Rlv0Qm2rei0Y+h/xXH1I6VsWznm5p81ifdG8zgsM1mDMoGcscjNk4wlkyUAtw7py1ooOx7rcuBlomzJCCWBAzSZ4ywJveRS43pbMgQvPai9wou7LTv9XA2nD5Q0v5hl4N+/RdGRgbEoKEnobfwWYEQ3au0SfOcKb3AcfdD4K+i9XQcfilwVzDIrtmTy8M57zlkVaBakEOdL3Xbp7RJBizzG/DEimz5Nv3VIQUzHcc1kdJIOU27rO6Ad78dRB7ZSdmDAqIysFqhM5LilmcJKYAfuPnl4E04ThYbpPyM8F+JL6TJKcCvFUSH9To7IJLMyuk7HEnCCwhynkrQfRQS0NzN5bI/nGFKsA3uQDvU8U3RYsmBgsm/EY3k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(39830400003)(396003)(136003)(451199015)(478600001)(6486002)(316002)(36756003)(66574015)(186003)(1076003)(2616005)(86362001)(38100700002)(38350700002)(26005)(6916009)(54906003)(52116002)(6512007)(6506007)(6666004)(107886003)(66946007)(66556008)(41300700001)(44832011)(5660300002)(8936002)(7416002)(66476007)(2906002)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2rRStmM3IinfKo0aWxK9XvKgQltTPhxRwC+WSLZdmZTN/O+cd38Tq9J065gT?=
 =?us-ascii?Q?RD9jpqMUt22tcri7OZiABrXOrNXC8ZqjUO+RJipuvuwKiNiYBjvroc6jl2fw?=
 =?us-ascii?Q?nGeJvoFBuGYIgNQY18AO8X3vxkmtV055h/jpOWus1AKWIL6BisfogPRG8syT?=
 =?us-ascii?Q?gxI6MChSzab3JoZ8GVNOYn0DNrE29jA8svTlo4kT3pnX8CsKExCOZ7hfr2fR?=
 =?us-ascii?Q?L94ls+yChIWflz+fYxV0x/q/SFtwN1eSERv6MWuqvGOO026lYLelegk4plkm?=
 =?us-ascii?Q?VHQr6dC1IXJKUOEMCRDFswOFIA+IjZ50kgsAeUvmO1mLfp/A9f4FS9JYmV0q?=
 =?us-ascii?Q?je+5bVPx5qK0nx11I5JeHwWQbvyioE9mWbT6TJU1LCQxSVjumbpc4BWyWdLX?=
 =?us-ascii?Q?V+zZUi5WDs4ZoMgWQFMr067kGiWGusLM1iS3WN9bXg8Xo/6aDicHk+hOAipF?=
 =?us-ascii?Q?+38XWX9gVSXlgSP6YzuuYdvTmdqg9NSLLzm2UAxIqgesNj0oWpWhZl+FbJ0Q?=
 =?us-ascii?Q?bC6PeR9yS0xfTCjfeBEG1G7gYFoCahRKTO6ZWI61IIfXvITYS0e3zy/4OBrS?=
 =?us-ascii?Q?q3GK5zsn5NbQpN3bTz10gw2+j45mQCqJ7yG+QUizzHWSucUcKI6WDTtL0Ddk?=
 =?us-ascii?Q?wocJM8vyviQNPYcsOV8YMep5piPgQlSA2+uCr2CGGrPW24eoVzb0XC5/n51N?=
 =?us-ascii?Q?RBMIMMtgW0bpkY5eGweEnAYPaaptVV4CrmPM8ShqUuTPSZdrkEc0PmXEyPBK?=
 =?us-ascii?Q?xF+vXBV8z64RTrwvqXk0XaakQEe+xQtLgHq2Z4T1bEDzJ20e5YWAKp+Grchs?=
 =?us-ascii?Q?z0UYJU3Z2Qjt2Y90C9R9e4Z0g0FA4OhB6C3ld0mGByjOdgcOmFi0DJyQX+Ac?=
 =?us-ascii?Q?KldQ1KuLl4g/pqkVSgWognwb09Wlp2sGmI7SZ+F4UunVzRTIr5/0kfDrDXCR?=
 =?us-ascii?Q?H2ycBGF940lmUJOHoY2UlpXKGYyZbWOIU/mTX7ujsGBZkEdRRP1uA5Mq0vXW?=
 =?us-ascii?Q?dqTuYp1b1VGW78ngl6sasEdv0Y7czoIL5Es9Or8eyv03yT5t2eJzIjVTQNSz?=
 =?us-ascii?Q?bO3d7JxDVLGL8V7daoP+uq8EkN3grRGAv5RJ5+rSfXi1e3j8WpQYg7qCdR0G?=
 =?us-ascii?Q?4iVnHHmwsx/oN5bxQc+4X6fDd56kewJ1+fIGfwVL3S9oet2y7nZ/yw4D1NcZ?=
 =?us-ascii?Q?3QbqooRH8T0JK8ZCX+8QanuavbX1kIFi8ftwDNOTWhygk6xbjtnZgUZYnu+B?=
 =?us-ascii?Q?iuTixMMf6/R/ZwkAqTI94X86OV9Ef9wEOj8JAPullgvmuuaJdnyf4NkHa1BX?=
 =?us-ascii?Q?sbgVe1R6NAeesKXk2dfXzmcJeHvFFADgnjO8EAobbOj3kxrHgqEnMjmyxKBu?=
 =?us-ascii?Q?IrmAXLVSoI07lG7e/V37dzyGNf3WakGbcI3BUSYfz3atuCfLuG14G2idSQum?=
 =?us-ascii?Q?VNgA4XnQU6u8tifhgqy696PdtyiRVzTTMjIJKo7CI9ERmVHn8j+8gffbp2K0?=
 =?us-ascii?Q?/It0u9KRwQIrfcgpWMpcKqfDLG0bO8u22z08C2dFfPSwPzDwmBgnkWqupj4b?=
 =?us-ascii?Q?gA4ATRz4MOIT3207P/2xsP5TLGEUF+Vd58Mn6koaF1/+5Re4e7fZZY+lxY+W?=
 =?us-ascii?Q?wA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 59b38e52-faed-4881-59e0-08da99ae99d8
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2022 19:47:21.2048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JuIYPa5TV27NBesmMCY3bA/OgmzTcmSgwjvvIVF/Yj5jHw+ihHFtELdOQLYTdjvOnBCW3wJvTtJ1/NteIveS87g/Ho0DchQeNIS6VYCJQXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P190MB1927
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 903e2e13e687..fe0d6001a6b6 100644
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
index 3956d6d5df3c..c0794603a733 100644
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
index bd0b21597676..c8ef32f9171b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -645,6 +645,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	prestera_queue_drain();
 
 	prestera_k_arb_abort(sw);
 
-- 
2.17.1

