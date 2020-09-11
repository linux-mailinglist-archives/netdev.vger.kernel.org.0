Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093F226693C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 21:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgIKTxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 15:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbgIKTxJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 15:53:09 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A26662220E;
        Fri, 11 Sep 2020 19:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599853989;
        bh=e+iu3g+odibO937wxbU1JF1UHo75F87EhphvuzygCVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWUSM37h7IN5C4EaCZAZMnZRmLwsa1zl72IZvSkX7t4Ii+jn4njLRtY4oibbSF+YY
         O+O79bNWEz9MZpgIGPKFkKvfPESMWnCdHxA2DJ9k1k7d9xjKIoqnpCFKl2pF5HRQp/
         RvdKDU2m3Cvd5R5WditpDzsywEaSbLpT5l8xSq0Q=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/8] selftests: add a test for ethtool pause stats
Date:   Fri, 11 Sep 2020 12:52:54 -0700
Message-Id: <20200911195258.1048468-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200911195258.1048468-1-kuba@kernel.org>
References: <20200911195258.1048468-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the empty nest is reported even without stats.
Make sure reporting only selected stats works fine.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../drivers/net/netdevsim/ethtool-pause.sh    | 108 ++++++++++++++++++
 1 file changed, 108 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh b/tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh
new file mode 100755
index 000000000000..dd6ad6501c9c
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh
@@ -0,0 +1,108 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+
+NSIM_ID=$((RANDOM % 1024))
+NSIM_DEV_SYS=/sys/bus/netdevsim/devices/netdevsim$NSIM_ID
+NSIM_DEV_DFS=/sys/kernel/debug/netdevsim/netdevsim$NSIM_ID
+NSIM_NETDEV=
+num_passes=0
+num_errors=0
+
+function cleanup_nsim {
+    if [ -e $NSIM_DEV_SYS ]; then
+	echo $NSIM_ID > /sys/bus/netdevsim/del_device
+    fi
+}
+
+function cleanup {
+    cleanup_nsim
+}
+
+trap cleanup EXIT
+
+function get_netdev_name {
+    local -n old=$1
+
+    new=$(ls /sys/class/net)
+
+    for netdev in $new; do
+	for check in $old; do
+            [ $netdev == $check ] && break
+	done
+
+	if [ $netdev != $check ]; then
+	    echo $netdev
+	    break
+	fi
+    done
+}
+
+function check {
+    local code=$1
+    local str=$2
+    local exp_str=$3
+
+    if [ $code -ne 0 ]; then
+	((num_errors++))
+	return
+    fi
+
+    if [ "$str" != "$exp_str"  ]; then
+	echo -e "Expected: '$exp_str', got '$str'"
+	((num_errors++))
+	return
+    fi
+
+    ((num_passes++))
+}
+
+# Bail if ethtool is too old
+if ! ethtool -h | grep include-stat 2>&1 >/dev/null; then
+    echo "SKIP: No --include-statistics support in ethtool"
+    exit 4
+fi
+
+# Make a netdevsim
+old_netdevs=$(ls /sys/class/net)
+
+modprobe netdevsim
+echo $NSIM_ID > /sys/bus/netdevsim/new_device
+
+NSIM_NETDEV=`get_netdev_name old_netdevs`
+
+set -o pipefail
+
+echo n > $NSIM_DEV_DFS/ethtool/pause/report_stats_tx
+echo n > $NSIM_DEV_DFS/ethtool/pause/report_stats_rx
+
+s=$(ethtool --json -a $NSIM_NETDEV | jq '.[].statistics')
+check $? "$s" "null"
+
+s=$(ethtool -I --json -a $NSIM_NETDEV | jq '.[].statistics')
+check $? "$s" "{}"
+
+echo y > $NSIM_DEV_DFS/ethtool/pause/report_stats_tx
+
+s=$(ethtool -I --json -a $NSIM_NETDEV | jq '.[].statistics | length')
+check $? "$s" "1"
+
+s=$(ethtool -I --json -a $NSIM_NETDEV | jq '.[].statistics.tx_pause_frames')
+check $? "$s" "2"
+
+echo y > $NSIM_DEV_DFS/ethtool/pause/report_stats_rx
+
+s=$(ethtool -I --json -a $NSIM_NETDEV | jq '.[].statistics | length')
+check $? "$s" "2"
+
+s=$(ethtool -I --json -a $NSIM_NETDEV | jq '.[].statistics.rx_pause_frames')
+check $? "$s" "1"
+s=$(ethtool -I --json -a $NSIM_NETDEV | jq '.[].statistics.tx_pause_frames')
+check $? "$s" "2"
+
+if [ $num_errors -eq 0 ]; then
+    echo "PASSED all $((num_passes)) checks"
+    exit 0
+else
+    echo "FAILED $num_errors/$((num_errors+num_passes)) checks"
+    exit 1
+fi
-- 
2.26.2

