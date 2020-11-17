Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37ADD2B6889
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 16:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbgKQPUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 10:20:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40307 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730607AbgKQPUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 10:20:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605626436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rOO2G97HUrhXF6iV8OUekNvcw7/a/iFM+wMdy6+CSsY=;
        b=Kp2/9NmoMtQcpiRJaEawZookUcppkgzdoaMKpjiP0zBvKpYrpFhCxRW3SCxtzLfu6FCXw2
        qNRH33Xbv9vrgPfEhHSvBL9boEDFxAOFeDblnxID0+Lh5IlIJ4AsfqSQ6fcNOGlYxIQ6lx
        TyyqHh9vh50okOsYKpnVxR7Uib6moDk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-CF209BIZOh6CsN-7KkvzYQ-1; Tue, 17 Nov 2020 10:20:33 -0500
X-MC-Unique: CF209BIZOh6CsN-7KkvzYQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70E3B188C137;
        Tue, 17 Nov 2020 15:20:30 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.192.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41E085576E;
        Tue, 17 Nov 2020 15:20:29 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v4 6/6] selftests: add ring and coalesce selftests
Date:   Tue, 17 Nov 2020 16:20:15 +0100
Message-Id: <20201117152015.142089-7-acardace@redhat.com>
In-Reply-To: <20201117152015.142089-1-acardace@redhat.com>
References: <20201117152015.142089-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add scripts to test ring and coalesce settings
of netdevsim.

Signed-off-by: Antonio Cardace <acardace@redhat.com>
---
 .../drivers/net/netdevsim/ethtool-coalesce.sh | 132 ++++++++++++++++++
 .../drivers/net/netdevsim/ethtool-ring.sh     |  85 +++++++++++
 2 files changed, 217 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-coalesce.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-ring.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/ethtool-coalesce.sh b/tools/testing/selftests/drivers/net/netdevsim/ethtool-coalesce.sh
new file mode 100755
index 000000000000..9adfba8f87e6
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/ethtool-coalesce.sh
@@ -0,0 +1,132 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+
+source ethtool-common.sh
+
+function get_value {
+    local query="${SETTINGS_MAP[$1]}"
+
+    echo $(ethtool -c $NSIM_NETDEV | \
+        awk -F':' -v pattern="$query:" '$0 ~ pattern {gsub(/[ \t]/, "", $2); print $2}')
+}
+
+function update_current_settings {
+    for key in ${!SETTINGS_MAP[@]}; do
+        CURRENT_SETTINGS[$key]=$(get_value $key)
+    done
+    echo ${CURRENT_SETTINGS[@]}
+}
+
+if ! ethtool -h | grep -q coalesce; then
+    echo "SKIP: No --coalesce support in ethtool"
+    exit 4
+fi
+
+NSIM_NETDEV=$(make_netdev)
+
+set -o pipefail
+
+declare -A SETTINGS_MAP=(
+    ["rx-frames-low"]="rx-frame-low"
+    ["tx-frames-low"]="tx-frame-low"
+    ["rx-frames-high"]="rx-frame-high"
+    ["tx-frames-high"]="tx-frame-high"
+    ["rx-usecs"]="rx-usecs"
+    ["rx-frames"]="rx-frames"
+    ["rx-usecs-irq"]="rx-usecs-irq"
+    ["rx-frames-irq"]="rx-frames-irq"
+    ["tx-usecs"]="tx-usecs"
+    ["tx-frames"]="tx-frames"
+    ["tx-usecs-irq"]="tx-usecs-irq"
+    ["tx-frames-irq"]="tx-frames-irq"
+    ["stats-block-usecs"]="stats-block-usecs"
+    ["pkt-rate-low"]="pkt-rate-low"
+    ["rx-usecs-low"]="rx-usecs-low"
+    ["tx-usecs-low"]="tx-usecs-low"
+    ["pkt-rate-high"]="pkt-rate-high"
+    ["rx-usecs-high"]="rx-usecs-high"
+    ["tx-usecs-high"]="tx-usecs-high"
+    ["sample-interval"]="sample-interval"
+)
+
+declare -A CURRENT_SETTINGS=(
+    ["rx-frames-low"]=""
+    ["tx-frames-low"]=""
+    ["rx-frames-high"]=""
+    ["tx-frames-high"]=""
+    ["rx-usecs"]=""
+    ["rx-frames"]=""
+    ["rx-usecs-irq"]=""
+    ["rx-frames-irq"]=""
+    ["tx-usecs"]=""
+    ["tx-frames"]=""
+    ["tx-usecs-irq"]=""
+    ["tx-frames-irq"]=""
+    ["stats-block-usecs"]=""
+    ["pkt-rate-low"]=""
+    ["rx-usecs-low"]=""
+    ["tx-usecs-low"]=""
+    ["pkt-rate-high"]=""
+    ["rx-usecs-high"]=""
+    ["tx-usecs-high"]=""
+    ["sample-interval"]=""
+)
+
+declare -A EXPECTED_SETTINGS=(
+    ["rx-frames-low"]=""
+    ["tx-frames-low"]=""
+    ["rx-frames-high"]=""
+    ["tx-frames-high"]=""
+    ["rx-usecs"]=""
+    ["rx-frames"]=""
+    ["rx-usecs-irq"]=""
+    ["rx-frames-irq"]=""
+    ["tx-usecs"]=""
+    ["tx-frames"]=""
+    ["tx-usecs-irq"]=""
+    ["tx-frames-irq"]=""
+    ["stats-block-usecs"]=""
+    ["pkt-rate-low"]=""
+    ["rx-usecs-low"]=""
+    ["tx-usecs-low"]=""
+    ["pkt-rate-high"]=""
+    ["rx-usecs-high"]=""
+    ["tx-usecs-high"]=""
+    ["sample-interval"]=""
+)
+
+# populate the expected settings map
+for key in ${!SETTINGS_MAP[@]}; do
+    EXPECTED_SETTINGS[$key]=$(get_value $key)
+done
+
+# test
+for key in ${!SETTINGS_MAP[@]}; do
+    value=$((RANDOM % $((2**32-1))))
+
+    ethtool -C $NSIM_NETDEV "$key" "$value"
+
+    EXPECTED_SETTINGS[$key]="$value"
+    expected=${EXPECTED_SETTINGS[@]}
+    current=$(update_current_settings)
+
+    check $? "$current" "$expected"
+    set +x
+done
+
+# bool settings which ethtool displays on the same line
+ethtool -C $NSIM_NETDEV adaptive-rx on
+s=$(ethtool -c $NSIM_NETDEV | grep -q "Adaptive RX: on  TX: off")
+check $? "$s" ""
+
+ethtool -C $NSIM_NETDEV adaptive-tx on
+s=$(ethtool -c $NSIM_NETDEV | grep -q "Adaptive RX: on  TX: on")
+check $? "$s" ""
+
+if [ $num_errors -eq 0 ]; then
+    echo "PASSED all $((num_passes)) checks"
+    exit 0
+else
+    echo "FAILED $num_errors/$((num_errors+num_passes)) checks"
+    exit 1
+fi
diff --git a/tools/testing/selftests/drivers/net/netdevsim/ethtool-ring.sh b/tools/testing/selftests/drivers/net/netdevsim/ethtool-ring.sh
new file mode 100755
index 000000000000..c969559ffa7a
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/ethtool-ring.sh
@@ -0,0 +1,85 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+
+source ethtool-common.sh
+
+function get_value {
+    local query="${SETTINGS_MAP[$1]}"
+
+    echo $(ethtool -g $NSIM_NETDEV | \
+        tail -n +$CURR_SETT_LINE | \
+        awk -F':' -v pattern="$query:" '$0 ~ pattern {gsub(/[\t ]/, "", $2); print $2}')
+}
+
+function update_current_settings {
+    for key in ${!SETTINGS_MAP[@]}; do
+        CURRENT_SETTINGS[$key]=$(get_value $key)
+    done
+    echo ${CURRENT_SETTINGS[@]}
+}
+
+if ! ethtool -h | grep -q set-ring >/dev/null; then
+    echo "SKIP: No --set-ring support in ethtool"
+    exit 4
+fi
+
+NSIM_NETDEV=$(make_netdev)
+
+set -o pipefail
+
+declare -A SETTINGS_MAP=(
+    ["rx"]="RX"
+    ["rx-mini"]="RX Mini"
+    ["rx-jumbo"]="RX Jumbo"
+    ["tx"]="TX"
+)
+
+declare -A EXPECTED_SETTINGS=(
+    ["rx"]=""
+    ["rx-mini"]=""
+    ["rx-jumbo"]=""
+    ["tx"]=""
+)
+
+declare -A CURRENT_SETTINGS=(
+    ["rx"]=""
+    ["rx-mini"]=""
+    ["rx-jumbo"]=""
+    ["tx"]=""
+)
+
+MAX_VALUE=$((RANDOM % $((2**32-1))))
+RING_MAX_LIST=$(ls $NSIM_DEV_DFS/ethtool/ring/)
+
+for ring_max_entry in $RING_MAX_LIST; do
+    echo $MAX_VALUE > $NSIM_DEV_DFS/ethtool/ring/$ring_max_entry
+done
+
+CURR_SETT_LINE=$(ethtool -g $NSIM_NETDEV | grep -i -m1 -n 'Current hardware settings' | cut -f1 -d:)
+
+# populate the expected settings map
+for key in ${!SETTINGS_MAP[@]}; do
+    EXPECTED_SETTINGS[$key]=$(get_value $key)
+done
+
+# test
+for key in ${!SETTINGS_MAP[@]}; do
+    value=$((RANDOM % $MAX_VALUE))
+
+    ethtool -G $NSIM_NETDEV "$key" "$value"
+
+    EXPECTED_SETTINGS[$key]="$value"
+    expected=${EXPECTED_SETTINGS[@]}
+    current=$(update_current_settings)
+
+    check $? "$current" "$expected"
+    set +x
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
2.28.0

