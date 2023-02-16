Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22D769A233
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjBPXVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBPXVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:21:45 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2046.outbound.protection.outlook.com [40.107.104.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF88474DA;
        Thu, 16 Feb 2023 15:21:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RsLJOcM/1k5NbtdJ0RbsBDO0U/KEUYr7ZJKZYom/WxPFk9XbFIhnRJHuZLR1iUaGCx6O2aZ/fBjFFnxVgBX0Nbn+L4u/FAjVKvm5aMHDj2j/W1tycHXWHgdOI+ADYq9cB4jpa2tOAyDtwEScWLjUF47MVSrR4B/lkZEeCvpOs82p//+uTCvAx2PN/Y+Q+8P2LvZ0OuppinpgVZM7JJ1NMflt4AvNuAgV8xk95KnJI4Ao5SvOcjs6SY4IcrjwvrTyhyPm6P3/oDIrWgRB9FwDupsUuZaG1bnlfreWmIqkJfx7JA4DP4cpKtmgaNAfRSaGqFVdG+gLz0rGl+nNUkHryQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qtUY4vbwbx9PSmMlkrh0xLObLuYtE7R/er+iSSTFwqE=;
 b=Y2j6Ffmga09ac+QSt5K+CI37+6Py1Uto2RE0+7FCtt+ZevnQNRecusWcV4JVN2Ql1Uz2P8dNjouNOO7CMYprLZSymf9/SP0LJIN8vlu7m5GotVKBxM5NDCVrvLZtk2ShFQa9LITs+gg5LHkf1zATQyxNWFVjTzmPh1jrve2b/LaE0uvl+Os6YfBGZhtV1C6LO3B44GYuCXR/z/cyq67KSwABT9I7fb6NIRXiglEw3u1FTx+1B9XrXmPkpDbNL5cqmYvQCfvwlRhGMGjYcCbg4pJ2uYotYMf7MHUh6RSDUVmOhMidg8Amr45JI8B1KyWCnldSN+wp2getLnl7Ze4nQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtUY4vbwbx9PSmMlkrh0xLObLuYtE7R/er+iSSTFwqE=;
 b=f8xlaZ7bGIN4t0gaXxfEycuQrjeDXUicbdkTz+CQnRKVp7NPycew6Tc2dLIoSgSa63qm37wVzFEKM+/9oQdlGsogtTbW72lnbReRzNhq/PLQ3nJix6gNDcXCKrCL6ngnIP81XRMDGYSCaadQIBavMOWo0FbQ/yDj6ZQQa5fvnJ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7436.eurprd04.prod.outlook.com (2603:10a6:102:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 23:21:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 23:21:41 +0000
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
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/12] Add tc-mqprio and tc-taprio support for preemptible traffic classes
Date:   Fri, 17 Feb 2023 01:21:14 +0200
Message-Id: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 63493869-a5d9-4907-3c2c-08db10748f5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3weF1LUhTf7TRZImVNnND1v/8WGSjYzcot6v5T9EDtiaqFswZPMoS3iwqSpbWazV0z9MhbvW/9WS+vBM/Cldwuo4qeGv5/9PksLI3NAFFx2MsvDN40G43Z5RvX4mjck8oN390cRFQYo+S3rrIFZSvej0YoMt426xVsuxVzKxJtFui81G7pv/3RoInuZ9x8BynoyJq4AYcVXYhtzhjiGePAsyzF1qmjB/Y3A7YGnfmQq7d0jkE31edOfVV12ewvoetbC3SEhYar5E8XfXADgi5LMjJkO16ixSfIs3q3AzmfLzMe+krHF/Se5rhs8e7gcS7IlKbxqL0goGTJZ9SLe5QQ00XasfwSUfsxbUcQnOIDmmpuWkcPIPerNZYTH2JOkR1qSlY5MAjNXAKXZE3JKJ2g4YXZwZFFuiv1rZm+7dRW9kPTeJjN6THdMDA/x7VsmiSi9/1wrbB2ZA/cLZJxu6EwIOnXtCttIQbahChZCuhgNNQ9Uj0nB/1mgJpGqPYm8AbV/xzGqyI5Q5lRIdjjT5kO12HB4peQgJhenBSvxBrbHH/NI9CagIOoGsEn4ktkNa5FTUA5mVZOss0Nf9lQcw0g+KOO6h5flY5ywoOxdFFk/mz7ESOgWNTTsmYaMdPT+3CfmuClBXqo+PeqA7/4VshKcFwlmpKfwhqYocwdxF8fbSchCpQe2cScLVPDm0MatnJC2+ILjcG2Fmbycgsdp8sE9FeBkmswu6ZVtzHYYDPe0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38100700002)(2906002)(38350700002)(44832011)(7416002)(83380400001)(66476007)(2616005)(966005)(86362001)(478600001)(6916009)(66556008)(36756003)(5660300002)(41300700001)(6506007)(52116002)(6666004)(4326008)(66946007)(6486002)(54906003)(186003)(316002)(8936002)(26005)(6512007)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WOp6uLxxNBaWZWCPLbGVMhn/1yohOgypJBvkUXUylhlMP6x25DV4brqJlfvN?=
 =?us-ascii?Q?3f2BZn+XTmLV6AnuJJQU2Ih56dIixIu+VmKcEQ/qM3/MakqaF9GFsrvwWSEi?=
 =?us-ascii?Q?bfgRhl8ZzDhsOuLflN5u5wyBDiz29bE2ywG5D+UrhgDhd4+F3ZILYH2x2P38?=
 =?us-ascii?Q?4ReMH5enLdNdvaTZ9YMHHlB/dAp5V5qbtPJNWd7+pM7KC+qVvx6QMJtyCYKp?=
 =?us-ascii?Q?sTZGByr+oBNeNsCUD05k5UrHh4xh381sqhehsMG76U6fE6TwlIp0b5NTko+T?=
 =?us-ascii?Q?UFsLK8qUB1vwmgx7jEW8cyUSqk6Apoeetzf8+pRL5PbelXgqgAIkIMzGw/p3?=
 =?us-ascii?Q?xNfHqAOgAuJpc2+olzE63T+X0zPqaxRGoraGQwXiwEQ3FUNBLBdk/M4FjdLP?=
 =?us-ascii?Q?5NvGAX5ifXRTa4MEMKegpSPp3r7JbkaQuNH7N41dNe7G+L8sqjmV7yDjbCRe?=
 =?us-ascii?Q?4yzmj6YKeDnd4RrNb2B//DN36+SczlulRQRYv2SCNOfrfXOezpGRNmUQRp3K?=
 =?us-ascii?Q?f6HkCNnHEii0mkxyIOrjOkUV6DzZh3IENDH31qVpk/yxzAz6sFE9060TFGfi?=
 =?us-ascii?Q?NNjLV4zUlqhUAX6lf0m9LE7XUYlH7BTAYigN1qoyKwV+Yk37Phfv40jNqMZH?=
 =?us-ascii?Q?pCAl9TqTxkweV+DWXiWXxNjmibmb2qO6lfQYCbHvTkkFthhFVmILhXsqDhgx?=
 =?us-ascii?Q?y66zRn2o5iLVvn6GKnFBF286yS92Y5oOVEZV/R7PHBS18ECMkrtSp9bvmYfF?=
 =?us-ascii?Q?mSlaDzIMgMF3oakVJridH87At77oNodOIUrfuC+3S7/yBYfFME9i4vdiRvNz?=
 =?us-ascii?Q?s2A085PMYICElGkS2qBzbUX6CbbCgyKEGB2hlhVd3SZPVoYu6rzWGW66iLkz?=
 =?us-ascii?Q?YHWeQVhqY4+lnhdB0wegGj/zguWmQBz9O/5Mdyc6O5HS+FcaLHIZttCdl2Wj?=
 =?us-ascii?Q?GY1/0akTODJRpjvgXlRn1GH3HuPfvoE6nAXMNZMRs2eOAujmg9p15rkpsnCe?=
 =?us-ascii?Q?xlyje5aVNQ9VL6kGtbLrM5n3q2+8ULHDsqvX4/+dgUOTv1vofnWz8fT40SGQ?=
 =?us-ascii?Q?UobD1MmBZnJkBY9+I4R/MvsvUvr22mTuZE3iFBjfumykTrVO9pIYL46TVzTR?=
 =?us-ascii?Q?2jKs5aWAHNLfGbZ/YEOIl/tCLw3P1T30O3hLf5T4xeSK+DcRhDNHxO4u55Gw?=
 =?us-ascii?Q?0ff0hWPLl6RwYQdozBRQcph55irijVkq1tblI8rL1O99JuPvVCfq/1y7Ehwp?=
 =?us-ascii?Q?4G+tsXK+hBgtgA6Gj6SUxUu3lBY4ZEFyAymMj3OH/tNQWa2TEezEXiE6VY2C?=
 =?us-ascii?Q?U945wq2k8GzUaqY7ecQAQE5XwvalAtW/WFJsHWX7OTOLu1xaQepdVmShRfTQ?=
 =?us-ascii?Q?hD/S4unexZU17rNNWEGlxOi4bLDKGoDLG4E1GDLI98QVRPoBhOUrocNPH/8T?=
 =?us-ascii?Q?zyTI4OBiX4C68LPjZzxCjQooqBtJZ7fUo9d/l5jjNKwzSW0qwJ8m8zLS2Nsh?=
 =?us-ascii?Q?4gjZobdwpijNiGDAnbdxFb8GABIPtDzPTSJbOmHLdgd3W4zBm9IgB+MMpKPn?=
 =?us-ascii?Q?56w9Tc2gnL+45fY/KSrfx/kCwJEznUOq5H7SzE+3TEFj6uMQI8LhhnEVkRQG?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63493869-a5d9-4907-3c2c-08db10748f5d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 23:21:41.3059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 53ETtrItl0q3lr+zpDQ/l0+a0Wm4C6Ts/jDjOoj0ntGD4Jchugt9++qeAdb9Kpz5nbdRo6U4rK4EN/jesZGCKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last RFC in August 2022 contained a proposal for the UAPI of both
TSN standards which together form Frame Preemption (802.1Q and 802.3):
https://patchwork.kernel.org/project/netdevbpf/cover/20220816222920.1952936-1-vladimir.oltean@nxp.com/

It wasn't clear at the time whether the 802.1Q portion of Frame Preemption
should be exposed via the tc qdisc (mqprio, taprio) or via some other
layer (perhaps also ethtool like the 802.3 portion).

So the 802.3 portion got submitted separately and finally was accepted:
https://patchwork.kernel.org/project/netdevbpf/cover/20230119122705.73054-1-vladimir.oltean@nxp.com/

leaving the only remaining question: how do we expose the 802.1Q bits?

This series proposes that we use the Qdisc layer, through separate
(albeit very similar) UAPI in mqprio and taprio, and that both these
Qdiscs pass the information down to the offloading device driver through
the common mqprio offload structure (which taprio also passes).

Implementations are provided for the NXP LS1028A on-board Ethernet
(enetc, felix).

Some patches should have maybe belonged to separate series, leaving here
only patches 09/12 - 12/12, for ease of review. That may be true,
however due to a perceived lack of time to wait for the prerequisite
cleanup to be merged, here they are all together.

Vladimir Oltean (12):
  net: enetc: rename "mqprio" to "qopt"
  net: mscc: ocelot: add support for mqprio offload
  net: dsa: felix: act upon the mqprio qopt in taprio offload
  net: ethtool: fix __ethtool_dev_mm_supported() implementation
  net: ethtool: create and export ethtool_dev_mm_supported()
  net/sched: mqprio: simplify handling of nlattr portion of TCA_OPTIONS
  net/sched: mqprio: add extack to mqprio_parse_nlattr()
  net/sched: mqprio: add an extack message to mqprio_parse_opt()
  net/sched: mqprio: allow per-TC user input of FP adminStatus
  net/sched: taprio: allow per-TC user input of FP adminStatus
  net: mscc: ocelot: add support for preemptible traffic classes
  net: enetc: add support for preemptible traffic classes

 drivers/net/dsa/ocelot/felix_vsc9959.c        |  44 ++++-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  31 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   1 +
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   4 +
 drivers/net/ethernet/mscc/ocelot.c            |  51 +++++
 drivers/net/ethernet/mscc/ocelot.h            |   2 +
 drivers/net/ethernet/mscc/ocelot_mm.c         |  56 ++++++
 include/linux/ethtool_netlink.h               |   6 +
 include/net/pkt_sched.h                       |   1 +
 include/soc/mscc/ocelot.h                     |   6 +
 include/uapi/linux/pkt_sched.h                |  17 ++
 net/ethtool/mm.c                              |  24 ++-
 net/sched/sch_mqprio.c                        | 182 +++++++++++++++---
 net/sched/sch_mqprio_lib.c                    |  14 ++
 net/sched/sch_mqprio_lib.h                    |   2 +
 net/sched/sch_taprio.c                        |  65 +++++--
 16 files changed, 459 insertions(+), 47 deletions(-)

-- 
2.34.1

