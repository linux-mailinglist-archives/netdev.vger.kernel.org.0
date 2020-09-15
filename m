Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B252269A3A
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 02:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgIOANn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 20:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgIOANL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 20:13:11 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69B6421D7B;
        Tue, 15 Sep 2020 00:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600128790;
        bh=XWlDCJ9SHtCClRFrBzW23zjeNWMz0gI0r4ruLe5po84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iyQNr6Vv0f2ReTzXxLP52VT5yO0p0hq8qj8xExFyIdbl9z3Sj8Z4chU7oI7z3Z4oc
         bZzPgvfV1KlItCgo/E9k4bCB621LQ5/uFZpKClIzntrMqJffTeNJMWpg6kC2gIjIF+
         H5Xy0yPQn1UUC2PnTtC/1BYPA5t63Hl9wVQXtqOs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, michael.chan@broadcom.com, saeedm@nvidia.com,
        tariqt@nvidia.com, andrew@lunn.ch, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 4/8] selftests: add a test for ethtool pause stats
Date:   Mon, 14 Sep 2020 17:11:55 -0700
Message-Id: <20200915001159.346469-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915001159.346469-1-kuba@kernel.org>
References: <20200915001159.346469-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the empty nest is reported even without stats.
Make sure reporting only selected stats works fine.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
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

