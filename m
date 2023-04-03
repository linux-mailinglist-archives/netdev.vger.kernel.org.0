Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF9A6D4296
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjDCKxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbjDCKxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:53:13 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2060.outbound.protection.outlook.com [40.107.22.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B9310254
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 03:53:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GN+DaKnZAR0Xi3Tr9Dn4w5A4oQo7CI+3jeClnBHaZu4h1SGfZs6s5meJxsIRibOK36lEQwReXgakLgypBdGLgY3odjYU1K7ONRATYaDRe62qvCLNeJhKtwG2dIVs4hP//q1k0p+I5MDJH6KYiCHGdP2KhVuJmVPoMfdUJUDK65AAlhES+CBnBPLXDtg8ZZNnLnbwW2gj1MBUYNCATW+Z58/l60BXCKa52VjXtiaxzk5EvrOUWyFTFrhVX7wtciNGeOhk+qGo0NGbbnyMygrn0XKCpibaaP9vn99DlZN8qDt/BOrfsmdaeFTs3ARSRsjqz6mfUPSRE9xEQ+SAWU12Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yWv2FeA1huTjvL9rXv9TEe75NzMKbwejjyh20YxAQV0=;
 b=hJA44PyHUR+6jIWApVx9oHH8ovl8gIY1sQcWrdsZYR3g0VXnSV9foVu8OxbAQ1U4/2xQHIAFkzTjfCaqgxPQjCOmq7MorlihhSELpw4DXHTTzUA69TnKHMxli3L7gH3INIrC8JIPhjh25zPGn4vEsX68c5IXPWk7y8rm12s8jqKuTdiGsHtW7Zi0scynlQz5Z2vQ1Qi9sM1remUffJ9TIYB6RU+Qh/H+Xujeo1ZuYWEaEQVzKyK8zeWj7KoMQ5hZbe/wFkaqgbD76nNOzgNepdLtvxj6t7Q1MPOvtAL99JqgCZObAxZ3rrMACJTwflnbavu+yyrjDW9+CuASXxgFiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWv2FeA1huTjvL9rXv9TEe75NzMKbwejjyh20YxAQV0=;
 b=NFgaP9CRqzaTcZbBoiArVmCdgXAYMqKfSNjDKmYg2amxgjGws+ogRTSFV2tDOwywlBHOpSgd86zMKtAbkiiNTgiHGefxu7e4TUlf2rL0qXN+wefkLNHHOeJ2eRoesANIN5NNMMdJNpGYxRA7g0GL6A4Gnbabn3eFAqZva0pVnB8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB8479.eurprd04.prod.outlook.com (2603:10a6:10:2c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 10:53:03 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:53:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 0/9] Add tc-mqprio and tc-taprio support for preemptible traffic classes
Date:   Mon,  3 Apr 2023 13:52:36 +0300
Message-Id: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::16)
 To AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: 33fa808d-bd2a-4066-e516-08db343198fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SVnsD+NeGnLqRyZSVxvC5rrTdN+iQBLHsedAaRMGbyKf721vGtZrh6sel/5ne++M2fGKHQ8ymzt9fOMs9uYkifzqGZYixioVluuaBXH9OmBVqjkYIl0Sq3LkWoZg07U1WR5H6uIEmt7/Azx7/b/Z8OJeT0iuFb0XnEafGkY8PZbHXzlPRN/BRdbgiYoWbTLAexqjIzWOEWI2loBtr5PpbWqx/lZSKFF28vo/7fZLvLeQqrkUwIlDPPnmzv31SYf9vGmKL48nyvpTD+FNgJo34RDLK8pBz5ORangjiukgIhlBOB8RXZT8dE8ghgSNUlsNblip42bKvnW1e3asYMgm3AaeZIk5Uyz/pZtMRMrGu7TZ5WDlewksYQvKuxcVBFMu7pAAYMEH9nhypyMzA0OQ2EAmeUYEmeMKR9Gfnwxy8sfciyAPx39Ohyg6UWKCA99iJFqv6L3w3EmEox5Ax/oumA/LQDyLkNvy+eZ2E6aCBUDMZJeZrRsSgPxPvkw8tQhz9GmhX3qY0WWsQxauqaMTn72R8fUBdgn73i3cAcf0j2jgSY9gRehmW9FgTaK6cAHonBWaL7GfFoTNiyS9bAttaA5crsBNvoWQAKSjDTw4wsY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199021)(8676002)(6916009)(66556008)(66476007)(66946007)(54906003)(316002)(478600001)(8936002)(44832011)(41300700001)(5660300002)(38100700002)(38350700002)(4326008)(186003)(83380400001)(2616005)(52116002)(966005)(6486002)(6666004)(1076003)(26005)(6506007)(6512007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T5nncTYl3FBxY4r5hem/wVgmawD8OyvPRatFFVInkeD967tNXMMB68O2bqUz?=
 =?us-ascii?Q?1gS96T/2ad7+JIzuLIJzbgDcUCG3HGeuVrPd78iSa+aNoSoedJGyE6ucFbmn?=
 =?us-ascii?Q?HNPbv5//BPltmt3CSMAzkAL0w+9VVBIqXt6rCVtMduaFnjuYdIWbqlaz3DsN?=
 =?us-ascii?Q?fjIErdp+wDFxu0rqhXzxt1f1lWAcoj4ds0w7SHx2YFhi2dYdfb+spSRMAZsG?=
 =?us-ascii?Q?zSXNT7e3Yj6eJmI1bwlZVxEK5EtaHQFWueazbxbVKzOzCFutGg8AU7UBKbEL?=
 =?us-ascii?Q?YCPMfAGT5otKjTwyPmlKaKqO4LHmP/pByfwzvLa2bA7/xQiSmpFB4iCuhpva?=
 =?us-ascii?Q?ejU3k0G5f5PVKpV8wC6CxA2xcTNePu5jOOpfORJignYUgZrXNS8fL/vouxI6?=
 =?us-ascii?Q?Fp/VfHPnags5B0vwjtYEmzM2Yxf9yvritFoYHu56g8XBekf0SLKV4SuQ5ZrH?=
 =?us-ascii?Q?NaO25vZMGx8hhG0q3eRbycAIDBXNjgr9ExW6z2jM8yxgnYm01K8aE7vBMO2V?=
 =?us-ascii?Q?5+JgepiQYt9WugEvLB+zwpgy4MAKD7fo1usTo9Wg0oHCHvQsW4X9UZ0H6JGr?=
 =?us-ascii?Q?/3CSXkodOSfRh5izk8X3vTP055c2rXT2g1rG4qETy4KFzIbZ2MZllKLflV/c?=
 =?us-ascii?Q?q5Z/a4aKzgHKu5cxEgmJOgTKKdKdNL7/Xwomy70NM6TEohVQDwVb0BzVQ6tP?=
 =?us-ascii?Q?Aj7Wf4htg3hAw+Yf9rcefx9GoORcXOWLSi0vum9JtpAwB06Ftgjr9+guyNr0?=
 =?us-ascii?Q?laqPwxm+seeBiqYrCyj1Q1f2nCZxFhVaqJjaaFXvtOI4crF0EEZrSk4K9eaG?=
 =?us-ascii?Q?W5Zg/w/mbctKTfkcxn2ViNX1vfAJP/qvzKssi6TJRrcy3jiOc9djsqKJIfat?=
 =?us-ascii?Q?dJWcv9JARo9lwSMaI2hazhuoXxh9zgloz9NbeIwr0oZiDDUuc2Q+w8Lw8INa?=
 =?us-ascii?Q?Yhjf/Sjo85d1IakGYzEfYUgY9SFCKUKdhakFpZudgN1We3/y5nUfY/LU1/bf?=
 =?us-ascii?Q?mZVvSzM4m3PUAeM5jeNg91LASOTCJeu/SE8ojtLz/I83by8v1jLDd65VrRLL?=
 =?us-ascii?Q?ciwJgbm9w6YzwzD/hnS1hCgem59WYapngWWcbdRq/+s6Nnd1Q3cMnYj/WcaV?=
 =?us-ascii?Q?15mLqQ9uutGBWEuJQe3qHZcp/K3Kmzy9eilU7pgZOqdU/fsKEehlR1PmxUOY?=
 =?us-ascii?Q?iv3/2VXWw4cnPokiPsMWHsHCJUj4N/JgTpbRtLVdmITrueV5bmoYjkox5v71?=
 =?us-ascii?Q?95m+wJVYxeVGeJNGNoqq2UtGk6mWpyFYmDcILFg2hJg3zpT8I1Pm4t0TyoHR?=
 =?us-ascii?Q?6SFt1Znw7uemfcBKcv8QmCcsQmFEShxAeF3UOWJa045yisgb3Qxq8h70SmoA?=
 =?us-ascii?Q?XMg2/5kpWRU5gccTTtDBoRLaMaKBwnbPYE5Ri5z4qJ5YdxHZInwtE7YWapHD?=
 =?us-ascii?Q?Yb5oF5KfaeZSjOHGnSx0Dn8gCrZ8FHFPPnFKbSFS/H+5pPmgyUCz5nyCsZom?=
 =?us-ascii?Q?5Q78nTJ0REV04C6Svok47vAtgoxnUPS9CLOGeVQkEM5xnVDWLTqqykr4ys+b?=
 =?us-ascii?Q?XYCo0gbTLF1H1Q9tCueqEBwyU9n7NPfQT4Qhi9uxiOKRDuuITWqYohEyz6Wj?=
 =?us-ascii?Q?Jw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33fa808d-bd2a-4066-e516-08db343198fe
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:53:02.9428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4D4rIvQT35acxNc4A0vraBcmTcxkOEFQqrXhYpBZORVettIoMJUhZeHvL+W9B/GUhavHuoz9rtH9lQqTnfyVCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8479
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the iproute2 support for the tc program to make use of the
kernel feature for preemptible traffic classes described here:
https://patchwork.kernel.org/project/netdevbpf/cover/20230403103440.2895683-1-vladimir.oltean@nxp.com/

The state of the man pages prior to this work was a bit unsatisfactory,
so patches 03-07 contain some man page cleanup in tc-taprio(8) and
tc-mqprio(8).

Vladimir Oltean (9):
  uapi: add definitions for preemptible traffic classes in mqprio and
    taprio
  utils: add max() definition
  tc/taprio: add max-sdu to the man page SYNOPSIS section
  tc/taprio: add a size table to the examples from the man page
  tc/mqprio: fix stray ] in man page synopsis
  tc/mqprio: use words in man page to express min_rate/max_rate
    dependency on bw_rlimit
  tc/mqprio: break up synopsis into multiple lines
  tc/mqprio: add support for preemptible traffic classes
  tc/taprio: add support for preemptible traffic classes

 include/uapi/linux/pkt_sched.h | 17 ++++++
 include/utils.h                |  8 +++
 man/man8/tc-mqprio.8           | 92 ++++++++++++++++++++++---------
 man/man8/tc-taprio.8           | 27 ++++++++--
 tc/q_mqprio.c                  | 98 +++++++++++++++++++++++++++++++++
 tc/q_taprio.c                  | 99 +++++++++++++++++++++++++---------
 6 files changed, 289 insertions(+), 52 deletions(-)

-- 
2.34.1

