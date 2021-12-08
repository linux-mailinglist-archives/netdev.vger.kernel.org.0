Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41ECA46D2A0
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbhLHLnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbhLHLnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:43:00 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B8FC07E5C1;
        Wed,  8 Dec 2021 03:38:32 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v1so7467204edx.2;
        Wed, 08 Dec 2021 03:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=va63/N8CYQSmLkQGhzY2hoE/p0MPavl2wkjpqBvYrRY=;
        b=kF7IgW785YxstHwbtnA4dOEnEW+K1MbxCrRk2Ns4UpyCKrb79XmMuE1MGl5tThmKUA
         XHKqLJuXWRXRd0rXTWLzvxveIm0aS5priRIDBLlzuNgxrsh+nbYArkRH8hSzJaHMrfWE
         S0ORT/OsOQBYleoOWw2G4QhKB2YhcPIHj+bDpX+PFmjiEZQYEOqwu2i37A6HoO5l7Bb+
         h3T41E05a+QbEsI7Lt6HeoptD1JdSekDBYwD2FvuwIEOdYj2CeYDdl4DXD4dZ/GtGZTA
         5R7bS44cEzNBALrgcg6zjAAKAHYjOc5pIjW9e5WQPpRKMjbFaWlT3AoYHBkS2Tni/ALC
         B/oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=va63/N8CYQSmLkQGhzY2hoE/p0MPavl2wkjpqBvYrRY=;
        b=F3nJUAD3Pi2Xz4HpY36oBPjNq5Ay39xk47m9OKtXralO2E+psxzn1/74VUt80LIMu/
         eigOL36Jz0PjsulVR/0Vwz0zu5ZW0ydUgV5goDLIVeJO8M0JzvZ00NdrP/tNlux3Tlf5
         ZQK8ElEOeiJEqxCgW8koCAdWCqpFPAeb1Xwb5CdJmWfCx3oynk+y6A7gZ5D9R2vhxDTS
         mTT2gkzY8pu4qGqtxlpcLw4PfjSKuO4CZBr8o88TdOYTLzNl7K2opDtjqpFYw8qd0q1a
         5gdfp90W423vLpjVvF9Nx2GV2YU/68O2PwJqTG2spNalh7cGAXEGeb9xWnSsnMk2L5D9
         exQg==
X-Gm-Message-State: AOAM530PW/zAilEE1XNSOciIZgUeQ3ToKLWBxExBM0cCfnSnxdayVchL
        bGg5fGXm5XHPHaaqvYTW754=
X-Google-Smtp-Source: ABdhPJx6aJZmM5GWY1yC6x8dDsBuVJ4QfZjtgxxoq88csbSXQgRn0a/SGf90hhYU9RvGN5DI8MWuUQ==
X-Received: by 2002:a17:907:2d0e:: with SMTP id gs14mr6831555ejc.249.1638963511090;
        Wed, 08 Dec 2021 03:38:31 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:3c9f:e05b:4dff:43ba])
        by smtp.gmail.com with ESMTPSA id g11sm1883810edz.53.2021.12.08.03.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:38:30 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 18/18] selftests: net/fcnal: Initial tcp_authopt support
Date:   Wed,  8 Dec 2021 13:37:33 +0200
Message-Id: <718934913b81a01d2d2a9479ea4eb645234d7697.1638962992.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638962992.git.cdleonard@gmail.com>
References: <cover.1638962992.git.cdleonard@gmail.com>
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
 tools/testing/selftests/net/fcnal-test.sh | 298 ++++++++++++++++++++++
 1 file changed, 298 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 32d5f7bc588e..e99b44f0ae5a 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -807,10 +807,301 @@ ipv4_ping()
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
+
+	log_start
+	run_cmd nettest -s -A ${MD5_PW} -m ${NSB_LO_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: Client address does not match address configured on server"
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
+
+	# client outside of prefix
+	log_start
+	show_hint "Should timeout due to MD5 mismatch"
+	run_cmd nettest -s -A ${MD5_PW} -m ${NS_NET} &
+	sleep 1
+	run_cmd_nsb nettest -c ${NSB_LO_IP} -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: Prefix config, client address not in configured prefix"
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
+	log_test $? 0 "AO: VRF: Servers in default-VRF and VRF, client in VRF"
+
+	log_start
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -A ${MD5_WRONG_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -A ${MD5_WRONG_PW}
+	log_test $? 0 "AO: VRF: Servers in default-VRF and VRF, client in default-VRF"
+
+	log_start
+	show_hint "Should timeout since client in default VRF uses VRF password"
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -A ${MD5_WRONG_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -A ${MD5_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in default-VRF with VRF pw"
+
+	log_start
+	show_hint "Should timeout since client in VRF uses default VRF password"
+	run_cmd nettest -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP} &
+	run_cmd nettest -s -A ${MD5_WRONG_PW} -m ${NSB_IP} &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in VRF with default-VRF pw"
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
+	log_test $? 0 "AO: VRF: Servers in default-VRF and VRF, client in VRF"
+
+	log_start
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -A ${MD5_WRONG_PW}
+	log_test $? 0 "AO: VRF: Servers in default-VRF and VRF, client in default-VRF"
+
+	log_start
+	show_hint "Should timeout since client in default VRF uses VRF password"
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsc nettest -6 -r ${NSA_IP6} -A ${MD5_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in default-VRF with VRF pw"
+
+	log_start
+	show_hint "Should timeout since client in VRF uses default VRF password"
+	run_cmd nettest -6 -s -I ${VRF} -A ${MD5_PW} -m ${NSB_IP6} &
+	run_cmd nettest -6 -s -A ${MD5_WRONG_PW} -m ${NSB_IP6} &
+	sleep 1
+	run_cmd_nsb nettest -6 -r ${NSA_IP6} -A ${MD5_WRONG_PW}
+	log_test $? 2 "AO: VRF: Servers in default VRF and VRF, conn in VRF with default-VRF pw"
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
@@ -1192,10 +1483,11 @@ ipv4_tcp_novrf()
 	show_hint "Should fail 'Connection refused'"
 	run_cmd nettest -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 1 "No server, device client, local conn"
 
 	ipv4_tcp_md5_novrf
+	ipv4_tcp_authopt_novrf
 }
 
 ipv4_tcp_vrf()
 {
 	local a
@@ -1246,10 +1538,12 @@ ipv4_tcp_vrf()
 	run_cmd nettest -r ${a} -d ${NSA_DEV}
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
 	# run MD5 tests
 	ipv4_tcp_md5
+	# run AO tests
+	ipv6_tcp_md5_vrf
 
 	#
 	# enable VRF global server
 	#
 	log_subsection "VRF Global server enabled"
@@ -2672,10 +2966,11 @@ ipv6_tcp_novrf()
 		run_cmd nettest -6 -d ${NSA_DEV} -r ${a}
 		log_test_addr ${a} $? 1 "No server, device client, local conn"
 	done
 
 	ipv6_tcp_md5_novrf
+	ipv6_tcp_authopt_novrf
 }
 
 ipv6_tcp_vrf()
 {
 	local a
@@ -2742,10 +3037,12 @@ ipv6_tcp_vrf()
 	run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
 	# run MD5 tests
 	ipv6_tcp_md5
+	# run AO tests
+	ipv6_tcp_authopt_vrf
 
 	#
 	# enable VRF global server
 	#
 	log_subsection "VRF Global server enabled"
@@ -4102,10 +4399,11 @@ do
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

