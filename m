Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900135B8AAD
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 16:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiINOfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 10:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiINOfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 10:35:01 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20070.outbound.protection.outlook.com [40.107.2.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E511BEAC;
        Wed, 14 Sep 2022 07:34:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAqv/l/FeF0/8A67f9u38lSIq1Ta27yUpcb866DEh4Od8NRdTg9ovVEw/jK/yAO8uGwsKzlIcZRqHDF5nm/TtEQxSLfZDShqgY2UzUovWmPH86X4j7nogEMLsAfhHwZGf4+clk5a1f3r2x2cPGR5lOop/jv/ayTCMUZks3pWBe36GlPzWQVHdEXBnj4wDf5z/oj11wU+V4ut6EXtkX6yl3LWj21mnTEqExv+dc2B0EbJpNyYKE4oeHdFH65VUFjRnjZSmIZU4k9kNseTKP26gnmUQxZv9DsJGu9IzvxHUQf7T5KgYngJz0macdImpr8WkawxSxZ5YG3C2bdIJadfxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERrYvNueZ8fSeXzxwlCPF0l8KXoyFKMy82vN+ixONLs=;
 b=fReKmhnBzB4Y/SRZXKQCfz0n2VN+NXICaJJ0jrMkTGGSF1Sggx3aKWjlLotRur31AF1U/ZepZrDKWYNANQDNHkbVNarLWAKQuRst9vzjLdAFdoGIJqA06hhH/iyH9NoA4HQs0pxGcTuBWGPlBu6LIsmUHAGyYuqUy1eQZiWOYmna9VgbqAqwQzw2HCQA80GnwCeznPN+TykhD0YMdK/4KqzLp/qo+CXuk42dNlqgverRYxD4YlDv1dpYg9Eqn2S2kYNN02tEJmy3Z5lkiTTHF0jX3Onu1+ZF7VDgnivWWI6gjaXoTp9PMVk9ao/JbgFh8myKCtBsuPw5EAzoLXb1aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERrYvNueZ8fSeXzxwlCPF0l8KXoyFKMy82vN+ixONLs=;
 b=sjx88SRmqe3xqZ7IoXOoteFKx73aMYsmT3HwuxYH+uUUT44LG9dDDoJ9jjEqENh63xYik6ady9Xmzpw60zUvKcwlNhw/rbmSRFbX0X1CZDT7QcG2R7fVanwHpQ3zlMFVts0cxjshInNKtumWDrRtuKX/i6TQARCfrWi629bfJCY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6777.eurprd04.prod.outlook.com (2603:10a6:10:11f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 14:34:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 14:34:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/3] Fixes for tc-taprio software mode
Date:   Wed, 14 Sep 2022 17:34:36 +0300
Message-Id: <20220914143439.1544363-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0029.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB6777:EE_
X-MS-Office365-Filtering-Correlation-Id: a8426d42-d03f-4286-8bf4-08da965e4bab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ADHzLE7fDssPqV2XtV62kk6Kkiz1pCrxOb/LSdJ/DWYYOWwpwkofwHQBJEZXmTNpOC4UpmZLRGcKqQtcurSN1UAYO1MlLJEcb8bbJi2P2tqlS6VvuRPm9Td/Tv4IJrhK9Y/Jm6qMOS2/eSE2FWiQ7zZeyDyciyppR5fy+BAymgW2OCW4OWyIYJvn6lKo6nVOrnRRbQzWlisDdkZ2dnPGnAOBiZIJJTgpM5iqMexXGYmiiJFIkYSKKwtK1DUsrDhricQPT3JaZx3jm9swf19nPcLSnb4SnRki7z1dNHvLLMGhJWsM4XVRJ2grfMwnqJtZZLfE/1vNrwUnL2wfjGbXXSEwIXqbUSlsWlenYHvZimZe/sKFk99JdIelFXLbaTrsNda1p38vlBvJlb8qmQSAzIWJtIIdwDll5FOcIgGpQhMX7gSEoGJvq5w0r2f2u9CfeUL+bKZ6sFoE+v1jYIiYu9S5bjivq85hJEAOJYGe6xvkUscMepU46GCNujFzzioP5CYF7F+z7Rj7nO8xzz/XD+amrZqYUnsMWDfMNnyY1IoYzl3rESdA8dw2mxdqXTYtnTki9f/zcAPavLJBtpLQM7PcUIqhlbS9NWG0ssR1cPT/ju6M83AywhzFVWBV+HeuxtVoAidgx49xA8EIsPm83q5g0bmJBvDzmYOgOlMtdjL6KP54FtFRETHJKRzIGsSU1Em6vCg1fG2tZfdB49LuOBkBMEGKkwa9EqVzuYNoija7CDW+H4s0GRgTV+AbCYtO1QIn+ThmSvG0ZdVoRC9fKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199015)(6486002)(4326008)(38350700002)(66946007)(5660300002)(6916009)(6512007)(7416002)(6506007)(2616005)(1076003)(66556008)(52116002)(36756003)(41300700001)(26005)(83380400001)(86362001)(66476007)(186003)(8936002)(44832011)(8676002)(4744005)(38100700002)(2906002)(316002)(6666004)(478600001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZtrRQhu9J1gny5VqQ855e4XMXHdsfeTiq8cpQQphAcDkXZWDCDPlOFhI+aYL?=
 =?us-ascii?Q?cKO3Tdmq5vOZu24C76AtsnQ39lqKYDhWKWHxDjzdepq7XJmZY9sPyT05MaWD?=
 =?us-ascii?Q?Pp6gOBeDAwtBS8J8EoyAN74JUtpH8okVAOF7ZbZ8r1lNLwVcTq7QX3V4XzFt?=
 =?us-ascii?Q?rCjmx0yn2YlNpMbJ5HGgC3PyuvgYtwfGjZolu/wsMqXFLXyhy+u5ed2xegjp?=
 =?us-ascii?Q?ZiFxV96R/sX9pxvWbmFPpWY31Z6AgJJxrSHfZNNq6ErhERsNuAn2SAfT5M8w?=
 =?us-ascii?Q?hZfxGNyNgKCbJiQnmnOn5J+GWERRrh/73H/V1dMDvoPeeJPr9PVfu0l7IXxz?=
 =?us-ascii?Q?V/DM1ucLVfvBQrN0g/stIq4BeXnWuaPKge0j/75SryhH9E71/nbGdCUjHJzI?=
 =?us-ascii?Q?Jrbof4AaMW8vqCfHP2pOZ6bK3wslYwDdnX956WszAbOjTUQpXeipmp28jDF5?=
 =?us-ascii?Q?IMTm5uaSPpQFguQjq2A9jgfNevfytthUbNG9BjH1I0dJiFB8ELp3XaMmHmCJ?=
 =?us-ascii?Q?E1OecNvJ2jb60WU1z7byA8ZOI5lClO0sV4AxtG1KB8tzDA51S94X/sDVUpA6?=
 =?us-ascii?Q?VXXk2qOfT/zEsXU8fnljcm2ZHDBSxWne4DMQacaGnDab9VgjhBSMVVprGsxQ?=
 =?us-ascii?Q?L8rEGstHGJAp/qEdfHFmS3uvrXuJ/bn5TDksqfMm9hgdxWrxs+yV9o40xM39?=
 =?us-ascii?Q?UaDlse91eUHBbKJXCwXE9ll+XV2sIwQRU5smzUcsidknqjgY1h4PMBLWMEN9?=
 =?us-ascii?Q?033aKNNr5Iz9Xa6P9GjkIz+uIzoCcePtjlTs6DLSHyCgJ+mbzV3HMGM8t7jo?=
 =?us-ascii?Q?fA2XHmcRWayTdVdjFQwGNtYL57sfFgnMea34ruHw+UTrvnrvq+cnN2sp50Xa?=
 =?us-ascii?Q?WV6kOF6AcMVUqI7j/Zg8uEDuWQiLfLSnm/BsYH/tl72a6QuCdV2Ca7VwoKEK?=
 =?us-ascii?Q?VxJTPUZUEWvKmX+N9l6KwLtlXoQj/38asCCyCbr95f5DT7pEnNdbMrvSuH+5?=
 =?us-ascii?Q?cOmvZV2Nj2vr2x2QEBQCZY93HrqtsfqZvkomq4rR1wBWjUIm8wltDHC5iv0h?=
 =?us-ascii?Q?e/YeZepBYGpAWsOEwG164kUrwIByi0XB4s67Vog4h7JaQUoasKNf40FpdRI2?=
 =?us-ascii?Q?9EQI3KwbAATEZZ9uhYoGG+5ffs09uklZGqBWNDpk4voDPK6oom4ZVS1Fy11D?=
 =?us-ascii?Q?Qlwy1BU7KzRz7aTIXNC1ycltX+LweuEWG8QbLsoQ/iJix2L9GjxWKfZfJwa8?=
 =?us-ascii?Q?5HhJ6SwhS+3aDlCWiwDfkyqKMHSkAdxJzNwbsr/141+4Q0qOQlQVIV0NeQLQ?=
 =?us-ascii?Q?0cduOgGzHrVuthRNKEHwEEgWlGzBlRXN3QaNLRIQ44XNqI+H3yXp3tNAr/1/?=
 =?us-ascii?Q?IsV1D5HRQO0CAv3/MEIGHAmMqbq3R7F0hAPeQw7gmhADatlxcKKsvCH3q0Wd?=
 =?us-ascii?Q?d1ZrNMe69IArKAprzP+UGuJemrcsaCRfEw3347qdv7EE2VxMiYxXqknoQph+?=
 =?us-ascii?Q?LetQ7kRPVPX61cNKPLYGDGg/vPlfPK0FihKgWhY4LHLOmP0zWLdyYpDLe4vK?=
 =?us-ascii?Q?5430oqvqHyGxexp3mEkwz0LCSraNEUz+QuHP5E/VVWWw5erCtz0Kmn15CRnE?=
 =?us-ascii?Q?gg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8426d42-d03f-4286-8bf4-08da965e4bab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 14:34:57.3378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QVEM7Au7Yzowf64o8iFyhYkDvR6DvRDp5gHKUdSFcbufP2DEwtQIuk/miFfsyx3EsdVQr0ECHDrBbLHjliEUFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6777
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While working on some new features for tc-taprio, I found some strange
behavior which looked like bugs. I was able to eventually trigger a NULL
pointer dereference. This patch set fixes 3 issues I saw. Detailed
explanation in patches.

Vladimir Oltean (3):
  net/sched: taprio: avoid disabling offload when it was never enabled
  net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo
    child qdiscs
  net/sched: taprio: dereference oper and admin sched under RCU in
    taprio_destroy

 net/sched/sch_taprio.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

-- 
2.34.1

