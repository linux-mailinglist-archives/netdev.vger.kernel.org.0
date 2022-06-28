Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F2C55ED37
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiF1TA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbiF1TAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:22 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE5DBF6C;
        Tue, 28 Jun 2022 11:59:57 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id cf14so18904716edb.8;
        Tue, 28 Jun 2022 11:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p79o1VsFDo3cqk77y+g7Vo/BbqY9LUCoOrOtB7thWXc=;
        b=kCuOg+JnsMVf2GKgp0FVpXjiZvxoJtJjry8oHlX2MssbI32rWwy5pOqbpWYl/RBv6n
         SdIUM9aZMrfxqcmVo3UCUY+52jLzD74eKkpiFxVYWBhEWKVl+0w1wMPJmIpJ7krtoHbL
         TAyV1MeBFVt/N3btF3lTG4qTgKw5Zinm3LfEqhuo9j8lcleifwMs29AyBkX7WPwKZOAI
         mx7xIIzJmuUEkc0NXSCSdCGg7uFnG3nZkfr+3lVNxcog3UlZ87R/loFGtMw5Wai+9OLn
         PSTmDIOfX5Zpv/71WkQHg9hOOmyEoGBqhvqDSovCuTCkB4nO94D/w7am3C/Hs1m/prj+
         WBig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p79o1VsFDo3cqk77y+g7Vo/BbqY9LUCoOrOtB7thWXc=;
        b=cXSv/acy3B54tgSvwe1Fai5TrefZeuxVD9ENeBVg/5pQjsJH0jGZeZMtjKh8ten/Bt
         Lj7q3YveqplpK9RScHQFevMYraIWyQMZ462toCe5l1cUz/orraMo0tRdy451IKXbYpCp
         z6oESamH3sWkrTOr0QrOYvYssknLhwWhLDipsuQ8Ay+8OS+qIfgGU48pN2T6qrlnmaUi
         o+pjwqf8ZABUMY9JRIJ+j55lQ2gXbXROLk7GDA/bsn7RfnXuI8b3pTeyANVHCnzCF4Vw
         92768xtB21MgKiRvp3jj4xXbLUr/ONe47efdcrlqpbLPKVY/jelNZlXocfCBJz4o3WIE
         6NAw==
X-Gm-Message-State: AJIora/2EdHjeYKCDj6uMfdolqizCsYvDuIK/vV8qRoRclo0TpvqeUvb
        FLARH2930BVq2EXgFD2U8FXhFFmGyrbHxg==
X-Google-Smtp-Source: AGRyM1sfveaW9Z0wUTJdyiH4ioJG+ffU6P3nXYR1U35Urv1GNQ5nJo6QrTpR64WlJRJWKdj/slZAPw==
X-Received: by 2002:a05:6402:5306:b0:437:8bbd:b313 with SMTP id eo6-20020a056402530600b004378bbdb313mr16741610edb.123.1656442796044;
        Tue, 28 Jun 2022 11:59:56 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.11.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:59:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 03/29] skbuff: add SKBFL_DONT_ORPHAN flag
Date:   Tue, 28 Jun 2022 19:56:25 +0100
Message-Id: <1def15f02ef8bcfe9fd80a4accd3c5af57675179.1653992701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1653992701.git.asml.silence@gmail.com>
References: <cover.1653992701.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't want to list every single ubuf_info callback in
skb_orphan_frags(), add a flag controlling the behaviour.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 8 +++++---
 net/core/skbuff.c      | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index da96f0d3e753..eead3527bdaf 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -686,10 +686,13 @@ enum {
 	 * charged to the kernel memory.
 	 */
 	SKBFL_PURE_ZEROCOPY = BIT(2),
+
+	SKBFL_DONT_ORPHAN = BIT(3),
 };
 
 #define SKBFL_ZEROCOPY_FRAG	(SKBFL_ZEROCOPY_ENABLE | SKBFL_SHARED_FRAG)
-#define SKBFL_ALL_ZEROCOPY	(SKBFL_ZEROCOPY_FRAG | SKBFL_PURE_ZEROCOPY)
+#define SKBFL_ALL_ZEROCOPY	(SKBFL_ZEROCOPY_FRAG | SKBFL_PURE_ZEROCOPY | \
+				 SKBFL_DONT_ORPHAN)
 
 /*
  * The callback notifies userspace to release buffers when skb DMA is done in
@@ -3175,8 +3178,7 @@ static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
 {
 	if (likely(!skb_zcopy(skb)))
 		return 0;
-	if (!skb_zcopy_is_nouarg(skb) &&
-	    skb_uarg(skb)->callback == msg_zerocopy_callback)
+	if (skb_shinfo(skb)->flags & SKBFL_DONT_ORPHAN)
 		return 0;
 	return skb_copy_ubufs(skb, gfp_mask);
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5b3559cb1d82..5b35791064d1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1193,7 +1193,7 @@ static struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
 	uarg->len = 1;
 	uarg->bytelen = size;
 	uarg->zerocopy = 1;
-	uarg->flags = SKBFL_ZEROCOPY_FRAG;
+	uarg->flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
 	refcount_set(&uarg->refcnt, 1);
 	sock_hold(sk);
 
-- 
2.36.1

