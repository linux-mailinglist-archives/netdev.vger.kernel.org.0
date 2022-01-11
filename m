Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C846348A4ED
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346233AbiAKBYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346218AbiAKBYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:24:48 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B3DC061748;
        Mon, 10 Jan 2022 17:24:48 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id t28so23330835wrb.4;
        Mon, 10 Jan 2022 17:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BT3XL2h14/pezcVsoOCWrtTWDzvTfgkCTHxovQFgrLg=;
        b=L7xwYZl32JRKpFu828tuty+GdXEMSomqvAPirfx/5RUwnJZr3a0LxXZLcTQkjvezE2
         bMph9bVQmDgGWrC61bSUiQ92TE4geXhnPOmxdyOf9TutT3qdY+4SDbPRiJIUznhUFoSx
         5VqmdLW33xwmnW1TfCBHYib8KY4OODYkevCLz54enC0+wg+rZuUsZHOItDMdBW3yvKc5
         NecVZ2uzAljU6AylkKgPwMm2q5RlUUk0HcJUnDyHT9A0Mihx66BonVscJxeqt8onXQ8K
         zAY1XvB6RSbZeIwQzkeApYrJhI78j0wHiwKhWbclk3e+BFS/IJV45UQFU0mOvvs/WgGy
         qEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BT3XL2h14/pezcVsoOCWrtTWDzvTfgkCTHxovQFgrLg=;
        b=DjetEe6sfapXFTZyF81xkWyAULm0bvD3QS9VKeedNkppe6/c/laUY6vhxn5XHB4wPj
         B5IhNgwFdaEuwIkiSdeb99HkVOBkFY5Xsd7Z7UrWVk84H8gnt29VO0iCDtoGegSTlumm
         RA3bLIxa/YnRL2Zyj8PxTiIFJSFG1+0qgMEUFEcgCoYLr9PICj57Ho15oarZL6Q+y6l9
         0+pfLRkhSoE4N5MS4aSYPQeYsTKFDp8ziQGVpC6EjjgE2rbjoVhYaoPG6MTmpP7rONNh
         c7hm/R/Bjd8Z62AI47VmvB0PNyHdUwOMIQV2pLgkYpohTcMvJfwmt/NHPfKn8ZlAQmAF
         uNJw==
X-Gm-Message-State: AOAM533OPyAPZ166sT071qOf2JPmzw/zx0S9t1bjCNoEhQqXWIYa9NvE
        9kckx5z3OI9G9EobDmGeFSxJODWmgHw=
X-Google-Smtp-Source: ABdhPJwTTNhB9HsNsiWQYR6v+29ko06w+rxlZvGfmmOzusUfJDh+IBgSas2xohKnmVVRxIYf2BKA0w==
X-Received: by 2002:a5d:4588:: with SMTP id p8mr1709396wrq.649.1641864286635;
        Mon, 10 Jan 2022 17:24:46 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 03/14] ipv6: remove daddr temp buffer in __ip6_make_skb
Date:   Tue, 11 Jan 2022 01:21:35 +0000
Message-Id: <46d9179f641bd1349a68c6445378fad719aa0170.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__ip6_make_skb() doesn't actually need to keep an on-stack copy of
fl6->daddr because even though ipv6_push_nfrag_opts() may return a
different daddr it doesn't change the one that was passed in.
Just set final_dst to fl6->daddr and get rid of the temp copy.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 14d607ccfeea..4acd577d5ec5 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1843,7 +1843,7 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 {
 	struct sk_buff *skb, *tmp_skb;
 	struct sk_buff **tail_skb;
-	struct in6_addr final_dst_buf, *final_dst = &final_dst_buf;
+	struct in6_addr *final_dst;
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct net *net = sock_net(sk);
 	struct ipv6hdr *hdr;
@@ -1873,9 +1873,9 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 
 	/* Allow local fragmentation. */
 	skb->ignore_df = ip6_sk_ignore_df(sk);
-
-	*final_dst = fl6->daddr;
 	__skb_pull(skb, skb_network_header_len(skb));
+
+	final_dst = &fl6->daddr;
 	if (opt && opt->opt_flen)
 		ipv6_push_frag_opts(skb, opt, &proto);
 	if (opt && opt->opt_nflen)
@@ -1895,7 +1895,6 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 
 	skb->priority = sk->sk_priority;
 	skb->mark = cork->base.mark;
-
 	skb->tstamp = cork->base.transmit_time;
 
 	ip6_cork_steal_dst(skb, cork);
-- 
2.34.1

