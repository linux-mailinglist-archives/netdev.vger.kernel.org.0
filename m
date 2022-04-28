Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECFDC5131F9
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345296AbiD1LET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345298AbiD1LDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:03:11 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017859D4E8;
        Thu, 28 Apr 2022 03:59:32 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r11-20020a05600c35cb00b0039409c1111bso1854598wmq.3;
        Thu, 28 Apr 2022 03:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r5k1ZTMK7mSQH9mXWos/hmZJEpLUd2ex8bU7xnkW7WU=;
        b=BiCbQzJ1UxgfgSMP82tJgGSeQrQZBhu4ySl2LOi6qrXumvH2JtQWELv7YQxIqBnX4x
         8tmxzOPLNtGKW/wYn8wGj5+HdNmnB20qh30CTdI67xC0DsqIbRLrqJNIezCj9qDPWuXk
         5uli2jnAE6TAO0LGz3AYIP4LAv7QIhZ6k0hvp5HyZl6xthOnYi/FZ68Cgv65bFz/nWjo
         pew3BkE6RMRQE7CF+kGZqjDP0gPlZaB7QvwfL0ZASPkvuaUr9hv9QpzVZfYjf9mhEQJI
         Ily8Xebav4k8Ejsbfhv1Xx51e1dsWSugFbOMYMLuUQApcEfZChYzV1J2oAcNgPHUfOQR
         M4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r5k1ZTMK7mSQH9mXWos/hmZJEpLUd2ex8bU7xnkW7WU=;
        b=Vn8tUkoZLRW7QaiF2ho/NsasvlQezC5l9Ltit66OzDHzBnqnuTG/pBuRc+04FWdS0I
         yFfyEqyLxiFfwwkNsIqjw6Ohu1GNC5Rt/dt1Fe2Eym6jOTfD2UGmqmAK4QZcoJgrqvHb
         LLoPNFUtHwTg6BCcKNgvPir+pZYAryNs2xQ3IVT6gyvVD4AiJsyPsj3sOOu0wyHqAoy4
         0yZvcA3tFkncXJDaFVppasMA5J5xV8ZocERVgnH25axx68UGdJCrriaMJNfoQG4RYCRF
         tayMpMhvrVi/0CoYZCwKJHyXWa3taz+7f2hxe5Q9ThwduuVQ2QN197I7AFI033TN+Y2a
         ZxAg==
X-Gm-Message-State: AOAM5307DPZLNiEjFvYgfeEdtsKmjvyEm0O443ER5R8MTTDJ2MgNZWbG
        0mUdlOLBumvlx0IiyUz4EKrQ5C2S2dw=
X-Google-Smtp-Source: ABdhPJybU48FPei64zykiGCI1HDY7wnNb5DGJdPnw67/1VDKwmUwYyv5obbnsCJ/5GqkULMBk/Izkg==
X-Received: by 2002:a7b:c844:0:b0:38e:7c92:a9e3 with SMTP id c4-20020a7bc844000000b0038e7c92a9e3mr29617741wml.140.1651143570314;
        Thu, 28 Apr 2022 03:59:30 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d588a000000b002052e4aaf89sm16028895wrf.80.2022.04.28.03.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:59:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 2/5] net: inline skb_zerocopy_iter_dgram
Date:   Thu, 28 Apr 2022 11:58:45 +0100
Message-Id: <2159b3b4ff6bfe623e9836468aefc866ee3b4ab6.1651141755.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651141755.git.asml.silence@gmail.com>
References: <cover.1651141755.git.asml.silence@gmail.com>
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

skb_zerocopy_iter_dgram() is a small proxy function, inline it. For
that, move __zerocopy_sg_from_iter into linux/skbuff.h

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 36 ++++++++++++++++++++++--------------
 net/core/datagram.c    |  2 --
 net/core/datagram.h    | 15 ---------------
 net/core/skbuff.c      |  7 -------
 4 files changed, 22 insertions(+), 38 deletions(-)
 delete mode 100644 net/core/datagram.h

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 84d78df60453..57182947cc80 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -684,20 +684,6 @@ struct ubuf_info {
 int mm_account_pinned_pages(struct mmpin *mmp, size_t size);
 void mm_unaccount_pinned_pages(struct mmpin *mmp);
 
-struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size);
-struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
-				       struct ubuf_info *uarg);
-
-void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
-
-void msg_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
-			   bool success);
-
-int skb_zerocopy_iter_dgram(struct sk_buff *skb, struct msghdr *msg, int len);
-int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
-			     struct msghdr *msg, int len,
-			     struct ubuf_info *uarg);
-
 /* This data is invariant across clones and lives at
  * the end of the header data, ie. at skb->end.
  */
@@ -1676,6 +1662,28 @@ static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
 }
 #endif
 
+struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size);
+struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
+				       struct ubuf_info *uarg);
+
+void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
+
+void msg_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
+			   bool success);
+
+int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
+			    struct iov_iter *from, size_t length);
+
+static inline int skb_zerocopy_iter_dgram(struct sk_buff *skb,
+					  struct msghdr *msg, int len)
+{
+	return __zerocopy_sg_from_iter(skb->sk, skb, &msg->msg_iter, len);
+}
+
+int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
+			     struct msghdr *msg, int len,
+			     struct ubuf_info *uarg);
+
 /* Internal */
 #define skb_shinfo(SKB)	((struct skb_shared_info *)(skb_end_pointer(SKB)))
 
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 70126d15ca6e..50f4faeea76c 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -62,8 +62,6 @@
 #include <trace/events/skb.h>
 #include <net/busy_poll.h>
 
-#include "datagram.h"
-
 /*
  *	Is a socket 'connection oriented' ?
  */
diff --git a/net/core/datagram.h b/net/core/datagram.h
deleted file mode 100644
index bcfb75bfa3b2..000000000000
--- a/net/core/datagram.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-
-#ifndef _NET_CORE_DATAGRAM_H_
-#define _NET_CORE_DATAGRAM_H_
-
-#include <linux/types.h>
-
-struct sock;
-struct sk_buff;
-struct iov_iter;
-
-int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
-			    struct iov_iter *from, size_t length);
-
-#endif /* _NET_CORE_DATAGRAM_H_ */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 30b523fa4ad2..384c6098a5f8 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -80,7 +80,6 @@
 #include <linux/user_namespace.h>
 #include <linux/indirect_call_wrapper.h>
 
-#include "datagram.h"
 #include "sock_destructor.h"
 
 struct kmem_cache *skbuff_head_cache __ro_after_init;
@@ -1339,12 +1338,6 @@ void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
 }
 EXPORT_SYMBOL_GPL(msg_zerocopy_put_abort);
 
-int skb_zerocopy_iter_dgram(struct sk_buff *skb, struct msghdr *msg, int len)
-{
-	return __zerocopy_sg_from_iter(skb->sk, skb, &msg->msg_iter, len);
-}
-EXPORT_SYMBOL_GPL(skb_zerocopy_iter_dgram);
-
 int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 			     struct msghdr *msg, int len,
 			     struct ubuf_info *uarg)
-- 
2.36.0

