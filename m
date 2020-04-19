Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EADF1AF8E7
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 11:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgDSJRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 05:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgDSJRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 05:17:20 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6E0C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 02:17:19 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a25so8240226wrd.0
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 02:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pplo.net; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=2uAS/EPyTRDrWB6pZ1V+5FQxeACYk2G8DedcruXMEMg=;
        b=S0G/cceqqYeY7kpjwRtB39O30tRhwud9Jy/7wCngDE6V8LQ/7604VSvnf+5T2jPONp
         7EoncGp5mWwYeGSQn5Qj/x4PwC6fb7nC08sKOT4QkJzIS3TbIXW/55dMiWOMHWz+yyYr
         1JTXD0vILZL89UnzFRllLrLhZ9yPEUTNAeRS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2uAS/EPyTRDrWB6pZ1V+5FQxeACYk2G8DedcruXMEMg=;
        b=Wp3uNO0w50KFrIcLRjYA3xcTXM46fFbcoG51tNsVFo/LrlNcqDoQ2rgqPJ3C8fNDmQ
         YXXiY6zAaSAh6wpSRTqXK7qqZGFgVh4RIzOsJSy1BtyuWjKKB0g9r43ooWkUGXUmBV0F
         RxcROdNZdbXeblCJMhoRhslJdGjVdSCXIBFrDjljmBI9Mh3fgJWOAoOm3THpPjh8JQUp
         6YQTbiWKFOfcssm3AsCGLwC2Z6zXcJldbO1f0L/aWpWLl83ZR4jZm+mas1unS+BnI67V
         0DYqiz1Jmk/YzYZ0WrRATDPytFoxnEyhDf0A7tc5drN6myDYlmRoOnXmyO9KzuvLz9OL
         yNWw==
X-Gm-Message-State: AGi0PubLBCqcA8paNCO51qStXrdT+eTdcujB3OdkM/rwcUli+Jj1pAsB
        GiFJ6EMukTTzE/HR/3KYf3retA==
X-Google-Smtp-Source: APiQypLYnfrq6BwZ49d2rMxmhtSCVR67h0pLMSCz0mtXB/2DgpK9xCPBNise39rHg8/o9wc7AKKTAw==
X-Received: by 2002:adf:afe4:: with SMTP id y36mr13195791wrd.205.1587287837873;
        Sun, 19 Apr 2020 02:17:17 -0700 (PDT)
Received: from localhost.localdomain (85.251.42.187.dyn.user.ono.com. [85.251.42.187])
        by smtp.gmail.com with ESMTPSA id u17sm43417535wra.63.2020.04.19.02.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2020 02:17:17 -0700 (PDT)
From:   Lourdes Pedrajas <lu@pplo.net>
To:     David Miller <davem@davemloft.net>
Cc:     Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Lourdes Pedrajas <lu@pplo.net>
Subject: [PATCH net-next] selftests: pmtu: implement IPIP, SIT and ip6tnl PMTU discovery tests
Date:   Sun, 19 Apr 2020 11:16:51 +0200
Message-Id: <20200419091651.22714-1-lu@pplo.net>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PMTU discovery tests for these encapsulations:

- IPIP
- SIT, mode ip6ip
- ip6tnl, modes ip6ip6 and ipip6

Signed-off-by: Lourdes Pedrajas <lu@pplo.net>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
---
 tools/testing/selftests/net/pmtu.sh | 122 ++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 71a62e7e35b1..77c09cd339c3 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -67,6 +67,10 @@
 #	Same as pmtu_ipv4_vxlan4, but using a generic UDP IPv4/IPv6
 #	encapsulation (GUE) over IPv4/IPv6, instead of VXLAN
 #
+# - pmtu_ipv{4,6}_ipv{4,6}_exception
+#	Same as pmtu_ipv4_vxlan4, but using a IPv4/IPv6 tunnel over IPv4/IPv6,
+#	instead of VXLAN
+#
 # - pmtu_vti4_exception
 #	Set up vti tunnel on top of veth, with xfrm states and policies, in two
 #	namespaces with matching endpoints. Check that route exception is not
@@ -151,6 +155,10 @@ tests="
 	pmtu_ipv6_gue4_exception	IPv6 over gue4: PMTU exceptions		1
 	pmtu_ipv4_gue6_exception	IPv4 over gue6: PMTU exceptions		1
 	pmtu_ipv6_gue6_exception	IPv6 over gue6: PMTU exceptions		1
+	pmtu_ipv4_ipv4_exception	IPv4 over IPv4: PMTU exceptions		1
+	pmtu_ipv6_ipv4_exception	IPv6 over IPv4: PMTU exceptions		1
+	pmtu_ipv4_ipv6_exception	IPv4 over IPv6: PMTU exceptions		1
+	pmtu_ipv6_ipv6_exception	IPv6 over IPv6: PMTU exceptions		1
 	pmtu_vti6_exception		vti6: PMTU exceptions			0
 	pmtu_vti4_exception		vti4: PMTU exceptions			0
 	pmtu_vti4_default_mtu		vti4: default MTU assignment		0
@@ -363,6 +371,62 @@ setup_gue66() {
 	setup_fou_or_gue 6 6 gue
 }
 
+setup_ipvX_over_ipvY() {
+	inner=${1}
+	outer=${2}
+
+	if [ "${outer}" -eq 4 ]; then
+		a_addr="${prefix4}.${a_r1}.1"
+		b_addr="${prefix4}.${b_r1}.1"
+		if [ "${inner}" -eq 4 ]; then
+			type="ipip"
+			mode="ipip"
+		else
+			type="sit"
+			mode="ip6ip"
+		fi
+	else
+		a_addr="${prefix6}:${a_r1}::1"
+		b_addr="${prefix6}:${b_r1}::1"
+		type="ip6tnl"
+		if [ "${inner}" -eq 4 ]; then
+			mode="ipip6"
+		else
+			mode="ip6ip6"
+		fi
+	fi
+
+	run_cmd ${ns_a} ip link add ip_a type ${type} local ${a_addr} remote ${b_addr} mode ${mode} || return 2
+	run_cmd ${ns_b} ip link add ip_b type ${type} local ${b_addr} remote ${a_addr} mode ${mode}
+
+	run_cmd ${ns_a} ip link set ip_a up
+	run_cmd ${ns_b} ip link set ip_b up
+
+	if [ "${inner}" = "4" ]; then
+		run_cmd ${ns_a} ip addr add ${tunnel4_a_addr}/${tunnel4_mask} dev ip_a
+		run_cmd ${ns_b} ip addr add ${tunnel4_b_addr}/${tunnel4_mask} dev ip_b
+	else
+		run_cmd ${ns_a} ip addr add ${tunnel6_a_addr}/${tunnel6_mask} dev ip_a
+		run_cmd ${ns_b} ip addr add ${tunnel6_b_addr}/${tunnel6_mask} dev ip_b
+	fi
+}
+
+setup_ip4ip4() {
+	setup_ipvX_over_ipvY 4 4
+}
+
+setup_ip6ip4() {
+	setup_ipvX_over_ipvY 6 4
+}
+
+setup_ip4ip6() {
+	setup_ipvX_over_ipvY 4 6
+}
+
+setup_ip6ip6() {
+	setup_ipvX_over_ipvY 6 6
+}
+
 setup_namespaces() {
 	for n in ${NS_A} ${NS_B} ${NS_R1} ${NS_R2}; do
 		ip netns add ${n} || return 1
@@ -908,6 +972,64 @@ test_pmtu_ipv6_gue6_exception() {
 	test_pmtu_ipvX_over_fouY_or_gueY 6 6 gue
 }
 
+test_pmtu_ipvX_over_ipvY_exception() {
+	inner=${1}
+	outer=${2}
+	ll_mtu=4000
+
+	setup namespaces routing ip${inner}ip${outer} || return 2
+
+	trace "${ns_a}" ip_a         "${ns_b}"  ip_b  \
+	      "${ns_a}" veth_A-R1    "${ns_r1}" veth_R1-A \
+	      "${ns_b}" veth_B-R1    "${ns_r1}" veth_R1-B
+
+	if [ ${inner} -eq 4 ]; then
+		ping=ping
+		dst=${tunnel4_b_addr}
+	else
+		ping=${ping6}
+		dst=${tunnel6_b_addr}
+	fi
+
+	if [ ${outer} -eq 4 ]; then
+		#                      IPv4 header
+		exp_mtu=$((${ll_mtu} - 20))
+	else
+		#                      IPv6 header   Option 4
+		exp_mtu=$((${ll_mtu} - 40          - 8))
+	fi
+
+	# Create route exception by exceeding link layer MTU
+	mtu "${ns_a}"  veth_A-R1 $((${ll_mtu} + 1000))
+	mtu "${ns_r1}" veth_R1-A $((${ll_mtu} + 1000))
+	mtu "${ns_b}"  veth_B-R1 ${ll_mtu}
+	mtu "${ns_r1}" veth_R1-B ${ll_mtu}
+
+	mtu "${ns_a}" ip_a $((${ll_mtu} + 1000)) || return
+	mtu "${ns_b}" ip_b $((${ll_mtu} + 1000)) || return
+	run_cmd ${ns_a} ${ping} -q -M want -i 0.1 -w 1 -s $((${ll_mtu} + 500)) ${dst}
+
+	# Check that exception was created
+	pmtu="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst})"
+	check_pmtu_value ${exp_mtu} "${pmtu}" "exceeding link layer MTU on ip${inner}ip${outer} interface"
+}
+
+test_pmtu_ipv4_ipv4_exception() {
+	test_pmtu_ipvX_over_ipvY_exception 4 4
+}
+
+test_pmtu_ipv6_ipv4_exception() {
+	test_pmtu_ipvX_over_ipvY_exception 6 4
+}
+
+test_pmtu_ipv4_ipv6_exception() {
+	test_pmtu_ipvX_over_ipvY_exception 4 6
+}
+
+test_pmtu_ipv6_ipv6_exception() {
+	test_pmtu_ipvX_over_ipvY_exception 6 6
+}
+
 test_pmtu_vti4_exception() {
 	setup namespaces veth vti4 xfrm4 || return 2
 	trace "${ns_a}" veth_a    "${ns_b}" veth_b \
-- 
2.17.1

