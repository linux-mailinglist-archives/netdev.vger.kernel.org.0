Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0396885D5
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbjBBSAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjBBSAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:00:44 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA9569B37
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:00:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQvNpd4xHoR6Dz9i7ZhKEdd3PIRjDW6AVkvsTOTLN5qFHqlkaQVRwYizY+5nAGdBAkaRaJArLXJhaHH7HnoHU8Uhp7V57pj3Yg/I1BT2Gizi9mlA7x/qILXs5bjnm6gphYQWKieR0rF1CRG/w4as7UfOzzyBpovjE4hSSD+q9Nwm0gUl4Nsc6SMZngvUwOireWO1SPQULxuZPCXffS+E8FLyrbQ2tf5BF8PADBMQR0knQ5xBUN54WuuvCui4GkbNIoJoSvV9tQbBigYG1O8z9Ob4xe/Kk6wqSF9qx9g0Ed/v/vMtxSSNKN6r6RJbhcZ9upx7HvbOAhvj8yloEJuZKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RgdE+rEZCwwJSyQa67X6ou0o+cmC3q+MdmhTxlmAz/g=;
 b=Xhe9xTYNAQGyPRAw8WoQv8Exja+wiv3iZ0Yd5eahv7kLy/cxM2Q3kYfXYW3o95h3MnrryaF5e/02VBk5r1iaFstwJPcc4b62FIBtAJlfDVDr78IvobIQkPWqQXvDjeKsFd/R3ddZtAT0p2DfxWy+kdExgye7g+9UI0s6iji2oJv/39J2l46trcaJeTCDC5BH4ZGNawCWwovGnauUGmubGEvOMSmdXJI1N0YRDYw5s146av+xF6WaPAl9nFXFjaScaWVa0eYhCWEpktOeUTQoTK/5Y4zUXlqGNfuYOa7qyYWqk3bCskhEKYXoTJH960g3Kpjeq0jFqoxOfItT6hnZ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgdE+rEZCwwJSyQa67X6ou0o+cmC3q+MdmhTxlmAz/g=;
 b=Kb+kguJ/1HgN6tlkHZNeThZKrw6b1y66VRCvnIVNQZrnB4sLorx/5H746UaHRA3yPzFXQG3LxjsrmbqHGyM3mEVMLqdnOGcIkFo0/+78j6iwT04RxU/MTtUKgzcXsYnrbcvncWWrsgBXdic4SkfBSokid8rQzEORX+U/jv5g0DOKTKwPsZtC+vy8qgb9zLlA5P5wLwvMTSv+msUW2hw0MbbhAdiP7x+qKkWsLlgRz4dDIP6rVVQAVK1lVG67Jj2lheA8UOHv0JffeJJjWBf+7HYSaAmXFXkQ3QIflk0ZsY6BTVcQJHPcj8/Ai25AuvnfWGzPt4mG5bleN3nyiTpkFw==
Received: from MW4P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::18)
 by IA1PR12MB7688.namprd12.prod.outlook.com (2603:10b6:208:420::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 18:00:33 +0000
Received: from CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::cd) by MW4P222CA0013.outlook.office365.com
 (2603:10b6:303:114::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 18:00:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT082.mail.protection.outlook.com (10.13.175.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 18:00:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:13 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:10 -0800
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
Subject: [PATCH net-next v3 00/16] bridge: Limit number of MDB entries per port, port-vlan
Date:   Thu, 2 Feb 2023 18:59:18 +0100
Message-ID: <cover.1675359453.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT082:EE_|IA1PR12MB7688:EE_
X-MS-Office365-Filtering-Correlation-Id: 961f9073-b8fa-40ed-dfb5-08db054760ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A2sM/ZW6y/vc8ix9o/6x/Yxm5H5WaP2qn/6sRKwGlLPMEh1wpN2hqvVu0R1k7sicg947V6a0plC6+jfh/pR72RLgHZGSuW+g0nzTyvSyIpBAEC19HicXOJndQb/961/ipN+ptLjyoAz/wboiYQXYA37hs7txWYZa+g/+mmvmL2t07QwrYJ1zDNWcAUX6ZLYO0uxaLgHdj83Wx9LGS30iYYtxU3ocdISsTWhIaifj3m5aXnq84VKOO2f3XZx2zzcsVjqDGQ00OJ7xsGVbWr4vQmK7aGEZs4uMGkoCFauOVITbmq+1A4KeCb8xwkcqk9FcuXGU1ig//CzMMP6vU9lY1sRsXvwKkYTTHN6NTGn76CdUZbZ6InYAeNJR3mAT/HDmWwd8isedzaZsnOpvBXnUVO9aLSEa3oHYhrbPIUm0wEJwxTafoHkA/LSNj52m+do4HC/Q8DSdK6G5PYfwxaIgKi2nvGD3CKWtq+1Q8uqVfYHdcQyHMjJcI/Pgcordq9F6F4+W8QrUVcGeDWlPVanxL0jrHNHyGUb/N2xSgTw0kk6gg7GmJcm6jExQ/tpuXyM424N3UpVZStFhG/Dw3DR7j74Z+06Q2qKHUHPbbfIz/H6ncUgNwq6ME3F13mTbh8Uxbog+lRPIQHotFbk4ebwuCop63MJowb0J4lPDDtUEkytVIVRCq3lJlbXcm9OWOuwHLltR6hgzOSOYF9fFetgVzA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199018)(36840700001)(40470700004)(46966006)(356005)(86362001)(7636003)(36860700001)(36756003)(82740400003)(70206006)(70586007)(54906003)(110136005)(5660300002)(82310400005)(8936002)(316002)(4326008)(8676002)(47076005)(426003)(2906002)(336012)(40480700001)(83380400001)(2616005)(478600001)(40460700003)(26005)(186003)(66899018)(16526019)(107886003)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 18:00:32.6482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 961f9073-b8fa-40ed-dfb5-08db054760ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7688
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
	 dev v2 af 2 src ::ffff:0.0.0.0 grp ::ffff:239.1.1.112/00:00:00:00:00:00 vid 0
	 dev v2 af 10 src :: grp ff0e::112/00:00:00:00:00:00 vid 0
	 dev v2 af 2 src ::ffff:0.0.0.0 grp ::ffff:239.1.1.112/00:00:00:00:00:00 vid 10
	 dev v2 af 10 src 2001:db8:1::1 grp ff0e::1/00:00:00:00:00:00 vid 10
	 dev v2 af 2 src ::ffff:192.0.2.1 grp ::ffff:239.1.1.1/00:00:00:00:00:00 vid 10

Another option to consume the tracepoint is e.g. through the bpftrace tool:

	# bpftrace -e ' tracepoint:bridge:br_mdb_full /args->af != 0/ {
			    printf("dev %s src %s grp %s vid %u\n",
				   str(args->dev), ntop(args->src),
				   ntop(args->grp), args->vid);
			}
			tracepoint:bridge:br_mdb_full /args->af == 0/ {
			    printf("dev %s grp %s vid %u\n",
				   str(args->dev),
				   macaddr(args->grpmac), args->vid);
			}'

This tracepoint is triggered for mcast_hash_max exhaustions as well.

The following is an example of how the feature is used. A more extensive
example is available in patch #8:

	# bridge vlan set dev v1 vid 1 mcast_max_groups 1
	# bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 1
	# bridge mdb add dev br port v1 grp 230.1.2.4 temp vid 1
	Error: bridge: Port-VLAN is already in 1 groups, and mcast_max_groups=1.

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

v3:
- Patch #7:
    - Access mdb_max_/_n_entries through READ_/WRITE_ONCE
    - Move extack setting to br_multicast_port_ngroups_inc_one().
      Since we use NL_SET_ERR_MSG_FMT_MOD, the correct context
      (port / port-vlan) can be passed through an argument.
      This also removes the need for more READ/WRITE_ONCE's
      at the extack-setting site.
- Patch #8:
    - Move the br_multicast_port_ctx_vlan_disabled() check
      out to the _vlan_ helpers callers. Thus these helpers
      cannot fail, which makes them very similar to the
      _port_ helpers. Have them take the MC context directly
      and unify them.

v2:
- Cover letter:
    - Add an example of a bpftrace-based probe script
- Patch #6:
    - Report IPv4 as an IPv6-mapped address through the IPv6 buffer
      as well, to save ring buffer space.
- Patch #7:
    - In br_multicast_port_ngroups_inc_one(), bounce
      if n>=max, not if n==max
    - Adjust extack messages to mention ngroups, now
      that the bounces appear when n>=max, not n==max
    - In __br_multicast_enable_port_ctx(), do not reset
      max to 0. Also do not count number of entries by
      going through _inc, as that would end up incorrectly
      bouncing the entries.
- Patch #8:
    - Drop locks around accesses in
      br_multicast_{port,vlan}_ngroups_{get,set_max}(),
    - Drop bounces due to max<n in
      br_multicast_{port,vlan}_ngroups_set_max().
- Patch #12:
    - In the comment at payload_template_calc_checksum(),
      s/%#02x/%02x/, that's the mausezahn payload format.
- Patch #16:
    - Adjust the tests that check setting max below n and
      reset of max on VLAN snooping enablement
    - Make test naming uniform
    - Enable testing of control path (IGMP/MLD) in
      mcast_vlan_snooping bridge
    - Reorganize the code so that test instances (per bridge
      type and configuration type) always come right after
      the test, in order of {d,q,qvs}{4,6}{cfg,ctl}.
      Then groups of selftests are at the end of the file.
      Similarly adjust invocation order of the tests.

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

 include/trace/events/bridge.h                 |   58 +
 include/uapi/linux/if_bridge.h                |    2 +
 include/uapi/linux/if_link.h                  |    2 +
 net/bridge/br_mdb.c                           |   17 +-
 net/bridge/br_multicast.c                     |  179 ++-
 net/bridge/br_netlink.c                       |   19 +-
 net/bridge/br_netlink_tunnel.c                |    3 +
 net/bridge/br_private.h                       |   12 +-
 net/bridge/br_vlan.c                          |   11 +-
 net/bridge/br_vlan_options.c                  |   27 +-
 net/core/net-traces.c                         |    1 +
 net/core/rtnetlink.c                          |    2 +-
 .../testing/selftests/net/forwarding/Makefile |    1 +
 .../selftests/net/forwarding/bridge_mdb.sh    |   60 +-
 .../net/forwarding/bridge_mdb_max.sh          | 1336 +++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  216 +++
 16 files changed, 1867 insertions(+), 79 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb_max.sh

-- 
2.39.0

