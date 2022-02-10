Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE184B0452
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 05:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbiBJEPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 23:15:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiBJEPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 23:15:35 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2098.outbound.protection.outlook.com [40.107.93.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990035587;
        Wed,  9 Feb 2022 20:15:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSbv8tVq4j9ZCWqUfMPp34NV4ii5/W8c6QAfsC/1U4EgJ5m2J0kvPWgtRHW6/VfnBqaYGgEPAL6XFJZ1lEvgfrSvOxF5wyt7EjLwA6y9FvHyYUUEPnq7PfQRz5OwXRsDhi+HzVEnd4uwolZ38i/DUccyAk7Vev87d2rHyQ8qlKE+US5yWD1Nqnt9igqsuH97smP79InE5yWpmKJ6b05uMopbtrkCKlkiIbY6tDb2929ZzLwIHA75Jk0NUkE1RE5+a9fvZkiube/9fvMfWUfV+lO/aoqlQpc3mmDlUdoyn4FsM8LZC2XG9zHDWNCdUOdwvvCTt8Z2R7z/blr+ENd17w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jt0Hg0AzZOhrgkSMhXnLIvDgiYWp9K4rItOxqLQvRMk=;
 b=dUglhevQ3hxIKCCQXj108aBYwQhae/vp6Qd3C4TJ9osLhzb0/5NJ4odrLcZ9ky2DcSnkRMfIPCxuACrbe/E2JKYOoyQkSW29wT8aK6syrj3s/jcNqA7nITlxGqBBkrPdg888hGw4tC8fW0yER3XXGuLrzc6vGbC3hczVw7YF9RfDLa5hPbZ0hxOo737Mp6WJh+syoIa/mRsvWbCKFHsc+bSiZpswacogpP0TpqKdof2r9z7NZpdCeQkR5Q86m1aMfLwNl24DI/JuH6+rjr/zjz1haNgmB8DGcmOXP8k+gvbFMPe56v425ULaVslC9uZXnxraVbrGnzFk/d5Pl6G2fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jt0Hg0AzZOhrgkSMhXnLIvDgiYWp9K4rItOxqLQvRMk=;
 b=e506ZH/+if125gp59tNLJYkBf2xj3XHlZi1zdemgndsgMS88VYxTExhOI8rlgmYv42p4/ffPSPoVJIvrQ8ZmSvEJf9Wbh5+5s8qUrPaM2BNRB/uAopxpbloRp80IHA/Bmj/zcufuAUtaYFpPYg/8pK1zzzSGNptLdHsWZvOAY/Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN7PR10MB2564.namprd10.prod.outlook.com (2603:10b6:406:c7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 04:15:33 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::bcda:8606:7c7a:b1d4]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::bcda:8606:7c7a:b1d4%3]) with mapi id 15.20.4951.017; Thu, 10 Feb 2022
 04:15:33 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v6 net-next 0/5] use bulk reads for ocelot statistics
Date:   Wed,  9 Feb 2022 20:13:40 -0800
Message-Id: <20220210041345.321216-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:303:6b::29) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 182bb424-70ae-46de-c9ab-08d9ec4bfb0c
X-MS-TrafficTypeDiagnostic: BN7PR10MB2564:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB25640066EF88FFC814674CCBA42F9@BN7PR10MB2564.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:346;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fXmT32xdnW6PPec078Vwx/1hjSh+W/LjRfPAv7z4T878hfSJiEVhr1Knylnco/ww5ltC6lTZqshSGzlPmpyvMAEQGKy78C1fZeleacSkr6Bj6dgvEQrvRZjg6ZOGr7FZc4a5OPYY9LxUf2SqsoCOb6nSi1W5oDB+rsofJfrBr4COohhR/O0iaOad+wBUTqe1pTeaKWZymGaF1yzk/SJzgPUUQRb39bqz1rPgkwI4l8SpSUp+hnjhL87AsIIfn5aNe37ku1VS3q1ZiKrD8wWdWQ6oycbIjcsF84jtErTre4eYgOMwyHAmBnDJAg+wqiyGWtooiKUTiCI/s/YrpadeWPTYrA/g+mCwk39Tz/9HqhlsG2d0WJTmos30r2kq/PUQmLe3EWP+JELlJmbg0+Y58DFFcdrqOz398WYBQG4ntyPrqKFeKKsIWQbrnuEN/BvE4wFh3ltuLI/jIweUUrJfmHIcjZGc+afIyZgkNba1/EJ4a52jHE2xYg4nM07F/Z4GBHnw5iUL0d9tTpZXiTN9Rx+yPX2IIcuGrAASbEbvsLsugM53SLqcRtlkwDifwL1HbhHqv5rJm5CEX30TKj4ap1bRXjiedR024dNRDZLXz6TMNz/ZFpHj7+8bNAZ1QmlviszIcal31LGU4drSHoOZ4K3SnJuZ8PTgPMnUXEDcIwrTJR4xtnKd584f32khOJKE3MnDBQlq76A6R4h6cV47CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(42606007)(366004)(39830400003)(396003)(376002)(136003)(316002)(66946007)(86362001)(508600001)(8676002)(38350700002)(8936002)(4326008)(38100700002)(2616005)(54906003)(66476007)(66556008)(5660300002)(26005)(44832011)(6486002)(6512007)(2906002)(6506007)(6666004)(83380400001)(36756003)(52116002)(186003)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?subSYdz6pWEcPbmGsXqhDp6Q0/4x+gvsKBAociDTFpCy/PltlY+at6ZM1EVc?=
 =?us-ascii?Q?Yxf+K8inR2XQFQuQx7L8eLG17UqRxoJDGRR1Ood4BUaScFOr6XUEqThmlxKv?=
 =?us-ascii?Q?OO/QKZhYwfWFtYFtgJgb6DrTa5sMz3wXD4hpPSA7Rwipnu2LywvDwKmtiVCV?=
 =?us-ascii?Q?V4lPdDGT3iGrov9AMLJO/w623t3glEQg4cUQaA1BbQRR2ERv7QVQkTl+3m7z?=
 =?us-ascii?Q?1Yux13I3RDG8XBfrcO1yRruH7YxbiMHgfvh5HZY60g9rph1TMtvCUTOGEABL?=
 =?us-ascii?Q?IVtTB+D153nhnWWPvoCfWwSUP7JV2opKb/nYfTiRdg14JTDf3e4AcbHz6U+W?=
 =?us-ascii?Q?wnLKMUv3eR+IFYq+OOUfQJJCRH6XEffOqXL6zn1RkglxkeGsdkUI7fyDbZOk?=
 =?us-ascii?Q?Ey5K3V9B9vP+HxB+zE1SUV/SnYBbms62IaXrPD1UV3UFCgF2INE7Dy/YiFbf?=
 =?us-ascii?Q?QqxBhjWBdu43oDLEtMzl24R+Stw4UcXgXWo+Q4ypg5NZFRd5fAnnPQZAj/qY?=
 =?us-ascii?Q?Hlp5n+4Fcke2KjaxJSo/l1Fdr8tWyiOXLNQWU1817OkO2xY1tb0h8DqizcJg?=
 =?us-ascii?Q?8+vX7rYnwDu+r5YDqPH+aDV8T2v9rU74/reTjNEVBIPSujSrhRDcB6vIRaPB?=
 =?us-ascii?Q?Jy6QaDXG+01vvfNWlnX0ExdZAY/X9T1OLdQ6aw7Dj4/YrxgWFbPiq7q1JiB/?=
 =?us-ascii?Q?0r7VQCHj9uwGqZEXyXTWRdV92o7DQco/mY2YVq/USkdY6LMSQg0W48mXActo?=
 =?us-ascii?Q?b8x47opJBwVNHgxTtdI6x8evsyRJNQ9RtaNxQSRBHzcsMauatvpDP1xfE1UR?=
 =?us-ascii?Q?7/XDladTp2w7v7mlzTa5f1rbYIQnZ7nk/B6AKmoZQY1XLzxlHFDjRutOSA9d?=
 =?us-ascii?Q?0Y83XTOd2WcXvtrH4P+TjiOFFheAm6UfZjUen6aF+vrgzvdp5gG2SG/wYEY7?=
 =?us-ascii?Q?krkUUsAvSdSGj3g6mZ+YHFB/AaPOI6fym0W+TwT6evWSlq8va6Byn/y2ZizD?=
 =?us-ascii?Q?wfTRApvdyLyNAOT6uAjG2lqY2SLyDinxa7KK0Wh8NZ1gLzm54evYRmlIVbsr?=
 =?us-ascii?Q?QNyJD38qYlh52rxwT8okaLesInrv2hORbg5D/hiWHrnTcPLGGFO+8HeVwPze?=
 =?us-ascii?Q?BzMQdtei5yY16QKQXGLVd39/XATQRhbJOe24tA15JaE09PvDvaJS7amb0ErC?=
 =?us-ascii?Q?jsQekzoTNFqgGvWT3avBqfhfevChD4MqacI+8eeNqwI+NzyyDpxd2NAVFsGf?=
 =?us-ascii?Q?0WjA7/boxmWflg9L5K8s+QQnC0ElslVScm8B4gQ2AtzRBx0ERr/AnbzubvyV?=
 =?us-ascii?Q?NFdjfkt1RPR1khyddC+U2YdgPpPRM9bTbnlD8vQWw+BpERsUxQP91qjq2AMI?=
 =?us-ascii?Q?TJJ6TP8jO/1yvwp8ruh4U0vplv2AULX1AXPefH3PWw+sf6o7mKCO6m6vQsZb?=
 =?us-ascii?Q?Gbn5Un1gdlto1DVn4D1G7kEFf2KqgDVBlNNCCJgwVDnnDbrkN0+Ye8zdCHl+?=
 =?us-ascii?Q?H9Tt2NTRfXpZ3Sph57lhP35QFBynxCoV6FgKZtVvAoxViFHwMcAqbrgCW+k+?=
 =?us-ascii?Q?JD6KqxodoHKxVW1b/hjcHtm9I7ItDuovTtcuxJ496zooPkC00ybfNJ3EEIhb?=
 =?us-ascii?Q?zVx1xDrmw2bN4bGDyw7LoZ1rnvuBG3lDp0SNjo9+7bbXImbwXReFI5xFE1il?=
 =?us-ascii?Q?p0nFgw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 182bb424-70ae-46de-c9ab-08d9ec4bfb0c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 04:15:33.2163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7u82d10ctp8CBucj3kQ8W0vH8QfHBdQ9eLJHlmHrG2L3cJ+4J+XuseN24RaTFnezyw9OUJvBVZZX38s4Id8J3fYLtiGFMFl6b2XpT87OQvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2564
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot loops over memory regions to gather stats on different ports.
These regions are mostly continuous, and are ordered. This patch set
uses that information to break the stats reads into regions that can get
read in bulk.

The motiviation is for general cleanup, but also for SPI. Performing two
back-to-back reads on a SPI bus require toggling the CS line, holding,
re-toggling the CS line, sending 3 address bytes, sending N padding
bytes, then actually performing the read. Bulk reads could reduce almost
all of that overhead, but require that the reads are performed via
regmap_bulk_read.

Verified with eth0 hooked up to the CPU port:
# ethtool -S eth0 | grep -v ": 0"
NIC statistics:
     Good Rx Frames: 8352
     Rx Octets: 10972241
     Good Tx Frames: 1674
     Tx Octets: 146253
     Rx + Tx 65-127 Octet Frames: 2565
     Rx + Tx 128-255 Octet Frames: 93
     Rx + Tx 256-511 Octet Frames: 158
     Rx + Tx 512-1023 Octet Frames: 271
     Rx + Tx 1024-Up Octet Frames: 6939
     Net Octets: 11118494
     Rx DMA chan 0: head_enqueue: 1
     Rx DMA chan 0: tail_enqueue: 8479
     Rx DMA chan 0: busy_dequeue: 7614
     Rx DMA chan 0: good_dequeue: 8352
     Tx DMA chan 0: head_enqueue: 1335
     Tx DMA chan 0: tail_enqueue: 339
     Tx DMA chan 0: misqueued: 339
     Tx DMA chan 0: empty_dequeue: 1335
     Tx DMA chan 0: good_dequeue: 1674
     p00_rx_octets: 146253
     p00_rx_unicast: 1674
     p00_rx_frames_65_to_127_octets: 1666
     p00_rx_frames_128_to_255_octets: 7
     p00_rx_frames_over_1526_octets: 1
     p00_tx_octets: 10972241
     p00_tx_unicast: 8352
     p00_tx_frames_65_to_127_octets: 899
     p00_tx_frames_128_255_octets: 86
     p00_tx_frames_256_511_octets: 158
     p00_tx_frames_512_1023_octets: 271
     p00_tx_frames_1024_1526_octets: 222
     p00_tx_frames_over_1526_octets: 6716
     p00_tx_green_prio_0: 8352


And with swp2 connected to swp3 with STP enabled:
# ethtool -S swp2 | grep -v ": 0"
NIC statistics:
     tx_packets: 397
     tx_bytes: 20634
     rx_packets: 1
     rx_bytes: 46
     rx_octets: 64
     rx_multicast: 1
     rx_frames_below_65_octets: 1
     rx_classified_drops: 1
     tx_octets: 46586
     tx_multicast: 404
     tx_broadcast: 303
     tx_frames_below_65_octets: 397
     tx_frames_65_to_127_octets: 306
     tx_frames_128_255_octets: 4
     tx_green_prio_0: 311
     tx_green_prio_7: 396
# ethtool -S swp3 | grep -v ": 0"
NIC statistics:
     tx_packets: 1
     tx_bytes: 52
     rx_packets: 711
     rx_bytes: 34050
     rx_octets: 46848
     rx_multicast: 406
     rx_broadcast: 305
     rx_frames_below_65_octets: 399
     rx_frames_65_to_127_octets: 308
     rx_frames_128_to_255_octets: 4
     rx_classified_drops: 398
     rx_green_prio_0: 313
     tx_octets: 64
     tx_multicast: 1
     tx_frames_below_65_octets: 1
     tx_green_prio_7: 1


v1 > v2: reword commit messages
v2 > v3: correctly mark this for net-next when sending
v3 > v4: calloc array instead of zalloc per review
v4 > v5:
    Apply CR suggestions for whitespace
    Fix calloc / zalloc mixup
    Properly destroy workqueues
    Add third commit to split long macros
v5 > v6:
    Fix functionality - v5 was improperly tested
    Add bugfix for ethtool mutex lock
    Remove unnecessary ethtool stats reads


Colin Foster (5):
  net: mscc: ocelot: fix mutex lock error during ethtool stats read
  net: mscc: ocelot: remove unnecessary stat reading from ethtool
  net: ocelot: align macros for consistency
  net: mscc: ocelot: add ability to perform bulk reads
  net: mscc: ocelot: use bulk reads for stats

 drivers/net/ethernet/mscc/ocelot.c    | 97 +++++++++++++++++++++------
 drivers/net/ethernet/mscc/ocelot_io.c | 13 ++++
 include/soc/mscc/ocelot.h             | 57 +++++++++++-----
 3 files changed, 132 insertions(+), 35 deletions(-)

-- 
2.25.1

