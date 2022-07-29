Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470365850C3
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbiG2NVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235982AbiG2NVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:21:41 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70087.outbound.protection.outlook.com [40.107.7.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A8561B30
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 06:21:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EuR/Be2tEmdyLjlbmbn421uPeNU2Sgd6u/RQUD9xDtNC4DvNXcfwo5Hf0xwHHvWpoUR1iqZN9KYZ9BJkFzfvh5GsQ9p+XAN4lP4FKc9wN3tatYohYZPW4eLydajO0ND/UkyYRfBg3/F1zRGRi5QHXUWHh1qHSRbgxS7bV6jyrA9eOZfwDbzCpdYOkAeIsr/IO9qjfKCtDdsrf6pU4cEPIpYmbzd1Qd6JcxMKp2/bY/iyq+FTLW0FtFnyrmGM70Zgk0BTxjnFXStKQ9Ebja3YZNDkp9UrA7wgBIK8Eq3ddWgtxH3ify2wFyh5geiWMLnpChZcUUaf1j6kt4h1LC7fbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SH7mmonBAttINeVIGF9rBmi+XI6Zc+A+eiB+aZEFWUI=;
 b=Ed6IPOg7kq2Fb6+rfMvQJOgNBWWe7/d0pTtJV6bjjK5+aaQIIPnOnj8zoT6c8NlBTYFcUjNbdMSG0lvvAsYgkV1HVByVlCpxX5VL1RRHdInNex+5sfQiZ88P0jCbbXUqPM5x6jEEooQiJTVvqfoPBs1AM5FAUQql2dXoxk0rJBFK2IhA9YRoTcoRld+PF4IXp/QflIgMLf0RR9pK5gHQqze/0wlZjGsBg5AYTL2uT3sH4HIMMn9jnZLRaDa2ZcBkHWleZUUQLXooCBKzOnQHpVz5544XZYCWtfYRSlryIE+MRzRiDuYg51l5lcPr3q0PBj0m9Qdo+T6Y3prv22++lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SH7mmonBAttINeVIGF9rBmi+XI6Zc+A+eiB+aZEFWUI=;
 b=ZELg2p0s9zUW2eCY7jji5Edm5310sSvqJy/fnYaOD50i0nXUDOmTlDzRfNcc9BRCnGJ1k7I19lktYjrOloJrzrBdp/7oF36CJsAzctUTF9NszBAsYRqPdmP+Xhe4fTmMsSOeAQFwJyPLJoGGgdQ4I5a/8F2Vt6JsCa69fwOj2dw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7497.eurprd04.prod.outlook.com (2603:10a6:10:204::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 13:21:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.011; Fri, 29 Jul 2022
 13:21:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: [PATCH v2 net-next 1/4] of: base: export of_device_compatible_match() for use in modules
Date:   Fri, 29 Jul 2022 16:21:16 +0300
Message-Id: <20220729132119.1191227-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0022.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10d01817-ae3a-4610-e4e8-08da716543c5
X-MS-TrafficTypeDiagnostic: DBBPR04MB7497:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZW48RFHTOAjg8bAtY6XQU7vEnGzBz0GSA+N4ylkTJaAkf8yrX4Pr8HULVh9SSErAnYWX8srOe3kFIAS2ELxpSyVeQLnz4ou28NlzThGOUq3yedEnbC1h60gWZKwZ5y0Swroh3/Ti8O6VKG7JlxoMQR0WJjAmP9VgPOxpuDcQhncYZ2Ogc8MABl53x0F0rz50TRIEQNiMFRjVpnsbt5SjTkOc1mOfSMEO/nsttp5ZJzSk92tiz0tz460oktQDyRuvAPdIdJyHy/illCYdvUUF5HCGoV4E8KjcSiyL28Az9iacfBr/Feh6PtCnQOnb1yn+FJmWmfWGY4i3R9UtCgw/+Z2JTF8ktC9fEbV6xwunF/SG9k+aBf9aPv3+ZWJj0p5UbOtX2DVtQOvGKj+p3k8o+wfjUnRhuXu3lKuR6jtUx+0N9FPWHLJ35Be1Soj1ZHGjhCuEKEBbEf8o+7tPdlaPwRqo0DevcfJNqVymHwFGQPXbliKY6e60R5cUipO38LV0i+ddqzpUR0nfsAFJ6ReGaH1odhgxcgXSccR4ODDvF63bbFvNKOjj1aOK/9eKOHQf1W3HZHJsVFXzHfmN1QJdvXb1ajKywAAnU29K748//EyfMDcCaykKBGWIbS9ZsTFIIYHIDHQ8PYV3sJkxf6TsACAok/9yhlQ3bP8c6jh1AJcXPcTNbRaBy9AjjjoGIL0N0FzDdvuh5rEwhUs/OD8vIJTWJGROBm96YbDi2Bvz8m/DxS268nm5InMhDtaGvtVJaY/RBptuG5ufUwiq7fyPGiQNoedFKrE35ZiF3qV/+KluEAfu3cxjbap/bc89QVe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(1076003)(6486002)(2616005)(478600001)(52116002)(6512007)(6506007)(26005)(38350700002)(186003)(38100700002)(41300700001)(83380400001)(7406005)(66476007)(5660300002)(4326008)(66556008)(8936002)(66946007)(7416002)(4744005)(36756003)(44832011)(6666004)(8676002)(54906003)(6916009)(316002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0a4AuoFca2dOHASBgdSyv8mN+Wod9zKLLZ/qBxdPoyBdrB9tikcLmn3X4+/T?=
 =?us-ascii?Q?TAvTbIuhBj/KhrqAWNeOeqlkIYs1LeXDOoNmo6WiwC1wv4imoBB5FCPWAXFL?=
 =?us-ascii?Q?WDcGz2dKR0BWKVcyJP0VFa34xynJTv7NxUXyRWtozTLexRIV500DIxp0X9Fi?=
 =?us-ascii?Q?QffSFxTwgpXHZ7BxpEOu5Ev9TP1MtvQJKDXHKQFPyNcjMXDdKeLVz3lDRLp3?=
 =?us-ascii?Q?7Euo/4b3QGxza4DxwsWJ0eYEl5sKRbh6rSioiEIz6oy6I/zA8F7uo6chQHJA?=
 =?us-ascii?Q?tYa764qvSmaj7BkqXJYj1NUYTxwUSBAb8csgxM4km6ZG8zzRxDM/Zwfv/sm5?=
 =?us-ascii?Q?EzLX9lIg1xK4PagD1lFZcFTzWmkHNfn9M82Urvop9Q6mSM174tKs6ZLdGF5h?=
 =?us-ascii?Q?KTlZx4p5g3NkwqPdrdhFkGwf1EWNJCdXlYcUmObSuR+jeJyTs+Ja2m2J8sWa?=
 =?us-ascii?Q?QpWdIcicdMS0KCbXRMBaDYSu1AqLVstk5pMglyW2ZFj40yjZjxM+qzw46g55?=
 =?us-ascii?Q?WpBkySqv7x7DSXC5n5ff6iq/mi9nfoKzxztQX3IrzTc6XoBEEIkHuV98zp74?=
 =?us-ascii?Q?sIYN+Miel8t8XJNPNIJDK60md8zo8tLz8V7FIQqnKLbPsVedmkjLXT28RRme?=
 =?us-ascii?Q?68w9aCUGwkuaYGN2BtlIKoYyQPtn6M9AR3hcdVPfhrSqSodblhet1MVsJAe+?=
 =?us-ascii?Q?QVtg99uF1dIR1DV4aEqWmFp/HtLlwDHEjHOfoVQTDXAb3ikym7ndJeBPDi8g?=
 =?us-ascii?Q?flO3YFZItdV8u/ydzVTR6ZfvnEQxzbdL3K//vGyiyJqrjdZjuiceD2II1nOa?=
 =?us-ascii?Q?GlPK0zTp8pjj8s/aKizxw9PI6UANFKhUCKWVNnIACsGuv3TPjBij3FAlgRMd?=
 =?us-ascii?Q?ID6T/HzpnRtulz72GpyY2PeRUOKesgJCkYXLIRwkh1LX93R4g0PUkY1IwuOv?=
 =?us-ascii?Q?aZkWJIcZCs3+B/jnVg31WkPynvgtQnJ4jC+qZ+Ece5Pvur3MOMMte7/dPZhB?=
 =?us-ascii?Q?4VuENExT8fdmXrDK3Gsc/z+e3J6Q3sjwQitvBFvd/MGyoSFYJxo3PoGkci6U?=
 =?us-ascii?Q?go2pqunsEuWpPAWR69kqCcqCYRmDQHvY4t1FpS/zhXBJsyBHZA3vF8xdR1/8?=
 =?us-ascii?Q?PsYgoU3QncG5yCzQDUMEINhpM9LxyhUQHUwj3/CjR6VZTCiFRqujj2No0e91?=
 =?us-ascii?Q?l/SFkA0nM5bNuK03H9Fxc+xZLqtKPxrE2lYrqUux+f1nHai5E4AJ7REzDCXz?=
 =?us-ascii?Q?mkVXr1/jijSdhy+517LIGC9hTA9Bev03uTjEl6UZzOb4IhTVLrVn4BAXhdxP?=
 =?us-ascii?Q?f95hSaIuZoQ/h8TKEgAdOLqWCR9M7+LWk75BwvFqzlMBZyDzxvZv8x6HytJq?=
 =?us-ascii?Q?y2qcsb5iu0XvpFrEQigeAe96PCPwpIU6en3zfzxgqhami8/t6P2aqpK1XlvP?=
 =?us-ascii?Q?3xxOzB8PTy0TAZFRS0ozDENjHLeWYJtBNlU/YqTM9nM5U95mew+BsfbvuWcR?=
 =?us-ascii?Q?SxQiDG8pQMhYukUe9jUmHdJXbg60IyN3gEb1WFzsjRF/n5zB/LkVS99d+U2M?=
 =?us-ascii?Q?g/MbTIURXIMnIxYnif1zXMIHEbJnAnHqdOngJ/PrlO6Jz+xGdfz9ZNGs3NQ+?=
 =?us-ascii?Q?2Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d01817-ae3a-4610-e4e8-08da716543c5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 13:21:37.1837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0UcMm0vcsCw1zeQsEjeRE5wJVQ5SWOKTNlhejrpbzeBtMOauyLyo8q4wFOnI7aqrVcJWEwdG1OijPIXhNY+dlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7497
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modules such as net/dsa/dsa_core.ko might want to iterate through an
array of compatible strings for things such as validation (or rather,
skipping it for some potentially broken drivers).

of_device_is_compatible() is exported, by of_device_compatible_match()
isn't. Export the latter as well, so we don't have to open-code the
iteration.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/of/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index d4f98c8469ed..5abd8fecaba2 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -578,6 +578,7 @@ int of_device_compatible_match(struct device_node *device,
 
 	return score;
 }
+EXPORT_SYMBOL_GPL(of_device_compatible_match);
 
 /**
  * of_machine_is_compatible - Test root of device tree for a given compatible value
-- 
2.34.1

