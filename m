Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF6138904A
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354107AbhESOQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353989AbhESOPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:39 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CFCC061346;
        Wed, 19 May 2021 07:14:07 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id a4so14236973wrr.2;
        Wed, 19 May 2021 07:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GeM8NQyz7ORAxfAoFKPgRLBmcqCsjTuQcn5faI5QXyo=;
        b=AOSrvP98BmuRTG+FmxrZd8I3tCCSpMJXKXFD/SuP2lMQDfMX96t3VHpGFpHkof0Mpr
         MIJVQ3l8YOGH8W6qAJprrVQoGQH3wxbzWwlW1AqSm9bRj1qk0HRWVTXizjiDoXXcK1h1
         x/nOfz8LJ7f0KuOiPLJMp3R9srUM1Byf2XodyBxZZV3uDk8XaV3zVkjBz9FGs2msEznR
         rYw0NPjTjXUbAJsefh4YRbqz2rUUVdufrjOTx4z1kBPOV8NDCEsQ81vSr79MDL25O1d3
         yYqP2bKwZm1jLS2Kafs4GtoZtI3v41ypw8DZUaUlEKS/fSRp/UTiow4iSq90ha0kGbIH
         bofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GeM8NQyz7ORAxfAoFKPgRLBmcqCsjTuQcn5faI5QXyo=;
        b=L1DNBPvKTZ6/YaV1ZDCAiCeQh7VbiAReM4V3XjsUGtvJ9mAS0+U0+4xa+q/kplL58M
         7trFhCAs8F8e/bRoXmqtvMLXhNc+1+jdx1sdtA8mgxltQn3M0H55jiK7joGnOMMebUTJ
         P4BS4Zv6sVf+1efZ8StkWHBZaLK/dv8dzlRSyYrzpoRLPj4/+vH9Q1dZK9lZTb/wl6ek
         aADjXcH425FjY93KvaT3XyOOIzZRzfFVIG6/l7TwB6d4p7AReuiY23Ix8RrwMu7sHBdS
         cIITXIJx3WNlKMq64m6JimCQvtOlwbV5UeG4NygAdK+3cMxgxGpK+mFeyMbo6+fHYCKP
         8+LA==
X-Gm-Message-State: AOAM533TLISkvRGX7HCQuQt3uCqDMY7fMmGs8Dgttet0piwqajQ/G/sp
        WGiPU4lrxb1DiWNa7zsznxJCCQ0zNVEgaMy/
X-Google-Smtp-Source: ABdhPJw7O8/hvA1MopjfEanOYzwwEajXtj0dfW4VBn7OK2Y1y3d3TQUYQKIK2wyVyHhTyB8GiOOQ8Q==
X-Received: by 2002:a5d:440d:: with SMTP id z13mr14641480wrq.134.1621433645790;
        Wed, 19 May 2021 07:14:05 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:14:05 -0700 (PDT)
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
Subject: [PATCH 13/23] io_uring: implement bpf prog registration
Date:   Wed, 19 May 2021 15:13:24 +0100
Message-Id: <c246d3736b9440532f3e82199a616e3f74d1b8ba.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[de]register BPF programs through io_uring_register() with new
IORING_ATTACH_BPF and IORING_DETACH_BPF commands.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 81 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  2 +
 2 files changed, 83 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 882b16b5e5eb..b13cbcd5c47b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -78,6 +78,7 @@
 #include <linux/task_work.h>
 #include <linux/pagemap.h>
 #include <linux/io_uring.h>
+#include <linux/bpf.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -103,6 +104,8 @@
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
+#define IORING_MAX_BPF_PROGS	100
+
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
 				IOSQE_BUFFER_SELECT)
@@ -266,6 +269,10 @@ struct io_restriction {
 	bool registered;
 };
 
+struct io_bpf_prog {
+	struct bpf_prog *prog;
+};
+
 enum {
 	IO_SQ_THREAD_SHOULD_STOP = 0,
 	IO_SQ_THREAD_SHOULD_PARK,
@@ -411,6 +418,10 @@ struct io_ring_ctx {
 	struct xarray		personalities;
 	u32			pers_next;
 
+	/* bpf programs */
+	unsigned		nr_bpf_progs;
+	struct io_bpf_prog	*bpf_progs;
+
 	struct fasync_struct	*cq_fasync;
 	struct eventfd_ctx	*cq_ev_fd;
 	atomic_t		cq_timeouts;
@@ -8627,6 +8638,66 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
+static int io_bpf_unregister(struct io_ring_ctx *ctx)
+{
+	int i;
+
+	if (!ctx->nr_bpf_progs)
+		return -ENXIO;
+
+	for (i = 0; i < ctx->nr_bpf_progs; ++i) {
+		struct bpf_prog *prog = ctx->bpf_progs[i].prog;
+
+		if (prog)
+			bpf_prog_put(prog);
+	}
+	kfree(ctx->bpf_progs);
+	ctx->bpf_progs = NULL;
+	ctx->nr_bpf_progs = 0;
+	return 0;
+}
+
+static int io_bpf_register(struct io_ring_ctx *ctx, void __user *arg,
+			   unsigned int nr_args)
+{
+	u32 __user *fds = arg;
+	int i, ret = 0;
+
+	if (!nr_args || nr_args > IORING_MAX_BPF_PROGS)
+		return -EINVAL;
+	if (ctx->nr_bpf_progs)
+		return -EBUSY;
+
+	ctx->bpf_progs = kcalloc(nr_args, sizeof(ctx->bpf_progs[0]),
+				 GFP_KERNEL);
+	if (!ctx->bpf_progs)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_args; ++i) {
+		struct bpf_prog *prog;
+		u32 fd;
+
+		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
+			ret = -EFAULT;
+			break;
+		}
+		if (fd == -1)
+			continue;
+
+		prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_IOURING);
+		if (IS_ERR(prog)) {
+			ret = PTR_ERR(prog);
+			break;
+		}
+		ctx->bpf_progs[i].prog = prog;
+	}
+
+	ctx->nr_bpf_progs = i;
+	if (ret)
+		io_bpf_unregister(ctx);
+	return ret;
+}
+
 static bool io_wait_rsrc_data(struct io_rsrc_data *data)
 {
 	if (!data)
@@ -8657,6 +8728,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
+	io_bpf_unregister(ctx);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
 
@@ -10188,6 +10260,15 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	case IORING_REGISTER_RSRC_UPDATE:
 		ret = io_register_rsrc_update(ctx, arg, nr_args);
 		break;
+	case IORING_REGISTER_BPF:
+		ret = io_bpf_register(ctx, arg, nr_args);
+		break;
+	case IORING_UNREGISTER_BPF:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_bpf_unregister(ctx);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 67a97c793de7..b450f41d7389 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -304,6 +304,8 @@ enum {
 	IORING_REGISTER_ENABLE_RINGS		= 12,
 	IORING_REGISTER_RSRC			= 13,
 	IORING_REGISTER_RSRC_UPDATE		= 14,
+	IORING_REGISTER_BPF			= 15,
+	IORING_UNREGISTER_BPF			= 16,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
-- 
2.31.1

