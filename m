Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516EA6E600B
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjDRLkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjDRLkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:40:10 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2052.outbound.protection.outlook.com [40.107.15.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEE99D
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:40:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9Zmfv5CzfXqi5YD4ci5NvkxSBW0mr4AHo2tEEMkEiz4QvMG6wdJ1cRpJopuuEfrA37tZWqfDrktwWrerV+9dRCJ6mCMPXNAzA8e2GWsc+da3Gqc9RCe0N6NOJ5JLouqJn26qtC/+QQST+wLqxqcDbhigXbiHotWNqMMsjAYXYJcxlq9IYEkJf1/VXSOx6q1hrdztGpNHcqqmcKBlif27ku0ygIp47PAUqbzzASr7ziqtIbVpoVQijgWGeNPVdGgb4OjV3D8irqWrr4C7RTiUeWe87gwyh3C2a1NVWfyARZwapPgI2AmWhcbjOnRZOEYoq2T5IRqudjk0t1VSR7D1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvpfJTH5Gc6Hm8f/60f47S/gOjtRqSHkdpmPMQ2DgH0=;
 b=LS9vchPvGi3ispwmZtjX2NoSeUy8yGMA43hT2C8deWITAbWwSraJhTZVEIHzuHRToJ1tARzStyyEVMDaRXr5yv2PF8VL/OHL8UxugRFrox2at1UNvjWJyD2Z0K/e7W7exHfaMtJ+sNAwMAsXwYqRmKVAzQbtWeldfjhUOKk5Gf6W87qDP6aZElM2ODz/zYZy+Z3PcodiAKa3diKA0IXOJcbayKjxgKYk6KWwuAvLEGq9ouGgDenkCZ7NvjZkVxc1E4HTXVNIzSCWAIXVZuN2osEbkUQvZuXMHN5z9cgHQZzQijqhoVcJYCE7itPql7D9ff4drTJMD0rMfMHkYNJfVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvpfJTH5Gc6Hm8f/60f47S/gOjtRqSHkdpmPMQ2DgH0=;
 b=LvlicDMVOoiRV15tiT+zEaVs3HzEUYZcaGfElTbIu8HIlSjG7DVlnedEnZQd3LNH3qF8qTrMOGXOUsjbpeA+Z/f7RGY4R5qsbFOb/Wp0vIRrMngY0333b3uMdcRap0oBhiyrL8v5kuH4f2AMuJUyYLd8lK2Tw+SYWkeOyzQ6K3E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB7824.eurprd04.prod.outlook.com (2603:10a6:102:cd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:40:06 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:40:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 00/10] Add tc-mqprio and tc-taprio support for preemptible traffic classes
Date:   Tue, 18 Apr 2023 14:39:43 +0300
Message-Id: <20230418113953.818831-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0003.eurprd05.prod.outlook.com
 (2603:10a6:800:92::13) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB7824:EE_
X-MS-Office365-Filtering-Correlation-Id: 40a59d47-ffc9-4bf3-8d7c-08db4001a7f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HPP5uSSy54/IGmjr3VFH4bK1UgE4JOxgmycb70HSS9oa1OTje391b2c7H5c0fstoZ+V3z7mUbwUUetuQzecRmv3sw0t2oXawyx+jb4XuNyL9hjLQ/scpUDVLKmX/MY/F9vLQefF4m3MWKRfmgAGEZyLK4gqPa1oRWOBcNId+gMi1JXunFS/FPwmnIHBRvrXz9L0eonnKtEIwouCO7jD4xnCeX5+cyTmoLMch4/bhpzk7O70gf6KMAkus9v8VBSwpZewqQf/6csNxRRu4tsmRNyJzf5Axtfn6agByesb+WL//u6HjnwWDufcEptpBLQ5/3TmvF2QjsLykqwIFurRFIMpx1/wzsIWKa3NR+DB0SQGYtXOP9YeBnN1sxPuHW922hmKKcbksslzcdf12YuYjyw5gFEI9CJqNEtExjouZyYRnIo0PgdKFEdEskol3w7sWBIYL56OUW7A6Z2vKAurgMUl+fWMb7PJmASrCmNPOeKP5w9tAS6jzsacc7mp4XLGZWQkBh54dQAzOHxSdSEE2ZBuiHFzAzm0p2dE21hL9ZfpErpeTz1DP8fBia8dYTdWHC1/GgPzvOOrml0JV6lniQ+s4DV5ba8mji/s1VgvRyB0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199021)(66899021)(6916009)(4326008)(316002)(54906003)(966005)(66946007)(66556008)(66476007)(186003)(6506007)(6512007)(1076003)(26005)(38350700002)(38100700002)(2616005)(83380400001)(5660300002)(41300700001)(8676002)(478600001)(52116002)(6486002)(6666004)(8936002)(36756003)(86362001)(2906002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bnGJ47kJE9WxjGcEKPyhvNo65Gs4R8KGPURrGLiOnEVUre4jXdN+Nn7yvi30?=
 =?us-ascii?Q?HJW3Ocvn+9O7YAFGDfjYNyb75UhBnoY0EFLhkoYlZG0qqQWjaHi3hsDRyuvq?=
 =?us-ascii?Q?HiH643+6cwtZ2c1gliljQvvm9KKumltxN2HXAGXimy4brm03ii2EQ1vcqb6c?=
 =?us-ascii?Q?grjschMlOAVXZSuyTlkX9JbaDec3MmuXWTFH1b43RkEfL9JbuioCCHaPr2Aw?=
 =?us-ascii?Q?DMAtRmw/+hTDPd17wMgPJClBJh3L/Ki1ha7/SARvE3KybubtxjJl3sgRwl8f?=
 =?us-ascii?Q?lDnf+kG13nR3Ow+lJQLuC6SB9syrN2r9l4I2CYUmiynv/eWwzvNzhOqtYoJh?=
 =?us-ascii?Q?xrv0ExNXCEkjddRSVzjuQ2q4TQTZ3JNxppSsuuoMPuKhRZrUzCnpPIfWItgS?=
 =?us-ascii?Q?eAvufjb2zblXDvw/RPVqz6Ve5KUpEXSI2pkCJXhX5gbVqFvk6jd2VPuJGe9Y?=
 =?us-ascii?Q?bmLjtwz+pd3QhjDPUwA/lHUqibTYm5gdFLWm2d5w93dRz6OPcstgdO6NQnAR?=
 =?us-ascii?Q?0WTA7XwWREiPA36B+Pu/WIiv3GIx27QqMHLD9/DSBIl0Xfl5Z+hzml02jcvY?=
 =?us-ascii?Q?JDgQlfepGfAu1qQ/8nmDJUcDy2hnDWirR4TUoB5+cnhNfT16JZLn76BtLC2S?=
 =?us-ascii?Q?9/PvVc/ziOh7lBhhIiVtFUqcN4+zd5YCPK9tf/T47pHajSGE3OpvQlrxUwrN?=
 =?us-ascii?Q?9WZPOYDya+RilY5NkoybO/UKLw06QuaSzZnFpN4uVP9qyELCoFUIi1oSknvL?=
 =?us-ascii?Q?FeHhXI6wROvnLWH9qEu0vs5KEF+uun0CNeHmTX9zwmlY2l1LIW/x8Vcu6U4b?=
 =?us-ascii?Q?YGD3GSpzQXTcozotEr4J2kYCygucQKqg+OXZManQ7ealySdS5HgNEkIGeduf?=
 =?us-ascii?Q?a5P7iYAbkPp+Oe9DTgrxM3ppoPHENKZ0iQ9rwt6xF0ivVdexK8jLSdHEZyD5?=
 =?us-ascii?Q?YxEoAhZvQVFJ1kZIdZhq+1D2mSeBSyjj8Bb29S63Q9FY35FzmMV7hWj3FyIe?=
 =?us-ascii?Q?+Fpa2alBXBXHEFk/RBZ50h5fQZ0sS1a/HKDKf579pSkKzYHwTbfh6kMuTSyQ?=
 =?us-ascii?Q?axGioZZC8m85BZyibpFrkUbUJsWpNR8VPnvEQaWD7S+QYtHQzdTTG2AVcjNw?=
 =?us-ascii?Q?mKCRl3ztKLiNLouiYnd5qkCXM1AwBMWBbI2kEMWxxCyj9rffAuOLJys1qt/n?=
 =?us-ascii?Q?+jt74Mo6yPU+I9Ts01v1BGp69AaJIXJYMXHuH38FR2B0QWFowUS1qbcA/c0K?=
 =?us-ascii?Q?Tg1g90As/+5aSCfrw3d5ccpjy/X5x3NA4IdzeLpg4bCSqmOMucvHCV4onUra?=
 =?us-ascii?Q?E3oKbEYmSdw3hUmYV5I7SqkswVM2xwx+JU3iI2ktfvLHIn5LFt6HnvfjCtQT?=
 =?us-ascii?Q?/S8scyZeei3xLwr9OWNtUx2tLEZMBmDmNcZ+UbsUUjjl8bzVSFoD/D9gu444?=
 =?us-ascii?Q?9qze7dPhT4uPHbECNwdbPgiARxkAleGflx4HF1ChGG8e2Npv3aXCNNMatiAa?=
 =?us-ascii?Q?8vfzEXPTuCDrGLfZlcD2WubOuuG4KGGGHUQQtaTIrg8CupBzxTs61a0x+6/m?=
 =?us-ascii?Q?+/GX3bQnvefoxECXizPOWhW/DY/z1vwudVEgi2Mmu1QmFpMiwi6mDWjK822k?=
 =?us-ascii?Q?3w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a59d47-ffc9-4bf3-8d7c-08db4001a7f3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:40:06.1664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p311CeG0toMCkl9vm8Xa1B519tiCIqyOtLVhq0Qm25gUNTR+XwRxgC5/74CV+Q0HBb79nNN9sXVGwbXvJCF7iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7824
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the iproute2 support for the tc program to make use of the
kernel features added in commit f7d29571ab0a ("Merge branch
'add-kernel-tc-mqprio-and-tc-taprio-support-for-preemptible-traffic-classes'").

The state of the man pages prior to this work was a bit unsatisfactory,
so patches 03-07 contain some man page cleanup in tc-taprio(8) and
tc-mqprio(8).

I don't know exactly what's the deal with syncing the main branch
between iproute2.git and iproute2-next.git. This patch set applies on
top of today's iproute2-next.git main branch, *merged* with today's
iproute2.git main branch. If I had formatted it directly on
iproute2-next, patch 04 would have conflicted with iproute2 change
ce4068f22db4 ("man: tc-mqprio: extend prio-tc-queue mapping with
examples"). I would recommend merging the 2 trees before applying this
series to iproute2-next.

It may be desirable for patches 01-06 to go to iproute2.git, so I've
sorted those to be first, in order to make that possible.

I also dared to sync the kernel headers and provide a commit (07/10) in
the same form as David Ahern does it. The automated script was:

  #!/bin/bash

  UAPI_FOLDER=include/uapi/
  # Built with "make -j 8 headers_install O=headers"
  KERNEL_HEADERS=/opt/net-next/headers/usr/include

  for file in $(find ${UAPI_FOLDER} -type f); do
  	filename="${file##$UAPI_FOLDER}"
  	rsync -avr "$KERNEL_HEADERS/$filename" "$file"
  done

FWIW, this kernel patch depends on frame preemption being available in
iproute2:
https://lore.kernel.org/netdev/20230418111459.811553-1-vladimir.oltean@nxp.com/

Vladimir Oltean (10):
  tc/taprio: add max-sdu to the man page SYNOPSIS section
  tc/taprio: add a size table to the examples from the man page
  tc/mqprio: fix stray ] in man page synopsis
  tc/mqprio: use words in man page to express min_rate/max_rate
    dependency on bw_rlimit
  tc/mqprio: break up synopsis into multiple lines
  tc/taprio: break up help text into multiple lines
  Update kernel headers
  utils: add max() definition
  tc/mqprio: add support for preemptible traffic classes
  tc/taprio: add support for preemptible traffic classes

 include/uapi/linux/bpf.h       |  61 +++++++++++++++----
 include/uapi/linux/pkt_sched.h |  17 ++++++
 include/utils.h                |   8 +++
 man/man8/tc-mqprio.8           |  92 ++++++++++++++++++++--------
 man/man8/tc-taprio.8           |  27 +++++++--
 tc/q_mqprio.c                  |  99 ++++++++++++++++++++++++++++++
 tc/q_taprio.c                  | 108 ++++++++++++++++++++++++---------
 7 files changed, 345 insertions(+), 67 deletions(-)

-- 
2.34.1

