Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51CF110CEB5
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 19:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfK1S70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 13:59:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49938 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfK1S7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 13:59:25 -0500
Received: from [189.110.51.181] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1iaP0d-0004aS-Kx; Thu, 28 Nov 2019 18:59:24 +0000
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        shuah@kernel.org, davem@davemloft.net, sbrivio@redhat.com
Subject: [PATCH] selftests: pmtu: use -oneline for ip route list cache
Date:   Thu, 28 Nov 2019 15:58:06 -0300
Message-Id: <20191128185806.23706-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some versions of iproute2 will output more than one line per entry, which
will cause the test to fail, like:

TEST: ipv6: list and flush cached exceptions                        [FAIL]
  can't list cached exceptions

That happens, for example, with iproute2 4.15.0. When using the -oneline
option, this will work just fine:

TEST: ipv6: list and flush cached exceptions                        [ OK ]

This also works just fine with a more recent version of iproute2, like
5.4.0.

For some reason, two lines are printed for the IPv4 test no matter what
version of iproute2 is used. Use the same -oneline parameter there instead
of counting the lines twice.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 tools/testing/selftests/net/pmtu.sh | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index ab367e75f095..d697815d2785 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -1249,8 +1249,7 @@ test_list_flush_ipv4_exception() {
 	done
 	run_cmd ${ns_a} ping -q -M want -i 0.1 -c 2 -s 1800 "${dst2}"
 
-	# Each exception is printed as two lines
-	if [ "$(${ns_a} ip route list cache | wc -l)" -ne 202 ]; then
+	if [ "$(${ns_a} ip -oneline route list cache | wc -l)" -ne 101 ]; then
 		err "  can't list cached exceptions"
 		fail=1
 	fi
@@ -1300,7 +1299,7 @@ test_list_flush_ipv6_exception() {
 		run_cmd ${ns_a} ping -q -M want -i 0.1 -w 1 -s 1800 "${dst_prefix1}${i}"
 	done
 	run_cmd ${ns_a} ping -q -M want -i 0.1 -w 1 -s 1800 "${dst2}"
-	if [ "$(${ns_a} ip -6 route list cache | wc -l)" -ne 101 ]; then
+	if [ "$(${ns_a} ip -oneline -6 route list cache | wc -l)" -ne 101 ]; then
 		err "  can't list cached exceptions"
 		fail=1
 	fi
-- 
2.20.1

