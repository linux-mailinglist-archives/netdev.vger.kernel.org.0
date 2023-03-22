Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E2E6C3F4A
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 01:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCVAsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 20:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjCVAsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 20:48:16 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B6EE382;
        Tue, 21 Mar 2023 17:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679446095; x=1710982095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N5rPgZRD9oNX2MUpnfum4/78Js7P8wvRbeVND19tXUE=;
  b=SRO9+MwVy/I1/WM7uAIuZqywiwRKxsyftBxib33qjEltgeX4P2BysLCE
   m86Hfa461SHJ/szPdN6qEkliG9JVL/Yl5IIMphB6zF6w08Mk/c4QxED7y
   f05jXmadGXfztQI737Tygdm6SouBrTx620+0SPpUhtbUxPZJorLJ/MPq/
   Y=;
X-IronPort-AV: E=Sophos;i="5.98,280,1673913600"; 
   d="scan'208";a="196003344"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 00:48:13 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com (Postfix) with ESMTPS id 4A47080DE5;
        Wed, 22 Mar 2023 00:48:08 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Wed, 22 Mar 2023 00:48:07 +0000
Received: from 88665a182662.ant.amazon.com (10.94.217.231) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 22 Mar 2023 00:48:03 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <aleksandr.mikhalitsyn@canonical.com>
CC:     <arnd@arndb.de>, <brauner@kernel.org>, <davem@davemloft.net>,
        <dsahern@kernel.org>, <edumazet@google.com>,
        <keescook@chromium.org>, <kuba@kernel.org>, <leon@kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 3/3] selftests: net: add SCM_PIDFD / SO_PEERPIDFD test
Date:   Tue, 21 Mar 2023 17:47:52 -0700
Message-ID: <20230322004752.30055-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230321183342.617114-4-aleksandr.mikhalitsyn@canonical.com>
References: <20230321183342.617114-4-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.94.217.231]
X-ClientProxiedBy: EX19D041UWB002.ant.amazon.com (10.13.139.179) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=0.3 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Tue, 21 Mar 2023 19:33:42 +0100
> Basic test to check consistency between:
> - SCM_CREDENTIALS and SCM_PIDFD
> - SO_PEERCRED and SO_PEERPIDFD
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Cc: linux-kselftest@vger.kernel.org
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---
>  tools/testing/selftests/net/.gitignore        |   1 +
>  tools/testing/selftests/net/af_unix/Makefile  |   3 +-
>  .../testing/selftests/net/af_unix/scm_pidfd.c | 336 ++++++++++++++++++
>  3 files changed, 339 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/net/af_unix/scm_pidfd.c
> 
> diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
> index a6911cae368c..f2d23a1df596 100644
> --- a/tools/testing/selftests/net/.gitignore
> +++ b/tools/testing/selftests/net/.gitignore
> @@ -25,6 +25,7 @@ reuseport_bpf_cpu
>  reuseport_bpf_numa
>  reuseport_dualstack
>  rxtimestamp
> +scm_pidfd
>  sk_bind_sendto_listen
>  sk_connect_zero_addr
>  socket
> diff --git a/tools/testing/selftests/net/af_unix/Makefile b/tools/testing/selftests/net/af_unix/Makefile
> index 1e4b397cece6..221c387a7d7f 100644
> --- a/tools/testing/selftests/net/af_unix/Makefile
> +++ b/tools/testing/selftests/net/af_unix/Makefile
> @@ -1,3 +1,4 @@
> -TEST_GEN_PROGS := diag_uid test_unix_oob unix_connect
> +CFLAGS += $(KHDR_INCLUDES)
> +TEST_GEN_PROGS := diag_uid test_unix_oob unix_connect scm_pidfd
>  
>  include ../../lib.mk
> diff --git a/tools/testing/selftests/net/af_unix/scm_pidfd.c b/tools/testing/selftests/net/af_unix/scm_pidfd.c
> new file mode 100644
> index 000000000000..fa502510ee9e
> --- /dev/null
> +++ b/tools/testing/selftests/net/af_unix/scm_pidfd.c
> @@ -0,0 +1,336 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <error.h>
> +#include <limits.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/socket.h>
> +#include <linux/socket.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <sys/un.h>
> +#include <sys/signal.h>
> +#include <sys/types.h>
> +#include <sys/wait.h>

#include "../../kselftest_harness.h"

Could you rewrite with kselftest ?
https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html

Also, it would be better to have all combinations as FIXTURE_VARIANT()
covered by unix_passcred_enabled() like

  (self, peer) = (0, 0), (SO_PASSPIDFD, 0), (0, SO_PASSPIDFD),
                 (SO_PASSPIDFD, SO_PASSPIDFD), ...
                 (SO_PASSPIDFD, SO_PEERCRED), ...

Thanks,
Kuniyuki


> +
> +#define clean_errno() (errno == 0 ? "None" : strerror(errno))
> +#define log_err(MSG, ...)                                                   \
> +	fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", __FILE__, __LINE__, \
> +		clean_errno(), ##__VA_ARGS__)
> +
> +#ifndef SCM_PIDFD
> +#define SCM_PIDFD 0x04
> +#endif
> +
> +static pid_t client_pid;
> +static char sock_name[32];
> +
> +static void die(int status)
> +{
> +	unlink(sock_name);
> +	kill(client_pid, SIGTERM);
> +	exit(status);
> +}
> +
> +static void child_die()
> +{
> +	kill(getppid(), SIGTERM);
> +	exit(1);
> +}
> +
> +static int safe_int(const char *numstr, int *converted)
> +{
> +	char *err = NULL;
> +	long sli;
> +
> +	errno = 0;
> +	sli = strtol(numstr, &err, 0);
> +	if (errno == ERANGE && (sli == LONG_MAX || sli == LONG_MIN))
> +		return -ERANGE;
> +
> +	if (errno != 0 && sli == 0)
> +		return -EINVAL;
> +
> +	if (err == numstr || *err != '\0')
> +		return -EINVAL;
> +
> +	if (sli > INT_MAX || sli < INT_MIN)
> +		return -ERANGE;
> +
> +	*converted = (int)sli;
> +	return 0;
> +}
> +
> +static int char_left_gc(const char *buffer, size_t len)
> +{
> +	size_t i;
> +
> +	for (i = 0; i < len; i++) {
> +		if (buffer[i] == ' ' || buffer[i] == '\t')
> +			continue;
> +
> +		return i;
> +	}
> +
> +	return 0;
> +}
> +
> +static int char_right_gc(const char *buffer, size_t len)
> +{
> +	int i;
> +
> +	for (i = len - 1; i >= 0; i--) {
> +		if (buffer[i] == ' ' || buffer[i] == '\t' ||
> +		    buffer[i] == '\n' || buffer[i] == '\0')
> +			continue;
> +
> +		return i + 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static char *trim_whitespace_in_place(char *buffer)
> +{
> +	buffer += char_left_gc(buffer, strlen(buffer));
> +	buffer[char_right_gc(buffer, strlen(buffer))] = '\0';
> +	return buffer;
> +}
> +
> +/* borrowed (with all helpers) from pidfd/pidfd_open_test.c */
> +static pid_t get_pid_from_fdinfo_file(int pidfd, const char *key, size_t keylen)
> +{
> +	int ret;
> +	char path[512];
> +	FILE *f;
> +	size_t n = 0;
> +	pid_t result = -1;
> +	char *line = NULL;
> +
> +	snprintf(path, sizeof(path), "/proc/self/fdinfo/%d", pidfd);
> +
> +	f = fopen(path, "re");
> +	if (!f)
> +		return -1;
> +
> +	while (getline(&line, &n, f) != -1) {
> +		char *numstr;
> +
> +		if (strncmp(line, key, keylen))
> +			continue;
> +
> +		numstr = trim_whitespace_in_place(line + 4);
> +		ret = safe_int(numstr, &result);
> +		if (ret < 0)
> +			goto out;
> +
> +		break;
> +	}
> +
> +out:
> +	free(line);
> +	fclose(f);
> +	return result;
> +}
> +
> +static int cmsg_check(int fd)
> +{
> +	struct msghdr msg = { 0 };
> +	struct cmsghdr *cmsg;
> +	struct iovec iov;
> +	struct ucred *ucred = NULL;
> +	int data = 0;
> +	char control[CMSG_SPACE(sizeof(struct ucred)) +
> +		     CMSG_SPACE(sizeof(int))] = { 0 };
> +	int *pidfd = NULL;
> +	pid_t parent_pid;
> +	int err;
> +
> +	iov.iov_base = &data;
> +	iov.iov_len = sizeof(data);
> +
> +	msg.msg_iov = &iov;
> +	msg.msg_iovlen = 1;
> +	msg.msg_control = control;
> +	msg.msg_controllen = sizeof(control);
> +
> +	err = recvmsg(fd, &msg, 0);
> +	if (err < 0) {
> +		log_err("recvmsg");
> +		return 1;
> +	}
> +
> +	if (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC)) {
> +		log_err("recvmsg: truncated");
> +		return 1;
> +	}
> +
> +	for (cmsg = CMSG_FIRSTHDR(&msg); cmsg != NULL;
> +	     cmsg = CMSG_NXTHDR(&msg, cmsg)) {
> +		if (cmsg->cmsg_level == SOL_SOCKET &&
> +		    cmsg->cmsg_type == SCM_PIDFD) {
> +			if (cmsg->cmsg_len < sizeof(*pidfd)) {
> +				log_err("CMSG parse: SCM_PIDFD wrong len");
> +				return 1;
> +			}
> +
> +			pidfd = (void *)CMSG_DATA(cmsg);
> +		}
> +
> +		if (cmsg->cmsg_level == SOL_SOCKET &&
> +		    cmsg->cmsg_type == SCM_CREDENTIALS) {
> +			if (cmsg->cmsg_len < sizeof(*ucred)) {
> +				log_err("CMSG parse: SCM_CREDENTIALS wrong len");
> +				return 1;
> +			}
> +
> +			ucred = (void *)CMSG_DATA(cmsg);
> +		}
> +	}
> +
> +	/* send(pfd, "x", sizeof(char), 0) */
> +	if (data != 'x') {
> +		log_err("recvmsg: data corruption");
> +		return 1;
> +	}
> +
> +	if (!pidfd) {
> +		log_err("CMSG parse: SCM_PIDFD not found");
> +		return 1;
> +	}
> +
> +	if (!ucred) {
> +		log_err("CMSG parse: SCM_CREDENTIALS not found");
> +		return 1;
> +	}
> +
> +	/* pidfd from SCM_PIDFD should point to the parent process PID */
> +	parent_pid =
> +		get_pid_from_fdinfo_file(*pidfd, "Pid:", sizeof("Pid:") - 1);
> +	if (parent_pid != getppid()) {
> +		log_err("wrong SCM_PIDFD %d != %d", parent_pid, getppid());
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +void client(struct sockaddr_un *listen_addr)
> +{
> +	int cfd;
> +	socklen_t len;
> +	struct ucred peer_cred;
> +	int peer_pidfd;
> +	pid_t peer_pid;
> +	int on = 0;
> +
> +	cfd = socket(AF_UNIX, SOCK_STREAM, 0);
> +	if (cfd < 0) {
> +		log_err("socket");
> +		child_die();
> +	}
> +
> +	if (connect(cfd, (struct sockaddr *)listen_addr,
> +		    sizeof(*listen_addr)) != 0) {
> +		log_err("connect");
> +		child_die();
> +	}
> +
> +	on = 1;
> +	if (setsockopt(cfd, SOL_SOCKET, SO_PASSCRED, &on, sizeof(on))) {
> +		log_err("Failed to set SO_PASSCRED");
> +		child_die();
> +	}
> +
> +	if (setsockopt(cfd, SOL_SOCKET, SO_PASSPIDFD, &on, sizeof(on))) {
> +		log_err("Failed to set SO_PASSPIDFD");
> +		child_die();
> +	}
> +
> +	if (cmsg_check(cfd)) {
> +		log_err("cmsg_check failed");
> +		child_die();
> +	}
> +
> +	len = sizeof(peer_cred);
> +	if (getsockopt(cfd, SOL_SOCKET, SO_PEERCRED, &peer_cred, &len)) {
> +		log_err("Failed to get SO_PEERCRED");
> +		child_die();
> +	}
> +
> +	len = sizeof(peer_pidfd);
> +	if (getsockopt(cfd, SOL_SOCKET, SO_PEERPIDFD, &peer_pidfd, &len)) {
> +		log_err("Failed to get SO_PEERPIDFD");
> +		child_die();
> +	}
> +
> +	/* pid from SO_PEERCRED should point to the parent process PID */
> +	if (peer_cred.pid != getppid()) {
> +		log_err("Failed to get SO_PEERPIDFD");
> +		child_die();
> +	}
> +
> +	peer_pid = get_pid_from_fdinfo_file(peer_pidfd,
> +					    "Pid:", sizeof("Pid:") - 1);
> +	if (peer_pid != peer_cred.pid) {
> +		log_err("Failed to get SO_PEERPIDFD");
> +		child_die();
> +	}
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	int lfd, pfd;
> +	int child_status = 0;
> +	struct sockaddr_un listen_addr;
> +
> +	lfd = socket(AF_UNIX, SOCK_STREAM, 0);
> +	if (lfd < 0) {
> +		perror("socket");
> +		exit(1);
> +	}
> +
> +	memset(&listen_addr, 0, sizeof(listen_addr));
> +	listen_addr.sun_family = AF_UNIX;
> +	sprintf(sock_name, "scm_pidfd_%d", getpid());
> +	unlink(sock_name);
> +	strcpy(listen_addr.sun_path, sock_name);
> +
> +	if ((bind(lfd, (struct sockaddr *)&listen_addr, sizeof(listen_addr))) !=
> +	    0) {
> +		perror("socket bind failed");
> +		exit(1);
> +	}
> +
> +	if (listen(lfd, 1) < 0) {
> +		perror("listen");
> +		exit(1);
> +	}
> +
> +	client_pid = fork();
> +	if (client_pid < 0) {
> +		perror("fork");
> +		exit(1);
> +	}
> +
> +	if (client_pid == 0) {
> +		client(&listen_addr);
> +		exit(0);
> +	}
> +
> +	pfd = accept(lfd, NULL, NULL);
> +	if (pfd < 0) {
> +		perror("accept");
> +		die(1);
> +	}
> +
> +	if (send(pfd, "x", sizeof(char), 0) < 0) {
> +		perror("send");
> +		die(1);
> +	}
> +
> +	waitpid(client_pid, &child_status, 0);
> +	die(WIFEXITED(child_status) ? WEXITSTATUS(child_status) : 1);
> +	die(0);
> +}
> \ No newline at end of file
> -- 
> 2.34.1
