Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED23A2AF925
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 20:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbgKKTiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 14:38:10 -0500
Received: from correo.us.es ([193.147.175.20]:45206 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727496AbgKKTiH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 14:38:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 078431878D5
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:38:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE72ADA856
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:38:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ED921DA853; Wed, 11 Nov 2020 20:38:05 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F395DA84D;
        Wed, 11 Nov 2020 20:38:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Nov 2020 20:38:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 52BC842EF9E1;
        Wed, 11 Nov 2020 20:38:03 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        razor@blackwall.org, jeremy@azazel.net
Subject: [PATCH net-next,v3 9/9] selftests: netfilter: flowtable bridge and VLAN support
Date:   Wed, 11 Nov 2020 20:37:37 +0100
Message-Id: <20201111193737.1793-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201111193737.1793-1-pablo@netfilter.org>
References: <20201111193737.1793-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds two new tests to cover bridge and VLAN support:

- Add a bridge device to the Router1 (nsr1) container and attach the
  veth0 device to the bridge. Set the IP address to the bridge device
  to exercise the bridge forwarding path.

- Add VLAN encapsulation between to the bridge device in the Router1 and
  one of the sender containers (ns1).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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

