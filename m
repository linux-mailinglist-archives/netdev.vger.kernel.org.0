Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB904572819
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbiGLUzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbiGLUyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:54:16 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290C3D1391;
        Tue, 12 Jul 2022 13:53:30 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v14so12825724wra.5;
        Tue, 12 Jul 2022 13:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wp0kER+7OMasisCSsReAtX19cUc/NcYCt5wUZzImOuo=;
        b=GYWGSGPS6YNm2dtj3iq60Pdz/K6WV2DG30z4HfrV/UTGVMjSYlgplWvh/RqSnMbXOS
         U5Si8G2L9Mo2NtsZ2ANr3yK0HBYlIbIyC4y4bUxGXaXYK2eFZm2nfY0ejA+q6HDpsg5j
         TjrIwr0+TwbKQCpankfmi9tp5nfca28udAIQQKuHhrRyy4V0zzKw0P6epsOrFv3hFa56
         UuAYTOtvDhms2TtE9ojNESZtub7hPY+ShOOKessexm6ts3wfxa3wXohf6S8JXAXFyGLq
         jGqXV18nDgCp1gGLDolwpG3+eNAIDKQ7GKnwf7sYnq5+JhBqzGm4zc80PijnDrAvnoJB
         WJSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wp0kER+7OMasisCSsReAtX19cUc/NcYCt5wUZzImOuo=;
        b=D7kwf7hAivz/7snWLTW07RGHbP0xz8uRD7rMUek5wQh7xBdO7I9KX2BgKrHG38Gr9G
         DRCET/fauj1AhKzba/OBT747i4Y1zqZLW6mSsJjT7Ytd4JR56LPPGpN5Wt9byxrNSEpH
         JS/dob2bo08CVFTJzbtu6XYfDwCswhFafoQCfPNM5yLWmUpmoeoVGJZjqw81DYPVIouW
         Vrv/8rYZiBPYOmSGmJg2TCxOECCNvQeFtnb3bGMOnFxQD0vguRmlD0E4PpVB9oIfCMTy
         28Zo2ISYCQOmSUz4/2cd//qinWZU0ve5E1I/fkofel1kmikhHb+/Y63zrg71s/LjUwwZ
         F/RA==
X-Gm-Message-State: AJIora8CXZvdDaiPj6XTh+Dfmn1p/7GFCSLO6AYmWrB0YxXhCs/x8jdt
        ZLENzQNJ5XExTSaab56h4BM2RekzecY=
X-Google-Smtp-Source: AGRyM1ttbGVusCjYADvlkUtJn2zh+eLy5GFazEjAG/V1u9H3yHHa4fYjl+DtXfAqC8Nswe3Ec4q4Lw==
X-Received: by 2002:a05:6000:16cb:b0:21d:7b9e:d0af with SMTP id h11-20020a05600016cb00b0021d7b9ed0afmr23944052wrf.139.1657659207969;
        Tue, 12 Jul 2022 13:53:27 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 17/27] io_uring: add rsrc referencing for notifiers
Date:   Tue, 12 Jul 2022 21:52:41 +0100
Message-Id: <3cd7a01d26837945b6982fa9cf15a63230f2ed4f.1657643355.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657643355.git.asml.silence@gmail.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
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
2.37.0

