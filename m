Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11C32B82F7
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgKRRSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:18:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45918 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728229AbgKRRSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 12:18:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605719923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nIiS4VXjK7crWMoMjKe+Kw8Quf3xc3QnFBb1artYkg=;
        b=gFqRsstGYj6cjO4dD4lD6FwhPNJcAGexEzDBCE7a+f9oO/UFqYd/allXHTpeF3A6AH43mp
        9OIoVy42wfjjSTEgRondOBrwaG14DpB02tlWZSbOX0g62KNT+RRWoajSCt+kSL7dN4ep43
        G/OgzZsjPR34TJ+SkqU7C4LlKHfWtSE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-9bTklf3tM2yy5CiDFivIrA-1; Wed, 18 Nov 2020 12:18:40 -0500
X-MC-Unique: 9bTklf3tM2yy5CiDFivIrA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA37E1084CA3;
        Wed, 18 Nov 2020 17:18:39 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.195.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F53B60843;
        Wed, 18 Nov 2020 17:18:38 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v5 4/6] selftests: extract common functions in ethtool-common.sh
Date:   Wed, 18 Nov 2020 18:18:25 +0100
Message-Id: <20201118171827.48143-5-acardace@redhat.com>
In-Reply-To: <20201118171827.48143-1-acardace@redhat.com>
References: <20201118171827.48143-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out some useful functions so that they can be reused
by other ethtool-netdevsim scripts.

Signed-off-by: Antonio Cardace <acardace@redhat.com>
---
 .../drivers/net/netdevsim/ethtool-common.sh   | 69 +++++++++++++++++++
 .../drivers/net/netdevsim/ethtool-pause.sh    | 63 +----------------
 2 files changed, 71 insertions(+), 61 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh b/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
new file mode 100644
index 000000000000..fa44cf6e732c
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
@@ -0,0 +1,69 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+
+NSIM_ID=$((RANDOM % 1024))
+NSIM_DEV_SYS=/sys/bus/netdevsim/devices/netdevsim$NSIM_ID
+NSIM_DEV_DFS=/sys/kernel/debug/netdevsim/netdevsim$NSIM_ID/ports/0
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
+function make_netdev {
+    # Make a netdevsim
+    old_netdevs=$(ls /sys/class/net)
+
+    if ! $(lsmod | grep -q netdevsim); then
+	modprobe netdevsim
+    fi
+
+    echo $NSIM_ID > /sys/bus/netdevsim/new_device
+    echo `get_netdev_name old_netdevs`
+}
diff --git a/tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh b/tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh
index 25c896b9e2eb..b4a7abfe5454 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh
@@ -1,60 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0-only
 
-NSIM_ID=$((RANDOM % 1024))
-NSIM_DEV_SYS=/sys/bus/netdevsim/devices/netdevsim$NSIM_ID
-NSIM_DEV_DFS=/sys/kernel/debug/netdevsim/netdevsim$NSIM_ID/ports/0
-NSIM_NETDEV=
-num_passes=0
-num_errors=0
-
-function cleanup_nsim {
-    if [ -e $NSIM_DEV_SYS ]; then
-	echo $NSIM_ID > /sys/bus/netdevsim/del_device
-    fi
-}
-
-function cleanup {
-    cleanup_nsim
-}
-
-trap cleanup EXIT
-
-function get_netdev_name {
-    local -n old=$1
-
-    new=$(ls /sys/class/net)
-
-    for netdev in $new; do
-	for check in $old; do
-            [ $netdev == $check ] && break
-	done
-
-	if [ $netdev != $check ]; then
-	    echo $netdev
-	    break
-	fi
-    done
-}
-
-function check {
-    local code=$1
-    local str=$2
-    local exp_str=$3
-
-    if [ $code -ne 0 ]; then
-	((num_errors++))
-	return
-    fi
-
-    if [ "$str" != "$exp_str"  ]; then
-	echo -e "Expected: '$exp_str', got '$str'"
-	((num_errors++))
-	return
-    fi
-
-    ((num_passes++))
-}
+source ethtool-common.sh
 
 # Bail if ethtool is too old
 if ! ethtool -h | grep include-stat 2>&1 >/dev/null; then
@@ -62,13 +9,7 @@ if ! ethtool -h | grep include-stat 2>&1 >/dev/null; then
     exit 4
 fi
 
-# Make a netdevsim
-old_netdevs=$(ls /sys/class/net)
-
-modprobe netdevsim
-echo $NSIM_ID > /sys/bus/netdevsim/new_device
-
-NSIM_NETDEV=`get_netdev_name old_netdevs`
+NSIM_NETDEV=$(make_netdev)
 
 set -o pipefail
 
-- 
2.28.0

