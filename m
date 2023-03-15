Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF486BB833
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjCOPnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjCOPnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:43:02 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DA8975A
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m13-20020a25800d000000b00b3dfeba6814so9732758ybk.11
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678894978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dlkJqv0b0Jem9BwwJCn3175Kp26LnlRSt2mhLf1rgJw=;
        b=L1OrWZzqWO4U8JLmwN7arX4Mls1srN+H90FWfXx6S6tefkuy0IKYOicZXMwhb+oEEI
         JsIAOy4pNFtB660WWTael+2fiVwwjxlmNIb/E4ELk0hU3wt4ZXmP0Fx2NLBcgglt1N2b
         ehkj0Wa/BZGOMJ9Vylj8XR9yCmmyXoLbTCpOaVUtA1yeUwvZFZQE0wIKIrhdzpwcRFRa
         7ofE0nqSJXSW/mkUxyTWIEd7//12t3ij9ebOlK9RMLjgTlWFQlmmzVUTbN7AgmKqek4w
         c+XUB7abMmS5er5bPP3jX8cAYL9Oxu1G/dx5w51vK2i2FHb6H/P0tMXHcxBHs7IuI46s
         a1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678894978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dlkJqv0b0Jem9BwwJCn3175Kp26LnlRSt2mhLf1rgJw=;
        b=sJ9l7JlyJU5DBRU14pD3+nm0Tw+EtEqSzOlIfGRxqlepI12fyDfDymQxOke9TGdTK0
         YAGjxyemACeup8bN9G/xWTxm7X12sgC5xOQKXEPy4LAusAMpkyOr2KFXGCZizl9EX2eL
         enQwFVT/LFvLru0xqt7O7p7IPFIKDGUM59unsEFM5ZsMp2gymvJnTBRP1dAGMgr/0SOR
         w4eh+fVgwQd0yvMtKdxblnoEqh2IehCwWNcJTDhdPWSZr8Adu7BOBnKyWYNxYKz/tmZ6
         a8Kr3rwJIHmy2Q3lZYzZXMfSCODU3FFX7VCneL3hh/GD8uNMU+bf7Ulzr7MrvcmtSkgB
         nmlw==
X-Gm-Message-State: AO0yUKXr7Albx9pkUKwiM4WUduce7hI0WI4m/FC8EP0Ed58+zm+YrJ4L
        xovYoYnEd7cZpXnPSULM1OM8CRMnXeHXCQ==
X-Google-Smtp-Source: AK7set8IhlNqZeVsGMufz+PNOl3ycNCTKla8J9pZYbAw9AJD2w2TFf235W/238+Mq97PVLgFiL361mabfwEGMg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:4417:0:b0:541:6d4c:9276 with SMTP id
 r23-20020a814417000000b005416d4c9276mr205995ywa.5.1678894977933; Wed, 15 Mar
 2023 08:42:57 -0700 (PDT)
Date:   Wed, 15 Mar 2023 15:42:44 +0000
In-Reply-To: <20230315154245.3405750-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315154245.3405750-8-edumazet@google.com>
Subject: [PATCH net-next 7/8] ipv4: raw: constify raw_v4_match() socket argument
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This clarifies raw_v4_match() intent.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/raw.h | 2 +-
 net/ipv4/raw.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/raw.h b/include/net/raw.h
index 2c004c20ed996d1dbe07f2c8d25edd2ce03cca03..7ad15830cf38460f1fae3a187986d74faef6dd1d 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -22,7 +22,7 @@
 extern struct proto raw_prot;
 
 extern struct raw_hashinfo raw_v4_hashinfo;
-bool raw_v4_match(struct net *net, struct sock *sk, unsigned short num,
+bool raw_v4_match(struct net *net, const struct sock *sk, unsigned short num,
 		  __be32 raddr, __be32 laddr, int dif, int sdif);
 
 int raw_abort(struct sock *sk, int err);
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 94df935ee0c5a83a4b1393653b79ac6060b4f12a..3cf68695b40ddc0e79c8fbd62f317048cf5c88e3 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -116,10 +116,10 @@ void raw_unhash_sk(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(raw_unhash_sk);
 
-bool raw_v4_match(struct net *net, struct sock *sk, unsigned short num,
+bool raw_v4_match(struct net *net, const struct sock *sk, unsigned short num,
 		  __be32 raddr, __be32 laddr, int dif, int sdif)
 {
-	struct inet_sock *inet = inet_sk(sk);
+	const struct inet_sock *inet = inet_sk(sk);
 
 	if (net_eq(sock_net(sk), net) && inet->inet_num == num	&&
 	    !(inet->inet_daddr && inet->inet_daddr != raddr) 	&&
-- 
2.40.0.rc1.284.g88254d51c5-goog

