Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23532795BE
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgIZA5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729867AbgIZA5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 20:57:00 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DB7D22211;
        Sat, 26 Sep 2020 00:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601081819;
        bh=+rpV0eReut7c1sB35IlsqV9MmGHAdcGiZu1ivuP5ngs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFIt5X9oUppemY+8qlQ4bnXdrP/OAA8MO2AJeLQYs42fQRKAuFpFNyb3/Heih0qH5
         bxMxPhnYUzSP1aWOn44R0Me+NAzRH09FgGykNCv8tuSdupaLnl0vXiir7vEC/erWGd
         xy1Upu6D6mfX5aPGQn1RNxonOCb7+qExYA4eBlDg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 09/10] selftests: net: add a test for static UDP tunnel ports
Date:   Fri, 25 Sep 2020 17:56:48 -0700
Message-Id: <20200926005649.3285089-10-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926005649.3285089-1-kuba@kernel.org>
References: <20200926005649.3285089-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN works as expected.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../drivers/net/netdevsim/udp_tunnel_nic.sh   | 58 +++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh b/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
index 9225133784af..1b08e042cf94 100755
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

