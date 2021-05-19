Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26040389028
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353992AbhESOPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353908AbhESOPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:16 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD58C061763;
        Wed, 19 May 2021 07:13:56 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id b7so6787134wmh.5;
        Wed, 19 May 2021 07:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1LxYRWZUsnSIxOX2Qv7kHLFKMWp6NXKb/JCxteoPhi4=;
        b=ZFGdykG9VWTjZi5gupEJgX3FD/oRFvi4uH4Ko+eiMjEJW4yRLfyXH/OJiOAKd1q4yi
         1+kKBEGdJuCZKkyDLC8k4uuC4JB5LU72XNU1VLdXgl+MMc0hDicBfgBiW3MTw2oI8v5g
         LF9Y0fHU56llWpvBOzIlBmV3TJYmQOvIv86gOmgFHgL7SsHicH7l4/XXO0/sB8y2+wlq
         QYPvOGnDvUEK2+u3WiCCWmeQFuoZelbGdzL1TZvLMaXNJpG2KdE63GtCBE2jbsx85zeC
         iIB2M/6PqCwnw9Ef11u0HUDtM2cpnrop9pzwh057QWKy+5+5G0769/BBTU1bgwlEJAoy
         pa1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1LxYRWZUsnSIxOX2Qv7kHLFKMWp6NXKb/JCxteoPhi4=;
        b=nwgOcFLF/s/fod2ke37r2smu7kjjEq5pwNEIwmmeDtLSYWl/MHXnPoaqyDmSXbTeoJ
         7qzNgpfQHi/i6rmrISnb6atlqPdGDreIY6FqMU+1SjUcVsJaX9YzCB9RGWTebkQdgwxh
         o+pl/UWmzMCUmnzYh4fhLZJmlYvW3yNxqW7v9ygdTjhIpvu8BMRo7d/0vObtgDhnY3If
         Nf4J6cwK2cudoLKLTY/xSSzUrTxiySo9CEsj98k3rroHMFiuO9qhLArgPQPjqvxtd++B
         IXUNxHBu/JW1qO8Eo7bTXB6I7LjBqiYqfF/6q5qjB5KESGNepq35PjPHCdjIATmQV8Ad
         BtwQ==
X-Gm-Message-State: AOAM533DYoo98464gyttRladTs2UynKwDuglaFqMLXeeaHRigHBM34od
        hBye4HIvpR0G1U/uy4Lv4UrpALZE5JPfUbSx
X-Google-Smtp-Source: ABdhPJzyGiyrMlenYIpS+THnOoIvHrkX2gj9WOMTuPD2+Qh++DG+o95t0zdKSz40zTawQlV6SgljOA==
X-Received: by 2002:a05:600c:3654:: with SMTP id y20mr6103852wmq.184.1621433635073;
        Wed, 19 May 2021 07:13:55 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:13:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Subject: [PATCH 04/23] io_uring: deduce cq_mask from cq_entries
Date:   Wed, 19 May 2021 15:13:15 +0100
Message-Id: <f5fc827237c2d339d3fdae8a0588763ba3e1d0f1.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to cache cq_mask, it's exactly cq_entries - 1, so just deduce
it to not carry it around.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 15dc5dad1f7d..067c89e63fea 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -361,7 +361,6 @@ struct io_ring_ctx {
 		u32			*sq_array;
 		unsigned		cached_sq_head;
 		unsigned		sq_entries;
-		unsigned		sq_mask;
 		unsigned		sq_thread_idle;
 		unsigned		cached_sq_dropped;
 		unsigned		cached_cq_overflow;
@@ -407,7 +406,6 @@ struct io_ring_ctx {
 	struct {
 		unsigned		cached_cq_tail;
 		unsigned		cq_entries;
-		unsigned		cq_mask;
 		atomic_t		cq_timeouts;
 		unsigned		cq_last_tm_flush;
 		unsigned		cq_extra;
@@ -1363,7 +1361,7 @@ static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
 static inline struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
-	unsigned tail;
+	unsigned tail, mask = ctx->cq_entries - 1;
 
 	/*
 	 * writes to the cq entry need to come after reading head; the
@@ -1374,7 +1372,7 @@ static inline struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 		return NULL;
 
 	tail = ctx->cached_cq_tail++;
-	return &rings->cqes[tail & ctx->cq_mask];
+	return &rings->cqes[tail & mask];
 }
 
 static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
@@ -6677,7 +6675,7 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
 static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 {
 	u32 *sq_array = ctx->sq_array;
-	unsigned head;
+	unsigned head, mask = ctx->sq_entries - 1;
 
 	/*
 	 * The cached sq head (or cq tail) serves two purposes:
@@ -6687,7 +6685,7 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 	 * 2) allows the kernel side to track the head on its own, even
 	 *    though the application is the one updating it.
 	 */
-	head = READ_ONCE(sq_array[ctx->cached_sq_head++ & ctx->sq_mask]);
+	head = READ_ONCE(sq_array[ctx->cached_sq_head++ & mask]);
 	if (likely(head < ctx->sq_entries))
 		return &ctx->sq_sqes[head];
 
@@ -9493,8 +9491,6 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	rings->cq_ring_mask = p->cq_entries - 1;
 	rings->sq_ring_entries = p->sq_entries;
 	rings->cq_ring_entries = p->cq_entries;
-	ctx->sq_mask = rings->sq_ring_mask;
-	ctx->cq_mask = rings->cq_ring_mask;
 
 	size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
 	if (size == SIZE_MAX) {
-- 
2.31.1

