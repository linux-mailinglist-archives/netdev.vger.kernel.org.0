Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7233478D93
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbhLQOWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:22:11 -0500
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com ([104.47.55.169]:17879
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229587AbhLQOWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:22:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8v4KB0WajJGIPlHFutMse2u2qe6cb+0rR8WlLq7Cvq7bKthcoGQELHHe2+Rrqqx/jCLLlC2gcZtboPK3b1IJ9pdGS0UqZt7AhpUQkm9fbxlMQdIkgCDekQdnxUWoA0ovou6IA/xobTS6i6o2LOdwwIpJ+y86d07YfhTXqIFfq31aOgFtuYzKcfVrBuHtVl+qflj11P8H3jvn7DZC3FkTY1Ojb8NuZ+MnQmqaVEAS84MbUdjn/5Fs3agsnvuvqbUg9QXY2uW4cUpnANFoDdT461yVLz1T4cMUlMty+LhfMiYPUGaMKz+YuXpT5nTKiLQL7ohcjJd1CBsUr9jR3awXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mte9h2jApFQcIk2S8UTxzyqmOFREj1lzB4RIZNoc8OU=;
 b=fNbLn9LFW9hlWP2uCxG7HxSHUsqaX6jisuJ5LvD0nhI8IPHyPI2AyPLisYw1ZEE3Xy1gX2vFO9h4sdzfMiWuD4HANWgoxFiJafb5Cv6qMFENJihOYeW52yju8xLag7F5yweWMrcO+2N7RPuxUqMU5xykprJLByGiwqrDjAomHm/DUe9zzS470m67gjYC8mseTRHsUZOGUZYy6JT5KPJ1ify7J64DgbG489/QXAM6n27IvOfq1ny1H/eVbFgitpsyrgugeLkynwdNbssBMedeBZho6t+uvGA08CJfPv556VsyfO6vazZJ8l1/UTjYpQcgOR0LJCHN6TBx86uFrprsMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mte9h2jApFQcIk2S8UTxzyqmOFREj1lzB4RIZNoc8OU=;
 b=tfho+YSRzw0mZECjeRq16VoJZCgM6+ecmAr6bfv733PfJOHNAQaxsovspqgTY4hFTnBzIOo6wWxX/CKpPxPhuI9NCLLtMm9240nCderS9Lc4If50cNOPdAHa4ddyfKZNMjl2UIxBv28wcS+ULuYmETHHjmPyptIQ6PczsqVkBz8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5469.namprd13.prod.outlook.com (2603:10b6:510:142::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Fri, 17 Dec
 2021 14:22:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 14:22:07 +0000
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
Subject: [PATCH v7 net-next 00/12] allow user to offload tc action to net device
Date:   Fri, 17 Dec 2021 15:21:38 +0100
Message-Id: <20211217142150.17838-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0079.eurprd07.prod.outlook.com
 (2603:10a6:207:6::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 013e4e08-5683-4656-dc1e-08d9c1689b33
X-MS-TrafficTypeDiagnostic: PH0PR13MB5469:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB546918A27F71A1223262BCCBE8789@PH0PR13MB5469.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P35pDU/hvqvHu/1oTX0VsmXcgYOtU/Wnr8NG+Ow5wz0eWKo0zTNVELHOlh3Pd5ZReDP+PFEfnl68C4KZNcih3CNXuEUzhUfFbnDzVcL9IPwTrjyx//VvJTkfPPbKY+PcGUik92DixXmKVT+AYuoA73te05wIoh9QMhql6dlPiuhqtNr4XNJS8JR7W3WgUQSnKCrq0LRY4IfMyZb4hLky3ThaAxq5yVUUoJJD8bGj9nbUZ56WApxvKIMv0RubVeZjsNdFYMqE0PzZSggIt7q7fiBtKRyjnpTUX8ft/KgWqVEEwM5iq6qtHg+4v1VXn/h7WOThCXLSrCtazgOCsmWojnjybD4/7i92ql/G/HOxEp8yQ+zUcHbysyDV/sV9HSBZBYw1KdfLgb4B/2PajJaZBbE8Q4hqhmNMeb61rfqZNWHQNysaD+gsUyZxqpkOOEP80w6b+cTB8PQGE92n0u6kswFBoKgfDbw6b4UcbqNebI7H0zpaWYV2XgTVTkfeSkFCS6oQ8bUaDNkP90uZYT4mZKenVVw4bfx0F5Jox62eePBZ7hwAsFQgfIhB3NPoICcL0lPG9SIxUqXmvp7orNB06ANqQuJC4k0hNipIGqDATk7FMILD7SoTWzwQRL6EXwUuYoLcaXWvo9rbUqrQjRm22eiFXnTksXoKPifZCyRQ9fauyBxqJjQjfqj64hvhAl6u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(39840400004)(376002)(136003)(346002)(396003)(7416002)(5660300002)(83380400001)(36756003)(6666004)(186003)(44832011)(1076003)(107886003)(6506007)(2906002)(6512007)(6486002)(52116002)(66476007)(66556008)(4326008)(38100700002)(66946007)(54906003)(110136005)(508600001)(8936002)(86362001)(316002)(8676002)(2616005)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iTOi+35rH+ii1yxgvvGGeNcLqey/VP0T1+rQ5uRAFVPkR5v5N1bNquYl1I9V?=
 =?us-ascii?Q?73Go/Xd9p9/BPAkplLvVIQI7pi4x7c+iyfDWubxErdf/c/1zD7gJSSHO9Cdm?=
 =?us-ascii?Q?IrIlzlamGjpQZkNeVDhyj04iKvxdYF6nVofTsgCjA2+jA9dTMKAhGIrRkK47?=
 =?us-ascii?Q?sjbiXLx5A6XUbc0rbbZVPdVJP0AzlRlwVliqHsRLc5E3zryocFefATU0es6I?=
 =?us-ascii?Q?AFPHBQgE5G4LVbJmJbN5wCQcB+aFduImRJaLnN/iMPRgsTc9wCSLlC1viHUj?=
 =?us-ascii?Q?tLF+JtjFT4VuAs68aRAAKq+7W9tUGQyI1Z+hxnzzpOBq9a+6jBTjG0ZC6OYH?=
 =?us-ascii?Q?KHgVTiReH4sDfwenP9xb04+ysLVTjczh9Xx2HCHY0umOZpeDu6McWbzDX7lC?=
 =?us-ascii?Q?EEdkr7yDm3sCijxW75rEvnWomQRDWkAJjK63bwAX0Q+GOCPA1vQ1260VkhHO?=
 =?us-ascii?Q?XU+V/mrSXmp8aOOcTXX6EKFWPyEqWvoLdYXxouWAtlEqD99SAl1wjpuO7uj3?=
 =?us-ascii?Q?UGxsmEIpg/AtZXYJKZLTac0uAYzJeogon6VaQRCUTTDxELmijYpFNknPvyr7?=
 =?us-ascii?Q?7QZTBI2aqPsydKpQol1jcxPgfSbRhBVZTUV0erMOSoIsugsYsEiO5O7GueUL?=
 =?us-ascii?Q?J/qeEfz4lwPjNHe6JdcXWXh1YmlkyW2Jw7XHkXaTnN4Kn0xtENivVVel/COQ?=
 =?us-ascii?Q?lc1E2pXRAPd/hal/5+w4YWIn9rP1DC06ehBhrDwNnSFVQbJriu5WmT9+m2AM?=
 =?us-ascii?Q?gcQmC4tRv1jpFkA5mzm60Rw1lhIZ9ZaGoiXamiV4Mo8DzVmoyxYzUrVu0Evj?=
 =?us-ascii?Q?8QRxZLRVpB6/Sjfv7yA6B4tysrLTi6QbQiGBZLFcagcRqKluVXsT6PQmMAr3?=
 =?us-ascii?Q?4XOjsj4dYDlKf+suSJmpI5Ix9WEeGT+v3IZuSPApb6YkWTmODe9HedSPy2rr?=
 =?us-ascii?Q?oketdj+k8+PfkwR9BCqI0S1ZITDu632NSnDMvfLpNa9Udivzxfx1ibcGKcUw?=
 =?us-ascii?Q?of/uwB8nw3nIVnOsdzBzZuQ5vGxVlxu9kg6kaamcfKBfwdoH9tBgz7eJjhfE?=
 =?us-ascii?Q?Evfq8AaRe2PcRTtpwh9SXFXoq212cb84CW36Y+fEHyxCIBZhy+OxrYssUpy+?=
 =?us-ascii?Q?TNvj3vDG+UjNADpFZaZ9L2HBGXmx/arbk2bKuU/09B3/Tocn5H/hCF3qygVH?=
 =?us-ascii?Q?HYu56qHIcUMS6dXUm8MbM1d1ruf5y81ejJQn9SktpVtvjeOz7UrK+4GhIcCn?=
 =?us-ascii?Q?bpzZ4e8B/0lWD5In7sPP8Y5Y6SKpRqBum7Dak1Rf/IviWr3C/LD31+PmoYIE?=
 =?us-ascii?Q?UU1B/EBbeqNsRhKL58+gkOtIhysiYW+Qki3QmnSwa2+qg1ShHzHV8l4+Apr5?=
 =?us-ascii?Q?Py5Cthc35becg+9Abn6UnTxiFEaAX2/g8VAUZMMZLtqZYpQ3Y99/CbnY7X0z?=
 =?us-ascii?Q?H1n1sygK9Xkw/XFhuur3gg1SrzOjfJS9gCvtHLc/lUapn0Oi7IXe7TCde1DS?=
 =?us-ascii?Q?5F6BO3QPwUd7ClZB1IYXHjQXoKePjf/6kv34BOz7rBfb0IWzFZ8rwDphZitz?=
 =?us-ascii?Q?Xh1cp7YS9HMqVMoSBLLtMtoXv7NJZXGglMCxzdvBG5/cYEvHunrzi3qqOyoY?=
 =?us-ascii?Q?kIBtiuw6iUKBgXcOle5gqhWcQ8l5dv74enonQ/YPxqDBouPOonLSK/XVHJ8n?=
 =?us-ascii?Q?FVlwQPDWxyGALG1kuitedtEkY+38JZuXfbGT72wZ1BrJNSM6CLQvZpUBcNnk?=
 =?us-ascii?Q?VDf1P47vpQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 013e4e08-5683-4656-dc1e-08d9c1689b33
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:22:07.7219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +hjU8RwNhEAOvSGVIS9QyjDMs+4K2ruTgKRn2bMx8cNxIHR8DrLGvZyN77oCJ54A8vgFiD0DhWTgHIERQDr6O+PFw1Q5hbTkIczPIx2D7QA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5469
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

Changes between v6 and v7:
* Add a single patch to rename offload functions with offload for readability.
* Post 166b6a46b78b ("flow_offload: return EOPNOTSUPP for the unsupported mpls action type") as a bug fix to netdev.
* Rename the new added action offload setup ops with offload instead of flow
* Rename the new added action offload function with offload instead of flow.
* Add a single patch to rename exts stats update function for readability.
* Add more selftest cases for validate filter and actions.
* Fix the kernel test robot issue reported by Oliver Sang.

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

Baowen Zheng (12):
  flow_offload: fill flags to action structure
  flow_offload: reject to offload tc actions in offload drivers
  flow_offload: add index to flow_action_entry structure
  flow_offload: rename offload functions with offload instead of flow
  flow_offload: add ops to tc_action_ops for flow action setup
  flow_offload: allow user to offload tc action to net device
  flow_offload: add skip_hw and skip_sw to control if offload the action
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
 include/net/pkt_cls.h                         |  32 +-
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
 net/sched/cls_flower.c                        |  17 +-
 net/sched/cls_matchall.c                      |  17 +-
 net/sched/cls_u32.c                           |  12 +-
 .../tc-testing/tc-tests/actions/police.json   |  24 +
 .../tc-testing/tc-tests/filters/matchall.json |  72 +++
 42 files changed, 1208 insertions(+), 306 deletions(-)

-- 
2.20.1

