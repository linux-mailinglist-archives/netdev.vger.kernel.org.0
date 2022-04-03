Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95644F09A9
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358481AbiDCNKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358587AbiDCNK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:29 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B43263B6
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:25 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h4so10584264wrc.13
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X8Z6isJG5NFeUxeEjvkxdgE+kQKIsemrCR/6308ZWXw=;
        b=XOeMqe5q8E5eT6wxLBvYkQ1jFIn+UZEesnikCxzlIVF+XX/SUKWC7+XI8JOjTVG0wA
         E5IR2kqtBLNlLb1sr2sWpL1ipp5PwS0d4jV/K/Ke9/oJ3x22t21i26D9N5DSo9CbiMNX
         XsDljfeDaixss3zJX7/AAMhyHnSrStMFM5bXcUwCmVlEBY6l1aUdb0NfN4T74B2AJ7Qo
         KQh09O2/hdPt0F7bWXiE0RP/SLZlgTPCrxT09SUkk/NWRb6s6ROOciThAq4nwCsbwl+l
         /WqgClk8RyfyDDLKR6D4AX5vaBOHXU2mTuo2TyDLzG8lEmPlBEdhg3vCoxTISSmUtF0O
         9HWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X8Z6isJG5NFeUxeEjvkxdgE+kQKIsemrCR/6308ZWXw=;
        b=Zqc6NdFj51F+VQYx/tT99jSovoYy0EauPCxh5vjr41yiaRE6TuHQ6KQzOJZj90o4Tk
         zcss4x6701dRJG2E/S3DjjrYTBI4opN943aeCL652+glZY0T/nSecu5sOtSeEaSh74Tv
         F3AylW/az+uhjLpnWWL5ittFNqDALGIEaE0SY4bbBZWKWk9wTuKi0ym4Tx3N9kgQlKAf
         vjsFozLfcE7iZUWH+fqW5pcUpeVtHRT7cztJS2e68y2wZY/YVK21k0uUt6g4xUjdAxGf
         eI+Q5VIIkjYWYTpoerwioTSN8kWNTpzG5lCpo5rm0gz7xFq1NejTEfA25tktwa2BWndn
         w5kg==
X-Gm-Message-State: AOAM532KHpRRkXWkyBvMo1yFk7UZMXgMoD8SHiFKy6egadpLxFn7E0/f
        e9EiXEJvjF66+eYTPfEz2A2hKBCq6Jo=
X-Google-Smtp-Source: ABdhPJxi5nzzCUeZzNns6kQOmLTC0sjPJvdC2nY/SX4hR8NornadvfThMqBuejxJ69zpRVJHkti6CQ==
X-Received: by 2002:adf:916d:0:b0:206:db9:7ce9 with SMTP id j100-20020adf916d000000b002060db97ce9mr2122089wrj.556.1648991303655;
        Sun, 03 Apr 2022 06:08:23 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 11/27] net: inline skb_zerocopy_iter_dgram
Date:   Sun,  3 Apr 2022 14:06:23 +0100
Message-Id: <37734b05228dd2c03821a650b5568eb94a801528.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
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
index ebc4ad36c3a2..93a50ac6b9c4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -647,20 +647,6 @@ struct ubuf_info {
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
@@ -1670,6 +1656,28 @@ static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
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
index ee290776c661..bd78b974baa5 100644
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
index 2c787d964a60..65ac779eb5cd 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -80,7 +80,6 @@
 #include <linux/user_namespace.h>
 #include <linux/indirect_call_wrapper.h>
 
-#include "datagram.h"
 #include "sock_destructor.h"
 
 struct kmem_cache *skbuff_head_cache __ro_after_init;
@@ -1340,12 +1339,6 @@ void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
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
2.35.1

