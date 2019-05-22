Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF7426A9B
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbfEVTLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728734AbfEVTLI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:11:08 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CCD620868;
        Wed, 22 May 2019 19:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552267;
        bh=ZVVKJcnXppEX2CLe91y0enfrHhEqhQ61OFlZP4qnUjU=;
        h=From:To:Cc:Subject:Date:From;
        b=Lc/lJZAOBD4LbZJoVhUi0SF+QvWDt5ltkby/raWwk8qGafpY8HUbkkQn6cXPYOpHW
         73fpmAOJfjJWI82TZCqAu8ECGUg/GEb5UurSQSt0SWN/UxJkSW3iww7zJ95jSkumrJ
         dlQ+KcB3+X1GEFccdDF84WOOa/0jk7XYotVbEkYM=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, sbrivio@redhat.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] selftests: pmtu: Simplify cleanup and namespace names
Date:   Wed, 22 May 2019 12:11:06 -0700
Message-Id: <20190522191106.15789-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The point of the pause-on-fail argument is to leave the setup as is after
a test fails to allow a user to debug why it failed. Move the cleanup
after posting the result to the user to make it so.

Random names for the namespaces are not user friendly when trying to
debug a failure. Make them simpler and more direct for the tests. Run
cleanup at the beginning to ensure they are cleaned up if they already
exist.

Remove cleanup_done. There is no harm in doing cleanup twice; just
ignore any errors related to not existing - which is already done.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/pmtu.sh | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index b9171a7b3aaa..ab77e6344d17 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -152,10 +152,10 @@ tests="
 	cleanup_ipv4_exception		ipv4: cleanup of cached exceptions
 	cleanup_ipv6_exception		ipv6: cleanup of cached exceptions"
 
-NS_A="ns-$(mktemp -u XXXXXX)"
-NS_B="ns-$(mktemp -u XXXXXX)"
-NS_R1="ns-$(mktemp -u XXXXXX)"
-NS_R2="ns-$(mktemp -u XXXXXX)"
+NS_A="ns-A"
+NS_B="ns-B"
+NS_R1="ns-R1"
+NS_R2="ns-R2"
 ns_a="ip netns exec ${NS_A}"
 ns_b="ip netns exec ${NS_B}"
 ns_r1="ip netns exec ${NS_R1}"
@@ -212,7 +212,6 @@ dummy6_0_addr="fc00:1000::0"
 dummy6_1_addr="fc00:1001::0"
 dummy6_mask="64"
 
-cleanup_done=1
 err_buf=
 tcpdump_pids=
 
@@ -495,7 +494,7 @@ setup_routing() {
 setup() {
 	[ "$(id -u)" -ne 0 ] && echo "  need to run as root" && return $ksft_skip
 
-	cleanup_done=0
+	cleanup
 	for arg do
 		eval setup_${arg} || { echo "  ${arg} not supported"; return 1; }
 	done
@@ -519,11 +518,9 @@ cleanup() {
 	done
 	tcpdump_pids=
 
-	[ ${cleanup_done} -eq 1 ] && return
 	for n in ${NS_A} ${NS_B} ${NS_R1} ${NS_R2}; do
 		ip netns del ${n} 2> /dev/null
 	done
-	cleanup_done=1
 }
 
 mtu() {
@@ -1136,6 +1133,9 @@ done
 
 trap cleanup EXIT
 
+# start clean
+cleanup
+
 for t in ${tests}; do
 	[ $desc -eq 0 ] && name="${t}" && desc=1 && continue || desc=0
 
@@ -1156,7 +1156,6 @@ for t in ${tests}; do
 
 		eval test_${name}
 		ret=$?
-		cleanup
 
 		if [ $ret -eq 0 ]; then
 			printf "TEST: %-60s  [ OK ]\n" "${t}"
-- 
2.11.0

