Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EB24F09A0
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358587AbiDCNKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358727AbiDCNK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:29 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E2F24F1D
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:33 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id u16so10666216wru.4
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HTOkaQJQEwGkCyutV8MTQiPLjfsdfmVwwswGO/KW+7M=;
        b=D96me3xUOgLSErFmTBzGLsVo4dugLrvAGWI50PgZhJOZFNolF8SfrkGGkwSKjhe4gY
         SBIwN9mqiI1zAKiV5YioAJDXkjjWcdZI9XD6JAsadveT2D6E2nTQNet3RLSV2HBhGN+F
         8ELsSZFdXqM/8/vtJAaZgc7norUPBfTEl5RhMkcnPXu8jDuyEhF/Oz1mqDR6A7JJMHtn
         8vZ9YpsF+s+8WArj3VGg5kb7xI9F1p6G7LOEF1ZY3kBsdLAxAVAYsiG8HTPrRZSCCzFV
         4e6wLnywuuLCP6vZQwRuLBORQ9RBb7m3zE54odWtZOYTftPpuSQDrZuKt9dFySkqQnu7
         bDqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HTOkaQJQEwGkCyutV8MTQiPLjfsdfmVwwswGO/KW+7M=;
        b=3NuZfNy5HpvHdwf0yTe5ByHlO/VUdLIHvZYXgHYTYPkFxDJkEy6zqBpO1k6THtj51m
         XGCVMsD0ig40niF7UdkXdiNWPZXipuJYf/7XOLisJVzL6vo19OqKgquqVLQXmXvjf+U/
         XNgLcwF+GbFVTgJaQdu7IAOYsuN49WI6jIGmUiat4aXKlc3DZ47N5bHWdTVojME0tEtF
         +OfeYRI/HnMfBR4AC1z7Q0hu9vNGF0NTtgX+MtZT8hhThsO07XCyRAPhzUUq6RPtPn6Z
         69eyVAagqztbyvR8AVO9C4JJcM6H6C0mfuE9M+fVe3CDKPY2juf58R3cQLN3LlpgEzgG
         s8Ng==
X-Gm-Message-State: AOAM531lLCdha59OiK1tqgMxEW90swX56rhLWa5lOX1FAesno+OXRcG2
        TVJGtfXzVcFRUdyreRmXcws+r3RR3/8=
X-Google-Smtp-Source: ABdhPJzzpc4WYTcmFDYxmrQACLwJ5AQhOAMi0wEfP9RR5YgURAgyzBETFT9S2OyMtoA5EPQgi7zfWg==
X-Received: by 2002:adf:eb81:0:b0:1e3:2bf5:132 with SMTP id t1-20020adfeb81000000b001e32bf50132mr13800044wrn.246.1648991311572;
        Sun, 03 Apr 2022 06:08:31 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 18/27] net: optimise ipcm6 cookie init
Date:   Sun,  3 Apr 2022 14:06:30 +0100
Message-Id: <15066b7067614521d47e679c7cadac044d70bd30.1648981571.git.asml.silence@gmail.com>
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

Users of ipcm6_init() have a somewhat complex post initialisation
of ->dontfrag and ->tclass. Not only it adds additional overhead,
but also complicates the code.

First, replace ipcm6_init() with ipcm6_init_sk(). As it might be not an
equivalent change, let's first look at ->dontfrag. The logic was to set
it from cmsg if specified and otherwise fallback to np->dontfrag. Now
it's initialising to np->dontfrag in the beginning and then potentially
overriding with cmsg, which is absolutely the same behaviour.

It's a bit more complex with ->tclass as ip6_datagram_send_ctl() might
set it to -1, which is a default and not valid value. The solution
here is to skip -1's specified in cmsg, so it'll be left with the socket
default value getting us to the old behaviour.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/ipv6.h    | 9 ---------
 net/ipv6/datagram.c   | 4 ++--
 net/ipv6/ip6_output.c | 2 --
 net/ipv6/raw.c        | 8 +-------
 net/ipv6/udp.c        | 7 +------
 net/l2tp/l2tp_ip6.c   | 8 +-------
 6 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 48a25f663646..2f2d9af58f05 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -352,15 +352,6 @@ struct ipcm6_cookie {
 	struct ipv6_txoptions *opt;
 };
 
-static inline void ipcm6_init(struct ipcm6_cookie *ipc6)
-{
-	*ipc6 = (struct ipcm6_cookie) {
-		.hlimit = -1,
-		.tclass = -1,
-		.dontfrag = -1,
-	};
-}
-
 static inline void ipcm6_init_sk(struct ipcm6_cookie *ipc6,
 				 const struct ipv6_pinfo *np)
 {
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 206f66310a88..1b334bc855ae 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -1003,9 +1003,9 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 			if (tc < -1 || tc > 0xff)
 				goto exit_f;
 
+			if (tc != -1)
+				ipc6->tclass = tc;
 			err = 0;
-			ipc6->tclass = tc;
-
 			break;
 		    }
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4319364a4a8c..bd5de7a5aa8c 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -2003,8 +2003,6 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 		ip6_cork_release(cork, &v6_cork);
 		return ERR_PTR(err);
 	}
-	if (ipc6->dontfrag < 0)
-		ipc6->dontfrag = inet6_sk(sk)->dontfrag;
 
 	err = __ip6_append_data(sk, &queue, cork, &v6_cork,
 				&current->task_frag, getfrag, from,
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index c51d5ce3711c..0e0156938968 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -808,7 +808,7 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	fl6.flowi6_mark = sk->sk_mark;
 	fl6.flowi6_uid = sk->sk_uid;
 
-	ipcm6_init(&ipc6);
+	ipcm6_init_sk(&ipc6, np);
 	ipc6.sockc.tsflags = sk->sk_tsflags;
 	ipc6.sockc.mark = sk->sk_mark;
 
@@ -920,9 +920,6 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (hdrincl)
 		fl6.flowi6_flags |= FLOWI_FLAG_KNOWN_NH;
 
-	if (ipc6.tclass < 0)
-		ipc6.tclass = np->tclass;
-
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
 	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
@@ -933,9 +930,6 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (ipc6.hlimit < 0)
 		ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
 
-	if (ipc6.dontfrag < 0)
-		ipc6.dontfrag = np->dontfrag;
-
 	if (msg->msg_flags&MSG_CONFIRM)
 		goto do_confirm;
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7f0fa9bd9ffe..4b15b37fc8f9 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1313,7 +1313,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	int is_udplite = IS_UDPLITE(sk);
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 
-	ipcm6_init(&ipc6);
+	ipcm6_init_sk(&ipc6, np);
 	ipc6.gso_size = READ_ONCE(up->gso_size);
 	ipc6.sockc.tsflags = sk->sk_tsflags;
 	ipc6.sockc.mark = sk->sk_mark;
@@ -1518,9 +1518,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
 
-	if (ipc6.tclass < 0)
-		ipc6.tclass = np->tclass;
-
 	fl6->flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6->flowlabel);
 
 	dst = ip6_sk_dst_lookup_flow(sk, fl6, final_p, connected);
@@ -1566,8 +1563,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	up->pending = AF_INET6;
 
 do_append_data:
-	if (ipc6.dontfrag < 0)
-		ipc6.dontfrag = np->dontfrag;
 	up->len += ulen;
 	err = ip6_append_data(sk, getfrag, msg, ulen, sizeof(struct udphdr),
 			      &ipc6, fl6, (struct rt6_info *)dst,
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 96f975777438..4459926f5840 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -521,7 +521,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	fl6.flowi6_mark = sk->sk_mark;
 	fl6.flowi6_uid = sk->sk_uid;
 
-	ipcm6_init(&ipc6);
+	ipcm6_init_sk(&ipc6, np);
 
 	if (lsa) {
 		if (addr_len < SIN6_LEN_RFC2133)
@@ -608,9 +608,6 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
 
-	if (ipc6.tclass < 0)
-		ipc6.tclass = np->tclass;
-
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
 	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
@@ -622,9 +619,6 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (ipc6.hlimit < 0)
 		ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
 
-	if (ipc6.dontfrag < 0)
-		ipc6.dontfrag = np->dontfrag;
-
 	if (msg->msg_flags & MSG_CONFIRM)
 		goto do_confirm;
 
-- 
2.35.1

