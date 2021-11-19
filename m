Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843B04577D7
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 21:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbhKSUpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:45:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:43529 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235354AbhKSUoy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:44:54 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10173"; a="231971914"
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="231971914"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 12:41:51 -0800
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="506889230"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.14.166])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 12:41:49 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/4] selftests: mptcp: add tproxy test case
Date:   Fri, 19 Nov 2021 12:41:37 -0800
Message-Id: <20211119204137.415733-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119204137.415733-1-mathew.j.martineau@linux.intel.com>
References: <20211119204137.415733-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No hard dependencies here, just skip if test environ lacks
nft binary or the needed kernel config options.

The test case spawns listener in ns2 but ns1 will connect
to the ip address of ns4.

policy routing + tproxy rule will redirect packets to ns2 instead
of forward.

v3: - update mptcp/config (Mat Martineau)
    - more verbose SKIP messages in mptcp_connect.sh

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/config      |  8 +-
 .../selftests/net/mptcp/mptcp_connect.c       | 51 +++++++++++-
 .../selftests/net/mptcp/mptcp_connect.sh      | 80 +++++++++++++++++++
 3 files changed, 136 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selftests/net/mptcp/config
index 0faaccd21447..419e71560fd1 100644
--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -13,5 +13,9 @@ CONFIG_NFT_COUNTER=m
 CONFIG_NFT_COMPAT=m
 CONFIG_NETFILTER_XTABLES=m
 CONFIG_NETFILTER_XT_MATCH_BPF=m
-CONFIG_NF_TABLES_IPV4=y
-CONFIG_NF_TABLES_IPV6=y
+CONFIG_NF_TABLES_INET=y
+CONFIG_NFT_TPROXY=m
+CONFIG_NFT_SOCKET=m
+CONFIG_IP_ADVANCED_ROUTER=y
+CONFIG_IP_MULTIPLE_TABLES=y
+CONFIG_IPV6_MULTIPLE_TABLES=y
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index 95e81d557b08..ada9b80774d4 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -75,7 +75,12 @@ struct cfg_cmsg_types {
 	unsigned int timestampns:1;
 };
 
+struct cfg_sockopt_types {
+	unsigned int transparent:1;
+};
+
 static struct cfg_cmsg_types cfg_cmsg_types;
+static struct cfg_sockopt_types cfg_sockopt_types;
 
 static void die_usage(void)
 {
@@ -93,6 +98,7 @@ static void die_usage(void)
 	fprintf(stderr, "\t-u -- check mptcp ulp\n");
 	fprintf(stderr, "\t-w num -- wait num sec before closing the socket\n");
 	fprintf(stderr, "\t-c cmsg -- test cmsg type <cmsg>\n");
+	fprintf(stderr, "\t-o option -- test sockopt <option>\n");
 	fprintf(stderr,
 		"\t-P [saveWithPeek|saveAfterPeek] -- save data with/after MSG_PEEK form tcp socket\n");
 	exit(1);
@@ -185,6 +191,22 @@ static void set_mark(int fd, uint32_t mark)
 	}
 }
 
+static void set_transparent(int fd, int pf)
+{
+	int one = 1;
+
+	switch (pf) {
+	case AF_INET:
+		if (-1 == setsockopt(fd, SOL_IP, IP_TRANSPARENT, &one, sizeof(one)))
+			perror("IP_TRANSPARENT");
+		break;
+	case AF_INET6:
+		if (-1 == setsockopt(fd, IPPROTO_IPV6, IPV6_TRANSPARENT, &one, sizeof(one)))
+			perror("IPV6_TRANSPARENT");
+		break;
+	}
+}
+
 static int sock_listen_mptcp(const char * const listenaddr,
 			     const char * const port)
 {
@@ -212,6 +234,9 @@ static int sock_listen_mptcp(const char * const listenaddr,
 				     sizeof(one)))
 			perror("setsockopt");
 
+		if (cfg_sockopt_types.transparent)
+			set_transparent(sock, pf);
+
 		if (bind(sock, a->ai_addr, a->ai_addrlen) == 0)
 			break; /* success */
 
@@ -944,6 +969,27 @@ static void parse_cmsg_types(const char *type)
 	exit(1);
 }
 
+static void parse_setsock_options(const char *name)
+{
+	char *next = strchr(name, ',');
+	unsigned int len = 0;
+
+	if (next) {
+		parse_setsock_options(next + 1);
+		len = next - name;
+	} else {
+		len = strlen(name);
+	}
+
+	if (strncmp(name, "TRANSPARENT", len) == 0) {
+		cfg_sockopt_types.transparent = 1;
+		return;
+	}
+
+	fprintf(stderr, "Unrecognized setsockopt option %s\n", name);
+	exit(1);
+}
+
 int main_loop(void)
 {
 	int fd;
@@ -1047,7 +1093,7 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "6jr:lp:s:hut:T:m:S:R:w:M:P:c:")) != -1) {
+	while ((c = getopt(argc, argv, "6jr:lp:s:hut:T:m:S:R:w:M:P:c:o:")) != -1) {
 		switch (c) {
 		case 'j':
 			cfg_join = true;
@@ -1108,6 +1154,9 @@ static void parse_opts(int argc, char **argv)
 		case 'c':
 			parse_cmsg_types(optarg);
 			break;
+		case 'o':
+			parse_setsock_options(optarg);
+			break;
 		}
 	}
 
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 559173a8e387..a4226b608c68 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -671,6 +671,82 @@ run_tests()
 	run_tests_lo $1 $2 $3 0
 }
 
+run_test_transparent()
+{
+	local connect_addr="$1"
+	local msg="$2"
+
+	local connector_ns="$ns1"
+	local listener_ns="$ns2"
+	local lret=0
+	local r6flag=""
+
+	# skip if we don't want v6
+	if ! $ipv6 && is_v6 "${connect_addr}"; then
+		return 0
+	fi
+
+ip netns exec "$listener_ns" nft -f /dev/stdin <<"EOF"
+flush ruleset
+table inet mangle {
+	chain divert {
+		type filter hook prerouting priority -150;
+
+		meta l4proto tcp socket transparent 1 meta mark set 1 accept
+		tcp dport 20000 tproxy to :20000 meta mark set 1 accept
+	}
+}
+EOF
+	if [ $? -ne 0 ]; then
+		echo "SKIP: $msg, could not load nft ruleset"
+		return
+	fi
+
+	local local_addr
+	if is_v6 "${connect_addr}"; then
+		local_addr="::"
+		r6flag="-6"
+	else
+		local_addr="0.0.0.0"
+	fi
+
+	ip -net "$listener_ns" $r6flag rule add fwmark 1 lookup 100
+	if [ $? -ne 0 ]; then
+		ip netns exec "$listener_ns" nft flush ruleset
+		echo "SKIP: $msg, ip $r6flag rule failed"
+		return
+	fi
+
+	ip -net "$listener_ns" route add local $local_addr/0 dev lo table 100
+	if [ $? -ne 0 ]; then
+		ip netns exec "$listener_ns" nft flush ruleset
+		ip -net "$listener_ns" $r6flag rule del fwmark 1 lookup 100
+		echo "SKIP: $msg, ip route add local $local_addr failed"
+		return
+	fi
+
+	echo "INFO: test $msg"
+
+	TEST_COUNT=10000
+	local extra_args="-o TRANSPARENT"
+	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP \
+		    ${connect_addr} ${local_addr} "${extra_args}"
+	lret=$?
+
+	ip netns exec "$listener_ns" nft flush ruleset
+	ip -net "$listener_ns" $r6flag rule del fwmark 1 lookup 100
+	ip -net "$listener_ns" route del local $local_addr/0 dev lo table 100
+
+	if [ $lret -ne 0 ]; then
+		echo "FAIL: $msg, mptcp connection error" 1>&2
+		ret=$lret
+		return 1
+	fi
+
+	echo "PASS: $msg"
+	return 0
+}
+
 run_tests_peekmode()
 {
 	local peekmode="$1"
@@ -794,5 +870,9 @@ run_tests_peekmode "saveWithPeek"
 run_tests_peekmode "saveAfterPeek"
 stop_if_error "Tests with peek mode have failed"
 
+# connect to ns4 ip address, ns2 should intercept/proxy
+run_test_transparent 10.0.3.1 "tproxy ipv4"
+run_test_transparent dead:beef:3::1 "tproxy ipv6"
+
 display_time
 exit $ret
-- 
2.34.0

