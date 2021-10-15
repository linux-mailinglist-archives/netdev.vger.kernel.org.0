Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E576D42EA12
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 09:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236116AbhJOH3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbhJOH3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 03:29:02 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B6AC061753;
        Fri, 15 Oct 2021 00:26:56 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id d9so34116304edh.5;
        Fri, 15 Oct 2021 00:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cbn2O/IuIC1N4BTjq1m4QTF3DvYmfJ/PJDBU5ZUFZwU=;
        b=ZH8M5/P68PDyO66dkz8xwMfv14P6PVYtKSBcFYRUdCIhnn6vURAFhh7PvAr7KyzGF9
         xxuGInmz3qWMpcFiP4EoLxBEnH8EoRJS2y8NULgmQkO5y17LnpwBqt6bnG2PysV7A8dR
         fhYrSS9n7+azVjjZb9ztyCnQByYRK+/hvS84CVfsS61ov/Z0Rdno/TdMkCfMr2veicrI
         F56vAEhmlKUYOv08+Ffm6FZkF74HxDEu8cmJdcyKRC+zDcXmvG8BmWWgf1FGV72JlX1L
         G6uFtLhrY+pY9O7mScRW6x12zQSviRZFMRlAldhDRdn+bvd0A+uBAeK5VIXkGZkWY+Le
         OT9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cbn2O/IuIC1N4BTjq1m4QTF3DvYmfJ/PJDBU5ZUFZwU=;
        b=5JSXOl7971eJUcgC5HfpSoZUxW4+1liA8iDDBecjZDQyssQ+jrPbi4H/gV1zxWoIK0
         L9vZuDZ3aJd+VmMSuR3AuIZk5OshFPgzp8v4QGxXwgBYLHHY6rGgT6lOuq8u1WaPRsoU
         UFo4uC/irVi/H8Nx6yGkYzZX2/hFOzupqzuZYRPz4/YLbtqOcsDfxL6X6W4V8P1ciSnA
         ORe1wKBSaYTftB+9G0c58guLA5atLOE2MLqYDq1vr+/INpRRe3HLVS5cen3Wizt7bitj
         wUTuQBjMSuwxlYa7Gap+P3C1QhuU4FbgZGmJ6Iyy5+6b7EU+0apIo30dlK7rdrUWPJ7X
         scuw==
X-Gm-Message-State: AOAM530+QlUmi9VaGxc2MGFpoRiWbGoBBPM81x06HJuKuh6CTNMos0Mv
        PMgxUsY9oS6Xp2NItF23VI0=
X-Google-Smtp-Source: ABdhPJz061JKy2uInEKwfVUf/BIfvyMXP0rM8AelWiqtieULl0lpFb/Os8TxHXg7s9/Q7SOVoZZpmg==
X-Received: by 2002:aa7:cb41:: with SMTP id w1mr15709697edt.327.1634282814640;
        Fri, 15 Oct 2021 00:26:54 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:bac1:743:3859:80df])
        by smtp.gmail.com with ESMTPSA id l25sm3873107edc.31.2021.10.15.00.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 00:26:54 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] selftests: nettest: Add --{force,no}-bind-key-ifindex
Date:   Fri, 15 Oct 2021 10:26:06 +0300
Message-Id: <111eb35784dbc9d509ed52d833209f3655008d61.1634282515.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1634282515.git.cdleonard@gmail.com>
References: <cover.1634282515.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These options allow explicit control over the TCP_MD5SIG_FLAG_IFINDEX
flag instead of always setting it based on binding to an interface.

Do this by converting to getopt_long because nettest has too many
single-character flags already and getopt_long is widely used in
selftests.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 tools/testing/selftests/net/nettest.c | 28 +++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index bd6288302094..b599003eb5ba 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -26,10 +26,11 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
 #include <time.h>
 #include <errno.h>
+#include <getopt.h>
 
 #include <linux/xfrm.h>
 #include <linux/ipsec.h>
 #include <linux/pfkeyv2.h>
 
@@ -99,10 +100,12 @@ struct sock_args {
 	union {
 		struct sockaddr_in v4;
 		struct sockaddr_in6 v6;
 	} md5_prefix;
 	unsigned int prefix_len;
+	/* 0: default, -1: force off, +1: force on */
+	int bind_key_ifindex;
 
 	/* expected addresses and device index for connection */
 	const char *expected_dev;
 	const char *expected_server_dev;
 	int expected_ifindex;
@@ -269,15 +272,18 @@ static int tcp_md5sig(int sd, void *addr, socklen_t alen, struct sock_args *args
 		md5sig.tcpm_prefixlen = args->prefix_len;
 		addr = &args->md5_prefix;
 	}
 	memcpy(&md5sig.tcpm_addr, addr, alen);
 
-	if (args->ifindex) {
+	if ((args->ifindex && args->bind_key_ifindex >= 0) || args->bind_key_ifindex >= 1) {
 		opt = TCP_MD5SIG_EXT;
 		md5sig.tcpm_flags |= TCP_MD5SIG_FLAG_IFINDEX;
 
 		md5sig.tcpm_ifindex = args->ifindex;
+		log_msg("TCP_MD5SIG_FLAG_IFINDEX set tcpm_ifindex=%d\n", md5sig.tcpm_ifindex);
+	} else {
+		log_msg("TCP_MD5SIG_FLAG_IFINDEX off\n", md5sig.tcpm_ifindex);
 	}
 
 	rc = setsockopt(sd, IPPROTO_TCP, opt, &md5sig, sizeof(md5sig));
 	if (rc < 0) {
 		/* ENOENT is harmless. Returned when a password is cleared */
@@ -1820,10 +1826,18 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 	wait(&status);
 	return client_status;
 }
 
 #define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbq"
+#define OPT_FORCE_BIND_KEY_IFINDEX 1001
+#define OPT_NO_BIND_KEY_IFINDEX 1002
+
+static struct option long_opts[] = {
+	{"force-bind-key-ifindex", 0, 0, OPT_FORCE_BIND_KEY_IFINDEX},
+	{"no-bind-key-ifindex", 0, 0, OPT_NO_BIND_KEY_IFINDEX},
+	{0, 0, 0, 0}
+};
 
 static void print_usage(char *prog)
 {
 	printf(
 	"usage: %s OPTS\n"
@@ -1856,10 +1870,14 @@ static void print_usage(char *prog)
 	"    -n num        number of times to send message\n"
 	"\n"
 	"    -M password   use MD5 sum protection\n"
 	"    -X password   MD5 password for client mode\n"
 	"    -m prefix/len prefix and length to use for MD5 key\n"
+	"    --no-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX off\n"
+	"    --force-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX on\n"
+	"        (default: only if -I is passed)\n"
+	"\n"
 	"    -g grp        multicast group (e.g., 239.1.1.1)\n"
 	"    -i            interactive mode (default is echo and terminate)\n"
 	"\n"
 	"    -0 addr       Expected local address\n"
 	"    -1 addr       Expected remote address\n"
@@ -1891,11 +1909,11 @@ int main(int argc, char *argv[])
 
 	/*
 	 * process input args
 	 */
 
-	while ((rc = getopt(argc, argv, GETOPT_STR)) != -1) {
+	while ((rc = getopt_long(argc, argv, GETOPT_STR, long_opts, NULL)) != -1) {
 		switch (rc) {
 		case 'B':
 			both_mode = 1;
 			break;
 		case 's':
@@ -1964,10 +1982,16 @@ int main(int argc, char *argv[])
 			msg = random_msg(atoi(optarg));
 			break;
 		case 'M':
 			args.password = optarg;
 			break;
+		case OPT_FORCE_BIND_KEY_IFINDEX:
+			args.bind_key_ifindex = 1;
+			break;
+		case OPT_NO_BIND_KEY_IFINDEX:
+			args.bind_key_ifindex = -1;
+			break;
 		case 'X':
 			args.client_pw = optarg;
 			break;
 		case 'm':
 			args.md5_prefix_str = optarg;
-- 
2.25.1

