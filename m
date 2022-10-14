Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001935FF096
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 16:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiJNOsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 10:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJNOsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 10:48:13 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2058.outbound.protection.outlook.com [40.107.22.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5818B19C219
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 07:48:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oc50TGtZ6rkublLOtf8InuWhVFB6KrBaEAX0EspqAAg6ocyoDf6ChT85TXn/3Z12fsj9U+sOs0qWrEilhw4HPTRiAzzBSn+50XUqCjQbm5KDCTQO51O8gyHrOD66O/hNOixkLp6TKcxE04wu+Bv8UGmbBTA2tEuAguIGFT/5pzYNJ91slFcZWbzHc6vWSfBYPlCbu2KwjG/2jQjWOxZA9asdm2kDSI2EhUzZGrDIskxl+4yjq12yfVxt5zX8pxasTMMGQN7/Vyh3OVNlborlycADBFJvStojhfCa8/6sgvahUFeacl/lasKxIu+5eG7rT9RxVeuHGTGz5zcXClfKXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3aDEkjxhOYnIcRo9HhsxpLkyLyJY5BGHp1HUrMug9qU=;
 b=dDUS+xknqYaC+bPEKB7vGKTde4Him6wCCb2V3jt28GumCs4UsfkJDD30YpZXBLGm+tXIkDxgHDb8nRN6O6t6HAAfXLUMbY8xAXV6elZbgeSpx8mHHZU+ZwVa/ayqNDqwIa+J5zqd+ZiTQ6LbsF10tVjBAF7N1GO6SrfumKaD0FvjbciMQWkFXfRduJQ4tOqK37M8IlRBBhIdUffSfbUBE230tGk1ox5Z3JiuFuDjtEB7Ydzslnvdu7N+EksMTPqgXjLLEmSFkFjvYsRh637+x/139PwmZ8bOwuaZPpMVtU7/bwMaA9X4fD+1s2vpBN2sMqBLHL5bb9lLt1wwD3Tgdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aDEkjxhOYnIcRo9HhsxpLkyLyJY5BGHp1HUrMug9qU=;
 b=UW+pYuVr9QDZMKvFpKtYVhG4zuTemNfJiHOIiyIIgCLC0GgI5MTy1Go4s3YjfEoTO7F9zIwPYK8gyNNIAzubIixlIyqhADcPJ03KJXONS+TqKk4uzEFyNVEvjE4jN1EnY3DX3xWNhmRFyynXRAAfJrlMzdCHKCZIiinDZYCk+SA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by GV1PR04MB9133.eurprd04.prod.outlook.com (2603:10a6:150:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 14 Oct
 2022 14:48:08 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4150:173b:56ec:dc6c]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4150:173b:56ec:dc6c%7]) with mapi id 15.20.5723.029; Fri, 14 Oct 2022
 14:48:08 +0000
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
Subject: [PATCH NET v6 2/2] net: stmmac: Enable mac_managed_pm phylink config
Date:   Fri, 14 Oct 2022 09:47:29 -0500
Message-Id: <20221014144729.1159257-3-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221014144729.1159257-1-shenwei.wang@nxp.com>
References: <20221014144729.1159257-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0217.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::12) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|GV1PR04MB9133:EE_
X-MS-Office365-Filtering-Correlation-Id: 44a04189-2a50-40ae-5d6b-08daadf31c16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vd+TZ5hk2mXrIVtUfYUT1A65/DzdKYk0Ud/gCEydtdesUmBk7mZWOjBBxvatTbDMo6Lobd8tYV1AitGWEYbWM3xbCMwwV6ljQqWaGCBIJMoVvLJMw/WuxurU8aKUnsVai/cpPyol8aGJShPHIo7tIvI5PixjW3GiFnUJ50lGeEXXFQVopoyG1dHvXknmlu0PHQkqPAEMSxlb8kYHKN+y8nujhOSfjnF1GVdLv/0fHL6/E+n1IMJl9AQ+e1eqQutbs/NXLNzNg8oT6QunLQ407rkKghG9H45kWCfDqbqsCnYgEXfX18WBldNOOLN1fw+JYvvdgd/pNa1o7/3tXiLlV4qo6kGRhqovEV+wr9e1bEdtqoOUp0+KuVGVUAIdx/wBJWjDbY3uoal7Zi2fzx9sM7FkDlbQt4jpeab0SXxFUV6u51sUKFjiB+vLuvMtl5pTcvK2QxLAhvw7Ecyx5yX2V9kjc/elIs7Nj5wr+uZV8uwpOUCgDvJhd6vxyC2dc8KNyL/Lex1aTJ0JctfDoTSL4tXk95S+sF8PTPywjv0629ktgGobzUM/dSmqDoPqULaQ1/4auAFi8QTHMvzA7EHzGWBBz2kbxLyRXl65iw7SfXBBs2HWYISf3KfpjUh8lrpx66KD7lt5DfSnmUF7IT4O5e7ERcdCfR9ubItMzlXOzEDwu0x6l8h4mn5JaVHhWqDEBXG5k2TaEWfeXMvRJcJ86GSreGLZiQ4WTotsvACVcGEPuYVx71kQCsiuUAJkvJ8df67x8HFbVEkRgHiWOOuaeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199015)(5660300002)(36756003)(8676002)(54906003)(41300700001)(6666004)(6486002)(86362001)(4326008)(44832011)(316002)(66556008)(66476007)(66946007)(8936002)(186003)(26005)(6512007)(38100700002)(7416002)(52116002)(38350700002)(2616005)(55236004)(110136005)(1076003)(6506007)(4744005)(2906002)(478600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HqgdlSg3nxgF9lwL4FDxXtgTrQDy6peHDf5RV0QdGd9WSgNWx2cFGJJijdKd?=
 =?us-ascii?Q?DS4rx3pK/Nc7CLaTSSnUPX6ScP56VRddaxJxbLCNiBi126nimfavp6KrwPYA?=
 =?us-ascii?Q?8kvFVls0lgcHg7dwOr+r7YQIA7ATPKxtuqKzssvGinMkBUooWpbgGiZvrNHv?=
 =?us-ascii?Q?XFkJlQi2CG56F1ajusIj6WSjP8eH/8WU7hmOQMGSOdpK6JsT5a+y3hM1Zzyp?=
 =?us-ascii?Q?1S0nxMVboYniIg5KxzSUkyYuZhTE08P9dN4mbo+XOTzUwW6tpQ14TGptAxfc?=
 =?us-ascii?Q?7eDdol+sVtzm8ec8LIGmhEUXDjsqGBXpfFcwPwsQL427A/fpqXMHEycmHzZ5?=
 =?us-ascii?Q?5/gQeHiHpXYCpiyDNntTYRORxBcTwCijXEc8rNX4JlFMVb9pj7FinV6xueWX?=
 =?us-ascii?Q?95jyNU34+zNuXQ2rY470YjyhlHmH3edG7lkTiwFpY71bB8Gf24Iq7/Dcq8fo?=
 =?us-ascii?Q?aYLcUDW1SWkUWnuHy8HjTwczpsJUKojpKfdUWayCLgM5ptXciqASHG218tp0?=
 =?us-ascii?Q?uH0bPS2fWrrkbQ7eA//7F2UmI7M2xjc0jTuFu/tpIRAZTFnVAAhkbZOJOqUF?=
 =?us-ascii?Q?PZNfPooOiZctGCF6EYm+VMMJIoXUDZtXZ2wTRyvZK2pFWZ7HpxZFFSHl010r?=
 =?us-ascii?Q?iaXC7qNG0fR4BYVwhAzS6TcQSdV7e6cfoG2hy3kofKSZLPKm/OpGSoCnXRmE?=
 =?us-ascii?Q?9lBmtWZlwCBFdySoc7YxkAmIsCfyXP3lj4Rum/UUDeHozi9TPELHor7Ezr6w?=
 =?us-ascii?Q?5J3EWWSannFD0zqJYUVYuWk6VQMHPoETdmn+ZAnRWQ/xzbQBvf1c5TMMLCV3?=
 =?us-ascii?Q?fp9jx8askB4Y1HInv/226VcNjFgp/z5igg//k1fYr+gGkvPD6wTQZog2+QkB?=
 =?us-ascii?Q?Wk4Ruo4G9ZT+zdE8Bc0K6pc9Y2orFZ3h8TRdp9Cf5y6EiqMnbv89LeFeIuAU?=
 =?us-ascii?Q?Ai7zCfYM4t11niRPqrsKSQuGadDqNLBmLBuZ0iF8NU43EVtHbplge50n8WTC?=
 =?us-ascii?Q?3x/GGqhkvZaWv/sCQW8VVoOLqKwAscl5K0DY/7a6kD/DgA9O9VnsrYnGVV3/?=
 =?us-ascii?Q?Ao8IxNSyZnK/2BS5JjNjxfOipSpW/cKJpQWteCP/J1DJYzxs5ZrsxaWYG9Jy?=
 =?us-ascii?Q?rHs5TlR8eBjHNUuFxeXcd9GUhsiUT5J9FngWaIVpBmGpKCNQUHEirbjyHOZR?=
 =?us-ascii?Q?S38LMf122u5GjBG9g/WdUwIfEqJvNy9EsQDoVHmm6PwezIRpKlhcexzv8YB3?=
 =?us-ascii?Q?kDo/QHobt7pympCXWLZZ9GocG2rbA65rlxTn+8BWrZKfGN4d6edDPFZxVoce?=
 =?us-ascii?Q?6zIeZimI/Ql6wwoF6QDbumb02VbNcZp+6CVmAD8glUrrqNJTvpl1Y7V0LZD9?=
 =?us-ascii?Q?O49HsLp5Ny2vLHN7/pIZHN5bJtmWbmnfZI4FePyxlc8xs/QFpA2tuy77pxoN?=
 =?us-ascii?Q?6lyzidc9MFM1rDzeXiK3qj5rASC1fD42b/N7XogDuCvktrM0TbK5vfUai+Gi?=
 =?us-ascii?Q?9vHDh0kxPC94XQcVKeU2mE0fNxb3TQb7wIvyGKxGlcLjTvEeoWHUpL+mjwy5?=
 =?us-ascii?Q?ZGqJGxX05nfBwuuMGONyDci+s0m5kOimvKbUKYTF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44a04189-2a50-40ae-5d6b-08daadf31c16
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 14:48:08.8419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4q66nAAhV9z9lKUs7AqkpzALHSi/8y+P4LER1fp2Vl0jCfMV3Q1eInLoeiPLlUQduYRqSgfixI1+ItmtvDz8hw==
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

Enable the mac_managed_pm configuration in the phylink_config
structure to avoid the kernel warning during system resume.

Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 65c96773c6d2..8273e6a175c8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1214,6 +1214,7 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 	if (priv->plat->tx_queues_to_use > 1)
 		priv->phylink_config.mac_capabilities &=
 			~(MAC_10HD | MAC_100HD | MAC_1000HD);
+	priv->phylink_config.mac_managed_pm = true;
 
 	phylink = phylink_create(&priv->phylink_config, fwnode,
 				 mode, &stmmac_phylink_mac_ops);
-- 
2.34.1

