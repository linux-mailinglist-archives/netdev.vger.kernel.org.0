Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBC1B542B
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 19:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbfIQR1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 13:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731044AbfIQR1P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 13:27:15 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34AA62171F;
        Tue, 17 Sep 2019 17:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568741235;
        bh=JFHk3a+4pDMiYAOACcSh94B/P4rsiN/SUnWl2UthWQA=;
        h=From:To:Cc:Subject:Date:From;
        b=ojNHUWvhjuCZy6IxW8+4vVOlO5oqqyJJV0+ofszpQ9VunlH9z37jUN1nCsn24IEM7
         kbHl10DB+MUvrKhgQoeRfy1ocPY0ansItOC2da4vVkvw74av2Rd9wPcf7XFsEqPITG
         +nnal7jPeHsU03MTlNT14PrX4ERNBw/UdEw1LqWE=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH] selftests: Update fib_nexthop_multiprefix to handle missing ping6
Date:   Tue, 17 Sep 2019 10:30:35 -0700
Message-Id: <20190917173035.19753-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Some distributions (e.g., debian buster) do not install ping6. Re-use
the hook in pmtu.sh to detect this and fallback to ping.

Fixes: 735ab2f65dce ("selftests: Add test with multiple prefixes using single nexthop")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fib_nexthop_multiprefix.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthop_multiprefix.sh b/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
index e6828732843e..9dc35a16e415 100755
--- a/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
+++ b/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
@@ -15,6 +15,8 @@
 PAUSE_ON_FAIL=no
 VERBOSE=0
 
+which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)
+
 ################################################################################
 # helpers
 
@@ -200,7 +202,7 @@ validate_v6_exception()
 	local rc
 
 	if [ ${ping_sz} != "0" ]; then
-		run_cmd ip netns exec h0 ping6 -s ${ping_sz} -c5 -w5 ${dst}
+		run_cmd ip netns exec h0 ${ping6} -s ${ping_sz} -c5 -w5 ${dst}
 	fi
 
 	if [ "$VERBOSE" = "1" ]; then
@@ -243,7 +245,7 @@ do
 		run_cmd taskset -c ${c} ip netns exec h0 ping -c1 -w1 172.16.10${i}.1
 		[ $? -ne 0 ] && printf "\nERROR: ping to h${i} failed\n" && ret=1
 
-		run_cmd taskset -c ${c} ip netns exec h0 ping6 -c1 -w1 2001:db8:10${i}::1
+		run_cmd taskset -c ${c} ip netns exec h0 ${ping6} -c1 -w1 2001:db8:10${i}::1
 		[ $? -ne 0 ] && printf "\nERROR: ping6 to h${i} failed\n" && ret=1
 
 		[ $ret -ne 0 ] && break
-- 
2.11.0

