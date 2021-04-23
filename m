Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63ED2369910
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243621AbhDWSR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:17:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:40508 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243438AbhDWSRw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 14:17:52 -0400
IronPort-SDR: IhMDEXRPzMPYJee+FiyVLQ8jVSQekfYcVYkvSmD0yK8AKz7ceUWx2ZEjBSZy28kPo/zat2w3h5
 Hy+UbqpQIb0w==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="196172523"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="196172523"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 11:17:15 -0700
IronPort-SDR: vFuFvjspdBEFLRoxwHc4WpFUB05HAl1rkIWPW2i3BVjia1Wog+BbYJ5DURxkKlfQeOjwVFBYbN
 yZ3hNtrAQ8Iw==
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="402264972"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.72.13])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 11:17:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Yonglong Li <liyonglong@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/5] selftests: mptcp: add a test case for MSG_PEEK
Date:   Fri, 23 Apr 2021 11:17:09 -0700
Message-Id: <20210423181709.330233-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423181709.330233-1-mathew.j.martineau@linux.intel.com>
References: <20210423181709.330233-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Li <liyonglong@chinatelecom.cn>

Extend mptcp_connect tool with MSG_PEEK support and add a test case in
mptcp_connect.sh that checks the data received from/after recv() with
MSG_PEEK.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../selftests/net/mptcp/mptcp_connect.c       | 48 ++++++++++++++++++-
 .../selftests/net/mptcp/mptcp_connect.sh      | 29 ++++++++---
 2 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index 2f207cf33661..d88e1fdfb147 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -45,7 +45,14 @@ enum cfg_mode {
 	CFG_MODE_SENDFILE,
 };
 
+enum cfg_peek {
+	CFG_NONE_PEEK,
+	CFG_WITH_PEEK,
+	CFG_AFTER_PEEK,
+};
+
 static enum cfg_mode cfg_mode = CFG_MODE_POLL;
+static enum cfg_peek cfg_peek = CFG_NONE_PEEK;
 static const char *cfg_host;
 static const char *cfg_port	= "12000";
 static int cfg_sock_proto	= IPPROTO_MPTCP;
@@ -73,6 +80,8 @@ static void die_usage(void)
 	fprintf(stderr, "\t-M mark -- set socket packet mark\n");
 	fprintf(stderr, "\t-u -- check mptcp ulp\n");
 	fprintf(stderr, "\t-w num -- wait num sec before closing the socket\n");
+	fprintf(stderr,
+		"\t-P [saveWithPeek|saveAfterPeek] -- save data with/after MSG_PEEK form tcp socket\n");
 	exit(1);
 }
 
@@ -331,6 +340,8 @@ static size_t do_write(const int fd, char *buf, const size_t len)
 
 static ssize_t do_rnd_read(const int fd, char *buf, const size_t len)
 {
+	int ret = 0;
+	char tmp[16384];
 	size_t cap = rand();
 
 	cap &= 0xffff;
@@ -340,7 +351,17 @@ static ssize_t do_rnd_read(const int fd, char *buf, const size_t len)
 	else if (cap > len)
 		cap = len;
 
-	return read(fd, buf, cap);
+	if (cfg_peek == CFG_WITH_PEEK) {
+		ret = recv(fd, buf, cap, MSG_PEEK);
+		ret = (ret < 0) ? ret : read(fd, tmp, ret);
+	} else if (cfg_peek == CFG_AFTER_PEEK) {
+		ret = recv(fd, buf, cap, MSG_PEEK);
+		ret = (ret < 0) ? ret : read(fd, buf, cap);
+	} else {
+		ret = read(fd, buf, cap);
+	}
+
+	return ret;
 }
 
 static void set_nonblock(int fd)
@@ -819,6 +840,26 @@ int parse_mode(const char *mode)
 	return 0;
 }
 
+int parse_peek(const char *mode)
+{
+	if (!strcasecmp(mode, "saveWithPeek"))
+		return CFG_WITH_PEEK;
+	if (!strcasecmp(mode, "saveAfterPeek"))
+		return CFG_AFTER_PEEK;
+
+	fprintf(stderr, "Unknown: %s\n", mode);
+	fprintf(stderr, "Supported MSG_PEEK mode are:\n");
+	fprintf(stderr,
+		"\t\t\"saveWithPeek\" - recv data with flags 'MSG_PEEK' and save the peek data into file\n");
+	fprintf(stderr,
+		"\t\t\"saveAfterPeek\" - read and save data into file after recv with flags 'MSG_PEEK'\n");
+
+	die_usage();
+
+	/* silence compiler warning */
+	return 0;
+}
+
 static int parse_int(const char *size)
 {
 	unsigned long s;
@@ -846,7 +887,7 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "6jr:lp:s:hut:m:S:R:w:M:")) != -1) {
+	while ((c = getopt(argc, argv, "6jr:lp:s:hut:m:S:R:w:M:P:")) != -1) {
 		switch (c) {
 		case 'j':
 			cfg_join = true;
@@ -899,6 +940,9 @@ static void parse_opts(int argc, char **argv)
 		case 'M':
 			cfg_mark = strtol(optarg, NULL, 0);
 			break;
+		case 'P':
+			cfg_peek = parse_peek(optarg);
+			break;
 		}
 	}
 
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 385cdc98aed8..9236609731b1 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -375,7 +375,7 @@ do_transfer()
 	local srv_proto="$4"
 	local connect_addr="$5"
 	local local_addr="$6"
-	local extra_args=""
+	local extra_args="$7"
 
 	local port
 	port=$((10000+$TEST_COUNT))
@@ -394,9 +394,9 @@ do_transfer()
 	fi
 
 	if [ -n "$extra_args" ] && $options_log; then
-		options_log=false
 		echo "INFO: extra options: $extra_args"
 	fi
+	options_log=false
 
 	:> "$cout"
 	:> "$sout"
@@ -589,6 +589,7 @@ run_tests_lo()
 	local connector_ns="$2"
 	local connect_addr="$3"
 	local loopback="$4"
+	local extra_args="$5"
 	local lret=0
 
 	# skip if test programs are running inside same netns for subsequent runs.
@@ -608,7 +609,8 @@ run_tests_lo()
 		local_addr="0.0.0.0"
 	fi
 
-	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr} ${local_addr}
+	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP \
+		    ${connect_addr} ${local_addr} "${extra_args}"
 	lret=$?
 	if [ $lret -ne 0 ]; then
 		ret=$lret
@@ -622,14 +624,16 @@ run_tests_lo()
 		fi
 	fi
 
-	do_transfer ${listener_ns} ${connector_ns} MPTCP TCP ${connect_addr} ${local_addr}
+	do_transfer ${listener_ns} ${connector_ns} MPTCP TCP \
+		    ${connect_addr} ${local_addr} "${extra_args}"
 	lret=$?
 	if [ $lret -ne 0 ]; then
 		ret=$lret
 		return 1
 	fi
 
-	do_transfer ${listener_ns} ${connector_ns} TCP MPTCP ${connect_addr} ${local_addr}
+	do_transfer ${listener_ns} ${connector_ns} TCP MPTCP \
+		    ${connect_addr} ${local_addr} "${extra_args}"
 	lret=$?
 	if [ $lret -ne 0 ]; then
 		ret=$lret
@@ -637,7 +641,8 @@ run_tests_lo()
 	fi
 
 	if [ $do_tcp -gt 1 ] ;then
-		do_transfer ${listener_ns} ${connector_ns} TCP TCP ${connect_addr} ${local_addr}
+		do_transfer ${listener_ns} ${connector_ns} TCP TCP \
+			    ${connect_addr} ${local_addr} "${extra_args}"
 		lret=$?
 		if [ $lret -ne 0 ]; then
 			ret=$lret
@@ -653,6 +658,15 @@ run_tests()
 	run_tests_lo $1 $2 $3 0
 }
 
+run_tests_peekmode()
+{
+	local peekmode="$1"
+
+	echo "INFO: with peek mode: ${peekmode}"
+	run_tests_lo "$ns1" "$ns1" 10.0.1.1 1 "-P ${peekmode}"
+	run_tests_lo "$ns1" "$ns1" dead:beef:1::1 1 "-P ${peekmode}"
+}
+
 make_file "$cin" "client"
 make_file "$sin" "server"
 
@@ -732,6 +746,9 @@ for sender in $ns1 $ns2 $ns3 $ns4;do
 	run_tests "$ns4" $sender dead:beef:3::1
 done
 
+run_tests_peekmode "saveWithPeek"
+run_tests_peekmode "saveAfterPeek"
+
 time_end=$(date +%s)
 time_run=$((time_end-time_start))
 
-- 
2.31.1

