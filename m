Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBB923B8A7
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 12:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgHDKS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 06:18:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44466 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728793AbgHDKSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 06:18:20 -0400
Received: from mail-pf1-f197.google.com ([209.85.210.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1k2u1R-0006Zv-DJ
        for netdev@vger.kernel.org; Tue, 04 Aug 2020 10:18:17 +0000
Received: by mail-pf1-f197.google.com with SMTP id x142so4472039pfc.14
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 03:18:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nqVDeX7baCcyf0olywWscaALURRXzwjMN/xMegqP4Ho=;
        b=sEuPsEENv4Hq/C90+o+B0e+KwtRLkpRntPYFw0iHYRwOVTBSSEKhLRkYdQrhORYUCt
         hfSbHitYXBAEQ1XBm0fOv7v3NC1HrloR5Rpb+hf44xXmBBEF4GRlWC5XBSQC4pIeGxWT
         Y17zuM6ul35fE4+MsWt6RYnvg+NvQmhsexonh2PLSSvarS6mLVM45fn8jO5kd9NyiQhK
         JsopJLjONK30/es/z6Z/PNKJzF7nBSZYvXULo9+XPD2OVqDl+FyRJ7uv8GvsRg+t9UXs
         p+U7+VGhJT+L/kB/fvWDYtcosn3WnSuW1rVTWjc5W47vhokSfviuE+XZO09GjLEgg1V4
         3cRw==
X-Gm-Message-State: AOAM530HqbnPw0+Y0YhSI/DqTQE+4BmNmC42MU1UXA31HoymCH2EwBLH
        0wCfdqtmB/3ke+JayhLD84SasfHM2IkMw+aywt2rHwWSV/Qeh4k/m1J1+ijv6lWXhGlhbWcnJU+
        +yn72UOPuGKZwfq+Dm9llShNUzTUYvY2T
X-Received: by 2002:a63:531e:: with SMTP id h30mr17848658pgb.165.1596536295214;
        Tue, 04 Aug 2020 03:18:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJvddgaSXE1rnnPkJxh20J6l9RPa4Do5Q4lT/hXuSnSL6mQwzOlsrP4B0f9zJh0g078l9xWQ==
X-Received: by 2002:a63:531e:: with SMTP id h30mr17848644pgb.165.1596536294836;
        Tue, 04 Aug 2020 03:18:14 -0700 (PDT)
Received: from localhost.localdomain (111-71-32-223.emome-ip.hinet.net. [111.71.32.223])
        by smtp.gmail.com with ESMTPSA id g15sm15578674pfh.70.2020.08.04.03.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 03:18:14 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     davem@davemloft.net, kuba@kernel.org, skhan@linuxfoundation.org
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] selftests: rtnetlink: correct the final return value for the test
Date:   Tue,  4 Aug 2020 18:18:02 +0800
Message-Id: <20200804101803.23062-2-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200804101803.23062-1-po-hsu.lin@canonical.com>
References: <20200804101803.23062-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value "ret" will be reset to 0 from the beginning of each
sub-test in rtnetlink.sh, therefore this test will always pass if the
last sub-test has passed:
    $ sudo ./rtnetlink.sh
    PASS: policy routing
    PASS: route get
    PASS: preferred_lft addresses have expired
    PASS: promote_secondaries complete
    PASS: tc htb hierarchy
    PASS: gre tunnel endpoint
    PASS: gretap
    PASS: ip6gretap
    PASS: erspan
    PASS: ip6erspan
    PASS: bridge setup
    PASS: ipv6 addrlabel
    PASS: set ifalias a39ee707-e36b-41d3-802f-63179ed4d580 for test-dummy0
    PASS: vrf
    PASS: vxlan
    FAIL: can't add fou port 7777, skipping test
    PASS: macsec
    PASS: ipsec
    3,7c3,7
    < sa[0]    spi=0x00000009 proto=0x32 salt=0x64636261 crypt=1
    < sa[0]    key=0x31323334 35363738 39303132 33343536
    < sa[1] rx ipaddr=0x00000000 00000000 00000000 c0a87b03
    < sa[1]    spi=0x00000009 proto=0x32 salt=0x64636261 crypt=1
    < sa[1]    key=0x31323334 35363738 39303132 33343536
    ---
    > sa[0]    spi=0x00000009 proto=0x32 salt=0x61626364 crypt=1
    > sa[0]    key=0x34333231 38373635 32313039 36353433
    > sa[1] rx ipaddr=0x00000000 00000000 00000000 037ba8c0
    > sa[1]    spi=0x00000009 proto=0x32 salt=0x61626364 crypt=1
    > sa[1]    key=0x34333231 38373635 32313039 36353433
    FAIL: ipsec_offload incorrect driver data
    FAIL: ipsec_offload
    PASS: bridge fdb get
    PASS: neigh get
    $ echo $?
    0

Make "ret" become a local variable for all sub-tests.
Also, check the sub-test results in kci_test_rtnl() and return the
final result for this test.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/rtnetlink.sh | 65 +++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index bdbf4b3..9db66be 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -5,7 +5,6 @@
 # set -e
 
 devdummy="test-dummy0"
-ret=0
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
@@ -66,7 +65,7 @@ kci_test_bridge()
 	devbr="test-br0"
 	vlandev="testbr-vlan1"
 
-	ret=0
+	local ret=0
 	ip link add name "$devbr" type bridge
 	check_err $?
 
@@ -113,7 +112,7 @@ kci_test_gre()
 	rem=10.42.42.1
 	loc=10.0.0.1
 
-	ret=0
+	local ret=0
 	ip tunnel add $gredev mode gre remote $rem local $loc ttl 1
 	check_err $?
 	ip link set $gredev up
@@ -149,7 +148,7 @@ kci_test_gre()
 kci_test_tc()
 {
 	dev=lo
-	ret=0
+	local ret=0
 
 	tc qdisc add dev "$dev" root handle 1: htb
 	check_err $?
@@ -184,7 +183,7 @@ kci_test_tc()
 
 kci_test_polrouting()
 {
-	ret=0
+	local ret=0
 	ip rule add fwmark 1 lookup 100
 	check_err $?
 	ip route add local 0.0.0.0/0 dev lo table 100
@@ -207,7 +206,7 @@ kci_test_route_get()
 {
 	local hash_policy=$(sysctl -n net.ipv4.fib_multipath_hash_policy)
 
-	ret=0
+	local ret=0
 
 	ip route get 127.0.0.1 > /dev/null
 	check_err $?
@@ -290,7 +289,7 @@ kci_test_promote_secondaries()
 
 kci_test_addrlabel()
 {
-	ret=0
+	local ret=0
 
 	ip addrlabel add prefix dead::/64 dev lo label 1
 	check_err $?
@@ -330,7 +329,7 @@ kci_test_addrlabel()
 
 kci_test_ifalias()
 {
-	ret=0
+	local ret=0
 	namewant=$(uuidgen)
 	syspathname="/sys/class/net/$devdummy/ifalias"
 
@@ -385,7 +384,7 @@ kci_test_ifalias()
 kci_test_vrf()
 {
 	vrfname="test-vrf"
-	ret=0
+	local ret=0
 
 	ip link show type vrf 2>/dev/null
 	if [ $? -ne 0 ]; then
@@ -425,7 +424,7 @@ kci_test_vrf()
 
 kci_test_encap_vxlan()
 {
-	ret=0
+	local ret=0
 	vxlan="test-vxlan0"
 	vlan="test-vlan0"
 	testns="$1"
@@ -511,7 +510,7 @@ kci_test_encap_vxlan()
 
 kci_test_encap_fou()
 {
-	ret=0
+	local ret=0
 	name="test-fou"
 	testns="$1"
 
@@ -548,7 +547,7 @@ kci_test_encap_fou()
 kci_test_encap()
 {
 	testns="testns"
-	ret=0
+	local ret=0
 
 	ip netns add "$testns"
 	if [ $? -ne 0 ]; then
@@ -573,7 +572,7 @@ kci_test_encap()
 kci_test_macsec()
 {
 	msname="test_macsec0"
-	ret=0
+	local ret=0
 
 	ip macsec help 2>&1 | grep -q "^Usage: ip macsec"
 	if [ $? -ne 0 ]; then
@@ -631,7 +630,7 @@ kci_test_macsec()
 #-------------------------------------------------------------------
 kci_test_ipsec()
 {
-	ret=0
+	local ret=0
 	algo="aead rfc4106(gcm(aes)) 0x3132333435363738393031323334353664636261 128"
 	srcip=192.168.123.1
 	dstip=192.168.123.2
@@ -731,7 +730,7 @@ kci_test_ipsec()
 #-------------------------------------------------------------------
 kci_test_ipsec_offload()
 {
-	ret=0
+	local ret=0
 	algo="aead rfc4106(gcm(aes)) 0x3132333435363738393031323334353664636261 128"
 	srcip=192.168.123.3
 	dstip=192.168.123.4
@@ -841,7 +840,7 @@ kci_test_gretap()
 {
 	testns="testns"
 	DEV_NS=gretap00
-	ret=0
+	local ret=0
 
 	ip netns add "$testns"
 	if [ $? -ne 0 ]; then
@@ -891,7 +890,7 @@ kci_test_ip6gretap()
 {
 	testns="testns"
 	DEV_NS=ip6gretap00
-	ret=0
+	local ret=0
 
 	ip netns add "$testns"
 	if [ $? -ne 0 ]; then
@@ -941,7 +940,7 @@ kci_test_erspan()
 {
 	testns="testns"
 	DEV_NS=erspan00
-	ret=0
+	local ret=0
 
 	ip link help erspan 2>&1 | grep -q "^Usage:"
 	if [ $? -ne 0 ];then
@@ -1006,7 +1005,7 @@ kci_test_ip6erspan()
 {
 	testns="testns"
 	DEV_NS=ip6erspan00
-	ret=0
+	local ret=0
 
 	ip link help ip6erspan 2>&1 | grep -q "^Usage:"
 	if [ $? -ne 0 ];then
@@ -1077,7 +1076,7 @@ kci_test_fdb_get()
 	test_mac=de:ad:be:ef:13:37
 	localip="10.0.2.2"
 	dstip="10.0.2.3"
-	ret=0
+	local ret=0
 
 	bridge fdb help 2>&1 |grep -q 'bridge fdb get'
 	if [ $? -ne 0 ];then
@@ -1125,7 +1124,7 @@ kci_test_neigh_get()
 	dstmac=de:ad:be:ef:13:37
 	dstip=10.0.2.4
 	dstip6=dead::2
-	ret=0
+	local ret=0
 
 	ip neigh help 2>&1 |grep -q 'ip neigh get'
 	if [ $? -ne 0 ];then
@@ -1175,6 +1174,7 @@ kci_test_neigh_get()
 
 kci_test_rtnl()
 {
+	local ret=0
 	kci_add_dummy
 	if [ $ret -ne 0 ];then
 		echo "FAIL: cannot add dummy interface"
@@ -1182,27 +1182,48 @@ kci_test_rtnl()
 	fi
 
 	kci_test_polrouting
+	check_err $?
 	kci_test_route_get
+	check_err $?
 	kci_test_addrlft
+	check_err $?
 	kci_test_promote_secondaries
+	check_err $?
 	kci_test_tc
+	check_err $?
 	kci_test_gre
+	check_err $?
 	kci_test_gretap
+	check_err $?
 	kci_test_ip6gretap
+	check_err $?
 	kci_test_erspan
+	check_err $?
 	kci_test_ip6erspan
+	check_err $?
 	kci_test_bridge
+	check_err $?
 	kci_test_addrlabel
+	check_err $?
 	kci_test_ifalias
+	check_err $?
 	kci_test_vrf
+	check_err $?
 	kci_test_encap
+	check_err $?
 	kci_test_macsec
+	check_err $?
 	kci_test_ipsec
+	check_err $?
 	kci_test_ipsec_offload
+	check_err $?
 	kci_test_fdb_get
+	check_err $?
 	kci_test_neigh_get
+	check_err $?
 
 	kci_del_dummy
+	return $ret
 }
 
 #check for needed privileges
@@ -1221,4 +1242,4 @@ done
 
 kci_test_rtnl
 
-exit $ret
+exit $?
-- 
2.7.4

