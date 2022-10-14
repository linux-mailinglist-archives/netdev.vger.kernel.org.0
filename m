Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155CD5FF091
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 16:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJNOru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 10:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiJNOrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 10:47:48 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2084.outbound.protection.outlook.com [40.107.21.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E0610A7ED
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 07:47:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/JcCQSAeJBF92cdpjtFK4nGS5v/szG0MY807HMuwxsL+ASnxKIroHktkAy1iYkrsZc0iYnPMAeA8/Qvo66FrZK3ixUNt/E153S/eJCG63Mc/ICA6Sv0NrXAiRGtHWi7ZVf9CfuO07evTcNydADhrWui1MgGPcVvTFczdIXhyfp6zeXjNqq1s6+KC+NlQkDJ83u+TedBJHVGI4ZXejEPV0qA4QAqmA5k1X36HLqYJRSfDGYcq+ZulBOeokGxbVAx8Bqbzw2Y/8PoEwW2wz3EtDPlI+P+Pelt8+WVut+wKiYF8PhhMyYjay7YXUoV7xMf8ZBaS0tzG/GG4xPQuTezLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6F7Si9ccQWD5GOC3H8nn5imuehqAiiprmCizm4S8B8=;
 b=RZo5g2Xv64kVNFgzbVdw65T6IG6Bn9u4ZwMhiFcjt/TbUJRqnJkeQ1mHWLBYsM/E1X2J+cfg/Ouyd/wN4CtqIWMH2xw5HeC164SQOikEOVzlVrrzw7a58LEfuxG3WCzeohDOmHQqLwJ0cIxgBI34KyUfvJKQgatjNORkePqie6Hj5Y0xBZAHE+QRKgMMbmIiqrbYVCU/ItZnPo0JZm/pCdlKU2rUAX2WKPCR/kFJ8cdacadiE93lKCDIAAKpFviz7A9WRAapCt4syGh0PpKiEhhHV6DKSZYCgKZpMK9LGCKQ0GaTgWE1WUlZlVhQEeK7EUKZd7+HtKyRFt5mLzl2uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6F7Si9ccQWD5GOC3H8nn5imuehqAiiprmCizm4S8B8=;
 b=kip7DzADZm8Js5uEnoRw6owi9ZP+qou546SiNA+wLcRgXnK5+KIrdFFK6SKwEZST5v5SFy9vQtReupDtvKBEZa27gLs0cXBBOPvjA6e9b2pmJrIQIUClgapEOoKVDbKhqndh24QKfOZ9BdlDleqXmIqKVKtFGwolYLlo90iG85M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by GV1PR04MB9133.eurprd04.prod.outlook.com (2603:10a6:150:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 14 Oct
 2022 14:47:44 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4150:173b:56ec:dc6c]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4150:173b:56ec:dc6c%7]) with mapi id 15.20.5723.029; Fri, 14 Oct 2022
 14:47:44 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH NET v6 0/2] net: phylink: add phylink_set_mac_pm() helper
Date:   Fri, 14 Oct 2022 09:47:27 -0500
Message-Id: <20221014144729.1159257-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:a03:74::34) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|GV1PR04MB9133:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a9cd047-0a0c-4812-0f79-08daadf30db8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y9QB1Mbk9kbXFBieP6VFCuQQo4C+N4bYUfOLH/+yKwytJXSdljD6uoQN3AituSbjGqvQgE7mTC20kr30IVTwLEpS67ET5rEY5a/e6G8diWxOseYXpNyhqpG0gsXLu8nU8m4QCd0FoD4c7Ic3oQfz3j+ZPCySW6TandrVVPPsFf8j55/TU+1Cjl6+riOO4+q/tMAQwPNNN95w+1cU7w1iZBhWBd4UEL2HhJJmmBXuOXh1KvCrMnW12OPMUD2tjzXsD5xj1wbk69SLOhlLjnMzEuKaW771sg4+iqpefdm7B/AQFe38Va1DAC/0mGXyIzcGlGkUJCRQqWqmkz++XIOsefzy+09WMyMyfUCOCQTnn+x0mnweyXi6j1cJqHCZy1NyzYh7C47mNiDJ4UiGdeOlCEwBgc3uqJzhEipQSOfwbAMj+WYnEiTWSJC9eAWEp+tgzXRIVYEa4lkrnOPi1WhnNn1mYLUmLIJcbaiZO47zMGK4n5erChClbvzyTHGY0k6jzx9VqfxVa5zyxQBQ4TiUxSIi6DgR/68YuxZixFgJDsyAd4ubmoWlMfZhdK/bqtab0tstuHWxIGGSk3ByLAtRH1YdTYePv0GEthsoxFuZZ3OxUaOnOcg20yBm11ndHZPYOoCOAumkatsaoloPvtpE18g/mjJZjguvX54ahFrl1Jy0wVWIoSWFoXXMR+w89ZlGu/KfAM5TmL352p957PvTvraLdsXMtKmE4CjYmDSPi7EhJbbOn9/73WdcdKJSr1Cc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199015)(5660300002)(36756003)(8676002)(54906003)(41300700001)(6666004)(6486002)(86362001)(4326008)(44832011)(316002)(66556008)(66476007)(66946007)(8936002)(186003)(26005)(6512007)(38100700002)(7416002)(52116002)(38350700002)(2616005)(55236004)(110136005)(1076003)(6506007)(4744005)(2906002)(478600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J25UiiObQeM2Bula7/5hqvADzcz+eE3GWQhX+U4PjkTVwVHhzLNIUUyWMwwv?=
 =?us-ascii?Q?EeLzYHaCgtV5HFe9rJtdzd6ldm/jHFNiRyOoWr7gIVXyVTi5BH2IRxSMF93x?=
 =?us-ascii?Q?zeIkjGEPVdvbmLIMcGavRD/2sqQvN+Dxuh10wqWOXhybbkDdsvxXdnUTew1f?=
 =?us-ascii?Q?NIClWXeyQyyZg294a7xlQ6O3U8GyMG3mc90/DDae34aclhaTOgdCsjYP1/JY?=
 =?us-ascii?Q?NKIAZc7cMkKsFPYcXoErTRzRMHdIZY563pVOuTq6uhQ2UKHuaMEhRv7qLLPs?=
 =?us-ascii?Q?lsp0n/SCBkumQNq2Tur7Zi+AKKqYI4rO5Dn4aAuoHQA5AG77COcssqKMyDHW?=
 =?us-ascii?Q?OpTcFtxCgKfF+SIDdOnwQewjMayaFY/jgDm4nMQZ95TXzzfPaJQXzVWPz0ha?=
 =?us-ascii?Q?Xoc5DXatyH8GPLUUFQaK5QOasoMVWfxAgQ1O6jPW0+GxGQYNixRItlEi9xZ/?=
 =?us-ascii?Q?yf9dU5CFOmo/t3VERP9y0jbPGYby2srD7nqRrIUxI3r4K8E7euXO7ERmLaz6?=
 =?us-ascii?Q?zHcNrTPXW46F3ALxLn5u+YsXfJZFakHddiKltGFf5nMeAESUXpzg86XU9ase?=
 =?us-ascii?Q?LTRxhUorjS8NlwG0YuKv/G9whIJytdQstM4Y5PisD8c1bfk79N4oXGiDAnRK?=
 =?us-ascii?Q?4y4daKZUyyaJiJjaVXHAaaoGJqqXM/nookoWqUX2SHTeUmG8momHSBFMifEB?=
 =?us-ascii?Q?LAXL41TqY39MMVDQiuHrWYNQ8LIXXaRicERFxZyDOFADTI5x2ZnaIr8uVczB?=
 =?us-ascii?Q?LEqnLmY/LZidOgPzohBhkRCJ3N/rMVoMRmbolwnxuW6FSY9FtXq3WSDdI1wX?=
 =?us-ascii?Q?uQi4wM0XK6rI1Lft1BUCySdoY2tMTNibNyOszeeUlHKJEMmDoYp9lx2Zr40J?=
 =?us-ascii?Q?JaYT9nGwMm6EiVMSc8fcVq/ZdyjkivL4mprE3PT12Hkav9AmAPipmau3CZxL?=
 =?us-ascii?Q?c6MQRrSQWzNOZmJpIhMBliTNBLxWmBoQjDstprs9IeJVQDJ/bvadaWxR1DuM?=
 =?us-ascii?Q?Cr0Uwaxp+/QB6wR7XHbuXAmaDksdLe8uoG8HVRz6FBgRyAt9v08TEB9mtanD?=
 =?us-ascii?Q?j1nVc76clU6MGLV9X/qDjdmARWxHAnlPAk3mrHCRtJ2rbc+Iv6ARTPjyhu3o?=
 =?us-ascii?Q?tEQtaXNkoJo8dKwT3w704/OEomWERCs7vw9GevtN4bH9k6mIQu03ff5zzj7l?=
 =?us-ascii?Q?2CVGicnV08TMQf2+6WBoXtcgj4a3bVzdN+IttDsM0Ps96MYKId/trk/rzQ1b?=
 =?us-ascii?Q?BM/jvgcHzf6V1gOvQl+dBkaQbbHrfL2xY16cSn86W2A81FZk5vLZfFWGEtYS?=
 =?us-ascii?Q?a4wwdbo/tcsgUfajbZNwkhHbZobke6JuYTTPYiItaYwxI4x3esXKVt3in5BI?=
 =?us-ascii?Q?FgZdH+0PXK/pimho+/+vtPQGgM4HUGMwAf3F0w4KCFo7l+yjx3hVINsbM96B?=
 =?us-ascii?Q?kVOG4lD6SvbDZGBEuFTGlZQ51GaeTsVu4J99OD10e5+nhEgt1Jc5o3HHcXZ0?=
 =?us-ascii?Q?lHFy7jgzWXBWUQQLWEAnYaN0B1YGFY37t9cDmgSbDG49v1KIdi1fy8JJ+80Q?=
 =?us-ascii?Q?OZpTN/o15T2K5c8PsLVFqTIFUMwm8/JtHeLiV+/p?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9cd047-0a0c-4812-0f79-08daadf30db8
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 14:47:44.7826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5XUXXwgrTxQtQCluQ0m4yc7mTHW+yhOLzlAPHy5KdAsc30hoyd7pVviIVnYEXaQ8tHIWpHInO0tuJGw9StRMEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9133
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per Russell's suggestion, the implementation is changed from the helper
function to add an extra property in phylink_config structure because this
change can easily cover SFP usecase too.

Changes in v6:
 - update the fix tag hash and format

Changes in v5:
 - Add fix tag in the commit message

Changes in v4:
 - Clean up the codes in phylink.c
 - Continue the version number

Shenwei Wang (2):
  net: phylink: add mac_managed_pm in phylink_config structure
  net: stmmac: Enable mac_managed_pm phylink config

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 drivers/net/phy/phylink.c                         | 3 +++
 include/linux/phylink.h                           | 2 ++
 3 files changed, 6 insertions(+)

--
2.34.1

