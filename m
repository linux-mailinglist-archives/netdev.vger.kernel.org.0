Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68FF71A067E
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 07:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgDGFUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 01:20:53 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:37663 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgDGFUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 01:20:52 -0400
Received: by mail-wm1-f42.google.com with SMTP id j19so447755wmi.2
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 22:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pplo.net; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=LH9DVsh46tLVBrpPLnxCn487/+heGcwo1v8Lhu9J4SA=;
        b=Yaoi7EWv8BVdIWHxhU7KgJV9KSvaZITvyGLKCqNsIUjZJDQuZn+p2liax8O/ANItxh
         42udsFfpRxwUmxYunfDtNTz8Y5XcMZcjFhY2XXWOaOETZyFJQiF4XcMdvvSe9DkK7pqL
         ptuvAbbU0iM9Qt24fPeei6ZJPbDCAQXP6topk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LH9DVsh46tLVBrpPLnxCn487/+heGcwo1v8Lhu9J4SA=;
        b=hfBSn3pa31iNJT20jK5hGJubG7498bb9gyCI8fivPZVrGnACza1CP71asB0ZHH4IrC
         tYo+MERDFxvRPr/Bou1uQiSGK8AXeYVotfghC5Gll3B1ouvcBIn0fYBsgJMZ71OekkLx
         GmtKHQ6mcBw1wz6ZDVHyuI2oWLnn1RG75U87+C/rS233CpH+yp5LaGEmz+YR8H986ozV
         rSGv9CktHu9i9pPxTpVUo7MNDSVvRDxXDjeTCWdYYf/Jgdx91bv8WougY8pZEYANDYHg
         EmRXfYh+Sd8izh2O+oh/rIdjdD48johu5qXyPh3VZnBIdEYQE5wMT8WxFtVIZ+FXUe9M
         O79g==
X-Gm-Message-State: AGi0PuYiWxl1YdxcjDFRytcYDKcEbXlxH1KSjpu+zOi1ytLms9ZKiFrx
        sudgPQRXMtKw/G1PzKZOYW3IiQ==
X-Google-Smtp-Source: APiQypKeZqarKUrfz8xJfRN1ya3ZQpQrv9QMZ5pNza7kjpY8aRvbBtA1UevOVHQpIzn5U06LGLj5qQ==
X-Received: by 2002:a1c:7405:: with SMTP id p5mr441503wmc.20.1586236848823;
        Mon, 06 Apr 2020 22:20:48 -0700 (PDT)
Received: from localhost.localdomain (85.251.42.187.dyn.user.ono.com. [85.251.42.187])
        by smtp.gmail.com with ESMTPSA id f12sm806975wmh.4.2020.04.06.22.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 22:20:48 -0700 (PDT)
From:   Lourdes Pedrajas <lu@pplo.net>
To:     David Miller <davem@davemloft.net>
Cc:     Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next] selftests: pmtu: implement IPIP, SIT and ip6tnl PMTU discovery tests
Date:   Tue,  7 Apr 2020 07:20:40 +0200
Message-Id: <20200407052040.8116-1-lu@pplo.net>
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
index 71a62e7e35b1..2be0bdb35d77 100755
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

