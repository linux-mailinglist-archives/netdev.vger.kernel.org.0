Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DE4666807
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 01:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbjALAn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 19:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236414AbjALAm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 19:42:58 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3796C321B2
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:42:02 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id fa5so9931962qtb.11
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vUUoLtN86s3kU8vXBVNP59LvAYOKvdDnf2xClyZsG14=;
        b=Wksiz5/zo13YqMCeRrukSjy+opa5asQ+d79WatNVvBDpuOgE9hVYw6oG8E30V+J73C
         LmPke5fbU64JgHhibEMFLMm5gngFf2HEErpN9uKbJX4/bMpeswZD0Ggd2tX+AmW8sITk
         xv2GDQIdMpEa9ijjtRPrIZCHYu0ZGy86uhMl37SoKvF+98kp6GU8ViZlojdUYErTtH+D
         i/hJBQNwAnAKdcQatIons0BoSgG1m76BdOLlzuAsJbn+YqFO6QnJ7c7SAtA/+h/OIfLw
         Z4io4wZwoowwPo9YY4aR7n3DenxD91eDqgeeB467lcBs8FV+N4M357pmW+LyX5q47GZG
         TC7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vUUoLtN86s3kU8vXBVNP59LvAYOKvdDnf2xClyZsG14=;
        b=fF8AQi3NsrpbD3yOK8ucf0O3NZ8OANQEhapswcLsgtCB1yNXnyHClV/lwNTk5aYq+m
         kslH4kIMEWDxgtV21S05eg8B2Sacf+mv0Mcglq91QLK+qQROIg5ANpWVGsaE7cQwdR8U
         tJgO7pTgBLsYy8oyoO6BbR9Z3e5TA4jdcNDVmKlJ7rpSd6yakdpZVj2VXC8Ufoh/Ux1Q
         is4ClRn3T2EmSmXpcrND1sxR+QQBmoCeyJ+F4MmHnqrnsJ59TcbEUpxGsVs660OXkybE
         Yn9yUgidXgGNfjrXMOGfMnjcFF8+N/O52Bj8I8rwcLctp+LMRXV1NXBo/U5olHAET6m2
         64+g==
X-Gm-Message-State: AFqh2kqMR1c87sfjQJ+LBAOTLRk3EBBjVuW8y+BH17l6fCd34MTrWI3r
        GEKbCUUOsbiISf+mI7yjrqbAs5Hli4i9Lg==
X-Google-Smtp-Source: AMrXdXt9rEVFEezmkAYJ7p1M6/0gotC1uSA0UmUeV9e8n/Mm7Y0wZXQZLwDnwhP9SKnYMFiCaGA7Jg==
X-Received: by 2002:ac8:5045:0:b0:3ad:7ac:ce61 with SMTP id h5-20020ac85045000000b003ad07acce61mr12689093qtm.64.1673484121130;
        Wed, 11 Jan 2023 16:42:01 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c11-20020ac853cb000000b00397b1c60780sm8268152qtq.61.2023.01.11.16.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 16:42:00 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCHv2 net 2/2] kselftest: add a selftest for ipv6 dad and rs sending
Date:   Wed, 11 Jan 2023 19:41:57 -0500
Message-Id: <83eec0770eee543174b90ba4e08d371a72565f0c.1673483994.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1673483994.git.lucien.xin@gmail.com>
References: <cover.1673483994.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to test all these factors and their combinations
that may enable/disable ipv6 DAD or RS on a slave port or dev.
For DAD, it includes:

  - sysctl "net.ipv6.conf.all.accept_dad"
  - sysctl "net.ipv6.conf.$dev_name.accept_dad"
  - inet6_ifaddr flag "IFA_F_NODAD"
  - netdev priv_flags "IFF_NO_ADDRCONF"

and for rs, it includes:

  - sysctl "net.ipv6.conf.$dev_name.accept_ra"
  - sysctl "net.ipv6.conf.$dev_name.router_solicitations"
  - netdev priv_flags "IFF_NO_ADDRCONF"

The test uses team/bond ports to have IFF_NO_ADDRCONF priv_flags
set, and "ip addr add ... nodad" to have IFA_F_NODAD flag set.
It uses "ip6tables" to count the DAD or RS packets during the
port or dev goes up.

Note that the bridge port is also tested as slave ports without
IFF_NO_ADDRCONF flag.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 tools/testing/selftests/net/Makefile       |   1 +
 tools/testing/selftests/net/ipv6_dad_rs.sh | 111 +++++++++++++++++++++
 2 files changed, 112 insertions(+)
 create mode 100755 tools/testing/selftests/net/ipv6_dad_rs.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 3007e98a6d64..4a9905d10212 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -75,6 +75,7 @@ TEST_GEN_PROGS += so_incoming_cpu
 TEST_PROGS += sctp_vrf.sh
 TEST_GEN_FILES += sctp_hello
 TEST_GEN_FILES += csum
+TEST_PROGS += ipv6_dad_rs.sh
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/ipv6_dad_rs.sh b/tools/testing/selftests/net/ipv6_dad_rs.sh
new file mode 100755
index 000000000000..064afe806ce4
--- /dev/null
+++ b/tools/testing/selftests/net/ipv6_dad_rs.sh
@@ -0,0 +1,111 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Testing for DAD/RS on Ports/Devices.
+# TOPO: ns0 (link0) <---> (link1) ns1
+
+setup() {
+	local mac_addr
+	local ip6_addr
+
+	ip net add ns0
+	ip net add ns1
+	ip net exec ns0 ip link add link0 type veth peer link1 netns ns1
+	ip net exec ns0 ip link set link0 up
+
+	# The test uses global addrs, so drop the pkts for link-local addrs.
+	mac_addr=`ip net exec ns1 cat /sys/class/net/link1/address`
+	ip6_addr="ff02::1:ff${mac_addr:9:2}:${mac_addr:12:2}${mac_addr:15:2}"
+	ip net exec ns1 ip6tables -A OUTPUT -d $ip6_addr -j DROP
+}
+
+cleanup() {
+	ip net del ns1
+	ip net del ns0
+}
+
+check_pkts() {
+	local CNT=0
+
+	while ip net exec ns0 ip6tables -t raw -L -v | \
+		grep link0 | awk '$1 != "0" {exit 1}'; do
+		[ $((CNT++)) = "30" ] && return 1
+		sleep 0.1
+	done
+}
+
+do_test() {
+	local master_type="$1"
+	local icmpv6_type="$2"
+	local pkt_exp="$3"
+	local pkt_rcv="0"
+	local dad="$4"
+
+	ip net exec ns1 ip link set link1 down
+	[ $master_type != "veth" ] && {
+		ip net exec ns1 ip link add master_dev1 type $master_type
+		ip net exec ns1 ip link set link1 master master_dev1
+	}
+
+	ip net exec ns0 ip6tables -t raw -A PREROUTING -i link0 \
+		-p ipv6-icmp --icmpv6-type $icmpv6_type -j ACCEPT
+
+	ip net exec ns1 ip addr add 2000::1/64 dev link1 $dad
+	ip net exec ns1 ip link set link1 up
+	check_pkts && pkt_rcv="1"
+
+	ip net exec ns1 ip addr del 2000::1/64 dev link1 $dad
+	ip net exec ns0 ip6tables -t raw -D PREROUTING -i link0 \
+		-p ipv6-icmp --icmpv6-type $icmpv6_type -j ACCEPT
+
+	[ $master_type != "veth" ] &&
+		ip net exec ns1 ip link del master_dev1
+	test "$pkt_exp" = "$pkt_rcv"
+}
+
+test_rs() {
+	local rs=1
+
+	echo "- link_ra: $link_ra, link_rs: $link_rs"
+	ip net exec ns1 sysctl -qw net.ipv6.conf.link1.accept_ra=$link_ra
+	ip net exec ns1 sysctl -qw net.ipv6.conf.link1.router_solicitations=$link_rs
+
+	[ "$link_ra" = "0" -o  "$link_rs" = "0" ] && rs=0
+	do_test veth router-solicitation $rs   && echo "  veth device (RS $rs): PASS" &&
+	do_test bridge router-solicitation $rs && echo "  bridge port (RS $rs): PASS" &&
+	do_test bond router-solicitation 0     && echo "  bond slave  (RS 0): PASS" &&
+	do_test team router-solicitation 0     && echo "  team port   (RS 0): PASS"
+}
+
+test_dad() {
+	local nodad=""
+	local ns=1
+
+	echo "- all_dad: $all_dad, link_dad: $link_dad, addr_nodad: $addr_nodad"
+	ip net exec ns1 sysctl -qw net.ipv6.conf.all.accept_dad=$all_dad
+	ip net exec ns1 sysctl -qw net.ipv6.conf.link1.accept_dad=$link_dad
+
+	[ "$all_dad" = "0" -a "$link_dad" = "0" ] && ns=0
+	[ "$addr_nodad" = "1" ] && nodad="nodad"  && ns=0
+	do_test veth neighbor-solicitation $ns $nodad   && echo "  veth device (NS $ns): PASS" &&
+	do_test bridge neighbor-solicitation $ns $nodad && echo "  bridge port (NS $ns): PASS" &&
+	do_test bond neighbor-solicitation 0 $dad       && echo "  bond slave  (NS 0): PASS" &&
+	do_test team neighbor-solicitation 0 $dad       && echo "  team port   (NS 0): PASS"
+}
+
+trap cleanup EXIT
+setup && echo "Testing for DAD/RS on Ports/Devices:" && {
+	for all_dad in 0 1; do
+		for link_dad in 0 1; do
+			for addr_nodad in 0 1; do
+				test_dad || exit $?
+			done
+		done
+	done
+	for link_ra in 0 1; do
+		for link_rs in 0 1; do
+			test_rs || exit $?
+		done
+	done
+}
+exit $?
-- 
2.31.1

