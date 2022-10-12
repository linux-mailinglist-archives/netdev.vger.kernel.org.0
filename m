Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAF75FC528
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJLMTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJLMTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:19:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186C9C4D87;
        Wed, 12 Oct 2022 05:19:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oiahm-0002ej-S5; Wed, 12 Oct 2022 14:19:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Phil Sutter <phil@nwl.cc>,
        Guillaume Nault <gnault@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 1/3] selftests: netfilter: Test reverse path filtering
Date:   Wed, 12 Oct 2022 14:19:00 +0200
Message-Id: <20221012121902.27738-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221012121902.27738-1-fw@strlen.de>
References: <20221012121902.27738-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Test reverse path (filter) matches in iptables, ip6tables and nftables.
Both with a regular interface and a VRF.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/netfilter/Makefile |   2 +-
 tools/testing/selftests/netfilter/rpath.sh | 147 +++++++++++++++++++++
 2 files changed, 148 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/rpath.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index 600e3a19d5e2..4504ee07be08 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -6,7 +6,7 @@ TEST_PROGS := nft_trans_stress.sh nft_fib.sh nft_nat.sh bridge_brouter.sh \
 	nft_concat_range.sh nft_conntrack_helper.sh \
 	nft_queue.sh nft_meta.sh nf_nat_edemux.sh \
 	ipip-conntrack-mtu.sh conntrack_tcp_unreplied.sh \
-	conntrack_vrf.sh nft_synproxy.sh
+	conntrack_vrf.sh nft_synproxy.sh rpath.sh
 
 CFLAGS += $(shell pkg-config --cflags libmnl 2>/dev/null || echo "-I/usr/include/libmnl")
 LDLIBS = -lmnl
diff --git a/tools/testing/selftests/netfilter/rpath.sh b/tools/testing/selftests/netfilter/rpath.sh
new file mode 100755
index 000000000000..2d8da7bd8ab7
--- /dev/null
+++ b/tools/testing/selftests/netfilter/rpath.sh
@@ -0,0 +1,147 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# return code to signal skipped test
+ksft_skip=4
+
+# search for legacy iptables (it uses the xtables extensions
+if iptables-legacy --version >/dev/null 2>&1; then
+	iptables='iptables-legacy'
+elif iptables --version >/dev/null 2>&1; then
+	iptables='iptables'
+else
+	iptables=''
+fi
+
+if ip6tables-legacy --version >/dev/null 2>&1; then
+	ip6tables='ip6tables-legacy'
+elif ! ip6tables --version >/dev/null 2>&1; then
+	ip6tables='ip6tables'
+else
+	ip6tables=''
+fi
+
+if nft --version >/dev/null 2>&1; then
+	nft='nft'
+else
+	nft=''
+fi
+
+if [ -z "$iptables$ip6tables$nft" ]; then
+	echo "SKIP: Test needs iptables, ip6tables or nft"
+	exit $ksft_skip
+fi
+
+sfx=$(mktemp -u "XXXXXXXX")
+ns1="ns1-$sfx"
+ns2="ns2-$sfx"
+trap "ip netns del $ns1; ip netns del $ns2" EXIT
+
+# create two netns, disable rp_filter in ns2 and
+# keep IPv6 address when moving into VRF
+ip netns add "$ns1"
+ip netns add "$ns2"
+ip netns exec "$ns2" sysctl -q net.ipv4.conf.all.rp_filter=0
+ip netns exec "$ns2" sysctl -q net.ipv4.conf.default.rp_filter=0
+ip netns exec "$ns2" sysctl -q net.ipv6.conf.all.keep_addr_on_down=1
+
+# a standard connection between the netns, should not trigger rp filter
+ip -net "$ns1" link add v0 type veth peer name v0 netns "$ns2"
+ip -net "$ns1" link set v0 up; ip -net "$ns2" link set v0 up
+ip -net "$ns1" a a 192.168.23.2/24 dev v0
+ip -net "$ns2" a a 192.168.23.1/24 dev v0
+ip -net "$ns1" a a fec0:23::2/64 dev v0 nodad
+ip -net "$ns2" a a fec0:23::1/64 dev v0 nodad
+
+# rp filter testing: ns1 sends packets via v0 which ns2 would route back via d0
+ip -net "$ns2" link add d0 type dummy
+ip -net "$ns2" link set d0 up
+ip -net "$ns1" a a 192.168.42.2/24 dev v0
+ip -net "$ns2" a a 192.168.42.1/24 dev d0
+ip -net "$ns1" a a fec0:42::2/64 dev v0 nodad
+ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
+
+# firewall matches to test
+ip netns exec "$ns2" "$iptables" -t raw -A PREROUTING -s 192.168.0.0/16 -m rpfilter
+ip netns exec "$ns2" "$ip6tables" -t raw -A PREROUTING -s fec0::/16 -m rpfilter
+ip netns exec "$ns2" nft -f - <<EOF
+table inet t {
+	chain c {
+		type filter hook prerouting priority raw;
+		ip saddr 192.168.0.0/16 fib saddr . iif oif exists counter
+		ip6 saddr fec0::/16 fib saddr . iif oif exists counter
+	}
+}
+EOF
+
+die() {
+	echo "FAIL: $*"
+	#ip netns exec "$ns2" "$iptables" -t raw -vS
+	#ip netns exec "$ns2" "$ip6tables" -t raw -vS
+	#ip netns exec "$ns2" nft list ruleset
+	exit 1
+}
+
+# check rule counters, return true if rule did not match
+ipt_zero_rule() { # (command)
+	[ -n "$1" ] || return 0
+	ip netns exec "$ns2" "$1" -t raw -vS | grep -q -- "-m rpfilter -c 0 0"
+}
+nft_zero_rule() { # (family)
+	[ -n "$nft" ] || return 0
+	ip netns exec "$ns2" "$nft" list chain inet t c | \
+		grep -q "$1 saddr .* counter packets 0 bytes 0"
+}
+
+netns_ping() { # (netns, args...)
+	local netns="$1"
+	shift
+	ip netns exec "$netns" ping -q -c 1 -W 1 "$@" >/dev/null
+}
+
+testrun() {
+	# clear counters first
+	[ -n "$iptables" ] && ip netns exec "$ns2" "$iptables" -t raw -Z
+	[ -n "$ip6tables" ] && ip netns exec "$ns2" "$ip6tables" -t raw -Z
+	if [ -n "$nft" ]; then
+		(
+			echo "delete table inet t";
+			ip netns exec "$ns2" nft -s list table inet t;
+		) | ip netns exec "$ns2" nft -f -
+	fi
+
+	# test 1: martian traffic should fail rpfilter matches
+	netns_ping "$ns1" -I v0 192.168.42.1 && \
+		die "martian ping 192.168.42.1 succeeded"
+	netns_ping "$ns1" -I v0 fec0:42::1 && \
+		die "martian ping fec0:42::1 succeeded"
+
+	ipt_zero_rule "$iptables" || die "iptables matched martian"
+	ipt_zero_rule "$ip6tables" || die "ip6tables matched martian"
+	nft_zero_rule ip || die "nft IPv4 matched martian"
+	nft_zero_rule ip6 || die "nft IPv6 matched martian"
+
+	# test 2: rpfilter match should pass for regular traffic
+	netns_ping "$ns1" 192.168.23.1 || \
+		die "regular ping 192.168.23.1 failed"
+	netns_ping "$ns1" fec0:23::1 || \
+		die "regular ping fec0:23::1 failed"
+
+	ipt_zero_rule "$iptables" && die "iptables match not effective"
+	ipt_zero_rule "$ip6tables" && die "ip6tables match not effective"
+	nft_zero_rule ip && die "nft IPv4 match not effective"
+	nft_zero_rule ip6 && die "nft IPv6 match not effective"
+
+}
+
+testrun
+
+# repeat test with vrf device in $ns2
+ip -net "$ns2" link add vrf0 type vrf table 10
+ip -net "$ns2" link set vrf0 up
+ip -net "$ns2" link set v0 master vrf0
+
+testrun
+
+echo "PASS: netfilter reverse path match works as intended"
+exit 0
-- 
2.35.1

