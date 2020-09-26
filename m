Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F74B2795BA
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgIZA5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729852AbgIZA45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 20:56:57 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0478F235FD;
        Sat, 26 Sep 2020 00:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601081817;
        bh=bk8fFg4p/NB/Pl/fp/+q43i0UvY8Y7EsogHYum29xXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v70EL98jEm0YXxgzOb/I6oSk8JWgZ998Xt499s+sOFc5pbtg54HCtsBuUT8JDx/eq
         Jgrp2M6gKYuvzZPyD21pmNEtOjd1KggzyJxfZcKNN2vGw4tpvAAy1GcRWJt44+jFLA
         W0N0gRpD0W4D7BYZp9ScddJ3Sa48vNONuz+5s0/s=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 04/10] selftests: net: add a test for shared UDP tunnel info tables
Date:   Fri, 25 Sep 2020 17:56:43 -0700
Message-Id: <20200926005649.3285089-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926005649.3285089-1-kuba@kernel.org>
References: <20200926005649.3285089-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test run of checks validating the shared UDP tunnel port
tables function as we expect.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../drivers/net/netdevsim/udp_tunnel_nic.sh   | 109 ++++++++++++++++++
 1 file changed, 109 insertions(+)
 mode change 100644 => 100755 tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh b/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
old mode 100644
new mode 100755
index ba1d53b9f815..9225133784af
--- a/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
@@ -775,6 +775,115 @@ for port in 0 1; do
     exp1=( 0 0 0 0 )
 done
 
+cleanup_nsim
+
+# shared port tables
+pfx="table sharing"
+
+echo $NSIM_ID > /sys/bus/netdevsim/new_device
+echo 0 > $NSIM_DEV_SYS/del_port
+
+echo 0 > $NSIM_DEV_DFS/udp_ports_open_only
+echo 1 > $NSIM_DEV_DFS/udp_ports_sleep
+echo 1 > $NSIM_DEV_DFS/udp_ports_shared
+
+old_netdevs=$(ls /sys/class/net)
+echo 1 > $NSIM_DEV_SYS/new_port
+NSIM_NETDEV=`get_netdev_name old_netdevs`
+old_netdevs=$(ls /sys/class/net)
+echo 2 > $NSIM_DEV_SYS/new_port
+NSIM_NETDEV2=`get_netdev_name old_netdevs`
+
+msg="VxLAN v4 devices"
+exp0=( `mke 4789 1` 0 0 0 )
+exp1=( 0 0 0 0 )
+new_vxlan vxlan0 4789 $NSIM_NETDEV
+new_vxlan vxlan1 4789 $NSIM_NETDEV2
+
+msg="VxLAN v4 devices go down"
+exp0=( 0 0 0 0 )
+ifconfig vxlan1 down
+ifconfig vxlan0 down
+check_tables
+
+for ifc in vxlan0 vxlan1; do
+    ifconfig $ifc up
+done
+
+msg="VxLAN v6 device"
+exp0=( `mke 4789 1` `mke 4790 1` 0 0 )
+new_vxlan vxlanC 4790 $NSIM_NETDEV 6
+
+msg="Geneve device"
+exp1=( `mke 6081 2` 0 0 0 )
+new_geneve gnv0 6081
+
+msg="NIC device goes down"
+ifconfig $NSIM_NETDEV down
+check_tables
+
+msg="NIC device goes up again"
+ifconfig $NSIM_NETDEV up
+check_tables
+
+for i in `seq 2`; do
+    msg="turn feature off - 1, rep $i"
+    ethtool -K $NSIM_NETDEV rx-udp_tunnel-port-offload off
+    check_tables
+
+    msg="turn feature off - 2, rep $i"
+    exp0=( 0 0 0 0 )
+    exp1=( 0 0 0 0 )
+    ethtool -K $NSIM_NETDEV2 rx-udp_tunnel-port-offload off
+    check_tables
+
+    msg="turn feature on - 1, rep $i"
+    exp0=( `mke 4789 1` `mke 4790 1` 0 0 )
+    exp1=( `mke 6081 2` 0 0 0 )
+    ethtool -K $NSIM_NETDEV rx-udp_tunnel-port-offload on
+    check_tables
+
+    msg="turn feature on - 2, rep $i"
+    ethtool -K $NSIM_NETDEV2 rx-udp_tunnel-port-offload on
+    check_tables
+done
+
+msg="tunnels destroyed 1"
+cleanup_tuns
+exp0=( 0 0 0 0 )
+exp1=( 0 0 0 0 )
+check_tables
+
+overflow_table0 "overflow NIC table"
+
+msg="re-add a port"
+
+echo 2 > $NSIM_DEV_SYS/del_port
+echo 2 > $NSIM_DEV_SYS/new_port
+check_tables
+
+msg="replace VxLAN in overflow table"
+exp0=( `mke 10000 1` `mke 10004 1` `mke 10002 1` `mke 10003 1` )
+del_dev vxlan1
+
+msg="vacate VxLAN in overflow table"
+exp0=( `mke 10000 1` `mke 10004 1` 0 `mke 10003 1` )
+del_dev vxlan2
+
+echo 1 > $NSIM_DEV_DFS/ports/$port/udp_ports_reset
+check_tables
+
+msg="tunnels destroyed 2"
+cleanup_tuns
+exp0=( 0 0 0 0 )
+exp1=( 0 0 0 0 )
+check_tables
+
+echo 1 > $NSIM_DEV_SYS/del_port
+echo 2 > $NSIM_DEV_SYS/del_port
+
+cleanup_nsim
+
 modprobe -r netdevsim
 
 if [ $num_errors -eq 0 ]; then
-- 
2.26.2

