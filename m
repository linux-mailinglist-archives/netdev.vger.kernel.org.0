Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604FF38903F
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354081AbhESOPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353956AbhESOPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:31 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CE5C061342;
        Wed, 19 May 2021 07:14:03 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q5so14199744wrs.4;
        Wed, 19 May 2021 07:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p5vGg0RqALu5mFpfRw+5YKA5lKfc7l3wHZfGWX7shrY=;
        b=Fb/E9ZY1LVmG6M+4NIy05ALhaxdRJ5skYa57IBz4gUxpMP/TTc2yS1tK1fdKEj1iPx
         /KGEa4USptfmtXZxlLPDV2068ZKyyeVjEkVgJzeBP2eeQpYft+IjBcWyHb4UFFeUJ3ET
         huStZC/oP27hjjlSEE9nLuQC51EukAImONAZIZNtktgrNThwfLJn+syufjHaITiHRfJo
         A/Z95u4SFf1ed0a4u8uTUY12mVmD+PD04b9njR2zXE2bAbWW/8QB4+O42uDVjb6/ykAZ
         RAD4cORX0s2ELVIdMJyaI162xZfV9zTfLIZq/3Cq99ATSeMSlDYLGLMpOmT1LbSU7/Oo
         rxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p5vGg0RqALu5mFpfRw+5YKA5lKfc7l3wHZfGWX7shrY=;
        b=rhPHqujlZABN3xfzR8rFS5LQvwWBGV6/UFP8JJpSv39XX1WBCQ+WlY8jy56v8rzw6U
         bS4+B/AEY90FrstqIlHkdVR9+JLfBYanuZJ+yDh06qVLYyJkKhv5ztHjBhArJmYsfLJ4
         d2SbLsDbMwwyKW8XL5Nm6wtwMeH3Jwkw60zY+RFLePyGEX9tiBKYrSWDfwDwF/jp3W54
         ZeIq1GqUzKY7fTzrLYtSvqJxnpM7wHzDu0KfxCbSKd72R8AeAeoQhfdIU/tgGpV175FC
         F34lQsERs+E9cueIzffsiug45+LJlIv+jHok99RJa0IDXAgqG4ap5xUdkLIJwJdAnSzQ
         akvg==
X-Gm-Message-State: AOAM533haRzHU27TrTBPVGXd+GqbCKEQiXnphm6Wr4jwgCG8VOKPwIlJ
        WyXIPAdZl2e1hqrNPrgLdRlhePViJdP8v8X8
X-Google-Smtp-Source: ABdhPJzoffqZYjzQLRf50KkXkExxnbeq+X8pmr3Q43uM2CrWulsgG8VTG7Ee2Z+/bVH5c6KhToD1RA==
X-Received: by 2002:adf:e991:: with SMTP id h17mr14767306wrm.265.1621433642101;
        Wed, 19 May 2021 07:14:02 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:14:01 -0700 (PDT)
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
Subject: [PATCH 10/23] io_uring: add support for multiple CQs
Date:   Wed, 19 May 2021 15:13:21 +0100
Message-Id: <6f8364dc9df59b27b09472f262a545b42f8639a5.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TODO: don't rob all bits from params, use pointer to a struct

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 89 +++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h |  3 +-
 2 files changed, 71 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f05592ae5f41..067cfb3a6e4a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -91,6 +91,7 @@
 #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
 
 #define IO_DEFAULT_CQ		0
+#define IO_MAX_CQRINGS		1024
 
 /*
  * Shift of 9 is 512 entries, or exactly one page on 64-bit archs
@@ -417,7 +418,7 @@ struct io_ring_ctx {
 	unsigned long		cq_check_overflow;
 	unsigned		cq_extra;
 	struct wait_queue_head	cq_wait;
-	struct io_cqring	cqs[1];
+	struct io_cqring	*cqs;
 	unsigned int		cq_nr;
 
 	struct {
@@ -1166,6 +1167,9 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	if (!ctx)
 		return NULL;
 
+	ctx->cqs = kmalloc_array(p->nr_cq + 1, sizeof(ctx->cqs[0]), GFP_KERNEL);
+	if (!ctx->cqs)
+		goto err;
 	/*
 	 * Use 5 bits less than the max cq entries, that should give us around
 	 * 32 entries per hash list if totally full and uniformly spread.
@@ -8634,6 +8638,8 @@ static bool io_wait_rsrc_data(struct io_rsrc_data *data)
 
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
+	unsigned int i;
+
 	io_sq_thread_finish(ctx);
 
 	if (ctx->mm_account) {
@@ -8673,6 +8679,9 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
+	for (i = 1; i < ctx->cq_nr; i++)
+		io_mem_free(ctx->cqs[i].rings);
+	kfree(ctx->cqs);
 
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
@@ -9524,11 +9533,39 @@ static const struct file_operations io_uring_fops = {
 #endif
 };
 
+static void __io_init_cqring(struct io_cqring *cq, struct io_rings *rings,
+			   unsigned int entries)
+{
+	WRITE_ONCE(rings->cq_ring_entries, entries);
+	WRITE_ONCE(rings->cq_ring_mask, entries - 1);
+
+	cq->cached_tail = 0;
+	cq->rings = rings;
+	cq->entries = entries;
+}
+
+static int io_init_cqring(struct io_cqring *cq, unsigned int entries)
+{
+	struct io_rings *rings;
+	size_t size;
+
+	size = rings_size(0, entries, NULL);
+	if (size == SIZE_MAX)
+		return -EOVERFLOW;
+	rings = io_mem_alloc(size);
+	if (!rings)
+		return -ENOMEM;
+	__io_init_cqring(cq, rings, entries);
+	return 0;
+}
+
 static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 				  struct io_uring_params *p)
 {
+	u32 __user *cq_sizes = u64_to_user_ptr(p->cq_sizes);
 	struct io_rings *rings;
 	size_t size, sq_array_offset;
+	int i, ret;
 
 	/* make sure these are sane, as we already accounted them */
 	ctx->sq_entries = p->sq_entries;
@@ -9544,30 +9581,43 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	ctx->rings = rings;
 	ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
 	rings->sq_ring_mask = p->sq_entries - 1;
-	rings->cq_ring_mask = p->cq_entries - 1;
 	rings->sq_ring_entries = p->sq_entries;
-	rings->cq_ring_entries = p->cq_entries;
 
-	ctx->cqs[0].cached_tail = 0;
-	ctx->cqs[0].rings = rings;
-	ctx->cqs[0].entries = p->cq_entries;
+	__io_init_cqring(&ctx->cqs[0], rings, p->cq_entries);
 	ctx->cq_nr = 1;
 
 	size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
-	if (size == SIZE_MAX) {
-		io_mem_free(ctx->rings);
-		ctx->rings = NULL;
-		return -EOVERFLOW;
-	}
+	ret = -EOVERFLOW;
+	if (unlikely(size == SIZE_MAX))
+		goto err;
 
 	ctx->sq_sqes = io_mem_alloc(size);
-	if (!ctx->sq_sqes) {
-		io_mem_free(ctx->rings);
-		ctx->rings = NULL;
-		return -ENOMEM;
+	ret = -ENOMEM;
+	if (unlikely(!ctx->sq_sqes))
+		goto err;
+
+	for (i = 0; i < p->nr_cq; i++, ctx->cq_nr++) {
+		u32 sz;
+		long entries;
+
+		ret = -EFAULT;
+		if (copy_from_user(&sz, &cq_sizes[i], sizeof(sz)))
+			goto err;
+		entries = io_get_cqring_size(p, sz);
+		if (entries < 0) {
+			ret = entries;
+			goto err;
+		}
+		ret = io_init_cqring(&ctx->cqs[i + 1], entries);
+		if (ret)
+			goto err;
 	}
 
 	return 0;
+err:
+	io_mem_free(ctx->rings);
+	ctx->rings = NULL;
+	return ret;
 }
 
 static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
@@ -9653,6 +9703,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	} else {
 		p->cq_entries = 2 * p->sq_entries;
 	}
+	if (p->nr_cq > IO_MAX_CQRINGS)
+		return -EINVAL;
+	if (!p->nr_cq != !p->cq_sizes)
+		return -EINVAL;
 
 	ctx = io_ring_ctx_alloc(p);
 	if (!ctx)
@@ -9744,14 +9798,9 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 {
 	struct io_uring_params p;
-	int i;
 
 	if (copy_from_user(&p, params, sizeof(p)))
 		return -EFAULT;
-	for (i = 0; i < ARRAY_SIZE(p.resv); i++) {
-		if (p.resv[i])
-			return -EINVAL;
-	}
 
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index c2dfb179360a..92b61ca09ea5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -263,7 +263,8 @@ struct io_uring_params {
 	__u32 sq_thread_idle;
 	__u32 features;
 	__u32 wq_fd;
-	__u32 resv[3];
+	__u32 nr_cq;
+	__u64 cq_sizes;
 	struct io_sqring_offsets sq_off;
 	struct io_cqring_offsets cq_off;
 };
-- 
2.31.1

