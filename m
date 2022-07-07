Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A55D56A1AF
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbiGGLw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbiGGLwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:12 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09576564D0;
        Thu,  7 Jul 2022 04:52:08 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b26so25980720wrc.2;
        Thu, 07 Jul 2022 04:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n3QKMlKm1it+ilRxJ10vGka3QnjL+qdopfFQgCtqzes=;
        b=fO5QR1d20sSzSVeCdHtu0VMhbYncXeiy0fQnnAuNdfydNu7mtHY5D4sY6NRFWHP2aR
         AviaBIbSZMz2EJlWI4yqRY3gT4lPudCNw9MBZPaoBKXfH2leJOQB0tWHFiIsk5gddId7
         09CVyP4Nx3n4WWvltfC2tc5OQeXDq0id45ULdaYP3hQVWmpL2zcDsapYHjbX+ozwtTAO
         SAIU9bXO10RG7wr0D1sK1vFyMGxiMiISbfPKLERm7Ff1I+cxFqzSr1ORAtSiOZIijtny
         Y3dFSy3CJDc7iFry6Yo8EsDI+WVVDJwbfj9IRBvCAnGdKtwXURew8WaVoahQ58yi7Djr
         RjWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n3QKMlKm1it+ilRxJ10vGka3QnjL+qdopfFQgCtqzes=;
        b=2vJYWGKWQu8LclvUrLpfIc5VObOOG+e9119cjS2NVv8dTHSuZIih0jBp48dL46H/ki
         Uay0CVieqpA8a/o3PR0dSfjCjPo/+e/DGPIrrQAIFGAe8dMP9CGgDsDvfPyAqXH3bH4g
         4rkV1A8WyqNWvjY4NzbpCBYXyf5l9vnjpulb4Mbvhwy0Wrys50jM3C/0Mk82/8Y3/DHO
         6FRazLPybWl6e42ewBb1jZeuRaL801320BILQEQ+F/tTfXpSC7skgMQAX0IpaTgaIPqI
         vOoPJw3YyQksRvj3KVQRRuEXgYjRdSkrqULoYved2Fhpq3uir8Jb4aRfEtyavhRB2lAQ
         mCUw==
X-Gm-Message-State: AJIora9zww99SbdXSXQtze7jymRIuqh+ixl/hNEQdftlQQahuN7tpFOk
        ZeDAQrskr21zIkuZFMMuYNt/QWDV+KCjdedPQX8=
X-Google-Smtp-Source: AGRyM1vxZs2OTI4jbQQUAMNu9efPsdSAxJOqJsy2aacCdXfJvt6XubcRUCfiT7JLXkO9elSdc077yA==
X-Received: by 2002:a5d:440e:0:b0:21d:85ce:6b8e with SMTP id z14-20020a5d440e000000b0021d85ce6b8emr3119240wrq.248.1657194726310;
        Thu, 07 Jul 2022 04:52:06 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:52:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 17/27] io_uring: add rsrc referencing for notifiers
Date:   Thu,  7 Jul 2022 12:49:48 +0100
Message-Id: <f9d58e980c64be93300fc345c7714f1e50ab9eae.1657194434.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657194434.git.asml.silence@gmail.com>
References: <cover.1657194434.git.asml.silence@gmail.com>
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
 io_uring/notif.c |  5 +++++
 io_uring/notif.h |  1 +
 io_uring/rsrc.h  | 12 +++++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index aec74f88fc33..0a2e98bd74f6 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -7,10 +7,12 @@
 
 #include "io_uring.h"
 #include "notif.h"
+#include "rsrc.h"
 
 static void __io_notif_complete_tw(struct callback_head *cb)
 {
 	struct io_notif *notif = container_of(cb, struct io_notif, task_work);
+	struct io_rsrc_node *rsrc_node = notif->rsrc_node;
 	struct io_ring_ctx *ctx = notif->ctx;
 
 	if (likely(notif->task)) {
@@ -25,6 +27,7 @@ static void __io_notif_complete_tw(struct callback_head *cb)
 	ctx->notif_locked_nr++;
 	io_cq_unlock_post(ctx);
 
+	io_rsrc_put_node(rsrc_node, 1);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -119,6 +122,8 @@ struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 	/* master ref owned by io_notif_slot, will be dropped on flush */
 	refcount_set(&notif->uarg.refcnt, 1);
 	percpu_ref_get(&ctx->refs);
+	notif->rsrc_node = ctx->rsrc_node;
+	io_charge_rsrc_node(ctx);
 	return notif;
 }
 
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 23ca7620fff9..1dd48efb7744 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -10,6 +10,7 @@
 struct io_notif {
 	struct ubuf_info	uarg;
 	struct io_ring_ctx	*ctx;
+	struct io_rsrc_node	*rsrc_node;
 
 	/* complete via tw if ->task is non-NULL, fallback to wq otherwise */
 	struct task_struct	*task;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 87f58315b247..af342fd239d0 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -135,6 +135,13 @@ static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
 	}
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
@@ -144,9 +151,8 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 
 		if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 			lockdep_assert_held(&ctx->uring_lock);
-			ctx->rsrc_cached_refs--;
-			if (unlikely(ctx->rsrc_cached_refs < 0))
-				io_rsrc_refs_refill(ctx);
+
+			io_charge_rsrc_node(ctx);
 		} else {
 			percpu_ref_get(&req->rsrc_node->refs);
 		}
-- 
2.36.1

