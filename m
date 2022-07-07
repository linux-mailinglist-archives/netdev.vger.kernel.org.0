Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE4B56A184
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbiGGLw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235472AbiGGLwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:12 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E84D564D1;
        Thu,  7 Jul 2022 04:52:08 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bk26so10879991wrb.11;
        Thu, 07 Jul 2022 04:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+ezDBB9HJAZBI4ahE1FxGpP6vMsCBfNd1fOFDrXYD+E=;
        b=d/KzkFf0dlzuz0vAfo1xFmo7HhGrlV2kj2zwbvG8VC9urem7lc3yRyqzj8KF/syNm1
         j8JngnPUuum9ywJxkYJXvVIm2pX9xo2nCVXTpff32L72QjQw+BiIN4e/cG/ZdycGA2Tx
         JMgmqx5tequF4V6INtewSoJCEgDM+N1Wm/cRgWrmGNGaUjXoXTEGOaSz4Jjc3Rl64Wi7
         XEhlDDguQbGBsaaWpZpEOtGI7p4YCJYQpoCrrDPwOEwkSdB7v+mL6qHT2EW+RU3ZXffc
         NiK8Z7BzjO0zb97Nl39MDF0yTaenxDHwy0kItJxh1bxZtTwudIWYabieFa7Ob5LEF+qw
         wKJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ezDBB9HJAZBI4ahE1FxGpP6vMsCBfNd1fOFDrXYD+E=;
        b=e9SH1W1XX00kKtkCRUykxfZqeXDdeWAixNWJrDiU+4iX1vBM7dU4GUc2QEfZ4gA1O3
         CdpbakIn6nV8T7c/gZzKyQRuOn4Cp6fy74GpIrqeSg1goHVTjSekAe7eZGsD0cWW+7jq
         t/vcf/smfn3ilIYAylUlZz7mwYftuFJZgbfrriAvaLdQu+PG2HfImR41FClOZhTDFW0t
         uZ6x5KAqvpZnwPqFmQjcpA3J6qqT14o60kp820dx6KVXu2fkN/1LiWjLOst7dky6Jq16
         gZdYNXv1d4iMrPEAhrPr33T/+gvpdoszj/sspmnYoBSecOMoGUZDq814Q70y17EX9PAj
         4+MA==
X-Gm-Message-State: AJIora+cJ3a7+CcJrCPWGE96XyUpstNmkxJFzzzH9kWbgkJLGzmWXLA0
        MTtXklYTKtnkSMIEfy4mKIf72u2zkVboW38Ynqs=
X-Google-Smtp-Source: AGRyM1utbcGQeXsnlJQ3nGaTNUsYYGz6GjByDYc8Hh/+OwFAMWiKUqW/Lpb6y3jSdvl0Bg74aWHF2g==
X-Received: by 2002:adf:fb83:0:b0:21d:649a:72d9 with SMTP id a3-20020adffb83000000b0021d649a72d9mr22525310wrr.688.1657194727477;
        Thu, 07 Jul 2022 04:52:07 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:52:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 18/27] io_uring: add notification slot registration
Date:   Thu,  7 Jul 2022 12:49:49 +0100
Message-Id: <d77393d539f38342b70b5dbbf10f482bd3c7da40.1657194434.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657194434.git.asml.silence@gmail.com>
References: <cover.1657194434.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the userspace to register and unregister notification slots.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 17 ++++++++++++++
 io_uring/io_uring.c           |  9 ++++++++
 io_uring/notif.c              | 43 +++++++++++++++++++++++++++++++++++
 io_uring/notif.h              |  3 +++
 4 files changed, 72 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e858dba2e6c9..f1ba8e934168 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -454,6 +454,10 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
+	/* zerocopy notification API */
+	IORING_REGISTER_NOTIFIERS		= 26,
+	IORING_UNREGISTER_NOTIFIERS		= 27,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -500,6 +504,19 @@ struct io_uring_rsrc_update2 {
 	__u32 resv2;
 };
 
+struct io_uring_notification_slot {
+	__u64 tag;
+	__u64 resv[3];
+};
+
+struct io_uring_notification_register {
+	__u32 nr_slots;
+	__u32 resv;
+	__u64 resv2;
+	__u64 data;
+	__u64 resv3;
+};
+
 /* Skip updating fd indexes set to this value in the fd table */
 #define IORING_REGISTER_FILES_SKIP	(-2)
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bdc5a2839d94..41ef98a43d32 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3875,6 +3875,15 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_file_alloc_range(ctx, arg);
 		break;
+	case IORING_REGISTER_NOTIFIERS:
+		ret = io_notif_register(ctx, arg, nr_args);
+		break;
+	case IORING_UNREGISTER_NOTIFIERS:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_notif_unregister(ctx);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 0a2e98bd74f6..e6d98dc208c7 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -162,5 +162,48 @@ __cold int io_notif_unregister(struct io_ring_ctx *ctx)
 	kvfree(ctx->notif_slots);
 	ctx->notif_slots = NULL;
 	ctx->nr_notif_slots = 0;
+	io_notif_cache_purge(ctx);
+	return 0;
+}
+
+__cold int io_notif_register(struct io_ring_ctx *ctx,
+			     void __user *arg, unsigned int size)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_uring_notification_slot __user *slots;
+	struct io_uring_notification_slot slot;
+	struct io_uring_notification_register reg;
+	unsigned i;
+
+	if (ctx->nr_notif_slots)
+		return -EBUSY;
+	if (size != sizeof(reg))
+		return -EINVAL;
+	if (copy_from_user(&reg, arg, sizeof(reg)))
+		return -EFAULT;
+	if (!reg.nr_slots || reg.nr_slots > IORING_MAX_NOTIF_SLOTS)
+		return -EINVAL;
+	if (reg.resv || reg.resv2 || reg.resv3)
+		return -EINVAL;
+
+	slots = u64_to_user_ptr(reg.data);
+	ctx->notif_slots = kvcalloc(reg.nr_slots, sizeof(ctx->notif_slots[0]),
+				GFP_KERNEL_ACCOUNT);
+	if (!ctx->notif_slots)
+		return -ENOMEM;
+
+	for (i = 0; i < reg.nr_slots; i++, ctx->nr_notif_slots++) {
+		struct io_notif_slot *notif_slot = &ctx->notif_slots[i];
+
+		if (copy_from_user(&slot, &slots[i], sizeof(slot))) {
+			io_notif_unregister(ctx);
+			return -EFAULT;
+		}
+		if (slot.resv[0] | slot.resv[1] | slot.resv[2]) {
+			io_notif_unregister(ctx);
+			return -EINVAL;
+		}
+		notif_slot->tag = slot.tag;
+	}
 	return 0;
 }
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 1dd48efb7744..00efe164bdc4 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -6,6 +6,7 @@
 #include <linux/nospec.h>
 
 #define IO_NOTIF_SPLICE_BATCH	32
+#define IORING_MAX_NOTIF_SLOTS (1U << 10)
 
 struct io_notif {
 	struct ubuf_info	uarg;
@@ -48,6 +49,8 @@ struct io_notif_slot {
 	u32			seq;
 };
 
+int io_notif_register(struct io_ring_ctx *ctx,
+		      void __user *arg, unsigned int size);
 int io_notif_unregister(struct io_ring_ctx *ctx);
 void io_notif_cache_purge(struct io_ring_ctx *ctx);
 
-- 
2.36.1

