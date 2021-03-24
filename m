Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A1B346ED5
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhCXBb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:31:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60592 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbhCXBbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:31:20 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 531EB63128;
        Wed, 24 Mar 2021 02:31:09 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 14/24] selftests: netfilter: flowtable bridge and vlan support
Date:   Wed, 24 Mar 2021 02:30:45 +0100
Message-Id: <20210324013055.5619-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds two new tests to cover bridge and vlan support:

- Add a bridge device to the Router1 (nsr1) container and attach the
  veth0 device to the bridge. Set the IP address to the bridge device
  to exercise the bridge forwarding path.

- Add vlan encapsulation between to the bridge device in the Router1 and
  one of the sender containers (ns1).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 .../selftests/netfilter/nft_flowtable.sh      | 82 +++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 431296c0f91c..427d94816f2d 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -371,6 +371,88 @@ else
 	ip netns exec nsr1 nft list ruleset
 fi
 
+# Another test:
+# Add bridge interface br0 to Router1, with NAT enabled.
+ip -net nsr1 link add name br0 type bridge
+ip -net nsr1 addr flush dev veth0
+ip -net nsr1 link set up dev veth0
+ip -net nsr1 link set veth0 master br0
+ip -net nsr1 addr add 10.0.1.1/24 dev br0
+ip -net nsr1 addr add dead:1::1/64 dev br0
+ip -net nsr1 link set up dev br0
+
+ip netns exec nsr1 sysctl net.ipv4.conf.br0.forwarding=1 > /dev/null
+
+# br0 with NAT enabled.
+ip netns exec nsr1 nft -f - <<EOF
+flush table ip nat
+table ip nat {
+   chain prerouting {
+      type nat hook prerouting priority 0; policy accept;
+      meta iif "br0" ip daddr 10.6.6.6 tcp dport 1666 counter dnat ip to 10.0.2.99:12345
+   }
+
+   chain postrouting {
+      type nat hook postrouting priority 0; policy accept;
+      meta oifname "veth1" counter masquerade
+   }
+}
+EOF
+
+if test_tcp_forwarding_nat ns1 ns2; then
+	echo "PASS: flow offloaded for ns1/ns2 with bridge NAT"
+else
+	echo "FAIL: flow offload for ns1/ns2 with bridge NAT" 1>&2
+	ip netns exec nsr1 nft list ruleset
+	ret=1
+fi
+
+# Another test:
+# Add bridge interface br0 to Router1, with NAT and VLAN.
+ip -net nsr1 link set veth0 nomaster
+ip -net nsr1 link set down dev veth0
+ip -net nsr1 link add link veth0 name veth0.10 type vlan id 10
+ip -net nsr1 link set up dev veth0
+ip -net nsr1 link set up dev veth0.10
+ip -net nsr1 link set veth0.10 master br0
+
+ip -net ns1 addr flush dev eth0
+ip -net ns1 link add link eth0 name eth0.10 type vlan id 10
+ip -net ns1 link set eth0 up
+ip -net ns1 link set eth0.10 up
+ip -net ns1 addr add 10.0.1.99/24 dev eth0.10
+ip -net ns1 route add default via 10.0.1.1
+ip -net ns1 addr add dead:1::99/64 dev eth0.10
+
+if test_tcp_forwarding_nat ns1 ns2; then
+	echo "PASS: flow offloaded for ns1/ns2 with bridge NAT and VLAN"
+else
+	echo "FAIL: flow offload for ns1/ns2 with bridge NAT and VLAN" 1>&2
+	ip netns exec nsr1 nft list ruleset
+	ret=1
+fi
+
+# restore test topology (remove bridge and VLAN)
+ip -net nsr1 link set veth0 nomaster
+ip -net nsr1 link set veth0 down
+ip -net nsr1 link set veth0.10 down
+ip -net nsr1 link delete veth0.10 type vlan
+ip -net nsr1 link delete br0 type bridge
+ip -net ns1 addr flush dev eth0.10
+ip -net ns1 link set eth0.10 down
+ip -net ns1 link set eth0 down
+ip -net ns1 link delete eth0.10 type vlan
+
+# restore address in ns1 and nsr1
+ip -net ns1 link set eth0 up
+ip -net ns1 addr add 10.0.1.99/24 dev eth0
+ip -net ns1 route add default via 10.0.1.1
+ip -net ns1 addr add dead:1::99/64 dev eth0
+ip -net ns1 route add default via dead:1::1
+ip -net nsr1 addr add 10.0.1.1/24 dev veth0
+ip -net nsr1 addr add dead:1::1/64 dev veth0
+ip -net nsr1 link set up dev veth0
+
 KEY_SHA="0x"$(ps -xaf | sha1sum | cut -d " " -f 1)
 KEY_AES="0x"$(ps -xaf | md5sum | cut -d " " -f 1)
 SPI1=$RANDOM
-- 
2.20.1

