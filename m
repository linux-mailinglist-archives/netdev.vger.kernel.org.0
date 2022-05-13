Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0BD52660A
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381996AbiEMP1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381973AbiEMP0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:26:51 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799AA1EAC6;
        Fri, 13 May 2022 08:26:50 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ks9so16963943ejb.2;
        Fri, 13 May 2022 08:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DZu1vGyRJvfMSB/s4tV6H7jpwGcGvBtFQ856IXndPcQ=;
        b=ivSAc5Ss+bwVCXF2o/taX96YkXq4gte9BeFc7Rg2VFgcIsWH0dGBSYhGIygnmoPm4i
         XBFXk7J3W6zhPuPpUWYCL8lwFoA4nfiUY30cKBtVylzK1kkhMv18WLHqE82jA1e6fzkD
         ONRqucgLp/mzwCtmbW9+dby4B2iget/2OY4gm/m2QTysSpMNG0Qt+yVYbfqS06tATnW5
         rA4a9hT2t4ff73cnRLegbL0FrxjSpwkYJDhahPtQ3mp6IlD31fS6vrrRbY6spahqUQPp
         wAEGmI72MBVrYd0A/KrQQ+GyQgMXqd8NLJZkkyXu9Yq+8R4RkwtXaT6GOrLhyL7q/JBo
         UTwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DZu1vGyRJvfMSB/s4tV6H7jpwGcGvBtFQ856IXndPcQ=;
        b=BlwXdJ4n3zVlgvEgdw37d26MVuVoLBCVI8ZuSQIp4wb85Mew3ECjMHC46MPnXP8On+
         us6gSh8D2wX80b05XG9q+VNgbmQM9+K+oVctnke94S3vaLZuPElNEwjPQwLYwjwhaVkK
         V9jw9pfc1alMzcRBBO71QKiTShDESgvEWoVBrB/IW71mlsylvimgV30wF26gjArynPoe
         w6RPW4LvAkaNnYo/Uk07FMwK46apcZT9FOM21nR6r6u6sE+5GLfwbhhrcyZIWxIiYa/y
         WgBCYwguSdEaosnfL+fCPAuqmqCX6aSE1wx7Jj3McevXNh+rE7MmDKcCnPwqIJ+jRDft
         SvUg==
X-Gm-Message-State: AOAM533NcA2Y5B6DJiRdG7McIC8RzOqz7Z076VaoN5Sbq9t8ZVRnjhLM
        eVXPk78KfVMkW3otPbjze7bbtT5kUH8=
X-Google-Smtp-Source: ABdhPJwlCuJ5+0i7mNICVTNVdzBucflX4ovUlHMkVIj9lonecTBKgYbn0Id03159P+EQdmMkaogrbQ==
X-Received: by 2002:a17:907:960d:b0:6f4:3b68:8d55 with SMTP id gb13-20020a170907960d00b006f43b688d55mr4671925ejc.105.1652455608549;
        Fri, 13 May 2022 08:26:48 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.161])
        by smtp.gmail.com with ESMTPSA id j13-20020a508a8d000000b0042617ba63cbsm1015351edj.85.2022.05.13.08.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:26:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 02/10] udp/ipv6: move pending section of udpv6_sendmsg
Date:   Fri, 13 May 2022 16:26:07 +0100
Message-Id: <a0e7477985ef08c5f08f35b8c7336587c8adce12.1652368648.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1652368648.git.asml.silence@gmail.com>
References: <cover.1652368648.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move up->pending section of udpv6_sendmsg() to the beginning of the
function. Even though it require some code duplication for sin6 parsing,
it clearly localises the pending handling in one place, removes an extra
if and more importantly will prepare the code for further patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 70 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 28 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 11d44ed46953..85bff1252f5c 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1318,6 +1318,46 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	ipc6.sockc.tsflags = sk->sk_tsflags;
 	ipc6.sockc.mark = sk->sk_mark;
 
+	/* Rough check on arithmetic overflow,
+	   better check is made in ip6_append_data().
+	   */
+	if (unlikely(len > INT_MAX - sizeof(struct udphdr)))
+		return -EMSGSIZE;
+
+	getfrag  =  is_udplite ?  udplite_getfrag : ip_generic_getfrag;
+
+	/* There are pending frames. */
+	if (up->pending) {
+		if (up->pending == AF_INET)
+			return udp_sendmsg(sk, msg, len);
+
+		/* Do a quick destination sanity check before corking. */
+		if (sin6) {
+			if (msg->msg_namelen < offsetof(struct sockaddr, sa_data))
+				return -EINVAL;
+			if (sin6->sin6_family == AF_INET6) {
+				if (msg->msg_namelen < SIN6_LEN_RFC2133)
+					return -EINVAL;
+				if (ipv6_addr_any(&sin6->sin6_addr) &&
+				    ipv6_addr_v4mapped(&np->saddr))
+					return -EINVAL;
+			} else if (sin6->sin6_family != AF_UNSPEC) {
+				return -EINVAL;
+			}
+		}
+
+		/* The socket lock must be held while it's corked. */
+		lock_sock(sk);
+		if (unlikely(up->pending != AF_INET6)) {
+			/* Just now it was seen corked, userspace is buggy */
+			err = up->pending ? -EAFNOSUPPORT : -EINVAL;
+			release_sock(sk);
+			return err;
+		}
+		dst = NULL;
+		goto do_append_data;
+	}
+
 	/* destination address check */
 	if (sin6) {
 		if (addr_len < offsetof(struct sockaddr, sa_data))
@@ -1343,12 +1383,11 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		default:
 			return -EINVAL;
 		}
-	} else if (!up->pending) {
+	} else {
 		if (sk->sk_state != TCP_ESTABLISHED)
 			return -EDESTADDRREQ;
 		daddr = &sk->sk_v6_daddr;
-	} else
-		daddr = NULL;
+	}
 
 	if (daddr) {
 		if (ipv6_addr_v4mapped(daddr)) {
@@ -1365,31 +1404,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		}
 	}
 
-	/* Rough check on arithmetic overflow,
-	   better check is made in ip6_append_data().
-	   */
-	if (len > INT_MAX - sizeof(struct udphdr))
-		return -EMSGSIZE;
-
-	getfrag  =  is_udplite ?  udplite_getfrag : ip_generic_getfrag;
-	if (up->pending) {
-		if (up->pending == AF_INET)
-			return udp_sendmsg(sk, msg, len);
-		/*
-		 * There are pending frames.
-		 * The socket lock must be held while it's corked.
-		 */
-		lock_sock(sk);
-		if (likely(up->pending)) {
-			if (unlikely(up->pending != AF_INET6)) {
-				release_sock(sk);
-				return -EAFNOSUPPORT;
-			}
-			dst = NULL;
-			goto do_append_data;
-		}
-		release_sock(sk);
-	}
 	ulen += sizeof(struct udphdr);
 
 	memset(fl6, 0, sizeof(*fl6));
-- 
2.36.0

