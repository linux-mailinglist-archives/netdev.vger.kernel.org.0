Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831C62B290D
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 00:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgKMXR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 18:17:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbgKMXRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 18:17:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605309442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HZwU5MqFyURdPBqY6ySq8B6Me24Wuo1MG4T+ge3xA9I=;
        b=gvQLkBCAB8VLEChDS5qyFyzwX/13AV4Kvf+T9so50QSV9be94qwSOdeaB6uLSSzgWl/3Gk
        aYQKkZrMhTm0exnCbx/x2F1D+gKMNlAD9ldb8hivwF+Q2X1IGGn1UWBi5Hk9x3V8b4miUv
        0kezRxsqDAb/KPopeiFNE/i55h9TmJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-Z6Kxo5JVOWCzb1tjRS77ow-1; Fri, 13 Nov 2020 18:17:20 -0500
X-MC-Unique: Z6Kxo5JVOWCzb1tjRS77ow-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7848710866A5;
        Fri, 13 Nov 2020 23:17:19 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.192.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B55A51512;
        Fri, 13 Nov 2020 23:17:18 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v3 4/4] selftests: add ring and coalesce selftests
Date:   Sat, 14 Nov 2020 00:16:55 +0100
Message-Id: <20201113231655.139948-4-acardace@redhat.com>
In-Reply-To: <20201113231655.139948-1-acardace@redhat.com>
References: <20201113231655.139948-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add scripts to test ring and coalesce settings
of netdevsim.

Signed-off-by: Antonio Cardace <acardace@redhat.com>
---
 .../drivers/net/netdevsim/ethtool-coalesce.sh | 68 +++++++++++++++++++
 .../drivers/net/netdevsim/ethtool-ring.sh     | 53 +++++++++++++++
 2 files changed, 121 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-coalesce.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-ring.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/ethtool-coalesce.sh b/tools/testing/selftests/drivers/net/netdevsim/ethtool-coalesce.sh
new file mode 100755
index 000000000000..3b322c99be69
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/ethtool-coalesce.sh
@@ -0,0 +1,68 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+
+source ethtool-common.sh
+
+function get_value {
+    local key=$1
+
+    echo $(ethtool -c $NSIM_NETDEV | \
+        awk -F':' -v pattern="$key:" '$0 ~ pattern {gsub(/[ \t]/, "", $2); print $2}')
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
+for key in ${!SETTINGS_MAP[@]}; do
+    query_key=${SETTINGS_MAP[$key]}
+    value=$((RANDOM % $((2**32-1))))
+    ethtool -C $NSIM_NETDEV "$key" "$value"
+    s=$(get_value "$query_key")
+    check $? "$s" "$value"
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
index 000000000000..513b9875c637
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/ethtool-ring.sh
@@ -0,0 +1,53 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+
+source ethtool-common.sh
+
+function get_value {
+    local key=$1
+
+    echo $(ethtool -g $NSIM_NETDEV | \
+        tail -n +$CURR_SETT_LINE | \
+        awk -F':' -v pattern="$key:" '$0 ~ pattern {gsub(/[\t ]/, "", $2); print $2}')
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
+MAX_VALUE=$((RANDOM % $((2**32-1))))
+RING_MAX_LIST=$(ls $NSIM_DEV_DFS/ethtool/ring/)
+
+for ring_max_entry in $RING_MAX_LIST; do
+    echo $MAX_VALUE > $NSIM_DEV_DFS/ethtool/ring/$ring_max_entry
+done
+
+CURR_SETT_LINE=$(ethtool -g $NSIM_NETDEV | grep -i -m1 -n 'Current hardware settings' | cut -f1 -d:)
+
+for key in ${!SETTINGS_MAP[@]}; do
+    query_key=${SETTINGS_MAP[$key]}
+    value=$((RANDOM % $MAX_VALUE))
+    ethtool -G $NSIM_NETDEV "$key" "$value"
+    s=$(get_value "$query_key")
+    check $? "$s" "$value"
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

