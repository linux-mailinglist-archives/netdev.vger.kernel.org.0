Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4823BD111
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbhGFLhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236488AbhGFLf2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D6F561E36;
        Tue,  6 Jul 2021 11:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570618;
        bh=zsY48qFw8ymrMeZel0vvj8wQaPvNdXU9ZoRorx8BPeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3SyQvuliCewA6drG66hnBcwQwKwJSo4zLanVnVt/b0OIIKMcYA8tOUF4LcG2RHma
         CxIhBs+AhQxbgXohQlU+IMjgU6JW+B2lls8dvcK/beaN74k5zG6gTFyj3mBsd4IyWa
         6Y4jFWnbFkVhRVl5p/cPqgaMqirg2uz66GNQ5u/v1WqAvpcI48rr2RS51XveobsZXF
         Pw9Ry+jXSAYdrCDQp+D7qeWJjT1acH0BpupI/nLRyolPDBf7hey0xrOeR6g1hShM0X
         lMCUgBpam7m4BgdeE3ja0ToLU0zo6QUFRp8xC+YHiJbp4D/75/AT0sJWc2JbJTZI9/
         ecbklVM/WRWUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amit Cohen <amcohen@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 073/137] selftests: Clean forgotten resources as part of cleanup()
Date:   Tue,  6 Jul 2021 07:20:59 -0400
Message-Id: <20210706112203.2062605-73-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit e67dfb8d15deb33c425d0b0ee22f2e5eef54c162 ]

Several tests do not set some ports down as part of their cleanup(),
resulting in IPv6 link-local addresses and associated routes not being
deleted.

These leaks were found using a BPF tool that monitors ASIC resources.

Solve this by setting the ports down at the end of the tests.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh       | 3 +++
 .../selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh  | 3 +++
 tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh   | 2 ++
 tools/testing/selftests/net/forwarding/pedit_dsfield.sh        | 2 ++
 tools/testing/selftests/net/forwarding/pedit_l4port.sh         | 2 ++
 tools/testing/selftests/net/forwarding/skbedit_priority.sh     | 2 ++
 6 files changed, 14 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
index f5abb1ebd392..269b2680611b 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
@@ -108,6 +108,9 @@ router_destroy()
 	__addr_add_del $rp1 del 192.0.2.2/24 2001:db8:1::2/64
 
 	tc qdisc del dev $rp2 clsact
+
+	ip link set dev $rp2 down
+	ip link set dev $rp1 down
 }
 
 setup_prepare()
diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
index 1fedfc9da434..1d157b1bd838 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
@@ -111,6 +111,9 @@ router_destroy()
 	__addr_add_del $rp1 del 192.0.2.2/24 2001:db8:1::2/64
 
 	tc qdisc del dev $rp2 clsact
+
+	ip link set dev $rp2 down
+	ip link set dev $rp1 down
 }
 
 setup_prepare()
diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
index 5cbff8038f84..28a570006d4d 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
@@ -93,7 +93,9 @@ switch_destroy()
 	lldptool -T -i $swp1 -V APP -d $(dscp_map 10) >/dev/null
 	lldpad_app_wait_del
 
+	ip link set dev $swp2 down
 	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 down
 	ip link set dev $swp1 nomaster
 	ip link del dev br1
 }
diff --git a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
index 55eeacf59241..64fbd211d907 100755
--- a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
+++ b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
@@ -75,7 +75,9 @@ switch_destroy()
 	tc qdisc del dev $swp2 clsact
 	tc qdisc del dev $swp1 clsact
 
+	ip link set dev $swp2 down
 	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 down
 	ip link set dev $swp1 nomaster
 	ip link del dev br1
 }
diff --git a/tools/testing/selftests/net/forwarding/pedit_l4port.sh b/tools/testing/selftests/net/forwarding/pedit_l4port.sh
index 5f20d289ee43..10e594c55117 100755
--- a/tools/testing/selftests/net/forwarding/pedit_l4port.sh
+++ b/tools/testing/selftests/net/forwarding/pedit_l4port.sh
@@ -71,7 +71,9 @@ switch_destroy()
 	tc qdisc del dev $swp2 clsact
 	tc qdisc del dev $swp1 clsact
 
+	ip link set dev $swp2 down
 	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 down
 	ip link set dev $swp1 nomaster
 	ip link del dev br1
 }
diff --git a/tools/testing/selftests/net/forwarding/skbedit_priority.sh b/tools/testing/selftests/net/forwarding/skbedit_priority.sh
index e3bd8a6bb8b4..bde11dc27873 100755
--- a/tools/testing/selftests/net/forwarding/skbedit_priority.sh
+++ b/tools/testing/selftests/net/forwarding/skbedit_priority.sh
@@ -72,7 +72,9 @@ switch_destroy()
 	tc qdisc del dev $swp2 clsact
 	tc qdisc del dev $swp1 clsact
 
+	ip link set dev $swp2 down
 	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 down
 	ip link set dev $swp1 nomaster
 	ip link del dev br1
 }
-- 
2.30.2

