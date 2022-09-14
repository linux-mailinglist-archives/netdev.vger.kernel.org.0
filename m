Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1A85B8735
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 13:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiINLXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 07:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiINLXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 07:23:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF1D5AA11
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 04:23:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKFZ7jLe5cODJHFTnFM5RxtASKhEq5MDWURkfj5ytwTTWpnIxWvoJ3ys8nnSGcimkUTI/ctf4YO7AcI6sWKiOz2cciqoZNMpENr+E1T+//z5RC8kmPwzDrfKT4YsGBZq/1iW4uuVYY+P6C1+WVeqxr3yt1rP/+2XVC10OWlOyYDjMR9KBBusA6dASatjo+XUTkSdV9kEhT0p1Xzc1vE8MFheiRKba+zLQqnTRbfYKkx2iBPtP0OzJiGcsr3dcDKeSii8M6aLy9y1nsbTJi2GydnKBujQ5NOCcuBf7qq4dHDq/UVcjT2HREbMTyU2YxQEkvMvHE6UCSkPOw03vIkixg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tblUcsCcqbNEeCRSiEPgeq3/EXOnHz1E926EbaBy7t0=;
 b=SwH0P50I36GpBp9TorbFEi7Bk81MvKXHI/y1kxCZBxU16eROhOCwcLwmJvmcymj2EwIyagRu9U5CDpE25XsWE9zpz/MhbKh792+UPTUCoT7Gsk6x7IUJytnVTTwT698/CfiLzw8NlY6+qu3zJFSTJZSgdn1/FCe5vMuoH/qQIGwnQSD92nSjR0n3ZG5SbOnYfgDaCYI0q3fo7OnKYLsapnv6dm/HbJjqJZzoTPQCsjcCdgv/vhqnZRk+JLuR8uJEzS4UykJh+36eC6cB2AWzR4roYgTtBpNI9INMpd5hQbnHBvb6q8aA+rNIavB5vWBKRgONTqJvJXEpDw6mf1oHuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tblUcsCcqbNEeCRSiEPgeq3/EXOnHz1E926EbaBy7t0=;
 b=rT1luObu8HD4XLy72fQmZQ4xugyu7U1+QB3NLUKx302/LufvFgIVHaMsH182WAIMTHWE99LCbsqBqWdTq2zy96JOOcILq45XLe7IJ9BPF3/xsgs909J5o3ZpZ+REAbKqPnBUyhJlMD+8wY10Hr9LIvcxkycBPdr4fms/wTwpjSZesvFDBbdsNM7nmXL5jD4DpKBLX7Se/o+o2SzZqFopLSd+S9qPGYGMG6i8KKiaviO4Ae8x7MLmqaosJmtkQS27jz2QKc2Av1yIsGmNMiAnmyeqjaDb9eTtRo2afjkz26WKjL/m7lNIIAcWeF5QDd9Ksbnpq6sYL6K8ZeJKzbIYOA==
Received: from BN9P221CA0015.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::20)
 by CY8PR12MB7145.namprd12.prod.outlook.com (2603:10b6:930:5f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Wed, 14 Sep
 2022 11:23:37 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::3e) by BN9P221CA0015.outlook.office365.com
 (2603:10b6:408:10a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.21 via Frontend
 Transport; Wed, 14 Sep 2022 11:23:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 11:23:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 04:23:16 -0700
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 04:23:13 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 5/5] selftests: mlxsw: Remove qos_burst test
Date:   Wed, 14 Sep 2022 13:21:52 +0200
Message-ID: <87fbb0f8b0aef6ac73be2c16d6aba8d512dbfc08.1663152826.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1663152826.git.petrm@nvidia.com>
References: <cover.1663152826.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT024:EE_|CY8PR12MB7145:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fbd7407-099f-4aa9-77f4-08da964390fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6D5BKPGmX6on5hwqUn0AoJ8bJiPjuZZSQ9nDC48OzohsjLD8wHgKbiFfMbYYa40/KA9qtjra/mLt9eygUSwQbx8wTklIeST4mYL4jP1f4wMPqbiu6ynQHZxRrnIaxAxrwWDTFX/cFVsCI2Oq93o/o4uPo1dIxjvrKgPWX0/v3L9jCFUvYaLqSdus3R6SxeP0yDq+9A0CgMNudjQlIzbDUteZhm8qVGOCXyIfKZhVaRJZhKjpwXu+4jOWLje1+7WOg1/QHXBMBdMWze4Aenp7w4jp7d1vOTOIl1CiLzNF5SzjxNL+hYX2ruGLPIFXp8SueHWNnrW3OPkgvwG4KUMVkTwJaW41GTNEaFdh9OFBKbasZiBhdbrhDUWART0j4Truj/Zxc8+9pGuK8SWZT1KHTiniV+7DbdDRVewRc8NJeQw35B18/wWur+RFdBSxAK5R7aNOGnwXnmyIj8mRXG4jiImD5LXVdphTMPHKQnun+zfMxvLVIOlZZCzepoPQsasx7WlwG2XqCGgbeuayUl9S9dtxG0cpNyPmhOq7ce7kkCeCoMBZM99xfYm4ZLuTxrSBiUAGK06ymgZkiPA0YBIsFrA7SBjMnrIv5ZqcyWY0MsVSHyKUF2lfBB2JqEn4qFzBEp6wVIB43d2d1yg+pR69K5o7go0xbSemw0eqcxWfSyBLMEu7VI8UZ2HEZjnSLFxjUI1x5VhmNvs9iwDGkwStvp4sKdjEEibbuwDjtXI095qYpYv8n9aFmXJPSRYTYPQKS/iVxgKrMaFKYn0srgxNcw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(39860400002)(346002)(451199015)(36840700001)(46966006)(40470700004)(40460700003)(26005)(40480700001)(6666004)(107886003)(36756003)(16526019)(5660300002)(336012)(47076005)(426003)(186003)(82310400005)(2616005)(36860700001)(316002)(41300700001)(83380400001)(2906002)(478600001)(110136005)(54906003)(86362001)(8936002)(82740400003)(7636003)(356005)(4326008)(8676002)(30864003)(70586007)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 11:23:36.3780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fbd7407-099f-4aa9-77f4-08da964390fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7145
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The previous patch added a test which can be used instead of qos_burst.sh.
Remove this test.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/qos_burst.sh  | 480 ------------------
 1 file changed, 480 deletions(-)
 delete mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_burst.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_burst.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_burst.sh
deleted file mode 100755
index 82a47b903f92..000000000000
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_burst.sh
+++ /dev/null
@@ -1,480 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-#
-# This test sends 1Gbps of traffic through the switch, into which it then
-# injects a burst of traffic and tests that there are no drops.
-#
-# The 1Gbps stream is created by sending >1Gbps stream from H1. This stream
-# ingresses through $swp1, and is forwarded thtrough a small temporary pool to a
-# 1Gbps $swp3.
-#
-# Thus a 1Gbps stream enters $swp4, and is forwarded through a large pool to
-# $swp2, and eventually to H2. Since $swp2 is a 1Gbps port as well, no backlog
-# is generated.
-#
-# At this point, a burst of traffic is forwarded from H3. This enters $swp5, is
-# forwarded to $swp2, which is fully subscribed by the 1Gbps stream. The
-# expectation is that the burst is wholly absorbed by the large pool and no
-# drops are caused. After the burst, there should be a backlog that is hard to
-# get rid of, because $sw2 is fully subscribed. But because each individual
-# packet is scheduled soon after getting enqueued, SLL and HLL do not impact the
-# test.
-#
-# +-----------------------+                           +-----------------------+
-# | H1                    |			      | H3                    |
-# |   + $h1.111           |			      |          $h3.111 +    |
-# |   | 192.0.2.33/28     |			      |    192.0.2.35/28 |    |
-# |   |                   |			      |                  |    |
-# |   + $h1               |			      |              $h3 +    |
-# +---|-------------------+  +--------------------+   +------------------|----+
-#     |                      |                    |       		 |
-# +---|----------------------|--------------------|----------------------|----+
-# |   + $swp1          $swp3 +                    + $swp4          $swp5 |    |
-# |   | iPOOL1        iPOOL0 |                    | iPOOL2        iPOOL2 |    |
-# |   | ePOOL4        ePOOL5 |                    | ePOOL4        ePOOL4 |    |
-# |   |                1Gbps |                    | 1Gbps                |    |
-# | +-|----------------------|-+                +-|----------------------|-+  |
-# | | + $swp1.111  $swp3.111 + |                | + $swp4.111  $swp5.111 + |  |
-# | |                          |                |                          |  |
-# | | BR1                      |                | BR2                      |  |
-# | |                          |                |                          |  |
-# | |                          |                |         + $swp2.111      |  |
-# | +--------------------------+                +---------|----------------+  |
-# |                                                       |                   |
-# | iPOOL0: 500KB dynamic                                 |                   |
-# | iPOOL1: 500KB dynamic                                 |                   |
-# | iPOOL2: 10MB dynamic                                  + $swp2             |
-# | ePOOL4: 500KB dynamic                                 | iPOOL0            |
-# | ePOOL5: 500KB dnamic                                  | ePOOL6            |
-# | ePOOL6: 10MB dynamic                                  | 1Gbps             |
-# +-------------------------------------------------------|-------------------+
-#                                                         |
-#                                                     +---|-------------------+
-#                                                     |   + $h2            H2 |
-#                                                     |   | 1Gbps             |
-#                                                     |   |                   |
-#                                                     |   + $h2.111           |
-#                                                     |     192.0.2.34/28     |
-#                                                     +-----------------------+
-#
-# iPOOL0+ePOOL4 are helper pools for control traffic etc.
-# iPOOL1+ePOOL5 are helper pools for modeling the 1Gbps stream
-# iPOOL2+ePOOL6 are pools for soaking the burst traffic
-
-ALL_TESTS="
-	ping_ipv4
-	test_8K
-	test_800
-"
-
-lib_dir=$(dirname $0)/../../../net/forwarding
-
-NUM_NETIFS=8
-source $lib_dir/lib.sh
-source $lib_dir/devlink_lib.sh
-source qos_lib.sh
-source mlxsw_lib.sh
-
-_1KB=1000
-_500KB=$((500 * _1KB))
-_1MB=$((1000 * _1KB))
-
-# The failure mode that this specifically tests is exhaustion of descriptor
-# buffer. The point is to produce a burst that shared buffer should be able
-# to accommodate, but produce it with small enough packets that the machine
-# runs out of the descriptor buffer space with default configuration.
-#
-# The machine therefore needs to be able to produce line rate with as small
-# packets as possible, and at the same time have large enough buffer that
-# when filled with these small packets, it runs out of descriptors.
-# Spectrum-2 is very close, but cannot perform this test. Therefore use
-# Spectrum-3 as a minimum, and permit larger burst size, and therefore
-# larger packets, to reduce spurious failures.
-#
-mlxsw_only_on_spectrum 3+ || exit
-
-BURST_SIZE=$((50000000))
-POOL_SIZE=$BURST_SIZE
-
-h1_create()
-{
-	simple_if_init $h1
-	mtu_set $h1 10000
-
-	vlan_create $h1 111 v$h1 192.0.2.33/28
-	ip link set dev $h1.111 type vlan egress-qos-map 0:1
-}
-
-h1_destroy()
-{
-	vlan_destroy $h1 111
-
-	mtu_restore $h1
-	simple_if_fini $h1
-}
-
-h2_create()
-{
-	simple_if_init $h2
-	mtu_set $h2 10000
-	ethtool -s $h2 speed 1000 autoneg off
-
-	vlan_create $h2 111 v$h2 192.0.2.34/28
-}
-
-h2_destroy()
-{
-	vlan_destroy $h2 111
-
-	ethtool -s $h2 autoneg on
-	mtu_restore $h2
-	simple_if_fini $h2
-}
-
-h3_create()
-{
-	simple_if_init $h3
-	mtu_set $h3 10000
-
-	vlan_create $h3 111 v$h3 192.0.2.35/28
-}
-
-h3_destroy()
-{
-	vlan_destroy $h3 111
-
-	mtu_restore $h3
-	simple_if_fini $h3
-}
-
-switch_create()
-{
-	# pools
-	# -----
-
-	devlink_pool_size_thtype_save 0
-	devlink_pool_size_thtype_save 4
-	devlink_pool_size_thtype_save 1
-	devlink_pool_size_thtype_save 5
-	devlink_pool_size_thtype_save 2
-	devlink_pool_size_thtype_save 6
-
-	devlink_port_pool_th_save $swp1 1
-	devlink_port_pool_th_save $swp2 6
-	devlink_port_pool_th_save $swp3 5
-	devlink_port_pool_th_save $swp4 2
-	devlink_port_pool_th_save $swp5 2
-
-	devlink_tc_bind_pool_th_save $swp1 1 ingress
-	devlink_tc_bind_pool_th_save $swp2 1 egress
-	devlink_tc_bind_pool_th_save $swp3 1 egress
-	devlink_tc_bind_pool_th_save $swp4 1 ingress
-	devlink_tc_bind_pool_th_save $swp5 1 ingress
-
-	# Control traffic pools. Just reduce the size.
-	devlink_pool_size_thtype_set 0 dynamic $_500KB
-	devlink_pool_size_thtype_set 4 dynamic $_500KB
-
-	# Stream modeling pools.
-	devlink_pool_size_thtype_set 1 dynamic $_500KB
-	devlink_pool_size_thtype_set 5 dynamic $_500KB
-
-	# Burst soak pools.
-	devlink_pool_size_thtype_set 2 static $POOL_SIZE
-	devlink_pool_size_thtype_set 6 static $POOL_SIZE
-
-	# $swp1
-	# -----
-
-	ip link set dev $swp1 up
-	mtu_set $swp1 10000
-	vlan_create $swp1 111
-	ip link set dev $swp1.111 type vlan ingress-qos-map 0:0 1:1
-
-	devlink_port_pool_th_set $swp1 1 16
-	devlink_tc_bind_pool_th_set $swp1 1 ingress 1 16
-
-	# Configure qdisc...
-	tc qdisc replace dev $swp1 root handle 1: \
-	   ets bands 8 strict 8 priomap 7 6
-	# ... so that we can assign prio1 traffic to PG1.
-	dcb buffer set dev $swp1 prio-buffer all:0 1:1
-
-	# $swp2
-	# -----
-
-	ip link set dev $swp2 up
-	mtu_set $swp2 10000
-	ethtool -s $swp2 speed 1000 autoneg off
-	vlan_create $swp2 111
-	ip link set dev $swp2.111 type vlan egress-qos-map 0:0 1:1
-
-	devlink_port_pool_th_set $swp2 6 $POOL_SIZE
-	devlink_tc_bind_pool_th_set $swp2 1 egress 6 $POOL_SIZE
-
-	# prio 0->TC0 (band 7), 1->TC1 (band 6)
-	tc qdisc replace dev $swp2 root handle 1: \
-	   ets bands 8 strict 8 priomap 7 6
-
-	# $swp3
-	# -----
-
-	ip link set dev $swp3 up
-	mtu_set $swp3 10000
-	ethtool -s $swp3 speed 1000 autoneg off
-	vlan_create $swp3 111
-	ip link set dev $swp3.111 type vlan egress-qos-map 0:0 1:1
-
-	devlink_port_pool_th_set $swp3 5 16
-	devlink_tc_bind_pool_th_set $swp3 1 egress 5 16
-
-	# prio 0->TC0 (band 7), 1->TC1 (band 6)
-	tc qdisc replace dev $swp3 root handle 1: \
-	   ets bands 8 strict 8 priomap 7 6
-
-	# $swp4
-	# -----
-
-	ip link set dev $swp4 up
-	mtu_set $swp4 10000
-	ethtool -s $swp4 speed 1000 autoneg off
-	vlan_create $swp4 111
-	ip link set dev $swp4.111 type vlan ingress-qos-map 0:0 1:1
-
-	devlink_port_pool_th_set $swp4 2 $POOL_SIZE
-	devlink_tc_bind_pool_th_set $swp4 1 ingress 2 $POOL_SIZE
-
-	# Configure qdisc...
-	tc qdisc replace dev $swp4 root handle 1: \
-	   ets bands 8 strict 8 priomap 7 6
-	# ... so that we can assign prio1 traffic to PG1.
-	dcb buffer set dev $swp4 prio-buffer all:0 1:1
-
-	# $swp5
-	# -----
-
-	ip link set dev $swp5 up
-	mtu_set $swp5 10000
-	vlan_create $swp5 111
-	ip link set dev $swp5.111 type vlan ingress-qos-map 0:0 1:1
-
-	devlink_port_pool_th_set $swp5 2 $POOL_SIZE
-	devlink_tc_bind_pool_th_set $swp5 1 ingress 2 $POOL_SIZE
-
-	# Configure qdisc...
-	tc qdisc replace dev $swp5 root handle 1: \
-	   ets bands 8 strict 8 priomap 7 6
-	# ... so that we can assign prio1 traffic to PG1.
-	dcb buffer set dev $swp5 prio-buffer all:0 1:1
-
-	# bridges
-	# -------
-
-	ip link add name br1 type bridge vlan_filtering 0
-	ip link set dev $swp1.111 master br1
-	ip link set dev $swp3.111 master br1
-	ip link set dev br1 up
-
-	ip link add name br2 type bridge vlan_filtering 0
-	ip link set dev $swp2.111 master br2
-	ip link set dev $swp4.111 master br2
-	ip link set dev $swp5.111 master br2
-	ip link set dev br2 up
-}
-
-switch_destroy()
-{
-	# Do this first so that we can reset the limits to values that are only
-	# valid for the original static / dynamic setting.
-	devlink_pool_size_thtype_restore 6
-	devlink_pool_size_thtype_restore 5
-	devlink_pool_size_thtype_restore 4
-	devlink_pool_size_thtype_restore 2
-	devlink_pool_size_thtype_restore 1
-	devlink_pool_size_thtype_restore 0
-
-	# bridges
-	# -------
-
-	ip link set dev br2 down
-	ip link set dev $swp5.111 nomaster
-	ip link set dev $swp4.111 nomaster
-	ip link set dev $swp2.111 nomaster
-	ip link del dev br2
-
-	ip link set dev br1 down
-	ip link set dev $swp3.111 nomaster
-	ip link set dev $swp1.111 nomaster
-	ip link del dev br1
-
-	# $swp5
-	# -----
-
-	dcb buffer set dev $swp5 prio-buffer all:0
-	tc qdisc del dev $swp5 root
-
-	devlink_tc_bind_pool_th_restore $swp5 1 ingress
-	devlink_port_pool_th_restore $swp5 2
-
-	vlan_destroy $swp5 111
-	mtu_restore $swp5
-	ip link set dev $swp5 down
-
-	# $swp4
-	# -----
-
-	dcb buffer set dev $swp4 prio-buffer all:0
-	tc qdisc del dev $swp4 root
-
-	devlink_tc_bind_pool_th_restore $swp4 1 ingress
-	devlink_port_pool_th_restore $swp4 2
-
-	vlan_destroy $swp4 111
-	ethtool -s $swp4 autoneg on
-	mtu_restore $swp4
-	ip link set dev $swp4 down
-
-	# $swp3
-	# -----
-
-	tc qdisc del dev $swp3 root
-
-	devlink_tc_bind_pool_th_restore $swp3 1 egress
-	devlink_port_pool_th_restore $swp3 5
-
-	vlan_destroy $swp3 111
-	ethtool -s $swp3 autoneg on
-	mtu_restore $swp3
-	ip link set dev $swp3 down
-
-	# $swp2
-	# -----
-
-	tc qdisc del dev $swp2 root
-
-	devlink_tc_bind_pool_th_restore $swp2 1 egress
-	devlink_port_pool_th_restore $swp2 6
-
-	vlan_destroy $swp2 111
-	ethtool -s $swp2 autoneg on
-	mtu_restore $swp2
-	ip link set dev $swp2 down
-
-	# $swp1
-	# -----
-
-	dcb buffer set dev $swp1 prio-buffer all:0
-	tc qdisc del dev $swp1 root
-
-	devlink_tc_bind_pool_th_restore $swp1 1 ingress
-	devlink_port_pool_th_restore $swp1 1
-
-	vlan_destroy $swp1 111
-	mtu_restore $swp1
-	ip link set dev $swp1 down
-}
-
-setup_prepare()
-{
-	h1=${NETIFS[p1]}
-	swp1=${NETIFS[p2]}
-
-	swp2=${NETIFS[p3]}
-	h2=${NETIFS[p4]}
-
-	swp3=${NETIFS[p5]}
-	swp4=${NETIFS[p6]}
-
-	swp5=${NETIFS[p7]}
-	h3=${NETIFS[p8]}
-
-	h2mac=$(mac_get $h2)
-
-	vrf_prepare
-
-	h1_create
-	h2_create
-	h3_create
-	switch_create
-}
-
-cleanup()
-{
-	pre_cleanup
-
-	switch_destroy
-	h3_destroy
-	h2_destroy
-	h1_destroy
-
-	vrf_cleanup
-}
-
-ping_ipv4()
-{
-	ping_test $h1 192.0.2.34 " h1->h2"
-	ping_test $h3 192.0.2.34 " h3->h2"
-}
-
-__test_qos_burst()
-{
-	local pktsize=$1; shift
-
-	RET=0
-
-	start_traffic_pktsize $pktsize $h1.111 192.0.2.33 192.0.2.34 $h2mac
-	sleep 1
-
-	local q0=$(ethtool_stats_get $swp2 tc_transmit_queue_tc_1)
-	((q0 == 0))
-	check_err $? "Transmit queue non-zero?"
-
-	local d0=$(ethtool_stats_get $swp2 tc_no_buffer_discard_uc_tc_1)
-
-	local cell_size=$(devlink_cell_size_get)
-	local cells=$((BURST_SIZE / cell_size))
-	# Each packet is $pktsize of payload + headers.
-	local pkt_cells=$(((pktsize + 50 + cell_size - 1)  / cell_size))
-	# How many packets can we admit:
-	local pkts=$((cells / pkt_cells))
-
-	$MZ $h3 -p $pktsize -Q 1:111 -A 192.0.2.35 -B 192.0.2.34 \
-		-a own -b $h2mac -c $pkts -t udp -q
-	sleep 1
-
-	local d1=$(ethtool_stats_get $swp2 tc_no_buffer_discard_uc_tc_1)
-	((d1 == d0))
-	check_err $? "Drops seen on egress port: $d0 -> $d1 ($((d1 - d0)))"
-
-	# Check that the queue is somewhat close to the burst size This
-	# makes sure that the lack of drops above was not due to port
-	# undersubscribtion.
-	local q0=$(ethtool_stats_get $swp2 tc_transmit_queue_tc_1)
-	local qe=$((90 * BURST_SIZE / 100))
-	((q0 > qe))
-	check_err $? "Queue size expected >$qe, got $q0"
-
-	stop_traffic
-	sleep 2
-
-	log_test "Burst: absorb $pkts ${pktsize}-B packets"
-}
-
-test_8K()
-{
-	__test_qos_burst 8000
-}
-
-test_800()
-{
-	__test_qos_burst 800
-}
-
-bail_on_lldpad
-
-trap cleanup EXIT
-setup_prepare
-setup_wait
-tests_run
-
-exit $EXIT_STATUS
-- 
2.35.3

