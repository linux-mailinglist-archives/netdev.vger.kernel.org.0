Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A33E6113600
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 20:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbfLDTxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 14:53:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39628 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727887AbfLDTxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 14:53:45 -0500
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1icaiU-0007wL-Kk; Wed, 04 Dec 2019 19:53:43 +0000
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        posk@google.com, cascardo@canonical.com
Subject: [PATCH] selftests: net: ip_defrag: increase netdev_max_backlog
Date:   Wed,  4 Dec 2019 16:53:21 -0300
Message-Id: <20191204195321.406365-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using fragments with size 8 and payload larger than 8000, the backlog
might fill up and packets will be dropped, causing the test to fail. This
happens often enough when conntrack is on during the IPv6 test.

As the larger payload in the test is 10000, using a backlog of 1250 allow
the test to run repeatedly without failure. At least a 1000 runs were
possible with no failures, when usually less than 50 runs were good enough
for showing a failure.

As netdev_max_backlog is not a pernet setting, this sets the backlog to
1000 during exit to prevent disturbing following tests.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Fixes: 4c3510483d26 (selftests: net: ip_defrag: cover new IPv6 defrag behavior)
---
 tools/testing/selftests/net/ip_defrag.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/ip_defrag.sh b/tools/testing/selftests/net/ip_defrag.sh
index 15d3489ecd9c..c91cfecfa245 100755
--- a/tools/testing/selftests/net/ip_defrag.sh
+++ b/tools/testing/selftests/net/ip_defrag.sh
@@ -12,6 +12,8 @@ setup() {
 	ip netns add "${NETNS}"
 	ip -netns "${NETNS}" link set lo up
 
+	sysctl -w net.core.netdev_max_backlog=1250 >/dev/null 2>&1
+
 	ip netns exec "${NETNS}" sysctl -w net.ipv4.ipfrag_high_thresh=9000000 >/dev/null 2>&1
 	ip netns exec "${NETNS}" sysctl -w net.ipv4.ipfrag_low_thresh=7000000 >/dev/null 2>&1
 	ip netns exec "${NETNS}" sysctl -w net.ipv4.ipfrag_time=1 >/dev/null 2>&1
@@ -30,6 +32,7 @@ setup() {
 
 cleanup() {
 	ip netns del "${NETNS}"
+	sysctl -w net.core.netdev_max_backlog=1000 >/dev/null 2>&1
 }
 
 trap cleanup EXIT
-- 
2.24.0

