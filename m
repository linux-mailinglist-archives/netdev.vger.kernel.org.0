Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D14E4449B9
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 21:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhKCUuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 16:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhKCUuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 16:50:39 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761DFC061714;
        Wed,  3 Nov 2021 13:48:02 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id n128so4412448iod.9;
        Wed, 03 Nov 2021 13:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tZbv5aAJ4v4EiF6Cmu6oZo1oYCe3bfoiySGK/sxgW9U=;
        b=EmC0sO8kvotE0Y/JF+uh8zs3/jRRnvL7cpGsCyZtvzDbf98RBFq0jeRYmTxJaGJk1t
         G0+Nbx4Njz+Eegpj5depBexDs/b77GUpkCn1FwzQuV5NWu3nSotD17lc7mbe2ecLImSe
         N2jv/M2DzLKMUDPfQT1ztpgbZ58fBjce0yPV5lPdAwafXbcQRQ62ZYInAi/viaSSAHJS
         7tvMxe0sWalef4i0UZiN7gXnnZz6sLSqz9P53KWwFNCSqOr/q9zZJEugt6yS+cD7ECgU
         2bRHr4b5T0TvD4sdK+HyUJ/MLi8fxRm3Cw1SHpTurw4ioaGgP3/V7tv+LaZYZ3yr1leT
         GGQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tZbv5aAJ4v4EiF6Cmu6oZo1oYCe3bfoiySGK/sxgW9U=;
        b=eR1orXVtGFGQ5pANCdofurlgY8dStd2JHk2cmJhpK4SJaFxqzT4Xf7ldGOxUICYBCJ
         HqSPopvFVVu/26oedsMf2Ms56uPEV/UX3jB+dNcAiwdiQtJgc43pVCX43eGnEt7viZzZ
         4X3SnU4QZAYyZvFPHOim7g/TBElFvgQ2o5lnVi9yM+HjaMgzflBbqiR3xgX1iuKzkZJS
         M0Bngk5NY2ex9rldZL5gyV9g/KuQNENCgHue43CvX3HSuMBzlDQlRJgh9eO62mubw8h4
         ngYIzpPz7cym6ksuHctUhYKOPfBSY4QW8muD1OxwtgogvsrKv95xOl9f2pgFlgE6zvKt
         EfsQ==
X-Gm-Message-State: AOAM530UlfW4E3zn06y/V15GwrXqBzUbaKACS0pOAa0ZMjHPJXVCwU/e
        PGhy5myRTdc4BPV4mZGa4A8ySWnCEmFE4Q==
X-Google-Smtp-Source: ABdhPJwXxmXoBceyGqG7yK+/s057O5be1LAh1K42KqNJ97TgBgrgaoyz9NRxQ0e7AqQIa/b4wYkNpg==
X-Received: by 2002:a05:6602:2ccf:: with SMTP id j15mr19127128iow.77.1635972481622;
        Wed, 03 Nov 2021 13:48:01 -0700 (PDT)
Received: from john.lan ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id y11sm1507612ior.4.2021.11.03.13.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:48:01 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     daniel@iogearbox.net, joamaki@gmail.com, xiyou.wangcong@gmail.com,
        jakub@cloudflare.com, john.fastabend@gmail.com
Subject: [PATCH bpf v2 1/5] bpf, sockmap: Use stricter sk state checks in sk_lookup_assign
Date:   Wed,  3 Nov 2021 13:47:32 -0700
Message-Id: <20211103204736.248403-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211103204736.248403-1-john.fastabend@gmail.com>
References: <20211103204736.248403-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to fix an issue with sockets in TCP sockmap redirect cases
we plan to allow CLOSE state sockets to exist in the sockmap. However,
the check in bpf_sk_lookup_assign currently only invalidates sockets
in the TCP_ESTABLISHED case relying on the checks on sockmap insert
to ensure we never SOCK_CLOSE state sockets in the map.

To prepare for this change we flip the logic in bpf_sk_lookup_assign()
to explicitly test for the accepted cases. Namely, a tcp socket in
TCP_LISTEN or a udp socket in TCP_CLOSE state. This also makes the
code more resilent to future changes.

Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h | 12 ++++++++++++
 net/core/filter.c     |  6 ++++--
 net/core/sock_map.c   |  6 ------
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index b4256847c707..584d94be9c8b 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -507,6 +507,18 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 	return !!psock->saved_data_ready;
 }
 
+static inline bool sk_is_tcp(const struct sock *sk)
+{
+	return sk->sk_type == SOCK_STREAM &&
+	       sk->sk_protocol == IPPROTO_TCP;
+}
+
+static inline bool sk_is_udp(const struct sock *sk)
+{
+	return sk->sk_type == SOCK_DGRAM &&
+	       sk->sk_protocol == IPPROTO_UDP;
+}
+
 #if IS_ENABLED(CONFIG_NET_SOCK_MSG)
 
 #define BPF_F_STRPARSER	(1UL << 1)
diff --git a/net/core/filter.c b/net/core/filter.c
index 8e8d3b49c297..a68418268e92 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10423,8 +10423,10 @@ BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
 		return -EINVAL;
 	if (unlikely(sk && sk_is_refcounted(sk)))
 		return -ESOCKTNOSUPPORT; /* reject non-RCU freed sockets */
-	if (unlikely(sk && sk->sk_state == TCP_ESTABLISHED))
-		return -ESOCKTNOSUPPORT; /* reject connected sockets */
+	if (unlikely(sk && sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN))
+		return -ESOCKTNOSUPPORT; /* only accept TCP socket in LISTEN */
+	if (unlikely(sk && sk_is_udp(sk) && sk->sk_state != TCP_CLOSE))
+		return -ESOCKTNOSUPPORT; /* only accept UDP socket in CLOSE */
 
 	/* Check if socket is suitable for packet L3/L4 protocol */
 	if (sk && sk->sk_protocol != ctx->protocol)
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index e252b8ec2b85..f39ef79ced67 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -511,12 +511,6 @@ static bool sock_map_op_okay(const struct bpf_sock_ops_kern *ops)
 	       ops->op == BPF_SOCK_OPS_TCP_LISTEN_CB;
 }
 
-static bool sk_is_tcp(const struct sock *sk)
-{
-	return sk->sk_type == SOCK_STREAM &&
-	       sk->sk_protocol == IPPROTO_TCP;
-}
-
 static bool sock_map_redirect_allowed(const struct sock *sk)
 {
 	if (sk_is_tcp(sk))
-- 
2.33.0

