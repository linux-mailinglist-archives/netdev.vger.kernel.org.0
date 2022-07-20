Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFCA57BD8C
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiGTSQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiGTSQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:16:20 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078EB54CBD
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658340978; x=1689876978;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/Xc9obqdSGjIGYgDP51B7rB0fCJR6Fd9Pke6LbtAZ2M=;
  b=eUOCHSlO/aUh+56L2Fx7ABErQRAwHvcdBWhyFL1WV/PnotSEJih6yTjb
   DkN/lngcE6Myp/AFOLZnmwKymIOtePZePsQsFn1TT2jcJOXIMh5CPGLdK
   IfGAE/QhSUM360LGWDIKABtzeyvWweQBRfW9YKluFzBA/BQ8dAWLDG4wp
   Q6r/B1dDfCy42CkXyLQN3y9OzzyVuT3auJK2MG4EUpnbmd9tzOXn6Q/j+
   CWFqyppBpyKggrIOwl0TSxAw1SA0Pk1P1oib3NNiT/BIY/AFY8zpodTyI
   DkCawgVcKZL0uXhg/mRWMVryT8iIvSIbwCICWZCDKMVxpX1QYAIeLP9Tm
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="285616567"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="285616567"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 11:16:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="844136658"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jul 2022 11:16:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Alan Brady <alan.brady@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 1/1] ping: support ipv6 ping socket flow labels
Date:   Wed, 20 Jul 2022 11:13:10 -0700
Message-Id: <20220720181310.1719994-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alan Brady <alan.brady@intel.com>

Ping sockets don't appear to make any attempt to preserve flow labels
created and set by userspace using IPV6_FLOWINFO_SEND. Instead they are
clobbered by autolabels (if enabled) or zero.

Grab the flowlabel out of the msghdr similar to how rawv6_sendmsg does
it and move the memset up so it doesn't get zeroed after.

Signed-off-by: Alan Brady <alan.brady@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
v2: change 'fix' to 'support' and add some selftests

 net/ipv6/ping.c                               |  6 +-
 tools/testing/selftests/net/ipv6_flowlabel.c  | 75 +++++++++++++++----
 tools/testing/selftests/net/ipv6_flowlabel.sh | 16 ++++
 3 files changed, 81 insertions(+), 16 deletions(-)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index ecf3a553a0dc..b1179f62bd23 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -64,6 +64,8 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (err)
 		return err;
 
+	memset(&fl6, 0, sizeof(fl6));
+
 	if (msg->msg_name) {
 		DECLARE_SOCKADDR(struct sockaddr_in6 *, u, msg->msg_name);
 		if (msg->msg_namelen < sizeof(*u))
@@ -72,12 +74,15 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			return -EAFNOSUPPORT;
 		}
 		daddr = &(u->sin6_addr);
+		if (np->sndflow)
+			fl6.flowlabel = u->sin6_flowinfo & IPV6_FLOWINFO_MASK;
 		if (__ipv6_addr_needs_scope_id(ipv6_addr_type(daddr)))
 			oif = u->sin6_scope_id;
 	} else {
 		if (sk->sk_state != TCP_ESTABLISHED)
 			return -EDESTADDRREQ;
 		daddr = &sk->sk_v6_daddr;
+		fl6.flowlabel = np->flow_label;
 	}
 
 	if (!oif)
@@ -101,7 +106,6 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	ipc6.sockc.tsflags = sk->sk_tsflags;
 	ipc6.sockc.mark = sk->sk_mark;
 
-	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_oif = oif;
 
 	if (msg->msg_controllen) {
diff --git a/tools/testing/selftests/net/ipv6_flowlabel.c b/tools/testing/selftests/net/ipv6_flowlabel.c
index a7c41375374f..708a9822259d 100644
--- a/tools/testing/selftests/net/ipv6_flowlabel.c
+++ b/tools/testing/selftests/net/ipv6_flowlabel.c
@@ -9,6 +9,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <limits.h>
+#include <linux/icmpv6.h>
 #include <linux/in6.h>
 #include <stdbool.h>
 #include <stdio.h>
@@ -29,26 +30,48 @@
 #ifndef IPV6_FLOWLABEL_MGR
 #define IPV6_FLOWLABEL_MGR 32
 #endif
+#ifndef IPV6_FLOWINFO_SEND
+#define IPV6_FLOWINFO_SEND 33
+#endif
 
 #define FLOWLABEL_WILDCARD	((uint32_t) -1)
 
 static const char cfg_data[]	= "a";
 static uint32_t cfg_label	= 1;
+static bool use_ping;
+static bool use_flowinfo_send;
+
+static struct icmp6hdr icmp6 = {
+	.icmp6_type = ICMPV6_ECHO_REQUEST
+};
+
+static struct sockaddr_in6 addr = {
+	.sin6_family = AF_INET6,
+	.sin6_addr = IN6ADDR_LOOPBACK_INIT,
+};
 
 static void do_send(int fd, bool with_flowlabel, uint32_t flowlabel)
 {
 	char control[CMSG_SPACE(sizeof(flowlabel))] = {0};
 	struct msghdr msg = {0};
-	struct iovec iov = {0};
+	struct iovec iov = {
+		.iov_base = (char *)cfg_data,
+		.iov_len = sizeof(cfg_data)
+	};
 	int ret;
 
-	iov.iov_base = (char *)cfg_data;
-	iov.iov_len = sizeof(cfg_data);
+	if (use_ping) {
+		iov.iov_base = &icmp6;
+		iov.iov_len = sizeof(icmp6);
+	}
 
 	msg.msg_iov = &iov;
 	msg.msg_iovlen = 1;
 
-	if (with_flowlabel) {
+	if (use_flowinfo_send) {
+		msg.msg_name = &addr;
+		msg.msg_namelen = sizeof(addr);
+	} else if (with_flowlabel) {
 		struct cmsghdr *cm;
 
 		cm = (void *)control;
@@ -94,6 +117,8 @@ static void do_recv(int fd, bool with_flowlabel, uint32_t expect)
 	ret = recvmsg(fd, &msg, 0);
 	if (ret == -1)
 		error(1, errno, "recv");
+	if (use_ping)
+		goto parse_cmsg;
 	if (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))
 		error(1, 0, "recv: truncated");
 	if (ret != sizeof(cfg_data))
@@ -101,6 +126,7 @@ static void do_recv(int fd, bool with_flowlabel, uint32_t expect)
 	if (memcmp(data, cfg_data, sizeof(data)))
 		error(1, 0, "recv: data mismatch");
 
+parse_cmsg:
 	cm = CMSG_FIRSTHDR(&msg);
 	if (with_flowlabel) {
 		if (!cm)
@@ -114,9 +140,11 @@ static void do_recv(int fd, bool with_flowlabel, uint32_t expect)
 		flowlabel = ntohl(*(uint32_t *)CMSG_DATA(cm));
 		fprintf(stderr, "recv with label %u\n", flowlabel);
 
-		if (expect != FLOWLABEL_WILDCARD && expect != flowlabel)
+		if (expect != FLOWLABEL_WILDCARD && expect != flowlabel) {
 			fprintf(stderr, "recv: incorrect flowlabel %u != %u\n",
 					flowlabel, expect);
+			error(1, 0, "recv: flowlabel is wrong");
+		}
 
 	} else {
 		fprintf(stderr, "recv without label\n");
@@ -165,11 +193,17 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "l:")) != -1) {
+	while ((c = getopt(argc, argv, "l:ps")) != -1) {
 		switch (c) {
 		case 'l':
 			cfg_label = strtoul(optarg, NULL, 0);
 			break;
+		case 'p':
+			use_ping = true;
+			break;
+		case 's':
+			use_flowinfo_send = true;
+			break;
 		default:
 			error(1, 0, "%s: parse error", argv[0]);
 		}
@@ -178,27 +212,30 @@ static void parse_opts(int argc, char **argv)
 
 int main(int argc, char **argv)
 {
-	struct sockaddr_in6 addr = {
-		.sin6_family = AF_INET6,
-		.sin6_port = htons(8000),
-		.sin6_addr = IN6ADDR_LOOPBACK_INIT,
-	};
 	const int one = 1;
 	int fdt, fdr;
+	int prot = 0;
+
+	addr.sin6_port = htons(8000);
 
 	parse_opts(argc, argv);
 
-	fdt = socket(PF_INET6, SOCK_DGRAM, 0);
+	if (use_ping) {
+		fprintf(stderr, "attempting to use ping sockets\n");
+		prot = IPPROTO_ICMPV6;
+	}
+
+	fdt = socket(PF_INET6, SOCK_DGRAM, prot);
 	if (fdt == -1)
 		error(1, errno, "socket t");
 
-	fdr = socket(PF_INET6, SOCK_DGRAM, 0);
+	fdr = use_ping ? fdt : socket(PF_INET6, SOCK_DGRAM, 0);
 	if (fdr == -1)
 		error(1, errno, "socket r");
 
 	if (connect(fdt, (void *)&addr, sizeof(addr)))
 		error(1, errno, "connect");
-	if (bind(fdr, (void *)&addr, sizeof(addr)))
+	if (!use_ping && bind(fdr, (void *)&addr, sizeof(addr)))
 		error(1, errno, "bind");
 
 	flowlabel_get(fdt, cfg_label, IPV6_FL_S_EXCL, IPV6_FL_F_CREATE);
@@ -216,13 +253,21 @@ int main(int argc, char **argv)
 		do_recv(fdr, false, 0);
 	}
 
+	if (use_flowinfo_send) {
+		fprintf(stderr, "using IPV6_FLOWINFO_SEND to send label\n");
+		addr.sin6_flowinfo = htonl(cfg_label);
+		if (setsockopt(fdt, SOL_IPV6, IPV6_FLOWINFO_SEND, &one,
+			       sizeof(one)) == -1)
+			error(1, errno, "setsockopt flowinfo_send");
+	}
+
 	fprintf(stderr, "send label\n");
 	do_send(fdt, true, cfg_label);
 	do_recv(fdr, true, cfg_label);
 
 	if (close(fdr))
 		error(1, errno, "close r");
-	if (close(fdt))
+	if (!use_ping && close(fdt))
 		error(1, errno, "close t");
 
 	return 0;
diff --git a/tools/testing/selftests/net/ipv6_flowlabel.sh b/tools/testing/selftests/net/ipv6_flowlabel.sh
index d3bc6442704e..cee95e252bee 100755
--- a/tools/testing/selftests/net/ipv6_flowlabel.sh
+++ b/tools/testing/selftests/net/ipv6_flowlabel.sh
@@ -18,4 +18,20 @@ echo "TEST datapath (with auto-flowlabels)"
 ./in_netns.sh \
   sh -c 'sysctl -q -w net.ipv6.auto_flowlabels=1 && ./ipv6_flowlabel -l 1'
 
+echo "TEST datapath (with ping-sockets)"
+./in_netns.sh \
+  sh -c 'sysctl -q -w net.ipv6.flowlabel_reflect=4 && \
+    sysctl -q -w net.ipv4.ping_group_range="0 2147483647" && \
+    ./ipv6_flowlabel -l 1 -p'
+
+echo "TEST datapath (with flowinfo-send)"
+./in_netns.sh \
+  sh -c './ipv6_flowlabel -l 1 -s'
+
+echo "TEST datapath (with ping-sockets flowinfo-send)"
+./in_netns.sh \
+  sh -c 'sysctl -q -w net.ipv6.flowlabel_reflect=4 && \
+    sysctl -q -w net.ipv4.ping_group_range="0 2147483647" && \
+    ./ipv6_flowlabel -l 1 -p -s'
+
 echo OK. All tests passed
-- 
2.35.1

