Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BEB4793B0
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240134AbhLQSRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:17:11 -0500
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com ([104.47.55.101]:6412
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229502AbhLQSRL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:17:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GaKFidihNbmgn0hrLeN4GO5mKC7Yzh2us2r3gK4L9698ppoO98zislmrDiS1qBXSC5ZfRjZdjU9mwDHU6/WUGUX4bRpQlf6vEXDgH3K7yuJ0yE45lA5ZXzWjzzg49wsYKiqu4h+MA9ZSYTzWEuWffEww6nEQleGwinVtOk2LWBsi6rL/CLn69Bxalc1LhNmRT24LKCckWZilNrFPb5en5L6Uz4xfXY6l/O6UeSdVXOmv97x+DR4s1nty/EM54eECuUzw0YrYw0f6irNfX+C7rYQJ221cXqVwP+Ux4IbO16kJw0t0GTYpDe+D6m2XZ3N38BR1fsDb/rRcTMQNaQYjpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7tztNVucn91QcmMP8XS0IuVu5uuE1YfqJ1FcT0fzKo=;
 b=NQSPyekARoMmQyxeJNxNuBPEOFer57sNHsf0ZCkd0xpaLDQVlk+HvJwtCjJ0Jbv5nzGbJUrtU2qKqtJCDjjUM8IYyzwKrzh0AWxFwI8XU74whsVKMB8dU5+nlfPqmLL2pLEonS7gDdUqXS6WiUEbeDpVLrYqZeglIlWGMkDPFEm8nXS4zzBviaPhnD/Ih8Sq/fOy8ZRPAfRry8M2jNGTtgu+WO3NFQSYLWBw1F12D9vzMEA0cFvF/c1+JElUVjpZEC27bDodr6QrqUooIJFZJqnHEQs9xYCHS7hUV7k2c+9bMTRkJUKuARVWhnLKuWj9mAMYABc9cDDrj14WXM7MVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7tztNVucn91QcmMP8XS0IuVu5uuE1YfqJ1FcT0fzKo=;
 b=tIzzqYjWvpr4ne4dm0VDGSzbUDvhJXRJ3JDlFF7hALD8o8eH4V3JcfGOc2gN4fYghLhiaSLz4o/E4ioN2VnTcHqzPO9o7B0qx49kMeaBoJHtG7mMyUs2/klG0svjZt6vajaUP3CqkshEHWwqnrWP2Ae+HTikUjlXjMzX+9jllQM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5004.namprd13.prod.outlook.com (2603:10b6:510:7b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.12; Fri, 17 Dec
 2021 18:17:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 18:17:07 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v8 net-next 00/13] allow user to offload tc action to net device
Date:   Fri, 17 Dec 2021 19:16:16 +0100
Message-Id: <20211217181629.28081-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0097.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9b77b0c-4490-4475-03cf-08d9c1896f02
X-MS-TrafficTypeDiagnostic: PH0PR13MB5004:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB500421CDE00B4053F6CBCF5EE8789@PH0PR13MB5004.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g4SDf6WluNjmKCi4QA5RYW5TVToj9ltiBGovrkd/u6vHAs4S4F9VuQd+6q+mN+JZ4qXogV6vUFCq4xlyw8Mxd2jcT9Zg+YmVsChlaHXlLTRsIiEnnQ4d22dRJiX0JlK4g6XiGiXPtMHrhLe58jHutb7ucCJPQ7bHEUAgLbVq0QDuCPcfSJt3HNlU7Qp+/0uk9nmPHxj2JYOq2qPoU19qZe9d4corNCxrRmIJLN0xdK6hYtdbtA84kkdLhV2xoYyWLapKKc/yvy2tYIF6J8Vb6PGdRvbYATeubUc9Y+EYHB3pbu1LTISiz4H0iTW2MGZc3Hdofgw8e+9AD5Zs0DdEoL+KaTCPhcLFDVBf4HMFNrIZKDAGQfZDzThtP1KUMejxvMLI5o6n1NTeeUHLKP6LpJ3q7UVlyz8azp+9XEjQkhEBUE3NVzQ2byEEvRsBZjcgrSM4+Xzebhg10YQIDls73XeByDb3v4AIAZcKAhzlUeFSOV2dkur9pGBbnIHFHIbENwj7thwzALahXVOCpqZCgXNpgIlBdR5qOyZ9PB79lZMe6qmSrIDlDVEMpKZMYx8zdx1l8dbPEVGs5TfDD+7qbilvWbw1ITnXMsWGjUwLipKT98CBJFXQlYGSrULo5QvzkAs/6sPU5qZVNUPELhDjXhU0alvnV96MueuEeOebgn9oaSGU0M4uRX5+M8Rla3Ne
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(396003)(346002)(39830400003)(376002)(366004)(508600001)(36756003)(6486002)(7416002)(5660300002)(186003)(6506007)(38100700002)(2906002)(44832011)(52116002)(6512007)(66476007)(83380400001)(8676002)(54906003)(110136005)(86362001)(107886003)(66556008)(1076003)(2616005)(4326008)(316002)(66946007)(8936002)(6666004)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O2soUsx3AQU9gq7hFhLQnyqaeXFfNna/9NLtG7tT1aUw+kK6lU9Yv9sGevxp?=
 =?us-ascii?Q?Okj8FGiC52znAxkDH07ZddXU6AezqjFkEeSk9FS2CevSsrWnLWjFksF/gNNH?=
 =?us-ascii?Q?v54AHmkCceVNMoau01zCPMUkc+UZIgRRyUDfrctcj7fpOIwiLVMY82wJw0Rn?=
 =?us-ascii?Q?/OXjDeAyaduoolCWch0SIWecECn+lph+cWMzltw4eHVVwZu66tFLRfKjfXtq?=
 =?us-ascii?Q?54rWxP+5UtfY/xBa4muxRe4mLWzY3GUBE44qh87ck15ggC877iWQRJfcONWC?=
 =?us-ascii?Q?2KT9cHPAv/UITabyZ4jz2hYi6HiG98wOMnnUx7qn2NnXhVH2NqNpjWcphgGF?=
 =?us-ascii?Q?AUkI9P3plgStIMyH+7mM3PXDb79kJw5bzHTNRfi8QDWEUO58A3NDPIRRfKfr?=
 =?us-ascii?Q?CSQkBg1mKvF/hIFnakE171fik+z+5icuti641LyU+Q1AOo8XmwZrgWOdaPCS?=
 =?us-ascii?Q?wGVzQe8+VIrTX6cgo6VS2A7MCGzeY1oSs/Kth47V0T7FnbVHCqSPHZeYnpeX?=
 =?us-ascii?Q?5u+jz2UG9cyzdeOGxo8K0jGaE1OeBtMV4n2IGnaJJQX49I24Lxd8PASEZDaQ?=
 =?us-ascii?Q?QCMQJG54/getGgyVyeFSXWJOJdc2mYeQEygqWtWrNKi25jOPYXQg8a6oe53q?=
 =?us-ascii?Q?e/bP3H2OoVsm4n5HVK92VLxxyPZ/WHVxBBNb1OiPamXsvXEGORi2PKG7BXkb?=
 =?us-ascii?Q?LKSE8CpBFGkE2H8Nap5USZD+b5PVt2xOBtMyKmVhdaCGmM++rd/z1is8fwOz?=
 =?us-ascii?Q?ePyhBlcmjVX1clF4qBglNMdOfzUME0EsvmgCKtzY9kzSiUqk8gIwS6GlDy2Q?=
 =?us-ascii?Q?ovQnWK7IY7GLQOE78mNNrwQfcNNIa/OZUT9ZZHZyQ9lX55MFRGJ3hlsUUrUP?=
 =?us-ascii?Q?otWiTJqMYXAFLK/dTrt3GHPFJIx80WQoUk4DRz29PYpsjqS2SdtgAYsR/x9G?=
 =?us-ascii?Q?C0Ki8SC/Fc/ZzGT6gOnzGu1uPocnh4ygFCacdd7zgfBMf1rB+x0jemaic12H?=
 =?us-ascii?Q?J8HP93q50X9N5dUtzz9IbBcpgDARQZcV/EgBLTjz5FuAKOqXALOFT4xFvfgn?=
 =?us-ascii?Q?imZTZf5vhQEnF9Wd3znk2YUgJbwSoLvapa5r7dLqMk3aTJCnkTwaejHQhqle?=
 =?us-ascii?Q?hVkM3yQptY8r42e4Zn5dlcdWJYmCo6Bdd2IxxFExLmBGEdGvp4XBXpNoJpqJ?=
 =?us-ascii?Q?btME8XOwOuFNIYmm9ffcbOo9+LtYJa1fVdNzYt5lUO5BKLDhVCmYDe/Df28n?=
 =?us-ascii?Q?bOoOyxI0IUlsrOqRbXzY1sSt/aWMUVOD3mch4C8fqPnAWIsRWJSBAJCOakav?=
 =?us-ascii?Q?pL3jPNwO5UXhq7dihLm5X8I5/398LuOn2Bgc02rqfBO11POgQR7ZtM2KJmqE?=
 =?us-ascii?Q?Iou/oxsAm3M/qKx3kSc++lqqvbb/smrv7CRgPqQ9zCUESGtDD1gFWHhXcWul?=
 =?us-ascii?Q?iObCna7cqMpB+oMdsPYqCBztcyzC3nFtE9rqiBZlnO53XNj88O0OsNSKxfbw?=
 =?us-ascii?Q?g6kD39LKJ2lopibWIWUdj+qMrauo0JdZsVNCaI1HfNbabXDiVvVGYILplyme?=
 =?us-ascii?Q?Zyk6zHLOQSgzXqHMJbvOyyW1weSlEvFXtOG1sxR1orBwG85ikkn42CVb9ZWN?=
 =?us-ascii?Q?+V1q8UKSbVMmA34SM04MyArwqnpqqXhPCiPRbehY2avThbRwK0nv6RpB+iPC?=
 =?us-ascii?Q?ixJAAyDO9oX1KlAvzFB/zws8l8ByhgOVjS2i5eHwi3+933TZvHvXvSFwfJQH?=
 =?us-ascii?Q?3w1zKZwSTGYFvOOZY/tZurTgNniMF8M=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b77b0c-4490-4475-03cf-08d9c1896f02
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:17:06.9646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N8VgSaalsiFBWeFZUGXGqdjl9Lt/EN68cq5OtDzyq224ffUy3GqywTgJjjn8BH7tCYMTydl1KKBhabK8YB+P+JebpVR7KddqcClcp3632/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5004
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Baowen Zheng says:

Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
tc actions independent of flows.

The motivation for this work is to prepare for using TC police action
instances to provide hardware offload of OVS metering feature - which calls
for policers that may be used by multiple flows and whose lifecycle is
independent of any flows that use them.

This patch includes basic changes to offload drivers to return EOPNOTSUPP
if this feature is used - it is not yet supported by any driver.

Tc cli command to offload and quote an action:

 # tc qdisc del dev $DEV ingress && sleep 1 || true
 # tc actions delete action police index 200 || true

 # tc qdisc add dev $DEV ingress
 # tc qdisc show dev $DEV ingress

 # tc actions add action police rate 100mbit burst 10000k index 200 skip_sw
 # tc -s -d actions list action police
 total acts 1

         action order 0:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action reclassify 
         overhead 0b linklayer ethernet
         ref 1 bind 0  installed 142 sec used 0 sec
         Action statistics:
         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0
         skip_sw in_hw in_hw_count 1
         used_hw_stats delayed

 # tc filter add dev $DEV protocol ip parent ffff: \
         flower skip_sw ip_proto tcp action police index 200
 # tc -s -d filter show dev $DEV protocol ip parent ffff:
 filter pref 49152 flower chain 0
 filter pref 49152 flower chain 0 handle 0x1
   eth_type ipv4
   ip_proto tcp
   skip_sw
   in_hw in_hw_count 1
         action order 1:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action 
         reclassify overhead 0b linklayer ethernet
         ref 2 bind 1  installed 300 sec used 0 sec
         Action statistics:
         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0
         skip_sw in_hw in_hw_count 1
         used_hw_stats delayed

 # tc filter add dev $DEV protocol ipv6 parent ffff: \
         flower skip_sw ip_proto tcp action police index 200
 # tc -s -d filter show dev $DEV protocol ipv6 parent ffff:
   filter pref 49151 flower chain 0
   filter pref 49151 flower chain 0 handle 0x1
   eth_type ipv6
   ip_proto tcp
   skip_sw
   in_hw in_hw_count 1
         action order 1:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action 
         reclassify overhead 0b linklayer ethernet
         ref 3 bind 2  installed 761 sec used 0 sec
         Action statistics:
         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0
         skip_sw in_hw in_hw_count 1
         used_hw_stats delayed

 # tc -s -d actions list action police
 total acts 1

          action order 0:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action reclassify overhead 0b linklayer ethernet
          ref 3 bind 2  installed 917 sec used 0 sec
          Action statistics:
          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
          backlog 0b 0p requeues 0
          skip_sw in_hw in_hw_count 1
         used_hw_stats delayed

Changes between v7 and v8:
* Rename enum offload_act_command as enum flow_offload_act_command
* Add a single patch to rename exts stats update function for readability.
* Fix the kernel test robot issue reported by Oliver Sang.

Changes between v6 and v7:
* Add a single patch to rename offload functions with offload for readability.
* Post 166b6a46b78b ("flow_offload: return EOPNOTSUPP for the unsupported mpls action type") as a bug fix to netdev.
* Rename enum flow_act_command as enum flow_offload_act_command
* Rename the new added action offload setup ops with offload instead of flow
* Rename the new added action offload function with offload instead of flow.
* Add more selftest cases for validate filter and actions.

Changes between v5 and v6:
* Fix issue reported by Dan Carpenter found using Smatch.

Changes beteeen v4 and v5:
* Made changes of code style according to the public review comments.
* Add a fix for unsupported mpls action type in flow action setup stage.
* Add ops to tc_action_ops for flow action setup to facilitate
  adding a standalone action module.
* Add notification process when deleting action in reoffload process.

Changes between v3 and v4:
* Made changes according to the public review comments.
* Validate flags inside tcf_action_init() instead of creating new
  tcf_exts_validate_actions() function.
* Exactly match when validating flags of actions and filters.
* Add index to flow_action_entry for driver to identify actions.

Changes between v2 and v3:
* Made changes according to the review comments.
* Delete in_hw and not_in_hw flag and user can judge if the action is
  offloaded to any hardware by in_hw_count.
* Split the main patch of the action offload to three single patch to
  facilitate code review.

Changes between v1 and v2:
* Add the skip_hw/skip_sw for user to specify if the action should be in
  hardware or software.
* Fix issue of sleeping function called from invalid context.
* Change the action offload/delete from batch to one by one.
* Add some parameters to the netlink message for user space to look up
  the offload status of the actions.
* Add reoffload process to update action hw_count when driver is inserted
  or removed.

Changes between v1 and RFC:
* Fix robot test failure.
* Change actions offload process in action add function rather than action
  init.
* Change actions offload delete process after tcf_del_notify to keep
  undeleted actions.
* Add process to update actions stats from hardware.

Baowen Zheng (13):
  flow_offload: fill flags to action structure
  flow_offload: reject to offload tc actions in offload drivers
  flow_offload: add index to flow_action_entry structure
  flow_offload: rename offload functions with offload instead of flow
  flow_offload: add ops to tc_action_ops for flow action setup
  flow_offload: allow user to offload tc action to net device
  flow_offload: add skip_hw and skip_sw to control if offload the action
  flow_offload: rename exts stats update functions with hw
  flow_offload: add process to update action stats from hardware
  net: sched: save full flags for tc action
  flow_offload: add reoffload process to update hw_count
  flow_offload: validate flags of filter and actions
  selftests: tc-testing: add action offload selftest for action and
    filter

 drivers/net/dsa/ocelot/felix_vsc9959.c        |   4 +-
 drivers/net/dsa/sja1105/sja1105_flower.c      |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |   2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c     |   2 +-
 .../ethernet/netronome/nfp/flower/offload.c   |   3 +
 include/linux/netdevice.h                     |   1 +
 include/net/act_api.h                         |  27 +-
 include/net/flow_offload.h                    |  20 +-
 include/net/pkt_cls.h                         |  38 +-
 include/net/tc_act/tc_gate.h                  |   5 -
 include/uapi/linux/pkt_cls.h                  |   9 +-
 net/core/flow_offload.c                       |  46 +-
 net/sched/act_api.c                           | 452 +++++++++++++++++-
 net/sched/act_bpf.c                           |   2 +-
 net/sched/act_connmark.c                      |   2 +-
 net/sched/act_csum.c                          |  19 +
 net/sched/act_ct.c                            |  21 +
 net/sched/act_ctinfo.c                        |   2 +-
 net/sched/act_gact.c                          |  38 ++
 net/sched/act_gate.c                          |  51 +-
 net/sched/act_ife.c                           |   2 +-
 net/sched/act_ipt.c                           |   2 +-
 net/sched/act_mirred.c                        |  50 ++
 net/sched/act_mpls.c                          |  54 ++-
 net/sched/act_nat.c                           |   2 +-
 net/sched/act_pedit.c                         |  36 +-
 net/sched/act_police.c                        |  27 +-
 net/sched/act_sample.c                        |  32 +-
 net/sched/act_simple.c                        |   2 +-
 net/sched/act_skbedit.c                       |  38 +-
 net/sched/act_skbmod.c                        |   2 +-
 net/sched/act_tunnel_key.c                    |  54 +++
 net/sched/act_vlan.c                          |  48 ++
 net/sched/cls_api.c                           | 272 ++---------
 net/sched/cls_flower.c                        |  29 +-
 net/sched/cls_matchall.c                      |  27 +-
 net/sched/cls_u32.c                           |  12 +-
 .../tc-testing/tc-tests/actions/police.json   |  24 +
 .../tc-testing/tc-tests/filters/matchall.json |  72 +++
 42 files changed, 1222 insertions(+), 320 deletions(-)

-- 
2.20.1

