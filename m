Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DE569880F
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 23:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjBOWqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 17:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjBOWqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 17:46:52 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2055.outbound.protection.outlook.com [40.107.6.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57430233E1;
        Wed, 15 Feb 2023 14:46:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IN58aNS434JWeCM4IvMC+c18d1LlQIDTqkh7driTScSL9uAhxzvfclXLtn/SSos0hD7ut2eyVRJ5I9UVfNwKQItcBKUBukbYScu5dMJL+HsziJqOOmDi2DOoIacuCkmb9dLkZTsQreNzbVBP3mJjx1NYkNRCp91qgoVqSRw7VxuRYWj2at0sDYRjXR+dKtDZOGSJvxWat7aZKA61qfEeFhp9JMUzDEiTZD7zrsYWvau7Edy+QxmN7KYcpH39n6+TQ8H26P5gOrS99U/pnXqdvNs4PCuKeO+sFVlPYVCi5NZtT+d754GNFzqTmzaMOetJEsOGpIDWqwtQ6/7ztHEApw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ar5kplMI4Kt2NpBOP70enFdc6bngcFvPoB3kgAg/WiA=;
 b=nxKHkCRVcqt/ycFjHxAjAQKIxNN3hFk3FDvO6DjqUxgaW12UUiI6DZok9JyOf4ng8j8AkEpgaZAgj6J3tYtyLG8sBbxG5fW9jK4Y0p9TjesP7uZKM0H0qIUaXBr6fwhOPvNnimold+CBphHK1Km3FeY1C9o2ijmTtV8xcFrdJBSvD6aUxzW2DDdbqqsUY2PjKbJV1QtWO8SZ5PHZs+ygU+oaR02r5tAw48OXoX8OgliI8t7WuXowRC5U3uAioIi+tMAfETiN4SMV02sSsq/sMemj/Sse2xZjoidykAke5aAau1cfhsb6a/MgTiroXUJYqq95xHUDscdggaCeqSxaSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ar5kplMI4Kt2NpBOP70enFdc6bngcFvPoB3kgAg/WiA=;
 b=OQ/Y+Spr2t/D0hKKMNz7GZdSx85BRlT5kK/puiuw0fXs71xE9MbB4X0yoc0SE6Af6Pd65NFokfOK2mmJpZhxCwUyXg/HyMC8Vchd01/cNYlOiQEfMepqt0ANkI4v3WbOp4PEO2Zur3XYipBHw17VttjNOCvh+BRa1zesCNUfHAQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8748.eurprd04.prod.outlook.com (2603:10a6:20b:409::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 22:46:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 22:46:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] taprio queueMaxSDU fixes
Date:   Thu, 16 Feb 2023 00:46:29 +0200
Message-Id: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0138.eurprd04.prod.outlook.com (2603:10a6:207::22)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8748:EE_
X-MS-Office365-Filtering-Correlation-Id: ed46aead-6238-428e-25a1-08db0fa684de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jzzCBEar2l9ynAo6ViEmwOiAk1npwc0WNWLjoDnGf/Euru8A5xcjpis0llOpQ8WoWNgPERB4Bg6Z76CJOu2QkzSGXT8HRy9MhgW6mXJpucAeVlOT7sSqwbFcJ/NxF5GfvwRUzzXifUO4WhdbKqa4epFihPNIO08VT3+HWJnNrQvJ9bIxmn1NNKrwzVCjuUVQNlyjF/roviOSm+o6P7WDY0IIbOAxcvRDl7dDOtLfbG9b5HKpStfNV+fdhWUs0JBCSUOtULVBsBsytHfbHRgg1EN5gPheusydBv1w0xhM3BQVuH6/XUs7Jar9C1X2MZhRNTKROq4iGEfJ7P8SKBALjL6b8vexUqIR55ee8YrW60PncjR6DrYqIlU+t79frp3mtrO+mGvUukEw2QLvtC2ozptOeU/X0V3pykflFkwkmYc5fbfeFw2xODqahsAk/oh5LGBdULHfuA/5U4ktYwlb6UU0JtWodm4zyaWx0Wk9jkA9c/VgmA2DgZwdJxcgjiAoAVpEQz6MpAeKLHUk4V5AGxhj9WEsA14TYGmfNBzwO6Iqo54s408Wznt+gTtDWMBQmfXpkcWRdZaMB7bFwXeVBp7jh4P3iQuyAxAIQX4cEdgnEKrZ9u2QLL1cQdREQ3Y/srucJfOSKHwUMcJSIEqeSWTGHyIZVEDoKk+J+i8V3zNo3/tZkY9kqtSr2v863qrrCrtW2EkWyD0BXCKcU2svpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199018)(478600001)(6666004)(6512007)(26005)(38100700002)(1076003)(186003)(6506007)(54906003)(6486002)(83380400001)(38350700002)(52116002)(41300700001)(2616005)(2906002)(86362001)(36756003)(4326008)(8676002)(6916009)(66476007)(66946007)(66556008)(316002)(44832011)(5660300002)(8936002)(7416002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8xyIjye8BfboZVzMo6gmcBmTnqzHiOQlZnjK8GrInp/w+vXYl1WVHgU55+bW?=
 =?us-ascii?Q?I5MIid8tDJ5/aNStusijmywPjQtXceQ51Lw1K4e238MubWLtO50Tt0WeazLz?=
 =?us-ascii?Q?4R6wyWN/CRnQAcGkxg9HHZtXo+Z39JhaPw05h57xx30Fd9rc3VfF1hFLKfQ4?=
 =?us-ascii?Q?OUo+wAFwRCmfRknR8tUvKMeodsRx5sPKGfZG7WKkPqZH3m8C4BqIqhx22Tuc?=
 =?us-ascii?Q?eNDYm1miNKbO0INHwLjBjTsKq3ECwd0V2QQWGmuzo3yNxptlnz7rsPOry4s3?=
 =?us-ascii?Q?1+scYO/nLLwbU7axfDw5kQw5ZKqld/eA4az+ftBJj98ShtGx5ruM98gA0ZS9?=
 =?us-ascii?Q?GfOVWL3RQuPrCrKa9LFL4xSCNwQL/aCr1eT3R/Kkt0DMw2c4kIi0n25o5NFy?=
 =?us-ascii?Q?cxXUP3n7BCt2fxm5MkI/u1bRnm91DQNYQGKqbjHEOY5/JK+sZyDfUqI4HyWm?=
 =?us-ascii?Q?7DxFuKsr45SrfBuI9FBsMXlDTUNFcPUK91Q5cDT99GRrCr1km/eQqE3NqbGr?=
 =?us-ascii?Q?tpiS8+u8qkL7zlgH8JbgnYJSbVRIhH+oupaFdeFtA+nvwd8SUnaVH35THBIQ?=
 =?us-ascii?Q?VhmK1zjF0e+7c5QsSj7yPPeZk0kWzNHBIaflpMFXgWr5qdo1XU6GBASC/pC5?=
 =?us-ascii?Q?EI6j4DonEk6HdiOgtKlQBrs1R6bT/5nHTEDZMuHD/TWw5U1LnapW9E7hII5F?=
 =?us-ascii?Q?X+QY5zNSpL1yOJ+LRzRYeBXBLXjuExQzxDfHffnkR8bAGbZZeHVG2r0brRZH?=
 =?us-ascii?Q?VPfgsxhTJkVanHq8M/Fw23sA/F1qMKlEbAVr7P7+zrYFfPv/qvHfptlW9Ugp?=
 =?us-ascii?Q?/mNmktRdP6XdVHz5xRKsitPgSlxxEPtpMeYSVYkZdfLuPgAHvLTaEmkmFZle?=
 =?us-ascii?Q?PnM4+sGI6kgAQJSj4tr5gNFNa3VXSm6p6TRKN6rLFerqdm8VnRtobVD8Ccmt?=
 =?us-ascii?Q?MdiH8zcza45tgkKPzvCX4b+h7PTrNfSV3+hxi/K3wMZVdqjSte+R3V14apO8?=
 =?us-ascii?Q?DXfOv3fWf8LFeL4GtFKJqNj8N/PtPGSQMqiMNSWR36TF71SCJ7htBbuiec6G?=
 =?us-ascii?Q?/x2G3HEVPmC/nEPrI6fk3f7QpuAWKO9S/RPHHaD6p58+4Cr9dZyQ2TUm4wDm?=
 =?us-ascii?Q?nR+ZW8QYepaCZ7vjM+95/WZt6u9db4XbOMHCg4BFgepfiWW9Hu4d6XREcwF4?=
 =?us-ascii?Q?i4PpZZ9JxglwxJRdA+MaupXiUWGO+x96wMnMOYftqR9rqKfsbgngLQ0uaQFD?=
 =?us-ascii?Q?KwVngv37cMIm3OFYeDosCSNOMFqro1TBOqzl5agszEwMemEPmrnzhFgXOLrz?=
 =?us-ascii?Q?W3AUyzoAbf6meauYCrtFZ8yW64PJqO5Wq8OVPUQecdiOWDJHxXI1PnLmCzqy?=
 =?us-ascii?Q?+wwHRC/KP0cgJ0Id2GeIxS3q6kYdcL1cWwCLO4EGXYTQW/x60JJiot0oAkPt?=
 =?us-ascii?Q?uYhnk2n72IxA2p0ON+KbaSzBJZFmdpaeF8n4F6mky2O3YR+IoR7vsIwZfMLv?=
 =?us-ascii?Q?8LOdJQ7BKDfeQHNCKOAJ31USS4vAN6K9ebDQwnY3qXsOFXnf8Yd6lpdsL6UN?=
 =?us-ascii?Q?vqoH2DhjiRwnxNMHLd/s86AGY5Or8DGTF2dQTZENKM8EiXRczcQXQNO34gaP?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed46aead-6238-428e-25a1-08db0fa684de
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 22:46:47.4477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oik6C+QqPGtMY2YLAUR0NNng761opV6GPGIcmqBBXhhWSDnucsNbX99ibnZbnt45s4JKWZFnJz5AwEsWa8gajg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8748
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes 3 issues noticed while attempting to reoffload the
dynamically calculated queueMaxSDU values. These are:
- Dynamic queueMaxSDU is not calculated correctly due to a lost patch
- Dynamically calculated queueMaxSDU needs to be clamped on the low end
- Dynamically calculated queueMaxSDU needs to be clamped on the high end

Vladimir Oltean (3):
  net/sched: taprio: fix calculation of maximum gate durations
  net/sched: taprio: don't allow dynamic max_sdu to go negative after
    stab adjustment
  net/sched: taprio: dynamic max_sdu larger than the max_mtu is
    unlimited

 net/sched/sch_taprio.c | 44 +++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 18 deletions(-)

-- 
2.34.1

