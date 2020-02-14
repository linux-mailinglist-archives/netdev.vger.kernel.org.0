Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF77E15DC78
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731261AbgBNPx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:53:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731249AbgBNPx0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2B7E222C4;
        Fri, 14 Feb 2020 15:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695606;
        bh=88HK1gOY1FHSYpLNTI+/uJaGR/7f7jW7TlUIoj3OmtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTURer+h8ob4eqNOd/VvBayk6eU5N6jpy5O/17nGzcksspeuLv5wJ8+25k8BDsIhS
         XOeOnTnuvCU3mQoV7yYvKbLUMOhIsxf7moJlEGsejjLPK0VmHx0P/NU8g1GVFODeAF
         1czbKSNha4t65F++JkrIIZlzzkfcUK2fia8WYosk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 209/542] selftests/net: make so_txtime more robust to timer variance
Date:   Fri, 14 Feb 2020 10:43:21 -0500
Message-Id: <20200214154854.6746-209-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit ea6a547669b37453f2b1a5d85188d75b3613dfaa ]

The SO_TXTIME test depends on accurate timers. In some virtualized
environments the test has been reported to be flaky. This is easily
reproduced by disabling kvm acceleration in Qemu.

Allow greater variance in a run and retry to further reduce flakiness.

Observed errors are one of two kinds: either the packet arrives too
early or late at recv(), or it was dropped in the qdisc itself and the
recv() call times out.

In the latter case, the qdisc queues a notification to the error
queue of the send socket. Also explicitly report this cause.

Link: https://lore.kernel.org/netdev/CA+FuTSdYOnJCsGuj43xwV1jxvYsaoa_LzHQF9qMyhrkLrivxKw@mail.gmail.com
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/so_txtime.c  | 84 +++++++++++++++++++++++-
 tools/testing/selftests/net/so_txtime.sh |  9 ++-
 2 files changed, 88 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/so_txtime.c b/tools/testing/selftests/net/so_txtime.c
index 34df4c8882afb..383bac05ac324 100644
--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -12,7 +12,11 @@
 #include <arpa/inet.h>
 #include <error.h>
 #include <errno.h>
+#include <inttypes.h>
 #include <linux/net_tstamp.h>
+#include <linux/errqueue.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
 #include <stdbool.h>
 #include <stdlib.h>
 #include <stdio.h>
@@ -28,7 +32,7 @@ static int	cfg_clockid	= CLOCK_TAI;
 static bool	cfg_do_ipv4;
 static bool	cfg_do_ipv6;
 static uint16_t	cfg_port	= 8000;
-static int	cfg_variance_us	= 2000;
+static int	cfg_variance_us	= 4000;
 
 static uint64_t glob_tstart;
 
@@ -43,6 +47,9 @@ static struct timed_send cfg_in[MAX_NUM_PKT];
 static struct timed_send cfg_out[MAX_NUM_PKT];
 static int cfg_num_pkt;
 
+static int cfg_errq_level;
+static int cfg_errq_type;
+
 static uint64_t gettime_ns(void)
 {
 	struct timespec ts;
@@ -90,13 +97,15 @@ static void do_send_one(int fdt, struct timed_send *ts)
 
 }
 
-static void do_recv_one(int fdr, struct timed_send *ts)
+static bool do_recv_one(int fdr, struct timed_send *ts)
 {
 	int64_t tstop, texpect;
 	char rbuf[2];
 	int ret;
 
 	ret = recv(fdr, rbuf, sizeof(rbuf), 0);
+	if (ret == -1 && errno == EAGAIN)
+		return true;
 	if (ret == -1)
 		error(1, errno, "read");
 	if (ret != 1)
@@ -113,6 +122,8 @@ static void do_recv_one(int fdr, struct timed_send *ts)
 
 	if (labs(tstop - texpect) > cfg_variance_us)
 		error(1, 0, "exceeds variance (%d us)", cfg_variance_us);
+
+	return false;
 }
 
 static void do_recv_verify_empty(int fdr)
@@ -125,12 +136,70 @@ static void do_recv_verify_empty(int fdr)
 		error(1, 0, "recv: not empty as expected (%d, %d)", ret, errno);
 }
 
+static void do_recv_errqueue_timeout(int fdt)
+{
+	char control[CMSG_SPACE(sizeof(struct sock_extended_err)) +
+		     CMSG_SPACE(sizeof(struct sockaddr_in6))] = {0};
+	char data[sizeof(struct ipv6hdr) +
+		  sizeof(struct tcphdr) + 1];
+	struct sock_extended_err *err;
+	struct msghdr msg = {0};
+	struct iovec iov = {0};
+	struct cmsghdr *cm;
+	int64_t tstamp = 0;
+	int ret;
+
+	iov.iov_base = data;
+	iov.iov_len = sizeof(data);
+
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+
+	msg.msg_control = control;
+	msg.msg_controllen = sizeof(control);
+
+	while (1) {
+		ret = recvmsg(fdt, &msg, MSG_ERRQUEUE);
+		if (ret == -1 && errno == EAGAIN)
+			break;
+		if (ret == -1)
+			error(1, errno, "errqueue");
+		if (msg.msg_flags != MSG_ERRQUEUE)
+			error(1, 0, "errqueue: flags 0x%x\n", msg.msg_flags);
+
+		cm = CMSG_FIRSTHDR(&msg);
+		if (cm->cmsg_level != cfg_errq_level ||
+		    cm->cmsg_type != cfg_errq_type)
+			error(1, 0, "errqueue: type 0x%x.0x%x\n",
+				    cm->cmsg_level, cm->cmsg_type);
+
+		err = (struct sock_extended_err *)CMSG_DATA(cm);
+		if (err->ee_origin != SO_EE_ORIGIN_TXTIME)
+			error(1, 0, "errqueue: origin 0x%x\n", err->ee_origin);
+		if (err->ee_code != ECANCELED)
+			error(1, 0, "errqueue: code 0x%x\n", err->ee_code);
+
+		tstamp = ((int64_t) err->ee_data) << 32 | err->ee_info;
+		tstamp -= (int64_t) glob_tstart;
+		tstamp /= 1000 * 1000;
+		fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped\n",
+				data[ret - 1], tstamp);
+
+		msg.msg_flags = 0;
+		msg.msg_controllen = sizeof(control);
+	}
+
+	error(1, 0, "recv: timeout");
+}
+
 static void setsockopt_txtime(int fd)
 {
 	struct sock_txtime so_txtime_val = { .clockid = cfg_clockid };
 	struct sock_txtime so_txtime_val_read = { 0 };
 	socklen_t vallen = sizeof(so_txtime_val);
 
+	so_txtime_val.flags = SOF_TXTIME_REPORT_ERRORS;
+
 	if (setsockopt(fd, SOL_SOCKET, SO_TXTIME,
 		       &so_txtime_val, sizeof(so_txtime_val)))
 		error(1, errno, "setsockopt txtime");
@@ -194,7 +263,8 @@ static void do_test(struct sockaddr *addr, socklen_t alen)
 	for (i = 0; i < cfg_num_pkt; i++)
 		do_send_one(fdt, &cfg_in[i]);
 	for (i = 0; i < cfg_num_pkt; i++)
-		do_recv_one(fdr, &cfg_out[i]);
+		if (do_recv_one(fdr, &cfg_out[i]))
+			do_recv_errqueue_timeout(fdt);
 
 	do_recv_verify_empty(fdr);
 
@@ -280,6 +350,10 @@ int main(int argc, char **argv)
 		addr6.sin6_family = AF_INET6;
 		addr6.sin6_port = htons(cfg_port);
 		addr6.sin6_addr = in6addr_loopback;
+
+		cfg_errq_level = SOL_IPV6;
+		cfg_errq_type = IPV6_RECVERR;
+
 		do_test((void *)&addr6, sizeof(addr6));
 	}
 
@@ -289,6 +363,10 @@ int main(int argc, char **argv)
 		addr4.sin_family = AF_INET;
 		addr4.sin_port = htons(cfg_port);
 		addr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+
+		cfg_errq_level = SOL_IP;
+		cfg_errq_type = IP_RECVERR;
+
 		do_test((void *)&addr4, sizeof(addr4));
 	}
 
diff --git a/tools/testing/selftests/net/so_txtime.sh b/tools/testing/selftests/net/so_txtime.sh
index 5aa519328a5b5..3f7800eaecb1e 100755
--- a/tools/testing/selftests/net/so_txtime.sh
+++ b/tools/testing/selftests/net/so_txtime.sh
@@ -5,7 +5,12 @@
 
 # Run in network namespace
 if [[ $# -eq 0 ]]; then
-	./in_netns.sh $0 __subprocess
+	if ! ./in_netns.sh $0 __subprocess; then
+		# test is time sensitive, can be flaky
+		echo "test failed: retry once"
+		./in_netns.sh $0 __subprocess
+	fi
+
 	exit $?
 fi
 
@@ -18,7 +23,7 @@ tc qdisc add dev lo root fq
 ./so_txtime -4 -6 -c mono a,10,b,20 a,10,b,20
 ./so_txtime -4 -6 -c mono a,20,b,10 b,20,a,20
 
-if tc qdisc replace dev lo root etf clockid CLOCK_TAI delta 200000; then
+if tc qdisc replace dev lo root etf clockid CLOCK_TAI delta 400000; then
 	! ./so_txtime -4 -6 -c tai a,-1 a,-1
 	! ./so_txtime -4 -6 -c tai a,0 a,0
 	./so_txtime -4 -6 -c tai a,10 a,10
-- 
2.20.1

