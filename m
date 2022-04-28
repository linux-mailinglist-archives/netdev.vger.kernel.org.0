Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E075131E0
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344734AbiD1LAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244981AbiD1LAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:00:43 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED3090CD9;
        Thu, 28 Apr 2022 03:57:28 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id w4so6204525wrg.12;
        Thu, 28 Apr 2022 03:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OEhPbS9UUEhMm7nsZ+7/eveIRRgkUDZKIVimBlj5lFI=;
        b=KTciY6PvBq1fAnq4w68NlQlhBJHjFuI79NLjB9db1OiSiBxq8WVdb5jY9pRWLTpDM4
         voTxFI1p1jt7jjHhuRv1d8wrbgR6NSKe1QeVMBJHPpDMqfNKlhXdmUKgVIraL0zOiHOF
         BQHeGovGAayCOxY1iyz/GMrRKvYssIkKh2l3V7MViYmOyHnGmGB2/y9Q+Oh3hLtJv5lL
         pPQEyzOc1mGgfym9Vw79AkhfgZj6GMOeclIAwECiJtl6AaLqKQySz/gFTP9ihcXetOvY
         WfsUWKGJIC+uTOm1qflcn88MkAGw/r6XeGlq4DayFRCwvsN+Lg1a+J/PbfpDeqnFv1eR
         GIgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OEhPbS9UUEhMm7nsZ+7/eveIRRgkUDZKIVimBlj5lFI=;
        b=Ihl9Mn2PJYgXSO2xR31KdF5QFKOY8DyKoe/OIpVnAT/PTQleF82BUTo0MgUBcHIfti
         P7jjWBNj4Ud8csZQw6K/59dnGx0EneOgOCqAkNfFZMDG2OQKY/5lOh/OEzgvwMoAFHZ9
         OyE5xeq92PFpe4FHON3KVjzYuakrBkWOmaGvOcOgWlr/7l3AgVUcZDISnXEVPZ2XJkxG
         /gBWFLRXMWXQhXbobxkzS3WNOEVZ0wlXszlPA4LIfJ7UDTd/l6a/3ULRdmrHXpxNOv27
         u3MnX32rp8BNSSoalr4HPHd4gZ7IIH0sEZNaaWZmsDuzRCznR5gbHmPv32ma/PMaL3C/
         NTaw==
X-Gm-Message-State: AOAM533Rr9nt1AQJpsEuB66p5xJZXkTDDPsWHJ426l5zrvn2QRXGrItr
        IMKjXxuw43jz7XJwYxAg6KU2sTEkiBI=
X-Google-Smtp-Source: ABdhPJzwmwvrRlcN/KPvdpTzjXIc9JAbsUfzKpvMU2hcfxXqXibaISCptYJWNuTbtb3jelE5ezLtJA==
X-Received: by 2002:a05:6000:18c9:b0:203:fb67:debe with SMTP id w9-20020a05600018c900b00203fb67debemr25691169wrq.494.1651143446899;
        Thu, 28 Apr 2022 03:57:26 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 01/11] ipv6: optimise ipcm6 cookie init
Date:   Thu, 28 Apr 2022 11:56:32 +0100
Message-Id: <64341db6ca5a1f4d1eebbe86a7ee0b7d7400335e.1651071843.git.asml.silence@gmail.com>
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
index 1f3d777e7694..976554d0fdec 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -2001,8 +2001,6 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 		ip6_cork_release(cork, &v6_cork);
 		return ERR_PTR(err);
 	}
-	if (ipc6->dontfrag < 0)
-		ipc6->dontfrag = inet6_sk(sk)->dontfrag;
 
 	err = __ip6_append_data(sk, &queue, cork, &v6_cork,
 				&current->task_frag, getfrag, from,
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 0d7c13d33d1a..4582e432fa9f 100644
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
index db9449b52dbe..de8382930910 100644
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

