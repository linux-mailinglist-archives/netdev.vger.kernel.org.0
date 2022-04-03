Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718944F09AB
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358592AbiDCNKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358765AbiDCNK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:29 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A6624596
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:35 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id w4so10596458wrg.12
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=va9zZWjDTCI1oJw3Kv1ZIgWs6fFF0wfjfDRP7pFWDs0=;
        b=UgV09UQozqN4AXwtXAhtfOvEF6cezzc3WCU/rr7kxaiO9l8rlULljUb1t9Vzeh910l
         UaZgb9A0cLXa8b93gX0QoX++QzqxxNDfIzh5stw6AwVBhAxo90sKD5ma0XN6Q9tyovRF
         F87KSWP8QZOnp4hfAO/0AaKEqlzppPPbV5cGZ3AsgZTRFgokoLIirzjK2jtDdVArEj4k
         OVDT0hTWjGjgOWGStIZApUc4yVywYOi3cjqIU2UdsotnbIAtLE8lH9mhgsrBP8c3O8gS
         lXLjIwIYtIZM3fguYs3qSz6AFtDrZQ4xtMOojw37MU9nnR4b95ZYA/Rzg8IPfNd0UsyL
         uMnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=va9zZWjDTCI1oJw3Kv1ZIgWs6fFF0wfjfDRP7pFWDs0=;
        b=YliJhX2vs6crVDh4Vjsi8qr7pgHbF87mw9w/XvDaxCtnxSfsDiFRITdxHmPc+BRhfA
         ObBC2FrgogMg+wU4tjK4MhHxjU4pUjsu34cE5bZH70QHDm4TFaiecELh6j5p51WLNbCJ
         DZMuISIgdkrG4tkmBVulU9B9gESHgbxqezxkxkL0stBs9zdjZePAyBmc4eKEo5bQbOI9
         gHYzgNT2zcX6Lr3JU9t9kVosiY21jBDlATXvd5vT15XNcNhJE0BOKo/Flbht9231kMKc
         pfbIQ5Qn2QhuDSORrJ3+eNtSRqOp4FYZ9vJjpnoGH9Eu5YGKEMKhF0HMW2vbFAACILtX
         JW4Q==
X-Gm-Message-State: AOAM532odVPzOT70P2J0OrzREZePZ8UfceC0Fa2wfd4jXgAKYP4hSRSt
        tC8z63TsnkdTzcTmIWRn+I+/ijGIvAw=
X-Google-Smtp-Source: ABdhPJyC8rIPCbJwhflo1WGJqkVtqx4xECfvBeMnmTQogkqTmQ8lp4bimfEfYOgj6eiX1NA/9O+mxg==
X-Received: by 2002:a05:6000:186d:b0:204:110a:d832 with SMTP id d13-20020a056000186d00b00204110ad832mr13936228wri.47.1648991313746;
        Sun, 03 Apr 2022 06:08:33 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 20/27] udp/ipv6: move pending section of udpv6_sendmsg
Date:   Sun,  3 Apr 2022 14:06:32 +0100
Message-Id: <f3e04d281c166c577bc25f30d250a1e89f81de97.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
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
 net/ipv6/udp.c | 67 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 27 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 588bd7e3ebc1..26832be40f31 100644
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
2.35.1

