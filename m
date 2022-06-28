Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1DDF55ED4F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbiF1TB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbiF1TAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:30 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EE919C02;
        Tue, 28 Jun 2022 12:00:15 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ge10so27683293ejb.7;
        Tue, 28 Jun 2022 12:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cc2i6+MHpZ7ZK8dQIgKI9vrMjg0qmVn/y1UW88z219M=;
        b=ADXOpUR3O49W4UKfgxHZww6vdKPSdY6G2PkXwDFy5PhaswYG6bEKQKghv/ooxhGGIh
         yodyFVCEGLNCwpWnRtApYFET563oqP1MpNnywyRsDE5fGOvTrEDyoZiGLhxyFuLuirIE
         l1ondENLVC8GKz86TfLf1Ea4zUGViYHL1Ho84fpT6uSwqsBqzdD6u+RmdmGqZ4OAPE67
         wH8NfcBgrRrTYRu30FNtH7xTbdHRrriimwwJlHubj3OOlKSBRE3GIWby/UAg2Llb0kvN
         0Ol9FMRHPcYPfYRVBsvzBKyVRtuuopZrvsUXS91Z7AEonx4VZ8TYNvA0UksfBqezN3xA
         QQmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cc2i6+MHpZ7ZK8dQIgKI9vrMjg0qmVn/y1UW88z219M=;
        b=OGzyLOHiOb18vuyySmiWBoa4Xml3YMbMmy/Y4pR3bCxsJJ4UHcsjPHBFit0oGAnU2F
         Sq+o6d7jICuj9nv1Aq9/e93qmBjZT5h4Z7LZ5tIy4dzECS4iioxspye/c5sr1k2GKhxm
         ALMZ5MMhMzHkGPQBc+MmccGcdW84yMSd+vNv5rrI6gJaiaobBbIUptn2IaIoytCocDlS
         WvfiSA2IbTqOFFgoY5dFCzDzw00QdKS8hsJOTvqQ08TI86iX7UjNbGs8txgGCyizYlDo
         4SFw6VcjDrvDX8gCF716tP3Q23r6mIft1cCQMmwLVY5OojGY56x1AsvtjaQFGI/aJ1I9
         z1xA==
X-Gm-Message-State: AJIora/xwFErM6k3Q+ZRFUujMm3aAlqTK/48L9oGvUkvmtWE+9xyV4Fl
        zfAXthsrQR86Qo3Xwey2atnKE2WUegSrSg==
X-Google-Smtp-Source: AGRyM1sIBdY5KRw+RjwHIfweX4YriDY/C12MfRShhLleIuMgr35iI8TUYcCy2QcTEBLVDbGYHPft+w==
X-Received: by 2002:a17:907:3d92:b0:726:39f9:4a33 with SMTP id he18-20020a1709073d9200b0072639f94a33mr18963947ejc.766.1656442813965;
        Tue, 28 Jun 2022 12:00:13 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 18/29] io_uring: add notification slot registration
Date:   Tue, 28 Jun 2022 19:56:40 +0100
Message-Id: <af374ecb2ec795a5fdd35cd2e11540f99d465860.1653992701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1653992701.git.asml.silence@gmail.com>
References: <cover.1653992701.git.asml.silence@gmail.com>
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
 fs/io_uring.c                 | 54 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h | 16 +++++++++++
 2 files changed, 70 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9ade0ea8552b..22427893549a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -94,6 +94,8 @@
 #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
 
+#define IORING_MAX_NOTIF_SLOTS	(1U << 10)
+
 /* only define max */
 #define IORING_MAX_FIXED_FILES	(1U << 20)
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
@@ -2972,6 +2974,49 @@ static __cold int io_notif_unregister(struct io_ring_ctx *ctx)
 	kvfree(ctx->notif_slots);
 	ctx->notif_slots = NULL;
 	ctx->nr_notif_slots = 0;
+	io_notif_cache_purge(ctx);
+	return 0;
+}
+
+static __cold int io_notif_register(struct io_ring_ctx *ctx,
+				    void __user *arg, unsigned int size)
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
 
@@ -13378,6 +13423,15 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_unregister_pbuf_ring(ctx, arg);
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
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 53e7dae92e42..96193bbda2e4 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -417,6 +417,9 @@ enum {
 	IORING_REGISTER_PBUF_RING		= 22,
 	IORING_UNREGISTER_PBUF_RING		= 23,
 
+	IORING_REGISTER_NOTIFIERS		= 24,
+	IORING_UNREGISTER_NOTIFIERS		= 25,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -463,6 +466,19 @@ struct io_uring_rsrc_update2 {
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
 
-- 
2.36.1

