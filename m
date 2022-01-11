Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DFC48A506
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346242AbiAKBZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346276AbiAKBY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:24:58 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88191C061763;
        Mon, 10 Jan 2022 17:24:53 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id v6so30028433wra.8;
        Mon, 10 Jan 2022 17:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VF7qW9MiU4eh1yjhaJcwhWLAYV9D5NgZferfOVmnDng=;
        b=RFL+flfdaUFyAwgadVffktUDcR9+oGaC9ycYXE+rrxdbPzduih04zFJ1l11pqd5CmO
         LdUmNpjZhvV5J2lAYBzMmJVEU37vek2Rnb3mhWjTqWumlcKB+ZHc5dg4kKP9iC8zjZzP
         SOCajB8b3g1AWJhWlNnpWtsKhAXZiOvSBCGkgnaVdsB0uIDBZAE71L/zALAQclsjz0hT
         HIHIz4DdjgaPY34CiPd2s3+8G2usnMv+Orz6ZguhxHt/m6tEawEDIsjcjyfK9vY8eAzo
         UaIKreWVEYOfoRE8UfKsRReQvvSXHvE64DzUF6337tcY1FfJfhJ9UMJRciLCBLw3jbqO
         VbsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VF7qW9MiU4eh1yjhaJcwhWLAYV9D5NgZferfOVmnDng=;
        b=6YJpVx/SgYy4Zct+Dyfc/7HCjg0OYf+/1vgi8qAERbYvMVfU1/mkGcDTFBhBA7O1F9
         PaaJzyuPzoUsGvH5JZyhwHcGqeX4F3fM6W3X+WLgSjoU3arO5P+4gVMeg1yI4UXBL3cd
         ExCIcQKSeh2N69uo48T5URbcrl7GHZRwwnK+2yHPwWWdktvTjyqhjp2S2MGaDTMQ7Eux
         1rs5XciHuFMTQvBncm1dQZMMzp27TX9OUPPMZ3bv3arS4hUAnXUTGuoj5wFhzxziAXqd
         3wavNSRZRM+NzbiZBT9isC3xsVDq17NztTiVKQ5QCwSjg1X4j1OSMvr4a4Y6Qomf9qMG
         yung==
X-Gm-Message-State: AOAM530KCbUlGn0T4k38DLy0pqt39QDIUxtdLtB8N3nrycOjDQb56CQW
        FHT42gtFScxsHHuKdJWlIFQsaOdmZXg=
X-Google-Smtp-Source: ABdhPJzKLWxf8INCA2QCG/MLWEti+p3d6k2tMR32Xj9bAoeRt/pw3Sb9JsMAvVBOOgR7vSbbK/bQWA==
X-Received: by 2002:a5d:6dd1:: with SMTP id d17mr1813032wrz.520.1641864292033;
        Mon, 10 Jan 2022 17:24:52 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 09/14] ipv6: hand away dst refs to cork setup
Date:   Tue, 11 Jan 2022 01:21:41 +0000
Message-Id: <fd490bae030b05830d4a06577ef3a7bbd6ed1707.1641843758.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641843758.git.asml.silence@gmail.com>
References: <cover.1641843758.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

udpv6_sendmsg() doesn't need dst after calling into ip6_make_skb(),
however it still retains a ref and ip6_make_skb() has to do an addition
get/put pair. Hand over dst with the reference from
ip6_sk_dst_lookup_flow() to avoid two atomics.

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

