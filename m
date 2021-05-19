Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106AF389026
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353973AbhESOPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353891AbhESOPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:15 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BEFC061760;
        Wed, 19 May 2021 07:13:55 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id u4-20020a05600c00c4b02901774b80945cso3532150wmm.3;
        Wed, 19 May 2021 07:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KqEkF4Dijyzr0PPwp8tl6lkEhCqjAVOKZqJtKABlU28=;
        b=iPwmgJkLjvCL/f8ItIm1m4rk0cwwg0XxIjxDWQkkisNr4iXOEGCpqj8/RTpEi/2hEy
         eJiREbqnUE+FErrGM97tgGNFx5wvOK/KW8CDycGbEUPTOYVwDmjy18qG6KtZpocXIZ71
         ZqlO02LE+KunTpU1Z8Lf1oKsFbV2+EHkEJPh/mbGLBQkZ6gNMQA7G6EyZ4KDEcvinlCn
         UBUxm03NyLvSYiEIWdN+u/mJk18SvktCW7mbEUEwPBu++2Usat8EHcldZLcRTAy0pslS
         CZBRH5pM0wi9I13cdDPlNgI1GF95QwEdl89BYZgrFCtVhdU5KvScc2ENSbe/5Wj7l5S5
         NLiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KqEkF4Dijyzr0PPwp8tl6lkEhCqjAVOKZqJtKABlU28=;
        b=c7VfuPHtQHDruGj8UGkwq/KNZ61mL7YicEgoB68U8rJwAYL3p/WNlibSrRFdXpq4bo
         Lkcrfc8ofPQ34LYtN5DNziNJ31jDGvtFR19vvLzf60cqS7kSsF7Y2wkzyUsrwJvq5zN/
         z0JW2rACGJsYYp00+QqOiITfiMV15R8ELGSCtuFJ7VmcCzjoX15XAC+0V1+2NDcq824b
         gAn67a3c10TmVf/PHi0y3c4hZW1HQP0VKxLVkjh34VaM0LZO4AwPhJFkmiJKxAm10jCJ
         yyoFu+WuNSdrPtVUXBETk2F7gfTj26+ESibExFU54RhTJmTT9O9ksTcxVI3HkvPTLSEW
         UAhQ==
X-Gm-Message-State: AOAM531rISNr9VzZyPZ4ta3Jnmgwxp0bYxlYTASSq/NWNGe3E9po2NYf
        2InRFywlM6mtXUrew8U7aQCvZ2GhCoE4G4YL
X-Google-Smtp-Source: ABdhPJzlaROjPTre/59PQ3SeVaTAljdyKaPRGNJMK2c8Ew/36zXwYH2Do7kAdXk5eQ79G60rJamITg==
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr11515439wmf.134.1621433633790;
        Wed, 19 May 2021 07:13:53 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:13:53 -0700 (PDT)
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
Subject: [PATCH 03/23] io_uring: remove dependency on ring->sq/cq_entries
Date:   Wed, 19 May 2021 15:13:14 +0100
Message-Id: <1188e30e5693519d59f065669fb1b8c415b076cf.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have numbers of {sq,cq} entries cached in ctx, don't look up them in
user-shared rings as 1) it may fetch additional cacheline 2) user may
change it and so it's always error prone.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 31eca208f675..15dc5dad1f7d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1352,7 +1352,7 @@ static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 {
 	struct io_rings *r = ctx->rings;
 
-	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == r->sq_ring_entries;
+	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == ctx->sq_entries;
 }
 
 static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
@@ -1370,7 +1370,7 @@ static inline struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 	 * control dependency is enough as we're using WRITE_ONCE to
 	 * fill the cq entry
 	 */
-	if (__io_cqring_events(ctx) == rings->cq_ring_entries)
+	if (__io_cqring_events(ctx) == ctx->cq_entries)
 		return NULL;
 
 	tail = ctx->cached_cq_tail++;
@@ -1423,11 +1423,10 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 /* Returns true if there are no backlogged entries after the flush */
 static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
-	struct io_rings *rings = ctx->rings;
 	unsigned long flags;
 	bool all_flushed, posted;
 
-	if (!force && __io_cqring_events(ctx) == rings->cq_ring_entries)
+	if (!force && __io_cqring_events(ctx) == ctx->cq_entries)
 		return false;
 
 	posted = false;
-- 
2.31.1

