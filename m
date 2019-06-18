Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3C54A1B2
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbfFRNID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:08:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18599 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbfFRNIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:08:02 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 681139F6EA5A97A302FE;
        Tue, 18 Jun 2019 21:07:58 +0800 (CST)
Received: from huawei.com (10.175.100.202) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 18 Jun 2019
 21:07:52 +0800
From:   luoshijie <luoshijie1@huawei.com>
To:     <davem@davemloft.net>, <tgraf@suug.ch>, <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <liuzhiqiang26@huawei.com>,
        <wangxiaogang3@huawei.com>, <mingfangsen@huawei.com>,
        <zhoukang7@huawei.com>
Subject: [PATCH v2 3/3] selftests: add route_localnet test script
Date:   Tue, 18 Jun 2019 15:14:05 +0000
Message-ID: <1560870845-172395-4-git-send-email-luoshijie1@huawei.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1560870845-172395-1-git-send-email-luoshijie1@huawei.com>
References: <1560870845-172395-1-git-send-email-luoshijie1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.202]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shijie Luo <luoshijie1@huawei.com>

Add a simple scripts to exercise several situations when enable
route_localnet.

Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Zhiqiang liu <liuzhiqiang26@huawei.com>
---
 tools/testing/selftests/net/route_localnet.sh | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100755 tools/testing/selftests/net/route_localnet.sh

diff --git a/tools/testing/selftests/net/route_localnet.sh b/tools/testing/selftests/net/route_localnet.sh
new file mode 100755
index 000000000000..116bfeab72fa
--- /dev/null
+++ b/tools/testing/selftests/net/route_localnet.sh
@@ -0,0 +1,74 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Run a couple of tests when route_localnet = 1.
+
+readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
+
+setup() {
+    ip netns add "${PEER_NS}"
+    ip -netns "${PEER_NS}" link set dev lo up
+    ip link add name veth0 type veth peer name veth1
+    ip link set dev veth0 up
+    ip link set dev veth1 netns "${PEER_NS}"
+
+    # Enable route_localnet and delete useless route 127.0.0.0/8.
+    sysctl -w net.ipv4.conf.veth0.route_localnet=1
+    ip netns exec "${PEER_NS}" sysctl -w net.ipv4.conf.veth1.route_localnet=1
+    ip route del 127.0.0.0/8 dev lo table local
+    ip netns exec "${PEER_NS}" ip route del 127.0.0.0/8 dev lo table local
+
+    ifconfig veth0 127.25.3.4/24 up
+    ip netns exec "${PEER_NS}" ifconfig veth1 127.25.3.14/24 up
+
+    ip route flush cache
+    ip netns exec "${PEER_NS}" ip route flush cache
+}
+
+cleanup() {
+    ip link del veth0
+    ip route add local 127.0.0.0/8 dev lo proto kernel scope host src 127.0.0.1
+    local -r ns="$(ip netns list|grep $PEER_NS)"
+    [ -n "$ns" ] && ip netns del $ns 2>/dev/null
+}
+
+# Run test when arp_announce = 2.
+run_arp_announce_test() {
+    echo "run arp_announce test"
+    setup
+
+    sysctl -w net.ipv4.conf.veth0.arp_announce=2
+    ip netns exec "${PEER_NS}" sysctl -w net.ipv4.conf.veth1.arp_announce=2
+    ping -c5 -I veth0 127.25.3.14
+    if [ $? -ne 0 ];then
+        echo "failed"
+    else
+        echo "ok"
+    fi
+
+    cleanup
+}
+
+# Run test when arp_ignore = 3.
+run_arp_ignore_test() {
+    echo "run arp_ignore test"
+    setup
+
+    sysctl -w net.ipv4.conf.veth0.arp_ignore=3
+    ip netns exec "${PEER_NS}" sysctl -w net.ipv4.conf.veth1.arp_ignore=3
+    ping -c5 -I veth0 127.25.3.14
+    if [ $? -ne 0 ];then
+        echo "failed"
+    else
+        echo "ok"
+    fi
+
+    cleanup
+}
+
+run_all_tests() {
+    run_arp_announce_test
+    run_arp_ignore_test
+}
+
+run_all_tests
-- 
2.19.1

