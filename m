Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BA261037A
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbiJ0Uyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235239AbiJ0Uwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:52:35 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEE57993B
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:45:34 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id m29-20020a05600c3b1d00b003c6bf423c71so5068422wms.0
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dwtJ3yUpPWJmmUE5F3LoS4PKdhnx1qXfUagzNvltjAg=;
        b=MJppJJocAVD1udLbf7Ml91Z1RvMgYtufEIobXxw8y+LEFIt5MUz2X61gtPUXpgjQY9
         LKxeQkW6kawSB/rHZ11ZZ8tRLTtpyB+D6cT+JzWFT6KysDtaQePNKVNTcPLq3dygeqxb
         ePRCSkhCuNiCs3VkFew2WNIKeEHRNgFOoVbreGxzznEm7305W9w3ikfmXaDzLTjhWDXD
         Rb9nmmhrlsTKrzcTpPGSaLaOhqnGagmm1FUbRjHQiTBPR9ZosgzSDA+7B+m5tC7qwNs1
         1+UgoYW+eBDLDBLQWdcaIV5CyWIAjlGseu3BibcNfAKBXppDyg1Bd9yddIB32yBymG4m
         0IkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dwtJ3yUpPWJmmUE5F3LoS4PKdhnx1qXfUagzNvltjAg=;
        b=WzLfywWPWCOfoEWRZDrbIM5/wuEGN2y0ZX9wAZwJPZANcfK4Sj0YcC29pCAwLPaaO6
         BJgL1x4NPUeN5hIB+RiaGoU2418i3ey+1wgvw1BUo/90XhklAmteFBkXQ1cJwFyQqMfR
         NXc8zvAc3uShB5suCQPgBNFD2FbSYgZ5GqIqOkwEIVjn6XrkSfF1Io7RKDbPFFd6A2ea
         odHhuWDTc5pukvxj6xL9zVFt0OmuQQNiMenQrQUCao5LjFwOBjHY0QqwYuD6wlmBTf/S
         JL1YLjRIrWtgpIPs/5zCuXcVDFy6bHlG8IPo2UDjwttNSyvowM8ZcQ6qNjlH54I1zjiV
         55Tg==
X-Gm-Message-State: ACrzQf0JuiKVfdfMXOSkqPd1DQAesk1p1eupnjrz7quAm4Yi4TMElj+1
        rirGVDiZG76daEcO01z33Xg3cA==
X-Google-Smtp-Source: AMsMyM4fnejBkCU0f691xbz7CzjpBLMN+lXSIezDH+0/8XINsCm+6EGJGTAS8aqCd0g0ebKEjE8jEQ==
X-Received: by 2002:a1c:7c14:0:b0:3b5:1133:d2ed with SMTP id x20-20020a1c7c14000000b003b51133d2edmr7182857wmc.133.1666903488225;
        Thu, 27 Oct 2022 13:44:48 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:47 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 35/36] selftests/nettest: Add TCP-AO support
Date:   Thu, 27 Oct 2022 21:43:46 +0100
Message-Id: <20221027204347.529913-36-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roughly, the same as TCP-MD5 support.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/net/nettest.c | 179 +++++++++++++++++++++++---
 1 file changed, 160 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 3499d6aff9e4..c81d3e2ceae1 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -77,7 +77,9 @@ struct sock_args {
 		     has_expected_laddr:1,
 		     has_expected_raddr:1,
 		     bind_test_only:1,
-		     use_md5:1;
+		     use_md5:1,
+		     use_tcpao:1,
+		     tcp_ao_excopts:1;
 
 	unsigned short port;
 
@@ -96,7 +98,7 @@ struct sock_args {
 	const char *serverns;
 
 	const char *password;
-	/* prefix for MD5 password */
+	/* prefix for MD5/TCP-AO password */
 	const char *auth_prefix_str;
 	union {
 		struct sockaddr_in v4;
@@ -105,6 +107,8 @@ struct sock_args {
 	unsigned int prefix_len;
 	/* 0: default, -1: force off, +1: force on */
 	int bind_key_ifindex;
+	unsigned int tcp_ao_sndid, tcp_ao_rcvid, tcp_ao_maclen;
+	char *tcp_ao_algo;
 
 	/* expected addresses and device index for connection */
 	const char *expected_dev;
@@ -300,7 +304,67 @@ static int tcp_md5sig(int sd, void *addr, socklen_t alen, struct sock_args *args
 	return rc;
 }
 
-static int tcp_md5_remote(int sd, struct sock_args *args)
+static int tcp_ao(int sd, void *addr, socklen_t alen, struct sock_args *args)
+{
+	int keylen = strlen(args->password);
+	struct tcp_ao ao = {};
+	int opt = TCP_AO;
+	int rc;
+
+	if (keylen > TCP_AO_MAXKEYLEN) {
+		log_error("key length is too big");
+		return -1;
+	}
+	ao.tcpa_keylen = keylen;
+	memcpy(ao.tcpa_key, args->password, keylen);
+	if (args->tcp_ao_algo)
+		strcpy(ao.tcpa_alg_name, args->tcp_ao_algo);
+	else
+		strcpy(ao.tcpa_alg_name, "cmac(aes128)");
+	if (args->tcp_ao_maclen)
+		ao.tcpa_maclen = args->tcp_ao_maclen;
+
+	ao.tcpa_sndid = args->tcp_ao_sndid;
+	ao.tcpa_rcvid = args->tcp_ao_rcvid;
+	if (args->tcp_ao_excopts)
+		ao.tcpa_keyflags |= TCP_AO_KEYF_EXCLUDE_OPT;
+
+	if (args->prefix_len) {
+		ao.tcpa_prefix = args->prefix_len;
+	} else {
+		switch (args->version) {
+		case AF_INET:
+			ao.tcpa_prefix = 32;
+			break;
+		case AF_INET6:
+			ao.tcpa_prefix = 128;
+			break;
+		default:
+			log_error("unknown address family\n");
+			exit(1);
+		}
+	}
+	memcpy(&ao.tcpa_addr, addr, alen);
+
+	/* FIXME: Remove once matching by port is supported */
+	if (args->version == AF_INET) {
+		struct sockaddr_in *sin = (void *)&ao.tcpa_addr;
+
+		sin->sin_port = htons(0);
+	} else if (args->version == AF_INET6) {
+		struct sockaddr_in6 *sin6 = (void *)&ao.tcpa_addr;
+
+		sin6->sin6_port = htons(0);
+	}
+
+	rc = setsockopt(sd, IPPROTO_TCP, opt, &ao, sizeof(ao));
+	if (rc < 0)
+		log_err_errno("setsockopt(TCP_AO)");
+
+	return rc;
+}
+
+static int tcp_auth_remote(int sd, struct sock_args *args)
 {
 	struct sockaddr_in sin = {
 		.sin_family = AF_INET,
@@ -329,7 +393,10 @@ static int tcp_md5_remote(int sd, struct sock_args *args)
 		exit(1);
 	}
 
-	if (tcp_md5sig(sd, addr, alen, args))
+	if (args->use_md5 && tcp_md5sig(sd, addr, alen, args))
+		return -1;
+
+	if (args->use_tcpao && tcp_ao(sd, addr, alen, args))
 		return -1;
 
 	return 0;
@@ -1546,10 +1613,8 @@ static int do_server(struct sock_args *args, int ipc_fd)
 		return rc;
 	}
 
-	if (args->use_md5 && tcp_md5_remote(lsd, args)) {
-		close(lsd);
-		goto err_exit;
-	}
+	if (tcp_auth_remote(lsd, args))
+		goto err_close;
 
 	ipc_write(ipc_fd, 1);
 	while (1) {
@@ -1598,6 +1663,8 @@ static int do_server(struct sock_args *args, int ipc_fd)
 	close(lsd);
 
 	return rc;
+err_close:
+	close(lsd);
 err_exit:
 	ipc_write(ipc_fd, 0);
 	return 1;
@@ -1673,6 +1740,9 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
 	if (args->use_md5 && tcp_md5sig(sd, addr, alen, args))
 		goto err;
 
+	if (args->use_tcpao && tcp_ao(sd, addr, alen, args))
+		goto err;
+
 	if (args->bind_test_only)
 		goto out;
 
@@ -1799,6 +1869,44 @@ static char *random_msg(int len)
 	return m;
 }
 
+static void strip_newlines(char *str)
+{
+	size_t i = strlen(str);
+
+	for (; i > 0; i--) {
+		if (str[i - 1] != '\n')
+			return;
+		str[i - 1] = '\0';
+	}
+}
+
+static int set_tcp_ao_param(struct sock_args *args, const char *opt)
+{
+	char *end, *sep = strstr(opt, ":");
+	unsigned long tmp;
+
+	errno = 0;
+	if (sep == NULL)
+		goto err_fail;
+
+	tmp = strtoul(opt, &end, 0);
+	if (errno || tmp > 255 || end != sep)
+		goto err_fail;
+	args->tcp_ao_sndid = (unsigned int) tmp;
+
+	tmp = strtoul(++sep, &end, 0);
+	if (errno || tmp > 255 || (*end != '\n' && *end != '\0'))
+		goto err_fail;
+	args->tcp_ao_rcvid = (unsigned int) tmp;
+
+	return 0;
+
+err_fail:
+	fprintf(stderr, "TCP-AO argument format is sndid:rcvid where ids in [0,255]\n"
+			"Example: -T 100:200\n");
+	return -1;
+}
+
 static int ipc_child(int fd, struct sock_args *args)
 {
 	char *outbuf, *errbuf;
@@ -1860,13 +1968,19 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:MX:m:d:I:BN:O:SUCi6xL:0:1:2:3:Fbqf"
-#define OPT_FORCE_BIND_KEY_IFINDEX 1001
-#define OPT_NO_BIND_KEY_IFINDEX 1002
+#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:MT:X:m:d:I:BN:O:SUCi6xL:0:1:2:3:Fbqf"
+#define OPT_FORCE_BIND_KEY_IFINDEX	1001
+#define OPT_NO_BIND_KEY_IFINDEX		1002
+#define OPT_TCPAO_ALGO			1003
+#define OPT_TCPAO_MACLEN		1004
+#define OPT_TCPAO_EXCOPTS		1005
 
 static struct option long_opts[] = {
-	{"force-bind-key-ifindex", 0, 0, OPT_FORCE_BIND_KEY_IFINDEX},
-	{"no-bind-key-ifindex", 0, 0, OPT_NO_BIND_KEY_IFINDEX},
+	{"force-bind-key-ifindex",	0, 0, OPT_FORCE_BIND_KEY_IFINDEX},
+	{"no-bind-key-ifindex",		0, 0, OPT_NO_BIND_KEY_IFINDEX},
+	{"tcpao_algo",			1, 0, OPT_TCPAO_ALGO },
+	{"tcpao_maclen",		1, 0, OPT_TCPAO_MACLEN },
+	{"tcpao_excopts",		0, 0, OPT_TCPAO_EXCOPTS },
 	{0, 0, 0, 0}
 };
 
@@ -1905,8 +2019,12 @@ static void print_usage(char *prog)
 	"    -n num        number of times to send message\n"
 	"\n"
 	"    -M            use MD5 sum protection\n"
-	"    -X password   MD5 password\n"
-	"    -m prefix/len prefix and length to use for MD5 key\n"
+	"    -T snd:rcvid  use TCP authopt (RFC5925) with snd/rcv ids\n"
+	"    --tcpao_algo=algo      TCP-AO hashing algorithm [valid with -T]\n"
+	"    --tcpao_maclen=maclen  TCP-AO MAC length [valid with -T]\n"
+	"    --tcpao_excopts        Exclude TCP options [valid with -T]\n"
+	"    -X password   MD5/TCP-AO password\n"
+	"    -m prefix/len prefix and length to use for MD5/TCP-AO key\n"
 	"    --no-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX off\n"
 	"    --force-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX on\n"
 	"        (default: only if -I is passed)\n"
@@ -2025,6 +2143,29 @@ int main(int argc, char *argv[])
 		case OPT_NO_BIND_KEY_IFINDEX:
 			args.bind_key_ifindex = -1;
 			break;
+		case OPT_TCPAO_ALGO:
+			args.tcp_ao_algo = strdup(optarg);
+			strip_newlines(args.tcp_ao_algo);
+			if (strlen(args.tcp_ao_algo) == 0) {
+				fprintf(stderr, "Invalid argument --tcpao_algo=%s\n", optarg);
+				return 1;
+			}
+			break;
+		case OPT_TCPAO_MACLEN:
+			if (str_to_uint(optarg, 1, 255, &tmp) != 0) {
+				fprintf(stderr, "Invalid --tcpao_maclen=%s\n", optarg);
+				return 1;
+			}
+			args.tcp_ao_maclen = tmp;
+			break;
+		case OPT_TCPAO_EXCOPTS:
+			args.tcp_ao_excopts = 1;
+			break;
+		case 'T':
+			args.use_tcpao = 1;
+			if (set_tcp_ao_param(&args, optarg))
+				return 1;
+			break;
 		case 'X':
 			args.password = optarg;
 			break;
@@ -2090,15 +2231,15 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (args.password && (!args.use_md5 ||
+	if (args.password && ((!args.use_md5 && !args.use_tcpao) ||
 	      (!args.has_remote_ip && !args.auth_prefix_str) ||
 	      args.type != SOCK_STREAM)) {
-		log_error("MD5 passwords apply to TCP only and require a remote ip for the password\n");
+		log_error("TCP-MD5/TCP-AO passwords apply to TCP only and require a remote ip for the password\n");
 		return 1;
 	}
 
-	if ((args.auth_prefix_str || args.use_md5) && !args.password) {
-		log_error("Prefix range for MD5 protection specified without a password\n");
+	if ((args.auth_prefix_str || args.use_md5 || args.use_tcpao) && !args.password) {
+		log_error("Prefix range for TCP-MD5/TCP-AO protection specified without a password\n");
 		return 1;
 	}
 
-- 
2.38.1

