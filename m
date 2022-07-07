Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836F756A193
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbiGGLwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235497AbiGGLwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:10 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E5F564CA;
        Thu,  7 Jul 2022 04:52:06 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id v67-20020a1cac46000000b003a1888b9d36so10890982wme.0;
        Thu, 07 Jul 2022 04:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7UzeQaTQZy+qkWsDQJne9orKwjzmVDjXh7VXgGpnuFg=;
        b=enf/qNVVS/BjnWhlcj1ZNs2RiobUrXSwlFWQlAt+wQRTx9JbK5iecSEHNTnlXfRGVE
         0+FSc+S5QuXlRAsfDI0Usy3+EkhMLuqzz56wINmSunrmxn6A8+yvd4/fezrGQ3PM4yh5
         j/XL8XANfjKn6e179pvlp4ZeqyLDi9wYK5qhTeuDJ4LOncjHvgYBYFVm4SKY8JvB17/s
         gBlaCaSkN0NaRsL1euRIZfgA9+lriUuOyvkd0OpPGCagH5zyZsa+XmV5WpIxP3pd6S0c
         YhU1P4mgmilLnNRWMwqiQEiB9VhP3MqBvU5chmq659VMNgRGiAkmfEbsw1O2sO94HEES
         zTqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7UzeQaTQZy+qkWsDQJne9orKwjzmVDjXh7VXgGpnuFg=;
        b=QUToOxGcmL+3lYonXnydig8TlN4f+Bp7gAHqFmcUR2UmRADiJO9YPPMOAsZMtieXbI
         aPziNQlnYkaCpFALw8ubFf32CgPboT5S3kjpMElhZnQmYYPiJx5FE4JzDdOoOwCZSdBq
         uIfIpq7m2MVmzFtWCHIIMBeI0HZgr1ZgITR7EWGl6FlE0YW4VYwljIIJEwXnWyTHbBVc
         YD3XPfH37OLjhXXNr/oZUsWTYYA19ja2ImOD9Irz4+++djC7QyE4w9NK2Qwl4kZyy5Eg
         6b+v4XwRtdMAQWLwoZcwGE0Gr9wMazFvVCfxzxO0pjU+TteahPbaOWAgPTKFHGIMA0f3
         UqDg==
X-Gm-Message-State: AJIora8A1M2+ehUlWcK67VjIPmgozU3Zm5r/mOjv+3IaD9EIcWUU67Ap
        W/vAufkPu9Df4W6wBzCjl9QuXmJ2mOGDY0OZgIo=
X-Google-Smtp-Source: AGRyM1t3YlXjkGssaDlaxXo1igHFNIao3LtCdS42R25mVvm7uukiFwA5Q6y4vC1gkKw7Z2RtrtrvJQ==
X-Received: by 2002:a05:600c:19c8:b0:3a1:792e:f913 with SMTP id u8-20020a05600c19c800b003a1792ef913mr4044760wmq.182.1657194725110;
        Thu, 07 Jul 2022 04:52:05 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:52:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 16/27] io_uring: complete notifiers in tw
Date:   Thu,  7 Jul 2022 12:49:47 +0100
Message-Id: <3f3cb9e30bd344d1fb21e9505785b653ca38f069.1657194434.git.asml.silence@gmail.com>
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

We need a task context to post CQEs but using wq is too expensive.
Try to complete notifiers using task_work and fall back to wq if fails.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 22 +++++++++++++++++++---
 io_uring/notif.h |  3 +++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index b257db2120b4..aec74f88fc33 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -13,6 +13,11 @@ static void __io_notif_complete_tw(struct callback_head *cb)
 	struct io_notif *notif = container_of(cb, struct io_notif, task_work);
 	struct io_ring_ctx *ctx = notif->ctx;
 
+	if (likely(notif->task)) {
+		io_put_task(notif->task, 1);
+		notif->task = NULL;
+	}
+
 	io_cq_lock(ctx);
 	io_fill_cqe_aux(ctx, notif->tag, 0, notif->seq, true);
 
@@ -43,6 +48,14 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 
 	if (!refcount_dec_and_test(&uarg->refcnt))
 		return;
+
+	if (likely(notif->task)) {
+		init_task_work(&notif->task_work, __io_notif_complete_tw);
+		if (likely(!task_work_add(notif->task, &notif->task_work,
+					  TWA_SIGNAL)))
+			return;
+	}
+
 	INIT_WORK(&notif->commit_work, io_notif_complete_wq);
 	queue_work(system_unbound_wq, &notif->commit_work);
 }
@@ -134,12 +147,15 @@ __cold int io_notif_unregister(struct io_ring_ctx *ctx)
 	for (i = 0; i < ctx->nr_notif_slots; i++) {
 		struct io_notif_slot *slot = &ctx->notif_slots[i];
 
-		if (slot->notif)
-			io_notif_slot_flush(slot);
+		if (!slot->notif)
+			continue;
+		if (WARN_ON_ONCE(slot->notif->task))
+			slot->notif->task = NULL;
+		io_notif_slot_flush(slot);
 	}
 
 	kvfree(ctx->notif_slots);
 	ctx->notif_slots = NULL;
 	ctx->nr_notif_slots = 0;
 	return 0;
-}
\ No newline at end of file
+}
diff --git a/io_uring/notif.h b/io_uring/notif.h
index b23c9c0515bb..23ca7620fff9 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -11,6 +11,9 @@ struct io_notif {
 	struct ubuf_info	uarg;
 	struct io_ring_ctx	*ctx;
 
+	/* complete via tw if ->task is non-NULL, fallback to wq otherwise */
+	struct task_struct	*task;
+
 	/* cqe->user_data, io_notif_slot::tag if not overridden */
 	u64			tag;
 	/* see struct io_notif_slot::seq */
-- 
2.36.1

