Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0AE5131D9
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344886AbiD1LAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344584AbiD1LAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:00:48 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C994791572;
        Thu, 28 Apr 2022 03:57:31 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e2so6231040wrh.7;
        Thu, 28 Apr 2022 03:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6yhw3vAgS0ezr9ZZJU/0JZnt1IXk8RP1bpIj/xq+Zmg=;
        b=kNRkNepYRjTt3OO/dzEKnflD89KsNKu1Kvbz4prFIzFNNaqhwYJwOuzBIJP6tAFrun
         RBgWT0YezwcnT3451mLIH3JFwChWNI3VugicPEWt0BhdJzJC5voIsgIF6611VlOQrmf3
         NOeCySN/YcYX1L9L4f4mxoFugWaMplUMtP8KHG/fK/tf8lMCBXW4FqTvqoTbB9828l4X
         ycFxEJwsi1DEe+32v60oVzQfouje+zoSHAho1xJVxRa4YVh3VJLg/L9nrELyV/WqeR57
         Ok/b65AapdQpMrAXkh0UDG3on51Zsyab8HgMWz10dUqBLNfXJs1eR1JFJrdF7T9YleLa
         xDzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6yhw3vAgS0ezr9ZZJU/0JZnt1IXk8RP1bpIj/xq+Zmg=;
        b=gYsc8hzsuWJ8eEkul3/lYAuJ+WIA1bUff7fkMCFQcW3V5XmyDuReaeJRxz9xhr6VlO
         RIviPm6+zO7PrhRZ3y0eSkyKoYHn7Q24Y3zGTjHtV9kl5Jlp1RhVI2JXZklX2drRQt9n
         HxN46YS/lGKOSqRy/Tvaqtiv8xN4PH2xZqqpM8rCdT2Tq0qWRc5PAqzUTfbpK4PnONEj
         Er4mptKDc2v956klsraDLHUlhEQTqpbGmjOEvCFWwPlFdleFC1cO2PGEXHwAEnvNoo9D
         CTNXkHu5jZzPn3U3wuijmOvQMysshvn7FupfVFCKuF7aECBNkAVO25ZTFpoir8MpmnHx
         GKeA==
X-Gm-Message-State: AOAM532pqghmPWTPpvz4mRBdul/I56g1GAxAU67H6+DeB4PYPmJUd+tv
        EAYUDqXplk0cQa1QilxDH6enUBZkwJE=
X-Google-Smtp-Source: ABdhPJymMF7tAwz9Q34P4pRLt6oqtcgbCF5jnPFeLNTcEUDZB9szPs7nr15jcgL7ZRVSKdDguuS9Rg==
X-Received: by 2002:a5d:4dc7:0:b0:20a:ed1a:2c0 with SMTP id f7-20020a5d4dc7000000b0020aed1a02c0mr6983853wru.448.1651143450190;
        Thu, 28 Apr 2022 03:57:30 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 03/11] udp/ipv6: move pending section of udpv6_sendmsg
Date:   Thu, 28 Apr 2022 11:56:34 +0100
Message-Id: <4087b9a2cb175bca7c10404e33e8ba6c8de2ff1a.1651071843.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651071843.git.asml.silence@gmail.com>
References: <cover.1651071843.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 net/ipv6/udp.c | 67 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 27 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 705eea080f5e..d6aedd4dab25 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1317,6 +1317,44 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	ipc6.sockc.tsflags = sk->sk_tsflags;
 	ipc6.sockc.mark = sk->sk_mark;
 
+	/* Rough check on arithmetic overflow,
+	   better check is made in ip6_append_data().
+	   */
+	if (unlikely(len > INT_MAX - sizeof(struct udphdr)))
+		return -EMSGSIZE;
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
@@ -1342,12 +1380,11 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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
@@ -1364,30 +1401,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		}
 	}
 
-	/* Rough check on arithmetic overflow,
-	   better check is made in ip6_append_data().
-	   */
-	if (len > INT_MAX - sizeof(struct udphdr))
-		return -EMSGSIZE;
-
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

