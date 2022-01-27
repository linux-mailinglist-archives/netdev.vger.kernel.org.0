Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E89E49D6DA
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbiA0Ag5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbiA0Ags (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:36:48 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6520C061748;
        Wed, 26 Jan 2022 16:36:47 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id u24so1377589eds.11;
        Wed, 26 Jan 2022 16:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mi+XPD0Dq+TrYWW1iZbOOEuiNokMVOo4lyf3EzZclVM=;
        b=gzkcPtjcGKG3ROk4gg/haSeVuFp1ik6ZH/VGo9HdXJO8TvGjTZMUG6a1wdbdBJBTVD
         WbMe43y/k8nWmPgVxEnvbYPtFprw7vuplrABcP/XJlwS4wHDGYiH3BRg8oNRQOjduhDg
         GYvHBK2oMbDu5rxuuFZKxnOUdGvwFFXOLT6Hr6752BqiRk8G+e55tWanJM0aOIjrDrmO
         igxEn0iXpLNvEl98MYgcyoovpmouQ9rp+L8UZbIVRKPbvLD5Kgd4qItPDrtMwQzG4511
         bOB5juTa/jkOuaHYQFx0vWDLOOIxk0yY1G2kxvGE0dok8Hlh0DN9bn3AZ9IX30dAQH5T
         E8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mi+XPD0Dq+TrYWW1iZbOOEuiNokMVOo4lyf3EzZclVM=;
        b=uMBTT3eIK/ZPbnVS8/YDTKzXB+OxWi3NPSlv8bE9peTUZIbydeSQmTiY8V3KM76lTG
         1zzylw054izE9wjZPLtdY0110e1Rdqct87xyTHFcOhALzvyuuyDvWIv4USFbLFjDbeB4
         8QqHMuCbFwXsc2/775Fg4h5v7K/39ZnboZSczz3R8XFh10fA3JM9mpOxudmTdPwYyKTH
         DRPUoBZs5GLwoNdiZ5nnCNGqnJPeNxfBRA/DERwYbHjekeGz/Q21LudKclWtHutAUgRT
         Uk2iMGbdhlLvIKy6spob8vLFMVIadUe4kHDXah9gMf64uX5kM2WJrpJoxjgPtYta9H1C
         G25A==
X-Gm-Message-State: AOAM531LaLPyQ3iR1/aJp2AmAfeiMFcEQjMbyHQoHpelTSHCYm2CNPm+
        6wZFiqkNdwb/K9rdDSxxgiYrEAUJUcg=
X-Google-Smtp-Source: ABdhPJwiP8z9E9KeZuiw7aip3tEDkd9tV8HYv9hbSCG6N9NvFb9+kDb7Er9ehV2bra0q4zvv0v8rpQ==
X-Received: by 2002:a05:6402:348c:: with SMTP id v12mr1415681edc.384.1643243805648;
        Wed, 26 Jan 2022 16:36:45 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id op27sm8039235ejb.103.2022.01.26.16.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:36:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v2 09/10] ipv6: optimise dst refcounting on cork init
Date:   Thu, 27 Jan 2022 00:36:30 +0000
Message-Id: <6c2a202cb1b22936624133d189bf2d95a1ab8eac.1643243773.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1643243772.git.asml.silence@gmail.com>
References: <cover.1643243772.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

udpv6_sendmsg() doesn't need dst after calling ip6_make_skb(), so
instead of taking an additional reference inside ip6_setup_cork()
and releasing the initial one afterwards, we can hand over a reference
into ip6_make_skb() saving two atomics. The only other user of
ip6_setup_cork() is ip6_append_data() and it requires an extra
dst_hold().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 13 +++++++++----
 net/ipv6/udp.c        |  3 ++-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 0cc490f2cfbf..0c6c971ce0a5 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1356,6 +1356,11 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 	unsigned int mtu;
 	struct ipv6_txoptions *nopt, *opt = ipc6->opt;
 
+	/* callers pass dst together with a reference, set it first so
+	 * ip6_cork_release() can put it down even in case of an error.
+	 */
+	cork->base.dst = &rt->dst;
+
 	/*
 	 * setup for corking
 	 */
@@ -1389,8 +1394,6 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 
 		/* need source address above miyazawa*/
 	}
-	dst_hold(&rt->dst);
-	cork->base.dst = &rt->dst;
 	v6_cork->hop_limit = ipc6->hlimit;
 	v6_cork->tclass = ipc6->tclass;
 	if (rt->dst.flags & DST_XFRM_TUNNEL)
@@ -1784,6 +1787,7 @@ int ip6_append_data(struct sock *sk,
 		/*
 		 * setup for corking
 		 */
+		dst_hold(&rt->dst);
 		err = ip6_setup_cork(sk, &inet->cork, &np->cork,
 				     ipc6, rt);
 		if (err)
@@ -1974,15 +1978,16 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 	int exthdrlen = (ipc6->opt ? ipc6->opt->opt_flen : 0);
 	int err;
 
-	if (flags & MSG_PROBE)
+	if (flags & MSG_PROBE) {
+		dst_release(&rt->dst);
 		return NULL;
+	}
 
 	__skb_queue_head_init(&queue);
 
 	cork->base.flags = 0;
 	cork->base.addr = 0;
 	cork->base.opt = NULL;
-	cork->base.dst = NULL;
 	v6_cork.opt = NULL;
 	err = ip6_setup_cork(sk, cork, &v6_cork, ipc6, rt);
 	if (err) {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index cfcf08c3df4d..c6872596b408 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1541,7 +1541,8 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		err = PTR_ERR(skb);
 		if (!IS_ERR_OR_NULL(skb))
 			err = udp_v6_send_skb(skb, fl6, &cork.base);
-		goto out;
+		/* ip6_make_skb steals dst reference */
+		goto out_no_dst;
 	}
 
 	lock_sock(sk);
-- 
2.34.1

