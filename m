Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2888497F07
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242638AbiAXMO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239456AbiAXMOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:14:11 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F1AC061748;
        Mon, 24 Jan 2022 04:13:53 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id s13so20819745ejy.3;
        Mon, 24 Jan 2022 04:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RVPT2+h1JMxni3JUffui8/RQgc3zJLoReDrrKPMolQw=;
        b=jszIA/Je3qnzc36P/gZ48YPHNk70gTiUCMcVbOrCRDyTtmK93pDKNka/YloA4OSsM6
         UG/N/AkQo1fAfXoRrHGHPSW9dNa9CKB9u3KFYeXXV98PgI428oAWNmRLoHjvTh7T68Ty
         ERH0UwJbZxqMzyvMtzj2HIFBOq7WgoaziR9/Wkw8lpiH/hp53KL462/mj5ipIF6lr6ND
         0GNWejDPCkpPZkZ0tOlXVlZ8IWjx13pGEvGl/3hXnNLFIw4izdWuCsrsLEcRj7cer7q7
         2OHulkCewM4JseW9vwuSxlekpvt2Z/mKyO+3MbGnjPB/lklsZp0EXvHuLqG8AOLPkfLW
         Hx7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RVPT2+h1JMxni3JUffui8/RQgc3zJLoReDrrKPMolQw=;
        b=Q54AQiWWXHa9rnLCH/JB+Cp7NbvCq2oiFVGrOGP6rEki1q3zicrO7QLHlkcntti1Rr
         Y5/x+fz8FzqB8rxrtp2fKHPXhWRlkbgS7dXdcABOWGp4832DMq/oDu6SnHStaHjW1sPB
         OXho4aLnX5H0slUJzAr28QO0Ih8/2uA4WZF3a2LMIh8RcHDtow8iMmzrP9tA7pU4P7ws
         vIP6urnEx7gT/wcJsM349T7ebxHbjpY90sxClE3aa4xlWK0GuFpsgskVf/CyxpnjClyQ
         AOflW5W5FT4FMDnrSQri3ofGHhwJ5R6m09SOY2rIn40ksu3tCthsETWm461gaSF56dS7
         YKWg==
X-Gm-Message-State: AOAM533gZhCv1KHfEx4Oqj1dXgAWq2/x7hO1AgK8uH8eI0enu3LcP9/J
        6Eq0tJzgTfnLww9pVTpq0qw=
X-Google-Smtp-Source: ABdhPJyT/YU3Xh0Kt1v38l9yYburqMYqP2i7YS2EsyAsUapJm8DQPzQZhFD7yPvPvkRZ4AFSqvaIcA==
X-Received: by 2002:a17:907:1c1b:: with SMTP id nc27mr4880640ejc.618.1643026432540;
        Mon, 24 Jan 2022 04:13:52 -0800 (PST)
Received: from ponky.lan ([2a04:241e:502:a09c:a21f:7a9f:9158:4a40])
        by smtp.gmail.com with ESMTPSA id b16sm4847517eja.211.2022.01.24.04.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 04:13:52 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 17/20] selftests: nettest: Rename md5_prefix to key_addr_prefix
Date:   Mon, 24 Jan 2022 14:13:03 +0200
Message-Id: <a2d7c0713cbfc2a70b6778f7cd0c3a0956c40977.1643026076.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1643026076.git.cdleonard@gmail.com>
References: <cover.1643026076.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is in preparation for reusing the same option for TCP-AO

Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 50 +++++++++++++--------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index d9a6fd2cd9d3..3841e5fec7c7 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -94,17 +94,17 @@ struct sock_args {
 	const char *clientns;
 	const char *serverns;
 
 	const char *password;
 	const char *client_pw;
-	/* prefix for MD5 password */
-	const char *md5_prefix_str;
+	/* prefix for MD5/AO*/
+	const char *key_addr_prefix_str;
 	union {
 		struct sockaddr_in v4;
 		struct sockaddr_in6 v6;
-	} md5_prefix;
-	unsigned int prefix_len;
+	} key_addr;
+	unsigned int key_addr_prefix_len;
 	/* 0: default, -1: force off, +1: force on */
 	int bind_key_ifindex;
 
 	/* expected addresses and device index for connection */
 	const char *expected_dev;
@@ -264,16 +264,16 @@ static int tcp_md5sig(int sd, void *addr, socklen_t alen, struct sock_args *args
 	int rc;
 
 	md5sig.tcpm_keylen = keylen;
 	memcpy(md5sig.tcpm_key, args->password, keylen);
 
-	if (args->prefix_len) {
+	if (args->key_addr_prefix_len) {
 		opt = TCP_MD5SIG_EXT;
 		md5sig.tcpm_flags |= TCP_MD5SIG_FLAG_PREFIX;
 
-		md5sig.tcpm_prefixlen = args->prefix_len;
-		addr = &args->md5_prefix;
+		md5sig.tcpm_prefixlen = args->key_addr_prefix_len;
+		addr = &args->key_addr;
 	}
 	memcpy(&md5sig.tcpm_addr, addr, alen);
 
 	if ((args->ifindex && args->bind_key_ifindex >= 0) || args->bind_key_ifindex >= 1) {
 		opt = TCP_MD5SIG_EXT;
@@ -309,17 +309,17 @@ static int tcp_md5_remote(int sd, struct sock_args *args)
 	int alen;
 
 	switch (args->version) {
 	case AF_INET:
 		sin.sin_port = htons(args->port);
-		sin.sin_addr = args->md5_prefix.v4.sin_addr;
+		sin.sin_addr = args->key_addr.v4.sin_addr;
 		addr = &sin;
 		alen = sizeof(sin);
 		break;
 	case AF_INET6:
 		sin6.sin6_port = htons(args->port);
-		sin6.sin6_addr = args->md5_prefix.v6.sin6_addr;
+		sin6.sin6_addr = args->key_addr.v6.sin6_addr;
 		addr = &sin6;
 		alen = sizeof(sin6);
 		break;
 	default:
 		log_error("unknown address family\n");
@@ -705,11 +705,11 @@ enum addr_type {
 	ADDR_TYPE_LOCAL,
 	ADDR_TYPE_REMOTE,
 	ADDR_TYPE_MCAST,
 	ADDR_TYPE_EXPECTED_LOCAL,
 	ADDR_TYPE_EXPECTED_REMOTE,
-	ADDR_TYPE_MD5_PREFIX,
+	ADDR_TYPE_KEY_PREFIX,
 };
 
 static int convert_addr(struct sock_args *args, const char *_str,
 			enum addr_type atype)
 {
@@ -745,32 +745,32 @@ static int convert_addr(struct sock_args *args, const char *_str,
 		break;
 	case ADDR_TYPE_EXPECTED_REMOTE:
 		desc = "expected remote";
 		addr = &args->expected_raddr;
 		break;
-	case ADDR_TYPE_MD5_PREFIX:
-		desc = "md5 prefix";
+	case ADDR_TYPE_KEY_PREFIX:
+		desc = "key addr prefix";
 		if (family == AF_INET) {
-			args->md5_prefix.v4.sin_family = AF_INET;
-			addr = &args->md5_prefix.v4.sin_addr;
+			args->key_addr.v4.sin_family = AF_INET;
+			addr = &args->key_addr.v4.sin_addr;
 		} else if (family == AF_INET6) {
-			args->md5_prefix.v6.sin6_family = AF_INET6;
-			addr = &args->md5_prefix.v6.sin6_addr;
+			args->key_addr.v6.sin6_family = AF_INET6;
+			addr = &args->key_addr.v6.sin6_addr;
 		} else
 			return 1;
 
 		sep = strchr(str, '/');
 		if (sep) {
 			*sep = '\0';
 			sep++;
 			if (str_to_uint(sep, 1, pfx_len_max,
-					&args->prefix_len) != 0) {
-				fprintf(stderr, "Invalid port\n");
+					&args->key_addr_prefix_len) != 0) {
+				fprintf(stderr, "Invalid prefix\n");
 				return 1;
 			}
 		} else {
-			args->prefix_len = 0;
+			args->key_addr_prefix_len = 0;
 		}
 		break;
 	default:
 		log_error("unknown address type\n");
 		exit(1);
@@ -835,13 +835,13 @@ static int validate_addresses(struct sock_args *args)
 
 	if (args->remote_addr_str &&
 	    convert_addr(args, args->remote_addr_str, ADDR_TYPE_REMOTE) < 0)
 		return 1;
 
-	if (args->md5_prefix_str &&
-	    convert_addr(args, args->md5_prefix_str,
-			 ADDR_TYPE_MD5_PREFIX) < 0)
+	if (args->key_addr_prefix_str &&
+	    convert_addr(args, args->key_addr_prefix_str,
+			 ADDR_TYPE_KEY_PREFIX) < 0)
 		return 1;
 
 	if (args->expected_laddr_str &&
 	    convert_addr(args, args->expected_laddr_str,
 			 ADDR_TYPE_EXPECTED_LOCAL))
@@ -2020,11 +2020,11 @@ int main(int argc, char *argv[])
 			break;
 		case 'X':
 			args.client_pw = optarg;
 			break;
 		case 'm':
-			args.md5_prefix_str = optarg;
+			args.key_addr_prefix_str = optarg;
 			break;
 		case 'S':
 			args.use_setsockopt = 1;
 			break;
 		case 'f':
@@ -2079,17 +2079,17 @@ int main(int argc, char *argv[])
 			return 1;
 		}
 	}
 
 	if (args.password &&
-	    ((!args.has_remote_ip && !args.md5_prefix_str) ||
+	    ((!args.has_remote_ip && !args.key_addr_prefix_str) ||
 	      args.type != SOCK_STREAM)) {
 		log_error("MD5 passwords apply to TCP only and require a remote ip for the password\n");
 		return 1;
 	}
 
-	if (args.md5_prefix_str && !args.password) {
+	if (args.key_addr_prefix_str && !args.password) {
 		log_error("Prefix range for MD5 protection specified without a password\n");
 		return 1;
 	}
 
 	if (iter == 0) {
-- 
2.25.1

