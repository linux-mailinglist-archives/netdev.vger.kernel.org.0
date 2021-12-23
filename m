Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C106F47E5CC
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349011AbhLWPlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349204AbhLWPlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:41:15 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035FBC0617A2;
        Thu, 23 Dec 2021 07:41:14 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id j21so22923971edt.9;
        Thu, 23 Dec 2021 07:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mLCtEWl6YZYNKGw7jvkpXmqL/AYDPWPJ84U9BUE0+Jk=;
        b=OUE7j5BfOgM7IGv04XZXHi4aUvjQn0J+fAS2L0mahVRtiWNHuSXtZRBeddaBT4AUye
         mQApKIuIC+WNAeeTAwurl6cZ/DmXHdYQAtgnOrbQRzNLR3WYF3nHtPI2UN+02P4Kcxkl
         QYqH/LxfFsodQy9gM15l3WjkxLd7gLbRq4w8btzRs4/q1hffHkdHY6AsZKmitxYEsQQu
         Km3Ohw+yyIqNLjAR8BE/TzrIrFQlY8Gi00oioHO84kt8FKRiqJuCtzJ7LuFKWuY0ktg2
         fvtPvjnsYwAvjBav67ZEhJ47B7Wc/zptx0ZrLXlh4nuqmUKVcg1L0zusg+Kq1cb6V6tt
         V7mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mLCtEWl6YZYNKGw7jvkpXmqL/AYDPWPJ84U9BUE0+Jk=;
        b=JZ01tUf2XV01I+d1REjg0frEISNpAJOTNxaqMeu9gsSjcJFK9jlgYplSsiRyeUskiC
         A7pQBCP4EPDyfBsSs2vYlS26BqstuWQBoduEHWrkuF3JuTxrL8SbBQhS5cnCwQDy+bFw
         7mWRjleg/PdxP5Wktvyd9jcR44S2Q00isXCeg/jk/OPtLG/nGuIMr7iXE0/819YBiYvm
         mrvuI30cEsuFb326cSByULIftvnpSM6XVMf0k0eJJB675LljjNcxMWQQGteArwHYvb1n
         VJ6OqZJ3hEfSdDpcfgRJcxgHfVEPbYYZkI7zCjL+qYUej+nhluLiFRJDnfomyCzp328n
         b/cQ==
X-Gm-Message-State: AOAM533rmvT5UCbw2wbKpWh3Nt4VCgZ/5ZIzZchUmta9GC7JSRb8DMpr
        4rvyJQ0w3CuGttHG8T+fFmE=
X-Google-Smtp-Source: ABdhPJyR3bSroLQ/z/pnPUqi2YRiELeTEh2Pqt7qqEfwS1hY8zoOvuym3PCvGswI17JVwtvB6JhHDA==
X-Received: by 2002:a17:906:f43:: with SMTP id h3mr2285167ejj.414.1640274072525;
        Thu, 23 Dec 2021 07:41:12 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:7c02:dfc6:b554:ab10])
        by smtp.gmail.com with ESMTPSA id bx6sm2088617edb.78.2021.12.23.07.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:41:11 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 19/19] selftests: net/fcnal: Initial tcp_authopt support
Date:   Thu, 23 Dec 2021 17:40:14 +0200
Message-Id: <a45ecaed888ec69dbcd6e819fdfbd50191ff8ae6.1640273966.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1640273966.git.cdleonard@gmail.com>
References: <cover.1640273966.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tests are mostly copied from tcp_md5 with minor changes.

It covers VRF support but only based on binding multiple servers: not
multiple keys bound to different interfaces.

Also add a specific -t tcp_authopt to run only these tests specifically.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 329 +++++++++++++++++++++-
 1 file changed, 327 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 412d85205546..610ae75df8b2 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -817,10 +817,330 @@ ipv4_ping()
 }
 
 ################################################################################
 # IPv4 TCP
 
+#
+# TCP Authentication Option Tests
+#
+
+# try to enable tcp_authopt sysctl
+enable_tcp_authopt()
+{
+	if [[ -e /proc/sys/net/ipv4/tcp_authopt ]]; then
+		sysctl -w net.ipv4.tcp_authopt=1
+	fi
+}
+
+# check if tcp_authopt is compiled with a client-side bind test
+has_tcp_authopt()
+{
+	run_cmd_nsb nettest -b -A ${MD5_PW} -r ${NSA_IP}
+}
+
+# Verify /proc/net/tcp_authopt is empty in all namespaces
+check_tcp_authopt_key_leak()
+{
+	local ns cnt
+
+	for ns in $NSA $NSB $NSC; do
+		if ! ip netns list | grep -q $ns; then
+			continue
+		fi
+		cnt=$(ip netns exec "$ns" cat /proc/net/tcp_authopt | wc -l)
+		if [[ $cnt != 1 ]]; then
+			echo "FAIL: leaked tcp_authopt keys in netns $ns"
+			ip netns exec $ns cat /proc/net/tcp_authopt
+			return 1
+		fi
+	done
+}
+
+log_check_tcp_authopt_key_leak()
+{
+	check_tcp_authopt_key_leak
+	log_test $? 0 "TCP-AO: Key leak check"
+}
+
+ipv4_tcp_authopt_novrf()
+{
+	enable_tcp_authopt
+	if ! has_tcp_authopt; then
+		echo "TCP-AO appears to be missing, skip"
+		return 0
+	fi
+
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: Single address config"
+
+	log_start
+	run_cmd nettest -s  &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: Server no config, client uses password"
+
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: Client uses wrong password"
+	log_check_tcp_authopt_key_leak
+
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} -m ${NSB_LO_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: Client address does not match address configured on server"
+	log_check_tcp_authopt_key_leak
+
+	# client in prefix
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: Prefix config"
+
+	# client in prefix, wrong password
+	log_start
+	show_hint "Should timeout since client uses wrong password"
+	run_cmd nettest -s -A ${MD5_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: Prefix config, client uses wrong password"
+	log_check_tcp_authopt_key_leak
+
+	# client outside of prefix
+	log_start
+	show_hint "Should timeout due to MD5 mismatch"
+	run_cmd nettest -s -A ${MD5_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest -c ${NSB_LO_IP} -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: Prefix config, client address not in configured prefix"
+	log_check_tcp_authopt_key_leak
+}
+
+ipv6_tcp_authopt_novrf()
+{
+	enable_tcp_authopt
+	if ! has_tcp_authopt; then
+		echo "TCP-AO appears to be missing, skip"
+		return 0
+	fi
+
+	log_start
+	run_cmd nettest -6 -s -A ${MD5_PW} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 0 "AO: Simple correct config"
+
+	log_start
+	run_cmd nettest -6 -s
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 2 "AO: Server no config, client uses password"
+
+	log_start
+	run_cmd nettest -6 -s -A ${MD5_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: Client uses wrong password"
+
+	log_start
+	run_cmd nettest -6 -s -A ${MD5_PW} -m ${NSB_LO_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 2 "AO: Client address does not match address configured on server"
+}
+
+ipv4_tcp_authopt_vrf()
+{
+	enable_tcp_authopt
+	if ! has_tcp_authopt; then
+		echo "TCP-AO appears to be missing, skip"
+		return 0
+	fi
+
+	log_start
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Simple config"
+
+	#
+	# duplicate config between default VRF and a VRF
+	#
+
+	log_start
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -A ${MD5_WRONG_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Servers in default VRF and VRF, client in VRF"
+
+	log_start
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -A ${MD5_WRONG_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -A ${MD5_WRONG_PW}
+	log_test $? 0 "AO: VRF: Servers in default VRF and VRF, client in default VRF"
+
+	log_start
+	show_hint "Should timeout since client in default VRF uses VRF password"
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -A ${MD5_WRONG_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in default VRF with VRF pw"
+
+	log_start
+	show_hint "Should timeout since client in VRF uses default VRF password"
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -A ${MD5_WRONG_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in VRF with default VRF pw"
+
+	test_ipv4_tcp_authopt_vrf__global_server__bind_ifindex0
+}
+
+test_ipv4_tcp_authopt_vrf__global_server__bind_ifindex0()
+{
+	# This particular test needs tcp_l3mdev_accept=1 for Global server to accept VRF connections
+	local old_tcp_l3mdev_accept
+	old_tcp_l3mdev_accept=$(get_sysctl net.ipv4.tcp_l3mdev_accept)
+	set_sysctl net.ipv4.tcp_l3mdev_accept=1
+
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} --force-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: VRF: Global server, Key bound to ifindex=0 rejects VRF connection"
+
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} --force-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Global server, key bound to ifindex=0 accepts non-VRF connection"
+	log_start
+
+	run_cmd nettest -s -A ${MD5_PW} --no-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Global server, key not bound to ifindex accepts VRF connection"
+
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} --no-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Global server, key not bound to ifindex accepts non-VRF connection"
+
+	# restore value
+	set_sysctl net.ipv4.tcp_l3mdev_accept="$old_tcp_l3mdev_accept"
+}
+
+ipv6_tcp_authopt_vrf()
+{
+	enable_tcp_authopt
+	if ! has_tcp_authopt; then
+		echo "TCP-AO appears to be missing, skip"
+		return 0
+	fi
+
+	log_start
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Simple config"
+
+	#
+	# duplicate config between default VRF and a VRF
+	#
+
+	log_start
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Servers in default VRF and VRF, client in VRF"
+
+	log_start
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -A ${MD5_WRONG_PW}
+	log_test $? 0 "AO: VRF: Servers in default VRF and VRF, client in default VRF"
+
+	log_start
+	show_hint "Should timeout since client in default VRF uses VRF password"
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in default VRF with VRF pw"
+
+	log_start
+	show_hint "Should timeout since client in VRF uses default VRF password"
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in VRF with default VRF pw"
+
+	log_start
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 0 "AO: VRF: Prefix config in default VRF and VRF, conn in VRF"
+
+	log_start
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -A ${MD5_WRONG_PW}
+	log_test $? 0 "AO: VRF: Prefix config in default VRF and VRF, conn in default VRF"
+
+	log_start
+	show_hint "Should timeout since client in default VRF uses VRF password"
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 2 "AO: VRF: Prefix config in def VRF and VRF, conn in def VRF with VRF pw"
+
+	log_start
+	show_hint "Should timeout since client in VRF uses default VRF password"
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NS_NET6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NS_NET6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: VRF: Prefix config in dev VRF and VRF, conn in VRF with def VRF pw"
+}
+
+only_tcp_authopt()
+{
+	log_section "TCP Authentication Option"
+
+	setup
+	set_sysctl net.ipv4.tcp_l3mdev_accept=0
+	log_subsection "TCP-AO IPv4 no VRF"
+	ipv4_tcp_authopt_novrf
+	log_subsection "TCP-AO IPv6 no VRF"
+	ipv6_tcp_authopt_novrf
+
+	setup "yes"
+	setup_vrf_dup
+	set_sysctl net.ipv4.tcp_l3mdev_accept=0
+	log_subsection "TCP-AO IPv4 VRF"
+	ipv4_tcp_authopt_vrf
+	log_subsection "TCP-AO IPv6 VRF"
+	ipv6_tcp_authopt_vrf
+}
+
 #
 # MD5 tests without VRF
 #
 ipv4_tcp_md5_novrf()
 {
@@ -1202,10 +1522,11 @@ ipv4_tcp_novrf()
 	show_hint "Should fail 'Connection refused'"
 	run_cmd nettest -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 1 "No server, device client, local conn"
 
 	ipv4_tcp_md5_novrf
+	ipv4_tcp_authopt_novrf
 }
 
 ipv4_tcp_vrf()
 {
 	local a
@@ -1254,13 +1575,14 @@ ipv4_tcp_vrf()
 	run_cmd nettest -s &
 	sleep 1
 	run_cmd nettest -r ${a} -d ${NSA_DEV}
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
-	# run MD5 tests
+	# run MD5+AO tests
 	setup_vrf_dup
 	ipv4_tcp_md5
+	ipv6_tcp_md5_vrf
 	cleanup_vrf_dup
 
 	#
 	# enable VRF global server
 	#
@@ -2685,10 +3007,11 @@ ipv6_tcp_novrf()
 		run_cmd nettest -6 -d ${NSA_DEV} -r ${a}
 		log_test_addr ${a} $? 1 "No server, device client, local conn"
 	done
 
 	ipv6_tcp_md5_novrf
+	ipv6_tcp_authopt_novrf
 }
 
 ipv6_tcp_vrf()
 {
 	local a
@@ -2753,13 +3076,14 @@ ipv6_tcp_vrf()
 	run_cmd nettest -6 -s &
 	sleep 1
 	run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
-	# run MD5 tests
+	# run MD5+AO tests
 	setup_vrf_dup
 	ipv6_tcp_md5
+	ipv6_tcp_authopt_vrf
 	cleanup_vrf_dup
 
 	#
 	# enable VRF global server
 	#
@@ -4125,10 +4449,11 @@ do
 	ipv6_bind|bind6) ipv6_addr_bind;;
 	ipv6_runtime)    ipv6_runtime;;
 	ipv6_netfilter)  ipv6_netfilter;;
 
 	use_cases)       use_cases;;
+	tcp_authopt)     only_tcp_authopt;;
 
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
 	vrf_setup)	 setup "yes"; exit 0;;
 	esac
-- 
2.25.1

