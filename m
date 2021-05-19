Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD99389063
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354316AbhESOQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354040AbhESOPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:49 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F82C0613CE;
        Wed, 19 May 2021 07:14:12 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso3530350wmh.4;
        Wed, 19 May 2021 07:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h10pgO2Ruz23aXWMMYRea29pOW4EecEeGd3AsobhL9Y=;
        b=TTGtF9J0FTnKB4QaPpfc7o8poBmJ4z/D3nXatcnaCO5uZpjltSL03x9BZTehpnPJO6
         jwFUZL3OpnxkD7O5/p7ECuqrH4V9vLl5Fvzz8qIpRFKzZ8mp0xiMjlC2TBr4m0VDR6VJ
         miFSU2db+Ph7fGajw1OT1Jv4y5o4L9+PPCzboHQP+mK+inYq5VUdaLIImNIWIEtT/wtL
         CfC0tdYfgWyPe877Eb2KUD55n4nCZSIH935Ox1qeDkRK8cfIrvoN73m4+ZEWEm2PU546
         bAtzhTdoziCudpYx2ZqMTmBu0CWZPYXk1DFK/wTI799s7yXFkFzEodwMC4yzOKMtMvrJ
         /jkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h10pgO2Ruz23aXWMMYRea29pOW4EecEeGd3AsobhL9Y=;
        b=n17Y7nELT3uSarWYEsdNVepF8CofQjQOlB+KMlahdHCAfax+2e5GsHNvWVVp2PZ8Pk
         O6ZHSphvQDB1UY+rWI/5QPBPHoJARKlAOvKfr6Xbnkch5PwyNPVrEfvmSo9jGFqqlyT7
         SCY+4bbxcsO50DHwpxuD/tZ+S1QFEg87867xDsh+Iz1pGNbvRNIt0gTFH9nkbdYQmU9G
         Odaif0mp5VYjfha+mdCXcQXhmVVM5ae3OSmaR3IDEqqsVNq48viFAHdHPkVes025cxyl
         i2Y3hxCXh4W16/dM/Xg3g7HQbbb3H4z3/73187oxYDuBqyVL7kCOcq0TbpVBCa1pNoAU
         6dHQ==
X-Gm-Message-State: AOAM531T/vgnkmQaft8BnQrfu+8txZaZcfQWEV611RZ35Fx6NlMxuZfo
        amuIhVxfNOfggOL2beHSH3/46fuq/Rm1BM+R
X-Google-Smtp-Source: ABdhPJwNoisVqwqptYNHAySSmwLHuzNJzQX1iwZxlzcR4ymwCUi/E4qrctdCa105hSRPq1kKTF6HdA==
X-Received: by 2002:a7b:c92e:: with SMTP id h14mr11734868wml.179.1621433650847;
        Wed, 19 May 2021 07:14:10 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:14:10 -0700 (PDT)
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
Subject: [PATCH 17/23] io_uring: enable bpf to reap CQEs
Date:   Wed, 19 May 2021 15:13:28 +0100
Message-Id: <e12812fd4cab5db70f0ae290166d0bf3a1f89076.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c            | 48 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/bpf.h |  1 +
 2 files changed, 49 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 464d630904e2..7c165b2ce8e4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10394,6 +10394,42 @@ BPF_CALL_5(io_bpf_emit_cqe, struct io_bpf_ctx *,		bpf_ctx,
 	return submitted ? 0 : -ENOMEM;
 }
 
+BPF_CALL_4(io_bpf_reap_cqe, struct io_bpf_ctx *,		bpf_ctx,
+			    u32,				cq_idx,
+			    struct io_uring_cqe *,		cqe_out,
+			    u32,				cqe_len)
+{
+	struct io_ring_ctx *ctx = bpf_ctx->ctx;
+	struct io_uring_cqe *cqe;
+	struct io_cqring *cq;
+	struct io_rings *r;
+	unsigned tail, head, mask;
+	int ret = -EINVAL;
+
+	if (unlikely(cqe_len != sizeof(*cqe_out)))
+		goto err;
+	if (unlikely(cq_idx >= ctx->cq_nr))
+		goto err;
+
+	cq = &ctx->cqs[cq_idx];
+	r = cq->rings;
+	tail = READ_ONCE(r->cq.tail);
+	head = smp_load_acquire(&r->cq.head);
+
+	ret = -ENOENT;
+	if (unlikely(tail == head))
+		goto err;
+
+	mask = cq->entries - 1;
+	cqe = &r->cqes[head & mask];
+	memcpy(cqe_out, cqe, sizeof(*cqe_out));
+	WRITE_ONCE(r->cq.head, head + 1);
+	return 0;
+err:
+	memset(cqe_out, 0, sizeof(*cqe_out));
+	return ret;
+}
+
 const struct bpf_func_proto io_bpf_queue_sqe_proto = {
 	.func = io_bpf_queue_sqe,
 	.gpl_only = false,
@@ -10414,6 +10450,16 @@ const struct bpf_func_proto io_bpf_emit_cqe_proto = {
 	.arg5_type = ARG_ANYTHING,
 };
 
+const struct bpf_func_proto io_bpf_reap_cqe_proto = {
+	.func = io_bpf_reap_cqe,
+	.gpl_only = false,
+	.ret_type = RET_INTEGER,
+	.arg1_type = ARG_PTR_TO_CTX,
+	.arg2_type = ARG_ANYTHING,
+	.arg3_type = ARG_PTR_TO_UNINIT_MEM,
+	.arg4_type = ARG_CONST_SIZE,
+};
+
 static const struct bpf_func_proto *
 io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -10424,6 +10470,8 @@ io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return prog->aux->sleepable ? &io_bpf_queue_sqe_proto : NULL;
 	case BPF_FUNC_iouring_emit_cqe:
 		return &io_bpf_emit_cqe_proto;
+	case BPF_FUNC_iouring_reap_cqe:
+		return &io_bpf_reap_cqe_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c6b023be7848..7719ec4a33e7 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4084,6 +4084,7 @@ union bpf_attr {
 	FN(check_mtu),			\
 	FN(iouring_queue_sqe),		\
 	FN(iouring_emit_cqe),		\
+	FN(iouring_reap_cqe),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.31.1

