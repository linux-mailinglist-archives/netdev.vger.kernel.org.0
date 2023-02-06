Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B854F68C5CF
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 19:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjBFScA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 13:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjBFSbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 13:31:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C140D2943A
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 10:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675708246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s50yxcE0OaGWC5SUnsikIZVGGGsiUrnDwXxdYcmFndI=;
        b=G2RWeGb45Y66zxq1iZCzh5cpiO7Hj1UalWcKyxTWTMioliugi59x/OvvpYO02DTG+VtPC4
        JsurwwK+hefHANHWTydUdnAstB4uoEnTY+x9ihlWzz9gFYTOmuvLpHIhvzRWXrx0wLKQE9
        +7alHFpuWBfV1HzSWFDG7mnJldyF078=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-2lsmsrQ8N1ClRBI3r75ozw-1; Mon, 06 Feb 2023 13:30:42 -0500
X-MC-Unique: 2lsmsrQ8N1ClRBI3r75ozw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56DDF811E6E;
        Mon,  6 Feb 2023 18:30:41 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C55E1121315;
        Mon,  6 Feb 2023 18:30:39 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Subject: [PATCH v3 net-next 4/4] self-tests: introduce self-tests for RPS default mask
Date:   Mon,  6 Feb 2023 19:30:22 +0100
Message-Id: <d613312e738ec8910fb235376f3dbe2b8186e352.1675708062.git.pabeni@redhat.com>
In-Reply-To: <cover.1675708062.git.pabeni@redhat.com>
References: <cover.1675708062.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that RPS default mask changes take place on
all newly created netns/devices and don't affect
existing ones.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/Makefile          |  1 +
 tools/testing/selftests/net/config            |  3 +
 .../testing/selftests/net/rps_default_mask.sh | 57 +++++++++++++++++++
 3 files changed, 61 insertions(+)
 create mode 100755 tools/testing/selftests/net/rps_default_mask.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 951bd5342bc6..3364c548a23b 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -46,6 +46,7 @@ TEST_PROGS += stress_reuseport_listen.sh
 TEST_PROGS += l2_tos_ttl_inherit.sh
 TEST_PROGS += bind_bhash.sh
 TEST_PROGS += ip_local_port_range.sh
+TEST_PROGS += rps_default_mask.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =  socket nettest
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index bd89198cd817..cc9fd55ab869 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -3,6 +3,9 @@ CONFIG_NET_NS=y
 CONFIG_BPF_SYSCALL=y
 CONFIG_TEST_BPF=m
 CONFIG_NUMA=y
+CONFIG_RPS=y
+CONFIG_SYSFS=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_NET_VRF=y
 CONFIG_NET_L3_MASTER_DEV=y
 CONFIG_IPV6=y
diff --git a/tools/testing/selftests/net/rps_default_mask.sh b/tools/testing/selftests/net/rps_default_mask.sh
new file mode 100755
index 000000000000..c81c0ac7ddfe
--- /dev/null
+++ b/tools/testing/selftests/net/rps_default_mask.sh
@@ -0,0 +1,57 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+readonly ksft_skip=4
+readonly cpus=$(nproc)
+ret=0
+
+[ $cpus -gt 2 ] || exit $ksft_skip
+
+readonly INITIAL_RPS_DEFAULT_MASK=$(cat /proc/sys/net/core/rps_default_mask)
+readonly NETNS="ns-$(mktemp -u XXXXXX)"
+
+setup() {
+	ip netns add "${NETNS}"
+	ip -netns "${NETNS}" link set lo up
+}
+
+cleanup() {
+	echo $INITIAL_RPS_DEFAULT_MASK > /proc/sys/net/core/rps_default_mask
+	ip netns del $NETNS
+}
+
+chk_rps() {
+	local rps_mask expected_rps_mask=$3
+	local dev_name=$2
+	local msg=$1
+
+	rps_mask=$(ip netns exec $NETNS cat /sys/class/net/$dev_name/queues/rx-0/rps_cpus)
+	printf "%-60s" "$msg"
+	if [ $rps_mask -eq $expected_rps_mask ]; then
+		echo "[ ok ]"
+	else
+		echo "[fail] expected $expected_rps_mask found $rps_mask"
+		ret=1
+	fi
+}
+
+trap cleanup EXIT
+
+echo 0 > /proc/sys/net/core/rps_default_mask
+setup
+chk_rps "empty rps_default_mask" lo 0
+cleanup
+
+echo 1 > /proc/sys/net/core/rps_default_mask
+setup
+chk_rps "non zero rps_default_mask" lo 1
+
+echo 3 > /proc/sys/net/core/rps_default_mask
+chk_rps "changing rps_default_mask dont affect existing netns" lo 1
+
+ip -n $NETNS link add type veth
+ip -n $NETNS link set dev veth0 up
+ip -n $NETNS link set dev veth1 up
+chk_rps "changing rps_default_mask affect newly created devices" veth0 3
+chk_rps "changing rps_default_mask affect newly created devices[II]" veth1 3
+exit $ret
-- 
2.39.1

