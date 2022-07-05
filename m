Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA1B5671C3
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbiGEPCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbiGEPBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:01:54 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878D715739;
        Tue,  5 Jul 2022 08:01:52 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id be14-20020a05600c1e8e00b003a04a458c54so7409032wmb.3;
        Tue, 05 Jul 2022 08:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SCyYZfevfzncrr2ZRaiwUivx5wLa+/wrAD8N6KE8FTk=;
        b=N28TNU1LrOgBz8bu3KKLxHMPsVF51gf6znnZspVrXdu6ClOrlZ/wdBGd8iABY3eObR
         kfO/pFRH0c0QIzJdusD7ySOXKXxcSi2me11Jz6IPfs8ttCCnFN2NDEu3p8Q8xJaGv8CR
         yC1AIiQ1NICSGPkJo5mS3d6E34B7g3W4/33UU3dpmNk1EvcmdfaNIzzleDUA+/aiTs89
         n/YbH2L4yOVbfvjwVjLv1h6o5+GiBd3KytKXvEk4WQEvQwCsh3WAOBZ0su9xOd9BEhk/
         n8nmfkBaFYqKW3BWywBKxkYgFy9jMaZMR6eUB5sP7yskPqwJJI98Ee1ttNFJJsW6l1k0
         BsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SCyYZfevfzncrr2ZRaiwUivx5wLa+/wrAD8N6KE8FTk=;
        b=Pp6sbuzCbBPQSTeHMakTlDihJKT+rRiTI4HDtN4TIzVe37SkNKOOkOgcltH2mw+TFp
         G7sfxQAmqhQbiCwZ8ndM40tgh1x01LcNaG+K0Wi730Ds32iJYPFyqRFH3cSZ6Ik3KF6Y
         kD1PXzuMzBtBNGTppQe9PvV/AOr97zGgzd+19Wftb69DxUTE2ruR1zZ4H7KhWpMSl4JC
         ZeO2ooIEKKm8TpqLeCSb/2nEXFeaHvaVnpDoufFYZYx8/Ue7CvkJU/9PpMcO8dtCTlDd
         NeRjGYxYLIZN1buoW/r3StD7YFg/lwjGlnJhc13uHBjPqmTD6rIawE7IE8MIQeLdJPl5
         XlBg==
X-Gm-Message-State: AJIora9QsISNZWLluJOYRlOxzdMxRsKaqH0v+KjnO8eExn0lZikOGUq/
        DWAJtw7U2k7wwuld5zbVwpCk8wk07FzNRQ==
X-Google-Smtp-Source: AGRyM1tl1xTiJ8iAj/GyHkhpPH3ky/+OmcWi0FLD5rIUnAYXUpOw7bZZ4u7UnQoF9g9/OhotV5Cv8g==
X-Received: by 2002:a05:600c:3b1d:b0:3a2:60a1:fe30 with SMTP id m29-20020a05600c3b1d00b003a260a1fe30mr10797775wms.193.1657033310609;
        Tue, 05 Jul 2022 08:01:50 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:01:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 03/25] skbuff: add SKBFL_DONT_ORPHAN flag
Date:   Tue,  5 Jul 2022 16:01:03 +0100
Message-Id: <0504267c0e7d8a4300949aa571d3459bf0d526aa.1656318994.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656318994.git.asml.silence@gmail.com>
References: <cover.1656318994.git.asml.silence@gmail.com>
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
index d3d10556f0fa..8e12b3b9ad6c 100644
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
@@ -3182,8 +3185,7 @@ static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
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

