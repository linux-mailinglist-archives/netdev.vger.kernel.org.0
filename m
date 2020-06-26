Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3026120B7B2
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgFZR41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:56:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58076 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726616AbgFZR41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:56:27 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QHu8Cc021451
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:56:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=hrIyz0/OEpgT9B5hqkQ+Scc8c6Wp8lbfV/CtupXCLy0=;
 b=Ww7h1k6QmZQss+7kOZOIbCGAn9rdN4a22OdCGFfrwtipgqV2YkBsuSy80qlj2iCFMSS2
 0YInafJ+6AaDxn1d24G18yRIfC8saWaLLGw7LAG4UsLf7K0pcEKkmmw0ptb5Va9UohWx
 rIFoYT/UN0w6DsekubMYnsD7ag90iSITTMo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31wh6ksfak-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:56:25 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 10:55:37 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 396472942E38; Fri, 26 Jun 2020 10:55:33 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 05/10] bpf: selftests: A few improvements to network_helpers.c
Date:   Fri, 26 Jun 2020 10:55:33 -0700
Message-ID: <20200626175533.1461548-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200626175501.1459961-1-kafai@fb.com>
References: <20200626175501.1459961-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_10:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=15
 cotscore=-2147483648 adultscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 mlxscore=0 clxscore=1015 spamscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes a few changes to the network_helpers.c

1) Enforce SO_RCVTIMEO and SO_SNDTIMEO
   This patch enforces timeout to the network fds through setsockopt
   SO_RCVTIMEO and SO_SNDTIMEO.

   It will remove the need for SOCK_NONBLOCK that requires a more demandi=
ng
   timeout logic with epoll/select, e.g. epoll_create, epoll_ctrl, and
   then epoll_wait for timeout.

   That removes the need for connect_wait() from the
   cgroup_skb_sk_lookup.c. The needed change is made in
   cgroup_skb_sk_lookup.c.

2) start_server():
   Add optional addr_str and port to start_server().
   That removes the need of the start_server_with_port().  The caller
   can pass addr_str=3D=3DNULL and/or port=3D=3D0.

   "int timeout_ms" is also added.

3) connect_to_fd(): Fully use the server_fd.
   The server sock address has already been obtained from
   getsockname(server_fd).  The sockaddr includes the family,
   so the "int family" arg is redundant.

   Since the server address is obtained from server_fd,  there
   is little reason not to get the server's socket type from the
   server_fd also.  getsockopt(server_fd) can be used to do that,
   so "int type" arg is also removed.

   "int timeout_ms" is added.

4) connect_fd_to_fd():
   "int timeout_ms" is added.
   Some code is also refactored to connect_fd_to_addr() which is
   shared with connect_to_fd().

5) Preserve errno:
   Some callers need to check errno, e.g. cgroup_skb_sk_lookup.c.
   Make changes to do it more consistently in save_errno_close()
   and log_err().

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/network_helpers.c | 157 +++++++++++-------
 tools/testing/selftests/bpf/network_helpers.h |   9 +-
 .../bpf/prog_tests/cgroup_skb_sk_lookup.c     |  12 +-
 .../bpf/prog_tests/connect_force_port.c       |  10 +-
 .../bpf/prog_tests/load_bytes_relative.c      |   4 +-
 .../selftests/bpf/prog_tests/tcp_rtt.c        |   4 +-
 6 files changed, 110 insertions(+), 86 deletions(-)

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testin=
g/selftests/bpf/network_helpers.c
index e36dd1a1780d..1a371d3eca7d 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -7,8 +7,6 @@
=20
 #include <arpa/inet.h>
=20
-#include <sys/epoll.h>
-
 #include <linux/err.h>
 #include <linux/in.h>
 #include <linux/in6.h>
@@ -17,8 +15,13 @@
 #include "network_helpers.h"
=20
 #define clean_errno() (errno =3D=3D 0 ? "None" : strerror(errno))
-#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n"=
, \
-	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)
+#define log_err(MSG, ...) ({						\
+			int save =3D errno;				\
+			fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
+				__FILE__, __LINE__, clean_errno(),	\
+				##__VA_ARGS__);				\
+			errno =3D save;					\
+})
=20
 struct ipv4_packet pkt_v4 =3D {
 	.eth.h_proto =3D __bpf_constant_htons(ETH_P_IP),
@@ -37,7 +40,34 @@ struct ipv6_packet pkt_v6 =3D {
 	.tcp.doff =3D 5,
 };
=20
-int start_server_with_port(int family, int type, __u16 port)
+static int settimeo(int fd, int timeout_ms)
+{
+	struct timeval timeout =3D { .tv_sec =3D 3 };
+
+	if (timeout_ms > 0) {
+		timeout.tv_sec =3D timeout_ms / 1000;
+		timeout.tv_usec =3D (timeout_ms % 1000) * 1000;
+	}
+
+	if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeout,
+		       sizeof(timeout))) {
+		log_err("Failed to set SO_RCVTIMEO");
+		return -1;
+	}
+
+	if (setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeout,
+		       sizeof(timeout))) {
+		log_err("Failed to set SO_SNDTIMEO");
+		return -1;
+	}
+
+	return 0;
+}
+
+#define save_errno_close(fd) ({ int save =3D errno; close(fd); errno =3D=
 save; })
+
+int start_server(int family, int type, const char *addr_str, __u16 port,
+		 int timeout_ms)
 {
 	struct sockaddr_storage addr =3D {};
 	socklen_t len;
@@ -48,120 +78,119 @@ int start_server_with_port(int family, int type, __=
u16 port)
=20
 		sin->sin_family =3D AF_INET;
 		sin->sin_port =3D htons(port);
+		if (addr_str &&
+		    inet_pton(AF_INET, addr_str, &sin->sin_addr) !=3D 1) {
+			log_err("inet_pton(AF_INET, %s)", addr_str);
+			return -1;
+		}
 		len =3D sizeof(*sin);
 	} else {
 		struct sockaddr_in6 *sin6 =3D (void *)&addr;
=20
 		sin6->sin6_family =3D AF_INET6;
 		sin6->sin6_port =3D htons(port);
+		if (addr_str &&
+		    inet_pton(AF_INET6, addr_str, &sin6->sin6_addr) !=3D 1) {
+			log_err("inet_pton(AF_INET6, %s)", addr_str);
+			return -1;
+		}
 		len =3D sizeof(*sin6);
 	}
=20
-	fd =3D socket(family, type | SOCK_NONBLOCK, 0);
+	fd =3D socket(family, type, 0);
 	if (fd < 0) {
 		log_err("Failed to create server socket");
 		return -1;
 	}
=20
+	if (settimeo(fd, timeout_ms))
+		goto error_close;
+
 	if (bind(fd, (const struct sockaddr *)&addr, len) < 0) {
 		log_err("Failed to bind socket");
-		close(fd);
-		return -1;
+		goto error_close;
 	}
=20
 	if (type =3D=3D SOCK_STREAM) {
 		if (listen(fd, 1) < 0) {
 			log_err("Failed to listed on socket");
-			close(fd);
-			return -1;
+			goto error_close;
 		}
 	}
=20
 	return fd;
-}
=20
-int start_server(int family, int type)
-{
-	return start_server_with_port(family, type, 0);
+error_close:
+	save_errno_close(fd);
+	return -1;
 }
=20
-static const struct timeval timeo_sec =3D { .tv_sec =3D 3 };
-static const size_t timeo_optlen =3D sizeof(timeo_sec);
-
-int connect_to_fd(int family, int type, int server_fd)
+static int connect_fd_to_addr(int fd,
+			      const struct sockaddr_storage *addr,
+			      socklen_t addrlen)
 {
-	int fd, save_errno;
-
-	fd =3D socket(family, type, 0);
-	if (fd < 0) {
-		log_err("Failed to create client socket");
+	if (connect(fd, (const struct sockaddr *)addr, addrlen)) {
+		log_err("Failed to connect to server");
 		return -1;
 	}
=20
-	if (connect_fd_to_fd(fd, server_fd) < 0 && errno !=3D EINPROGRESS) {
-		save_errno =3D errno;
-		close(fd);
-		errno =3D save_errno;
-		return -1;
-	}
-
-	return fd;
+	return 0;
 }
=20
-int connect_fd_to_fd(int client_fd, int server_fd)
+int connect_to_fd(int server_fd, int timeout_ms)
 {
 	struct sockaddr_storage addr;
-	socklen_t len =3D sizeof(addr);
-	int save_errno;
+	struct sockaddr_in *addr_in;
+	socklen_t addrlen, optlen;
+	int fd, type;
=20
-	if (setsockopt(client_fd, SOL_SOCKET, SO_RCVTIMEO, &timeo_sec,
-		       timeo_optlen)) {
-		log_err("Failed to set SO_RCVTIMEO");
+	optlen =3D sizeof(type);
+	if (getsockopt(server_fd, SOL_SOCKET, SO_TYPE, &type, &optlen)) {
+		log_err("getsockopt(SOL_TYPE)");
 		return -1;
 	}
=20
-	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
+	addrlen =3D sizeof(addr);
+	if (getsockname(server_fd, (struct sockaddr *)&addr, &addrlen)) {
 		log_err("Failed to get server addr");
 		return -1;
 	}
=20
-	if (connect(client_fd, (const struct sockaddr *)&addr, len) < 0) {
-		if (errno !=3D EINPROGRESS) {
-			save_errno =3D errno;
-			log_err("Failed to connect to server");
-			errno =3D save_errno;
-		}
+	addr_in =3D (struct sockaddr_in *)&addr;
+	fd =3D socket(addr_in->sin_family, type, 0);
+	if (fd < 0) {
+		log_err("Failed to create client socket");
 		return -1;
 	}
=20
-	return 0;
+	if (settimeo(fd, timeout_ms))
+		goto error_close;
+
+	if (connect_fd_to_addr(fd, &addr, addrlen))
+		goto error_close;
+
+	return fd;
+
+error_close:
+	save_errno_close(fd);
+	return -1;
 }
=20
-int connect_wait(int fd)
+int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms)
 {
-	struct epoll_event ev =3D {}, events[2];
-	int timeout_ms =3D 1000;
-	int efd, nfd;
+	struct sockaddr_storage addr;
+	socklen_t len =3D sizeof(addr);
=20
-	efd =3D epoll_create1(EPOLL_CLOEXEC);
-	if (efd < 0) {
-		log_err("Failed to open epoll fd");
+	if (settimeo(client_fd, timeout_ms))
 		return -1;
-	}
-
-	ev.events =3D EPOLLRDHUP | EPOLLOUT;
-	ev.data.fd =3D fd;
=20
-	if (epoll_ctl(efd, EPOLL_CTL_ADD, fd, &ev) < 0) {
-		log_err("Failed to register fd=3D%d on epoll fd=3D%d", fd, efd);
-		close(efd);
+	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
+		log_err("Failed to get server addr");
 		return -1;
 	}
=20
-	nfd =3D epoll_wait(efd, events, ARRAY_SIZE(events), timeout_ms);
-	if (nfd < 0)
-		log_err("Failed to wait for I/O event on epoll fd=3D%d", efd);
+	if (connect_fd_to_addr(client_fd, &addr, len))
+		return -1;
=20
-	close(efd);
-	return nfd;
+	return 0;
 }
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testin=
g/selftests/bpf/network_helpers.h
index 6a8009605670..f580e82fda58 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -33,10 +33,9 @@ struct ipv6_packet {
 } __packed;
 extern struct ipv6_packet pkt_v6;
=20
-int start_server(int family, int type);
-int start_server_with_port(int family, int type, __u16 port);
-int connect_to_fd(int family, int type, int server_fd);
-int connect_fd_to_fd(int client_fd, int server_fd);
-int connect_wait(int client_fd);
+int start_server(int family, int type, const char *addr, __u16 port,
+		 int timeout_ms);
+int connect_to_fd(int server_fd, int timeout_ms);
+int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms);
=20
 #endif
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_skb_sk_lookup.=
c b/tools/testing/selftests/bpf/prog_tests/cgroup_skb_sk_lookup.c
index 059047af7df3..464edc1c1708 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_skb_sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_skb_sk_lookup.c
@@ -13,7 +13,7 @@ static void run_lookup_test(__u16 *g_serv_port, int out=
_sk)
 	socklen_t addr_len =3D sizeof(addr);
 	__u32 duration =3D 0;
=20
-	serv_sk =3D start_server(AF_INET6, SOCK_STREAM);
+	serv_sk =3D start_server(AF_INET6, SOCK_STREAM, NULL, 0, 0);
 	if (CHECK(serv_sk < 0, "start_server", "failed to start server\n"))
 		return;
=20
@@ -24,17 +24,13 @@ static void run_lookup_test(__u16 *g_serv_port, int o=
ut_sk)
 	*g_serv_port =3D addr.sin6_port;
=20
 	/* Client outside of test cgroup should fail to connect by timeout. */
-	err =3D connect_fd_to_fd(out_sk, serv_sk);
+	err =3D connect_fd_to_fd(out_sk, serv_sk, 1000);
 	if (CHECK(!err || errno !=3D EINPROGRESS, "connect_fd_to_fd",
 		  "unexpected result err %d errno %d\n", err, errno))
 		goto cleanup;
=20
-	err =3D connect_wait(out_sk);
-	if (CHECK(err, "connect_wait", "unexpected result %d\n", err))
-		goto cleanup;
-
 	/* Client inside test cgroup should connect just fine. */
-	in_sk =3D connect_to_fd(AF_INET6, SOCK_STREAM, serv_sk);
+	in_sk =3D connect_to_fd(serv_sk, 0);
 	if (CHECK(in_sk < 0, "connect_to_fd", "errno %d\n", errno))
 		goto cleanup;
=20
@@ -85,7 +81,7 @@ void test_cgroup_skb_sk_lookup(void)
 	 * differs from that of testing cgroup. Moving selftests process to
 	 * testing cgroup won't change cgroup id of an already created socket.
 	 */
-	out_sk =3D socket(AF_INET6, SOCK_STREAM | SOCK_NONBLOCK, 0);
+	out_sk =3D socket(AF_INET6, SOCK_STREAM, 0);
 	if (CHECK_FAIL(out_sk < 0))
 		return;
=20
diff --git a/tools/testing/selftests/bpf/prog_tests/connect_force_port.c =
b/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
index 17bbf76812ca..9229db2f5ca5 100644
--- a/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
+++ b/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
@@ -114,7 +114,7 @@ static int run_test(int cgroup_fd, int server_fd, int=
 family, int type)
 		goto close_bpf_object;
 	}
=20
-	fd =3D connect_to_fd(family, type, server_fd);
+	fd =3D connect_to_fd(server_fd, 0);
 	if (fd < 0) {
 		err =3D -1;
 		goto close_bpf_object;
@@ -137,25 +137,25 @@ void test_connect_force_port(void)
 	if (CHECK_FAIL(cgroup_fd < 0))
 		return;
=20
-	server_fd =3D start_server_with_port(AF_INET, SOCK_STREAM, 60123);
+	server_fd =3D start_server(AF_INET, SOCK_STREAM, NULL, 60123, 0);
 	if (CHECK_FAIL(server_fd < 0))
 		goto close_cgroup_fd;
 	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET, SOCK_STREAM));
 	close(server_fd);
=20
-	server_fd =3D start_server_with_port(AF_INET6, SOCK_STREAM, 60124);
+	server_fd =3D start_server(AF_INET6, SOCK_STREAM, NULL, 60124, 0);
 	if (CHECK_FAIL(server_fd < 0))
 		goto close_cgroup_fd;
 	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET6, SOCK_STREAM));
 	close(server_fd);
=20
-	server_fd =3D start_server_with_port(AF_INET, SOCK_DGRAM, 60123);
+	server_fd =3D start_server(AF_INET, SOCK_DGRAM, NULL, 60123, 0);
 	if (CHECK_FAIL(server_fd < 0))
 		goto close_cgroup_fd;
 	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET, SOCK_DGRAM));
 	close(server_fd);
=20
-	server_fd =3D start_server_with_port(AF_INET6, SOCK_DGRAM, 60124);
+	server_fd =3D start_server(AF_INET6, SOCK_DGRAM, NULL, 60124, 0);
 	if (CHECK_FAIL(server_fd < 0))
 		goto close_cgroup_fd;
 	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET6, SOCK_DGRAM));
diff --git a/tools/testing/selftests/bpf/prog_tests/load_bytes_relative.c=
 b/tools/testing/selftests/bpf/prog_tests/load_bytes_relative.c
index c1168e4a9036..5a2a689dbb68 100644
--- a/tools/testing/selftests/bpf/prog_tests/load_bytes_relative.c
+++ b/tools/testing/selftests/bpf/prog_tests/load_bytes_relative.c
@@ -23,7 +23,7 @@ void test_load_bytes_relative(void)
 	if (CHECK_FAIL(cgroup_fd < 0))
 		return;
=20
-	server_fd =3D start_server(AF_INET, SOCK_STREAM);
+	server_fd =3D start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
 	if (CHECK_FAIL(server_fd < 0))
 		goto close_cgroup_fd;
=20
@@ -49,7 +49,7 @@ void test_load_bytes_relative(void)
 	if (CHECK_FAIL(err))
 		goto close_bpf_object;
=20
-	client_fd =3D connect_to_fd(AF_INET, SOCK_STREAM, server_fd);
+	client_fd =3D connect_to_fd(server_fd, 0);
 	if (CHECK_FAIL(client_fd < 0))
 		goto close_bpf_object;
 	close(client_fd);
diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/tes=
ting/selftests/bpf/prog_tests/tcp_rtt.c
index 9013a0c01eed..d207e968e6b1 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
@@ -118,7 +118,7 @@ static int run_test(int cgroup_fd, int server_fd)
 		goto close_bpf_object;
 	}
=20
-	client_fd =3D connect_to_fd(AF_INET, SOCK_STREAM, server_fd);
+	client_fd =3D connect_to_fd(server_fd, 0);
 	if (client_fd < 0) {
 		err =3D -1;
 		goto close_bpf_object;
@@ -161,7 +161,7 @@ void test_tcp_rtt(void)
 	if (CHECK_FAIL(cgroup_fd < 0))
 		return;
=20
-	server_fd =3D start_server(AF_INET, SOCK_STREAM);
+	server_fd =3D start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
 	if (CHECK_FAIL(server_fd < 0))
 		goto close_cgroup_fd;
=20
--=20
2.24.1

