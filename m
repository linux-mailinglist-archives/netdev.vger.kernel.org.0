Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867A25E8363
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbiIWURp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiIWUPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:15:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95755135716
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:14:18 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id t7so1533546wrm.10
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=LqvkFCVCjfa7ILnjOvpfFzjAz1hFv+OuedSgBSKgSnc=;
        b=dASSeeXmaKEDFIEpWQgMRlQAuiOWIUSOdmJjKkGDgoXy9J72ds0K0tj0DjLpitLAfb
         pyHEkrfVsIUPlTrJPZQQrU3X9umCQ792x+u5AbB122ybV+ilTXp6bq/nBS4pA0hfSig0
         mu2fuMKTAbtsNpktGbK/6jCSk9WkPaYwOENc3cKWa6XnVaoRj+7pVX9oHV2BLGiblrLO
         hvJKAJEtHqZfbzVUsh6cIP1J9GDYgZu5OT1eLeLxVSDvz2guAINOaEYT3QBRv6cUrAMc
         nF3GiqN1pkXy/k5ddngK74F67NKvHx+p+Pobe6oS5St4ZewXcQdZfr3KZUFQ8IXvKHVp
         CQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LqvkFCVCjfa7ILnjOvpfFzjAz1hFv+OuedSgBSKgSnc=;
        b=tw9tGxZ+HJuKL/JqXbzYaDjbwkWIDWlI1uLwRjVwSH8TBUYBcjLLYV/2uKuyVaW9Yy
         1tlWVtdqBpAAsOlyysdHbl2MTZ+EZXyBHwVjNRLeB15zmnpxA+Mc6iYGz4tc8JGZtbTQ
         tzYDQE/tKt9eAWduidGdtAK/r4J9EoCy2aqONAW8z+Qd6x9HkCyCZiHW2Edrgj4XFt6v
         kt7snDczTMMT8/wIf7XRJd+NBOX0yTcNSQg+yRwv8UA5bZy/LQPuafvMvkDO9mUEHmnQ
         Bo+HrtpGn6AUsEhkgBsArVhU7e2+GAWNn32cEpYOgiVQhl/ZFPtvINt8/07RCa8GzZDr
         dPmw==
X-Gm-Message-State: ACrzQf1zL/BGKFk0Ky+h6kz26qeB4J1cilUL1r6XfKjx87FIvGeppyPB
        Q38EnVNDA963W7uilv7T0z4+4A==
X-Google-Smtp-Source: AMsMyM5qnhpllhRG2HKj/CG2nloo2ZUCnGNX01syZ4Z9PMofeVZUxk7mfTuQotLNdmwmS810AYgEjA==
X-Received: by 2002:a5d:69ca:0:b0:228:dd17:9534 with SMTP id s10-20020a5d69ca000000b00228dd179534mr6602076wrw.652.1663964058126;
        Fri, 23 Sep 2022 13:14:18 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:14:17 -0700 (PDT)
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
Subject: [PATCH v2 33/35] selftest/nettest: Rename md5_prefix* => auth_prefix*
Date:   Fri, 23 Sep 2022 21:13:17 +0100
Message-Id: <20220923201319.493208-34-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now it's going to be used for TCP-AO testing too.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/net/nettest.c | 28 +++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 35831bc3da24..3a887ef783cd 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -97,11 +97,11 @@ struct sock_args {
 
 	const char *password;
 	/* prefix for MD5 password */
-	const char *md5_prefix_str;
+	const char *auth_prefix_str;
 	union {
 		struct sockaddr_in v4;
 		struct sockaddr_in6 v6;
-	} md5_prefix;
+	} auth_prefix;
 	unsigned int prefix_len;
 	/* 0: default, -1: force off, +1: force on */
 	int bind_key_ifindex;
@@ -271,7 +271,7 @@ static int tcp_md5sig(int sd, void *addr, socklen_t alen, struct sock_args *args
 		md5sig.tcpm_flags |= TCP_MD5SIG_FLAG_PREFIX;
 
 		md5sig.tcpm_prefixlen = args->prefix_len;
-		addr = &args->md5_prefix;
+		addr = &args->auth_prefix;
 	}
 	memcpy(&md5sig.tcpm_addr, addr, alen);
 
@@ -311,13 +311,13 @@ static int tcp_md5_remote(int sd, struct sock_args *args)
 	switch (args->version) {
 	case AF_INET:
 		sin.sin_port = htons(args->port);
-		sin.sin_addr = args->md5_prefix.v4.sin_addr;
+		sin.sin_addr = args->auth_prefix.v4.sin_addr;
 		addr = &sin;
 		alen = sizeof(sin);
 		break;
 	case AF_INET6:
 		sin6.sin6_port = htons(args->port);
-		sin6.sin6_addr = args->md5_prefix.v6.sin6_addr;
+		sin6.sin6_addr = args->auth_prefix.v6.sin6_addr;
 		addr = &sin6;
 		alen = sizeof(sin6);
 		break;
@@ -750,11 +750,11 @@ static int convert_addr(struct sock_args *args, const char *_str,
 	case ADDR_TYPE_MD5_PREFIX:
 		desc = "md5 prefix";
 		if (family == AF_INET) {
-			args->md5_prefix.v4.sin_family = AF_INET;
-			addr = &args->md5_prefix.v4.sin_addr;
+			args->auth_prefix.v4.sin_family = AF_INET;
+			addr = &args->auth_prefix.v4.sin_addr;
 		} else if (family == AF_INET6) {
-			args->md5_prefix.v6.sin6_family = AF_INET6;
-			addr = &args->md5_prefix.v6.sin6_addr;
+			args->auth_prefix.v6.sin6_family = AF_INET6;
+			addr = &args->auth_prefix.v6.sin6_addr;
 		} else
 			return 1;
 
@@ -837,8 +837,8 @@ static int validate_addresses(struct sock_args *args)
 	    convert_addr(args, args->remote_addr_str, ADDR_TYPE_REMOTE) < 0)
 		return 1;
 
-	if (args->md5_prefix_str &&
-	    convert_addr(args, args->md5_prefix_str,
+	if (args->auth_prefix_str &&
+	    convert_addr(args, args->auth_prefix_str,
 			 ADDR_TYPE_MD5_PREFIX) < 0)
 		return 1;
 
@@ -2020,7 +2020,7 @@ int main(int argc, char *argv[])
 			args.password = optarg;
 			break;
 		case 'm':
-			args.md5_prefix_str = optarg;
+			args.auth_prefix_str = optarg;
 			break;
 		case 'S':
 			args.use_setsockopt = 1;
@@ -2079,13 +2079,13 @@ int main(int argc, char *argv[])
 	}
 
 	if (args.password && (!args.use_md5 ||
-	      (!args.has_remote_ip && !args.md5_prefix_str) ||
+	      (!args.has_remote_ip && !args.auth_prefix_str) ||
 	      args.type != SOCK_STREAM)) {
 		log_error("MD5 passwords apply to TCP only and require a remote ip for the password\n");
 		return 1;
 	}
 
-	if ((args.md5_prefix_str || args.use_md5) && !args.password) {
+	if ((args.auth_prefix_str || args.use_md5) && !args.password) {
 		log_error("Prefix range for MD5 protection specified without a password\n");
 		return 1;
 	}
-- 
2.37.2

