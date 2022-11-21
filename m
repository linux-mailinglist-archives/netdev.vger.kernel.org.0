Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD64632CC4
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiKUTPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiKUTPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:15:13 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A128F63148
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:15:11 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 991941B81312; Mon, 21 Nov 2022 11:15:00 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        ammarfaizi2@gnuweeb.org
Subject: [PATCH v5 3/4] liburing: add example programs for napi busy poll
Date:   Mon, 21 Nov 2022 11:14:58 -0800
Message-Id: <20221121191459.998388-4-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121191459.998388-1-shr@devkernel.io>
References: <20221121191459.998388-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds two example programs to test the napi busy poll functionality.
It consists of a client program and a server program. To get a napi id,
the client and the server program need to be run on different hosts.

To test the napi busy poll timeout, the -t needs to be specified. A
reasonable value for the busy poll timeout is 100. By specifying the
busy poll timeout on the server and the client the best results are
accomplished.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 .gitignore                       |   2 +
 examples/Makefile                |   2 +
 examples/napi-busy-poll-client.c | 442 +++++++++++++++++++++++++++++++
 examples/napi-busy-poll-server.c | 386 +++++++++++++++++++++++++++
 4 files changed, 832 insertions(+)
 create mode 100644 examples/napi-busy-poll-client.c
 create mode 100644 examples/napi-busy-poll-server.c

diff --git a/.gitignore b/.gitignore
index 6e8a2f7..89b5a41 100644
--- a/.gitignore
+++ b/.gitignore
@@ -15,6 +15,8 @@
 /examples/io_uring-test
 /examples/io_uring-udp
 /examples/link-cp
+/examples/napi-busy-poll-client
+/examples/napi-busy-poll-server
 /examples/ucontext-cp
 /examples/poll-bench
 /examples/send-zerocopy
diff --git a/examples/Makefile b/examples/Makefile
index e561e05..59f1260 100644
--- a/examples/Makefile
+++ b/examples/Makefile
@@ -15,6 +15,8 @@ example_srcs :=3D \
 	io_uring-test.c \
 	io_uring-udp.c \
 	link-cp.c \
+	napi-busy-poll-client.c \
+	napi-busy-poll-server.c \
 	poll-bench.c \
 	send-zerocopy.c
=20
diff --git a/examples/napi-busy-poll-client.c b/examples/napi-busy-poll-c=
lient.c
new file mode 100644
index 0000000..9b2e543
--- /dev/null
+++ b/examples/napi-busy-poll-client.c
@@ -0,0 +1,442 @@
+#include <ctype.h>
+#include <errno.h>
+#include <float.h>
+#include <getopt.h>
+#include <liburing.h>
+#include <math.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <time.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include <netdb.h>
+#include <netinet/in.h>
+
+#define MAXBUFLEN 100
+#define PORTNOLEN 10
+#define ADDRLEN   80
+#define RINGSIZE  1024
+
+#define printable(ch) (isprint((unsigned char)ch) ? ch : '#')
+
+enum {
+	IOURING_RECV,
+	IOURING_SEND,
+	IOURING_RECVMSG,
+	IOURING_SENDMSG
+};
+
+struct ctx
+{
+	struct io_uring ring;
+	struct sockaddr_in6 saddr;
+
+	int sockfd;
+	int buffer_len;
+	int num_pings;
+	bool napi_check;
+
+	union {
+		char buffer[MAXBUFLEN];
+		struct timespec ts;
+	};
+
+	int rtt_index;
+	double *rtt;
+} ctx;
+
+struct options
+{
+	int  num_pings;
+	int  timeout;
+
+	bool sq_poll;
+	bool busy_loop;
+	bool prefer_busy_poll;
+
+	char port[PORTNOLEN];
+	char addr[ADDRLEN];
+} options;
+
+struct option longopts[] =3D
+{
+	{"address"  , 1, NULL, 'a'},
+	{"busy"     , 0, NULL, 'b'},
+	{"help"     , 0, NULL, 'h'},
+	{"num_pings", 1, NULL, 'n'},
+	{"port"     , 1, NULL, 'p'},
+	{"prefer"   , 1, NULL, 'u'},
+	{"sqpoll"   , 0, NULL, 's'},
+	{"timeout"  , 1, NULL, 't'},
+	{NULL       , 0, NULL,  0 }
+};
+
+void printUsage(const char *name)
+{
+	fprintf(stderr,
+	"Usage: %s [-l|--listen] [-a|--address ip_address] [-p|--port port-no] =
[-s|--sqpoll]"
+	" [-b|--busy] [-n|--num pings] [-t|--timeout busy-poll-timeout] [-u||--=
prefer] [-h|--help]\n"
+	"--address\n"
+	"-a        : remote or local ipv6 address\n"
+	"--busy\n"
+	"-b        : busy poll io_uring instead of blocking.\n"
+	"--num_pings\n"
+	"-n        : number of pings\n"
+	"--port\n"
+	"-p        : port\n"
+	"--sqpoll\n"
+	"-s        : Configure io_uring to use SQPOLL thread\n"
+	"--timeout\n"
+	"-t        : Configure NAPI busy poll timeoutn"
+	"--prefer\n"
+	"-u        : prefer NAPI busy poll\n"
+	"--help\n"
+	"-h        : Display this usage message\n\n",
+	name);
+}
+
+void printError(const char *msg, int opt)
+{
+	if (msg && opt)
+		fprintf(stderr, "%s (-%c)\n", msg, printable(opt));
+}
+
+void setProcessScheduler(void)
+{
+	struct sched_param param;
+
+	param.sched_priority =3D sched_get_priority_max(SCHED_FIFO);
+	if (sched_setscheduler(0, SCHED_FIFO, &param) < 0)
+		fprintf(stderr, "sched_setscheduler() failed: (%d) %s\n",
+			errno, strerror(errno));
+}
+
+double diffTimespec(const struct timespec *time1, const struct timespec =
*time0)
+{
+	return (time1->tv_sec - time0->tv_sec)
+		+ (time1->tv_nsec - time0->tv_nsec) / 1000000000.0;
+}
+
+uint64_t encodeUserData(char type, int fd)
+{
+	return (uint32_t)fd | ((uint64_t)type << 56);
+}
+
+void decodeUserData(uint64_t data, char *type, int *fd)
+{
+	*type =3D data >> 56;
+	*fd   =3D data & 0xffffffffU;
+}
+
+const char *opTypeToStr(char type)
+{
+	const char *res;
+
+	switch (type) {
+	case IOURING_RECV:
+		res =3D "IOURING_RECV";
+		break;
+	case IOURING_SEND:
+		res =3D "IOURING_SEND";
+		break;
+	case IOURING_RECVMSG:
+		res =3D "IOURING_RECVMSG";
+		break;
+	case IOURING_SENDMSG:
+		res =3D "IOURING_SENDMSG";
+		break;
+	default:
+		res =3D "Unknown";
+	}
+
+	return res;
+}
+
+void reportNapi(struct ctx *ctx)
+{
+	unsigned int napi_id =3D 0;
+	socklen_t len =3D sizeof(napi_id);
+
+	getsockopt(ctx->sockfd, SOL_SOCKET, SO_INCOMING_NAPI_ID, &napi_id, &len=
);
+	if (napi_id)
+		printf(" napi id: %d\n", napi_id);
+	else
+		printf(" unassigned napi id\n");
+
+	ctx->napi_check =3D true;
+}
+
+void sendPing(struct ctx *ctx)
+{
+	struct io_uring_sqe *sqe =3D io_uring_get_sqe(&ctx->ring);
+
+	clock_gettime(CLOCK_REALTIME, (struct timespec *)ctx->buffer);
+
+	io_uring_prep_send(sqe, ctx->sockfd, ctx->buffer, sizeof(struct timespe=
c), 0);
+	sqe->user_data =3D encodeUserData(IOURING_SEND, ctx->sockfd);
+}
+
+void receivePing(struct ctx *ctx)
+{
+	struct io_uring_sqe *sqe =3D io_uring_get_sqe(&ctx->ring);
+
+	io_uring_prep_recv(sqe, ctx->sockfd, ctx->buffer, MAXBUFLEN, 0);
+	sqe->user_data =3D encodeUserData(IOURING_RECV, ctx->sockfd);
+}
+
+void recordRTT(struct ctx *ctx)
+{
+	struct timespec startTs =3D ctx->ts;
+
+	// Send next ping.
+	sendPing(ctx);
+
+	// Store round-trip time.
+	ctx->rtt[ctx->rtt_index] =3D diffTimespec(&ctx->ts, &startTs);
+	ctx->rtt_index++;
+}
+
+void printStats(struct ctx *ctx)
+{
+	double minRTT    =3D DBL_MAX;
+	double maxRTT    =3D 0.0;
+	double avgRTT    =3D 0.0;
+	double stddevRTT =3D 0.0;
+
+	// Calculate min, max, avg.
+	for (int i =3D 0; i < ctx->rtt_index; i++) {
+		if (ctx->rtt[i] < minRTT)
+			minRTT =3D ctx->rtt[i];
+		if (ctx->rtt[i] > maxRTT)
+			maxRTT =3D ctx->rtt[i];
+
+        	avgRTT +=3D ctx->rtt[i];
+	}
+	avgRTT /=3D ctx->rtt_index;
+
+	// Calculate stddev.
+	for (int i =3D 0; i < ctx->rtt_index; i++)
+		stddevRTT +=3D fabs(ctx->rtt[i] - avgRTT);
+	stddevRTT /=3D ctx->rtt_index;
+
+	fprintf(stdout, " rtt(us) min/avg/max/mdev =3D %.3f/%.3f/%.3f/%.3f\n",
+		minRTT * 1000000, avgRTT * 1000000, maxRTT * 1000000, stddevRTT * 1000=
000);
+}
+
+int completion(struct ctx *ctx, struct io_uring_cqe *cqe)
+{
+	char type;
+	int  fd;
+	int  res =3D cqe->res;
+
+	decodeUserData(cqe->user_data, &type, &fd);
+	if (res < 0) {
+		fprintf(stderr, "unexpected %s failure: (%d) %s\n",
+			opTypeToStr(type), -res, strerror(-res));
+		return -1;
+	}
+
+	switch (type) {
+	case IOURING_SEND:
+		receivePing(ctx);
+		break;
+	case IOURING_RECV:
+		if (res !=3D sizeof(struct timespec)) {
+			fprintf(stderr, "unexpected ping reply len: %d\n", res);
+			abort();
+		}
+
+		if (!ctx->napi_check) {
+			reportNapi(ctx);
+			sendPing(ctx);
+		} else {
+			recordRTT(ctx);
+		}
+
+		--ctx->num_pings;
+		break;
+
+	default:
+		fprintf(stderr, "unexpected %s completion\n",
+			opTypeToStr(type));
+		return -1;
+		break;
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct ctx       ctx;
+	struct options   opt;
+	struct __kernel_timespec *tsPtr;
+	struct __kernel_timespec ts;
+	struct io_uring_params params;
+	struct io_uring_napi napi;
+	int flag;   =20
+
+	memset(&opt, 0, sizeof(struct options));
+
+	// Process flags.
+	while ((flag =3D getopt_long(argc, argv, ":hsbua:n:p:t:", longopts, NUL=
L)) !=3D -1) {
+		switch (flag) {
+		case 'a':
+			strcpy(opt.addr, optarg);
+			break;
+		case 'b':
+			opt.busy_loop =3D true;
+			break;
+		case 'h':
+			printUsage(argv[0]);
+			exit(0);
+			break;
+		case 'n':
+			opt.num_pings =3D atoi(optarg) + 1;
+			break;
+		case 'p':
+			strcpy(opt.port, optarg);
+			break;
+		case 's':
+                	opt.sq_poll =3D true;
+			break;
+		case 't':
+			opt.timeout =3D atoi(optarg);
+			break;
+		case 'u':
+			opt.prefer_busy_poll =3D true;
+			break;
+		case ':':
+			printError("Missing argument", optopt);
+			printUsage(argv[0]);
+			exit(-1);
+			break;
+		case '?':
+			printError("Unrecognized option", optopt);
+			printUsage(argv[0]);
+			exit(-1);
+			break;
+
+		default:
+			fprintf(stderr, "Fatal: Unexpected case in CmdLineProcessor switch()\=
n");
+			exit(-1);
+			break;
+		}
+	}
+
+	if (strlen(opt.addr) =3D=3D 0) {
+		fprintf(stderr, "address option is mandatory\n");
+		printUsage(argv[0]);
+		exit(1);
+	}
+
+	ctx.saddr.sin6_port   =3D htons(atoi(opt.port));
+	ctx.saddr.sin6_family =3D AF_INET6;
+
+	if (inet_pton(AF_INET6, opt.addr, &ctx.saddr.sin6_addr) <=3D 0) {
+        	fprintf(stderr, "inet_pton error for %s\n", optarg);
+		printUsage(argv[0]);
+		exit(1);
+        }
+
+	// Connect to server.
+	fprintf(stdout, "Connecting to %s... (port=3D%s) to send %d pings\n", o=
pt.addr, opt.port, opt.num_pings - 1);
+
+	if ((ctx.sockfd =3D socket(AF_INET6, SOCK_DGRAM, 0)) < 0) {
+        	fprintf(stderr, "socket() failed: (%d) %s\n", errno, strerror(e=
rrno));
+        	exit(1);
+	}
+
+	if (connect(ctx.sockfd, (struct sockaddr *)&ctx.saddr, sizeof(struct so=
ckaddr_in6)) < 0) {
+		fprintf(stderr, "connect() failed: (%d) %s\n", errno, strerror(errno))=
;
+		exit(1);
+	}
+
+	// Setup ring.
+	memset(&params, 0, sizeof(params));
+	memset(&ts, 0, sizeof(ts));
+	memset(&napi, 0, sizeof(napi));
+
+	if (opt.sq_poll) {
+		params.flags =3D IORING_SETUP_SQPOLL;
+		params.sq_thread_idle =3D 50;
+	}
+
+	if (io_uring_queue_init_params(RINGSIZE, &ctx.ring, &params) < 0) {
+		fprintf(stderr, "io_uring_queue_init_params() failed: (%d) %s\n",
+			errno, strerror(errno));
+		exit(1);
+	}
+
+	if (opt.timeout || opt.prefer_busy_poll) {
+		napi.prefer_busy_poll =3D opt.prefer_busy_poll;
+		napi.busy_poll_to =3D opt.timeout;
+
+		io_uring_register_napi(&ctx.ring, &napi);
+	}
+
+	if (opt.busy_loop)
+		tsPtr =3D &ts;
+	else
+		tsPtr =3D NULL;
+
+	// Use realtime scheduler.
+	setProcessScheduler();
+
+	// Copy payload.
+	clock_gettime(CLOCK_REALTIME, &ctx.ts);
+
+	// Setup context.
+	ctx.napi_check =3D false;
+	ctx.buffer_len =3D sizeof(struct timespec);
+	ctx.num_pings  =3D opt.num_pings;
+
+	ctx.rtt_index =3D 0;
+	ctx.rtt =3D (double *)malloc(sizeof(double) * opt.num_pings);
+	if (!ctx.rtt) {
+		fprintf(stderr, "Cannot allocate results array\n");
+		exit(1);
+	}
+
+	// Send initial message to get napi id.
+	sendPing(&ctx);
+
+        while (ctx.num_pings !=3D 0) {
+		int res;
+		unsigned num_completed =3D 0;
+		unsigned head;
+		struct io_uring_cqe *cqe;
+
+		do {
+			res =3D io_uring_submit_and_wait_timeout(&ctx.ring, &cqe, 1, tsPtr, N=
ULL);
+		}
+		while (res < 0 && errno =3D=3D ETIME);
+
+		io_uring_for_each_cqe(&ctx.ring, head, cqe) {
+			++num_completed;
+			if (completion(&ctx, cqe))
+				goto out;
+		}
+
+		if (num_completed)
+			io_uring_cq_advance(&ctx.ring, num_completed);
+	}
+
+	printStats(&ctx);
+
+out:
+	free(ctx.rtt);
+
+	if (opt.timeout || opt.prefer_busy_poll)
+		io_uring_unregister_napi(&ctx.ring, &napi);
+	io_uring_queue_exit(&ctx.ring);
+
+	// Clean up.
+	close(ctx.sockfd);
+
+	return 0;
+}
diff --git a/examples/napi-busy-poll-server.c b/examples/napi-busy-poll-s=
erver.c
new file mode 100644
index 0000000..1336ba8
--- /dev/null
+++ b/examples/napi-busy-poll-server.c
@@ -0,0 +1,386 @@
+#include <ctype.h>
+#include <errno.h>
+#include <getopt.h>
+#include <liburing.h>
+#include <math.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <time.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include <netdb.h>
+#include <netinet/in.h>
+
+#define MAXBUFLEN 100
+#define PORTNOLEN 10
+#define ADDRLEN   80
+#define RINGSIZE  1024
+
+#define printable(ch) (isprint((unsigned char)ch) ? ch : '#')
+
+enum {
+	IOURING_RECV,
+	IOURING_SEND,
+	IOURING_RECVMSG,
+	IOURING_SENDMSG
+};
+
+struct ctx
+{
+	struct io_uring     ring;
+	struct sockaddr_in6 saddr;
+	struct iovec        iov;
+	struct msghdr       msg;
+
+	int sockfd;
+	int buffer_len;
+	int num_pings;
+	bool napi_check;
+
+	union {
+		char buffer[MAXBUFLEN];
+		struct timespec ts;
+	};
+} ctx;
+
+struct options
+{
+	int  num_pings;
+	int  timeout;
+
+	bool listen;
+	bool sq_poll;
+	bool busy_loop;
+	bool prefer_busy_poll;
+
+	char port[PORTNOLEN];
+	char addr[ADDRLEN];
+} options;
+
+struct option longopts[] =3D
+{
+	{"address"  , 1, NULL, 'a'},
+	{"busy"     , 0, NULL, 'b'},
+	{"help"     , 0, NULL, 'h'},
+	{"listen"   , 0, NULL, 'l'},
+	{"num_pings", 1, NULL, 'n'},
+	{"port"     , 1, NULL, 'p'},
+	{"prefer"   , 1, NULL, 'u'},
+	{"sqpoll"   , 0, NULL, 's'},
+	{"timeout"  , 1, NULL, 't'},
+	{NULL       , 0, NULL,  0 }
+};
+
+void printUsage(const char *name)
+{
+	fprintf(stderr,
+        "Usage: %s [-l|--listen] [-a|--address ip_address] [-p|--port po=
rt-no] [-s|--sqpoll]"
+        " [-b|--busy] [-n|--num pings] [-t|--timeout busy-poll-timeout] =
[-u|--prefer] [-h|--help]\n"
+	" --listen\n"
+	"-l        : Server mode\n"
+        "--address\n"
+        "-a        : remote or local ipv6 address\n"
+        "--busy\n"
+        "-b        : busy poll io_uring instead of blocking.\n"
+        "--num_pings\n"
+        "-n        : number of pings\n"
+        "--port\n"
+        "-p        : port\n"
+        "--sqpoll\n"
+        "-s        : Configure io_uring to use SQPOLL thread\n"
+        "--timeout\n"
+        "-t        : Configure NAPI busy poll timeoutn"
+	"--prefer\n"
+	"-u        : prefer NAPI busy poll\n"
+        "--help\n"
+        "-h        : Display this usage message\n\n",
+	name);
+}
+
+void printError(const char *msg, int opt)
+{
+	if (msg && opt)
+		fprintf(stderr, "%s (-%c)\n", msg, printable(opt));
+}
+
+void setProcessScheduler()
+{
+	struct sched_param param;
+
+	param.sched_priority =3D sched_get_priority_max(SCHED_FIFO);
+	if (sched_setscheduler(0, SCHED_FIFO, &param) < 0)
+		fprintf(stderr, "sched_setscheduler() failed: (%d) %s\n",
+			errno, strerror(errno));
+}
+
+uint64_t encodeUserData(char type, int fd)
+{
+	return (uint32_t)fd | ((__u64)type << 56);
+}
+
+void decodeUserData(uint64_t data, char *type, int *fd)
+{
+	*type =3D data >> 56;
+	*fd   =3D data & 0xffffffffU;
+}
+
+const char *opTypeToStr(char type)
+{
+	const char *res;
+
+	switch (type) {
+	case IOURING_RECV:
+		res =3D "IOURING_RECV";
+		break;
+	case IOURING_SEND:
+		res =3D "IOURING_SEND";
+		break;
+	case IOURING_RECVMSG:
+		res =3D "IOURING_RECVMSG";
+		break;
+	case IOURING_SENDMSG:
+		res =3D "IOURING_SENDMSG";
+		break;
+	default:
+		res =3D "Unknown";
+	}
+
+	return res;
+}
+
+void reportNapi(struct ctx *ctx)
+{
+	unsigned int napi_id =3D 0;
+	socklen_t len =3D sizeof(napi_id);
+
+	getsockopt(ctx->sockfd, SOL_SOCKET, SO_INCOMING_NAPI_ID, &napi_id, &len=
);
+	if (napi_id)
+		printf(" napi id: %d\n", napi_id);
+	else
+		printf(" unassigned napi id\n");
+
+	ctx->napi_check =3D true;
+}
+
+void sendPing(struct ctx *ctx)
+{
+
+	struct io_uring_sqe *sqe =3D io_uring_get_sqe(&ctx->ring);
+
+	io_uring_prep_sendmsg(sqe, ctx->sockfd, &ctx->msg, 0);
+	sqe->user_data =3D encodeUserData(IOURING_SENDMSG, ctx->sockfd);
+}
+
+void receivePing(struct ctx *ctx)
+{
+	bzero(&ctx->msg, sizeof(struct msghdr));
+	ctx->msg.msg_name    =3D &ctx->saddr;
+	ctx->msg.msg_namelen =3D sizeof(struct sockaddr_in6);
+	ctx->iov.iov_base    =3D ctx->buffer;
+	ctx->iov.iov_len     =3D MAXBUFLEN;
+	ctx->msg.msg_iov     =3D &ctx->iov;
+	ctx->msg.msg_iovlen  =3D 1;
+
+	struct io_uring_sqe *sqe =3D io_uring_get_sqe(&ctx->ring);
+	io_uring_prep_recvmsg(sqe, ctx->sockfd, &ctx->msg, 0);
+	sqe->user_data =3D encodeUserData(IOURING_RECVMSG, ctx->sockfd);
+}
+
+void completion(struct ctx *ctx, struct io_uring_cqe *cqe)
+{
+	char type;
+	int  fd;
+	int  res =3D cqe->res;
+
+	decodeUserData(cqe->user_data, &type, &fd);
+	if (res < 0) {
+		fprintf(stderr, "unexpected %s failure: (%d) %s\n",
+			opTypeToStr(type), -res, strerror(-res));
+		abort();
+	}
+
+	switch (type) {
+	case IOURING_SENDMSG:
+		receivePing(ctx);
+		--ctx->num_pings;
+		break;
+	case IOURING_RECVMSG:
+		ctx->iov.iov_len =3D res;
+		sendPing(ctx);
+		if (!ctx->napi_check)
+			reportNapi(ctx);
+		break;
+	default:
+		fprintf(stderr, "unexpected %s completion\n",
+			opTypeToStr(type));
+		abort();
+		break;
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	int flag;   =20
+	struct ctx       ctx;
+	struct options   opt;
+	struct __kernel_timespec *tsPtr;
+	struct __kernel_timespec ts;
+	struct io_uring_params params;
+	struct io_uring_napi napi;
+
+	memset(&opt, 0, sizeof(struct options));
+
+	// Process flags.
+	while ((flag =3D getopt_long(argc, argv, ":lhsbua:n:p:t:", longopts, NU=
LL)) !=3D -1) {
+		switch (flag) {
+		case 'a':
+			strcpy(opt.addr, optarg);
+			break;
+		case 'b':
+			opt.busy_loop =3D true;
+			break;
+		case 'h':
+			printUsage(argv[0]);
+			exit(0);
+			break;
+		case 'l':
+			opt.listen =3D true;
+			break;
+		case 'n':
+			opt.num_pings =3D atoi(optarg) + 1;
+			break;
+		case 'p':
+			strcpy(opt.port, optarg);
+			break;
+		case 's':
+                	opt.sq_poll =3D true;
+			break;
+		case 't':
+			opt.timeout =3D atoi(optarg);
+			break;
+		case 'u':
+			opt.prefer_busy_poll =3D true;
+			break;
+		case ':':
+			printError("Missing argument", optopt);
+			printUsage(argv[0]);
+			exit(-1);
+			break;
+		case '?':
+			printError("Unrecognized option", optopt);
+			printUsage(argv[0]);
+			exit(-1);
+			break;
+
+		default:
+			fprintf(stderr, "Fatal: Unexpected case in CmdLineProcessor switch()\=
n");
+			exit(-1);
+			break;
+		}
+	}
+
+	if (strlen(opt.addr) =3D=3D 0) {
+		fprintf(stderr, "address option is mandatory\n");
+		printUsage(argv[0]);
+		exit(1);
+	}
+
+	ctx.saddr.sin6_port   =3D htons(atoi(opt.port));
+	ctx.saddr.sin6_family =3D AF_INET6;
+
+	if (inet_pton(AF_INET6, opt.addr, &ctx.saddr.sin6_addr) <=3D 0) {
+        	fprintf(stderr, "inet_pton error for %s\n", optarg);
+		printUsage(argv[0]);
+		exit(1);
+        }
+
+	// Connect to server.
+	fprintf(stdout, "Listening %s : %s...\n", opt.addr, opt.port);
+
+	if ((ctx.sockfd =3D socket(AF_INET6, SOCK_DGRAM, 0)) < 0) {
+        	fprintf(stderr, "socket() failed: (%d) %s\n", errno, strerror(e=
rrno));
+        	exit(1);
+	}
+
+	if (bind(ctx.sockfd, (struct sockaddr *)&ctx.saddr, sizeof(struct socka=
ddr_in6)) < 0) {
+		fprintf(stderr, "bind() failed: (%d) %s\n", errno, strerror(errno));
+		exit(1);
+	}
+
+	// Setup ring.
+	memset(&params, 0, sizeof(params));
+	memset(&ts, 0, sizeof(ts));
+	memset(&napi, 0, sizeof(napi));
+
+	if (opt.sq_poll) {
+		params.flags =3D IORING_SETUP_SQPOLL;
+		params.sq_thread_idle =3D 50;
+	}
+
+	if (io_uring_queue_init_params(RINGSIZE, &ctx.ring, &params) < 0) {
+		fprintf(stderr, "io_uring_queue_init_params() failed: (%d) %s\n",
+			errno, strerror(errno));
+		exit(1);
+	}
+
+	if (opt.timeout || opt.prefer_busy_poll) {
+		napi.prefer_busy_poll =3D opt.prefer_busy_poll;
+		napi.busy_poll_to =3D opt.timeout;
+
+		io_uring_register_napi(&ctx.ring, &napi);
+	}
+
+	if (opt.busy_loop)
+		tsPtr =3D &ts;
+	else
+		tsPtr =3D NULL;
+
+
+	// Use realtime scheduler.
+	setProcessScheduler();
+
+	// Copy payload.
+	clock_gettime(CLOCK_REALTIME, &ctx.ts);
+
+	// Setup context.
+	ctx.napi_check =3D false;
+	ctx.buffer_len =3D sizeof(struct timespec);
+	ctx.num_pings  =3D opt.num_pings;
+
+	// Receive initial message to get napi id.
+	receivePing(&ctx);
+
+        while (ctx.num_pings !=3D 0) {
+		int res;
+		unsigned int num_completed =3D 0;
+		unsigned int head;
+		struct io_uring_cqe *cqe;
+
+		do {
+			res =3D io_uring_submit_and_wait_timeout(&ctx.ring, &cqe, 1, tsPtr, N=
ULL);
+		}
+		while (res < 0 && errno =3D=3D ETIME);
+
+		io_uring_for_each_cqe(&ctx.ring, head, cqe) {
+			++num_completed;
+			completion(&ctx, cqe);
+		}
+
+		if (num_completed) {
+			io_uring_cq_advance(&ctx.ring, num_completed);
+		}
+	}
+
+	// Clean up.
+	if (opt.timeout || opt.prefer_busy_poll)
+		io_uring_unregister_napi(&ctx.ring, &napi);
+
+	io_uring_queue_exit(&ctx.ring);
+	close(ctx.sockfd);
+
+	return 0;
+}
--=20
2.30.2

