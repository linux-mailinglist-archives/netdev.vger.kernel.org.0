Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1EB555ED62
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbiF1TBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbiF1TAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:35 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1949C1EEFE;
        Tue, 28 Jun 2022 12:00:23 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id g26so27683700ejb.5;
        Tue, 28 Jun 2022 12:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=awYm6HD6jYs2SaAyNqv6tsJHKyEz5elq2Zf1xhTXbLA=;
        b=lOYPNl4WFiYVlmBE984FzFFjiIRwadj5m58zSyoDhC7nvUlLk/i9yy0IKrPUxIP2L3
         wxNIPgdREa/XKvgJ/1BFwVtFAAlcdKcOs462InfzpX6RjhhZVg1ZLB++mQ/5oEKJiBpT
         IKghCvnxyZ+sHhloRkDGn0fQhlnqhTwPYCD78Apo/o2wxIpo9MGyvB6QoMOVmUB0KzXT
         OYt/qftk0ms4VyyQSnkDuNp49x/KHQRxE1MNfUU8BjOYSqsDS0ZYnzHjb2PPMzHPeo0K
         OMInc51n74xAqkEGcDX4hADru1plpGKqiUhadgbUaI6le86dA2aPOv1N0LJvsJCT3ZIR
         +5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=awYm6HD6jYs2SaAyNqv6tsJHKyEz5elq2Zf1xhTXbLA=;
        b=Yu4wyjJL9FdFDLXqPUVYHqp1g+qCC6QhsrAz+vhIV6GHgyIj0gJnpC+LIytf8pHHrb
         5ELX0wllnhOlON4WjAQ+uHCcgkuQX4Q4/gl/SKTzIETnNhzwkTzI0fksyKV+4ScVqr4Q
         TqiFG2bNeiuOT8o903KC6FbOqslRJFy1zFKZSGiwXZX1Oovz/Z96m9LxsKQo0ndTye4q
         PynDtCgKNYhgAAS8EaUfHkIc0wP+EiNQEM0C0t2fpjXIDzkkFJ8I+UAUD+i+2vOAFHA/
         xKyMJtogrYoFS1RS8gKxf4gkSI4gznjezDjakErYW+BsSAJFsZxcs0SEFEu8ooYSAZ56
         Egcg==
X-Gm-Message-State: AJIora8dqonTNiQ52TEJa606+dWIu19Wq6gTjYcRRyONUbekzsDJtEib
        TduLUeLB/tpfCr7O5s298tZy6Ldj3e3pgg==
X-Google-Smtp-Source: AGRyM1uQA2BJUNEBkywkqA9NRUiJiEe1S1TN+RAgvh9Yxx1WjiBWYnFhFMwxSFJlkcHeN8QxV7lt8w==
X-Received: by 2002:a17:906:478e:b0:722:f84d:159f with SMTP id cw14-20020a170906478e00b00722f84d159fmr19402174ejc.182.1656442821239;
        Tue, 28 Jun 2022 12:00:21 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 24/29] io_uring: add rsrc referencing for notifiers
Date:   Tue, 28 Jun 2022 19:56:46 +0100
Message-Id: <bf98145dc28282bc45aac455acf63f04ebd9a531.1653992701.git.asml.silence@gmail.com>
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

In preparation to zerocopy sends with fixed buffers make notifiers to
reference the rsrc node to protect the used fixed buffers. We can't just
grab it for a send request as notifiers can likely outlive requests that
used it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a1e9405a3f1b..07d09d06e8ab 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -378,6 +378,7 @@ struct io_ev_fd {
 struct io_notif {
 	struct ubuf_info	uarg;
 	struct io_ring_ctx	*ctx;
+	struct io_rsrc_node	*rsrc_node;
 
 	/* cqe->user_data, io_notif_slot::tag if not overridden */
 	u64			tag;
@@ -1695,13 +1696,20 @@ static __cold void io_rsrc_refs_drop(struct io_ring_ctx *ctx)
 	}
 }
 
-static void io_rsrc_refs_refill(struct io_ring_ctx *ctx)
+static __cold void io_rsrc_refs_refill(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	ctx->rsrc_cached_refs += IO_RSRC_REF_BATCH;
 	percpu_ref_get_many(&ctx->rsrc_node->refs, IO_RSRC_REF_BATCH);
 }
 
+static inline void io_charge_rsrc_node(struct io_ring_ctx *ctx)
+{
+	ctx->rsrc_cached_refs--;
+	if (unlikely(ctx->rsrc_cached_refs < 0))
+		io_rsrc_refs_refill(ctx);
+}
+
 static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 					struct io_ring_ctx *ctx,
 					unsigned int issue_flags)
@@ -1711,9 +1719,7 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 
 		if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 			lockdep_assert_held(&ctx->uring_lock);
-			ctx->rsrc_cached_refs--;
-			if (unlikely(ctx->rsrc_cached_refs < 0))
-				io_rsrc_refs_refill(ctx);
+			io_charge_rsrc_node(ctx);
 		} else {
 			percpu_ref_get(&req->rsrc_node->refs);
 		}
@@ -2826,6 +2832,7 @@ static __cold void io_free_req(struct io_kiocb *req)
 static void __io_notif_complete_tw(struct callback_head *cb)
 {
 	struct io_notif *notif = container_of(cb, struct io_notif, task_work);
+	struct io_rsrc_node *rsrc_node = notif->rsrc_node;
 	struct io_ring_ctx *ctx = notif->ctx;
 	struct mmpin *mmp = &notif->uarg.mmp;
 
@@ -2849,6 +2856,7 @@ static void __io_notif_complete_tw(struct callback_head *cb)
 	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
 
+	io_rsrc_put_node(rsrc_node, 1);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -2943,6 +2951,8 @@ static struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 	/* master ref owned by io_notif_slot, will be dropped on flush */
 	refcount_set(&notif->uarg.refcnt, 1);
 	percpu_ref_get(&ctx->refs);
+	notif->rsrc_node = ctx->rsrc_node;
+	io_charge_rsrc_node(ctx);
 	return notif;
 }
 
-- 
2.36.1

