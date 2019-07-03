Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 559235E7A5
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfGCPUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:20:13 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:36835 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCPUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 11:20:13 -0400
Received: by mail-qt1-f182.google.com with SMTP id z4so346446qtc.3
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 08:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MIlUQxFsb2db2WQ6kov9u8rpQ3U0K+sn4hwe1MLLEbE=;
        b=OKIJqdZXTJlmFhbnJAgRqoXCPYlETjniZEe2ZeuKbrwSANAjUgf/gM8vsEoJId+S7v
         2DQE0b5XAf6wuZGLaTMEj3RR9FB0ZkhF2N/fh/ce5fKAkLnFls6Yrz/ZDrtVHIUZZwkT
         VvgoFcO1iNkPJPTyO9e5OA0SfAk25xa7VX30jEaymqzPet14z8yTpR46kJ98RoT4kjyn
         ZmAt9PpvlUkuVqHda+Qn3vywAGoTTBF1zXCPrYjfTNIx/xnYjk0DsXTG0GYO3nBQp/jw
         0jd/tVWt1qoHYkO2reQRHowkDHW+FItqy3jjjOqKKERUVzVa5ZiFaQcLO5eLnzJ4RCuO
         rUYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MIlUQxFsb2db2WQ6kov9u8rpQ3U0K+sn4hwe1MLLEbE=;
        b=bfLPYRgrakjv8tzmOVBqY7i4jjXi8EjwQNO4fujaktdmdjzAUjkLfNvNzGaq0tZzbC
         e6T07xhR7GF6xqNtz7+lcFC42DrJevvEawFsOg7lLEr+jhTGtM+EL51reBLSYZsY3Iti
         cCvU0EeHu9+rc+ak1bhGc8CkTzkwRUv+bZdVx3CuZCCniBlZp3ASppsBOvW+yAIGBmad
         7lXyi2kXJctGDZeDHDXOdeQL3g8oBuB/hXg+BKAmEYIa9fAaVmZgDoBEotULlOUIfhKd
         PryNIIORJD1hXhSFMUsrbm/3L7z55vpmjk5LvUhWXmGKjtjSj9ehTI0oeGPjPdpYRtr1
         iNXg==
X-Gm-Message-State: APjAAAUm0EGVL33Ihg8EUMhzjVDw3cRIZVhIEfeFM1/OMYbSjQ9U5o1m
        pr5Cse+lYP7eWxlsJvzQ7qV/IPbwvQ==
X-Google-Smtp-Source: APXvYqyXm1eQ/5C2lqGMOJU7cX8+923sjCap6jqKFb5p2/Wn3YzUarzkJWs4Fi7fOLIc/ffrDnvMcw==
X-Received: by 2002:a81:204:: with SMTP id 4mr22045766ywc.107.1562167210782;
        Wed, 03 Jul 2019 08:20:10 -0700 (PDT)
Received: from localhost.localdomain (99-149-127-125.lightspeed.rlghnc.sbcglobal.net. [99.149.127.125])
        by smtp.gmail.com with ESMTPSA id 73sm1243303ywd.88.2019.07.03.08.20.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 08:20:10 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, nikolay@cumulusnetworks.com, dsahern@gmail.com,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net-next 3/3] selftests: forwarding: Test multipath hashing on inner IP pkts for GRE tunnel
Date:   Wed,  3 Jul 2019 11:19:34 -0400
Message-Id: <20190703151934.9567-4-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190703151934.9567-1-ssuryaextr@gmail.com>
References: <20190703151934.9567-1-ssuryaextr@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftest scripts for multipath hashing on inner IP pkts when there
is a single GRE tunnel but there are multiple underlay routes to reach
the other end of the tunnel.

Four cases are covered in these scripts:
    - IPv4 over GRE over IPv4
    - IPv6 over GRE over IPv4
    - IPv4 over GRE over IPv6
    - IPv6 over GRE over IPv6

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 .../net/forwarding/gre_inner_v4_multipath.sh  | 305 +++++++++++++++++
 .../net/forwarding/gre_inner_v6_multipath.sh  | 306 ++++++++++++++++++
 .../forwarding/ip6gre_inner_v4_multipath.sh   | 304 +++++++++++++++++
 .../forwarding/ip6gre_inner_v6_multipath.sh   | 305 +++++++++++++++++
 4 files changed, 1220 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/gre_inner_v4_multipath.sh
 create mode 100755 tools/testing/selftests/net/forwarding/gre_inner_v6_multipath.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_inner_v4_multipath.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_inner_v6_multipath.sh

diff --git a/tools/testing/selftests/net/forwarding/gre_inner_v4_multipath.sh b/tools/testing/selftests/net/forwarding/gre_inner_v4_multipath.sh
new file mode 100755
index 000000000000..4b2ef8a5715f
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/gre_inner_v4_multipath.sh
@@ -0,0 +1,305 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test traffic distribution when there are multiple routes between a GRE over
+# IPv4 tunnel. The tunnel carries IPv4 traffic between multiple hosts.
+# Multiple routes are in the underlay network. With the default multipath
+# policy, SW2 will only look at the outer IP addresses, hence only a single
+# route would be used.
+#
+# +-------------------------+
+# | H1                      |
+# |               $h1 +     |
+# | 192.0.3.{2-62}/24 |     |
+# +-------------------|-----+
+#                     |
+# +-------------------|------------------------+
+# | SW1               |                        |
+# |              $ol1 +                        |
+# |      192.0.3.1/24                          |
+# |                                            |
+# |  + g1 (gre)                                |
+# |    loc=192.0.2.65                          |
+# |    rem=192.0.2.66 --.                      |
+# |    tos=inherit      |                      |
+# |                     v                      |
+# |                     + $ul1                 |
+# |                     | 192.0.2.129/28       |
+# +---------------------|----------------------+
+#                       |
+# +---------------------|----------------------+
+# | SW2                 |                      |
+# |               $ul21 +                      |
+# |      192.0.2.130/28                        |
+# |                   |                        |
+# !   ________________|_____                   |
+# |  /                      \                  |
+# |  |                      |                  |
+# |  + $ul22.111 (vlan)     + $ul22.222 (vlan) |
+# |  | 192.0.2.145/28       | 192.0.2.161/28   |
+# |  |                      |                  |
+# +--|----------------------|------------------+
+#    |                      |
+# +--|----------------------|------------------+
+# |  |                      |                  |
+# |  + $ul32.111 (vlan)     + $ul32.222 (vlan) |
+# |  | 192.0.2.146/28       | 192.0.2.162/28   |
+# |  |                      |                  |
+# |  \______________________/                  |
+# |                   |                        |
+# |                   |                        |
+# |               $ul31 +                      |
+# |      192.0.2.177/28 |                  SW3 |
+# +---------------------|----------------------+
+#                       |
+# +---------------------|----------------------+
+# |                     + $ul4                 |
+# |                     ^ 192.0.2.178/28       |
+# |                     |                      |
+# |  + g2 (gre)         |                      |
+# |    loc=192.0.2.66   |                      |
+# |    rem=192.0.2.65 --'                      |
+# |    tos=inherit                             |
+# |                                            |
+# |               $ol4 +                       |
+# |       192.0.4.1/24 |                   SW4 |
+# +--------------------|-----------------------+
+#                      |
+# +--------------------|---------+
+# |                    |         |
+# |                $h2 +         |
+# |  192.0.4.{2-62}/24        H2 |
+# +------------------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	multipath_ipv4
+"
+
+NUM_NETIFS=10
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.3.2/24
+	ip route add vrf v$h1 192.0.4.0/24 via 192.0.3.1
+}
+
+h1_destroy()
+{
+	ip route del vrf v$h1 192.0.4.0/24 via 192.0.3.1
+	simple_if_fini $h1 192.0.3.2/24
+}
+
+sw1_create()
+{
+	simple_if_init $ol1 192.0.3.1/24
+	__simple_if_init $ul1 v$ol1 192.0.2.129/28
+
+	tunnel_create g1 gre 192.0.2.65 192.0.2.66 tos inherit dev v$ol1
+	__simple_if_init g1 v$ol1 192.0.2.65/32
+	ip route add vrf v$ol1 192.0.2.66/32 via 192.0.2.130
+
+	ip route add vrf v$ol1 192.0.4.0/24 nexthop dev g1
+}
+
+sw1_destroy()
+{
+	ip route del vrf v$ol1 192.0.4.0/24
+
+	ip route del vrf v$ol1 192.0.2.66/32
+	__simple_if_fini g1 192.0.2.65/32
+	tunnel_destroy g1
+
+	__simple_if_fini $ul1 192.0.2.129/28
+	simple_if_fini $ol1 192.0.3.1/24
+}
+
+sw2_create()
+{
+	simple_if_init $ul21 192.0.2.130/28
+	__simple_if_init $ul22 v$ul21
+	vlan_create $ul22 111 v$ul21 192.0.2.145/28
+	vlan_create $ul22 222 v$ul21 192.0.2.161/28
+
+	ip route add vrf v$ul21 192.0.2.65/32 via 192.0.2.129
+	ip route add vrf v$ul21 192.0.2.66/32 \
+	   nexthop via 192.0.2.146 \
+	   nexthop via 192.0.2.162
+}
+
+sw2_destroy()
+{
+	ip route del vrf v$ul21 192.0.2.66/32
+	ip route del vrf v$ul21 192.0.2.65/32
+
+	vlan_destroy $ul22 222
+	vlan_destroy $ul22 111
+	__simple_if_fini $ul22
+	simple_if_fini $ul21 192.0.2.130/28
+}
+
+sw3_create()
+{
+	simple_if_init $ul31 192.0.2.177/28
+	__simple_if_init $ul32 v$ul31
+	vlan_create $ul32 111 v$ul31 192.0.2.146/28
+	vlan_create $ul32 222 v$ul31 192.0.2.162/28
+
+	ip route add vrf v$ul31 192.0.2.66/32 via 192.0.2.178
+	ip route add vrf v$ul31 192.0.2.65/32 \
+	   nexthop via 192.0.2.145 \
+	   nexthop via 192.0.2.161
+
+	tc qdisc add dev $ul32 clsact
+	tc filter add dev $ul32 ingress pref 111 prot 802.1Q \
+	   flower vlan_id 111 action pass
+	tc filter add dev $ul32 ingress pref 222 prot 802.1Q \
+	   flower vlan_id 222 action pass
+}
+
+sw3_destroy()
+{
+	tc qdisc del dev $ul32 clsact
+
+	ip route del vrf v$ul31 192.0.2.65/32
+	ip route del vrf v$ul31 192.0.2.66/32
+
+	vlan_destroy $ul32 222
+	vlan_destroy $ul32 111
+	__simple_if_fini $ul32
+	simple_if_fini $ul31 192.0.2.177/28
+}
+
+sw4_create()
+{
+	simple_if_init $ol4 192.0.4.1/24
+	__simple_if_init $ul4 v$ol4 192.0.2.178/28
+
+	tunnel_create g2 gre 192.0.2.66 192.0.2.65 tos inherit dev v$ol4
+	__simple_if_init g2 v$ol4 192.0.2.66/32
+	ip route add vrf v$ol4 192.0.2.65/32 via 192.0.2.177
+
+	ip route add vrf v$ol4 192.0.3.0/24 nexthop dev g2
+}
+
+sw4_destroy()
+{
+	ip route del vrf v$ol4 192.0.3.0/24
+
+	ip route del vrf v$ol4 192.0.2.65/32
+	__simple_if_fini g2 192.0.2.66/32
+	tunnel_destroy g2
+
+	__simple_if_fini $ul4 192.0.2.178/28
+	simple_if_fini $ol4 192.0.4.1/24
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.4.2/24
+	ip route add vrf v$h2 192.0.3.0/24 via 192.0.4.1
+}
+
+h2_destroy()
+{
+	ip route del vrf v$h2 192.0.3.0/24 via 192.0.4.1
+	simple_if_fini $h2 192.0.4.2/24
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+
+	ol1=${NETIFS[p2]}
+	ul1=${NETIFS[p3]}
+
+	ul21=${NETIFS[p4]}
+	ul22=${NETIFS[p5]}
+
+	ul32=${NETIFS[p6]}
+	ul31=${NETIFS[p7]}
+
+	ul4=${NETIFS[p8]}
+	ol4=${NETIFS[p9]}
+
+	h2=${NETIFS[p10]}
+
+	vrf_prepare
+	h1_create
+	sw1_create
+	sw2_create
+	sw3_create
+	sw4_create
+	h2_create
+
+	forwarding_enable
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	forwarding_restore
+
+	h2_destroy
+	sw4_destroy
+	sw3_destroy
+	sw2_destroy
+	sw1_destroy
+	h1_destroy
+	vrf_cleanup
+}
+
+multipath4_test()
+{
+	local what=$1; shift
+	local weight1=$1; shift
+	local weight2=$1; shift
+
+	sysctl_set net.ipv4.fib_multipath_hash_policy 2
+	ip route replace vrf v$ul21 192.0.2.66/32 \
+	   nexthop via 192.0.2.146 weight $weight1 \
+	   nexthop via 192.0.2.162 weight $weight2
+
+	local t0_111=$(tc_rule_stats_get $ul32 111 ingress)
+	local t0_222=$(tc_rule_stats_get $ul32 222 ingress)
+
+	ip vrf exec v$h1 \
+	   $MZ $h1 -q -p 64 -A "192.0.3.2-192.0.3.62" -B "192.0.4.2-192.0.4.62" \
+	       -d 1msec -c 50 -t udp "sp=1024,dp=1024"
+	sleep 1
+
+	local t1_111=$(tc_rule_stats_get $ul32 111 ingress)
+	local t1_222=$(tc_rule_stats_get $ul32 222 ingress)
+
+	local d111=$((t1_111 - t0_111))
+	local d222=$((t1_222 - t0_222))
+	multipath_eval "$what" $weight1 $weight2 $d111 $d222
+
+	ip route replace vrf v$ul21 192.0.2.66/32 \
+	   nexthop via 192.0.2.146 \
+	   nexthop via 192.0.2.162
+	sysctl_restore net.ipv4.fib_multipath_hash_policy
+}
+
+ping_ipv4()
+{
+	ping_test $h1 192.0.4.2
+}
+
+multipath_ipv4()
+{
+	log_info "Running IPv4 over GRE over IPv4 multipath tests"
+	multipath4_test "ECMP" 1 1
+	multipath4_test "Weighted MP 2:1" 2 1
+	multipath4_test "Weighted MP 11:45" 11 45
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/gre_inner_v6_multipath.sh b/tools/testing/selftests/net/forwarding/gre_inner_v6_multipath.sh
new file mode 100755
index 000000000000..4557a4c6edac
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/gre_inner_v6_multipath.sh
@@ -0,0 +1,306 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test traffic distribution when there are multiple routes between a GRE over
+# IPv4 tunnel. The tunnel carries IPv6 traffic between multiple hosts.
+# Multiple routes are in the underlay network. With the default multipath
+# policy, SW2 will only look at the outer IP addresses, hence only a single
+# route would be used.
+#
+# +-------------------------+
+# | H1                      |
+# |               $h1 +     |
+# |  2001:db8:1::2/64 |     |
+# +-------------------|-----+
+#                     |
+# +-------------------|------------------------+
+# | SW1               |                        |
+# |              $ol1 +                        |
+# |  2001:db8:1::1/64                          |
+# |                                            |
+# |  + g1 (gre)                                |
+# |    loc=192.0.2.65                          |
+# |    rem=192.0.2.66 --.                      |
+# |    tos=inherit      |                      |
+# |                     v                      |
+# |                     + $ul1                 |
+# |                     | 192.0.2.129/28       |
+# +---------------------|----------------------+
+#                       |
+# +---------------------|----------------------+
+# | SW2                 |                      |
+# |               $ul21 +                      |
+# |      192.0.2.130/28                        |
+# |                   |                        |
+# !   ________________|_____                   |
+# |  /                      \                  |
+# |  |                      |                  |
+# |  + $ul22.111 (vlan)     + $ul22.222 (vlan) |
+# |  | 192.0.2.145/28       | 192.0.2.161/28   |
+# |  |                      |                  |
+# +--|----------------------|------------------+
+#    |                      |
+# +--|----------------------|------------------+
+# |  |                      |                  |
+# |  + $ul32.111 (vlan)     + $ul32.222 (vlan) |
+# |  | 192.0.2.146/28       | 192.0.2.162/28   |
+# |  |                      |                  |
+# |  \______________________/                  |
+# |                   |                        |
+# |                   |                        |
+# |               $ul31 +                      |
+# |      192.0.2.177/28 |                  SW3 |
+# +---------------------|----------------------+
+#                       |
+# +---------------------|----------------------+
+# |                     + $ul4                 |
+# |                     ^ 192.0.2.178/28       |
+# |                     |                      |
+# |  + g2 (gre)         |                      |
+# |    loc=192.0.2.66   |                      |
+# |    rem=192.0.2.65 --'                      |
+# |    tos=inherit                             |
+# |                                            |
+# |               $ol4 +                       |
+# |   2001:db8:2::1/64 |                   SW4 |
+# +--------------------|-----------------------+
+#                      |
+# +--------------------|---------+
+# |                    |         |
+# |                $h2 +         |
+# |   2001:db8:2::2/64        H2 |
+# +------------------------------+
+
+ALL_TESTS="
+	ping_ipv6
+	multipath_ipv6
+"
+
+NUM_NETIFS=10
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 2001:db8:1::2/64
+	ip -6 route add vrf v$h1 2001:db8:2::/64 via 2001:db8:1::1
+}
+
+h1_destroy()
+{
+	ip -6 route del vrf v$h1 2001:db8:2::/64 via 2001:db8:1::1
+	simple_if_fini $h1 2001:db8:1::2/64
+}
+
+sw1_create()
+{
+	simple_if_init $ol1 2001:db8:1::1/64
+	__simple_if_init $ul1 v$ol1 192.0.2.129/28
+
+	tunnel_create g1 gre 192.0.2.65 192.0.2.66 tos inherit dev v$ol1
+	__simple_if_init g1 v$ol1 192.0.2.65/32
+	ip route add vrf v$ol1 192.0.2.66/32 via 192.0.2.130
+
+	ip -6 route add vrf v$ol1 2001:db8:2::/64 dev g1
+}
+
+sw1_destroy()
+{
+	ip -6 route del vrf v$ol1 2001:db8:2::/64
+
+	ip route del vrf v$ol1 192.0.2.66/32
+	__simple_if_fini g1 192.0.2.65/32
+	tunnel_destroy g1
+
+	__simple_if_fini $ul1 192.0.2.129/28
+	simple_if_fini $ol1 2001:db8:1::1/64
+}
+
+sw2_create()
+{
+	simple_if_init $ul21 192.0.2.130/28
+	__simple_if_init $ul22 v$ul21
+	vlan_create $ul22 111 v$ul21 192.0.2.145/28
+	vlan_create $ul22 222 v$ul21 192.0.2.161/28
+
+	ip route add vrf v$ul21 192.0.2.65/32 via 192.0.2.129
+	ip route add vrf v$ul21 192.0.2.66/32 \
+	   nexthop via 192.0.2.146 \
+	   nexthop via 192.0.2.162
+}
+
+sw2_destroy()
+{
+	ip route del vrf v$ul21 192.0.2.66/32
+	ip route del vrf v$ul21 192.0.2.65/32
+
+	vlan_destroy $ul22 222
+	vlan_destroy $ul22 111
+	__simple_if_fini $ul22
+	simple_if_fini $ul21 192.0.2.130/28
+}
+
+sw3_create()
+{
+	simple_if_init $ul31 192.0.2.177/28
+	__simple_if_init $ul32 v$ul31
+	vlan_create $ul32 111 v$ul31 192.0.2.146/28
+	vlan_create $ul32 222 v$ul31 192.0.2.162/28
+
+	ip route add vrf v$ul31 192.0.2.66/32 via 192.0.2.178
+	ip route add vrf v$ul31 192.0.2.65/32 \
+	   nexthop via 192.0.2.145 \
+	   nexthop via 192.0.2.161
+
+	tc qdisc add dev $ul32 clsact
+	tc filter add dev $ul32 ingress pref 111 prot 802.1Q \
+	   flower vlan_id 111 action pass
+	tc filter add dev $ul32 ingress pref 222 prot 802.1Q \
+	   flower vlan_id 222 action pass
+}
+
+sw3_destroy()
+{
+	tc qdisc del dev $ul32 clsact
+
+	ip route del vrf v$ul31 192.0.2.65/32
+	ip route del vrf v$ul31 192.0.2.66/32
+
+	vlan_destroy $ul32 222
+	vlan_destroy $ul32 111
+	__simple_if_fini $ul32
+	simple_if_fini $ul31 192.0.2.177/28
+}
+
+sw4_create()
+{
+	simple_if_init $ol4 2001:db8:2::1/64
+	__simple_if_init $ul4 v$ol4 192.0.2.178/28
+
+	tunnel_create g2 gre 192.0.2.66 192.0.2.65 tos inherit dev v$ol4
+	__simple_if_init g2 v$ol4 192.0.2.66/32
+	ip route add vrf v$ol4 192.0.2.65/32 via 192.0.2.177
+
+	ip -6 route add vrf v$ol4 2001:db8:1::/64 dev g2
+}
+
+sw4_destroy()
+{
+	ip -6 route del vrf v$ol4 2001:db8:1::/64
+
+	ip route del vrf v$ol4 192.0.2.65/32
+	__simple_if_fini g2 192.0.2.66/32
+	tunnel_destroy g2
+
+	__simple_if_fini $ul4 192.0.2.178/28
+	simple_if_fini $ol4 2001:db8:2::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 2001:db8:2::2/64
+	ip -6 route add vrf v$h2 2001:db8:1::/64 via 2001:db8:2::1
+}
+
+h2_destroy()
+{
+	ip -6 route del vrf v$h2 2001:db8:1::/64 via 2001:db8:2::1
+	simple_if_fini $h2 2001:db8:2::2/64
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+
+	ol1=${NETIFS[p2]}
+	ul1=${NETIFS[p3]}
+
+	ul21=${NETIFS[p4]}
+	ul22=${NETIFS[p5]}
+
+	ul32=${NETIFS[p6]}
+	ul31=${NETIFS[p7]}
+
+	ul4=${NETIFS[p8]}
+	ol4=${NETIFS[p9]}
+
+	h2=${NETIFS[p10]}
+
+	vrf_prepare
+	h1_create
+	sw1_create
+	sw2_create
+	sw3_create
+	sw4_create
+	h2_create
+
+	forwarding_enable
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	forwarding_restore
+
+	h2_destroy
+	sw4_destroy
+	sw3_destroy
+	sw2_destroy
+	sw1_destroy
+	h1_destroy
+	vrf_cleanup
+}
+
+multipath6_test()
+{
+	local what=$1; shift
+	local weight1=$1; shift
+	local weight2=$1; shift
+
+	sysctl_set net.ipv4.fib_multipath_hash_policy 2
+	ip route replace vrf v$ul21 192.0.2.66/32 \
+	   nexthop via 192.0.2.146 weight $weight1 \
+	   nexthop via 192.0.2.162 weight $weight2
+
+	local t0_111=$(tc_rule_stats_get $ul32 111 ingress)
+	local t0_222=$(tc_rule_stats_get $ul32 222 ingress)
+
+	ip vrf exec v$h1 \
+	   $MZ $h1 -6 -q -p 64 -A "2001:db8:1::2-2001:db8:1::1e" \
+	       -B "2001:db8:2::2-2001:db8:2::1e" \
+	       -d 1msec -c 50 -t udp "sp=1024,dp=1024"
+	sleep 1
+
+	local t1_111=$(tc_rule_stats_get $ul32 111 ingress)
+	local t1_222=$(tc_rule_stats_get $ul32 222 ingress)
+
+	local d111=$((t1_111 - t0_111))
+	local d222=$((t1_222 - t0_222))
+	multipath_eval "$what" $weight1 $weight2 $d111 $d222
+
+	ip route replace vrf v$ul21 192.0.2.66/32 \
+	   nexthop via 192.0.2.146 \
+	   nexthop via 192.0.2.162
+	sysctl_restore net.ipv4.fib_multipath_hash_policy
+}
+
+ping_ipv6()
+{
+	ping_test $h1 2001:db8:2::2
+}
+
+multipath_ipv6()
+{
+	log_info "Running IPv6 over GRE over IPv4 multipath tests"
+	multipath6_test "ECMP" 1 1
+	multipath6_test "Weighted MP 2:1" 2 1
+	multipath6_test "Weighted MP 11:45" 11 45
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/ip6gre_inner_v4_multipath.sh b/tools/testing/selftests/net/forwarding/ip6gre_inner_v4_multipath.sh
new file mode 100755
index 000000000000..ca4f383d6492
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ip6gre_inner_v4_multipath.sh
@@ -0,0 +1,304 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test traffic distribution when there are multiple routes between a GRE over
+# IPv6 tunnel. The tunnel carries IPv4 traffic between multiple hosts.
+# Multiple routes are in the underlay network. With the default multipath
+# policy, SW2 will only look at the outer IP addresses, hence only a single
+# route would be used.
+#
+# +-------------------------+
+# | H1                      |
+# |               $h1 +     |
+# | 192.0.3.{2-62}/24 |     |
+# +-------------------|-----+
+#                     |
+# +-------------------|-------------------------+
+# | SW1               |                         |
+# |              $ol1 +                         |
+# |      192.0.3.1/24                           |
+# |                                             |
+# |  + g1 (gre)                                 |
+# |    loc=2001:db8:40::1                       |
+# |    rem=2001:db8:40::2 --.                   |
+# |    tos=inherit          |                   |
+# |                         v                   |
+# |                         + $ul1              |
+# |                         | 2001:db8:80::1/64 |
+# +-------------------------|-------------------+
+#                           |
+# +-------------------------|-------------------+
+# | SW2                     |                   |
+# |                   $ul21 +                   |
+# |       2001:db8:80::2/64                     |
+# |                   |                         |
+# !   ________________|_____                    |
+# |  /                      \                   |
+# |  |                      |                   |
+# |  + $ul22.111 (vlan)     + $ul22.222 (vlan)  |
+# |  | 2001:db8:81::1/64    | 2001:db8:82::1/64 |
+# |  |                      |                   |
+# +--|----------------------|-------------------+
+#    |                      |
+# +--|----------------------|-------------------+
+# |  |                      |                   |
+# |  + $ul32.111 (vlan)     + $ul32.222 (vlan)  |
+# |  | 2001:db8:81::2/64    | 2001:db8:82::2/64 |
+# |  |                      |                   |
+# |  \______________________/                   |
+# |                   |                         |
+# |                   |                         |
+# |                   $ul31 +                   |
+# |       2001:db8:83::2/64 |               SW3 |
+# +-------------------------|-------------------+
+#                           |
+# +-------------------------|-------------------+
+# |                         + $ul4              |
+# |                         ^ 2001:db8:83::1/64 |
+# |  + g2 (gre)             |                   |
+# |    loc=2001:db8:40::2   |                   |
+# |    rem=2001:db8:40::1 --'                   |
+# |    tos=inherit                              |
+# |                                             |
+# |               $ol4 +                        |
+# |       192.0.4.1/24 |                    SW4 |
+# +--------------------|------------------------+
+#                      |
+# +--------------------|---------+
+# |                    |         |
+# |                $h2 +         |
+# |  192.0.4.{2-62}/24        H2 |
+# +------------------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	multipath_ipv4
+"
+
+NUM_NETIFS=10
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.3.2/24
+	ip route add vrf v$h1 192.0.4.0/24 via 192.0.3.1
+}
+
+h1_destroy()
+{
+	ip route del vrf v$h1 192.0.4.0/24 via 192.0.3.1
+	simple_if_fini $h1 192.0.3.2/24
+}
+
+sw1_create()
+{
+	simple_if_init $ol1 192.0.3.1/24
+	__simple_if_init $ul1 v$ol1 2001:db8:80::1/64
+
+	tunnel_create g1 ip6gre 2001:db8:40::1 2001:db8:40::2 tos inherit dev v$ol1
+	__simple_if_init g1 v$ol1 2001:db8:40::1/128
+	ip -6 route add vrf v$ol1 2001:db8:40::2/128 via 2001:db8:80::2
+
+	ip route add vrf v$ol1 192.0.4.0/24 nexthop dev g1
+}
+
+sw1_destroy()
+{
+	ip route del vrf v$ol1 192.0.4.0/24
+
+	ip -6 route del vrf v$ol1 2001:db8:40::2/128
+	__simple_if_fini g1 2001:db8:40::1/128
+	tunnel_destroy g1
+
+	__simple_if_fini $ul1 2001:db8:80::1/64
+	simple_if_fini $ol1 192.0.3.1/24
+}
+
+sw2_create()
+{
+	simple_if_init $ul21 2001:db8:80::2/64
+	__simple_if_init $ul22 v$ul21
+	vlan_create $ul22 111 v$ul21 2001:db8:81::1/64
+	vlan_create $ul22 222 v$ul21 2001:db8:82::1/64
+
+	ip -6 route add vrf v$ul21 2001:db8:40::1/128 via 2001:db8:80::1
+	ip -6 route add vrf v$ul21 2001:db8:40::2/128 \
+	   nexthop via 2001:db8:81::2 \
+	   nexthop via 2001:db8:82::2
+}
+
+sw2_destroy()
+{
+	ip -6 route del vrf v$ul21 2001:db8:40::2/128
+	ip -6 route del vrf v$ul21 2001:db8:40::1/128
+
+	vlan_destroy $ul22 222
+	vlan_destroy $ul22 111
+	__simple_if_fini $ul22
+	simple_if_fini $ul21 2001:db8:80::2/64
+}
+
+sw3_create()
+{
+	simple_if_init $ul31 2001:db8:83::2/64
+	__simple_if_init $ul32 v$ul31
+	vlan_create $ul32 111 v$ul31 2001:db8:81::2/64
+	vlan_create $ul32 222 v$ul31 2001:db8:82::2/64
+
+	ip -6 route add vrf v$ul31 2001:db8:40::2/128 via 2001:db8:83::1
+	ip -6 route add vrf v$ul31 2001:db8:40::1/128 \
+	   nexthop via 2001:db8:81::1 \
+	   nexthop via 2001:db8:82::1
+
+	tc qdisc add dev $ul32 clsact
+	tc filter add dev $ul32 ingress pref 111 prot 802.1Q \
+	   flower vlan_id 111 action pass
+	tc filter add dev $ul32 ingress pref 222 prot 802.1Q \
+	   flower vlan_id 222 action pass
+}
+
+sw3_destroy()
+{
+	tc qdisc del dev $ul32 clsact
+
+	ip -6 route del vrf v$ul31 2001:db8:40::1/128
+	ip -6 route del vrf v$ul31 2001:db8:40::2/128
+
+	vlan_destroy $ul32 222
+	vlan_destroy $ul32 111
+	__simple_if_fini $ul32
+	simple_if_fini $ul31 2001:Db8:83::2/64
+}
+
+sw4_create()
+{
+	simple_if_init $ol4 192.0.4.1/24
+	__simple_if_init $ul4 v$ol4 2001:db8:83::1/64
+
+	tunnel_create g2 ip6gre 2001:db8:40::2 2001:db8:40::1 tos inherit dev v$ol4
+	__simple_if_init g2 v$ol4 2001:db8:40::2/128
+	ip -6 route add vrf v$ol4 2001:db8:40::1/128 via 2001:db8:83::2
+
+	ip route add vrf v$ol4 192.0.3.0/24 nexthop dev g2
+}
+
+sw4_destroy()
+{
+	ip route del vrf v$ol4 192.0.3.0/24
+
+	ip -6 route del vrf v$ol4 2001:db8:40::1/128
+	__simple_if_fini g2 2001:db8:40::2/128
+	tunnel_destroy g2
+
+	__simple_if_fini $ul4 2001:db8:83::1/64
+	simple_if_fini $ol4 192.0.4.1/24
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.4.2/24
+	ip route add vrf v$h2 192.0.3.0/24 via 192.0.4.1
+}
+
+h2_destroy()
+{
+	ip route del vrf v$h2 192.0.3.0/24 via 192.0.4.1
+	simple_if_fini $h2 192.0.4.2/24
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+
+	ol1=${NETIFS[p2]}
+	ul1=${NETIFS[p3]}
+
+	ul21=${NETIFS[p4]}
+	ul22=${NETIFS[p5]}
+
+	ul32=${NETIFS[p6]}
+	ul31=${NETIFS[p7]}
+
+	ul4=${NETIFS[p8]}
+	ol4=${NETIFS[p9]}
+
+	h2=${NETIFS[p10]}
+
+	vrf_prepare
+	h1_create
+	sw1_create
+	sw2_create
+	sw3_create
+	sw4_create
+	h2_create
+
+	forwarding_enable
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	forwarding_restore
+
+	h2_destroy
+	sw4_destroy
+	sw3_destroy
+	sw2_destroy
+	sw1_destroy
+	h1_destroy
+	vrf_cleanup
+}
+
+multipath4_test()
+{
+	local what=$1; shift
+	local weight1=$1; shift
+	local weight2=$1; shift
+
+	sysctl_set net.ipv6.fib_multipath_hash_policy 2
+	ip route replace vrf v$ul21 2001:db8:40::2/128 \
+	   nexthop via 2001:db8:81::2 weight $weight1 \
+	   nexthop via 2001:db8:82::2 weight $weight2
+
+	local t0_111=$(tc_rule_stats_get $ul32 111 ingress)
+	local t0_222=$(tc_rule_stats_get $ul32 222 ingress)
+
+	ip vrf exec v$h1 \
+	   $MZ $h1 -q -p 64 -A "192.0.3.2-192.0.3.62" -B "192.0.4.2-192.0.4.62" \
+	       -d 1msec -c 50 -t udp "sp=1024,dp=1024"
+	sleep 1
+
+	local t1_111=$(tc_rule_stats_get $ul32 111 ingress)
+	local t1_222=$(tc_rule_stats_get $ul32 222 ingress)
+
+	local d111=$((t1_111 - t0_111))
+	local d222=$((t1_222 - t0_222))
+	multipath_eval "$what" $weight1 $weight2 $d111 $d222
+
+	ip route replace vrf v$ul21 2001:db8:40::2/128 \
+	   nexthop via 2001:db8:81::2 \
+	   nexthop via 2001:db8:82::2
+	sysctl_restore net.ipv6.fib_multipath_hash_policy
+}
+
+ping_ipv4()
+{
+	ping_test $h1 192.0.4.2
+}
+
+multipath_ipv4()
+{
+	log_info "Running IPv4 over GRE over IPv6 multipath tests"
+	multipath4_test "ECMP" 1 1
+	multipath4_test "Weighted MP 2:1" 2 1
+	multipath4_test "Weighted MP 11:45" 11 45
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/ip6gre_inner_v6_multipath.sh b/tools/testing/selftests/net/forwarding/ip6gre_inner_v6_multipath.sh
new file mode 100755
index 000000000000..c167acd33cb5
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ip6gre_inner_v6_multipath.sh
@@ -0,0 +1,305 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test traffic distribution when there are multiple routes between a GRE over
+# IPv6 tunnel. The tunnel carries IPv6 traffic between multiple hosts.
+# Multiple routes are in the underlay network. With the default multipath
+# policy, SW2 will only look at the outer IP addresses, hence only a single
+# route would be used.
+#
+# +-------------------------+
+# | H1                      |
+# |               $h1 +     |
+# |  2001:db8:1::2/64 |     |
+# +-------------------|-----+
+#                     |
+# +-------------------|-------------------------+
+# | SW1               |                         |
+# |              $ol1 +                         |
+# |  2001:db8:1::1/64                           |
+# |                                             |
+# |  + g1 (gre)                                 |
+# |    loc=2001:db8:40::1                       |
+# |    rem=2001:db8:40::2 --.                   |
+# |    tos=inherit          |                   |
+# |                         v                   |
+# |                         + $ul1              |
+# |                         | 2001:db8:80::1/64 |
+# +-------------------------|-------------------+
+#                           |
+# +-------------------------|-------------------+
+# | SW2                     |                   |
+# |                   $ul21 +                   |
+# |       2001:db8:80::2/64                     |
+# |                   |                         |
+# !   ________________|_____                    |
+# |  /                      \                   |
+# |  |                      |                   |
+# |  + $ul22.111 (vlan)     + $ul22.222 (vlan)  |
+# |  | 2001:db8:81::1/64    | 2001:db8:82::1/64 |
+# |  |                      |                   |
+# +--|----------------------|-------------------+
+#    |                      |
+# +--|----------------------|-------------------+
+# |  |                      |                   |
+# |  + $ul32.111 (vlan)     + $ul32.222 (vlan)  |
+# |  | 2001:db8:81::2/64    | 2001:db8:82::2/64 |
+# |  |                      |                   |
+# |  \______________________/                   |
+# |                   |                         |
+# |                   |                         |
+# |                   $ul31 +                   |
+# |       2001:db8:83::2/64 |               SW3 |
+# +-------------------------|-------------------+
+#                           |
+# +-------------------------|-------------------+
+# |                         + $ul4              |
+# |                         ^ 2001:db8:83::1/64 |
+# |  + g2 (gre)             |                   |
+# |    loc=2001:db8:40::2   |                   |
+# |    rem=2001:db8:40::1 --'                   |
+# |    tos=inherit                              |
+# |                                             |
+# |               $ol4 +                        |
+# |   2001:db8:2::1/64 |                    SW4 |
+# +--------------------|------------------------+
+#                      |
+# +--------------------|---------+
+# |                    |         |
+# |                $h2 +         |
+# |   2001:db8:2::2/64        H2 |
+# +------------------------------+
+
+ALL_TESTS="
+	ping_ipv6
+	multipath_ipv6
+"
+
+NUM_NETIFS=10
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 2001:db8:1::2/64
+	ip -6 route add vrf v$h1 2001:db8:2::/64 via 2001:db8:1::1
+}
+
+h1_destroy()
+{
+	ip -6 route del vrf v$h1 2001:db8:2::/64 via 2001:db8:1::1
+	simple_if_fini $h1 2001:db8:1::2/64
+}
+
+sw1_create()
+{
+	simple_if_init $ol1 2001:db8:1::1/64
+	__simple_if_init $ul1 v$ol1 2001:db8:80::1/64
+
+	tunnel_create g1 ip6gre 2001:db8:40::1 2001:db8:40::2 tos inherit dev v$ol1
+	__simple_if_init g1 v$ol1 2001:db8:40::1/128
+	ip -6 route add vrf v$ol1 2001:db8:40::2/128 via 2001:db8:80::2
+
+	ip -6 route add vrf v$ol1 2001:db8:2::/64 dev g1
+}
+
+sw1_destroy()
+{
+	ip -6 route del vrf v$ol1 2001:db8:2::/64
+
+	ip -6 route del vrf v$ol1 2001:db8:40::2/128
+	__simple_if_fini g1 2001:db8:40::1/128
+	tunnel_destroy g1
+
+	__simple_if_fini $ul1 2001:db8:80::1/64
+	simple_if_fini $ol1 2001:db8:1::1/64
+}
+
+sw2_create()
+{
+	simple_if_init $ul21 2001:db8:80::2/64
+	__simple_if_init $ul22 v$ul21
+	vlan_create $ul22 111 v$ul21 2001:db8:81::1/64
+	vlan_create $ul22 222 v$ul21 2001:db8:82::1/64
+
+	ip -6 route add vrf v$ul21 2001:db8:40::1/128 via 2001:db8:80::1
+	ip -6 route add vrf v$ul21 2001:db8:40::2/128 \
+	   nexthop via 2001:db8:81::2 \
+	   nexthop via 2001:db8:82::2
+}
+
+sw2_destroy()
+{
+	ip -6 route del vrf v$ul21 2001:db8:40::2/128
+	ip -6 route del vrf v$ul21 2001:db8:40::1/128
+
+	vlan_destroy $ul22 222
+	vlan_destroy $ul22 111
+	__simple_if_fini $ul22
+	simple_if_fini $ul21 2001:db8:80::2/64
+}
+
+sw3_create()
+{
+	simple_if_init $ul31 2001:db8:83::2/64
+	__simple_if_init $ul32 v$ul31
+	vlan_create $ul32 111 v$ul31 2001:db8:81::2/64
+	vlan_create $ul32 222 v$ul31 2001:db8:82::2/64
+
+	ip -6 route add vrf v$ul31 2001:db8:40::2/128 via 2001:db8:83::1
+	ip -6 route add vrf v$ul31 2001:db8:40::1/128 \
+	   nexthop via 2001:db8:81::1 \
+	   nexthop via 2001:db8:82::1
+
+	tc qdisc add dev $ul32 clsact
+	tc filter add dev $ul32 ingress pref 111 prot 802.1Q \
+	   flower vlan_id 111 action pass
+	tc filter add dev $ul32 ingress pref 222 prot 802.1Q \
+	   flower vlan_id 222 action pass
+}
+
+sw3_destroy()
+{
+	tc qdisc del dev $ul32 clsact
+
+	ip -6 route del vrf v$ul31 2001:db8:40::1/128
+	ip -6 route del vrf v$ul31 2001:db8:40::2/128
+
+	vlan_destroy $ul32 222
+	vlan_destroy $ul32 111
+	__simple_if_fini $ul32
+	simple_if_fini $ul31 2001:Db8:83::2/64
+}
+
+sw4_create()
+{
+	simple_if_init $ol4 2001:db8:2::1/64
+	__simple_if_init $ul4 v$ol4 2001:db8:83::1/64
+
+	tunnel_create g2 ip6gre 2001:db8:40::2 2001:db8:40::1 tos inherit dev v$ol4
+	__simple_if_init g2 v$ol4 2001:db8:40::2/128
+	ip -6 route add vrf v$ol4 2001:db8:40::1/128 via 2001:db8:83::2
+
+	ip -6 route add vrf v$ol4 2001:db8:1::/64 dev g2
+}
+
+sw4_destroy()
+{
+	ip -6 route del vrf v$ol4 2001:db8:1::/64
+
+	ip -6 route del vrf v$ol4 2001:db8:40::1/128
+	__simple_if_fini g2 2001:db8:40::2/128
+	tunnel_destroy g2
+
+	__simple_if_fini $ul4 2001:db8:83::1/64
+	simple_if_fini $ol4 2001:db8:2::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 2001:db8:2::2/64
+	ip -6 route add vrf v$h2 2001:db8:1::/64 via 2001:db8:2::1
+}
+
+h2_destroy()
+{
+	ip -6 route del vrf v$h2 2001:db8:1::/64 via 2001:db8:2::1
+	simple_if_fini $h2 2001:db8:2::2/64
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+
+	ol1=${NETIFS[p2]}
+	ul1=${NETIFS[p3]}
+
+	ul21=${NETIFS[p4]}
+	ul22=${NETIFS[p5]}
+
+	ul32=${NETIFS[p6]}
+	ul31=${NETIFS[p7]}
+
+	ul4=${NETIFS[p8]}
+	ol4=${NETIFS[p9]}
+
+	h2=${NETIFS[p10]}
+
+	vrf_prepare
+	h1_create
+	sw1_create
+	sw2_create
+	sw3_create
+	sw4_create
+	h2_create
+
+	forwarding_enable
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	forwarding_restore
+
+	h2_destroy
+	sw4_destroy
+	sw3_destroy
+	sw2_destroy
+	sw1_destroy
+	h1_destroy
+	vrf_cleanup
+}
+
+multipath6_test()
+{
+	local what=$1; shift
+	local weight1=$1; shift
+	local weight2=$1; shift
+
+	sysctl_set net.ipv6.fib_multipath_hash_policy 2
+	ip route replace vrf v$ul21 2001:db8:40::2/128 \
+	   nexthop via 2001:db8:81::2 weight $weight1 \
+	   nexthop via 2001:db8:82::2 weight $weight2
+
+	local t0_111=$(tc_rule_stats_get $ul32 111 ingress)
+	local t0_222=$(tc_rule_stats_get $ul32 222 ingress)
+
+	ip vrf exec v$h1 \
+	   $MZ $h1 -6 -q -p 64 -A "2001:db8:1::2-2001:db8:1::1e" \
+	       -B "2001:db8:2::2-2001:db8:2::1e" \
+	       -d 1msec -c 50 -t udp "sp=1024,dp=1024"
+	sleep 1
+
+	local t1_111=$(tc_rule_stats_get $ul32 111 ingress)
+	local t1_222=$(tc_rule_stats_get $ul32 222 ingress)
+
+	local d111=$((t1_111 - t0_111))
+	local d222=$((t1_222 - t0_222))
+	multipath_eval "$what" $weight1 $weight2 $d111 $d222
+
+	ip route replace vrf v$ul21 2001:db8:40::2/128 \
+	   nexthop via 2001:db8:81::2 \
+	   nexthop via 2001:db8:82::2
+	sysctl_restore net.ipv6.fib_multipath_hash_policy
+}
+
+ping_ipv6()
+{
+	ping_test $h1 2001:db8:2::2
+}
+
+multipath_ipv6()
+{
+	log_info "Running IPv6 over GRE over IPv6 multipath tests"
+	multipath6_test "ECMP" 1 1
+	multipath6_test "Weighted MP 2:1" 2 1
+	multipath6_test "Weighted MP 11:45" 11 45
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
-- 
2.17.1

