Return-Path: <netdev+bounces-1363-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0729F6FD9C0
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D25A1C20CD7
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768D820B2E;
	Wed, 10 May 2023 08:41:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A01120F5
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:41:27 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2A471701;
	Wed, 10 May 2023 01:41:21 -0700 (PDT)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 7/7] selftests: nft_flowtable.sh: check ingress/egress chain too
Date: Wed, 10 May 2023 10:33:13 +0200
Message-Id: <20230510083313.152961-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230510083313.152961-1-pablo@netfilter.org>
References: <20230510083313.152961-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Florian Westphal <fw@strlen.de>

Make sure flowtable interacts correctly with ingress and egress
chains, i.e. those get handled before and after flow table respectively.

Adds three more tests:
1. repeat flowtable test, but with 'ip dscp set cs3' done in
   inet forward chain.

Expect that some packets have been mangled (before flowtable offload
became effective) while some pass without mangling (after offload
succeeds).

2. repeat flowtable test, but with 'ip dscp set cs3' done in
   veth0:ingress.

Expect that all packets pass with cs3 dscp field.

3. same as 2, but use veth1:egress.  Expect the same outcome.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/netfilter/nft_flowtable.sh      | 124 ++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 51f986f19fee..a32f490f7539 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -188,6 +188,26 @@ if [ $? -ne 0 ]; then
 	exit $ksft_skip
 fi
 
+ip netns exec $ns2 nft -f - <<EOF
+table inet filter {
+   counter ip4dscp0 { }
+   counter ip4dscp3 { }
+
+   chain input {
+      type filter hook input priority 0; policy accept;
+      meta l4proto tcp goto {
+	      ip dscp cs3 counter name ip4dscp3 accept
+	      ip dscp 0 counter name ip4dscp0 accept
+      }
+   }
+}
+EOF
+
+if [ $? -ne 0 ]; then
+	echo "SKIP: Could not load nft ruleset"
+	exit $ksft_skip
+fi
+
 # test basic connectivity
 if ! ip netns exec $ns1 ping -c 1 -q 10.0.2.99 > /dev/null; then
   echo "ERROR: $ns1 cannot reach ns2" 1>&2
@@ -255,6 +275,60 @@ check_counters()
 	fi
 }
 
+check_dscp()
+{
+	local what=$1
+	local ok=1
+
+	local counter=$(ip netns exec $ns2 nft reset counter inet filter ip4dscp3 | grep packets)
+
+	local pc4=${counter%*bytes*}
+	local pc4=${pc4#*packets}
+
+	local counter=$(ip netns exec $ns2 nft reset counter inet filter ip4dscp0 | grep packets)
+	local pc4z=${counter%*bytes*}
+	local pc4z=${pc4z#*packets}
+
+	case "$what" in
+	"dscp_none")
+		if [ $pc4 -gt 0 ] || [ $pc4z -eq 0 ]; then
+			echo "FAIL: dscp counters do not match, expected dscp3 == 0, dscp0 > 0, but got $pc4,$pc4z" 1>&2
+			ret=1
+			ok=0
+		fi
+		;;
+	"dscp_fwd")
+		if [ $pc4 -eq 0 ] || [ $pc4z -eq 0 ]; then
+			echo "FAIL: dscp counters do not match, expected dscp3 and dscp0 > 0 but got $pc4,$pc4z" 1>&2
+			ret=1
+			ok=0
+		fi
+		;;
+	"dscp_ingress")
+		if [ $pc4 -eq 0 ] || [ $pc4z -gt 0 ]; then
+			echo "FAIL: dscp counters do not match, expected dscp3 > 0, dscp0 == 0 but got $pc4,$pc4z" 1>&2
+			ret=1
+			ok=0
+		fi
+		;;
+	"dscp_egress")
+		if [ $pc4 -eq 0 ] || [ $pc4z -gt 0 ]; then
+			echo "FAIL: dscp counters do not match, expected dscp3 > 0, dscp0 == 0 but got $pc4,$pc4z" 1>&2
+			ret=1
+			ok=0
+		fi
+		;;
+	*)
+		echo "FAIL: Unknown DSCP check" 1>&2
+		ret=1
+		ok=0
+	esac
+
+	if [ $ok -eq 1 ] ;then
+		echo "PASS: $what: dscp packet counters match"
+	fi
+}
+
 check_transfer()
 {
 	in=$1
@@ -325,6 +399,51 @@ test_tcp_forwarding()
 	return $?
 }
 
+test_tcp_forwarding_set_dscp()
+{
+	check_dscp "dscp_none"
+
+ip netns exec $nsr1 nft -f - <<EOF
+table netdev dscpmangle {
+   chain setdscp0 {
+      type filter hook ingress device "veth0" priority 0; policy accept
+	ip dscp set cs3
+  }
+}
+EOF
+if [ $? -eq 0 ]; then
+	test_tcp_forwarding_ip "$1" "$2"  10.0.2.99 12345
+	check_dscp "dscp_ingress"
+
+	ip netns exec $nsr1 nft delete table netdev dscpmangle
+else
+	echo "SKIP: Could not load netdev:ingress for veth0"
+fi
+
+ip netns exec $nsr1 nft -f - <<EOF
+table netdev dscpmangle {
+   chain setdscp0 {
+      type filter hook egress device "veth1" priority 0; policy accept
+      ip dscp set cs3
+  }
+}
+EOF
+if [ $? -eq 0 ]; then
+	test_tcp_forwarding_ip "$1" "$2"  10.0.2.99 12345
+	check_dscp "dscp_egress"
+
+	ip netns exec $nsr1 nft flush table netdev dscpmangle
+else
+	echo "SKIP: Could not load netdev:egress for veth1"
+fi
+
+	# partial.  If flowtable really works, then both dscp-is-0 and dscp-is-cs3
+	# counters should have seen packets (before and after ft offload kicks in).
+	ip netns exec $nsr1 nft -a insert rule inet filter forward ip dscp set cs3
+	test_tcp_forwarding_ip "$1" "$2"  10.0.2.99 12345
+	check_dscp "dscp_fwd"
+}
+
 test_tcp_forwarding_nat()
 {
 	local lret
@@ -394,6 +513,11 @@ table ip nat {
 }
 EOF
 
+if ! test_tcp_forwarding_set_dscp $ns1 $ns2 0 ""; then
+	echo "FAIL: flow offload for ns1/ns2 with dscp update" 1>&2
+	exit 0
+fi
+
 if ! test_tcp_forwarding_nat $ns1 $ns2 0 ""; then
 	echo "FAIL: flow offload for ns1/ns2 with NAT" 1>&2
 	ip netns exec $nsr1 nft list ruleset
-- 
2.30.2


