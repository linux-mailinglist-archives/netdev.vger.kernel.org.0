Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E2E389031
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354013AbhESOPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353949AbhESOP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:28 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CD7C06138C;
        Wed, 19 May 2021 07:13:58 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id y14so12113786wrm.13;
        Wed, 19 May 2021 07:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OeEwqb/igFRqCGm3Sb3F+bC88dq+JZby5yeiT6dBiuA=;
        b=l/JRy3U4P60H+ui9Tl2niQPeBH2AO/7v7MCP31Gh/1iXHCuc02HVFwRjY4Ia2Nrigv
         06sfdrm8q70S60Aewx3MEjx3lTL3Zhjvc9QHw4uDoin8VJeRRgVmElVel0KlIyFpg3xc
         hCP40Na9Pts1R+abFOalbO9eATC9hMYy34YJHW8H3B3KODH5oRgAtviFd1xOH9Nu5DRN
         zIyGmkAgwia9Q/jZQ3HuCzu39B5t7g1ZSpiM9xfCAROWTQeD4pw5V95LupNZXOCv0wNo
         ZHmKb4BblNwv2I4EoxoEWQ+c/YKlGPzMdp7hrEuqMqC5viDBjnoJ5f5oCmuC+p2vUW+x
         VUiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OeEwqb/igFRqCGm3Sb3F+bC88dq+JZby5yeiT6dBiuA=;
        b=V7o6/I1Y6Xmp969YezGelJwe9orUbJTFrtabIBimsFDLrxujuBfHF0bCdi8mHPq9Wz
         JqXku19H3a+9FQOLbbt32wA06oLd1gGdzwrWYboquSLDjJJF02Ak9mQBo/kiPxUPnbez
         QRoNGGc5V3WCrEwb80ItARBojc2VeYKry9Qq01z02vQTrJ6llBXRPdxU50/YgeC6Z4gZ
         ZKz/IUSH1VFzO/pdNRof4NCEz6ZjCFzS6CpbecP1tl8nFSSQuGf40LF8v+Xo2ihwPPTp
         kwosTUJoUiGHtRgyjDNYFwwRwHaltRyxRzQFln1Nt9oN3E87p/zlmK7Btegs71zafntQ
         9Llg==
X-Gm-Message-State: AOAM532QS82NwUnqkTcybVPaAUas/l9bDV6gANYPvxLV0QWQgoN7ycDu
        Zdc6rMJTX4GbHtS/GMjdT8x/kOdxPo/5JqsS
X-Google-Smtp-Source: ABdhPJwpyFzXtcUnk3BSIi+6vwJdGw6RixhvwFjAVHfMm9raGNhfvFPKcJrhRXzfF+HSesNdZhKb+g==
X-Received: by 2002:a5d:5541:: with SMTP id g1mr10583939wrw.102.1621433637408;
        Wed, 19 May 2021 07:13:57 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:13:57 -0700 (PDT)
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
Subject: [PATCH 06/23] io_uring: rename io_get_cqring
Date:   Wed, 19 May 2021 15:13:17 +0100
Message-Id: <be3a185ade803d9f0c43ffe6db43638b4801579e.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename io_get_cqring() into io_get_cqe() for consistency with SQ, and
just because the old name is not as clear.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b89a781b3f33..49a1b6b81d7d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11,7 +11,7 @@
  * before writing the tail (using smp_load_acquire to read the tail will
  * do). It also needs a smp_mb() before updating CQ head (ordering the
  * entry load(s) with the head store), pairing with an implicit barrier
- * through a control-dependency in io_get_cqring (smp_store_release to
+ * through a control-dependency in io_get_cqe (smp_store_release to
  * store head will do). Failure to do so could lead to reading invalid
  * CQ entries.
  *
@@ -1364,7 +1364,7 @@ static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
 	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
 }
 
-static inline struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
+static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
 	unsigned tail, mask = ctx->cq_entries - 1;
@@ -1436,7 +1436,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	posted = false;
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 	while (!list_empty(&ctx->cq_overflow_list)) {
-		struct io_uring_cqe *cqe = io_get_cqring(ctx);
+		struct io_uring_cqe *cqe = io_get_cqe(ctx);
 		struct io_overflow_cqe *ocqe;
 
 		if (!cqe && !force)
@@ -1558,7 +1558,7 @@ static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data
 	 * submission (by quite a lot). Increment the overflow count in
 	 * the ring.
 	 */
-	cqe = io_get_cqring(ctx);
+	cqe = io_get_cqe(ctx);
 	if (likely(cqe)) {
 		WRITE_ONCE(cqe->user_data, user_data);
 		WRITE_ONCE(cqe->res, res);
-- 
2.31.1

