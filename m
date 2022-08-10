Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C1F58EFCC
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbiHJPxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbiHJPwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:52:12 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94C96B664;
        Wed, 10 Aug 2022 08:51:53 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id s11-20020a1cf20b000000b003a52a0945e8so1194784wmc.1;
        Wed, 10 Aug 2022 08:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=8bvrycIBhC98AAS95EkRU1aUeIYv5cmtQ6g1fcH8Ls4=;
        b=NXRHpYfu0yj454B9TNqMSmsanOBuZYbEWiz+69QOiDC+DiJ2G+DWR8eQVlY70gQLu2
         d0y7fh2jjsSTdciIvCwRVN4S9hece9UJOGa8XGh2v8vTiQdh6mNLdQQ8Fav5YfXJjcUU
         khtZG1kVvwRuto8hvHjfgINz8qFheZKolPC7tRow4X5InG3ks03RinhMEB69q/HPIghp
         RR52RfGpkiacBVtnyrW+hJzjBXI1YrXWzEp3tbUt8VcNjh69N5Ru/lSwr+rsyQJoHgS+
         05TXvir/g7FILT8dTPmjkGDy/QS+ouQWtNodRMedLwj3LN6GVEXfdRJ6j4sUIlZrGHUR
         ilkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=8bvrycIBhC98AAS95EkRU1aUeIYv5cmtQ6g1fcH8Ls4=;
        b=rswghZnQ8v3r55AeXW+qUVezH8KK9xYl4oBb1lBQJ8v0ARPYXK82lMP50ozbzN2XE5
         +twmQfsX1n2gV1+TdnhXy93q2+CaCtnOKNvUYps0vadIy4FdhUgKqgK9a+K20PiPkuLA
         fWPzSn1/WhOI5kFsie4VSwn7wozR1sWFoz5zPgt3nKwc11mchLMPv+TiOWmf0RDgm7ez
         amPkRz4HUmvSkDbLnnVkZxiQNtBf41E+zxzwc7SfHqdwwCzrjeul4CBYClxpzOlW5FQe
         gKDYXI81RR8chsd/Y6x3CRjf8RSxyLB4kkZ4WeKMmyb24YmDL+F6nWRh1rOPK8hvhyOB
         GT5A==
X-Gm-Message-State: ACgBeo3aaVrtdPUcnhVnj/DNQT+k8ELoo9o3tTyaH6Gw87YTm1VnXeOh
        NpMFzr5lNGCK4dThRlvtstWcIaeIq7M=
X-Google-Smtp-Source: AA6agR6ysliwRQwjHrbtgRjuvt8Ybcqj6h9fHpK3wukZ1ZPxN88XDbQ1aaLBOWU/0aq+IGK8xrnzTA==
X-Received: by 2002:a05:600c:4ecd:b0:3a3:3eb0:9101 with SMTP id g13-20020a05600c4ecd00b003a33eb09101mr3007084wmq.49.1660146711936;
        Wed, 10 Aug 2022 08:51:51 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id ay1-20020a05600c1e0100b003a342933727sm3004519wmb.3.2022.08.10.08.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:51:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next io_uring 11/11] io_uring/notif: add ubuf_info ref caching
Date:   Wed, 10 Aug 2022 16:49:19 +0100
Message-Id: <9514ddeea83902c36887ce764bc0306a518af73c.1660124059.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1660124059.git.asml.silence@gmail.com>
References: <cover.1660124059.git.asml.silence@gmail.com>
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

Cache some active notifier references at the io_uring side and get them
in batches, so the ammortised cost is low. Then these references can be
given away to the network layer using UARGFL_GIFT_REF.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   |  8 +++++++-
 io_uring/notif.c |  6 ++++--
 io_uring/notif.h | 22 +++++++++++++++++++++-
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index e6fc9748fbd2..bdaf9b10bd1b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -949,6 +949,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sendzc *zc = io_kiocb_to_cmd(req);
 	struct io_notif_slot *notif_slot;
 	struct io_kiocb *notif;
+	struct ubuf_info *ubuf;
 	struct msghdr msg;
 	struct iovec iov;
 	struct socket *sock;
@@ -1007,10 +1008,15 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
 	msg.msg_flags = msg_flags;
-	msg.msg_ubuf = &io_notif_to_data(notif)->uarg;
 	msg.sg_from_iter = io_sg_from_iter;
+	msg.msg_ubuf = ubuf = &io_notif_to_data(notif)->uarg;
+	ubuf->flags |= UARGFL_GIFT_REF;
 	ret = sock_sendmsg(sock, &msg);
 
+	/* check if the send consumed an additional ref */
+	if (likely(!(ubuf->flags & UARGFL_GIFT_REF)))
+		io_notif_consume_ref(notif);
+
 	if (unlikely(ret < min_ret)) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
 			return -EAGAIN;
diff --git a/io_uring/notif.c b/io_uring/notif.c
index dd346ea67580..73bbda5de07d 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -68,15 +68,17 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
 	nd->uarg.skb_flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
 	nd->uarg.flags = UARGFL_CALLER_PINNED;
 	nd->uarg.callback = io_uring_tx_zerocopy_callback;
+	nd->cached_refs = IO_NOTIF_REF_CACHE_NR;
 	/* master ref owned by io_notif_slot, will be dropped on flush */
-	refcount_set(&nd->uarg.refcnt, 1);
+	refcount_set(&nd->uarg.refcnt, IO_NOTIF_REF_CACHE_NR + 1);
 	return notif;
 }
 
 static inline bool io_notif_drop_refs(struct io_notif_data *nd)
 {
-	int refs = 1;
+	int refs = nd->cached_refs + 1;
 
+	nd->cached_refs = 0;
 	return refcount_sub_and_test(refs, &nd->uarg.refcnt);
 }
 
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 0819304d7e00..2a263055a53b 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -9,11 +9,14 @@
 
 #define IO_NOTIF_SPLICE_BATCH	32
 #define IORING_MAX_NOTIF_SLOTS (1U << 10)
+#define IO_NOTIF_REF_CACHE_NR	64
 
 struct io_notif_data {
 	struct file		*file;
-	struct ubuf_info	uarg;
 	unsigned long		account_pages;
+	/* extra uarg->refcnt refs */
+	int			cached_refs;
+	struct ubuf_info	uarg;
 };
 
 struct io_notif_slot {
@@ -88,3 +91,20 @@ static inline int io_notif_account_mem(struct io_kiocb *notif, unsigned len)
 	}
 	return 0;
 }
+
+static inline void io_notif_consume_ref(struct io_kiocb *notif)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_notif_data *nd = io_notif_to_data(notif);
+
+	nd->cached_refs--;
+
+	/*
+	* Issue sends without looking at notif->cached_refs first, so we
+	* always have to have at least one ref cached
+	*/
+	if (unlikely(!nd->cached_refs)) {
+		refcount_add(IO_NOTIF_REF_CACHE_NR, &nd->uarg.refcnt);
+		nd->cached_refs += IO_NOTIF_REF_CACHE_NR;
+	}
+}
-- 
2.37.0

