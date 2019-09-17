Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6701B5424
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 19:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731088AbfIQR1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 13:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731078AbfIQR1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 13:27:01 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A1152171F;
        Tue, 17 Sep 2019 17:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568741220;
        bh=7r8eF29fs/tdpwPKzP94o2oeY1M/LYAdlmqGJPp8IBM=;
        h=From:To:Cc:Subject:Date:From;
        b=U9KzfgO73NxuTpYv67p7lcgOLwapwppuPUrQjxYFA/0bRNuMivSF9pDBsBUYqtlq7
         VmV72R3rKCB0V4xjy0+gHxC2/fjTW7CBGhGgklE5GrVsi/v2aNXRNbDE4cHQ4T6Z6a
         kNEDVinZWGL+nOxFx9FkYOuragN9hc7EEB7Py4Co=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] selftests: Update fib_tests to handle missing ping6
Date:   Tue, 17 Sep 2019 10:30:21 -0700
Message-Id: <20190917173021.19705-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Some distributions (e.g., debian buster) do not install ping6. Re-use
the hook in pmtu.sh to detect this and fallback to ping.

Fixes: a0e11da78f48 ("fib_tests: Add tests for metrics on routes")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fib_tests.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 4465fc2dae14..cba83a12da82 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -17,6 +17,8 @@ PAUSE=no
 IP="ip -netns ns1"
 NS_EXEC="ip netns exec ns1"
 
+which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)
+
 log_test()
 {
 	local rc=$1
@@ -1086,7 +1088,7 @@ ipv6_route_metrics_test()
 	log_test $rc 0 "Multipath route with mtu metric"
 
 	$IP -6 ro add 2001:db8:104::/64 via 2001:db8:101::2 mtu 1300
-	run_cmd "ip netns exec ns1 ping6 -w1 -c1 -s 1500 2001:db8:104::1"
+	run_cmd "ip netns exec ns1 ${ping6} -w1 -c1 -s 1500 2001:db8:104::1"
 	log_test $? 0 "Using route with mtu metric"
 
 	run_cmd "$IP -6 ro add 2001:db8:114::/64 via  2001:db8:101::2  congctl lock foo"
-- 
2.11.0

