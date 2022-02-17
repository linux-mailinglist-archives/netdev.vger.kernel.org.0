Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC71D4B956C
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 02:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiBQBVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 20:21:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiBQBVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 20:21:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41B6D81;
        Wed, 16 Feb 2022 17:21:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D6DF61CB3;
        Thu, 17 Feb 2022 01:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D195C340F3;
        Thu, 17 Feb 2022 01:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645060886;
        bh=+OCt0log3K2xs5sjl3CiOmfN5eEpTzA4BA1coaL2ZOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFxQrZA5DXCBRjFS7VIWqfDblSK9kcqsY8FuknpPONMroOxJsPR1gXcqEl347t+YO
         qfNaU7m6KLgMegKnyG43HMX054lIwV0OEl+vSkf8ZMnCnON4zJkrEyvgd9bH+4hz3i
         9y4BITj7zSquc4mrofbdzYPBx0FtP9hr2hqYXFT+uDn37MR28iDsrVPWrtqV1ldXXM
         P28SaBFgcn41i2KSBUapbb8dhHy2xk6ENoSVLCTOc7kw/zadWPweKNs4F+MSUwdA9w
         1VMY1ON0RyT2cVRJ2yRyTFXgP2alasj9YblT6V+Fz2o1A/r2FnsZ2uUHxw7zloCfX2
         CTTNowZT+HAYw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/5] selftests: net: test IPV6_DONTFRAG
Date:   Wed, 16 Feb 2022 17:21:17 -0800
Message-Id: <20220217012120.61250-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217012120.61250-1-kuba@kernel.org>
References: <20220217012120.61250-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test setting IPV6_DONTFRAG via setsockopt and cmsg
across socket types.

Output without the kernel support (this series):

    Case DONTFRAG ICMP setsock returned 0, expected 1
    Case DONTFRAG ICMP cmsg returned 0, expected 1
    Case DONTFRAG ICMP both returned 0, expected 1
    Case DONTFRAG ICMP diff returned 0, expected 1
  FAIL - 4/24 cases failed

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/cmsg_ipv6.sh  |  65 ++++++++++++++
 tools/testing/selftests/net/cmsg_sender.c | 105 +++++++++++++++++-----
 2 files changed, 147 insertions(+), 23 deletions(-)
 create mode 100755 tools/testing/selftests/net/cmsg_ipv6.sh

diff --git a/tools/testing/selftests/net/cmsg_ipv6.sh b/tools/testing/selftests/net/cmsg_ipv6.sh
new file mode 100755
index 000000000000..fb5a8ab7c909
--- /dev/null
+++ b/tools/testing/selftests/net/cmsg_ipv6.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+NS=ns
+IP6=2001:db8:1::1/64
+TGT6=2001:db8:1::2
+
+cleanup()
+{
+    ip netns del $NS
+}
+
+trap cleanup EXIT
+
+NSEXE="ip netns exec $NS"
+
+# Namespaces
+ip netns add $NS
+
+$NSEXE sysctl -w net.ipv4.ping_group_range='0 2147483647' > /dev/null
+
+# Connectivity
+ip -netns $NS link add type dummy
+ip -netns $NS link set dev dummy0 up
+ip -netns $NS addr add $IP6 dev dummy0
+
+# Test
+BAD=0
+TOTAL=0
+
+check_result() {
+    ((TOTAL++))
+    if [ $1 -ne $2 ]; then
+	echo "  Case $3 returned $1, expected $2"
+	((BAD++))
+    fi
+}
+
+# IPV6_DONTFRAG
+for ovr in setsock cmsg both diff; do
+    for df in 0 1; do
+	for p in u i r; do
+	    [ $p == "u" ] && prot=UDP
+	    [ $p == "i" ] && prot=ICMP
+	    [ $p == "r" ] && prot=RAW
+
+	    [ $ovr == "setsock" ] && m="-F $df"
+	    [ $ovr == "cmsg" ]    && m="-f $df"
+	    [ $ovr == "both" ]    && m="-F $df -f $df"
+	    [ $ovr == "diff" ]    && m="-F $((1 - df)) -f $df"
+
+	    $NSEXE ./cmsg_sender -s -S 2000 -6 -p $p $m $TGT6 1234
+	    check_result $? $df "DONTFRAG $prot $ovr"
+	done
+    done
+done
+
+# Summary
+if [ $BAD -ne 0 ]; then
+    echo "FAIL - $BAD/$TOTAL cases failed"
+    exit 1
+else
+    echo "OK"
+    exit 0
+fi
diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index efa617bd34e2..844ca6134662 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -33,22 +33,26 @@ enum {
 	ERN_CMSG_RCV,
 };
 
+struct option_cmsg_u32 {
+	bool ena;
+	unsigned int val;
+};
+
 struct options {
 	bool silent_send;
 	const char *host;
 	const char *service;
+	unsigned int size;
 	struct {
 		unsigned int mark;
+		unsigned int dontfrag;
 	} sockopt;
 	struct {
 		unsigned int family;
 		unsigned int type;
 		unsigned int proto;
 	} sock;
-	struct {
-		bool ena;
-		unsigned int val;
-	} mark;
+	struct option_cmsg_u32 mark;
 	struct {
 		bool ena;
 		unsigned int delay;
@@ -56,7 +60,11 @@ struct options {
 	struct {
 		bool ena;
 	} ts;
+	struct {
+		struct option_cmsg_u32 dontfrag;
+	} v6;
 } opt = {
+	.size = 13,
 	.sock = {
 		.family	= AF_UNSPEC,
 		.type	= SOCK_DGRAM,
@@ -72,6 +80,7 @@ static void __attribute__((noreturn)) cs_usage(const char *bin)
 	printf("Usage: %s [opts] <dst host> <dst port / service>\n", bin);
 	printf("Options:\n"
 	       "\t\t-s      Silent send() failures\n"
+	       "\t\t-S      send() size\n"
 	       "\t\t-4/-6   Force IPv4 / IPv6 only\n"
 	       "\t\t-p prot Socket protocol\n"
 	       "\t\t        (u = UDP (default); i = ICMP; r = RAW)\n"
@@ -80,6 +89,8 @@ static void __attribute__((noreturn)) cs_usage(const char *bin)
 	       "\t\t-M val  Set SO_MARK via setsockopt\n"
 	       "\t\t-d val  Set SO_TXTIME with given delay (usec)\n"
 	       "\t\t-t      Enable time stamp reporting\n"
+	       "\t\t-f val  Set don't fragment via cmsg\n"
+	       "\t\t-F val  Set don't fragment via setsockopt\n"
 	       "");
 	exit(ERN_HELP);
 }
@@ -88,11 +99,14 @@ static void cs_parse_args(int argc, char *argv[])
 {
 	char o;
 
-	while ((o = getopt(argc, argv, "46sp:m:M:d:t")) != -1) {
+	while ((o = getopt(argc, argv, "46sS:p:m:M:d:tf:F:")) != -1) {
 		switch (o) {
 		case 's':
 			opt.silent_send = true;
 			break;
+		case 'S':
+			opt.size = atoi(optarg);
+			break;
 		case '4':
 			opt.sock.family = AF_INET;
 			break;
@@ -126,6 +140,13 @@ static void cs_parse_args(int argc, char *argv[])
 		case 't':
 			opt.ts.ena = true;
 			break;
+		case 'f':
+			opt.v6.dontfrag.ena = true;
+			opt.v6.dontfrag.val = atoi(optarg);
+			break;
+		case 'F':
+			opt.sockopt.dontfrag = atoi(optarg);
+			break;
 		}
 	}
 
@@ -136,6 +157,38 @@ static void cs_parse_args(int argc, char *argv[])
 	opt.service = argv[optind + 1];
 }
 
+static void memrnd(void *s, size_t n)
+{
+	int *dword = s;
+	char *byte;
+
+	for (; n >= 4; n -= 4)
+		*dword++ = rand();
+	byte = (void *)dword;
+	while (n--)
+		*byte++ = rand();
+}
+
+static void
+ca_write_cmsg_u32(char *cbuf, size_t cbuf_sz, size_t *cmsg_len,
+		  int level, int optname, struct option_cmsg_u32 *uopt)
+{
+	struct cmsghdr *cmsg;
+
+	if (!uopt->ena)
+		return;
+
+	cmsg = (struct cmsghdr *)(cbuf + *cmsg_len);
+	*cmsg_len += CMSG_SPACE(sizeof(__u32));
+	if (cbuf_sz < *cmsg_len)
+		error(ERN_CMSG_WR, EFAULT, "cmsg buffer too small");
+
+	cmsg->cmsg_level = level;
+	cmsg->cmsg_type = optname;
+	cmsg->cmsg_len = CMSG_LEN(sizeof(__u32));
+	*(__u32 *)CMSG_DATA(cmsg) = uopt->val;
+}
+
 static void
 cs_write_cmsg(int fd, struct msghdr *msg, char *cbuf, size_t cbuf_sz)
 {
@@ -145,17 +198,11 @@ cs_write_cmsg(int fd, struct msghdr *msg, char *cbuf, size_t cbuf_sz)
 	msg->msg_control = cbuf;
 	cmsg_len = 0;
 
-	if (opt.mark.ena) {
-		cmsg = (struct cmsghdr *)(cbuf + cmsg_len);
-		cmsg_len += CMSG_SPACE(sizeof(__u32));
-		if (cbuf_sz < cmsg_len)
-			error(ERN_CMSG_WR, EFAULT, "cmsg buffer too small");
+	ca_write_cmsg_u32(cbuf, cbuf_sz, &cmsg_len,
+			  SOL_SOCKET, SO_MARK, &opt.mark);
+	ca_write_cmsg_u32(cbuf, cbuf_sz, &cmsg_len,
+			  SOL_IPV6, IPV6_DONTFRAG, &opt.v6.dontfrag);
 
-		cmsg->cmsg_level = SOL_SOCKET;
-		cmsg->cmsg_type = SO_MARK;
-		cmsg->cmsg_len = CMSG_LEN(sizeof(__u32));
-		*(__u32 *)CMSG_DATA(cmsg) = opt.mark.val;
-	}
 	if (opt.txtime.ena) {
 		struct sock_txtime so_txtime = {
 			.clockid = CLOCK_MONOTONIC,
@@ -286,18 +333,33 @@ cs_read_cmsg(int fd, struct msghdr *msg, char *cbuf, size_t cbuf_sz)
 	}
 }
 
+static void ca_set_sockopts(int fd)
+{
+	if (opt.sockopt.mark &&
+	    setsockopt(fd, SOL_SOCKET, SO_MARK,
+		       &opt.sockopt.mark, sizeof(opt.sockopt.mark)))
+		error(ERN_SOCKOPT, errno, "setsockopt SO_MARK");
+	if (opt.sockopt.dontfrag &&
+	    setsockopt(fd, SOL_IPV6, IPV6_DONTFRAG,
+		       &opt.sockopt.dontfrag, sizeof(opt.sockopt.dontfrag)))
+		error(ERN_SOCKOPT, errno, "setsockopt IPV6_DONTFRAG");
+}
+
 int main(int argc, char *argv[])
 {
-	char buf[] = "blablablabla";
 	struct addrinfo hints, *ai;
 	struct iovec iov[1];
 	struct msghdr msg;
 	char cbuf[1024];
+	char *buf;
 	int err;
 	int fd;
 
 	cs_parse_args(argc, argv);
 
+	buf = malloc(opt.size);
+	memrnd(buf, opt.size);
+
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family = opt.sock.family;
 
@@ -326,17 +388,14 @@ int main(int argc, char *argv[])
 		buf[0] = ICMPV6_ECHO_REQUEST;
 		buf[1] = 0;
 	} else if (opt.sock.type == SOCK_RAW) {
-		struct udphdr hdr = { 1, 2, htons(sizeof(buf)), 0 };
+		struct udphdr hdr = { 1, 2, htons(opt.size), 0 };
 		struct sockaddr_in6 *sin6 = (void *)ai->ai_addr;;
 
 		memcpy(buf, &hdr, sizeof(hdr));
 		sin6->sin6_port = htons(opt.sock.proto);
 	}
 
-	if (opt.sockopt.mark &&
-	    setsockopt(fd, SOL_SOCKET, SO_MARK,
-		       &opt.sockopt.mark, sizeof(opt.sockopt.mark)))
-		error(ERN_SOCKOPT, errno, "setsockopt SO_MARK");
+	ca_set_sockopts(fd);
 
 	if (clock_gettime(CLOCK_REALTIME, &time_start_real))
 		error(ERN_GETTIME, errno, "gettime REALTIME");
@@ -344,7 +403,7 @@ int main(int argc, char *argv[])
 		error(ERN_GETTIME, errno, "gettime MONOTONIC");
 
 	iov[0].iov_base = buf;
-	iov[0].iov_len = sizeof(buf);
+	iov[0].iov_len = opt.size;
 
 	memset(&msg, 0, sizeof(msg));
 	msg.msg_name = ai->ai_addr;
@@ -360,7 +419,7 @@ int main(int argc, char *argv[])
 			fprintf(stderr, "send failed: %s\n", strerror(errno));
 		err = ERN_SEND;
 		goto err_out;
-	} else if (err != sizeof(buf)) {
+	} else if (err != (int)opt.size) {
 		fprintf(stderr, "short send\n");
 		err = ERN_SEND_SHORT;
 		goto err_out;
-- 
2.34.1

