Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376DE56CF00
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 14:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiGJMUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 08:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiGJMUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 08:20:42 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60115.outbound.protection.outlook.com [40.107.6.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCC1B7DE;
        Sun, 10 Jul 2022 05:20:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1YYm7r5QCPFIAbVNvlOyZKWrMuhVJySMn/jMGrnndkWRWvjYBXrpeiQjF+iV4ITeVKxv+KLAndzBEIRLlfxuTj8h/4y9qItYZJl5degbBjCcG53IojQuKvXEJiX3LAGBqigVHAsKDgoMLsKcZNooSFuQsQKbT3UdRkbNisAYY+Kw6ZdS8aseVnE33v1U5YumHnK38l7KMWqK1rFmNgfGy5VYsTFO1TMJsVLmZF5m85t5z+X/I9u3lDDh/P1Dj/CRYgo7Na+0VTHpfkXV89cSBt/yIa8gBT1grGZLO3M2aEwSAgRQb+uU/R32waE3SKDYW6bPWlEb5pZo5A/h8nZDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jojp9lvjTrOqKCBMefo5IOSIkAjrxVXikCJW972bUGA=;
 b=nVrDnrbWgTLbhZ09T0ctcm6Y+rJl167DDS8wvATNm68SsXsf03LhXIce0rg9uxaqu1GdVxJem8eTC0eK6aP32rAjzSFdoaIAwM7qdEBZLuTh7QRlTbYilu6GTMq6bObk0QmUYbqSgGu+coaW5KNCwf68HqyTHct9UDQqZzTpGc7/CtMYEYd7gRrob/tczasFZVS0qTgNjO3QXSm5HwSmqB59OxsHONRnkakPLHggPgZvYBlZC1qKvkcQ9FYLgTukOgo6ChfXUdhdwKWsIH6FxOU/KDNhpXrGhhFzIy9zuGnxm5fhtOTZRO45vy4B6Kr/yUyD3kZCPM7P0HUSpuOhog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jojp9lvjTrOqKCBMefo5IOSIkAjrxVXikCJW972bUGA=;
 b=YKhgcoRZKnc4W2JzKOKacv+W1BThCErRkzd4ddixaf6ePCdooU8T2e5e6W/pritIoU9tJuc8L2aZTrHvVLr8AIr5Z1xAJqLqruc8DhFbQM4RnTUIgcB/OkhzRE50ZPDO0sKWn0AvnROWNxoUxKpxP/ZRYSvoSwz915DI+BZJRVM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AM5P190MB0276.EURP190.PROD.OUTLOOK.COM (2603:10a6:206:21::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Sun, 10 Jul
 2022 12:20:37 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 12:20:36 +0000
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
        Paolo Abeni <pabeni@redhat.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: marvell: prestera: fix missed deinit sequence
Date:   Sun, 10 Jul 2022 15:20:21 +0300
Message-Id: <20220710122021.7642-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0068.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::15) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56b5e154-7395-4c4d-96fa-08da626e9827
X-MS-TrafficTypeDiagnostic: AM5P190MB0276:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EYOw68ZGrtiFHZGJHEx3RBnbGdfQgTpWbcsl4gA0NKXL1ggeP32Uf2JKfRJYofSsbKTwjTieZvdpRODyf+4n+hVxy1ISS94A66koL7GeJyV6Nm6txLPCJGMBo5nB3IfN1iRWiF5G/4sF/clfZq+REhNeps9e5LFHmAtkXECzYJOl9iCvfUGdc6VZLrGdJRwYWPF5CrC/IjLbA29fcK50GZWIb1l5T417D9c6u4fkgpc/kl3TPHdr15NW77NNzpovUtNtKP2dWm1enqEoyjp6mz/P1ceCbl1tXuxH2En0UoJSPGBi1h49W2M49pgxJuSG8Gm8+AC1lFL++ZYfL+FG5WnrmHhovk46PqUEKQ/iGKcD4sJEUFWcXPjMgL07/aaPiEXrN30hz/DqUcZUo4ZiPRyGAyfh870arY4T+Gf88o5EHm0uHPLo4UcuePhxQb4FGlPSpMnzwdk1K3BI2BEhBpiZjodfYeJ0hgnQYRO0XX8teouWqh9rYjQigKWWKprzFZEMA2TMyjx9G13Is6JkU76ix28aJk2yxNtgv2FIj0qBXAUsVCAQtSK5M93o6WoFrqgTlKxmNp2MP9CM277eCxwjFDJoPxP7WtSxOPiZbfljhfLZLGwme2Xt8agFVc+gyuMQAKEZwcqy/LclrXy9xpk1YRqx1aPWNW33fZn2aSlBjn/U8ES8ET2S4PbnviNM5QWOw/zhoI99omOK3BtLT2L+LiHdm5GKdV/y2Gy6lwE0yREtQzcU1GnQst18ntfH7lBZRLCy1BElyS8gYC/0jcoFU09Vz4AlCKxNiVuEPOsuwii3tzWlgzSJn0E9PZbX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39830400003)(366004)(376002)(396003)(136003)(66946007)(186003)(38350700002)(36756003)(41300700001)(66574015)(38100700002)(86362001)(1076003)(26005)(2616005)(8676002)(2906002)(52116002)(6916009)(54906003)(83380400001)(44832011)(4744005)(8936002)(4326008)(6506007)(66476007)(6486002)(478600001)(6512007)(316002)(5660300002)(66556008)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3M7epefWlI6VXkX7QR4jy61twP/U49pupiIxWhCVPDwJqMqZZMHU/h2usKTE?=
 =?us-ascii?Q?n6wdtB6W/svr1Wm3c5I35+643lLnWdhRt0nhW3jjo/pDvw3yk+q/ph2cL7Xk?=
 =?us-ascii?Q?zugDKT2hYYzIv3KgGCzXLhHWfJusF1DFefgAuI3rvPbUs5aJFIKW4H99ZQaU?=
 =?us-ascii?Q?fWxVdoYzlh0imRk5IJz0YDWlPTuulZDX7EZ7oAhA3nZra4Thww6n8Il6OFqD?=
 =?us-ascii?Q?lHeRX0licHYBlEqv/mxcxstsu20VXI1PYKexCCaM917lNhpGYEv9/WABSqA6?=
 =?us-ascii?Q?S7onRERgf9+XLsQscqA1qA4TNrTTELLPCHRwFCfjXDzXxPe3iHinFzgBB08t?=
 =?us-ascii?Q?Bb1ALAGnCXG2OaswoVtO5GEjB2bJZLWPi6aPnZpOaHMGK/fpMxfgnu0fX6kM?=
 =?us-ascii?Q?S8ra6QDJNhpfnxYdgTAmFqk/RYI8azz1+3U7Cj46KCD5rFLvzWiT3vbIQV13?=
 =?us-ascii?Q?2axc1nVqNeyF+pXFwv242wkhayeh0qIYw8ZUUlMozfYtmAYNO4yy4yF3/vD+?=
 =?us-ascii?Q?c2mWQNB+CKo8kAWPgpYv7vcnPXLk5yaTT7qetC6mi632g87cWL/uho5MK4TQ?=
 =?us-ascii?Q?LysqmNodIBWfZuEveZ2Stcp6pGPELyZybMhHixE25jTfjKIxDXiYzqUq/0lz?=
 =?us-ascii?Q?rHLhP1oubrVWYJunjZngNMoAGRyOOXPNebnNAogR/yQ2iJTrA2M/wU60UFeA?=
 =?us-ascii?Q?YeS4TMD/HphW4zMezT+edeUl/oDm+9pRe7ZxpYMuTdaqBY0cICmltUm6jnwt?=
 =?us-ascii?Q?tHPODIAu2RWkU+AyGnsEwPTA+gTdkmKTsKJBSMiRWKqYdwcNWxa0Bsb40AlA?=
 =?us-ascii?Q?/wk9hL9GoVbQY9C2+QuqJN0KhYuGzwqTK9hoKc4bo2MRBcSC0d1/m8xWr68x?=
 =?us-ascii?Q?RPswz7KnPozNBR72b9T9B1Rw7bQrAS7DhptadXqHN1DCHWsDXaN6JCPqnata?=
 =?us-ascii?Q?MWTIlQrgztPawcHUUdWSIE/Qz7ROAZ1+DN0VSNb+FNq5AulkEd3j+Hq8fr2r?=
 =?us-ascii?Q?SdPwRmn6Nmb8TgDgn1kQz3tQSvzc9Z1JKfrhXt5heNcGD2zjqRGu6TwhTRif?=
 =?us-ascii?Q?8kbJr4VHRNIPI1ZZhcdfX6N6a/qLOKRQ6b4afmv7J8FoSWntEmtQ0Toj86Uu?=
 =?us-ascii?Q?UMJj5LdeohaHjiZ5+QSuBijzzEjy+zRxuHGnxJhlQm5aVKNEKf4kZQhsAgat?=
 =?us-ascii?Q?i0Bw07gtRLSxWEWxH6NDxxZ3HsykvCqSS/rke760Xl2yz7IiEFQMZVA0qhoi?=
 =?us-ascii?Q?hffWNp4mA1onGcpCaKmxAzCoUH3ESw7dwIBhfoTa2VBd7M/3Ne0sh4V/971v?=
 =?us-ascii?Q?oqUZAG6h3fTBB/n0eAw3Z2CdWkugK1Q8STRsgxU+HRRDgPnPNnnfrNdpHVTe?=
 =?us-ascii?Q?Th/BVBfvG8bKA8oSVLPFU27lwsDHqleUGwEaTQTe7tJLwcdkHGlhkZhnjGPr?=
 =?us-ascii?Q?5ML9vVga/gFh+Nk7wu2fnrWUTpW65JfOuEmtJOwHpXa2lmTUSPyLEP4k9Q/U?=
 =?us-ascii?Q?wVWA7RLXK0rVlT6H280cagD9gNkCQzZLRpm43guFfvQ8wSaDwBB4/JQ8vfkx?=
 =?us-ascii?Q?s8QhAH4HVsDb3sVqDDDduQvEUUIOFCiLT1d1KP9r+8QK8EWW7swNvVGzwZ2V?=
 =?us-ascii?Q?hg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b5e154-7395-4c4d-96fa-08da626e9827
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 12:20:36.6720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SfhyUUjD/81/f6UJ4Of/ipHshT96nbrAwQ7MFgN9c7ywU/niRaDlXfjBwxK+wAHGnKBkChWq3x8c09cpO5xp7779TnMacPXc8ZPQ240qbf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5P190MB0276
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add unregister_fib_notifier as rollback of register_fib_notifier.

Fixes: 4394fbcb78cf ("net: marvell: prestera: handle fib notifications")
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_router.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 3754d8aec76d..3c8116f16b4d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -588,6 +588,7 @@ int prestera_router_init(struct prestera_switch *sw)
 
 void prestera_router_fini(struct prestera_switch *sw)
 {
+	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
 	rhashtable_destroy(&sw->router->kern_fib_cache_ht);
-- 
2.17.1

