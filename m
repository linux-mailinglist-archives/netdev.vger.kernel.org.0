Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A3D22A34A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 01:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733190AbgGVXsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 19:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733042AbgGVXss (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 19:48:48 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CDAE22CA1;
        Wed, 22 Jul 2020 23:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595461727;
        bh=R4Nz1y6+aum+5jQvWt0Fj2x0+8k3UwBOljjjpqRRIP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynBSOh7qrv8SGsV1yMQvXtEOFb7AWyukU2aTMV5OhSOJ5ySEf79kTiKnBS9caBr37
         xT5Ji5fAfNL7GVx7eM+e4FTuKR/6vrMwOSdlPcAYq61Xjbk72clFSgsodR2CBggQNu
         r3d/43A7fx+QjAJhmxqP1+aOyscZaho7NUYGqHNM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC 4/4] selftests: net: add a test for static UDP tunnel ports
Date:   Wed, 22 Jul 2020 16:48:38 -0700
Message-Id: <20200722234838.3200228-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722234838.3200228-1-kuba@kernel.org>
References: <20200722234838.3200228-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN works as expected.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../drivers/net/netdevsim/udp_tunnel_nic.sh   | 58 +++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh b/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
index 9225133784af..1b08e042cf94 100644
--- a/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
@@ -7,6 +7,7 @@ NSIM_DEV_SYS=/sys/bus/netdevsim/devices/netdevsim$NSIM_ID
 NSIM_DEV_DFS=/sys/kernel/debug/netdevsim/netdevsim$NSIM_ID
 NSIM_NETDEV=
 HAS_ETHTOOL=
+STATIC_ENTRIES=
 EXIT_STATUS=0
 num_cases=0
 num_errors=0
@@ -193,6 +194,21 @@ function check_tables {
 	sleep 0.02
 	((retries--))
     done
+
+    if [ -n "$HAS_ETHTOOL" -a -n "${STATIC_ENTRIES[0]}" ]; then
+	fail=0
+	for i in "${!STATIC_ENTRIES[@]}"; do
+	    pp_expected=`pre_ethtool ${STATIC_ENTRIES[i]}`
+	    cnt=$(ethtool --show-tunnels $NSIM_NETDEV | grep -c "$pp_expected")
+	    if [ $cnt -ne 1 ]; then
+		err_cnt "ethtool static entry: $pfx - $msg"
+		echo "       check_table: ethtool does not contain '$pp_expected'"
+		ethtool --show-tunnels $NSIM_NETDEV
+		fail=1
+	    fi
+	done
+	[ $fail == 0 ] && pass_cnt
+    fi
 }
 
 function print_table {
@@ -884,6 +900,48 @@ echo 2 > $NSIM_DEV_SYS/del_port
 
 cleanup_nsim
 
+# Static IANA port
+pfx="static IANA vxlan"
+
+echo $NSIM_ID > /sys/bus/netdevsim/new_device
+echo 0 > $NSIM_DEV_SYS/del_port
+
+echo 1 > $NSIM_DEV_DFS/udp_ports_static_iana_vxlan
+STATIC_ENTRIES=( `mke 4789 1` )
+
+port=1
+old_netdevs=$(ls /sys/class/net)
+echo $port > $NSIM_DEV_SYS/new_port
+NSIM_NETDEV=`get_netdev_name old_netdevs`
+
+msg="check empty"
+exp0=( 0 0 0 0 )
+exp1=( 0 0 0 0 )
+check_tables
+
+msg="add on static port"
+new_vxlan vxlan0 4789 $NSIM_NETDEV
+new_vxlan vxlan1 4789 $NSIM_NETDEV
+
+msg="add on different port"
+exp0=( `mke 4790 1` 0 0 0 )
+new_vxlan vxlan2 4790 $NSIM_NETDEV
+
+cleanup_tuns
+
+msg="tunnels destroyed"
+exp0=( 0 0 0 0 )
+exp1=( 0 0 0 0 )
+check_tables
+
+msg="different type"
+new_geneve gnv0	4789
+
+cleanup_tuns
+cleanup_nsim
+
+# END
+
 modprobe -r netdevsim
 
 if [ $num_errors -eq 0 ]; then
-- 
2.26.2

