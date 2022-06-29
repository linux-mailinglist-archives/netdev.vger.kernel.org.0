Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7AC560925
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 20:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbiF2SaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 14:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiF2SaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 14:30:22 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2081.outbound.protection.outlook.com [40.107.20.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9729F2A94D
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 11:30:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czo5/oNU08aKfiY9r1E5KZNYnbI319fgqJe7dfF6D/4HPOP2MfduuaZQ+K76PH3HhuSdayVLOh5yCL76KYokXAXcpoGAzqPEkI9Jq1LatYoAbvw82t8IVw5pvNDzR/0p9WzJKBPH+dW1TUGm0I8KlLKqxzXnA9XSyf9RolCL/soHimv1mxcIkMzHr48Kp4PSwUWottCUNqOkjFg1+K3ulBHGYjIuGc5bE5cjPBvUR8mNdHBdc0Gfg/nh9uoQyhATX4yPSjKTy4iV5fB4CmOCqAPyXPPVYbe5C3i9hqebocO5W4GSNjcRsBrwsE9/2sEGWjXv9WGrieErYpmHohkrLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fA6qI0rurAA0bbZs2v8jcgA65rPa7tHMDOQVEYSUROg=;
 b=mA0bRvcZKsMFGX5W9eJsxEAsaVupuK2Wwy1twUAxkyi3b2ZnnZaPd/6pmFmSxP6FVO2ufba2nyoNPvFZopx+AE9CcMAumNFCHJipiHu/Bp6n2yQY0SqvWsJdEMOVPlSgadnlJ3Oa2l8ZEoFpXyjA4GUi14NBxq3x4T050b6sl7SAbTxLevUbwk3CQZeC2oEo4VcgfVLNvOSexO6+3C6+OG5EdIqvqvR2K7qwPmx+vjtBnh5iPswqLudapLKUuPnpaP8Z4Rck1ESGqm+u6M4Ss4PvlkXZRbakmd17LIfnuxkJA6cZ7394JomNFjpobI9uj6Xd/2TJRKwQoxB4e2pCQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fA6qI0rurAA0bbZs2v8jcgA65rPa7tHMDOQVEYSUROg=;
 b=kRx+OW0zg8pN3qgRBagWAtECvpFfVwMZM+NsRLP1XanxpxIjGY6KvwyFnpZg55LpB5dSe1aZB5NItlD4yTGdPhSb15Fgnh9SelOlmRKYxz8gH7VLlKb8tkgIuTylVr1JYxzBxCGbWkrECnFavz68gDP9aMcTCLLoVTBGmO/UFlA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB3530.eurprd04.prod.outlook.com (2603:10a6:7:7e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 18:30:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 18:30:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net] net: dsa: felix: fix race between reading PSFP stats and port stats
Date:   Wed, 29 Jun 2022 21:30:07 +0300
Message-Id: <20220629183007.3808130-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P189CA0043.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 823e2062-6f04-4ffd-5a07-08da59fd6ae8
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3530:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lyaayZuUGdnQ72bGhwhJYRQ2f3Au97FZjeL7q5th/VERvK7p1YWMneLpf6+1Fa5qpCzUVRzpNyiZp1Lmdj5Bg6hw36VTrqSuFQKfPB1snMF5vS1GbiNbMALeTuh0F/B8St/zy5w/FM9LAaP+uFd2GVd45+JkF1F92x9e+9qQKv5w+Ku6QX51yTSNtaPyZOltOcdtb/b1iN4X9zZ2xiZrwrs8Wn0xJsMrEAQAiTOvEo6H2m09kmcgquHQc1P1ujPxEvv9NIEGTxWcnZXvbtl/luUTVmo77DIzb0r1SS0OVdtbaAdGO9bICYCwZ6gY9o/EvnK94Z89U9RH/PlSRQCjBgajSyVFMNIByPZ9lV8beSANyjteZ14kbtu3QxxyM7xtYAeXWPIAIRZqeC2QNKTFGCHAAWKWz6eNZHQWGw6WC3GMrOFSxJakzVnQuHotGH5FYckOIYNaXQrNryHpf3Xg7YeCFvL3glkUIWNHQjwTg3L5qpCzfhL30HGSWxoDHhPL0kl2vk5DuiwtEFU/lf+aUs4GqCAwXNXcBySWvtj9/WmSTAS4xeEIr9eats0tv/Xqs+sgejXCa3nYiDmmikCOhEKH0Lgt4ENmgxPp5+/keyEkECMlwIpjxpwjDIkU5Zn+J7y7Pqu2Tc99+qTKkGN3srjmVwnz8pYpE0MT6kOj7cIGTbqtKK9vWqXGqcIVursnTIl8Tx9zLTNtPN4wTRbXHC5urr4uaQMAjvdcdR2Jj5iym09s+fLWusFsYFeFUBpivoqWQVpLmt3j1t1CrDEyrzkSg+yHmbtrYU7NidDyac4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(5660300002)(7416002)(66476007)(66946007)(2906002)(6512007)(44832011)(26005)(8676002)(8936002)(4326008)(86362001)(66556008)(83380400001)(38350700002)(36756003)(38100700002)(478600001)(1076003)(6506007)(6486002)(41300700001)(6916009)(6666004)(186003)(54906003)(52116002)(316002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lot+MxrinEOxtqC9unpKaY+KIrXsRIZHaPSdN/Ck2KZGjOFci5f8Ce07rO6b?=
 =?us-ascii?Q?iMSU4VlDiBP2hQoBnXItXBrnreBAoAGblxbCfOBJgOuezWFQnwKNsl/6WGYf?=
 =?us-ascii?Q?J6Y0NsI86hswZ6HEa0uMABsQv2VGBqR5yf7n3aJ66Ptai14SEu3leG4BD4vd?=
 =?us-ascii?Q?dW8b1GPusHtkRxVAxQ5oBJq0RxCYRdYb8MDAuQQvAip0k/am/HfGqqYLybL7?=
 =?us-ascii?Q?onzrtv19nsCwhBafNuH+vPizwWwbow1w+zXx+FcVQvzIwkPHMMBl6YfgJbrL?=
 =?us-ascii?Q?gqNl32cPRX692msJxmJj4vVie5dIyyAei0di6s32wuhtRdCFO6QJgMMW2o5C?=
 =?us-ascii?Q?LpRdrzR+BhDKV7lHQYxhdzMdCY6f4KvmiWT5SPBmBpoz4kvfbXaAICVH6MPC?=
 =?us-ascii?Q?YcfJQhGeMLAb4gGpxcjG6luNntaZJ/4+XuWJILkw5HMLLaLVozU2le11xB8r?=
 =?us-ascii?Q?zvx20ncLOYlAF3tH7IC0272laJtADaGnbR6pMclBu7WUPvM59dDvTPCJ9PqX?=
 =?us-ascii?Q?bD5rxN4d0cxJhIpu7RWmLh5dbC9mCVnF6hCw+pCxyqTfofEaVZ6uM+lc4bo9?=
 =?us-ascii?Q?g8qrkpLY7N44Mj4fuYidMMM9IqHNthC5KoLINZ7V8Roi+RkTFW7D7bxMKk5y?=
 =?us-ascii?Q?PxyFp7Mx8gIv0t+xWhAZywFJ+HQ60eYlenw9+oCRIDvsqxhCTbxWOUoyooLm?=
 =?us-ascii?Q?c2E7hPZG3ndUkJKJjFDuc8GHKmXBHQxPopJ+DkWuxz7LfXEd68UlF39Hs8Eg?=
 =?us-ascii?Q?gvLB0IQPDY5w4XazzTr3wMDfUfmttzRzSGRBfsVuuUmqqdob6Fzn+YlVl2n+?=
 =?us-ascii?Q?gjbtyiDYzRRYlxT9iKNOjcXirOPC6XPo0iEsgIHrpq+lzffswgrPmAmxeI1i?=
 =?us-ascii?Q?1vxc22gHiqomFKJ0VuGW0zTcpKSosfNOo0AQaUVN1SWfdcPb+9UBcM8E97ok?=
 =?us-ascii?Q?dYXomGUrJXJh7qbxR0cYnhFSnf2iSCUpIq8+dvG71Z1tix5O0YIaHZbVfm8w?=
 =?us-ascii?Q?mrZpZiwXYzX3TLvgvKRqZMFzo57rhgoZluOGdkircOyQRvIrqyW1XiFsOFr4?=
 =?us-ascii?Q?iMYQYiVjcZq/dueHWbOb3ukFkTBNFlTOvy0i9buMlFI3Tufpq5JcTILKRoW+?=
 =?us-ascii?Q?XdK4oyYzihrKFsN6/WkqCrN6xXKyIWX6xjTwikXKalTNPOwuX6cuLQCxXdSM?=
 =?us-ascii?Q?zhdHv4VSFESzLiJ4CkghfJoFCCtmY4xooRze+B6JBmxUpdghu+OcOyIqRDPF?=
 =?us-ascii?Q?0GZ0r3DnlexobIqC1Xt+ElCjWtSJPWb95cqiPhPWLEnyavG1sT7aH1KGppAc?=
 =?us-ascii?Q?fgpkfs+eeR76IPocsG6xmRyid4+GQaqRQUeJgoiNzOAxyx9nnEz6Iytovfeo?=
 =?us-ascii?Q?sjNTewWPRS8RTWWhm2JFBokub239xk+XQpLzqa4nMDG85vhQwqX20VPdIpiS?=
 =?us-ascii?Q?4+4Wwx5uIoM+gB8PoRRuBFnlb6SGhdiNh1cewpQymjub2F9ZonxZPMZr1ZLP?=
 =?us-ascii?Q?dikHFIxrS4/1pY1/q4wP5gY9tOLTcjuJ+5LZ/BjbJ9kH1bdTfEZXq6g3sL5y?=
 =?us-ascii?Q?koD6mbHzBVSLk81lPG2srGyi70oJt4aXyhrWtpzu+GjNRpMW+D74mbANs43V?=
 =?us-ascii?Q?sQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 823e2062-6f04-4ffd-5a07-08da59fd6ae8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 18:30:18.3431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mn47hgAo3yT/9r3QL+f1JhUMLAjnaP1dR5tgO7QQ8Y2VR0xfw4b5HU6R4SqeqPQqKLozIbfXl1p81LWTQ7vkLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3530
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both PSFP stats and the port stats read by ocelot_check_stats_work() are
indirectly read through the same mechanism - write to STAT_CFG:STAT_VIEW,
read from SYS:STAT:CNT[n].

It's just that for port stats, we write STAT_VIEW with the index of the
port, and for PSFP stats, we write STAT_VIEW with the filter index.

So if we allow them to run concurrently, ocelot_check_stats_work() may
change the view from vsc9959_psfp_counters_get(), and vice versa.

Fixes: 7d4b564d6add ("net: dsa: felix: support psfp filter on vsc9959")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index dd9085ae0922..693cd6ffbace 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1956,6 +1956,8 @@ static void vsc9959_psfp_sgi_table_del(struct ocelot *ocelot,
 static void vsc9959_psfp_counters_get(struct ocelot *ocelot, u32 index,
 				      struct felix_stream_filter_counters *counters)
 {
+	mutex_lock(&ocelot->stats_lock);
+
 	ocelot_rmw(ocelot, SYS_STAT_CFG_STAT_VIEW(index),
 		   SYS_STAT_CFG_STAT_VIEW_M,
 		   SYS_STAT_CFG);
@@ -1970,6 +1972,8 @@ static void vsc9959_psfp_counters_get(struct ocelot *ocelot, u32 index,
 		     SYS_STAT_CFG_STAT_VIEW(index) |
 		     SYS_STAT_CFG_STAT_CLEAR_SHOT(0x10),
 		     SYS_STAT_CFG);
+
+	mutex_unlock(&ocelot->stats_lock);
 }
 
 static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
-- 
2.25.1

