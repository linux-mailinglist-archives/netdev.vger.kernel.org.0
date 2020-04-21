Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E451B2A74
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 16:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgDUOr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 10:47:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728899AbgDUOr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 10:47:29 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98F5620679;
        Tue, 21 Apr 2020 14:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587480448;
        bh=179hm4bmrWpEhrcTpNyYUj8Z88t4HCasC1NbfEsT6Nc=;
        h=From:To:Cc:Subject:Date:From;
        b=OOaIjmc99UZlb66p7Sb9+gbcrP44W4N2zNqvBVS0FZurL279nPq3L84JMZeGKgyt2
         2hmt7B3LWtsatjQ+3wR9O2YinY824fdzOKb6q6ZEyua4OA8uNANdC7Lv0vvyVY8c+I
         eVS5JVGty9oiMXDfDX8WpNNXrq1H/RbP+GgBWxYM=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net] selftests: Fix suppress test in fib_tests.sh
Date:   Tue, 21 Apr 2020 08:47:24 -0600
Message-Id: <20200421144724.54859-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

fib_tests is spewing errors:
    ...
    Cannot open network namespace "ns1": No such file or directory
    Cannot open network namespace "ns1": No such file or directory
    Cannot open network namespace "ns1": No such file or directory
    Cannot open network namespace "ns1": No such file or directory
    ping: connect: Network is unreachable
    Cannot open network namespace "ns1": No such file or directory
    Cannot open network namespace "ns1": No such file or directory
    ...

Each test entry in fib_tests is supposed to do its own setup and
cleanup. Right now the $IP commands in fib_suppress_test are
failing because there is no ns1. Add the setup/cleanup and logging
expected for each test.

Fixes: ca7a03c41753 ("ipv6: do not free rt if FIB_LOOKUP_NOREF is set on suppress rule")
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/net/fib_tests.sh | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index b7616704b55e..84205c3a55eb 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -618,16 +618,22 @@ fib_nexthop_test()
 
 fib_suppress_test()
 {
+	echo
+	echo "FIB rule with suppress_prefixlength"
+	setup
+
 	$IP link add dummy1 type dummy
 	$IP link set dummy1 up
 	$IP -6 route add default dev dummy1
 	$IP -6 rule add table main suppress_prefixlength 0
-	ping -f -c 1000 -W 1 1234::1 || true
+	ping -f -c 1000 -W 1 1234::1 >/dev/null 2>&1
 	$IP -6 rule del table main suppress_prefixlength 0
 	$IP link del dummy1
 
 	# If we got here without crashing, we're good.
-	return 0
+	log_test 0 0 "FIB rule suppress test"
+
+	cleanup
 }
 
 ################################################################################
-- 
2.20.1

