Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7B5389039
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354054AbhESOPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347171AbhESOPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:30 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BA4C06138F;
        Wed, 19 May 2021 07:14:02 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id a4so14236691wrr.2;
        Wed, 19 May 2021 07:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EJHSY4GTkUlJ+ZXFSK+xFoztKbsreaR/qQT5e4Mm7Vk=;
        b=VpmUnLwdywtGsaomIJ9w3D94b1zm2owM3muYBDMYOuMmlDy4VY0YQT6VOLQxT7YJpQ
         QzajMZzPOI5H7yL3TTYVvPgNqykBnWBCXfB7q6ZHR2Q2/ci73Q715uDGHuohZ06L1Tu0
         a+A0JXvHfD4YTc7GE4lqbHJTA+VD6TWu6TXficdQ7AFABKl3sAbs4uhOydFY6YjpbkVD
         7c2lgNCjA6UZL+BI1QE0QDYVCuyjuz/I6beCOpk2jW9Fdls1lgYxa5WKlJvWvIgl33Cs
         vcFAzawtikeRxIswzelxeWKfdf/kvPS/UXrwzi4sCCWNuF9CPextXeVI2UYAIbMzz8BX
         s6Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EJHSY4GTkUlJ+ZXFSK+xFoztKbsreaR/qQT5e4Mm7Vk=;
        b=DP8rx2fUDKa6FcBTLLAhfOaF0a3m4kzw1s73DLkSymRxk9FaDH5CJcaXYZfcXIj+bC
         VIe/aStE5K44PPQb2t/Ga7EmgH/DC8q8FqtCuudLO5kb0YEnpLLeOGazsj03DBA9BANi
         Ovw6MyuU5G6B0iNQ5mMd5mVyUR1Ct15fqv6JZ73nHXrZFEEsV6Fz2ZLNAfRTk3Ju6pfe
         Hadd73nbRyIocfMX+T0qhFfFjXN9F88HD5L4rE7NkusqyTnV+kYfgJy5nFPq5+7svNdc
         JL2vRZlSkCTgKBECtdi7cAMefcpcpm73tMpLfDREGF0HEbrC+LuBP6UT0pSX+WJ1BvmG
         bKyg==
X-Gm-Message-State: AOAM531plHoTpUiIUdxK0U5Be06iZLxpHmjFN4AwJepxON+017EX5HzZ
        nzMBARhgPZppdwGvDlXfmvd92qnJXsBxfWgp
X-Google-Smtp-Source: ABdhPJwPUYcxqEtO1WUZ6UbamK3hCLDfJxNDZea9HK3S6q1BE8ZpYYlMAzy3fTkuiAxC65yCiLqibw==
X-Received: by 2002:a05:6000:1286:: with SMTP id f6mr14488512wrx.226.1621433640869;
        Wed, 19 May 2021 07:14:00 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:14:00 -0700 (PDT)
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
Subject: [PATCH 09/23] io_uring: extract cq size helper
Date:   Wed, 19 May 2021 15:13:20 +0100
Message-Id: <743a1d192f84fb2294840d802b45cdd005d4c926.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract a helper calculating CQ size from an userspace specified number
of entries.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 356a5dc90f46..f05592ae5f41 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1139,6 +1139,24 @@ static inline bool io_is_timeout_noseq(struct io_kiocb *req)
 	return !req->timeout.off;
 }
 
+static long io_get_cqring_size(struct io_uring_params *p, unsigned entries)
+{
+	/*
+	 * If IORING_SETUP_CQSIZE is set, we do the same roundup
+	 * to a power-of-two, if it isn't already. We do NOT impose
+	 * any cq vs sq ring sizing.
+	 */
+	if (!entries)
+		return -EINVAL;
+	if (entries > IORING_MAX_CQ_ENTRIES) {
+		if (!(p->flags & IORING_SETUP_CLAMP))
+			return -EINVAL;
+		entries = IORING_MAX_CQ_ENTRIES;
+	}
+	entries = roundup_pow_of_two(entries);
+	return entries;
+}
+
 static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
@@ -9625,21 +9643,13 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	 */
 	p->sq_entries = roundup_pow_of_two(entries);
 	if (p->flags & IORING_SETUP_CQSIZE) {
-		/*
-		 * If IORING_SETUP_CQSIZE is set, we do the same roundup
-		 * to a power-of-two, if it isn't already. We do NOT impose
-		 * any cq vs sq ring sizing.
-		 */
-		if (!p->cq_entries)
-			return -EINVAL;
-		if (p->cq_entries > IORING_MAX_CQ_ENTRIES) {
-			if (!(p->flags & IORING_SETUP_CLAMP))
-				return -EINVAL;
-			p->cq_entries = IORING_MAX_CQ_ENTRIES;
-		}
-		p->cq_entries = roundup_pow_of_two(p->cq_entries);
-		if (p->cq_entries < p->sq_entries)
+		long cq_entries = io_get_cqring_size(p, p->cq_entries);
+
+		if (cq_entries < 0)
+			return cq_entries;
+		if (cq_entries < p->sq_entries)
 			return -EINVAL;
+		p->cq_entries = cq_entries;
 	} else {
 		p->cq_entries = 2 * p->sq_entries;
 	}
-- 
2.31.1

