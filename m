Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB47667083
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbjALLIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbjALLHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:07:49 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4561C4828B
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 02:59:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrTW3L5UKFT6wdKAKOALrkHw4ISsKPhviC2vlk0S3y4YFru4/xobG0k8B15+QJIiLsb4lhcVdjvolcd81kRm06t8YdDfjlM0IgXHiARbNhOiGPaVNqNkcMD7rYDx4XdcWVKcBrG4aO8DyT6K5CAMXCN+kibW/tGRGd97KcPdDTBtEkfzH+DQM2wk4KrqaEzxt6DErYFwe0gHUA97abS62ItOSOuOd8U463Qx1tOOPHjXh+sxoNX83clU2P7yb9zW3Jje2UkoSLa6uqOCGdBFtJr6HaD6gMpHDCr5zdFlPB8ws0l4SmUJE12ugePemRehH4td/g2ojKKma6TT2j7ACQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MD4u4ZVwrQUPAH1v2OJghhpujSLHTjnfimKB2sZDaSY=;
 b=cZj5cn2RdECdpEV3+OtYNRw3recadJIZOz3R4Kcs2xJ5l38rV5Hs6VhFzEBhFIrWxG7cTsA6RpT/vAqdsZG9JMscnugDZjZsHgMOVNviAuLv6A1B6Njpnt/s7ROgGdwK+GKuJ6s9YrhB6X8jpdlL/ZWX0cBDVscaM81wmPW6IzQe+MSQ8bzqPmiLISWpC9eS4OcoDiXbWL04de1OmmgY0XPUG++63f09y96MB53+1yFGfJyFQkym5PI5nTPHWuR4/mt5FcJuSF76M+KHhPGXdYDxGiP5tHiaWP89UA6Ky/56LPE6z1fIkFr6LuHFADfJ0Y6h3CYohZdNKxnKmlx0UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MD4u4ZVwrQUPAH1v2OJghhpujSLHTjnfimKB2sZDaSY=;
 b=LEU4ApnSjdu7zqNwIXESqvVdSd3n9gL+3Fkj3ml9KzN1mwkOJbiWKZa+qTIT/I+B76x8oEpWC26YYR9qMYc4yeDoMlcrm7tZqwbeM06WxtmsPYbYeRcAoBg3vJbYx032AimmqpoCmGc3n71C9s+bE3fEv52uXQCH9OyJbn/242twfDyviL1XnVKi10EOheOhQD+fnHCex7T4xFnq2UWgKDqPcfT40VnQKiRq5qKKCaoiywe9N7c74i/1z8g1yFXbKrDK4UXO6CoCO72b2+rGZOd1DYg77w0heghT7ArlVgrRVIwo1Y1OjvglrgpYzT82aLT/whoHF4dwmmuBt/o/TA==
Received: from BN9P222CA0024.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::29)
 by SJ1PR12MB6170.namprd12.prod.outlook.com (2603:10b6:a03:45b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 12 Jan
 2023 10:59:33 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::d6) by BN9P222CA0024.outlook.office365.com
 (2603:10b6:408:10c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13 via Frontend
 Transport; Thu, 12 Jan 2023 10:59:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 12 Jan 2023 10:59:32 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 02:59:13 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 02:59:13 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Thu, 12 Jan 2023 02:59:10 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next 0/4] net/sched: cls_api: Support hardware miss to tc action
Date:   Thu, 12 Jan 2023 12:58:59 +0200
Message-ID: <20230112105905.1738-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT016:EE_|SJ1PR12MB6170:EE_
X-MS-Office365-Filtering-Correlation-Id: ffc90ae1-a88b-4eeb-f658-08daf48c15b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 897TlGBRyMDbA8vq5pc6gXn0qT3w/NxQiF7PpG7Ix1EZ1p6eq1MyOCcCIXRN52Uf0zMnEKBHMqXmHA0+VemooN39W2ae7Q4mIACm7ql5mfOWWJ4Ck4ueRaEOqISibtxLbOH6dclvbTN1QNT2Ulof7DXca9y/fR1xtY9HTmsJDUKKbzC0j+jd3xTdmVz5DWupZGfxBB6T00wLgXNB71mWx/7oO2NyajW0uWhYe7yOnc0SW5GPgpMYWEVQGfb3CTxssbCHy2t43gUVNfGvV1EjTT622WsAX4PWxrK59kt3ewjunQtmyvc4AEe0pMfFkknOX4wAcUBhjccZbFIIwsu3qaVb1eb+aYz8ZIjdVDidJ0O+pDFLDNYclrH6cNoCyZFDQPZgPtiSF9RuWbK6yOQEzQbhaVe3pCJUWhrq4JTkvJiUL0BLnMtE9N59lqIxTgQYZRaos1ZZ/9LViVJkjXCGgFXLUIqfg+mJSin1/vxr6hAa7lu2KKRx+VhLdsakHw6D+Fk4KOVA8Yri4jCd3WLz2NViigIoNix0g79/aPn0r/+6wDSmwX+Lu/dnj0ozW8an64ItzbbL/UmR7ny60vZpS6MIjrPktaHJvjcBqSDM22ZDbZCYha244nIEtmr8OTfJV0InAjcjz218YmSliyHOxV6/A0foZKwoS7N72+fh7W3MyvbU/4/p4r07wExdjBTfc0zJmFtoT8TlT5nOd2MaXQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(36860700001)(107886003)(6666004)(2906002)(70206006)(36756003)(4326008)(5660300002)(83380400001)(8936002)(8676002)(82740400003)(426003)(41300700001)(356005)(47076005)(478600001)(7636003)(336012)(40480700001)(26005)(70586007)(82310400005)(186003)(1076003)(40460700003)(86362001)(2616005)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 10:59:32.0938
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc90ae1-a88b-4eeb-f658-08daf48c15b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6170
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds support for hardware miss to a specific tc action
instance on a filter's action list. The mlx5 driver patch (besides
the refactors) shows its usage instead of using just chain restore.

This miss to action supports partial offload of a filter's action list,
and and let software continue processing where hardware left off.

Example is the CT action, where new connections need to be handled in
software. And if there is a packet modifying action before the CT action,
then restoring only the chain on misses might cause the rule to not
re-execute the relevant filter in software.

Consider the following scenario:

$ tc filter add dev dev1 ingress chain 0 proto ip flower \
  ct_state -trk dst_mac fe:50:56:26:13:7d \
  action pedit ex munge eth dst aa:bb:cc:dd:ee:01 \
  action ct \
  action goto chain 1
$ tc filter add dev dev1 ingress chain 1 proto ip flower \
  ct_state +trk+est \
  action mirred egress redirect dev ...
$ tc filter add dev dev1 ingress chain 1 proto ip flower \
  ct_state +trk+new \
  action ct commit \
  action mirred egress redirect dev dev2

$ tc filter add dev dev2 ingress chain 0 proto ip flower \
  action ct \
  action mirred egress redirect dev dev1

A packet doing the pedit in hardware (setting dst_mac to aa:bb:cc:dd:ee:01),
missing in the ct action, and restarting in chain 0 in software will fail
matching the original dst_mac in the flower filter on chain 0.

The above scenario is supported in mlx5 driver by reordering the actions
so ct will be done in hardware before the pedit action, but some packet
modifications can't be reordered in regards to the ct action. An example
of that is a modification to the tuple fields (e.g action pedit ex munge ip
dst 1.1.1.1) since it affects the ct action's result (as it does lookup based
on ip).

Paul Blakey (6):
  net/sched: cls_api: Support hardware miss to tc action
  net/sched: flower: Move filter handle initialization earlier
  net/sched: flower: Support hardware miss to tc action
  net/mlx5: Refactor tc miss handling to a single function
  net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
  net/mlx5: TC, Set CT miss to the specific ct action instance

 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 225 ++------------
 .../mellanox/mlx5/core/en/tc/sample.c         |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  32 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 276 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  21 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   2 +
 .../mellanox/mlx5/core/lib/fs_chains.c        |  14 +-
 include/linux/skbuff.h                        |   6 +-
 include/net/flow_offload.h                    |   1 +
 include/net/pkt_cls.h                         |  20 +-
 include/net/sch_generic.h                     |   2 +
 net/openvswitch/flow.c                        |   2 +-
 net/sched/act_api.c                           |   2 +-
 net/sched/cls_api.c                           | 208 ++++++++++++-
 net/sched/cls_flower.c                        |  75 +++--
 17 files changed, 580 insertions(+), 314 deletions(-)

-- 
2.30.1

