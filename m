Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DDA2F42BE
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbhAMECG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:02:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbhAMECF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:02:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1A772313A;
        Wed, 13 Jan 2021 04:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610510459;
        bh=wsm+A5jY+QTIU4fd2ObPBK8dZXdKgfZ+vE97utz/YTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZjBb5Gtd7byTmJ+T9Vuortu+cL12TZ3gpBNRElpov6/Y9fKqpVzHkrXhLZ1sJWA6
         9mGoaYmBKM9Vv40BsgSkVf2NDXXlL166tAtXxMkLymhJxE927RIaHBiftnJs9SJShV
         2ziNCH5bI30oCgwSrjgYZOJqhQtt8rVQyGcz6ThlxK6nzuQMG0Lrt8/UFvHs9qvewb
         nx8G4dU07qCNH7IJU4zfWd4Du2cYhC5kSrNgp/2bWUpU2hJsMXrMvYAk4ZLk+8cgDj
         /+1VdsHJsp4U4jezhi0zsXMWmi/5EdVyZSx1cC/KMJJOhyTymuTgyVgBbM94Jt7B7f
         2ZmAou3HoHjRQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v3 05/13] selftests: Add support to nettest to run both client and server
Date:   Tue, 12 Jan 2021 21:00:32 -0700
Message-Id: <20210113040040.50813-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210113040040.50813-1-dsahern@kernel.org>
References: <20210113040040.50813-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add option to nettest to run both client and server within a
single instance. Client forks a child process to run the server
code. A pipe is used for the server to tell the client it has
initialized and is ready or had an error. This avoid unnecessary
sleeps to handle such race when the commands are separately launched.

Signed-off-by: Seth David Schoen <schoen@loyalty.org>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 93 ++++++++++++++++++++++++---
 1 file changed, 85 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index cc9635b6461f..685cbe8933de 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -1395,8 +1395,19 @@ static int lsock_init(struct sock_args *args)
 	return -1;
 }
 
-static int do_server(struct sock_args *args)
+static void ipc_write(int fd, int message)
 {
+	/* Not in both_mode, so there's no process to signal */
+	if (fd < 0)
+		return;
+
+	if (write(fd, &message, sizeof(message)) < 0)
+		log_err_errno("Failed to send client status");
+}
+
+static int do_server(struct sock_args *args, int ipc_fd)
+{
+	/* ipc_fd = -1 if no parent process to signal */
 	struct timeval timeout = { .tv_sec = prog_timeout }, *ptval = NULL;
 	unsigned char addr[sizeof(struct sockaddr_in6)] = {};
 	socklen_t alen = sizeof(addr);
@@ -1409,13 +1420,13 @@ static int do_server(struct sock_args *args)
 		if (switch_ns(args->serverns)) {
 			log_error("Could not set server netns to %s\n",
 				  args->serverns);
-			return 1;
+			goto err_exit;
 		}
 		log_msg("Switched server netns\n");
 	}
 
 	if (resolve_devices(args) || validate_addresses(args))
-		return 1;
+		goto err_exit;
 
 	if (prog_timeout)
 		ptval = &timeout;
@@ -1426,14 +1437,16 @@ static int do_server(struct sock_args *args)
 		lsd = lsock_init(args);
 
 	if (lsd < 0)
-		return 1;
+		goto err_exit;
 
 	if (args->bind_test_only) {
 		close(lsd);
+		ipc_write(ipc_fd, 1);
 		return 0;
 	}
 
 	if (args->type != SOCK_STREAM) {
+		ipc_write(ipc_fd, 1);
 		rc = msg_loop(0, lsd, (void *) addr, alen, args);
 		close(lsd);
 		return rc;
@@ -1441,9 +1454,10 @@ static int do_server(struct sock_args *args)
 
 	if (args->password && tcp_md5_remote(lsd, args)) {
 		close(lsd);
-		return 1;
+		goto err_exit;
 	}
 
+	ipc_write(ipc_fd, 1);
 	while (1) {
 		log_msg("\n");
 		log_msg("waiting for client connection.\n");
@@ -1491,6 +1505,9 @@ static int do_server(struct sock_args *args)
 	close(lsd);
 
 	return rc;
+err_exit:
+	ipc_write(ipc_fd, 0);
+	return 1;
 }
 
 static int wait_for_connect(int sd)
@@ -1688,7 +1705,43 @@ static char *random_msg(int len)
 	return m;
 }
 
-#define GETOPT_STR  "sr:l:p:t:g:P:DRn:M:m:d:N:O:SCi6L:0:1:2:Fbq"
+static int ipc_child(int fd, struct sock_args *args)
+{
+	server_mode = 1; /* to tell log_msg in case we are in both_mode */
+
+	return do_server(args, fd);
+}
+
+static int ipc_parent(int cpid, int fd, struct sock_args *args)
+{
+	int client_status;
+	int status;
+	int buf;
+
+	/* do the client-side function here in the parent process,
+	 * waiting to be told when to continue
+	 */
+	if (read(fd, &buf, sizeof(buf)) <= 0) {
+		log_err_errno("Failed to read IPC status from status");
+		return 1;
+	}
+	if (!buf) {
+		log_error("Server failed; can not continue\n");
+		return 1;
+	}
+	log_msg("Server is ready\n");
+
+	client_status = do_client(args);
+	log_msg("parent is done!\n");
+
+	if (kill(cpid, 0) == 0)
+		kill(cpid, SIGKILL);
+
+	wait(&status);
+	return client_status;
+}
+
+#define GETOPT_STR  "sr:l:p:t:g:P:DRn:M:m:d:BN:O:SCi6L:0:1:2:Fbq"
 
 static void print_usage(char *prog)
 {
@@ -1702,6 +1755,7 @@ static void print_usage(char *prog)
 	"    -t            timeout seconds (default: none)\n"
 	"\n"
 	"Optional:\n"
+	"    -B            do both client and server via fork and IPC\n"
 	"    -N ns         set client to network namespace ns (requires root)\n"
 	"    -O ns         set server to network namespace ns (requires root)\n"
 	"    -F            Restart server loop\n"
@@ -1740,8 +1794,11 @@ int main(int argc, char *argv[])
 		.port    = DEFAULT_PORT,
 	};
 	struct protoent *pe;
+	int both_mode = 0;
 	unsigned int tmp;
 	int forever = 0;
+	int fd[2];
+	int cpid;
 
 	/* process inputs */
 	extern char *optarg;
@@ -1753,6 +1810,9 @@ int main(int argc, char *argv[])
 
 	while ((rc = getopt(argc, argv, GETOPT_STR)) != -1) {
 		switch (rc) {
+		case 'B':
+			both_mode = 1;
+			break;
 		case 's':
 			server_mode = 1;
 			break;
@@ -1892,7 +1952,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	if (!server_mode && !args.has_grp &&
+	if ((both_mode || !server_mode) && !args.has_grp &&
 	    !args.has_remote_ip && !args.has_local_ip) {
 		fprintf(stderr,
 			"Local (server mode) or remote IP (client IP) required\n");
@@ -1904,9 +1964,26 @@ int main(int argc, char *argv[])
 		msg = NULL;
 	}
 
+	if (both_mode) {
+		if (pipe(fd) < 0) {
+			perror("pipe");
+			exit(1);
+		}
+
+		cpid = fork();
+		if (cpid < 0) {
+			perror("fork");
+			exit(1);
+		}
+		if (cpid)
+			return ipc_parent(cpid, fd[0], &args);
+
+		return ipc_child(fd[1], &args);
+	}
+
 	if (server_mode) {
 		do {
-			rc = do_server(&args);
+			rc = do_server(&args, -1);
 		} while (forever);
 
 		return rc;
-- 
2.24.3 (Apple Git-128)

