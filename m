Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA0067D258
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjAZRCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbjAZRCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:02:10 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED98A2B637
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:02:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uvco43R5s6ZT/WK5xe3hYFinwNqchTNpnD0rpuWDpZ9gqqgcbWIfvICEl2OAzJHONpMoUhk3RjaDfGVLGpQo3+SFCjkstepoxpFUD+QryaWaDKbapAUMWpX6H0Z/5muvdTVGOPhantMNPsC4lD7gdUp6oiuRc1QNJd3N3nkcTlTJte8O2UFn7+gqulidEC8KG7ycB6J3O45zWVG0KS4JmJSMFIRs5Rmcs3FNDFyPIv1Ypo5STd7PpHRE+IevP6JrQNG+VdJLjzylnqrtZW8MHVpEt5opIKYg1seJE+Kyt/QpttCcbMNwRQLAVQH3vHi0ruxeAkjxEFv+EEofoNEYYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xOCr523mzKItGXdE26z8vzFu+vo9cyaFmxTQOXoHOig=;
 b=jtJyP4zY++ExFWZClne7SdNRsxoc/33oNd8IlXizVx18zvf5W4VSPeKj09hxyqs36ZpNK4fDZdNWx7KpMEbCBvyNxK+bcFhpim/j8l6rI5KLYLrZN7C6a8dI4pH9/1l2F6RstcQT2/m5QId0LD7FDq/0/VHh2mARA4Iw1DO65h8duJiGZw9DSinL3Z7tqlu+0GibkZieJjl3ZQi/7nxzpkZHffnSOYYX6FmC30E0SYmrsjoLOZs7O8IQoK03pIfGeIVoCIYf8RbhYIR0PqtRRNh6ufdZBxgAEvltsDWTR4XXjcy9sPjYH1QwMsl1IKCrHvhCXd+YO4eVaHb8/Bu96A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOCr523mzKItGXdE26z8vzFu+vo9cyaFmxTQOXoHOig=;
 b=IfQCA9wYM91om3IYaHtBHaK4+vW8IX8kQvyQYYkV8IaFeozIf7D6lrjuHzh3Eu//vh16MbTYgEKRIzRdBgJzTTaW4N55ZDVea4/FlYjZ3JBfqUdvBsTLp37gfDSWIG17c/TLwtTw/Eyw2yS0gcM/BDTjH5CsOtnbJvbIohVRuSIcsjW9WtCjBX5SRFlBSQNoPw9Ylz/rD9coboTU2t/42pHo0h4OXky3QnkZasvzKg2lP38RNiVqKohjXB+nGmX/cJCCPwo63q5jVxrVb/xN3EG7n1XQ0/rPjGQ5pOCVAqyiX11c058IHxQ1WLgPHR09W9oc0ZzSBUtyubvmZYtlDQ==
Received: from MW4PR04CA0294.namprd04.prod.outlook.com (2603:10b6:303:89::29)
 by DS0PR12MB6581.namprd12.prod.outlook.com (2603:10b6:8:d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 26 Jan
 2023 17:02:04 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::13) by MW4PR04CA0294.outlook.office365.com
 (2603:10b6:303:89::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.17 via Frontend Transport; Thu, 26 Jan 2023 17:02:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:01:51 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:01:48 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>
CC:     <bridge@lists.linux-foundation.org>,
        Petr Machata <petrm@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>
Subject: [PATCH net-next 00/16] bridge: Limit number of MDB entries per port, port-vlan
Date:   Thu, 26 Jan 2023 18:01:08 +0100
Message-ID: <cover.1674752051.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT035:EE_|DS0PR12MB6581:EE_
X-MS-Office365-Filtering-Correlation-Id: aa7066f3-44d5-4b3b-a52f-08daffbf0c70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: djdaTDD8Mdd3vA5xxSoJBfWQAbXKRP9L3wx465AvGDTRHC+aIw2dszPWcb+QKZQ536l78laSDsSocz7yaLWHzjhPvZX6UloYTbcI9amP7amTo3iV8ZEjSelOQYQHZyGvryYqAery3ih4sMRpLgd+zObOBoLcuJcf7qLowQO173XNNwih/AGakOY9XFTPTFNhJcAFM6tWCuUfmT6KV3dV4YMOVyIOi+5FG3E4jGXXFwM082177shMVo0znXDiC16yCqKqOJKqD/YFqYadH9KZH+NoH+yZrHpgtAnzf6tLbhHDiOnlHsGOztM/Xhk13MKCvfgUSbl7aeZgXURb/BMbdVs7g6aVeBN1t6x92TLsPQv2rtmGCqHgk2g6EfPsMJr+Fxcnuv1vy798bfxDEaATx14w+CnCWW8x63ltTa+Umn+wm/8MP0NA9h6vwnk7ko+4+EZ8g3WVtdDs4LFWMM7IDaMi0Yi2pYl3dyUvrI/MV7r01e97md+95XbWk5TFMZMnxoiM+JloNdwbw/GnNCJXCuq9FUx0bdqb+0WFb1K2Ek/CUsfNsmEwBBx41wm1QODpYM1T41F5ijOFAZCJBWmmmfcGTJly72tOUZ2yWBHRnvBHEtKp1QIyR6ORKnsN4OoBinZ4w6lE1e40dPQnW5ddP0w8NpmHV6IWZdAq6Da1eoPRlOOwejuJVmZeKe+pQvAzGgVl7LY9N/2TBECAgcNwSA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199018)(36840700001)(46966006)(40470700004)(5660300002)(70206006)(2906002)(26005)(316002)(82310400005)(478600001)(186003)(110136005)(4326008)(2616005)(336012)(40460700003)(83380400001)(8936002)(8676002)(16526019)(86362001)(36860700001)(356005)(70586007)(40480700001)(7636003)(6666004)(36756003)(54906003)(107886003)(47076005)(41300700001)(82740400003)(426003)(66899018);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:03.7798
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa7066f3-44d5-4b3b-a52f-08daffbf0c70
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6581
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDB maintained by the bridge is limited. When the bridge is configured
for IGMP / MLD snooping, a buggy or malicious client can easily exhaust its
capacity. In SW datapath, the capacity is configurable through the
IFLA_BR_MCAST_HASH_MAX parameter, but ultimately is finite. Obviously a
similar limit exists in the HW datapath for purposes of offloading.

In order to prevent the issue of unilateral exhaustion of MDB resources,
introduce two parameters in each of two contexts:

- Per-port and (when BROPT_MCAST_VLAN_SNOOPING_ENABLED is enabled)
  per-port-VLAN number of MDB entries that the port is member in.

- Per-port and (when BROPT_MCAST_VLAN_SNOOPING_ENABLED is enabled)
  per-port-VLAN maximum permitted number of MDB entries, or 0 for
  no limit.

Per-port number of entries keeps track of the total number of MDB entries
configured on a given port. The per-port-VLAN value then keeps track of the
subset of MDB entries configured specifically for the given VLAN, on that
port. The number is adjusted as port_groups are created and deleted, and
therefore under multicast lock.

A maximum value, if non-zero, then places a limit on the number of entries
that can be configured in a given context. Attempts to add entries above
the maximum are rejected.

Rejection reason of netlink-based requests to add MDB entries is
communicated through extack. This channel is unavailable for rejections
triggered from the control path. To address this lack of visibility, the
patchset adds a tracepoint, bridge:br_mdb_full:

	# perf record -e bridge:br_mdb_full &
	# [...]
	# perf script | cut -d: -f4-
	 dev v2 af 2 src 192.0.2.1/:: grp 239.1.1.1/::/00:00:00:00:00:00 vid 0
	 dev v2 af 10 src 0.0.0.0/2001:db8:1::1 grp 0.0.0.0/ff0e::1/00:00:00:00:00:00 vid 0
	 dev v2 af 2 src 192.0.2.1/:: grp 239.1.1.1/::/00:00:00:00:00:00 vid 10
	 dev v2 af 10 src 0.0.0.0/2001:db8:1::1 grp 0.0.0.0/ff0e::1/00:00:00:00:00:00 vid 10

This tracepoint is triggered for mcast_hash_max exhaustions as well.

The following is an example of how the feature is used. A more extensive
example is available in patch #8:

	# bridge vlan set dev v1 vid 1 mcast_max_groups 1
	# bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 1
	# bridge mdb add dev br port v1 grp 230.1.2.4 temp vid 1
	Error: bridge: Port-VLAN is already a member in mcast_max_groups (1) groups.

The patchset progresses as follows:

- In patch #1, set strict_start_type at two bridge-related policies. The
  reason is we are adding a new attribute to one of these, and want the new
  attribute to be parsed strictly. The other was adjusted for completeness'
  sake.

- In patches #2 to #5, br_mdb and br_multicast code is adjusted to make the
  following additions smoother.

- In patch #6, add the tracepoint.

- In patch #7, the code to maintain number of MDB entries is added as
  struct net_bridge_mcast_port::mdb_n_entries. The maximum is added, too,
  as struct net_bridge_mcast_port::mdb_max_entries, however at this point
  there is no way to set the value yet, and since 0 is treated as "no
  limit", the functionality doesn't change at this point. Note however,
  that mcast_hash_max violations already do trigger at this point.

- In patch #8, netlink plumbing is added: reading of number of entries, and
  reading and writing of maximum.

  The per-port values are passed through RTM_NEWLINK / RTM_GETLINK messages
  in IFLA_BRPORT_MCAST_N_GROUPS and _MAX_GROUPS, inside IFLA_PROTINFO nest.

  The per-port-vlan values are passed through RTM_GETVLAN / RTM_NEWVLAN
  messages in BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS, _MAX_GROUPS, inside
  BRIDGE_VLANDB_ENTRY.

The following patches deal with the selftest:

- Patches #9 and #10 clean up and move around some selftest code.

- Patches #11 to #14 add helpers and generalize the existing IGMP / MLD
  support to allow generating packets with configurable group addresses and
  varying source lists for (S,G) memberships.

- Patch #15 adds code to generate IGMP leave and MLD done packets.

- Patch #16 finally adds the selftest itself.

Petr Machata (16):
  net: bridge: Set strict_start_type at two policies
  net: bridge: Add extack to br_multicast_new_port_group()
  net: bridge: Move extack-setting to br_multicast_new_port_group()
  net: bridge: Add br_multicast_del_port_group()
  net: bridge: Change a cleanup in br_multicast_new_port_group() to goto
  net: bridge: Add a tracepoint for MDB overflows
  net: bridge: Maintain number of MDB entries in net_bridge_mcast_port
  net: bridge: Add netlink knobs for number / maximum MDB entries
  selftests: forwarding: Move IGMP- and MLD-related functions to lib
  selftests: forwarding: bridge_mdb: Fix a typo
  selftests: forwarding: lib: Add helpers for IP address handling
  selftests: forwarding: lib: Add helpers for checksum handling
  selftests: forwarding: lib: Parameterize IGMPv3/MLDv2 generation
  selftests: forwarding: lib: Allow list of IPs for IGMPv3/MLDv2
  selftests: forwarding: lib: Add helpers to build IGMP/MLD leave
    packets
  selftests: forwarding: bridge_mdb_max: Add a new selftest

 include/trace/events/bridge.h                 |  67 ++
 include/uapi/linux/if_bridge.h                |   2 +
 include/uapi/linux/if_link.h                  |   2 +
 net/bridge/br_mdb.c                           |  17 +-
 net/bridge/br_multicast.c                     | 255 ++++-
 net/bridge/br_netlink.c                       |  21 +-
 net/bridge/br_netlink_tunnel.c                |   3 +
 net/bridge/br_private.h                       |  22 +-
 net/bridge/br_vlan.c                          |  11 +-
 net/bridge/br_vlan_options.c                  |  33 +-
 net/core/net-traces.c                         |   1 +
 net/core/rtnetlink.c                          |   2 +-
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/bridge_mdb.sh    |  60 +-
 .../net/forwarding/bridge_mdb_max.sh          | 970 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh | 216 ++++
 16 files changed, 1604 insertions(+), 79 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb_max.sh

-- 
2.39.0

