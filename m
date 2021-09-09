Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0014E405FE2
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 01:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348814AbhIIXLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 19:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231814AbhIIXL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 19:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22440611BD;
        Thu,  9 Sep 2021 23:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631229017;
        bh=3YxsuiRXu/smKF4MR7FdUwElSK/efD1o+XDrBjXxq+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKLDkvZAeJ5mfJdofd6v00Ql38FCNvRcZq5Uax6iT9so9XPdYG1j/3DK2dPVHXuU4
         bxTRKIAIaQgNAxBCknj6yMKrsKWRdg+uOGm7kmhvahXLUrWT2VOFqXaLPeajzrFnc6
         ugyTcc6opeqM9bcafAsRrEF0weOJV830/I6UZueoJ4dhmKUKsFEXblUeV8edDXi9f3
         2gwsMdENDMevIClYgWddI/iF0DVl6s+4t9NvkjG5uKfutF10W7g6KH7E+u8WW6Ugo3
         rSJEKOw2n0lpNM4HOxVyHuNeeRwBTFTHmbPSF2/kywAqeG0jf6miV0Iz1Q4j3Ce+gX
         ucOmz4sUybcgg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 3/3] selftests: net: test ethtool -L vs mq
Date:   Thu,  9 Sep 2021 16:10:04 -0700
Message-Id: <20210909231004.196905-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210909231004.196905-1-kuba@kernel.org>
References: <20210909231004.196905-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a selftest for checking mq children are visible after ethtool -L.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../drivers/net/netdevsim/ethtool-common.sh   |  2 +-
 .../drivers/net/netdevsim/tc-mq-visibility.sh | 77 +++++++++++++++++++
 2 files changed, 78 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/tc-mq-visibility.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh b/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
index 7ca1f030d209..922744059aaa 100644
--- a/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
@@ -50,7 +50,7 @@ function make_netdev {
 	modprobe netdevsim
     fi
 
-    echo $NSIM_ID > /sys/bus/netdevsim/new_device
+    echo $NSIM_ID $@ > /sys/bus/netdevsim/new_device
     # get new device name
     ls /sys/bus/netdevsim/devices/netdevsim${NSIM_ID}/net/
 }
diff --git a/tools/testing/selftests/drivers/net/netdevsim/tc-mq-visibility.sh b/tools/testing/selftests/drivers/net/netdevsim/tc-mq-visibility.sh
new file mode 100755
index 000000000000..fd13c8cfb7a8
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/tc-mq-visibility.sh
@@ -0,0 +1,77 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+
+source ethtool-common.sh
+
+set -o pipefail
+
+n_children() {
+    n=$(tc qdisc show dev $NDEV | grep '^qdisc' | wc -l)
+    echo $((n - 1))
+}
+
+tcq() {
+    tc qdisc $1 dev $NDEV ${@:2}
+}
+
+n_child_assert() {
+    n=$(n_children)
+    if [ $n -ne $1 ]; then
+	echo "ERROR ($root): ${@:2}, expected $1 have $n"
+	((num_errors++))
+    else
+	((num_passes++))
+    fi
+}
+
+
+for root in mq mqprio; do
+    NDEV=$(make_netdev 1 4)
+
+    opts=
+    [ $root == "mqprio" ] && opts='hw 0 num_tc 1 map 0 0 0 0  queues 1@0'
+
+    tcq add root handle 100: $root $opts
+    n_child_assert 4 'Init'
+
+    # All defaults
+
+    for n in 3 2 1 2 3 4 1 4; do
+	ethtool -L $NDEV combined $n
+	n_child_assert $n "Change queues to $n while down"
+    done
+
+    ip link set dev $NDEV up
+
+    for n in 3 2 1 2 3 4 1 4; do
+	ethtool -L $NDEV combined $n
+	n_child_assert $n "Change queues to $n while up"
+    done
+
+    # One real one
+    tcq replace parent 100:4 handle 204: pfifo_fast
+    n_child_assert 4 "One real queue"
+
+    ethtool -L $NDEV combined 1
+    n_child_assert 2 "One real queue, one default"
+
+    ethtool -L $NDEV combined 4
+    n_child_assert 4 "One real queue, rest default"
+
+    # Graft some
+    tcq replace parent 100:1 handle 204:
+    n_child_assert 3 "Grafted"
+
+    ethtool -L $NDEV combined 1
+    n_child_assert 1 "Grafted, one"
+
+    cleanup_nsim
+done
+
+if [ $num_errors -eq 0 ]; then
+    echo "PASSED all $((num_passes)) checks"
+    exit 0
+else
+    echo "FAILED $num_errors/$((num_errors+num_passes)) checks"
+    exit 1
+fi
-- 
2.31.1

