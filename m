Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2830A34DFD5
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhC3EAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhC3EAD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:00:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2F486198F;
        Tue, 30 Mar 2021 04:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617076803;
        bh=pLdXPT1+42EFZw3nBwPz8ltin1Iqm0NIb5m9smM3DQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8H1ml199Bs1q3O7Lcj5XQmJRg/DB8h0VY8eMlEiVddf7cLnw8BIl9LMr/wFFK17E
         YJH528Q01rPwZE3KTwfAeZehVgfHhEdTkRMDokxI/FQ6xpnS6jes44XJcYgw8HwdMy
         MfRtzZpy/fIyiEV8JgWUjKnmpbicv2u0JikR7EtZT7unXZYdNH/JylEJPLTA+5fisO
         5gY0mpAEhV6E+RWg0RpB3GQ48tl4vmL0dOPVziZdZtKx26ApUivC65vo1MFCkJEzC1
         jbLWeuZ5EhPZpQ5xve9EGBQyxpTS4iofZLQXozXswPHwE5uX0+FxqUChh9ecTmXgYS
         601aoxdyEC0Kg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, mkubecek@suse.cz, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/3] selftests: ethtool: add a netdevsim FEC test
Date:   Mon, 29 Mar 2021 20:59:54 -0700
Message-Id: <20210330035954.1206441-4-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330035954.1206441-1-kuba@kernel.org>
References: <20210330035954.1206441-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test FEC settings, iterate over configs.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../drivers/net/netdevsim/ethtool-common.sh   |   5 +-
 .../drivers/net/netdevsim/ethtool-fec.sh      | 110 ++++++++++++++++++
 2 files changed, 114 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-fec.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh b/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
index 9f64d5c7107b..7ca1f030d209 100644
--- a/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
@@ -24,8 +24,11 @@ function check {
     local code=$1
     local str=$2
     local exp_str=$3
+    local exp_fail=$4
 
-    if [ $code -ne 0 ]; then
+    [ -z "$exp_fail" ] && cop="-ne" || cop="-eq"
+
+    if [ $code $cop 0 ]; then
 	((num_errors++))
 	return
     fi
diff --git a/tools/testing/selftests/drivers/net/netdevsim/ethtool-fec.sh b/tools/testing/selftests/drivers/net/netdevsim/ethtool-fec.sh
new file mode 100755
index 000000000000..0c56746e9ce0
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/ethtool-fec.sh
@@ -0,0 +1,110 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+
+source ethtool-common.sh
+
+NSIM_NETDEV=$(make_netdev)
+[ a$ETHTOOL == a ] && ETHTOOL=ethtool
+
+set -o pipefail
+
+# netdevsim starts out with None/None
+s=$($ETHTOOL --show-fec $NSIM_NETDEV | tail -2)
+check $? "$s" "Configured FEC encodings: None
+Active FEC encoding: None"
+
+# Test Auto
+$ETHTOOL --set-fec $NSIM_NETDEV encoding auto
+check $?
+s=$($ETHTOOL --show-fec $NSIM_NETDEV | tail -2)
+check $? "$s" "Configured FEC encodings: Auto
+Active FEC encoding: Off"
+
+# Test case in-sensitivity
+for o in off Off OFF; do
+    $ETHTOOL --set-fec $NSIM_NETDEV encoding $o
+    check $?
+    s=$($ETHTOOL --show-fec $NSIM_NETDEV | tail -2)
+    check $? "$s" "Configured FEC encodings: Off
+Active FEC encoding: Off"
+done
+
+for o in BaseR baser BAser; do
+    $ETHTOOL --set-fec $NSIM_NETDEV encoding $o
+    check $?
+    s=$($ETHTOOL --show-fec $NSIM_NETDEV | tail -2)
+    check $? "$s" "Configured FEC encodings: BaseR
+Active FEC encoding: BaseR"
+done
+
+for o in llrs rs; do
+    $ETHTOOL --set-fec $NSIM_NETDEV encoding $o
+    check $?
+    s=$($ETHTOOL --show-fec $NSIM_NETDEV | tail -2)
+    check $? "$s" "Configured FEC encodings: ${o^^}
+Active FEC encoding: ${o^^}"
+done
+
+# Test mutliple bits
+$ETHTOOL --set-fec $NSIM_NETDEV encoding rs llrs
+check $?
+s=$($ETHTOOL --show-fec $NSIM_NETDEV | tail -2)
+check $? "$s" "Configured FEC encodings: RS LLRS
+Active FEC encoding: LLRS"
+
+$ETHTOOL --set-fec $NSIM_NETDEV encoding rs off auto
+check $?
+s=$($ETHTOOL --show-fec $NSIM_NETDEV | tail -2)
+check $? "$s" "Configured FEC encodings: Auto Off RS
+Active FEC encoding: RS"
+
+# Make sure other link modes are rejected
+$ETHTOOL --set-fec $NSIM_NETDEV encoding FIBRE 2>/dev/null
+check $? '' '' 1
+
+$ETHTOOL --set-fec $NSIM_NETDEV encoding bla-bla-bla 2>/dev/null
+check $? '' '' 1
+
+# Try JSON
+$ETHTOOL --json --show-fec $NSIM_NETDEV | jq empty >>/dev/null 2>&1
+if [ $? -eq 0 ]; then
+    $ETHTOOL --set-fec $NSIM_NETDEV encoding auto
+    check $?
+
+    s=$($ETHTOOL --json --show-fec $NSIM_NETDEV | jq '.[].config[]')
+    check $? "$s" '"Auto"'
+    s=$($ETHTOOL --json --show-fec $NSIM_NETDEV | jq '.[].active[]')
+    check $? "$s" '"Off"'
+
+    $ETHTOOL --set-fec $NSIM_NETDEV encoding auto RS
+    check $?
+
+    s=$($ETHTOOL --json --show-fec $NSIM_NETDEV | jq '.[].config[]')
+    check $? "$s" '"Auto"
+"RS"'
+    s=$($ETHTOOL --json --show-fec $NSIM_NETDEV | jq '.[].active[]')
+    check $? "$s" '"RS"'
+fi
+
+# Test error injection
+echo 11 > $NSIM_DEV_DFS/ethtool/get_err
+
+$ETHTOOL --show-fec $NSIM_NETDEV >>/dev/null 2>&1
+check $? '' '' 1
+
+echo 0 > $NSIM_DEV_DFS/ethtool/get_err
+echo 11 > $NSIM_DEV_DFS/ethtool/set_err
+
+$ETHTOOL --show-fec $NSIM_NETDEV  >>/dev/null 2>&1
+check $?
+
+$ETHTOOL --set-fec $NSIM_NETDEV encoding RS 2>/dev/null
+check $? '' '' 1
+
+if [ $num_errors -eq 0 ]; then
+    echo "PASSED all $((num_passes)) checks"
+    exit 0
+else
+    echo "FAILED $num_errors/$((num_errors+num_passes)) checks"
+    exit 1
+fi
-- 
2.30.2

