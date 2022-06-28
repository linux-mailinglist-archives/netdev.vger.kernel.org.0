Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C8155ED4B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbiF1TBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234445AbiF1TAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:30 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB4A193E7;
        Tue, 28 Jun 2022 12:00:14 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id h23so27614715ejj.12;
        Tue, 28 Jun 2022 12:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i0MO0fedUqWqU6OS3v8noUO6m7kPGB9OwseLoBpuluo=;
        b=FxAG96JzN9Cevq47mDhXQKg6CoCJp6Ik7+LjtZfbWvdsLQnX4N4VtaFK1K5TqTCHUJ
         irgc+0Fcsm9yk31Zrx6if98iy+1fssmDIFeHtq8g/UXqgSemeDhl00kCRKyAC8oyPsL/
         MjyujfaEq5rC8cPbcxpvErGctVJWNrkFcnCLVWwHcj30xpCNQDWS3hTJLkpiTrQfHlDy
         E0bcuQYfIAcNGe+9VPHwMjrCRVpSYBqw6LXIZjWbU1NVEHrDdH1uNYP2NWm/Dc4okbrZ
         yuPQ8J/ovQ180r61dzHVBvGcSu+C1B9qqYLH1QmDLj7GlQeQRyLedrQZB5PmgBl1nJex
         nyVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i0MO0fedUqWqU6OS3v8noUO6m7kPGB9OwseLoBpuluo=;
        b=u39+5xybBiM9TPjVjVBNDb4MHLGYLYr+p6JzjEY6U/AU2eJuK/32IOL27TOtcMn+wd
         gdYuM3olQzYZj+rzB9qR75SuhHYIzIXsvsS0b9PftfBVa9AYtDS24cnFiD2bi7GzrOrr
         WNnqOLPTNMAWU++6WwnZnXMRV+rrbK2ItNcpmhKf47oxhhvM2GJL94ODopaQb6bZ93kf
         taNtzAE5YJ5VhsXwOmYlEnS1HoVT4riTOSh0Ha/rehR/uaqzpEugAryf6GV53T82zusw
         aj/TLHXigA5IOKiJ3EAyI0ObGOtH27zsO3Eq9IH2FXh9yoid4YaS7d0Gd7JL2mDjfg6O
         9Eyw==
X-Gm-Message-State: AJIora/QBy9Aatp5SAkCsBPhMU/2O0aHTzn2Jo+C045eDJmScdv03PB1
        ilTs+zxpCpQ0Mt6iKnZFvC6E90fPg1pU2g==
X-Google-Smtp-Source: AGRyM1tAMSUMslAPyxoH+0wzXDKJtb027MJYgfXn00t1CGulBpfPU7dB3FymrXO1iaawk8utfe/udQ==
X-Received: by 2002:a17:907:94d4:b0:722:e4b8:c2f2 with SMTP id dn20-20020a17090794d400b00722e4b8c2f2mr19166869ejc.527.1656442812700;
        Tue, 28 Jun 2022 12:00:12 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 17/29] io_uring: complete notifiers in tw
Date:   Tue, 28 Jun 2022 19:56:39 +0100
Message-Id: <e5ec892bba575359f178a7aa23ae85f4436e771a.1653992701.git.asml.silence@gmail.com>
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

We need a task context to post CQEs but using wq is too expensive.
Try to complete notifiers using task_work and fall back to wq if fails.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 422ff835bf36..9ade0ea8552b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -384,6 +384,8 @@ struct io_notif {
 	/* hook into ctx->notif_list and ctx->notif_list_locked */
 	struct list_head	cache_node;
 
+	/* complete via tw if ->task is non-NULL, fallback to wq otherwise */
+	struct task_struct	*task;
 	union {
 		struct callback_head	task_work;
 		struct work_struct	commit_work;
@@ -2802,6 +2804,11 @@ static void __io_notif_complete_tw(struct callback_head *cb)
 	struct io_notif *notif = container_of(cb, struct io_notif, task_work);
 	struct io_ring_ctx *ctx = notif->ctx;
 
+	if (likely(notif->task)) {
+		io_put_task(notif->task, 1);
+		notif->task = NULL;
+	}
+
 	spin_lock(&ctx->completion_lock);
 	io_fill_cqe_aux(ctx, notif->tag, 0, notif->seq);
 
@@ -2835,6 +2842,14 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 
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
@@ -2946,8 +2961,12 @@ static __cold int io_notif_unregister(struct io_ring_ctx *ctx)
 	for (i = 0; i < ctx->nr_notif_slots; i++) {
 		struct io_notif_slot *slot = &ctx->notif_slots[i];
 
-		if (slot->notif)
+		if (slot->notif) {
+			WARN_ON_ONCE(slot->notif->task);
+
+			slot->notif->task = NULL;
 			io_notif_slot_flush(slot);
+		}
 	}
 
 	kvfree(ctx->notif_slots);
-- 
2.36.1

