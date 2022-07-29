Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255565851B6
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 16:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbiG2OkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 10:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237156AbiG2OkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 10:40:00 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1AD7E02E
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 07:39:56 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id f20so438376lfc.10
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 07:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N5JoMWEdpqW2rG4X2OnLxPkiYqb3od743gGmev+ObJk=;
        b=NB6jPgssQMsFB/CmjXcLDhk96st7QqSeQAFQzUg1+/DgvCJIXSF9NPAJhN1BYzGMG4
         7kHAmLtC3GYv9z6WO7KmfsU0fYbFdKELkMGmmkm/uyF5FKurBqhGRmFJWmt1uhpv+cLY
         nEwZGbwrzgmKVvxtd06jqMHTkFtTft5Um585o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N5JoMWEdpqW2rG4X2OnLxPkiYqb3od743gGmev+ObJk=;
        b=yLRLQGRa67wxi9V4JKPzeyoV50NBCeueLdKT8PXhXkxRrn4l/uSByPDZW30wlvZPS+
         SHIlm+31qrZDjQU3W+UOzvEyDFI+d074JMar7WxfmoHXKd/BUNGAlsJm8HM//wzb+H/o
         44y8iZUjPd6b420dJcNO/1CzbnWe05wdYW5FB/toXGc15HuWm5cgz0hOJrVGHSy8eOWb
         Wa4iIfxP0ZXF6SLw9dsHr7PBdE8qaSCp29ZEAyz3GPsmiBoO8xBAiymHN35tYicneytM
         jn8Ncw9FqnFPRwm1mVN70HIApfBqdexEXgjrMU45QqM52RPfxSfgjlOMFugk5vMWbBdf
         +t0Q==
X-Gm-Message-State: AJIora9GETGeC/nOTlKeg42xlJKmpgPonHekJBhR/rlrAFnAgNLzmyCS
        pyhZSe1GDBY5KJwFM+QcivB+WndSuSNATQ==
X-Google-Smtp-Source: AGRyM1ud5Y1X1Hjgp+8ZnEdUViHKlDSPcVjAY+3CGnRkScPwH1ATkjYRK1uEEEPdyIfPRbfO8CgIKg==
X-Received: by 2002:ac2:4c4d:0:b0:48a:7a96:470d with SMTP id o13-20020ac24c4d000000b0048a7a96470dmr1269225lfk.682.1659105594827;
        Fri, 29 Jul 2022 07:39:54 -0700 (PDT)
Received: from localhost.localdomain ([2a01:110f:4304:1700:d82f:ac98:7032:476e])
        by smtp.gmail.com with ESMTPSA id i2-20020a196d02000000b0048ab15f2262sm678380lfc.96.2022.07.29.07.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 07:39:54 -0700 (PDT)
From:   Marek Majkowski <marek@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, kernel-team@cloudflare.com,
        ivan@cloudflare.com, edumazet@google.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, brakmo@fb.com,
        Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH net-next v2 2/2] Tests for RTAX_INITRWND
Date:   Fri, 29 Jul 2022 16:39:35 +0200
Message-Id: <20220729143935.2432743-3-marek@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220729143935.2432743-1-marek@cloudflare.com>
References: <20220729143935.2432743-1-marek@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Accompanying tests. We open skops program, hooking on
BPF_SOCK_OPS_RWND_INIT event, where we return updated value of
initrwnd route path attribute.

In tests we see if values above 64KiB indeed are advertised correctly
to the remote peer.

Signed-off-by: Marek Majkowski <marek@cloudflare.com>
---
 .../selftests/bpf/prog_tests/tcp_initrwnd.c   | 420 ++++++++++++++++++
 .../selftests/bpf/progs/test_tcp_initrwnd.c   |  30 ++
 2 files changed, 450 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcp_initrwnd.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tcp_initrwnd.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_initrwnd.c b/tools/testing/selftests/bpf/prog_tests/tcp_initrwnd.c
new file mode 100644
index 000000000000..af54dde05609
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_initrwnd.c
@@ -0,0 +1,420 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright (c) 2022 Cloudflare
+
+#include "test_progs.h"
+#include "bpf_util.h"
+#include "network_helpers.h"
+
+#include "test_tcp_initrwnd.skel.h"
+
+#define CG_NAME "/tcpbpf-user-test"
+
+/* It's easier to hardcode offsets than to fight with headers
+ *
+ * $ pahole tcp_info
+ * struct tcp_info {
+ *	__u32                      tcpi_rcv_ssthresh;   *    64     4 *
+ *	__u32                      tcpi_snd_wnd;        *   228     4 *
+ */
+
+#define TCPI_RCV_SSTHRESH(info) info[64 / 4]
+#define TCPI_SND_WND(info) info[228 / 4]
+
+static int read_int_sysctl(const char *sysctl)
+{
+	char buf[16];
+	int fd, ret;
+
+	fd = open(sysctl, 0);
+	if (CHECK_FAIL(fd == -1))
+		goto err;
+
+	ret = read(fd, buf, sizeof(buf));
+	if (CHECK_FAIL(ret <= 0))
+		goto err;
+
+	close(fd);
+	return atoi(buf);
+err:
+	if (fd < 0)
+		close(fd);
+	return -1;
+}
+
+static int write_int_sysctl(const char *sysctl, int v)
+{
+	int fd, ret, size;
+	char buf[16];
+
+	fd = open(sysctl, O_RDWR);
+	if (CHECK_FAIL(fd < 0))
+		goto err;
+
+	size = snprintf(buf, sizeof(buf), "%d", v);
+	ret = write(fd, buf, size);
+	if (CHECK_FAIL(ret < 0))
+		goto err;
+
+	close(fd);
+	return 0;
+err:
+	if (fd < 0)
+		close(fd);
+	return -1;
+}
+
+static int tcp_timestamps;
+static int tcp_window_scaling;
+static int tcp_workaround_signed_windows;
+static int tcp_syncookies;
+
+static void do_test_server(int server_fd, struct test_tcp_initrwnd *skel,
+			   int initrwnd, unsigned int tcpi_snd_wnd_on_connect,
+			   unsigned int rcv_ssthresh_on_recv,
+			   unsigned int tcpi_snd_wnd_on_recv)
+{
+	int client_fd = -1, sd = -1, r;
+	__u32 info[256 / 4];
+	socklen_t optlen = sizeof(info);
+	char b[1] = { 0x55 };
+
+	fprintf(stderr, "[*] initrwnd=%d\n", initrwnd);
+
+	skel->bss->initrwnd = initrwnd; // in full MSS packets
+
+	client_fd = connect_to_fd(server_fd, 0);
+	if (CHECK_FAIL(client_fd < 0))
+		goto err;
+
+	sd = accept(server_fd, NULL, NULL);
+	if (CHECK_FAIL(sd < 0))
+		goto err;
+
+	/* There are three moments where we check the window/rcv_ssthresh.
+	 *
+	 * (1) First, after socket creation, TCP handshake, we expect
+	 * the client to see only SYN+ACK which is without window
+	 * scaling. That is: from client/sender point of view we see
+	 * at most 64KiB open receive window.
+	 */
+	r = getsockopt(client_fd, SOL_TCP, TCP_INFO, &info, &optlen);
+	if (CHECK_FAIL(r < 0))
+		goto err;
+
+	ASSERT_EQ(TCPI_SND_WND(info), tcpi_snd_wnd_on_connect,
+		  "getsockopt(TCP_INFO.tcpi_snd_wnd) on connect");
+
+	/* (2) At the same time, from the server/receiver point of
+	 * view, we already initiated socket, so rcv_ssthresh is set
+	 * to high value, potentially larger than 64KiB.
+	 */
+	r = getsockopt(sd, SOL_TCP, TCP_INFO, &info, &optlen);
+	if (CHECK_FAIL(r < 0))
+		goto err;
+
+	ASSERT_EQ(TCPI_RCV_SSTHRESH(info), rcv_ssthresh_on_recv,
+		  "getsockopt(TCP_INFO.rcv_ssthresh) on recv");
+
+	ASSERT_LE(tcpi_snd_wnd_on_connect, rcv_ssthresh_on_recv,
+		  "snd_wnd > rcv_ssthresh");
+
+	/* (3) Finally, after receiving some ACK from client, the
+	 * client/sender should also see wider open window, larger
+	 * than 64KiB.
+	 */
+	if (CHECK_FAIL(write(client_fd, &b, sizeof(b)) != 1))
+		perror("Failed to send single byte");
+
+	if (CHECK_FAIL(read(sd, &b, sizeof(b)) != 1))
+		perror("Failed to send single byte");
+
+	r = getsockopt(client_fd, SOL_TCP, TCP_INFO, &info, &optlen);
+	if (CHECK_FAIL(r < 0))
+		goto err;
+
+	ASSERT_EQ(TCPI_SND_WND(info), tcpi_snd_wnd_on_recv,
+		  "getsockopt(TCP_INFO.tcpi_snd_wnd) after recv");
+
+	ASSERT_LE(tcpi_snd_wnd_on_connect, tcpi_snd_wnd_on_recv,
+		  "snd_wnd_on_connect > snd_wnd_on_recv");
+
+err:
+	if (sd != -1)
+		close(sd);
+	if (client_fd != -1)
+		close(client_fd);
+}
+
+static int socket_client(int server_fd)
+{
+	socklen_t optlen;
+	int family, type, protocol, r;
+
+	optlen = sizeof(family);
+	r = getsockopt(server_fd, SOL_SOCKET, SO_DOMAIN, &family, &optlen);
+	if (CHECK_FAIL(r < 0))
+		return -1;
+
+	optlen = sizeof(type);
+	r = getsockopt(server_fd, SOL_SOCKET, SO_TYPE, &type, &optlen);
+	if (CHECK_FAIL(r < 0))
+		return -1;
+
+	optlen = sizeof(protocol);
+	r = getsockopt(server_fd, SOL_SOCKET, SO_PROTOCOL, &protocol, &optlen);
+	if (CHECK_FAIL(r < 0))
+		return -1;
+
+	return socket(family, type, protocol);
+}
+
+static void do_test_client(int server_fd, struct test_tcp_initrwnd *skel,
+			   int initrwnd, unsigned int rcv_ssthresh,
+			   unsigned int tcpi_snd_wnd)
+{
+	int client_fd = -1, sd = -1, r, maxseg;
+	__u32 info[256 / 4];
+	socklen_t optlen = sizeof(info);
+	size_t rcvbuf;
+
+	fprintf(stderr, "[*] client initrwnd=%d\n", initrwnd);
+
+	skel->bss->initrwnd = initrwnd; // in full MSS packets
+
+	client_fd = socket_client(server_fd);
+	if (CHECK_FAIL(client_fd < 0))
+		goto err;
+
+	/* With MSS=64KiB on loopback it's hard to argue about init
+	 * rwnd. Let's set MSS to something that will make our life
+	 * easier, like 1024 + timestamps.
+	 */
+	maxseg = 1024;
+
+	r = setsockopt(client_fd, SOL_TCP, TCP_MAXSEG, &maxseg, sizeof(maxseg));
+	if (CHECK_FAIL(r < 0))
+		goto err;
+
+	rcvbuf = 208 * 1024;
+	r = setsockopt(client_fd, SOL_SOCKET, SO_RCVBUF, &rcvbuf,
+		       sizeof(rcvbuf));
+	if (CHECK_FAIL(r < 0))
+		goto err;
+
+	r = connect_fd_to_fd(client_fd, server_fd, 0);
+	if (CHECK_FAIL(r < 0))
+		goto err;
+
+	sd = accept(server_fd, NULL, NULL);
+	if (CHECK_FAIL(sd < 0))
+		goto err;
+
+	/* There is only one moment to check - the server should know
+	 * about client window just after accept. First check client
+	 * rcv_ssthresh for sanity.
+	 */
+	r = getsockopt(client_fd, SOL_TCP, TCP_INFO, &info, &optlen);
+	if (CHECK_FAIL(r < 0))
+		goto err;
+
+	ASSERT_EQ(TCPI_RCV_SSTHRESH(info), rcv_ssthresh,
+		  "getsockopt(TCP_INFO.tcpi_rcv_ssthresh) on client");
+
+	/* And the recevie window size as seen from the server.
+	 */
+	r = getsockopt(sd, SOL_TCP, TCP_INFO, &info, &optlen);
+	if (CHECK_FAIL(r < 0))
+		goto err;
+
+	ASSERT_EQ(TCPI_SND_WND(info), tcpi_snd_wnd,
+		  "getsockopt(TCP_INFO.tcpi_snd_wnd)");
+
+	ASSERT_GE(rcv_ssthresh, tcpi_snd_wnd, "rcv_ssthresh < tcpi_snd_wnd");
+err:
+	if (sd != -1)
+		close(sd);
+	if (client_fd != -1)
+		close(client_fd);
+}
+
+static void run_tests(int cg_fd, struct test_tcp_initrwnd *skel)
+{
+	int server_fd = -1, r, rcvbuf, maxseg;
+	unsigned int max_wnd, buf;
+
+	skel->links.bpf_testcb =
+		bpf_program__attach_cgroup(skel->progs.bpf_testcb, cg_fd);
+	if (!ASSERT_OK_PTR(skel->links.bpf_testcb, "attach_cgroup(bpf_testcb)"))
+		goto err;
+
+	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
+	if (CHECK_FAIL(server_fd < 0))
+		goto err;
+
+	maxseg = 1024;
+	if (tcp_timestamps)
+		maxseg += 12;
+
+	/* With MSS=64KiB on loopback it's hard to argue about init
+	 * rwnd. Let's set MSS to something that will make our life
+	 * easier, like 1024 + timestamps.
+	 */
+	r = setsockopt(server_fd, SOL_TCP, TCP_MAXSEG, &maxseg, sizeof(maxseg));
+	if (CHECK_FAIL(r < 0))
+		goto err;
+
+	/* Obviously, rcvbuffer must be large at the start for the
+	 * initrwnd to make any dent in rcv_ssthresh (assuming default
+	 * tcp_rmem of 128KiB)
+	 */
+	rcvbuf = 208 * 1024;
+	r = setsockopt(server_fd, SOL_SOCKET, SO_RCVBUF, &rcvbuf,
+		       sizeof(rcvbuf));
+	if (CHECK_FAIL(r < 0))
+		goto err;
+
+	max_wnd = tcp_workaround_signed_windows ? 32767 : 65535;
+
+	/* [*] server advertising large window ** */
+	fprintf(stderr,
+		"[#] server timestamps=%d window_scaling=%d workaround_signed_windows=%d syncookies=%d\n",
+		tcp_timestamps, tcp_window_scaling,
+		tcp_workaround_signed_windows, tcp_syncookies);
+
+	/* Small initrwnd. Not exceeding 64KiB */
+	do_test_server(server_fd, skel, 1, 1024, 1024, 1024);
+
+	if (tcp_window_scaling) {
+		/* Borderline. Not exceeding 64KiB */
+		do_test_server(server_fd, skel, 63, MIN(max_wnd, 63 * 1024),
+			       63 * 1024, 63 * 1024);
+	} else {
+		do_test_server(server_fd, skel, 63, MIN(max_wnd, 63 * 1024),
+			       63 * 1024, MIN(max_wnd, 63 * 1024));
+	}
+
+	if (tcp_window_scaling) {
+		/* The interesting case. Crossing 64KiB */
+		do_test_server(server_fd, skel, 128, max_wnd, 128 * 1024,
+			       128 * 1024);
+	} else {
+		do_test_server(server_fd, skel, 128, max_wnd, 65535, max_wnd);
+	}
+
+	if (tcp_window_scaling) {
+		/* Super large. Remember the rcv buffer is 208*2 */
+		do_test_server(server_fd, skel, 206, max_wnd, 206 * 1024,
+			       206 * 1024);
+
+		/* Not sure why, but here you go, subtract 12 if timestamps */
+		buf = 207 * 1024U - (tcp_timestamps ? 12 : 0);
+		do_test_server(server_fd, skel, 512, max_wnd, buf, buf);
+	}
+
+	/* [*] client advertising large window ** */
+	fprintf(stderr,
+		"[#] client timestamps=%d window_scaling=%d workaround_signed_windows=%d syncookies=%d\n",
+		tcp_timestamps, tcp_window_scaling,
+		tcp_workaround_signed_windows, tcp_syncookies);
+
+	/* Ensure server mss is not 1024 not to be confusing */
+	maxseg = 32767;
+	r = setsockopt(server_fd, SOL_TCP, TCP_MAXSEG, &maxseg, sizeof(maxseg));
+	if (CHECK_FAIL(r < 0))
+		goto err;
+
+	/* Test if client advertises small rcv window */
+	do_test_client(server_fd, skel, 1, 1024, 1024);
+
+	if (tcp_window_scaling) {
+		/* Medium size */
+		do_test_client(server_fd, skel, 63, 63 * 1024, 63 * 1024);
+	} else {
+		do_test_client(server_fd, skel, 63, 63 * 1024,
+			       MIN(max_wnd, 63 * 1024));
+	}
+
+	if (tcp_window_scaling) {
+		/* And large window */
+		do_test_client(server_fd, skel, 128, 128 * 1024, 128 * 1024);
+	} else {
+		do_test_client(server_fd, skel, 128, 65535, max_wnd);
+	}
+
+	if (tcp_window_scaling) {
+		/* Super large. */
+		do_test_client(server_fd, skel, 206, 206 * 1024U, 206 * 1024U);
+
+		/* Not sure why, but here you go, subtract 12 if timestamps */
+		buf = 207 * 1024U + (tcp_timestamps ? 12 : 0);
+		do_test_client(server_fd, skel, 512, buf, buf);
+	}
+err:
+	if (server_fd != -1)
+		close(server_fd);
+}
+
+#define PROC_TCP_TIMESTAMPS "/proc/sys/net/ipv4/tcp_timestamps"
+#define PROC_TCP_WINDOW_SCALING "/proc/sys/net/ipv4/tcp_window_scaling"
+#define PROC_TCP_WORKAROUND_SIGNED_WINDOWS \
+	"/proc/sys/net/ipv4/tcp_workaround_signed_windows"
+#define PROC_TCP_SYNCOOKIES "/proc/sys/net/ipv4/tcp_syncookies"
+
+void test_tcp_initrwnd(void)
+{
+	struct test_tcp_initrwnd *skel;
+	unsigned int i;
+	int cg_fd;
+
+	int saved_tcp_timestamps = read_int_sysctl(PROC_TCP_TIMESTAMPS);
+	int saved_tcp_window_scaling = read_int_sysctl(PROC_TCP_WINDOW_SCALING);
+	int saved_tcp_workaround_signed_windows =
+		read_int_sysctl(PROC_TCP_WORKAROUND_SIGNED_WINDOWS);
+	int saved_tcp_syncookies = read_int_sysctl(PROC_TCP_SYNCOOKIES);
+
+	if (CHECK_FAIL(saved_tcp_timestamps == -1 ||
+		       saved_tcp_window_scaling == -1 ||
+		       saved_tcp_workaround_signed_windows == -1 ||
+		       saved_tcp_syncookies == -1))
+		return;
+
+	cg_fd = test__join_cgroup(CG_NAME);
+	if (CHECK_FAIL(cg_fd < 0))
+		return;
+
+	skel = test_tcp_initrwnd__open_and_load();
+	if (CHECK_FAIL(!skel)) {
+		close(cg_fd);
+		return;
+	}
+
+	// syn cookies testing disabled
+	for (i = 0; i < 8; i++) {
+		tcp_timestamps = !!(i & 0x1);
+		tcp_window_scaling = !!(i & 0x2);
+		tcp_workaround_signed_windows = !!(i & 0x4);
+		tcp_syncookies = (i & 0x8) ? 2 : 0;
+
+		write_int_sysctl(PROC_TCP_TIMESTAMPS, tcp_timestamps);
+		write_int_sysctl(PROC_TCP_WINDOW_SCALING, tcp_window_scaling);
+		write_int_sysctl(PROC_TCP_WORKAROUND_SIGNED_WINDOWS,
+				 tcp_workaround_signed_windows);
+		write_int_sysctl(PROC_TCP_SYNCOOKIES, tcp_syncookies);
+
+		// Without tcp timestamps syncookies can't do wscale
+		if (tcp_syncookies && tcp_timestamps == 0)
+			tcp_window_scaling = 0;
+
+		run_tests(cg_fd, skel);
+	}
+
+	write_int_sysctl(PROC_TCP_TIMESTAMPS, saved_tcp_timestamps);
+	write_int_sysctl(PROC_TCP_WINDOW_SCALING, saved_tcp_window_scaling);
+	write_int_sysctl(PROC_TCP_WORKAROUND_SIGNED_WINDOWS,
+			 saved_tcp_workaround_signed_windows);
+	write_int_sysctl(PROC_TCP_SYNCOOKIES, saved_tcp_syncookies);
+
+	test_tcp_initrwnd__destroy(skel);
+
+	close(cg_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_tcp_initrwnd.c b/tools/testing/selftests/bpf/progs/test_tcp_initrwnd.c
new file mode 100644
index 000000000000..d532e9e2d344
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_tcp_initrwnd.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright (c) 2022 Cloudflare
+
+#include <linux/bpf.h>
+
+#include <bpf/bpf_helpers.h>
+
+int initrwnd;
+
+SEC("sockops")
+int bpf_testcb(struct bpf_sock_ops *skops)
+{
+	int rv = -1;
+	int op;
+
+	op = (int)skops->op;
+
+	switch (op) {
+	case BPF_SOCK_OPS_RWND_INIT:
+		rv = initrwnd;
+		break;
+
+	default:
+		rv = -1;
+	}
+	skops->reply = rv;
+	return 1;
+}
+
+char _license[] SEC("license") = "Dual BSD/GPL";
-- 
2.25.1

