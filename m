Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9468038904C
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354125AbhESOQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353961AbhESOPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:31 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122DFC061344;
        Wed, 19 May 2021 07:14:05 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id y184-20020a1ce1c10000b02901769b409001so3432498wmg.3;
        Wed, 19 May 2021 07:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K6PlxR1Sd0Afhg7WgBhZnU12RDoSmxGULXPHeQgmUtQ=;
        b=kZbVe1+YAuC3A2cvHPLAJKF9rDZiNU07dbnjjQ+8rdlThDSiL2BHpe9buOIp2lCnOb
         p3agNsXrGjlkCZEwu66m04+44YK7oCtRZNnEXh1Jk/K2OIxIBgWZWolRExdfFEOJjOlS
         mPdeoONhtOPixZUtK+x8cgjkf/mjYv2PEWaRqwBULBq2RQpzKArXpTloDRDwaNRwi8vf
         PGKW212hS8Qw0IfewBVjzt4JhPJWzecTdZVChh55WZmRuOOUkNBonaVlVqLPKV7rTYD/
         ZUSomRhOlpe+3LYWNVzKUjSu3vW8Eo/4+k/Vcuf6SifUESZqsqJjDEnhOFj60WFHTCXH
         9QDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K6PlxR1Sd0Afhg7WgBhZnU12RDoSmxGULXPHeQgmUtQ=;
        b=RLLaCoWLczvlRqf2k8Kr5EgJqd/PLB4tZyJlAUQc3FWt4OBPx6R8QRn6xQJscLCG+8
         CXGj2qmhM8B468UYZb2kxohgdvHPT+O6eFJQ4cyfegKWR4a+PSSlMT337VXhNtpGscCS
         b8NpoI5ziCBNtyPwKQaH5ZRk6kA8wXumE+UmvnNHS+3F2/tiJ7gL1NjbVQkczgbYQ6Ei
         L+p/LZfHakbsffEATAmz+ksZxxiROH4GksQDosVZARM/3SoKriTSHTuhS8uwAz/K517z
         N1ZjqQS8k8NChD5RieKoNKJu931QFw6W5F3lWZlKzCXGM+xgI33NaEYfdA00eY9lptcS
         PPXA==
X-Gm-Message-State: AOAM530z34Zk79raN5a4du/n7c/ikhJg8k6OcN/tbm7Wm4v3aRqWRUi/
        ekuJyPrx5sFXC2yttGhIvfObHnsZqqPpsWPv
X-Google-Smtp-Source: ABdhPJwZT+EsBrggiDOnFydu0K3+0eay6r0x0styanpMdNMyczuPKrpqOosZc0yumdIULPYGxSSxQg==
X-Received: by 2002:a7b:c041:: with SMTP id u1mr11549476wmc.95.1621433643523;
        Wed, 19 May 2021 07:14:03 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:14:03 -0700 (PDT)
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
Subject: [PATCH 11/23] io_uring: enable mmap'ing additional CQs
Date:   Wed, 19 May 2021 15:13:22 +0100
Message-Id: <0b54c7e684a2a9c3cb1a3cddfe48790e79bfbb89.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TODO: get rid of extra offset

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 13 ++++++++++++-
 include/uapi/linux/io_uring.h |  2 ++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 067cfb3a6e4a..1a4c9e513ac9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9207,6 +9207,7 @@ static void *io_uring_validate_mmap_request(struct file *file,
 	struct io_ring_ctx *ctx = file->private_data;
 	loff_t offset = pgoff << PAGE_SHIFT;
 	struct page *page;
+	unsigned long cq_idx;
 	void *ptr;
 
 	switch (offset) {
@@ -9218,7 +9219,15 @@ static void *io_uring_validate_mmap_request(struct file *file,
 		ptr = ctx->sq_sqes;
 		break;
 	default:
-		return ERR_PTR(-EINVAL);
+		if (offset < IORING_OFF_CQ_RING_EXTRA)
+			return ERR_PTR(-EINVAL);
+		offset -= IORING_OFF_CQ_RING_EXTRA;
+		if (offset % IORING_STRIDE_CQ_RING)
+			return ERR_PTR(-EINVAL);
+		cq_idx = offset / IORING_STRIDE_CQ_RING;
+		if (cq_idx >= ctx->cq_nr)
+			return ERR_PTR(-EINVAL);
+		ptr = ctx->cqs[cq_idx].rings;
 	}
 
 	page = virt_to_head_page(ptr);
@@ -9615,6 +9624,8 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 
 	return 0;
 err:
+	while (ctx->cq_nr > 1)
+		io_mem_free(ctx->cqs[--ctx->cq_nr].rings);
 	io_mem_free(ctx->rings);
 	ctx->rings = NULL;
 	return ret;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92b61ca09ea5..67a97c793de7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -203,6 +203,8 @@ enum {
 #define IORING_OFF_SQ_RING		0ULL
 #define IORING_OFF_CQ_RING		0x8000000ULL
 #define IORING_OFF_SQES			0x10000000ULL
+#define IORING_OFF_CQ_RING_EXTRA	0x1200000ULL
+#define IORING_STRIDE_CQ_RING		0x0100000ULL
 
 /*
  * Filled with the offset for mmap(2)
-- 
2.31.1

