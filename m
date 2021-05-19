Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DAE389059
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354243AbhESOQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353994AbhESOPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:40 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37232C061347;
        Wed, 19 May 2021 07:14:11 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id v12so14199390wrq.6;
        Wed, 19 May 2021 07:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i3e5Ax3mN/Y6yPJpYOCMTBCrnugW+yH6avkA8+dpTMg=;
        b=o0IMFRjUNXwCpOHk3pjSBZPz4dX7RtIs+Nbuov846dsGZ93uGA1REcYDEmAyWquxZx
         6uoKNeCUigLeYsDZBvBwOajq6vLKsl57jSaHDitctlNZ6FYeAUdNFU3xUDJZ5uqNlq+9
         GbiyxGeTgpyYriKH+0usuyUqnhEAt6nV1HS+hTxUYrCyMzUpzqQYOsHj3oHcV3Ic6TuR
         rTX/V1sI5kj26beypsIO4+IoSY65UwAJvm14yzNu1ngOcUY058VzCKMVFgpdS1NJHQf7
         a/+oax78Nhpdj5SB2+b1BB/JictgIREppkWX+FPSVXinpDEv1FhN84VENlKibbmWh96X
         TgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i3e5Ax3mN/Y6yPJpYOCMTBCrnugW+yH6avkA8+dpTMg=;
        b=LNunQli8heNAtCxfkf2C9WVHL08whV4qRgS0UlISEywM1H6w0Ef8KQNonVCcUyttxF
         dkR+DaEKC7mlUf2z/zD+UGn7Q9WZ9iDCeBbZPdcjR+zBaYb1LlH7TWa/R3p2a06+GXi1
         RwUSsNCrsz0Ub3IQPiRUgBaJvGvkCBGCDhGt8TNrOX5qj5Giygr22eeFoieFyHDhGeCk
         poaPohRO0E6Vs9E74lmBOyMApjIA/flZvN5gj/uqoCeeX2pYSmnuHCfhQLpSX1Nqwpl+
         awO5qpdlpEbyAybspDlCOOuEGparvJmr9Rqbdz66xyxbD/6N4f+HGDa0rYomov9wDkCP
         O/fQ==
X-Gm-Message-State: AOAM532PQiTc+yP2KWTEwTsLeyQSdRlwGG+SsHjf0EfkA6hQpkCOYBpb
        bQByItyuXRd1P7bE64xdkpHbryOFh8PyAOG8
X-Google-Smtp-Source: ABdhPJwDsCZjLb/cYFXSCoIiv0fCMqbZyLQ3qdXf4hFV92BafEpmsWtCKjBjqWOXH65ZDuGBfT2AJQ==
X-Received: by 2002:adf:fe07:: with SMTP id n7mr14908474wrr.388.1621433649552;
        Wed, 19 May 2021 07:14:09 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:14:09 -0700 (PDT)
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
Subject: [PATCH 16/23] io_uring: enable bpf to submit CQEs
Date:   Wed, 19 May 2021 15:13:27 +0100
Message-Id: <b30d850d24bd7fb926bc0f60a4e3e2e62e90838f.1621424513.git.asml.silence@gmail.com>
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
 fs/io_uring.c            | 36 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/bpf.h |  1 +
 2 files changed, 37 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aae786291c57..464d630904e2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10371,6 +10371,29 @@ BPF_CALL_3(io_bpf_queue_sqe, struct io_bpf_ctx *,		bpf_ctx,
 	return !io_submit_sqe(ctx, req, sqe);
 }
 
+BPF_CALL_5(io_bpf_emit_cqe, struct io_bpf_ctx *,		bpf_ctx,
+			    u32,				cq_idx,
+			    u64,				user_data,
+			    s32,				res,
+			    u32,				flags)
+{
+	struct io_ring_ctx *ctx = bpf_ctx->ctx;
+	bool submitted;
+
+	if (unlikely(cq_idx >= ctx->cq_nr))
+		return -EINVAL;
+
+	spin_lock_irq(&ctx->completion_lock);
+	submitted = io_cqring_fill_event(ctx, user_data, res, flags, cq_idx);
+	io_commit_cqring(ctx);
+	ctx->cq_extra++;
+	spin_unlock_irq(&ctx->completion_lock);
+	if (submitted)
+		io_cqring_ev_posted(ctx);
+
+	return submitted ? 0 : -ENOMEM;
+}
+
 const struct bpf_func_proto io_bpf_queue_sqe_proto = {
 	.func = io_bpf_queue_sqe,
 	.gpl_only = false,
@@ -10380,6 +10403,17 @@ const struct bpf_func_proto io_bpf_queue_sqe_proto = {
 	.arg3_type = ARG_CONST_SIZE,
 };
 
+const struct bpf_func_proto io_bpf_emit_cqe_proto = {
+	.func = io_bpf_emit_cqe,
+	.gpl_only = false,
+	.ret_type = RET_INTEGER,
+	.arg1_type = ARG_PTR_TO_CTX,
+	.arg2_type = ARG_ANYTHING,
+	.arg3_type = ARG_ANYTHING,
+	.arg4_type = ARG_ANYTHING,
+	.arg5_type = ARG_ANYTHING,
+};
+
 static const struct bpf_func_proto *
 io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -10388,6 +10422,8 @@ io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
 	case BPF_FUNC_iouring_queue_sqe:
 		return prog->aux->sleepable ? &io_bpf_queue_sqe_proto : NULL;
+	case BPF_FUNC_iouring_emit_cqe:
+		return &io_bpf_emit_cqe_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index cc268f749a7d..c6b023be7848 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4083,6 +4083,7 @@ union bpf_attr {
 	FN(sock_from_file),		\
 	FN(check_mtu),			\
 	FN(iouring_queue_sqe),		\
+	FN(iouring_emit_cqe),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.31.1

