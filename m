Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC525ECCA9
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiI0TPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiI0TPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:15:38 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80057.outbound.protection.outlook.com [40.107.8.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B99D5E566
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 12:15:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZt2/xr45STJv9dOXCFFcu2Tv6KJwypO9HuRRew9to8dKQGI9VrVSDmwy2rKdttTIH0PAQ4KcT9QhFjs3JSRrwWdJ35Uv9UNreB6ihepXZHmbBVda5tp2OBBfRomEILop/TGHHmT+4Jzagy22oPNVUTBDRX3ajWpdWjmSHO4sszQtW9Gy7NWrlnNWKoyVfJKifEGISwm0JyAAxt0kysFjRTWsheqjMhE1oG4mCXVgRgzV9DxMU9dVgzPy3ti8jZNQyEnKW8WElLlj4lVmptrhz36ghz+y8dcbaYO0HglxPoKho5uNihlvVL9WxOCu6Z3Yxjc/h+fsgmdXw9XE47+hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=szKmPp4un6/xV3ARyTRMSe2Rb2dhlI0OI/L4BSo6Hak=;
 b=gYdfnlQw3xaiTYHRUjV3ZOYpn4bmA3l4Zj+FoppDDzMWL1yYa5Ays/X9XOsMVIvK81xE4AWIVFLqzrhDYDEDwsrrKV7HGsenMnLcE36n/NsiR+dEMrDFpblRONoXHdx5+9Tg22wAtyjm3xGMz2ov6f6tMeXUkxy/iUhSC4MfZtaUmhp1se/H07HxZYg7hz23vws9C9JnCK3aJluW2679uk+1Y2ImQs4k2Ro6piFb1T5t5DrIJwso7srRvpp+3gzPE6n8Tqmzvbk778/Nink/GWjnv1UGajB/zHKntmGC83Re8vJ3q8Du/L02WkZho4TL+Z8AeWxidl19H28PFnjalA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szKmPp4un6/xV3ARyTRMSe2Rb2dhlI0OI/L4BSo6Hak=;
 b=BP/TFazaYYS8v2PPTdEx29XoiIZeOz5kQdxV1zuALv9lkM1zys7GSZ/T415siKvU9XMTBlUQCJfbedHX7YoLr01CHlIVyvgYi+ZZWt7TjVhXhMuld/BX6YBkkwfWxVJ8k2bvtCVNuCgoUHuzmxMcS4l6sxUiiC32EVvp02spHCU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7029.eurprd04.prod.outlook.com (2603:10a6:20b:118::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 19:15:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 19:15:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH net-next 0/5] Rework resource allocation in Felix DSA driver
Date:   Tue, 27 Sep 2022 22:15:15 +0300
Message-Id: <20220927191521.1578084-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0287.eurprd07.prod.outlook.com
 (2603:10a6:800:130::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: 28ca067f-178d-493e-743d-08daa0bca5fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BeMtMacFx8o7XQQO8ol5sN2VpkBe7JBkCmxCX4vnYeZVul3FMlk6hGl6pziZFX0uw6ievxvWG9BrnMGhbgriNWh/YnDNMma+tsF1tGFqBjsAJ/lk+CTE9tyXCBUlarKd8Q74nwd1IjIKZofGLkAoRpepIr+iYISQvanHJIRs/zFS2rRjI1IEPKLERBY2Lx5aUPRLVnUqoKAgYPEs2MPbEODYv8PhBljvODV6gWJQg/NNSLMQk1DEoBNJK6R8MhG3vSKcWQyfOOQTv+hpr180DUxPDzWaZdCZEvrzr2Js9IDTx/FsV08e7HalZr2fcz/5/G9OrGYOD0ywsipgiHPhAtJlWoRmBMsavc5boK6p7x4B1bx9u+nK6ClGzodB/YS9lUJsfPKZN5US8q3cxmWqnVBpK+u7JJU3IFsoxrlohizSOKNY8UsQJkzXuiqcOkRz6cVg9XcTZlueP9JbC3qbu4kecc32nsbEOx4r0kPxHzy+kXdF9Pq1DRLhZw0+wa1kNcdkoi1lLf9kJ1nOZiSsROQZlXG+4D89It/Ko8jX1wQGcIQGcpMnp9pP4AVA9WrYxNMh+h20EfqvMT4Ybq0lGUIyoDO4aA5cz7DgLYbqkafD7AefqF7I2huYF4ERMWSaom/7rbxgdEhgrWjD3RScEevvMUkbCZL38e9YbieS/klYUu6764qwxLrGUyy6nOYUAFAfVmOlKsKqqHcyCtlzYWzPx3acGGDe/i7jgI6GcfifKEyT27q7aPN2gzVuv26LARO5ZsRfzf6US+2xIU58b09vFd7kkDBLLncEDeahXNk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(86362001)(38100700002)(38350700002)(36756003)(2906002)(44832011)(2616005)(6506007)(478600001)(6486002)(6666004)(186003)(83380400001)(52116002)(26005)(1076003)(6512007)(966005)(54906003)(7416002)(8936002)(316002)(8676002)(6916009)(66476007)(66946007)(5660300002)(4326008)(41300700001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N6Dix9vdxRil1iV3LhAyGNkEUhRUDqC9MGHXznWZ+Uzfgh102C1a0lI1FA2F?=
 =?us-ascii?Q?uoBzLdwELqKLAvsfI33yHPGKBZYz44mTchoWp2rOaAJsp1tHky3XUCJGStvp?=
 =?us-ascii?Q?q0d0TOl3W0pjfXnna9UuQBYvtkfrUfbc6gqpB6ox7ImxXzpYMPXriZjgkt8d?=
 =?us-ascii?Q?pjvv5yucWDdP8A0ozrAxB+Pxhn7qR3IsJFn8vx/FbKV45ajv6TbZ5nB9TcR6?=
 =?us-ascii?Q?DmuB1jOv8enBLgj63weOKjwk4gv/rNiRQCoCJHaGk8pP/xdMlpktzqSpvJtP?=
 =?us-ascii?Q?wzyekzhj7lvI/f3NHnUhiMX+bn0MiFeF/ee7wVWGB8VXsEiRcZMICT/TW9yw?=
 =?us-ascii?Q?LQJX3ZPZKUN/6z7wnFQXhNzvFmWZ+wsuhU0ruH+4fiFCjcsTKTkWkHLy48Hq?=
 =?us-ascii?Q?1DtKU0nKagmYiU2tta5UzqrBqGwHrsy7csG8nQkIB2mSkqXAHV6wLSOWH1Wh?=
 =?us-ascii?Q?7YowvE2mefcZiMwXTr0I3BfsvHDD95hs8hvg6ix53FQsfVoNZCT2pKDosLaT?=
 =?us-ascii?Q?WisvCAw0TVLw2qinbm1eA7pk7iDCkm0w5wlfToE1majLnpbxPlRfa1D/AP/g?=
 =?us-ascii?Q?wNNivkZZI4gcRY4KEHKiTbJzk6yhu3771HNbvdtTf0WyC4FVQeB4Rwb3ctRj?=
 =?us-ascii?Q?rVNC7lIj2I3wUmk+tRLb6ygJnCn84HBs7aZKvlpO45n1f5q6aWJM+GJTisHD?=
 =?us-ascii?Q?LkpsDj1mCyE5EXd/5WmklVUR2uinDMf8IYEG7fFN3jJCgu0qYDYegTBfLX8K?=
 =?us-ascii?Q?XOC06UNlFYU2clg1HdWttFlr8EQd15GSCNcwyJQh1lCZLsT8H3rfqJckdzcg?=
 =?us-ascii?Q?nJ8H2Z4lOLVWYrDWUlYgpZyY73pxr6YR80LZXs3pHXzw5A7nuPZ00RWiQNH3?=
 =?us-ascii?Q?e/7gWD3/B79nKIS99/bTZ8f0ftPHS42x3bvPFF/+KskZPP41ne0wbwEZvmXh?=
 =?us-ascii?Q?fDvn0ge2BOpUhgHc0ArGe7NCLXgN8Y8yWO6VSTe9WwP+uMjyZP4KVxQXjzCL?=
 =?us-ascii?Q?qjkrGfjgdh8QqI2X9iQsb2Gz+GGTqzuZoctKHAA1/X+bMabqRlOpkZBuJuP/?=
 =?us-ascii?Q?MOd3ognfPNtWe7k+ya2Mx8Bst8PGCFTDm5oqT5W2LegIK5Y/j5m/nNMd+F16?=
 =?us-ascii?Q?wFg0DwkK8Qa8qXqMPQeH7Uedt4/MrweBMsK3qBy7zt0oxkI+BaeWSG4ZMlqe?=
 =?us-ascii?Q?uGj5DfDYOyleLKoj76d4H10EMOF1i+qkUWIj7gy4+MvCOhDsD43PMnkvuh2I?=
 =?us-ascii?Q?dgdhSRsjvEa3ef5L4XIcW1mEt+FhmKr9xZVvJBoBo0he45gEdPxxplCYEtiV?=
 =?us-ascii?Q?/kfXz4qR487HwTKOZAoqwOoNHoIpzM9tdgymsFzJCa36cMKeZSlJo0fSGa5X?=
 =?us-ascii?Q?JzJgPoD0Lh/kyROUfKzHPuvHVpMRwhMLPxkBGLVoyNzTQjFrKUQPbVUOIi8G?=
 =?us-ascii?Q?G3NyNMJZ5MbWGYDwiWpgGL3OXY0IzCcpgE3GXVORkXC8EWAmIxtO2MZNM71a?=
 =?us-ascii?Q?BKlp3W27PTnqWbHTtu/MosWtzE0PjehAl4WE/4QAW68gdDWKwQtyeZ6wnJ+7?=
 =?us-ascii?Q?6qHLv/YIvGE6yGizkzuRfEGaJorxgMKYQtdOP5U3fhjj9D/nYFqiW5n7W0kC?=
 =?us-ascii?Q?iw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28ca067f-178d-493e-743d-08daa0bca5fb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 19:15:33.0361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JSNxPvRAmFkLdqNbUAwepWDdrNH++PoS9xS4A9N+UsU28Oukq0821kofJ+nuhW8tdIeqeGNWB7dlADWdGjcGag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7029
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Felix DSA driver controls NXP variations of Microchip switches.
Colin Foster is trying to add support in this driver for "genuine"
Microchip hardware, but some of the NXP-isms in this driver need to go
away before that happens cleanly.
https://patchwork.kernel.org/project/netdevbpf/cover/20220926002928.2744638-1-colin.foster@in-advantage.com/

The starting point was Colin's patch 08/14 "net: dsa: felix: update
init_regmap to be string-based", and this continues to be the central
theme here, but things are done differently.

In short (full explanations are in patches), the goal is for MFD-based
switches like Colin's SPI-controlled VSC7512 to be able to request a
regmap that was created 100% externally (by drivers/mfd/ocelot-core.c)
in a very simple way, that does not create dependencies on other
modules. That is dev_get_regmap(), and as input it wants a string, for
the resource name. So we rework the resource allocation in this driver
to be based on string names provided by the specific instantiation (in
Colin's case, ocelot_ext.c).

Patch set was boot-tested on NXP LS1028A.

Vladimir Oltean (5):
  net: dsa: felix: remove felix_info :: imdio_res
  net: dsa: felix: remove felix_info :: imdio_base
  net: dsa: felix: remove felix_info :: init_regmap
  net: dsa: felix: use DEFINE_RES_MEM_NAMED for resources
  net: dsa: felix: update regmap requests to be string-based

 drivers/net/dsa/ocelot/felix.c           |  73 ++++++++----
 drivers/net/dsa/ocelot/felix.h           |  13 ++-
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 136 +++++++---------------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 140 ++++++-----------------
 4 files changed, 133 insertions(+), 229 deletions(-)

-- 
2.34.1

