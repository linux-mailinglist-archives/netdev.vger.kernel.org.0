Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4F138902D
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353927AbhESOPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353948AbhESOP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:28 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BABC06138B;
        Wed, 19 May 2021 07:13:57 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id a4so14236438wrr.2;
        Wed, 19 May 2021 07:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZPT+0HJmzsc95uwTFh6BaxO4xNAkeAD/mL9HofulqQs=;
        b=ugKf7X7OZjfuyM0BMA5+9eJmnjeem8TIzS8o3NGQQBbdg//F4mw1EcRMf58jy07IiS
         J+QHbGfm/uMUrK8Q6zp9twEnp9vI0wGClssYlxIBoSWP/XICWUOoRySpkJRjkwdsh079
         tvNWrWJWFm0bXiK04IyGz6uty3Isw9b11hcK6ykOhAcHCwKaQyitsCp20aFTRNNZjgw5
         Ero9VdPiVQ3btsfqtsBVmS/mT5tj6/Nqo2x3bEnRwV9RxhfxVDI7YzvW/DbLw0fMPtSE
         A0MxJevqdd2fv8OVs/jVH8tl7rBBuRKgP/o+VtcYHqraKeHvxothy/x8Rfh4NpSVje+5
         OxGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZPT+0HJmzsc95uwTFh6BaxO4xNAkeAD/mL9HofulqQs=;
        b=bYKkp4VFEugnNKq4M5cbdY6Hls6GEGbUdk3PLkC2WIxA2O+nen7iYn7oWdzLTJMR4c
         Csf7ltgFm04jR8XrmGLUTeqRY99dj+67eyX/WqVJvRVjKQhy2SZKIsAu7vgI7wskTB+B
         VnKu3HUpr3DMiA5vfYxG2d+JI0fwoM15L3yDGVtm6UyfAt4qxlfrVLT0hpkKRXSEAzvk
         wUUDMLjMtVesn/Hr78LgToF1vFhTc/OOa4BobVG8+cbYiBvDJAjGOLUHJ8v9bfDjF8PM
         rCUyj7q2w1uWJsAq3XeG7WuACP+OqlHdSTmpTf6ErnASN388ZWcg7vsE+Mp/GULDtc0s
         uBng==
X-Gm-Message-State: AOAM532+XKstRw5YBabOAc7nwYnWkFMWqWIbZb+rNDcSVG0h3r9E5urd
        Q9Ns5bn+gjeTRJgcQxmrG06LdLcxVuMmw82S
X-Google-Smtp-Source: ABdhPJwIGP4B1GsZIjPV9HwTg4I3krYxTRqYaxuRBbbjraw0wXD/gBdvaNtXqSmRKJ/QDmpO7Eh42g==
X-Received: by 2002:a5d:64c7:: with SMTP id f7mr14861047wri.257.1621433636230;
        Wed, 19 May 2021 07:13:56 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:13:55 -0700 (PDT)
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
Subject: [PATCH 05/23] io_uring: kill cached_cq_overflow
Date:   Wed, 19 May 2021 15:13:16 +0100
Message-Id: <740885c2bdc38f2a269cd9591987c80ae7b7ce8a.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two copies of cq_overflow, shared with userspace and internal
cached one. It was needed for DRAIN accounting, but now we have yet
another knob to tune the accounting, i.e. cq_extra, and we can throw
away the internal counter and just increment the one in the shared ring.

If user modifies it as so never gets the right overflow value ever
again, it's its problem, even though before we would have restored it
back by next overflow.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 067c89e63fea..b89a781b3f33 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -363,7 +363,6 @@ struct io_ring_ctx {
 		unsigned		sq_entries;
 		unsigned		sq_thread_idle;
 		unsigned		cached_sq_dropped;
-		unsigned		cached_cq_overflow;
 		unsigned long		sq_check_overflow;
 
 		struct list_head	defer_list;
@@ -1195,13 +1194,20 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	return NULL;
 }
 
+static void io_account_cq_overflow(struct io_ring_ctx *ctx)
+{
+	struct io_rings *r = ctx->rings;
+
+	WRITE_ONCE(r->cq_overflow, READ_ONCE(r->cq_overflow) + 1);
+	ctx->cq_extra--;
+}
+
 static bool req_need_defer(struct io_kiocb *req, u32 seq)
 {
 	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
 		struct io_ring_ctx *ctx = req->ctx;
 
-		return seq + ctx->cq_extra != ctx->cached_cq_tail
-				+ READ_ONCE(ctx->cached_cq_overflow);
+		return seq + READ_ONCE(ctx->cq_extra) != ctx->cached_cq_tail;
 	}
 
 	return false;
@@ -1440,8 +1446,8 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		if (cqe)
 			memcpy(cqe, &ocqe->cqe, sizeof(*cqe));
 		else
-			WRITE_ONCE(ctx->rings->cq_overflow,
-				   ++ctx->cached_cq_overflow);
+			io_account_cq_overflow(ctx);
+
 		posted = true;
 		list_del(&ocqe->list);
 		kfree(ocqe);
@@ -1525,7 +1531,7 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 		 * or cannot allocate an overflow entry, then we need to drop it
 		 * on the floor.
 		 */
-		WRITE_ONCE(ctx->rings->cq_overflow, ++ctx->cached_cq_overflow);
+		io_account_cq_overflow(ctx);
 		return false;
 	}
 	if (list_empty(&ctx->cq_overflow_list)) {
-- 
2.31.1

