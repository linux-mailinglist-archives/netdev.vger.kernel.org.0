Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F53648A504
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346385AbiAKBZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346278AbiAKBY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:24:58 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3FFC061201;
        Mon, 10 Jan 2022 17:24:54 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id e9so28605860wra.2;
        Mon, 10 Jan 2022 17:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WLXW72viCdTqGqSUN8B/wJ3y6rx1ShnvlX/6mgA/9Xo=;
        b=MkjnzgdbarY2G24kMTnfTMWw6YO8KJWOBRn54o2VeMv0jtN+dexJXKD+8Z1DK919ru
         q/3brEep39XVdvqSuZgYNScFXx9oaAL8rONzamI7ygfiE5Oo2W/UURrzZM14YVgg36LS
         ZweIIOzK5IXbjmsgnJx3F9RP5hCysuEQmZkwB8lfamfkY5T7RykQ5jIUPdCA0q/vZzJT
         tctGCY/6KEHzZcFUt8U1Qv5yIvVNbmeudk0JzRZMG45aDbiITS9ggJDRhQdg+4OgYga9
         sHz/+n0SaqvT0xHInAcW0GyYS3Ip4tI6pVRrE7iopfmrx6mHouoowfYm0KvH3e2044fk
         9zDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WLXW72viCdTqGqSUN8B/wJ3y6rx1ShnvlX/6mgA/9Xo=;
        b=Nuol8Ou7Ulw0L89tgPhL4wOzKG7n3/DT3WnliAHyX519eJ80O1uwqqx4g+GBuAEkV1
         NabQ+8ALn5Bj/ICwQkQdtjDGu9ZRvV3jmd1PlOIC6ZfsHhKYlTfAMpXXmlBQZDQvormr
         /EH9rvIOdpCkoHmVZbDxMwGgnY8W15PyJwh5576vAjJCp3CW4XO7UuOaiER/JA81RlfL
         kg+sr0CoW7I/bPyVK3opX3Ab0PkF2G9dJUPZtoaIXdhmuN5B0z69iOL1NaeBl5miu4Xm
         tLzMG5u2l+RL7IJpvOJnNpFg90plWPjzp59/qOsxL6TL606Olysm8+O36lg5CCTbtsge
         Ygmg==
X-Gm-Message-State: AOAM530JqpHggTfEPM9OBgUNQ3w7Xv3WxGWC7agb+L+A8gpXMc+MGvi7
        8SrBq8dijHKKe1pKXlZjxloT3SRZUO8=
X-Google-Smtp-Source: ABdhPJyEJu/8rM2j1jKQ83BmKsi1GeVilEWi6/P7o3ocKooP95U+H6dO2+/HMuP86/309RGcBqKr+A==
X-Received: by 2002:a05:6000:c8:: with SMTP id q8mr1723397wrx.611.1641864292947;
        Mon, 10 Jan 2022 17:24:52 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 09/14] ipv6: hand dst refs to cork setup
Date:   Tue, 11 Jan 2022 01:21:42 +0000
Message-Id: <07031c43d3e5c005fbfc76b60a58e30c66d7c620.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During cork->dst setup, ip6_make_skb() gets an additional reference to
a passed in dst. However, udpv6_sendmsg() doesn't need dst after calling
ip6_make_skb(), and so we can save two additional atomics by passing
dst references to ip6_make_skb(). udpv6_sendmsg() is the only caller, so
it's enough to make sure it doesn't use dst afterwards.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 9 ++++++---
 net/ipv6/udp.c        | 3 ++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 0cc490f2cfbf..6a7bba4dd04d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1356,6 +1356,8 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 	unsigned int mtu;
 	struct ipv6_txoptions *nopt, *opt = ipc6->opt;
 
+	cork->base.dst = &rt->dst;
+
 	/*
 	 * setup for corking
 	 */
@@ -1389,8 +1391,6 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 
 		/* need source address above miyazawa*/
 	}
-	dst_hold(&rt->dst);
-	cork->base.dst = &rt->dst;
 	v6_cork->hop_limit = ipc6->hlimit;
 	v6_cork->tclass = ipc6->tclass;
 	if (rt->dst.flags & DST_XFRM_TUNNEL)
@@ -1784,6 +1784,7 @@ int ip6_append_data(struct sock *sk,
 		/*
 		 * setup for corking
 		 */
+		dst_hold(&rt->dst);
 		err = ip6_setup_cork(sk, &inet->cork, &np->cork,
 				     ipc6, rt);
 		if (err)
@@ -1974,8 +1975,10 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 	int exthdrlen = (ipc6->opt ? ipc6->opt->opt_flen : 0);
 	int err;
 
-	if (flags & MSG_PROBE)
+	if (flags & MSG_PROBE) {
+		dst_release(&rt->dst);
 		return NULL;
+	}
 
 	__skb_queue_head_init(&queue);
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index eec83e34ae27..3039dff7fe64 100644
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

