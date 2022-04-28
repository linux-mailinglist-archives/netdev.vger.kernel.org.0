Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F685131D1
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344476AbiD1LAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344526AbiD1LAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:00:45 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EE491368;
        Thu, 28 Apr 2022 03:57:30 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w4so6204628wrg.12;
        Thu, 28 Apr 2022 03:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mnpdGRyJiicLRHa2IgTDV7oi07PrHAZNJEbFWn+qIEE=;
        b=NReDgY8SnYmMb+IEoGqOxXCWkRmL5UADdjjFrnsD22OgiPs5rW8jNC3bBrZ9qnaE+Q
         s+hrSLW4xZfSt1YN8rV8BSBFlPPHPlGFpVrnPGZoRG0whRVWCjJMEbW5FjM5YxuXjnFn
         fFGVktocBgktRuv7KBK5fLlwyuhDuSePerSEEZhf+dxKLA1XaPlsBIh78KlH5hOGeRUm
         TfOMR79UV7GLyuQZD50jlQXY8iLrx3Sl/7YIVsya2Si2shsOkj6O7nmoKWyyHSlvSD/H
         8yMYVcv0FSo+u0t8g5dFuZGe3A9+0lkR9KPMlFV4XEGIgBbqoMy+i6m+uvx1IoK/9FrA
         sZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mnpdGRyJiicLRHa2IgTDV7oi07PrHAZNJEbFWn+qIEE=;
        b=7WAm2dqmM5oGF+ucn7D5CmSwBN/KTiGJa2f+0zTmaK09mzP7CSI25UrbUvuNSP4J6V
         mz501m49QhjBjbOTQzDlmD8abNycMbd5dWRoVOTBBeeVQB9GeKu7GYqy9kv7KuxLDEmI
         XhkMh6FmE/wQk79qoQA921JkduKohzk6F+mxQ7ws3jxR30YEn3tQfgNy6R9yk5890ZVO
         pbRrHOYae5vrw8SUe+vhY64IZGjzglGLUJ7C3Ea4XxMq1kPAt1bxWETvQ7rHoNZBrtGI
         noqUGzcWSNzTy1ffQqVwiVoFH/hlbhvz9f2wZtQSdJCuHcNXyRStHEkAMJx3uDPLXwog
         hOzQ==
X-Gm-Message-State: AOAM532wc3qA5a1otTqIPkqxqI8uUHKiesfkvyfoa+iT662lULhXvj+c
        O4SEjNGDKMjPQk1uOyokw6RDgTZGpZg=
X-Google-Smtp-Source: ABdhPJxteBSGREvfRY+StbvoICJq86d1XIraQhIw5UniH71CHKq4CAn8L5i9irrbztemiak/3zetSg==
X-Received: by 2002:a5d:6949:0:b0:20a:e021:f8e0 with SMTP id r9-20020a5d6949000000b0020ae021f8e0mr13677427wrw.231.1651143448613;
        Thu, 28 Apr 2022 03:57:28 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 02/11] udp/ipv6: refactor udpv6_sendmsg udplite checks
Date:   Thu, 28 Apr 2022 11:56:33 +0100
Message-Id: <33dfdf2119c86e35062f783d405bedec2fde2b4c.1651071843.git.asml.silence@gmail.com>
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

Don't save a IS_UDPLITE() result in advance but do when it's really
needed, so it doesn't store/load it from the stack. Same for resolving
the getfrag callback pointer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index de8382930910..705eea080f5e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1310,7 +1310,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	int ulen = len;
 	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int err;
-	int is_udplite = IS_UDPLITE(sk);
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 
 	ipcm6_init_sk(&ipc6, np);
@@ -1371,7 +1370,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (len > INT_MAX - sizeof(struct udphdr))
 		return -EMSGSIZE;
 
-	getfrag  =  is_udplite ?  udplite_getfrag : ip_generic_getfrag;
 	if (up->pending) {
 		if (up->pending == AF_INET)
 			return udp_sendmsg(sk, msg, len);
@@ -1538,6 +1536,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (!corkreq) {
 		struct sk_buff *skb;
 
+		getfrag = IS_UDPLITE(sk) ? udplite_getfrag : ip_generic_getfrag;
 		skb = ip6_make_skb(sk, getfrag, msg, ulen,
 				   sizeof(struct udphdr), &ipc6,
 				   (struct rt6_info *)dst,
@@ -1564,6 +1563,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 do_append_data:
 	up->len += ulen;
+	getfrag = IS_UDPLITE(sk) ? udplite_getfrag : ip_generic_getfrag;
 	err = ip6_append_data(sk, getfrag, msg, ulen, sizeof(struct udphdr),
 			      &ipc6, fl6, (struct rt6_info *)dst,
 			      corkreq ? msg->msg_flags|MSG_MORE : msg->msg_flags);
@@ -1594,7 +1594,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	 */
 	if (err == -ENOBUFS || test_bit(SOCK_NOSPACE, &sk->sk_socket->flags)) {
 		UDP6_INC_STATS(sock_net(sk),
-			       UDP_MIB_SNDBUFERRORS, is_udplite);
+			       UDP_MIB_SNDBUFERRORS, IS_UDPLITE(sk));
 	}
 	return err;
 
-- 
2.36.0

