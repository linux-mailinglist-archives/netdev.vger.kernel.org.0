Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24DA68E06E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbjBGSrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbjBGSq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:46:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9E1233E4
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 10:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675795571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s50yxcE0OaGWC5SUnsikIZVGGGsiUrnDwXxdYcmFndI=;
        b=RYdhFoq/PjB5wVLXU5wcPy76gKMViKqHOH5A5J2U/dMWkd73RU5sjUxNE3tftAzddc7uQx
        47tP+5iIvGk+G7j0p7jcoqaE4NhxvRDyvi91bqrAx/AmlqRN3zeXmAvTums9WRbU3E+mKC
        s+4tmBJ1d1B7QMbH9QJ8Gs5qXg2tZZw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-2f789DVMOK2pIYQQ0BBEyg-1; Tue, 07 Feb 2023 13:46:05 -0500
X-MC-Unique: 2f789DVMOK2pIYQQ0BBEyg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D85C811E9C;
        Tue,  7 Feb 2023 18:46:05 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECB1C400DB1E;
        Tue,  7 Feb 2023 18:46:03 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Subject: [PATCH v4 net-next 4/4] self-tests: introduce self-tests for RPS default mask
Date:   Tue,  7 Feb 2023 19:44:58 +0100
Message-Id: <9f6f87435cc57bfd612846d170b1e9e5774c56a7.1675789134.git.pabeni@redhat.com>
In-Reply-To: <cover.1675789134.git.pabeni@redhat.com>
References: <cover.1675789134.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

