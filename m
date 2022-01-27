Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B4E49D6D3
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbiA0Agu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234040AbiA0Agp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:36:45 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D8CC061751;
        Wed, 26 Jan 2022 16:36:45 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a8so2084978ejc.8;
        Wed, 26 Jan 2022 16:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f76VCmw6L1xq+F3n85MyvmtgQ0vjtDYX1QQFC+2rnWw=;
        b=BHocNtloAkh991Vev1wdeaPq962WdUAWrH0gTeYZa5Qr4GkgzAlj91092gbZ3hfows
         KW81zysv2dFH8rJoLeR9krplJUAw0Bj/q01FRPIetqDjbHD/NAxAsm7jwJoH6/1eaD72
         hAFJReMR99f5ntiNhg20spSk/BsnOxRntaz1bbYcuWi5yWLLZxxYoR3O2FHFZaSFNVcY
         zxZLJEyb84nNW50KML1Qj5glsrBFsPmtpi0qVKCU+W8OkB5YKY8+t/ZsFBjp2Gar5/0D
         QcLuXoGPAI9bucHHvZMBcUHHwEPRdyfCYpBZ/RiHnAcRjWSKADI4w48lNVLod9nClZnP
         T/+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f76VCmw6L1xq+F3n85MyvmtgQ0vjtDYX1QQFC+2rnWw=;
        b=xe+MpBDmodfcos5vbq3IbBUcQZiU1aRwI37s5sNi9k5DBXftGbI18Bo4+9OEfOcSxU
         2pbC7IDpvXcCsaLyCSjGyE6kQVgY0oyXc4Nwmg/jYpIzZys9zLdynRlXMiMVqFqEZGYM
         uyC3Oowl6k+EBzLKAyNztIaceUiA94SEpOFOsZPhcQEc2hYBJ3cIKrXkZUMxA8HEgrtf
         uSrgsnst8TaqDpt1ejC5fYicGkwhiW8y1P1eKU3FZb5vEaU+Q1G8zGf+cnKQv4KI5tPW
         LjcDoWUJzbej92/En4b+rzEtzqombNl/pImqj+brDyweflyCZI1tcvN1HxPrEIltuEg9
         ozTA==
X-Gm-Message-State: AOAM533KTpcbfuPkaqxISbS6mJQwQzJJ5XauKrTzitwv95dmQvD9YoB3
        avkpCMUyEH1AFi6yyrD/uy+JbGjYB8A=
X-Google-Smtp-Source: ABdhPJz+kvaEfq525bjPdM95RrJW6W70jSOXDDrflqgVF2/p/oiYVG0gwdaQh75KbJ2Qr69+ttFUqw==
X-Received: by 2002:a17:907:7d93:: with SMTP id oz19mr1064241ejc.350.1643243803620;
        Wed, 26 Jan 2022 16:36:43 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id op27sm8039235ejb.103.2022.01.26.16.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:36:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v2 07/10] udp6: pass flow in ip6_make_skb together with cork
Date:   Thu, 27 Jan 2022 00:36:28 +0000
Message-Id: <f335e8665f0914c7b70e92086c5a833aee18504d.1643243773.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1643243772.git.asml.silence@gmail.com>
References: <cover.1643243772.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another preparation patch. inet_cork_full already contains a field for
iflow, so we can avoid passing a separate struct iflow6 into
__ip6_append_data() and ip6_make_skb(), and use the flow stored in
inet_cork_full. Make sure callers set cork->fl, i.e. we init it in
ip6_append_data() and before calling ip6_make_skb().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/ipv6.h    |  2 +-
 net/ipv6/ip6_output.c | 20 +++++++++-----------
 net/ipv6/udp.c        |  4 +++-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 3afcb128e064..5e0b56d66724 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1020,7 +1020,7 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
 			     void *from, int length, int transhdrlen,
-			     struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
+			     struct ipcm6_cookie *ipc6,
 			     struct rt6_info *rt, unsigned int flags,
 			     struct inet_cork_full *cork);
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 62da09819750..0cc490f2cfbf 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1350,7 +1350,7 @@ static void ip6_append_data_mtu(unsigned int *mtu,
 
 static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 			  struct inet6_cork *v6_cork, struct ipcm6_cookie *ipc6,
-			  struct rt6_info *rt, struct flowi6 *fl6)
+			  struct rt6_info *rt)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	unsigned int mtu;
@@ -1391,7 +1391,6 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 	}
 	dst_hold(&rt->dst);
 	cork->base.dst = &rt->dst;
-	cork->fl.u.ip6 = *fl6;
 	v6_cork->hop_limit = ipc6->hlimit;
 	v6_cork->tclass = ipc6->tclass;
 	if (rt->dst.flags & DST_XFRM_TUNNEL)
@@ -1422,7 +1421,6 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 }
 
 static int __ip6_append_data(struct sock *sk,
-			     struct flowi6 *fl6,
 			     struct sk_buff_head *queue,
 			     struct inet_cork_full *cork_full,
 			     struct inet6_cork *v6_cork,
@@ -1434,6 +1432,7 @@ static int __ip6_append_data(struct sock *sk,
 {
 	struct sk_buff *skb, *skb_prev = NULL;
 	struct inet_cork *cork = &cork_full->base;
+	struct flowi6 *fl6 = &cork_full->fl.u.ip6;
 	unsigned int maxfraglen, fragheaderlen, mtu, orig_mtu, pmtu;
 	struct ubuf_info *uarg = NULL;
 	int exthdrlen = 0;
@@ -1786,19 +1785,19 @@ int ip6_append_data(struct sock *sk,
 		 * setup for corking
 		 */
 		err = ip6_setup_cork(sk, &inet->cork, &np->cork,
-				     ipc6, rt, fl6);
+				     ipc6, rt);
 		if (err)
 			return err;
 
+		inet->cork.fl.u.ip6 = *fl6;
 		exthdrlen = (ipc6->opt ? ipc6->opt->opt_flen : 0);
 		length += exthdrlen;
 		transhdrlen += exthdrlen;
 	} else {
-		fl6 = &inet->cork.fl.u.ip6;
 		transhdrlen = 0;
 	}
 
-	return __ip6_append_data(sk, fl6, &sk->sk_write_queue, &inet->cork,
+	return __ip6_append_data(sk, &sk->sk_write_queue, &inet->cork,
 				 &np->cork, sk_page_frag(sk), getfrag,
 				 from, length, transhdrlen, flags, ipc6);
 }
@@ -1967,9 +1966,8 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
 			     void *from, int length, int transhdrlen,
-			     struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
-			     struct rt6_info *rt, unsigned int flags,
-			     struct inet_cork_full *cork)
+			     struct ipcm6_cookie *ipc6, struct rt6_info *rt,
+			     unsigned int flags, struct inet_cork_full *cork)
 {
 	struct inet6_cork v6_cork;
 	struct sk_buff_head queue;
@@ -1986,7 +1984,7 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 	cork->base.opt = NULL;
 	cork->base.dst = NULL;
 	v6_cork.opt = NULL;
-	err = ip6_setup_cork(sk, cork, &v6_cork, ipc6, rt, fl6);
+	err = ip6_setup_cork(sk, cork, &v6_cork, ipc6, rt);
 	if (err) {
 		ip6_cork_release(cork, &v6_cork);
 		return ERR_PTR(err);
@@ -1994,7 +1992,7 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 	if (ipc6->dontfrag < 0)
 		ipc6->dontfrag = inet6_sk(sk)->dontfrag;
 
-	err = __ip6_append_data(sk, fl6, &queue, cork, &v6_cork,
+	err = __ip6_append_data(sk, &queue, cork, &v6_cork,
 				&current->task_frag, getfrag, from,
 				length + exthdrlen, transhdrlen + exthdrlen,
 				flags, ipc6);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 3af1eea739a8..44b7ca9bd78e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1533,9 +1533,11 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		struct inet_cork_full cork;
 		struct sk_buff *skb;
 
+		cork.fl.u.ip6 = fl6;
+
 		skb = ip6_make_skb(sk, getfrag, msg, ulen,
 				   sizeof(struct udphdr), &ipc6,
-				   &fl6, (struct rt6_info *)dst,
+				   (struct rt6_info *)dst,
 				   msg->msg_flags, &cork);
 		err = PTR_ERR(skb);
 		if (!IS_ERR_OR_NULL(skb))
-- 
2.34.1

