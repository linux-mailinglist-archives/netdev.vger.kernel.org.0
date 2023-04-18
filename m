Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5292D6E5F81
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbjDRLPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDRLPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:15:21 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF58128;
        Tue, 18 Apr 2023 04:15:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ht54AXH5xoSGNtbA47KF4fx7x+Fd3m4G7M7wtcB4yy0Bf+sSrSdYZQrcb7/09bp+ibKvuoZJhJzSKuoxyNBnkMNBIKoX14tQ7coMXqlwq+sYE0Si9mAbBkd6dwenbjKgCE1ARIaGLjJW0FGqfOUWTSfH784ZGTDPjD/pW05htThUNCM9eTWWxUZFataan/gqnnyFmlKFTJzJcFAJW5gPBGfjb0xU6CyotXSY8bSVkGOoOP7F++mh7/ZVSHyjjoqggsZ7zrH1+uZhaKLc1CuwsVkt/agx9r/eiAxnWGozkrbqZjgu2n/I3CJNecxzGpiL2B0wtdJMFmJWNzUuVYZchw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lqf/eJuy3wlKBmp70MLJHp4tMtUxK0CySmBuf439LgQ=;
 b=JfF22Z6QxwnaEap0fxYruBtCh/m8Dznqe5/XEk2lImu+wDKCi9JYQpqkRh6KnWi3ealLyvDAEOTJj9S7WkBxsuhyYxXN9o5oQBKTi16kuKTHshYQjTeN8dFhBwp7p0hcr4y3joCwNmENPV4cdSeNCRz81wkblidWOO6dUGH1jiVT/JaeGj5Emf0z0FbFwXRueOoSHp563PhaNy/tg9IcATYQXl8opi9Vo5PKZdp4C98H/6Zxf2I6HNT6cMRfOfop1ZiLaTWIaRxR388z3umcqPu+f26fYOOugQhRMZjJ209R2mQGpW7qPHoay5F1eTZMmloLv0kM+J+Ksuz5PbdJdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqf/eJuy3wlKBmp70MLJHp4tMtUxK0CySmBuf439LgQ=;
 b=ahW2X1y44ZzrXbIa1i2VAHA6Bd1j+OoIMxDfoMXSA8npnmeqTZpReFp4QPg4B4rfml9CS4t6XTGR47ODyRsVXQ1wz9sv8/ezE0eQ67s64AG8wwF4iQCwH6+3sTENGE4zkw2YWY7vPFuCS1qEWgDsitICsI/0HsJuY8x11u2jxnA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8659.eurprd04.prod.outlook.com (2603:10a6:20b:42a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:15:15 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:15:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 0/9] ethtool mm API consolidation
Date:   Tue, 18 Apr 2023 14:14:50 +0300
Message-Id: <20230418111459.811553-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0152.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8659:EE_
X-MS-Office365-Filtering-Correlation-Id: e3a8f4d4-0a04-4b56-487e-08db3ffe2f88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NV/BSgYfDRl+0z12pxZHxRKGHKksQRsFL2q/gG+GMwNcS9M1o+pIL55ap54FLV4ff4q085RSq8TGzjADYOCR7ikKlSQs1WZb3Vsy3hElWXc9QWziho1HOLXXabpNg9xiJmwnui7B6VzXsBkP0OhfThQTcTSWdptZHvMpginqKldMYsRRZ/9Ih7u8/9X8G4ACgH/oEd6sb+aF9qGCi/5IZ1d9cxW/vzLyyJjMibyYmZasMmyDRcGE+/6BWtcC0/JlYhaSZE8t5Dg3QEw1R/jI8Y9q26Prjdh6A8JRuaxTM6byMEHy4O7716Zz5Srjn21pxNA80zV9+CqOzdlfHQJw0RzQ1VztcZtLpLXWWbrtypfq5lq38XrBWkUalzZxq6xkYVmWOXk3hV0OQ+VSRsE+I+S9bv+qQE0GVjSYJhdK6vQd95Ysq1N1O1U/AT57wL1HH4rOfBarmy4K3DEOtBuB4iT7zUEqqMYCWo3tC4BoPNtJSvzXsLE3ylABXgFJ9/Jg2dLIskABivO3XjgU8LQEjVrh4JScRBtA6gVpTownCGtrpNdeJ4YV/JR0mz0X+TAPu5Hb7zoKu3+Lw0/UsjM2r/HyLIM6bt9G+aNJ9eX9T7p+bfXCvSqQezc4R6hrCq07OXWcKfnOevd/67OFHYln1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(966005)(6666004)(6486002)(478600001)(86362001)(2616005)(36756003)(26005)(83380400001)(6512007)(1076003)(6506007)(186003)(38100700002)(38350700002)(52116002)(66556008)(66946007)(66476007)(316002)(2906002)(4326008)(6916009)(8936002)(5660300002)(8676002)(7416002)(44832011)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8GBpZxwFnvCYtYR8gtiHkKQgaGgm32+kXSNSoIDlbVh9ulErkpgOLppqJpq0?=
 =?us-ascii?Q?sYjQVQOBkk0pNK7AdOP4voRCpihjhuv1p9FtMfUd16ijNP5QDFOednNb+RXU?=
 =?us-ascii?Q?Dk2d1s8xM40Katk6+XJ4SVEOGjgGCRZMM8dhhtReTg48hMoP+flsPAe7YU5U?=
 =?us-ascii?Q?OHHo2fQeWbqFa3LNudui8DtO7gIYh14QtZ0saeKyx6Z1H0wsAlVXLI/Aydmk?=
 =?us-ascii?Q?BkoVpnZm1QJBiJo3tBWAL1mXhZCoVtf1ZVdibO8yb1bNwO3ZnrOatPYoMjX3?=
 =?us-ascii?Q?pJoAKgAp5maZ7BDc6pWpqK0kgdvgUd7755m20O4iMbk7vecRrUQcbuvF39V8?=
 =?us-ascii?Q?qXAAhLMgcPAcgvunShkmyeHhXE17haj1C+CKnFQjoLlUaH+UfnI+9NvPQgPI?=
 =?us-ascii?Q?jITDYTYMCasELIsEPDcMoyJW5o7D/apKxxjleQ0QNLPcDCtz0F1HPR0q5EfZ?=
 =?us-ascii?Q?3zJbummsKGMFlrvJ27uw9eJbmkjHcZs8+Lh7ko9vuSDz/tG+dXMPjtp9IWgo?=
 =?us-ascii?Q?15bMz3b2SwcRNS0osN0ccIwhT7rqt0m5hDXqPjnvZzRYvtWy9oC1MFTm5sj7?=
 =?us-ascii?Q?b2fvqiYYlo7XlU1lHOV3sOW59WxRKBuzbr0M1Ege/FVZgcBD9o1+5aov0i76?=
 =?us-ascii?Q?gzL8otciUKFq4eyH1JET8ql32A1PpRgsW1rFUfiWu08kuaLbvyn12Xj7Msmq?=
 =?us-ascii?Q?uzYmK3GQLh9U97UZlTiCfy/Kjmpwr8HZQJExysp7biNk4zY9zrKMuhxlZzYS?=
 =?us-ascii?Q?tukvsqDmoeVedBlFBvUWp7tCuQ+tu5beW2OpwAC3x9MS6N0vNRtrrlgpy8gp?=
 =?us-ascii?Q?TcDTCw0JhD6nRIiHygGhkolt0x1cxLy23YJtNp4Etu8mNrFiGTbbAknGI+7B?=
 =?us-ascii?Q?mYZIkD6Ba+jlTMTpicfNSoJqcJJW2xW96dYl2rdOImYWWiVa0oUMZAChNvGD?=
 =?us-ascii?Q?vpMoOaWb+pjXL0pAwWaGhhn+7yciRv5elLkjprDh8LfnvFeWx0yrCmun6OeH?=
 =?us-ascii?Q?cO4OwBCgNyr7KbNpTUPf28NMJHhdbanP0dftH52DDrrERZXHRloQa2Ra0ooa?=
 =?us-ascii?Q?V74F0y68MEm3GuH9w0hUBxVytOyB1gaaOAI90SbB58cRoqzVMjpPD3IHLSAr?=
 =?us-ascii?Q?Vy31my2S5PR/htuy7lhVdiN0gRB0uEjRQgZncHJPSwcYPs0XlyneuuhXIB/a?=
 =?us-ascii?Q?DpFCIXwlzDEYkh6BrlLc1AgkL+rg346f8JF/zmysrc5tbWN6k8duQS3fial3?=
 =?us-ascii?Q?HlKBn+a3hLS3LE2DH7Bp5UaSHwhTu7SujRTehc/NnhQ9lu7QjTUvklYInjQE?=
 =?us-ascii?Q?9785j2gHk5tLwdR8q+PjvOF6I/jDbkYfmnLme78ljZMfsWsY9OfTdHa8NQlX?=
 =?us-ascii?Q?aaHQc3fpTwirokeNQsFmMkivvkdl6bW2z3FNr1hdc5WCUWWy8CUuRhB/nhch?=
 =?us-ascii?Q?+4iMZbl9rakx+zmfJtVQGuaTfONwQp8wTCak5nZqBuojUsirPZUTy1+84ymp?=
 =?us-ascii?Q?HqkNpm11hLM4Q/NcUlC8wwsnjJa97Z9+wN5zaLcRM9I75GtgnNp0zsOlSeYP?=
 =?us-ascii?Q?QbEwEotxqvBxW8AeAFf/Y5R+bmK5lz6i6clyZGmDjAHno64jtCerwvPbuUmn?=
 =?us-ascii?Q?8Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3a8f4d4-0a04-4b56-487e-08db3ffe2f88
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:15:15.6397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 77UxkFe2HULMD7TNfY4+tulG2ZAOe4IIRY+/wX6N3gvkg8XpAlvXlVsd41s724cZyIA+L2IV30rwLTebGUIjlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series consolidates the behavior of the 2 drivers that implement
the ethtool MAC Merge layer by making NXP ENETC commit its preemptible
traffic classes to hardware only when MM TX is active (same as Ocelot).

Then, after resolving an issue with the ENETC driver, it restricts user
space from entering 2 states which don't make sense:

- pmac-enabled off tx-enabled on  verify-enabled *
- pmac-enabled *   tx-enabled off verify-enabled on

Then, it introduces a selftest (ethtool_mm.sh) which puts everything
together and tests all valid configurations known to me.

This is simultaneously the v2 of "[PATCH net-next 0/2] ethtool mm API
improvements":
https://lore.kernel.org/netdev/20230415173454.3970647-1-vladimir.oltean@nxp.com/
which had caused some problems to openlldp. Those were solved in the
meantime, see:
https://github.com/intel/openlldp/commit/11171b474f6f3cbccac5d608b7f26b32ff72c651

and of "[RFC PATCH net-next] selftests: forwarding: add a test for MAC
Merge layer":
https://lore.kernel.org/netdev/20230210221243.228932-1-vladimir.oltean@nxp.com/

Petr Machata (2):
  selftests: forwarding: sch_tbf_*: Add a pre-run hook
  selftests: forwarding: generalize bail_on_lldpad from mlxsw

Vladimir Oltean (7):
  net: enetc: fix MAC Merge layer remaining enabled until a link down
    event
  net: enetc: report mm tx-active based on tx-enabled and verify-status
  net: enetc: only commit preemptible TCs to hardware when MM TX is
    active
  net: enetc: include MAC Merge / FP registers in register dump
  net: ethtool: mm: sanitize some UAPI configurations
  selftests: forwarding: introduce helper for standard ethtool counters
  selftests: forwarding: add a test for MAC Merge layer

 drivers/net/ethernet/freescale/enetc/enetc.c  |  23 +-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   5 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  94 +++++-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   3 +
 net/ethtool/mm.c                              |  10 +
 .../drivers/net/mlxsw/qos_headroom.sh         |   3 +-
 .../selftests/drivers/net/mlxsw/qos_lib.sh    |  28 --
 .../selftests/drivers/net/mlxsw/qos_pfc.sh    |   3 +-
 .../selftests/drivers/net/mlxsw/sch_ets.sh    |   3 +-
 .../drivers/net/mlxsw/sch_red_core.sh         |   1 -
 .../drivers/net/mlxsw/sch_red_ets.sh          |   2 +-
 .../drivers/net/mlxsw/sch_red_root.sh         |   2 +-
 .../drivers/net/mlxsw/sch_tbf_ets.sh          |   6 +-
 .../drivers/net/mlxsw/sch_tbf_prio.sh         |   6 +-
 .../drivers/net/mlxsw/sch_tbf_root.sh         |   6 +-
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/ethtool_mm.sh    | 288 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  60 ++++
 .../net/forwarding/sch_tbf_etsprio.sh         |   4 +
 .../selftests/net/forwarding/sch_tbf_root.sh  |   4 +
 20 files changed, 486 insertions(+), 66 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_mm.sh

-- 
2.34.1

