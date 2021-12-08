Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F1C46D299
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbhLHLnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbhLHLm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:42:59 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24F5C061746;
        Wed,  8 Dec 2021 03:38:25 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id w1so7368891edc.6;
        Wed, 08 Dec 2021 03:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RVPT2+h1JMxni3JUffui8/RQgc3zJLoReDrrKPMolQw=;
        b=Y9VES6kVAajO2YukvLlA9DyY3xNj9FlpbNafOGMha8409a7Qq3Yup0H4JH2Zrl2eHj
         bNRnsZt3uSCQnReeW7260MH15gxIwTe7sKlU83FYkbpfWvoycwX9Va14Lm7EAIXJQPYU
         IdCoY2D9uH5tQZ6ctJbH7pmY0lZIYSC/ASBtJvd2yc2u8B6/CLeWVcNg0Ju9GtySzaP6
         U3vkhKJ1BztXP4CzpBnkw5VJggSRqyWjit7O1jkJ85NGolri0N1oKM9UVy2x1USxYQ4s
         IIFBZGcixQGP9dBEj3+Mc8NnlZMQYp5+bJ/lizz9jZ/B1zMHrr83vEj+4C2ReHf6Lc63
         5A7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RVPT2+h1JMxni3JUffui8/RQgc3zJLoReDrrKPMolQw=;
        b=CJEgiX3OY3idQPpsYItcxh4IbEmaOcZxEk5rllatAm3JSP4Srn2ab4jX/J4uQhyhvw
         rWcfJuPew1n83tjEfCiUppj0QaIHicvXKqz/vDHf1HM2aka3LNI2+4PlTnevBI5XodId
         DNqRkvl+1sLqX5pHNiJqURflx10JTU+8F6DLj1yR22B8dfaQera5l/LA9MH90r4q8fVR
         ke/S2+Rl6bNTZIBJvd/6BclkZ6mUZ70ocGVKDixSSdSfo7hWWPet/j0xtmZu+v/wBMDj
         JZM/PVlcz4pNT+zCjhUs+KDmnbnptN1pXi4SKg1yjnH/xP7OZFSQ4ZXvNgTi0Ymb6aoG
         Xe9g==
X-Gm-Message-State: AOAM5326eQWOj1AYgbaO62tcf4yPuBWJnJyV1+4eO4qNKjaFy4/rurCw
        sVhjdYpQSZsPsjWXunff3q8=
X-Google-Smtp-Source: ABdhPJye+pih97YuJGTbr+n4wXZbAcpr8J3iys2HHJt+y0QlUMC+bAMZBs6n/t+DYw4FCz9c/L8VRw==
X-Received: by 2002:a17:906:fb17:: with SMTP id lz23mr6702930ejb.149.1638963504451;
        Wed, 08 Dec 2021 03:38:24 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:3c9f:e05b:4dff:43ba])
        by smtp.gmail.com with ESMTPSA id g11sm1883810edz.53.2021.12.08.03.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:38:24 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 16/18] selftests: nettest: Rename md5_prefix to key_addr_prefix
Date:   Wed,  8 Dec 2021 13:37:31 +0200
Message-Id: <70cc6300b78d75fd36adb57b17e7208c2f0788f4.1638962992.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638962992.git.cdleonard@gmail.com>
References: <cover.1638962992.git.cdleonard@gmail.com>
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

