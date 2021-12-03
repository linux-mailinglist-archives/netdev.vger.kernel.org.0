Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B79467FF1
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 23:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383427AbhLCWjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 17:39:12 -0500
Received: from mga18.intel.com ([134.134.136.126]:46470 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383422AbhLCWjM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 17:39:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="223940931"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="223940931"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:47 -0800
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="460185304"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.18.88])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:47 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 02/10] selftests: mptcp: add TCP_INQ support
Date:   Fri,  3 Dec 2021 14:35:33 -0800
Message-Id: <20211203223541.69364-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
References: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Do checks on the returned inq counter.

Fail on:
1. Huge value (> 1 kbyte, test case files are 1 kb)
2. last hint larger than returned bytes when read was short
3. erronenous indication of EOF.

3) happens when a hint of X bytes reads X-1 on next call
   but next recvmsg returns more data (instead of EOF).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../selftests/net/mptcp/mptcp_connect.c       | 60 ++++++++++++++++++-
 .../selftests/net/mptcp/mptcp_sockopt.sh      |  4 +-
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index ada9b80774d4..98de28ac3ba8 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -73,12 +73,20 @@ static uint32_t cfg_mark;
 struct cfg_cmsg_types {
 	unsigned int cmsg_enabled:1;
 	unsigned int timestampns:1;
+	unsigned int tcp_inq:1;
 };
 
 struct cfg_sockopt_types {
 	unsigned int transparent:1;
 };
 
+struct tcp_inq_state {
+	unsigned int last;
+	bool expect_eof;
+};
+
+static struct tcp_inq_state tcp_inq;
+
 static struct cfg_cmsg_types cfg_cmsg_types;
 static struct cfg_sockopt_types cfg_sockopt_types;
 
@@ -389,7 +397,9 @@ static size_t do_write(const int fd, char *buf, const size_t len)
 static void process_cmsg(struct msghdr *msgh)
 {
 	struct __kernel_timespec ts;
+	bool inq_found = false;
 	bool ts_found = false;
+	unsigned int inq = 0;
 	struct cmsghdr *cmsg;
 
 	for (cmsg = CMSG_FIRSTHDR(msgh); cmsg ; cmsg = CMSG_NXTHDR(msgh, cmsg)) {
@@ -398,12 +408,27 @@ static void process_cmsg(struct msghdr *msgh)
 			ts_found = true;
 			continue;
 		}
+		if (cmsg->cmsg_level == IPPROTO_TCP && cmsg->cmsg_type == TCP_CM_INQ) {
+			memcpy(&inq, CMSG_DATA(cmsg), sizeof(inq));
+			inq_found = true;
+			continue;
+		}
+
 	}
 
 	if (cfg_cmsg_types.timestampns) {
 		if (!ts_found)
 			xerror("TIMESTAMPNS not present\n");
 	}
+
+	if (cfg_cmsg_types.tcp_inq) {
+		if (!inq_found)
+			xerror("TCP_INQ not present\n");
+
+		if (inq > 1024)
+			xerror("tcp_inq %u is larger than one kbyte\n", inq);
+		tcp_inq.last = inq;
+	}
 }
 
 static ssize_t do_recvmsg_cmsg(const int fd, char *buf, const size_t len)
@@ -420,10 +445,23 @@ static ssize_t do_recvmsg_cmsg(const int fd, char *buf, const size_t len)
 		.msg_controllen = sizeof(msg_buf),
 	};
 	int flags = 0;
+	unsigned int last_hint = tcp_inq.last;
 	int ret = recvmsg(fd, &msg, flags);
 
-	if (ret <= 0)
+	if (ret <= 0) {
+		if (ret == 0 && tcp_inq.expect_eof)
+			return ret;
+
+		if (ret == 0 && cfg_cmsg_types.tcp_inq)
+			if (last_hint != 1 && last_hint != 0)
+				xerror("EOF but last tcp_inq hint was %u\n", last_hint);
+
 		return ret;
+	}
+
+	if (tcp_inq.expect_eof)
+		xerror("expected EOF, last_hint %u, now %u\n",
+		       last_hint, tcp_inq.last);
 
 	if (msg.msg_controllen && !cfg_cmsg_types.cmsg_enabled)
 		xerror("got %lu bytes of cmsg data, expected 0\n",
@@ -435,6 +473,19 @@ static ssize_t do_recvmsg_cmsg(const int fd, char *buf, const size_t len)
 	if (msg.msg_controllen)
 		process_cmsg(&msg);
 
+	if (cfg_cmsg_types.tcp_inq) {
+		if ((size_t)ret < len && last_hint > (unsigned int)ret) {
+			if (ret + 1 != (int)last_hint) {
+				int next = read(fd, msg_buf, sizeof(msg_buf));
+
+				xerror("read %u of %u, last_hint was %u tcp_inq hint now %u next_read returned %d/%m\n",
+				       ret, (unsigned int)len, last_hint, tcp_inq.last, next);
+			} else {
+				tcp_inq.expect_eof = true;
+			}
+		}
+	}
+
 	return ret;
 }
 
@@ -944,6 +995,8 @@ static void apply_cmsg_types(int fd, const struct cfg_cmsg_types *cmsg)
 
 	if (cmsg->timestampns)
 		xsetsockopt(fd, SOL_SOCKET, SO_TIMESTAMPNS_NEW, &on, sizeof(on));
+	if (cmsg->tcp_inq)
+		xsetsockopt(fd, IPPROTO_TCP, TCP_INQ, &on, sizeof(on));
 }
 
 static void parse_cmsg_types(const char *type)
@@ -965,6 +1018,11 @@ static void parse_cmsg_types(const char *type)
 		return;
 	}
 
+	if (strncmp(type, "TCPINQ", len) == 0) {
+		cfg_cmsg_types.tcp_inq = 1;
+		return;
+	}
+
 	fprintf(stderr, "Unrecognized cmsg option %s\n", type);
 	exit(1);
 }
diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
index 41de643788b8..c8c364369599 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
@@ -178,7 +178,7 @@ do_transfer()
 
 	timeout ${timeout_test} \
 		ip netns exec ${listener_ns} \
-			$mptcp_connect -t ${timeout_poll} -l -M 1 -p $port -s ${srv_proto} -c TIMESTAMPNS \
+			$mptcp_connect -t ${timeout_poll} -l -M 1 -p $port -s ${srv_proto} -c TIMESTAMPNS,TCPINQ \
 				${local_addr} < "$sin" > "$sout" &
 	spid=$!
 
@@ -186,7 +186,7 @@ do_transfer()
 
 	timeout ${timeout_test} \
 		ip netns exec ${connector_ns} \
-			$mptcp_connect -t ${timeout_poll} -M 2 -p $port -s ${cl_proto} -c TIMESTAMPNS \
+			$mptcp_connect -t ${timeout_poll} -M 2 -p $port -s ${cl_proto} -c TIMESTAMPNS,TCPINQ \
 				$connect_addr < "$cin" > "$cout" &
 
 	cpid=$!
-- 
2.34.1

