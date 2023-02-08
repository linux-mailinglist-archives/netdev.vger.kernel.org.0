Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF7F68F41E
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjBHRPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjBHRPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:15:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2251C7FC
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 09:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675876488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BcBnKLL04OLQt/8/WgLEYFuhusUDObDu3v14OiusQt0=;
        b=QXGntvjMv/Yf+pk41gSSPUdcsJqFHMmQhIiD21aWPkOzUdhH1PjouuQqmvkFkccCLBJbGI
        5vyPYZUil+55D9P91hizrrQd3dz70Ny+9KlYVjNsckNA52UmclbymzzQ5OBvdOSrRV/jhn
        SYP9iG/jvYyKc2o/6ufZ2eOrPCv8EHI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-622-PHEIiJAUOd2czjeyXs1bqg-1; Wed, 08 Feb 2023 12:14:14 -0500
X-MC-Unique: PHEIiJAUOd2czjeyXs1bqg-1
Received: by mail-qv1-f71.google.com with SMTP id e5-20020a056214110500b0053547681552so10015157qvs.8
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 09:14:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BcBnKLL04OLQt/8/WgLEYFuhusUDObDu3v14OiusQt0=;
        b=1cMioxHBoRTk7UpDovscR24cxGA4IkU1WU8MHt1U5sVwSoK/pQcpWfSgSepVaxWriF
         /UZekE/0kEX86hkCimOXiixJS9nMZh5+uBj8pxVLWLNZseyhqL1fA/IDD78wz2YySn37
         WmEUtPuSuVWDvg9zUJTdER+tmel0OUHvT2azPBT4WTTebcM4uGDw+6YdEO448XKvvthD
         RGzZnitmzdx7unY5I6pjDLgC3zT/g6NHtQLtp2AEpDCEsrIjwoJdoIC31JljalY7ADfg
         nHe5eiW8cnnfwmhNwHCcDao4XwrBblOyHNI+uA15Tu6mxipcZ1vxaYQDcQZRCLEbeO+x
         DUnw==
X-Gm-Message-State: AO0yUKWmPjHnKQZpv+YmMKkupGGO429r3ih87bnVoOy9yT1Qj+cB6m1K
        JmykvepvalcaADM1VzdjSVNyRsGvakSSMLogP1ala0tLhgIyajgmwBwb3mEKGjBBy0RaLbPgwul
        ZxbVDZo7/GoGJSiU3
X-Received: by 2002:a05:622a:1995:b0:3b6:4249:bbca with SMTP id u21-20020a05622a199500b003b64249bbcamr11030463qtc.55.1675876451917;
        Wed, 08 Feb 2023 09:14:11 -0800 (PST)
X-Google-Smtp-Source: AK7set8CHrHeEm7ACUHgkhfiLwSZfpwqrL90deHe4+NsASyNVptqlZVhdiD3AXRDj5NDiYuOd6jENg==
X-Received: by 2002:a05:622a:1995:b0:3b6:4249:bbca with SMTP id u21-20020a05622a199500b003b64249bbcamr11030434qtc.55.1675876451588;
        Wed, 08 Feb 2023 09:14:11 -0800 (PST)
Received: from debian (2a01cb058918ce00464fe7234b8f6f47.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:464f:e723:4b8f:6f47])
        by smtp.gmail.com with ESMTPSA id a14-20020ac8434e000000b003bb764fe4ffsm1648549qtn.3.2023.02.08.09.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:14:11 -0800 (PST)
Date:   Wed, 8 Feb 2023 18:14:07 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [PATCH net 3/3] selftests: fib_rule_tests: Test UDP and TCP
 connections with DSCP rules.
Message-ID: <adc684f239cab31298038362045bd3771c3ee818.1675875519.git.gnault@redhat.com>
References: <cover.1675875519.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1675875519.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the fib_rule6_send and fib_rule4_send tests to verify that DSCP
values are properly taken into account when UDP or TCP sockets try to
connect().

Tests are done with nettest, which needs a new option to specify
the DS Field value of the socket being tested. This new option is
named '-Q', in reference to the similar option used by ping.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/fib_rule_tests.sh | 128 +++++++++++++++++-
 tools/testing/selftests/net/nettest.c         |  51 ++++++-
 2 files changed, 177 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index c245476fa29d..63c3eaec8d30 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -10,8 +10,10 @@ ret=0
 
 PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
 IP="ip -netns testns"
+IP_PEER="ip -netns peerns"
 
 RTABLE=100
+RTABLE_PEER=101
 GW_IP4=192.51.100.2
 SRC_IP=192.51.100.3
 GW_IP6=2001:db8:1::2
@@ -20,7 +22,9 @@ SRC_IP6=2001:db8:1::3
 DEV_ADDR=192.51.100.1
 DEV_ADDR6=2001:db8:1::1
 DEV=dummy0
-TESTS="fib_rule6 fib_rule4"
+TESTS="fib_rule6 fib_rule4 fib_rule6_connect fib_rule4_connect"
+
+SELFTEST_PATH=""
 
 log_test()
 {
@@ -52,6 +56,31 @@ log_section()
 	echo "######################################################################"
 }
 
+check_nettest()
+{
+	if which nettest > /dev/null 2>&1; then
+		return 0
+	fi
+
+	# Add the selftest directory to PATH if not already done
+	if [ "${SELFTEST_PATH}" = "" ]; then
+		SELFTEST_PATH="$(dirname $0)"
+		PATH="${PATH}:${SELFTEST_PATH}"
+
+		# Now retry with the new path
+		if which nettest > /dev/null 2>&1; then
+			return 0
+		fi
+
+		if [ "${ret}" -eq 0 ]; then
+			ret="${ksft_skip}"
+		fi
+		echo "nettest not found (try 'make -C ${SELFTEST_PATH} nettest')"
+	fi
+
+	return 1
+}
+
 setup()
 {
 	set -e
@@ -72,6 +101,39 @@ cleanup()
 	ip netns del testns
 }
 
+setup_peer()
+{
+	set -e
+
+	ip netns add peerns
+	$IP_PEER link set dev lo up
+
+	ip link add name veth0 netns testns type veth \
+		peer name veth1 netns peerns
+	$IP link set dev veth0 up
+	$IP_PEER link set dev veth1 up
+
+	$IP address add 192.0.2.10 peer 192.0.2.11/32 dev veth0
+	$IP_PEER address add 192.0.2.11 peer 192.0.2.10/32 dev veth1
+
+	$IP address add 2001:db8::10 peer 2001:db8::11/128 dev veth0 nodad
+	$IP_PEER address add 2001:db8::11 peer 2001:db8::10/128 dev veth1 nodad
+
+	$IP_PEER address add 198.51.100.11/32 dev lo
+	$IP route add table $RTABLE_PEER 198.51.100.11/32 via 192.0.2.11
+
+	$IP_PEER address add 2001:db8::1:11/128 dev lo
+	$IP route add table $RTABLE_PEER 2001:db8::1:11/128 via 2001:db8::11
+
+	set +e
+}
+
+cleanup_peer()
+{
+	$IP link del dev veth0
+	ip netns del peerns
+}
+
 fib_check_iproute_support()
 {
 	ip rule help 2>&1 | grep -q $1
@@ -190,6 +252,37 @@ fib_rule6_test()
 	fi
 }
 
+# Verify that the IPV6_TCLASS option of UDPv6 and TCPv6 sockets is properly
+# taken into account when connecting the socket and when sending packets.
+fib_rule6_connect_test()
+{
+	local dsfield
+
+	if ! check_nettest; then
+		echo "SKIP: Could not run test without nettest tool"
+		return
+	fi
+
+	setup_peer
+	$IP -6 rule add dsfield 0x04 table $RTABLE_PEER
+
+	# Combine the base DS Field value (0x04) with all possible ECN values
+	# (Not-ECT: 0, ECT(1): 1, ECT(0): 2, CE: 3).
+	# The ECN bits shouldn't influence the result of the test.
+	for dsfield in 0x04 0x05 0x06 0x07; do
+		nettest -q -6 -B -t 5 -N testns -O peerns -U -D \
+			-Q "${dsfield}" -l 2001:db8::1:11 -r 2001:db8::1:11
+		log_test $? 0 "rule6 dsfield udp connect (dsfield ${dsfield})"
+
+		nettest -q -6 -B -t 5 -N testns -O peerns -Q "${dsfield}" \
+			-l 2001:db8::1:11 -r 2001:db8::1:11
+		log_test $? 0 "rule6 dsfield tcp connect (dsfield ${dsfield})"
+	done
+
+	$IP -6 rule del dsfield 0x04 table $RTABLE_PEER
+	cleanup_peer
+}
+
 fib_rule4_del()
 {
 	$IP rule del $1
@@ -296,6 +389,37 @@ fib_rule4_test()
 	fi
 }
 
+# Verify that the IP_TOS option of UDPv4 and TCPv4 sockets is properly taken
+# into account when connecting the socket and when sending packets.
+fib_rule4_connect_test()
+{
+	local dsfield
+
+	if ! check_nettest; then
+		echo "SKIP: Could not run test without nettest tool"
+		return
+	fi
+
+	setup_peer
+	$IP -4 rule add dsfield 0x04 table $RTABLE_PEER
+
+	# Combine the base DS Field value (0x04) with all possible ECN values
+	# (Not-ECT: 0, ECT(1): 1, ECT(0): 2, CE: 3).
+	# The ECN bits shouldn't influence the result of the test.
+	for dsfield in 0x04 0x05 0x06 0x07; do
+		nettest -q -B -t 5 -N testns -O peerns -D -U -Q "${dsfield}" \
+			-l 198.51.100.11 -r 198.51.100.11
+		log_test $? 0 "rule4 dsfield udp connect (dsfield ${dsfield})"
+
+		nettest -q -B -t 5 -N testns -O peerns -Q "${dsfield}" \
+			-l 198.51.100.11 -r 198.51.100.11
+		log_test $? 0 "rule4 dsfield tcp connect (dsfield ${dsfield})"
+	done
+
+	$IP -4 rule del dsfield 0x04 table $RTABLE_PEER
+	cleanup_peer
+}
+
 run_fibrule_tests()
 {
 	log_section "IPv4 fib rule"
@@ -345,6 +469,8 @@ do
 	case $t in
 	fib_rule6_test|fib_rule6)		fib_rule6_test;;
 	fib_rule4_test|fib_rule4)		fib_rule4_test;;
+	fib_rule6_connect_test|fib_rule6_connect)	fib_rule6_connect_test;;
+	fib_rule4_connect_test|fib_rule4_connect)	fib_rule4_connect_test;;
 
 	help) echo "Test names: $TESTS"; exit 0;;
 
diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 7900fa98eccb..ee9a72982705 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -87,6 +87,7 @@ struct sock_args {
 	int use_setsockopt;
 	int use_freebind;
 	int use_cmsg;
+	uint8_t dsfield;
 	const char *dev;
 	const char *server_dev;
 	int ifindex;
@@ -580,6 +581,36 @@ static int set_reuseaddr(int sd)
 	return rc;
 }
 
+static int set_dsfield(int sd, int version, int dsfield)
+{
+	if (!dsfield)
+		return 0;
+
+	switch (version) {
+	case AF_INET:
+		if (setsockopt(sd, SOL_IP, IP_TOS, &dsfield,
+			       sizeof(dsfield)) < 0) {
+			log_err_errno("setsockopt(IP_TOS)");
+			return -1;
+		}
+		break;
+
+	case AF_INET6:
+		if (setsockopt(sd, SOL_IPV6, IPV6_TCLASS, &dsfield,
+			       sizeof(dsfield)) < 0) {
+			log_err_errno("setsockopt(IPV6_TCLASS)");
+			return -1;
+		}
+		break;
+
+	default:
+		log_error("Invalid address family\n");
+		return -1;
+	}
+
+	return 0;
+}
+
 static int str_to_uint(const char *str, int min, int max, unsigned int *value)
 {
 	int number;
@@ -1317,6 +1348,9 @@ static int msock_init(struct sock_args *args, int server)
 		       (char *)&one, sizeof(one)) < 0)
 		log_err_errno("Setting SO_BROADCAST error");
 
+	if (set_dsfield(sd, AF_INET, args->dsfield) != 0)
+		goto out_err;
+
 	if (args->dev && bind_to_device(sd, args->dev) != 0)
 		goto out_err;
 	else if (args->use_setsockopt &&
@@ -1445,6 +1479,9 @@ static int lsock_init(struct sock_args *args)
 	if (set_reuseport(sd) != 0)
 		goto err;
 
+	if (set_dsfield(sd, args->version, args->dsfield) != 0)
+		goto err;
+
 	if (args->dev && bind_to_device(sd, args->dev) != 0)
 		goto err;
 	else if (args->use_setsockopt &&
@@ -1658,6 +1695,9 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
 	if (set_reuseport(sd) != 0)
 		goto err;
 
+	if (set_dsfield(sd, args->version, args->dsfield) != 0)
+		goto err;
+
 	if (args->dev && bind_to_device(sd, args->dev) != 0)
 		goto err;
 	else if (args->use_setsockopt &&
@@ -1862,7 +1902,7 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SUCi6xL:0:1:2:3:Fbqf"
+#define GETOPT_STR  "sr:l:c:Q:p:t:g:P:DRn:M:X:m:d:I:BN:O:SUCi6xL:0:1:2:3:Fbqf"
 #define OPT_FORCE_BIND_KEY_IFINDEX 1001
 #define OPT_NO_BIND_KEY_IFINDEX 1002
 
@@ -1893,6 +1933,8 @@ static void print_usage(char *prog)
 	"    -D|R          datagram (D) / raw (R) socket (default stream)\n"
 	"    -l addr       local address to bind to in server mode\n"
 	"    -c addr       local address to bind to in client mode\n"
+	"    -Q dsfield    DS Field value of the socket (the IP_TOS or\n"
+	"                  IPV6_TCLASS socket option)\n"
 	"    -x            configure XFRM policy on socket\n"
 	"\n"
 	"    -d dev        bind socket to given device name\n"
@@ -1971,6 +2013,13 @@ int main(int argc, char *argv[])
 			args.has_local_ip = 1;
 			args.client_local_addr_str = optarg;
 			break;
+		case 'Q':
+			if (str_to_uint(optarg, 0, 255, &tmp) != 0) {
+				fprintf(stderr, "Invalid DS Field\n");
+				return 1;
+			}
+			args.dsfield = tmp;
+			break;
 		case 'p':
 			if (str_to_uint(optarg, 1, 65535, &tmp) != 0) {
 				fprintf(stderr, "Invalid port\n");
-- 
2.30.2

