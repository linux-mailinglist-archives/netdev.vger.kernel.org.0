Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080AD2B979
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 19:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfE0Rmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 13:42:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726494AbfE0Rmg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 13:42:36 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 161903087929;
        Mon, 27 May 2019 17:42:35 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB54E1001DDC;
        Mon, 27 May 2019 17:42:31 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Xiumei Mu <xmu@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net] selftests: pmtu: Fix encapsulating device in pmtu_vti6_link_change_mtu
Date:   Mon, 27 May 2019 19:42:23 +0200
Message-Id: <a53ca7bdf29b2b265d812adf51168f7c5f4e4e26.1558978791.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 27 May 2019 17:42:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the pmtu_vti6_link_change_mtu test, both local and remote addresses
for the vti6 tunnel are assigned to the same address given to the dummy
interface that we use as encapsulating device with a known MTU.

This works as long as the dummy interface is actually selected, via
rt6_lookup(), as encapsulating device. But if the remote address of the
tunnel is a local address too, the loopback interface could also be
selected, and there's nothing wrong with it.

This is what some older -stable kernels do (3.18.z, at least), and
nothing prevents us from subtly changing FIB implementation to revert
back to that behaviour in the future.

Define an IPv6 prefix instead, and use two separate addresses as local
and remote for vti6, so that the encapsulating device can't be a
loopback interface.

Reported-by: Xiumei Mu <xmu@redhat.com>
Fixes: 1fad59ea1c34 ("selftests: pmtu: Add pmtu_vti6_link_change_mtu test")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 tools/testing/selftests/net/pmtu.sh | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index b9171a7b3aaa..317dafcd605d 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -208,8 +208,8 @@ tunnel6_a_addr="fd00:2::a"
 tunnel6_b_addr="fd00:2::b"
 tunnel6_mask="64"
 
-dummy6_0_addr="fc00:1000::0"
-dummy6_1_addr="fc00:1001::0"
+dummy6_0_prefix="fc00:1000::"
+dummy6_1_prefix="fc00:1001::"
 dummy6_mask="64"
 
 cleanup_done=1
@@ -1005,13 +1005,13 @@ test_pmtu_vti6_link_change_mtu() {
 	run_cmd ${ns_a} ip link set dummy0 up
 	run_cmd ${ns_a} ip link set dummy1 up
 
-	run_cmd ${ns_a} ip addr add ${dummy6_0_addr}/${dummy6_mask} dev dummy0
-	run_cmd ${ns_a} ip addr add ${dummy6_1_addr}/${dummy6_mask} dev dummy1
+	run_cmd ${ns_a} ip addr add ${dummy6_0_prefix}1/${dummy6_mask} dev dummy0
+	run_cmd ${ns_a} ip addr add ${dummy6_1_prefix}1/${dummy6_mask} dev dummy1
 
 	fail=0
 
 	# Create vti6 interface bound to device, passing MTU, check it
-	run_cmd ${ns_a} ip link add vti6_a mtu 1300 type vti6 remote ${dummy6_0_addr} local ${dummy6_0_addr}
+	run_cmd ${ns_a} ip link add vti6_a mtu 1300 type vti6 remote ${dummy6_0_prefix}2 local ${dummy6_0_prefix}1
 	mtu="$(link_get_mtu "${ns_a}" vti6_a)"
 	if [ ${mtu} -ne 1300 ]; then
 		err "  vti6 MTU ${mtu} doesn't match configured value 1300"
@@ -1020,7 +1020,7 @@ test_pmtu_vti6_link_change_mtu() {
 
 	# Move to another device with different MTU, without passing MTU, check
 	# MTU is adjusted
-	run_cmd ${ns_a} ip link set vti6_a type vti6 remote ${dummy6_1_addr} local ${dummy6_1_addr}
+	run_cmd ${ns_a} ip link set vti6_a type vti6 remote ${dummy6_1_prefix}2 local ${dummy6_1_prefix}1
 	mtu="$(link_get_mtu "${ns_a}" vti6_a)"
 	if [ ${mtu} -ne $((3000 - 40)) ]; then
 		err "  vti MTU ${mtu} is not dummy MTU 3000 minus IPv6 header length"
@@ -1028,7 +1028,7 @@ test_pmtu_vti6_link_change_mtu() {
 	fi
 
 	# Move it back, passing MTU, check MTU is not overridden
-	run_cmd ${ns_a} ip link set vti6_a mtu 1280 type vti6 remote ${dummy6_0_addr} local ${dummy6_0_addr}
+	run_cmd ${ns_a} ip link set vti6_a mtu 1280 type vti6 remote ${dummy6_0_prefix}2 local ${dummy6_0_prefix}1
 	mtu="$(link_get_mtu "${ns_a}" vti6_a)"
 	if [ ${mtu} -ne 1280 ]; then
 		err "  vti6 MTU ${mtu} doesn't match configured value 1280"
-- 
2.20.1

