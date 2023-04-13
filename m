Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294C16E0B07
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjDMKI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjDMKIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:08:20 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2063.outbound.protection.outlook.com [40.107.6.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B118A74;
        Thu, 13 Apr 2023 03:08:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hbs/RN62kAla4+lNt9nv+oF7+lsUkQL0iRhQly4xvwy5N/YqmUOuB83IOG6skjasZR+NnM21Vn5Wq7yKpSPPozAHG8FwKBKZFwrq8OJzfzl8unfmQGfM926W05LJW5tr2TyEf/9CEgfEqs7LogdahwAdFZDDmRyRVx8p65WDlQO4PggZr7qSzsKWDSEgCiswnjAx2dgT3NbRD/eU2xicx/WCB8ckvev2wUuZ7p67a/frUQqiT49U+zZVYWHlW6GUM03yQac8I5sIUIe8NJ7qenK2oHTlXSuNgn8H3Lmg/1j3PZMA/wlAnldG1L7/7QfCQDmQfU/oRRSN4BrsNkt2XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FCoJxPgFm5FazRUss6exA3Dcdvph5hJH0O+kDejoJdc=;
 b=J5HkcK2jfChrKlLfPgNuejxm1tTDCC1X6C9M/BCefpSH+XyUOZOT0m+8xFm3udNWYmQTAtYkF9OeYhGizY7q73YPJ7imBnGFV3PYI0/dheq2JBamamKIrsj4ZARaZ1XVTrequDFhbIxxRyryyYHBEgsfnG2AkY4V+K64kbQznvLjI0uByAbO4vplfeUb/YVXQpTK0po7Z1PioKbTsuk5WSq2EwgjETU3X4mB/Et3jQ35r1m2l1g3npbEHgdH+TXa4LJRVOUU9E/iWUw7yGZZJyP9jrhiRJU+w/hEmdt/N+NCCGIkh6HEL9C0DxsRUNEHAjnJ5cchjAuFsdUZmr8Krw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCoJxPgFm5FazRUss6exA3Dcdvph5hJH0O+kDejoJdc=;
 b=JyHIrfWVqPM3u7j7hlmZ1p50XDUoK+KQzxM40PNqONmqsLacGX7AfNMT7aikG3JbdiDuBd9KWMo87/SsH6Y/HtrtoM7vQ62apZjLFX9eUpWr1ueMemABEZTS7aCYpPTNpsU2MHwUHbmwors164vE7I65nLWEPU7IW2Z8sX1zjpQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB9121.eurprd04.prod.outlook.com (2603:10a6:102:22b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 10:08:14 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Thu, 13 Apr 2023
 10:08:14 +0000
Date:   Thu, 13 Apr 2023 13:08:10 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] Ocelot/Felix driver cleanup
Message-ID: <20230413100810.kgq3owyikjb637fh@skbuf>
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
 <ZDdQrmtqa8eYiRbX@MSI.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDdQrmtqa8eYiRbX@MSI.localdomain>
X-ClientProxiedBy: FR2P281CA0127.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::15) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB9121:EE_
X-MS-Office365-Filtering-Correlation-Id: 173dc4f1-3a53-46de-0833-08db3c06fea1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QmF+gaagbmdvefia4qwletLX9LdvyWQk8yNzNjyJezG9+9gdj2rZoARbnOs97uK0wNQbbpTMt60ChqmaZRMl2WgEzGsY5ugcjTLcg+UrZZm2PHWKOw6uZm7s+YLVmB14qBensIIOcsx7VkK5kduX8M3YeRJYwObI4nkem4rL2AiczlsqqnObktXCxUU1CHWApbd4ep2mCZUPUdPLnSBqMc45Xyn0H31BL+X9qrAtZnko1RQTDtyRpCbxmAPLov1R+VTY4ZQkg9KIsWpLQjHQdEudHjEYLpyN0hRPUiQ8JfOJPxqCk5menBCAH6luBrnUxYE8R7eAAZVhaIuiXuhsBhEwf2AIwwggZtHxRTLPVgEwhvm5N15Yca2hVjqtltD4eCEwXrDQGiygqhOx0DNxl2Ab1hfBzphcew8fAn+2HEI/Bxfgqzjgfdjw59OyhOLocu1Nmhjo1QAwJb55D4FXVfzuZnjC2QR2s2yMiHxsy6S9I6UCLQPabp90gaDYKTxdJcnnoiu3ihr600S3iIVij0buIREoqdZiQ+djnDS3c/GLUWTmLjUU9VzmAOI/sUD2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(136003)(39860400002)(346002)(376002)(396003)(451199021)(9686003)(6506007)(6512007)(2906002)(26005)(1076003)(186003)(33716001)(8936002)(38100700002)(83380400001)(4744005)(66946007)(66556008)(86362001)(66476007)(6666004)(6486002)(478600001)(44832011)(5660300002)(7416002)(316002)(4326008)(6916009)(8676002)(54906003)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MRiwFwK8K0IT/rp88rDhQw+2vTZmrEMz+RV8I7V9hQuMpUrKIwGDcIL/MxGn?=
 =?us-ascii?Q?GHvoHzCL8XZxxU4flDLWbC0yiIAr+6qTmto/lDMXHIJmC33gG5trQPZ0NzKs?=
 =?us-ascii?Q?xU9TpBlql6EoLWTbIJJ6hcujfrPhRUx56YEA5ChancYcpSe1PGgJpbTuLXZY?=
 =?us-ascii?Q?jFuEM5rvaSjwmcIyQrd8O8zz9PXDE2pOVd0ExhrI1a45hHrxBsBxrRbUNl/v?=
 =?us-ascii?Q?BeL8s7L2QtkbzcNyWWRm04ZAiBGENPFBxmv458IlEFe+B2G9KKqpNlJ5yKkl?=
 =?us-ascii?Q?NQwMHPAhCBHm25eSoQ+JWKhtjhqKsVf0X/VuB7/w1SeZr37if1O69VySghOe?=
 =?us-ascii?Q?pnzC3/wFraYU7qEbzrStJ4yibcTVLvBquLn6eB4JRHaHr4DHdPtl4Ybq1Kz2?=
 =?us-ascii?Q?W9wOjz5euC69VyA3D2CR9lNTlMr1Qk20AIOdNuJcXk0OalIAb+AiOwOKzC/1?=
 =?us-ascii?Q?0actPmEuQjyNikGq8mgMzLDRHK98EdiWQRXml/sOaDkVfxu6W0xuvAeNIo5Q?=
 =?us-ascii?Q?kRtVnqw4jzWbSa0V8vfBM7k9vR563IXlgPB/et8aHy8WuJl3gqC1l+0tlE7d?=
 =?us-ascii?Q?L6znnrNkj4MnkYXTFNJZiBabuxBTg+GhP3YUdc/bhbSCIHX0V+gxH/FyYbgT?=
 =?us-ascii?Q?GmfdxL5kYVplVZXYpF6YkLvw+Yo5duV4Wl8D5ICxX+njhDgl6jj6h61UfjrA?=
 =?us-ascii?Q?dvydFJazyYmMpbyB6oxQldTP9zM8kubpdY0RT3VvlkeLhPgpa2g2csoEJe/v?=
 =?us-ascii?Q?H3wmcYjtxL+FS5g1Vgm0iLoGJZdq2B+VvWkXoaDi3skQh9lUfejE6YOTs+E9?=
 =?us-ascii?Q?led7by/JdCRstZoWwRfpHFFwh0o6bViVgXsCStDxtdoLGVIz4W1e+G4a70kg?=
 =?us-ascii?Q?+RZpsDAJk72MkbTcbElg52z6BhG3s5qIBVwp/l08DMzbDNUzV57zDF30O2Tn?=
 =?us-ascii?Q?A8HJxZaA2AyVsPFiRr7D/bdpWBbI4bArN4BXxddQaCujkWi44YhAd46/vqXM?=
 =?us-ascii?Q?2L8T/XeiNgNvZEf2JIUGIZRJxX6Dqv7ZeP1NK9ruFR42gTqKynFSF7Pd4GAc?=
 =?us-ascii?Q?WhBjCUwsegnHf5jjNpqJGqU/TLiDGJCSJftN4UH/Wivtp2vCfkOzph6HOIeK?=
 =?us-ascii?Q?TfyzeK3r12aZ21CXTdIIPz7lomByawzk34++GSj3K0NhqwF2UIXnrJ9J/Nuv?=
 =?us-ascii?Q?Cfl/iwfpScftbHIMl/5eoExk7YHsOh4c6X72cSXiOHWk35IUjGENc3y/zw9t?=
 =?us-ascii?Q?uLGj2Ly0F4DkwywHrM9tlCcOf5M3LUou0KNqHe9XywK623nE5Ez07b6O8jDx?=
 =?us-ascii?Q?yAxJ95MJjtaqDTETGHMKYl4ThYoH6MBwmQgXZD2hhoQ6yvTDjDEx/dE4W/qz?=
 =?us-ascii?Q?EdNlk0sGsaHwrpx5ZTxetpZ1FM3U3EepDguJ4fb5Ne9IY+9BgNomme/aSUKb?=
 =?us-ascii?Q?geOFXcVW/ufJY4r4tl5aseAdTK4OJbSsfBO74z3Z4mVC4uOX/lJnAATSBnWL?=
 =?us-ascii?Q?3OstKCrxaD8xyEhH3FE3N8+/4kFTThK30bKmuBBMwxOJ4Y5Lgh2UID+sc5g0?=
 =?us-ascii?Q?lucqkwUf1jX0UNuSpCwtjG0xtWkU5n5xa1Yziv6NIlm0UyzdsYWU/p7nxEcV?=
 =?us-ascii?Q?Ig=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 173dc4f1-3a53-46de-0833-08db3c06fea1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 10:08:14.4694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xYsOXJkiHxSifdo51RH/LWHMt4LLgW9I3PUbGDMUJzeXmsl0hWArGmetJbULjUIEBbzduoQtsu4r2RBvdBNGFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9121
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Wed, Apr 12, 2023 at 05:45:34PM -0700, Colin Foster wrote:
> Sorry I won't have access to hardware until next week, so I can't add
> any tested-bys. But this whole set is straightforward, it probably
> isn't too necessary. Let me know if there's anything you want from me on
> this set.

I've tested the patches on Felix; hopefully there is no reason why they
would introduce regressions.

I copied you just to make sure you're aware of the changes, because it's
all code you've visited, contributed to, and which has confused you (and
me too).
