Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C978622A7B
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiKIL2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiKIL2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:28:31 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CBB91157;
        Wed,  9 Nov 2022 03:28:30 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 3/3] selftests: netfilter: Fix and review rpath.sh
Date:   Wed,  9 Nov 2022 12:28:20 +0100
Message-Id: <20221109112820.206807-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221109112820.206807-1-pablo@netfilter.org>
References: <20221109112820.206807-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Address a few problems with the initial test script version:

* On systems with ip6tables but no ip6tables-legacy, testing for
  ip6tables was disabled by accident.
* Firewall setup phase did not respect possibly unavailable tools.
* Consistently call nft via '$nft'.

Fixes: 6e31ce831c63b ("selftests: netfilter: Test reverse path filtering")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/rpath.sh | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/netfilter/rpath.sh b/tools/testing/selftests/netfilter/rpath.sh
index 2d8da7bd8ab7..f7311e66d219 100755
--- a/tools/testing/selftests/netfilter/rpath.sh
+++ b/tools/testing/selftests/netfilter/rpath.sh
@@ -15,7 +15,7 @@ fi
 
 if ip6tables-legacy --version >/dev/null 2>&1; then
 	ip6tables='ip6tables-legacy'
-elif ! ip6tables --version >/dev/null 2>&1; then
+elif ip6tables --version >/dev/null 2>&1; then
 	ip6tables='ip6tables'
 else
 	ip6tables=''
@@ -62,9 +62,11 @@ ip -net "$ns1" a a fec0:42::2/64 dev v0 nodad
 ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 
 # firewall matches to test
-ip netns exec "$ns2" "$iptables" -t raw -A PREROUTING -s 192.168.0.0/16 -m rpfilter
-ip netns exec "$ns2" "$ip6tables" -t raw -A PREROUTING -s fec0::/16 -m rpfilter
-ip netns exec "$ns2" nft -f - <<EOF
+[ -n "$iptables" ] && ip netns exec "$ns2" \
+	"$iptables" -t raw -A PREROUTING -s 192.168.0.0/16 -m rpfilter
+[ -n "$ip6tables" ] && ip netns exec "$ns2" \
+	"$ip6tables" -t raw -A PREROUTING -s fec0::/16 -m rpfilter
+[ -n "$nft" ] && ip netns exec "$ns2" $nft -f - <<EOF
 table inet t {
 	chain c {
 		type filter hook prerouting priority raw;
@@ -106,8 +108,8 @@ testrun() {
 	if [ -n "$nft" ]; then
 		(
 			echo "delete table inet t";
-			ip netns exec "$ns2" nft -s list table inet t;
-		) | ip netns exec "$ns2" nft -f -
+			ip netns exec "$ns2" $nft -s list table inet t;
+		) | ip netns exec "$ns2" $nft -f -
 	fi
 
 	# test 1: martian traffic should fail rpfilter matches
-- 
2.30.2

