Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131BA526607
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbiEMP0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381968AbiEMP0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:26:50 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D5D15803;
        Fri, 13 May 2022 08:26:48 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id g6so16976073ejw.1;
        Fri, 13 May 2022 08:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NS0EJAZp+0rPTLWVYJ93d+JB/ZGcAv8pGti3LVvcpjY=;
        b=pBrFe8nLsA/7V80wRN+351c6WWybUimGleeUAf24RlV0LTGjjhm5ab+MjuQjcQBJul
         CJN35ITxka9b/l/H6KtWmIjsB7v5tmb93kkJn8DbsjfpXjFWOPQiq/Z1chOB5TQ6Cgbt
         /0IgcrmPo3E0lk5/CiUl9O1+4RaXOLi7C7ZAKVEhzI8tOufEaKxJSwuBSFHSBYtu0Eqd
         kWnLFb9+GXbND653p6XQthJGOozx3t5VHlFiB52ohYZMpFDr7KVwIhpL7lSoOQh5o+t3
         xmH76BovwszxHdXAv/UsKXgei1uhB1JhjRfDJuICkMHxwDpd69vkjKKF7UtCwh+PugL8
         4weQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NS0EJAZp+0rPTLWVYJ93d+JB/ZGcAv8pGti3LVvcpjY=;
        b=8JrsZt+EDakugFeS0nK9Y5v36IsymSuuoluBCyvlK7WEC4CXJ9SWTW0YpnJMnbg2BV
         7K6bDOs1ylWtQjYZJjKu61FCuLJgCFdNSrSgLvzty8eVQdKSCT7C5LwfmAafbQR7ZHX7
         5FQVJTsvz5Gj7IfAXqu1fVzdYXjmV3Z/7cntoNDeC2KOfJQHpbtY+kczNGtJ9hz5bmEA
         UFSAPetj+voHCKYZZNtbYocpcr86cp38NQMb2USNqR780wbGY3al7SvBn/vRywnG3MMq
         dQsNdGRQw7glId2Pbhar7A2s0jwSRL/YWJ4+Fum2rTK6CFK6OW0wqXKtBmIHg79lA8KG
         pX8w==
X-Gm-Message-State: AOAM533vtl2PthyCxHDunGfpTKTFglz2etAdX4EHeQ3f7Db3l7EkDE6X
        A/Kshk8u41PSpalPm9mrXG+4AEPqiJ8=
X-Google-Smtp-Source: ABdhPJy/NcF7De6kBQUtNOI9zYRPteMz9Wi4814U2MisoOVBIQf6suFXIg5/EspUMXmxmhEWk3fXew==
X-Received: by 2002:a17:906:c14d:b0:6fd:dd02:7f81 with SMTP id dp13-20020a170906c14d00b006fddd027f81mr4943845ejc.722.1652455607267;
        Fri, 13 May 2022 08:26:47 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.161])
        by smtp.gmail.com with ESMTPSA id j13-20020a508a8d000000b0042617ba63cbsm1015351edj.85.2022.05.13.08.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:26:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 01/10] ipv6: optimise ipcm6 cookie init
Date:   Fri, 13 May 2022 16:26:06 +0100
Message-Id: <79c491627ca937a6528dd27a1ba6cecd822e1d8d.1652368648.git.asml.silence@gmail.com>
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

The common pattern for setting up ipcm6 cookies is to call ipcm6_init()
initialising ->dontfrag and tclass fields to -1, which is a special
value, and then if the fields haven't changed set it to some default
value. For instance

ipcm6_init(&ipc6); // ipc6.tclass = -1;
if (cmsg)
    ip6_datagram_send_ctl(&ipc6);
if (ipc6.tclass < 0)
    ipc6.tclass = np->tclass;

This prioritieses cmsg over the socket status. This patches changes it
to ipcm6_init_sk(), which initially sets those fields to the socket
default values, and then lets cmsg to override it:

ipcm6_init_sk(&ipc6); // ipc6.tclass = np->tclass;
if (cmsg)
    ip6_datagram_send_ctl(&ipc6);

It sets it to the cmsg value if specified and leaves the socket default
if not. One difference with this approach is when cmsg sets ->tclass to
the special value, i.e. -1, and the old version would catch it and
initialise. Thus, this patch also modifies ip6_datagram_send_ctl() to
ignore cmsg trying to assign -1 to the ->tclass field.

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
index 213612f1680c..30a3447e34b4 100644
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
index 39b2327edc4e..3a2ae188d08b 100644
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
index afa5bd4ad167..53c0e33e3899 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -2002,8 +2002,6 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 		ip6_cork_release(cork, &v6_cork);
 		return ERR_PTR(err);
 	}
-	if (ipc6->dontfrag < 0)
-		ipc6->dontfrag = inet6_sk(sk)->dontfrag;
 
 	err = __ip6_append_data(sk, &queue, cork, &v6_cork,
 				&current->task_frag, getfrag, from,
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 3b7cbd522b54..402e4d9e3f82 100644
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
index 3fc97d4621ac..11d44ed46953 100644
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
index 217c7192691e..12406789bb28 100644
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
2.36.0

