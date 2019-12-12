Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8236011D26C
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 17:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbfLLQgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 11:36:50 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39663 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729883AbfLLQgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 11:36:50 -0500
Received: by mail-qt1-f195.google.com with SMTP id i12so2785865qtp.6
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 08:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JHntgrrBjeNyPsGxQSc+b1zy3+T4ugECE3btZhC+mKo=;
        b=XKW0p3zTuuWX5aAdIZHPEwjdvNHO3tZP9IZhrGWLPdhwu8AQQhnEU2paLwZHd0TGWN
         oyndZwYv96ZfNrthG3CczpiOInawTqhxwOFimBF1vEwauchxD5fIM/Vj+hz07BfOw+zU
         ktQEwMvI+vauNreC02dmj7vcT0bCFRh2nbdpz9iZ0Uw9O73yRuGu/4SvNrpYutOvnbxP
         kvmxbWuA5yh8wdmx3Oa442CBM/InvVyt024WOJxkd07K77K7BV0Qg4gnplQlDpMyGYkv
         rsSVlFoXImzOlJSXcqchEaf0ZsHIqsx5vmWe+CchrUZ9yLadMXhiIiJ7H+O5rYEt2bds
         MWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JHntgrrBjeNyPsGxQSc+b1zy3+T4ugECE3btZhC+mKo=;
        b=aNju94UeeRfryKTPYuHbCf1gm7Hqsryp8kI5XzglC+6TLWRbefKCL6KA8Nr3sluohL
         Z3EpnXTo2kMD2hyOfQkXiaitoVsHcuy0rhhvSYi2xNctNTjF6qd1H7lr2uqicUrWhz9s
         akUhJ35VfTKCPXTcNyGmIj4CDf/PVmCONX8fug/CRjSsoEBSVrtib2FlHFUK49sPi5pV
         Y32enGx+MURqHuIyb5TYQ3f/gq8ke17ssIZ7Tp9ovDd0o8dRAls5bwcu+XEaeEMnc3CW
         f+fPwdfxab7jrjygd8/GRsPrC56t30m7fUDflBfFYHkgSVG3WZCRKLWgHwCH0+4uEO58
         NBHw==
X-Gm-Message-State: APjAAAXmk4u8Vg389L74xwCPyozNOT+6Z3toL6sBUh4KYbCBJ3Wc1gRm
        UWk5ymVFfj+a3gWG3HoFz/7iKtq3
X-Google-Smtp-Source: APXvYqz8PHooLE2y+yn+1wL+cMFfz/W+XUuW0bmB+2rDQ3C8AF70rDzNyq2ZuVLlS927fgnUTCdHUA==
X-Received: by 2002:aed:24b2:: with SMTP id t47mr8149031qtc.337.1576168608444;
        Thu, 12 Dec 2019 08:36:48 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:6084:feee:4efa:5ea9])
        by smtp.gmail.com with ESMTPSA id t16sm2203052qtn.74.2019.12.12.08.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 08:36:47 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH net-next] selftests/net: make so_txtime more robust to timer variance
Date:   Thu, 12 Dec 2019 11:36:46 -0500
Message-Id: <20191212163646.190982-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

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
2.24.0.525.g8f36a354ae-goog

