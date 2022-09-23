Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745475E8478
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbiIWVAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiIWVAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:00:40 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2041.outbound.protection.outlook.com [40.107.21.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6723109634;
        Fri, 23 Sep 2022 14:00:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcXWTPsI//E+4a9B+kXqmapfCnWqeufufAsCCF1l3c8uVH6/a+mdRO7p895EfHV2wnh11ssoWi18ntcS5FCldNyZKwZlMQRBoI/djf2LBmRAViri75iOZqdqjYWGbuK+fbqSxROLANvq/4Px3qjnKDWTKpF5x90yApgbeK/F+YYtE59Z/qFS/YE8gkrPPU3sEoD2RADSls4SKsMdloO/EIQk8761dKulQRGUAiZOhkJ8UObbBbUWU0mSqzUAvoI2yjZY+AvAiyoltz5lPOUg2bmq0b38+S0q3dzPuX1zUeiygVH0/C/E+jV2yC3KJ7XeDN4JJYFOJu4xmfAS82mRhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fuPEtxUodvmdbLjU8Tx+5k6uYitzVcUQTOJm4E7Zvl8=;
 b=OE757I5ONq+VuNhGFDpeFySciIHNrJEVt4IC/cPMpm4su+6B4zfV0qM259HPcWeNU3i9MsywHhGLWF5ZApHw5u/az/xYECLm3AfewcMalThBnrsUSfR4B+mVj0SO86LODTVzbAYxuoQOcYtrn+tfcIbGQZlB5h1Ib6s0fAZxKvUbkW7YQdXxstgAy5FvRRcDv1RnUU/v4/CqFZOsULft1hRWzlukdMQBeKQwdljwd2HhL6THP20T31Uw/OuHjmEJMTDLPQ2vXL8vbOT3TsJN9yPERv5ye63o833vcrZmceW9pQU5Aqdx13wbUbtHDiEHerSuA+lCHS6N8rz+C1pZCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fuPEtxUodvmdbLjU8Tx+5k6uYitzVcUQTOJm4E7Zvl8=;
 b=Rfelerx6vLR9jZxxTHBsz1GShV1vRF0ZvUgOD7c2gMePW57LSYfl5d1u3gLEysCmB9hAbqo2gV/8xP0kmrcTLptXbpTabU5EF7enMtAI/ABQb5k9UhSB3AtkKCgitE9w6xr1VsRpdfeYdBNvaq2rOnXVEUoAYzCslQDufHjO5eY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7863.eurprd04.prod.outlook.com (2603:10a6:20b:2a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Fri, 23 Sep
 2022 21:00:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 21:00:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] Improve tsn_lib selftests for future distributed tasks
Date:   Sat, 24 Sep 2022 00:00:11 +0300
Message-Id: <20220923210016.3406301-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0270.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7863:EE_
X-MS-Office365-Filtering-Correlation-Id: c845e0c6-54b6-42db-e2fb-08da9da6a99f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EJmf9bwW+B/yDwcukQZcZPzYEnZdwSwS3r20klHVbxE5QE0kMG6Xj1ScVUJ9n5MX+AQ60Omsr0Dblxl5Eavpufui7Icl6L09qf6MVbvKG9SHpi/lV+fBnx6wrqy3VhhG6+XOj2uhPNmmeTZg0V7GOUUnyT8+2RShBRSuxzrVpAp1Y/en4tgC0X83jV9jctUaXnNFAzuxHCw/KZQjmLWZQJgn6LROEvBbYUNMMcsvzLdGuuV4zS2OeqGb48ZfrC8gTffubBZE4zYMRCqa8aG/u6oZt8HbmZHqDyYGGdyL1FcupxZ2oWsBVLoTGA/1U3SsSd26PkObUmZvWCYUsKLVTpuHBpAk4ogWV+LBxogwJ04RIYJCjAuCKzGpnnWpv6/sHeFCyKIE4Wt3GB6p4YhylTwgip8G564oHXym/ah2dCWuDlld8v43Vgq+iypUCmKjcIQoYnH9kBNmsvqNk5JDDar026dGeD6W5v/UK3y66g9VzAG4naC4F9DVyKLbLPfdGDaDoFe3EPPoD+lOGDKRnboiSiQGUBE4Z3Gxp6Rnu8YT73Hwydf9DDu5ZcpJiXLX/bby1BwMFLZqR7pHZVTcYfSTe4Dqei5dvweWaxEZA2MTM7X7TvVcfIvOXaOS3WoUfKxlVZfgTj0iPmENyw+uyTgiRdZXzngcXRseRX+E2mH1pwxdAfLkbbLmNXoqOCKvwR/VTf+fNdx9zYNG4Hh3Ad6kgDTdjgMP5qUrzcDlRFUnh4Vl2AtWlesZYrezQGGe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199015)(6486002)(38100700002)(66476007)(52116002)(316002)(6916009)(8676002)(4326008)(66556008)(66946007)(6506007)(36756003)(6666004)(1076003)(478600001)(8936002)(5660300002)(54906003)(41300700001)(86362001)(44832011)(2906002)(38350700002)(6512007)(26005)(186003)(2616005)(83380400001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8nJaJ9mlk4VQEb2RajIR2SuVL5dp6/P8pzR6NuriBMzdKZAPMzkSJuaj34qE?=
 =?us-ascii?Q?ypnlLBH7q/DTJ0spwYUFGJTqX2Ee3IztCxMVkdiEeU3eAyftO7DF6Xlk+xKC?=
 =?us-ascii?Q?DVQqNsetWxcJ+F9TP8QokP9jewslzqXkmi0+zzEWh7IzK0KZxlV2vM4B9rWm?=
 =?us-ascii?Q?pHbB3/Ouk+EjXU134F9sCuarFCeKRweklcif0sWAjT1/2N077CW6wjJsPCF3?=
 =?us-ascii?Q?Fxbesl0U0m0RPaz6JRmf9lD3uK7wcGtzhdFx45troJuKKpImEkcVWj9XM6x4?=
 =?us-ascii?Q?D8ZxGcpU8U2LEs/zcAlx00gfMVeAAG7WN3xcz38M3eHqZn1c85ijlqZ5b80p?=
 =?us-ascii?Q?/duyHNVtdAZV+/xfDCP+NTR2d6wGJYmIYG6GGjfFBCr0LdZbhmJgcFOILee7?=
 =?us-ascii?Q?wshebOsmq3OaH81i5mKsUBmMk81lhyCAvxLs3kcOkct520keFUfnXX3l0svY?=
 =?us-ascii?Q?/xuHC6ZM87dDiIOgmQ/i8mKuiJlwVpJS2dT1X7/WzTLVofVOA7hZj0vTFcDI?=
 =?us-ascii?Q?H5kkoUTPIgHFOwve/PVkX/2Lzb3VU5iVjqY1I2atWWMSr62Yap8WLtqk4EV5?=
 =?us-ascii?Q?mxlepY0wGz031Bw2+BTmo2LjCKbxUM9TBZYvNiLt05DEHo2cK9ubfqMhl4co?=
 =?us-ascii?Q?qUtOaCdh6n8K5UukaLd6MU9bqpFB6Y+aiqDiicMteK7e2sxHbg4KfXi+RL4p?=
 =?us-ascii?Q?XhQjh+TCkVoaqgIWV7ov7U/uwNNfdEC6Jt4AbjIDxLQjG1bHj24EojRb8KK3?=
 =?us-ascii?Q?3vTWn0BnbiDOxpOCqQ2Qpsk7phcnbR5vvU6fqfVdRqgZleJD5OiqMywt5g8E?=
 =?us-ascii?Q?ilXM0SViagg2rtiLwj3oh5JcpIJiAb7WOop5m6o0AKRCCmh6MVRC5vEy8EAG?=
 =?us-ascii?Q?T51QCDNIemMBw/hgDpASHaRpPZIYN6hPn0xVJCWbAPTbr43aPlPEmmZhBjFO?=
 =?us-ascii?Q?X+ZmkXOBtg9Z9VxNr7aMIw8jcvHBt/q2Ox3XAvSJuIDo7B/b4Q/Y3sBEZcs3?=
 =?us-ascii?Q?AL0ujrx9xUtgIBaw2ckL3WHW8RkP5A5/cj6hjM9VsWlpWuPV15FsuMKHKLS7?=
 =?us-ascii?Q?GoX03Bf5ORKqRYoKjlnOJFhEgvRKMzUeOtqe2mK/k6hvu5XaBKOlfOf+wlSg?=
 =?us-ascii?Q?A0L3DwTmcZcpRPAtXSx5aYYKnYBhZM9mNtdMMDcBxe4M/2tXV0wD/wscpdf0?=
 =?us-ascii?Q?ul4XAjLAstV2WkMS56PL/VdnEVim7HUAGdDcLHzWo13RPLO/cRTYYOx01fEk?=
 =?us-ascii?Q?6lOMf9PV3ru11gANBzkASqSYckFbqmv/mYB+ztVRyR0ttknlCJUNubGFfSjY?=
 =?us-ascii?Q?T6o9gSc3poo5rudssq986muCsXzXR34NXwgZNhCPEZLTifpgMlQ2Rz7om5YQ?=
 =?us-ascii?Q?AybmxmOPEH64w/RMMCyQnVGZAuT4+tW5xBN8W8AmMIh9KwqSIXff+EN3+oNA?=
 =?us-ascii?Q?QixGfWBNF0u6l/lqckZkkIAjkqHYb5/UdGVZ7WmRnGX8HW7CwYpSx4Gaq1g5?=
 =?us-ascii?Q?avzddIJt3A0vtKWqgWs3ygWFNNVR+tPPSLRU0eeHxYdsY3UcQiwe5NZe+bb+?=
 =?us-ascii?Q?0czd0CKMviHPTi+LVstwDLGx9MLN2IoM4gvO9+gcDDUv9vjRv9qZZpUzOWEc?=
 =?us-ascii?Q?KA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c845e0c6-54b6-42db-e2fb-08da9da6a99f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:00:36.5587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lY410wlSWcnUF+7zjnHgXSCbnBFIK+zJhBTBFXKBVVINKNFJk0qCfjqgj6PU6hpNA3sgSitrHfrWNGmZorqfvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7863
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the boards I am working with are limited in the number of ports
that they offer, and as more TSN related selftests are added, it is
important to be able to distribute the work among multiple boards.
A large part of implementing that is ensuring network-wide
synchronization, but also permitting more streams of data to flow
through the network. There is the more important aspect of also
coordinating the timing characteristics of those streams, and that is
also something that is tackled, although not in this modest patch set.
The goal here is not to introduce new selftests yet, but just to lay a
better foundation for them. These patches are a part of the cleanup work
I've done while working on selftests for frame preemption. They are
regression-tested with psfp.sh.

Vladimir Oltean (4):
  selftests: net: tsn_lib: don't overwrite isochron receiver extra args
    with UDS
  selftests: net: tsn_lib: allow running ptp4l on multiple interfaces
  selftests: net: tsn_lib: allow multiple isochron receivers
  selftests: net: tsn_lib: run phc2sys in automatic mode

 .../selftests/drivers/net/ocelot/psfp.sh      |  2 +-
 .../selftests/net/forwarding/tsn_lib.sh       | 52 ++++++++++++-------
 2 files changed, 34 insertions(+), 20 deletions(-)

-- 
2.34.1

