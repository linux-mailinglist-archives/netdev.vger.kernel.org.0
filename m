Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8495632466
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiKUN4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiKUN4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:15 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3721C906
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cf2CFfyEYBeKvNbiXEmiFRfRHOJMlXjD322+UbTCx/DvHPJN+5uqUZejOS7mQ0TrKHNrK+yS3abjcVhm+mND//rFwN6eRfQcEDJKmD9prdONabywyZZ49w8UOQNwZbUb8V4qO1P43lH7xvJgG+wOqCarCbFNxdYluqTPEn5gVOlQwK7piZiHVbZ9NxDoKnAuXjpm8p/rYfBgnEQ/XSkCdNrlX28PCVElJZVI1/KiQTf3YVLBNGZkmiOtq46q9JeCHRHunQ8a9dQZfUCf7Q9ujVom9zjy1HQ7aZxPr6l9iQohRhYMSxVLkPK+fBEpDUYlF7J1ULahxK0ZJnluic2hmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VMo0ZouvDelFiwDsgLR3aNyCITfboUZw2oH5iB6booA=;
 b=heIC2kqrza/uhKmkw1UzC2Ke6FOuN7cEG4YM6YcnFs6Jj4YUrmLxJMAAsXyNv8NrhJscTMmY8coKN5k7hZM/sHM7FAB17u6dvGYt4zf4ULrVafFZU1Pu2AHnSKVYeUhy+54YjHk8cgOvHTIiQ5lAcloip5TqP43bB6J4ZrRCsAY4LZ1Q5qpoaQwyBOBn5JZ47z4cCq8jIo/w6j7W9EljihjxnaOT6N4EBDVxxz5YE2bRM2a671PLnLRo7wCbgcz9oClE+ggqEg3uquQs9Za+gtjhP4lfeqW+90CbyfzT34jKSC8d64oKhq7T3AQL0BJpp5K2jVK04erNBHfZ4q2OeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMo0ZouvDelFiwDsgLR3aNyCITfboUZw2oH5iB6booA=;
 b=PiogkqeagcDNAyBgi0P0EDlbL5hmUppfdjHamya28m3h+ZexHwUak+rPmATXVu3mycVY+/DiM8GPirOASxLLO4jdmAHHUKjqdFHbEK0TI8H1+i1V9Yn8WRbUM7faf1lO5JVqMbGxj0KRZiIWhfLBQNHhJBrlfVF3KW+skE1jE28=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8134.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 00/17] Remove dsa_priv.h
Date:   Mon, 21 Nov 2022 15:55:38 +0200
Message-Id: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0015.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8134:EE_
X-MS-Office365-Filtering-Correlation-Id: 5464e0c2-c906-4d80-a5bf-08dacbc825d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MuItEoghoU/1JxsN7qlzUBInS3/YrCko/Ozc4I7UwlhNhVyiBB0YJ8ehZq8W2MUk6adaSvfDslpx0SrT+5f+i7DOFk5DDLuAOJ0FpUXihAiFTofWRLybfM54oDdiTpMJHa7qkVY1p3NS74X96IrIcnaqO3a6WJVxNTOUINzKnUbCC84H3g07vYyrFRdes+lyYobQhoR4fttPsXFJxdklpprgoDnYaij5SP2Xaj+mPLtnyFuD4LNCWFdt294rdW+V+7jyNCjslnRDqgATkz4etakBkFDXE362QZ/aTjc0ZZkfPbYjNljmqb/j11WN4H9zAL2OT/hykGJeiKsLJlclIvwA51bYXzAyHOY9iAm9xapWyKL+VFMOzd2IuloTs/Gq3u8cv2aJNEA+PGKF1DS5cGJ9f+69diyfFKSlHyIFX7IlwYViZP0xpYu8POk8IxHhHyaQY9e0Du8e3YCvIG2tEa6mQfxJjgJikB+pH0mYbtpDsC5BNw94XIdFheyXoNcf2On0LX6FOYnzAqamI9hf49mlWlYROlYC7iurdMdDx7CQXpEyDuKXtV4VKcGy7tPzOh4hnl6w+VBQu/ggYG9dzF5g4AZ/bQdWdMyt/MlAo2scXcmoiKd2A8CWPG5CiyB8HuHsP4f3tDfyOW/gwYmBC8j93arMclYHQ7Mi8ZbFRAU9yr63Zb6uEzIFoVUPkEm7aD6u/EA6RaEl7m8xX9PG36GHnEUNm2oaEG4G5gzhzQk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(36756003)(478600001)(5660300002)(44832011)(6512007)(66946007)(54906003)(66476007)(26005)(6916009)(4326008)(8676002)(316002)(2616005)(6506007)(52116002)(66556008)(41300700001)(1076003)(186003)(8936002)(38350700002)(38100700002)(83380400001)(2906002)(86362001)(6666004)(6486002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pvjX6Zh8wScB1kUSM7SMx34MVmpGU16NIuae4hVghFrVMY9FoyxalikMAbIA?=
 =?us-ascii?Q?h03c+mAJsjh9sWWJuwwllFXhwl5GPTOev/YdM0la1rM/z2fKrjsXEJt7XgYh?=
 =?us-ascii?Q?2p3Z3BPfySjy5yP3yMMuunsPygP9cZqHz5LSAozshrATo1LFHNOXrDOKuxPN?=
 =?us-ascii?Q?1tRqyO1WxiYEH1jrIjSg0aBTbxb2dQfhaEg0fbZpMb3rNYYbxhaPAN5hvZ6o?=
 =?us-ascii?Q?COU/iijI6aGPfooukxK7v3Jrd0UY1WijfQs6OiRpT5NVBictWX6/ORSmSJIF?=
 =?us-ascii?Q?K3uuyx+v4hBJUIwPmoQKLX/gFef2ObxQQNLh35IDdOfXweIL94tPeONb4eEm?=
 =?us-ascii?Q?OajFFEYl+8+A+FxwxztACwc8yDouNm1Mv1QP0c+eMDnXLyrEtEejjgBwVl2C?=
 =?us-ascii?Q?it/z23/KYy3IsnCS3RBmfIwvvidZRC4AXG4mUYmd0qhaQ9ynb8YfZZQUZEzA?=
 =?us-ascii?Q?0+Eh+du7Npc/dqNITcUOwJlBMgpTMfS/i7TERC3dIBNW4RYYumrRan5a1LYu?=
 =?us-ascii?Q?kQDSasnY5I04J+9y+fBV3epuzkLueIx3Sbnpc656RANJbcYgiwgA9IVEWpyh?=
 =?us-ascii?Q?rYqHsXnKQcJPpaYGayg1V22AqWLwXeThD4bi30nAftreRycg4fLyG2LyYulk?=
 =?us-ascii?Q?tzq59ngwWmh5Xt+xWWsQZR00hw7Mmowwm5YBbgK8cl2JqZMBVid57sengS1q?=
 =?us-ascii?Q?puWB97CpX1O4EwwLpelaNj6jXRgxwmSC0FiqytRWihWQkPI05OigJssBamva?=
 =?us-ascii?Q?ca5J5hiLS+4EyRU4Q0XrpamAR8uGWt+MYhpgVU6QyFKpeX17gQwKc51BQTBd?=
 =?us-ascii?Q?TX7/8/3ye35N8hNCIvkoRtz7ucCmt+jx1MkqPuWS1g+vyeE55kroKi6xsEYa?=
 =?us-ascii?Q?Km79t8da0zyKyeUQ2PYlWPH8S5Ks1sE75G4rqVpzsFSLU1Xu/kHHT5Y8NNoh?=
 =?us-ascii?Q?HV9rl0LHPvtTTMXcYRVBXoE/PeLOhgAUJkFeCnPknijz2KNPFyD9v0QQQwJE?=
 =?us-ascii?Q?16LsghX3HzplRI4fEbwIzcSresXJGMPeXGtsBXa/JNcudU+swferZOPOUtOZ?=
 =?us-ascii?Q?PiNzyB6X9uzYh36ujl+ZBAKOUg9dwmlFS5Nn3KGcg5ZgTXMrqGklzTZ1doHK?=
 =?us-ascii?Q?8MDWH1GXq7iAhBZKP4pT8AMVh4PeR7riK5jm0874eJZjKJZJ1QwfMxM8zmQb?=
 =?us-ascii?Q?UYJFMHZQw83OApp5BcBznAFLz1WXKayAo0vNlRSWfR/T7kXxOva6P8kpQj6n?=
 =?us-ascii?Q?eSghuqdHDGACgN4UBHI61M9jgi8YP047xNLS4mQBBobSTUa6FQzYbc5wsD9X?=
 =?us-ascii?Q?1O3rpQSL7KO2uBm4tLRBNpT2jevSUiR0EIB0qMHKmsK5APCouDiF3N59lKel?=
 =?us-ascii?Q?3PG/KJXyn2FLsDMcGUwD4MosSszeGKkyV76PCdjt+zvwnBWSUEKj1K6L6QzR?=
 =?us-ascii?Q?SCA5RvuiNQPB3HJ9rZfOOkkq+Uzt0ZqMDS9DQ8O7keamCFLCJ0pxGwQloTMZ?=
 =?us-ascii?Q?zpraOh0i+IyKw4GbuZdZ/S2D3rvf+ZRuB4xDecBqIzS37uvAakXjN425zdIR?=
 =?us-ascii?Q?OtQmA6AWVp5+L6x7iUd4YnoD6+sLJwveuWw/dZrleFC2mAFHQ8YtA7jGj0lL?=
 =?us-ascii?Q?MQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5464e0c2-c906-4d80-a5bf-08dacbc825d7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:11.7633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9rSoFgHDc03oNBkIYsvbFDwv+rB5kuSN5zAUcKz8i6SIEtaEBee40rLP5Rb/LAK6oJFEWraBIwJjfsh21Dg9+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8134
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After working on the "Autoload DSA tagging driver when dynamically
changing protocol" series:
https://patchwork.kernel.org/project/netdevbpf/cover/20221115011847.2843127-1-vladimir.oltean@nxp.com/

it became clear to me that the situation with DSA headers is a bit
messy, and I put the tagging protocol driver macros in a pretty random
temporary spot in dsa_priv.h.

Now is the time to make the net/dsa/ folder a bit more organized, and to
make tagging protocol driver modules include just headers they're going
to use.

Another thing is the merging and cleanup of dsa.c and dsa2.c. Before,
dsa.c had 589 lines and dsa2.c had 1817 lines. Now, the combined dsa.c
has 1749 lines, the rest went to some other places.

Sorry for the set size, I know the rules, but since this is basically
code movement for the most part, I thought more patches are better.

Vladimir Oltean (17):
  net: dsa: unexport dsa_dev_to_net_device()
  net: dsa: modularize DSA_TAG_PROTO_NONE
  net: dsa: move bulk of devlink code to devlink.{c,h}
  net: dsa: if ds->setup is true, ds->devlink is always non-NULL
  net: dsa: move rest of devlink setup/teardown to devlink.c
  net: dsa: move headers exported by port.c to port.h
  net: dsa: move headers exported by master.c to master.h
  net: dsa: move headers exported by slave.c to slave.h
  net: dsa: move tagging protocol code to tag.{c,h}
  net: dsa: move headers exported by switch.c to switch.h
  net: dsa: move dsa_tree_notify() and dsa_broadcast() to switch.c
  net: dsa: move notifier definitions to switch.h
  net: dsa: merge dsa.c into dsa2.c
  net: dsa: rename dsa2.c back into dsa.c and create its header
  net: dsa: move definitions from dsa_priv.h to slave.c
  net: dsa: move tag_8021q headers to their proper place
  net: dsa: kill off dsa_priv.h

 drivers/net/dsa/Kconfig           |    2 +
 drivers/net/dsa/b53/Kconfig       |    1 +
 drivers/net/dsa/microchip/Kconfig |    1 +
 include/linux/dsa/8021q.h         |   31 +-
 include/net/dsa.h                 |    3 +-
 net/dsa/Kconfig                   |    6 +
 net/dsa/Makefile                  |    4 +-
 net/dsa/devlink.c                 |  391 +++++++
 net/dsa/devlink.h                 |   16 +
 net/dsa/dsa.c                     | 1754 +++++++++++++++++++++++-----
 net/dsa/dsa.h                     |   40 +
 net/dsa/dsa2.c                    | 1817 -----------------------------
 net/dsa/dsa_priv.h                |  663 -----------
 net/dsa/master.c                  |   10 +-
 net/dsa/master.h                  |   19 +
 net/dsa/netlink.c                 |    3 +-
 net/dsa/netlink.h                 |    8 +
 net/dsa/port.c                    |    6 +-
 net/dsa/port.h                    |  114 ++
 net/dsa/slave.c                   |   49 +-
 net/dsa/slave.h                   |   69 ++
 net/dsa/switch.c                  |   53 +-
 net/dsa/switch.h                  |  120 ++
 net/dsa/tag.c                     |  243 ++++
 net/dsa/tag.h                     |  310 +++++
 net/dsa/tag_8021q.c               |   19 +-
 net/dsa/tag_8021q.h               |   27 +
 net/dsa/tag_ar9331.c              |    2 +-
 net/dsa/tag_brcm.c                |    2 +-
 net/dsa/tag_dsa.c                 |    2 +-
 net/dsa/tag_gswip.c               |    2 +-
 net/dsa/tag_hellcreek.c           |    2 +-
 net/dsa/tag_ksz.c                 |    3 +-
 net/dsa/tag_lan9303.c             |    2 +-
 net/dsa/tag_mtk.c                 |    2 +-
 net/dsa/tag_none.c                |   30 +
 net/dsa/tag_ocelot.c              |    3 +-
 net/dsa/tag_ocelot_8021q.c        |    4 +-
 net/dsa/tag_qca.c                 |    2 +-
 net/dsa/tag_rtl4_a.c              |    2 +-
 net/dsa/tag_rtl8_4.c              |    2 +-
 net/dsa/tag_rzn1_a5psw.c          |    2 +-
 net/dsa/tag_sja1105.c             |    4 +-
 net/dsa/tag_trailer.c             |    2 +-
 net/dsa/tag_xrs700x.c             |    2 +-
 45 files changed, 3016 insertions(+), 2833 deletions(-)
 create mode 100644 net/dsa/devlink.c
 create mode 100644 net/dsa/devlink.h
 create mode 100644 net/dsa/dsa.h
 delete mode 100644 net/dsa/dsa2.c
 delete mode 100644 net/dsa/dsa_priv.h
 create mode 100644 net/dsa/master.h
 create mode 100644 net/dsa/netlink.h
 create mode 100644 net/dsa/port.h
 create mode 100644 net/dsa/slave.h
 create mode 100644 net/dsa/switch.h
 create mode 100644 net/dsa/tag.c
 create mode 100644 net/dsa/tag.h
 create mode 100644 net/dsa/tag_8021q.h
 create mode 100644 net/dsa/tag_none.c

-- 
2.34.1

