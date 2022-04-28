Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF1F5135E7
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347869AbiD1OCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347858AbiD1OCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:02:03 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE85054FB5;
        Thu, 28 Apr 2022 06:58:48 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id m20so9716288ejj.10;
        Thu, 28 Apr 2022 06:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OEhPbS9UUEhMm7nsZ+7/eveIRRgkUDZKIVimBlj5lFI=;
        b=omuFmVbFmUOMDqtROASIHcSfMyZkpFuPF1GwAY9KcxlascuXyE+AMZVGAaGwOWIY1S
         ym8ZcJYBJPJrn2jN6LDco3YJHgvdfGVSuTwUo4vJMmI/puo26KmCUBUf5/M4oM2X1Xhx
         aQgaBUeGJUot9+xmWwPmelbGvxRA3m65dqJTVhK5Zkt0h5v4onWTrrilXLEG9L7aXp3t
         Tia93LSxEpeqUCtQSMc5NtN1jbsUG6bP60x5RNaJ7d7cjYDhrFPNiPM6SNfIr2ViddAD
         65NHMZEDzaIlUXuSfEo3Z01raRdYKeFvTR0n8bxzdmT8EbjFe3sfrRHM6RRbKS6wRYYF
         i6qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OEhPbS9UUEhMm7nsZ+7/eveIRRgkUDZKIVimBlj5lFI=;
        b=fpxYjI/qXnGtNYtHJH8IsByOU+j/WowkM1yBq84acyNTJE+LPWhNN3u8M+PcH5bA8b
         La2FWmC1dYcWKP5xzkMEyIsmUhPZFt2K7SBnPq4qMs/iEzjWfpGUhJWHC/xxQyymffMW
         gFNenSJRgynJGodzo4/oMHHp5y/5RiOHiLnZNSrHJzz/e7FwPZQkUJx5xNtzoQRl3znJ
         gwJnfwMGvlDJ50aICqdCdaaJhLBowiKq4+c1QcUvLAnjYI8BZDUrWDveDCehBkaOB6tz
         S7C3I05ct0o5wRv3gHTx0SWBhvYLsBhpDhVFI32JxmVXoCkauGf7ja8sfmJDThV2iAN5
         hvng==
X-Gm-Message-State: AOAM531/J1cP4cz1tFOBMYmVsP9J/qZc5iv0VNo4g9oWZNq205Des4cX
        kEPnGc/lv1+TBagUGtrgJzRvAPo9L1Y=
X-Google-Smtp-Source: ABdhPJzIqr6TOs8gcajLm7jw8RmYW0yfqZg4ikRYIfxe9F3mWA7FyYyFJfoIT3dcwsRhbDkWxff7iQ==
X-Received: by 2002:a17:907:6ea4:b0:6f3:87c8:21cc with SMTP id sh36-20020a1709076ea400b006f387c821ccmr23228049ejc.490.1651154327180;
        Thu, 28 Apr 2022 06:58:47 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id t19-20020aa7d4d3000000b0042617ba63c2sm1652568edr.76.2022.04.28.06.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:58:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 net-next 01/11] ipv6: optimise ipcm6 cookie init
Date:   Thu, 28 Apr 2022 14:57:56 +0100
Message-Id: <64341db6ca5a1f4d1eebbe86a7ee0b7d7400335e.1651153920.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651153920.git.asml.silence@gmail.com>
References: <cover.1651153920.git.asml.silence@gmail.com>
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

