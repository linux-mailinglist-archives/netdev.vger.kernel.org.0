Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAC048A4FB
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346288AbiAKBZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346297AbiAKBZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:25:00 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC6CC061751;
        Mon, 10 Jan 2022 17:24:58 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id v6so30028683wra.8;
        Mon, 10 Jan 2022 17:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cLHZNKxSVLlIqt82iN+00oFOdp+Zw3lomAl6fzMW3gQ=;
        b=E97YACHjCfA9o7nbBNMoNuGTlk5ww1E/pGt2T80i6nTf4voJ2+m973msMByvGKfZCg
         /r6Ed2lI9aPTOLEvnqghjaiORTGYlmiuSRHrcfmihkwlN8klBoSoE0zINvH7S+6C26pd
         LJxNq5+VJWLOGrUpynL3eY6qvEUM4MlKIPDH5L/aPvv5EGMUgl7mRnbCg1jARTmCNGqN
         30SNuXC8K9Fhf8i6+FcOx01SAVQEnkd9kdhqD76voNUgqV5JsFkAxugZ8cqQkvsUdZM6
         ZwacmybXvQzyv+lfOe8r6IRu1+SbFNy9ZnuyR+eNqhOIwofkSlwkB75efOAJxLALBSrm
         kuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cLHZNKxSVLlIqt82iN+00oFOdp+Zw3lomAl6fzMW3gQ=;
        b=3lDCfBnpJuAaL8LD9SvM8hg8LB1nExcq4RHZxGW9v1wPDSDuulJBFAyD2aFO9ZH92I
         L93j0k8hOxREYiGlmB63y5whIBv3p5268ShZVQf18yJ8iK1PjRrenwuW3x6vHgp20RE7
         X2Md/JmOF7wLE6yJptiMvj2LN2+TAlOoi6waPDkgjVSlD5sid0xikYUdPKpqOXlo3w2X
         Zf2Q1PZnNkfNcQb/9BjshhjA670dPX6Rwi9a4k+vyZ5lq4kFDQPdmRE39zptTV8QSlHb
         KqdlmugY3C2xH+gjDxbvpbrb+qJg4NasDkMOC9K2GAgtGkWk1Ylg8dEk+pVwvmgsjfbk
         NuRA==
X-Gm-Message-State: AOAM530kgevx0dVPsIVDk3B+qVa6WMernXVcEP01i3Wulkaj0vWk2N/r
        yanXUkSO1VaugNzTOcijOzJ6PQYQBN8=
X-Google-Smtp-Source: ABdhPJycmpPYwVnA2PBfXK/arNpJX02Fu1XAxJuzT/SY1+MVe/Q1mQCyMv4OBHocREiUHjedv1S+9g==
X-Received: by 2002:a05:6000:1866:: with SMTP id d6mr1702705wri.704.1641864297269;
        Mon, 10 Jan 2022 17:24:57 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 14/14] net: inline sock_alloc_send_skb
Date:   Tue, 11 Jan 2022 01:21:47 +0000
Message-Id: <00f1789794462df0bd2f23bd9672cc7ddc740494.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_alloc_send_skb() is simple and just proxying to another function,
so we can inline it and cut associated overhead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/sock.h | 10 ++++++++--
 net/core/sock.c    |  7 -------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 7b4b4237e6e0..cde35481a152 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1810,11 +1810,17 @@ int sock_getsockopt(struct socket *sock, int level, int op,
 		    char __user *optval, int __user *optlen);
 int sock_gettstamp(struct socket *sock, void __user *userstamp,
 		   bool timeval, bool time32);
-struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
-				    int noblock, int *errcode);
 struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 				     unsigned long data_len, int noblock,
 				     int *errcode, int max_page_order);
+
+static inline struct sk_buff *sock_alloc_send_skb(struct sock *sk,
+						  unsigned long size,
+						  int noblock, int *errcode)
+{
+	return sock_alloc_send_pskb(sk, size, 0, noblock, errcode, 0);
+}
+
 void *sock_kmalloc(struct sock *sk, int size, gfp_t priority);
 void sock_kfree_s(struct sock *sk, void *mem, int size);
 void sock_kzfree_s(struct sock *sk, void *mem, int size);
diff --git a/net/core/sock.c b/net/core/sock.c
index e21485ab285d..25a266a429d4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2592,13 +2592,6 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 }
 EXPORT_SYMBOL(sock_alloc_send_pskb);
 
-struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
-				    int noblock, int *errcode)
-{
-	return sock_alloc_send_pskb(sk, size, 0, noblock, errcode, 0);
-}
-EXPORT_SYMBOL(sock_alloc_send_skb);
-
 int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct cmsghdr *cmsg,
 		     struct sockcm_cookie *sockc)
 {
-- 
2.34.1

