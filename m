Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDC548A4F7
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346328AbiAKBZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346265AbiAKBY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:24:58 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6634C06175A;
        Mon, 10 Jan 2022 17:24:51 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id w26so4104506wmi.0;
        Mon, 10 Jan 2022 17:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZMPDzSjQOrUNWqC2VSg8brQGgBuhUXpA3LowQDg7QLw=;
        b=dRBROPBBDXjlIatKXI1B/6UOMPn5j/DxUxs0wV1kKWQnhHArRMCPXW6LJRB3bD2/KS
         4z3aWKZQ4e2KS3IqGQEqxXhjM5VG6leJ0p1arNRxy3bwT+FnzyW9gHGt7xScqIPfKCLP
         4yzD1DaSu9UP1d97toJ5sBNbCC7lhSp02ch7PdR9+7koi/UA0zmyKa419XoXOVqEQhb6
         wwy/vNOlCVHw/6TnvEujzSC5uzuhX28egYD+Sd1HA4tApHEwWt1wKPe6C55NjxMJG0dK
         VndFaLpK0GHp1gHLjPlPgRpNaAO1oY+SZsTi8zw+KyJ0K7f3vvlgbx0Kj0ANLW/15vwG
         PS8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZMPDzSjQOrUNWqC2VSg8brQGgBuhUXpA3LowQDg7QLw=;
        b=NegXgMZNikzkjf+2L7PeTO6Y/p04GJgc0t9ApzWwlvpli3h0/f+gQEUOtgkXw0yPLc
         ugu5xG+BA1fUWgACGhZq3Bgz7pt5rsLh6lGIp95dWkFt4Kw8nV787yWt/PjNhf3zFTGu
         xUNuOJkE8WED3iRweTAL11exfgRovIZtIh7KhsDmrVKY5nJ5wludvJR+ByFklD15ZSG0
         1YXBErF71WDmiU8tw0FSGGqNekHZ5NJervWsDs0lbwhPzxI6AP3AKfExhviQDwO+ddb+
         thGxgrmxkCaDEccpJ8a8j2yd+zLksK96bBtK9VSw0DcgJVcfC6SDMW3TX4dje0jbwelI
         /j6g==
X-Gm-Message-State: AOAM530h9RKgC8yh4R3RdiGDuI25N4dH7NyO0t0SSAlTKFQoEoGBNMXi
        x92r5QMlAcFJsdvN8hOwO/WJssTS1Rc=
X-Google-Smtp-Source: ABdhPJwZQMIAah5MNkGLIHGtWLlMBOSlkCIxtcWgoT3edWp8cvUpZyvRGSIrY4RDJjA8yh2Tv0RIcw==
X-Received: by 2002:a1c:f20e:: with SMTP id s14mr326748wmc.186.1641864290249;
        Mon, 10 Jan 2022 17:24:50 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 07/14] ipv6: pass flow in ip6_make_skb together with cork
Date:   Tue, 11 Jan 2022 01:21:39 +0000
Message-Id: <eae1be625797e0323e3e1e82b44cc0d716e2fcc9.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another preparation patch. inet_cork_full already contains a field for
iflow, so we can avoid passing a separate struct iflow6 into
__ip6_append_data() and ip6_make_skb(), and use the flow stored in
inet_cork_full. Make sure callers set cork->fl right, i.e. we init it in
ip6_append_data() and right before the only ip6_make_skb() call.

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
index 9a91b51d8e3f..2580705431ea 100644
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

