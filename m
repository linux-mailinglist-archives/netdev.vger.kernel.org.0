Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B9455ED67
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbiF1TBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiF1TAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:36 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01F02AE20;
        Tue, 28 Jun 2022 12:00:26 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id fw3so37479ejc.10;
        Tue, 28 Jun 2022 12:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h+qNzD2Yd+IQYNeNbouiSvYfHA0ZdKwKafy/cYjUYo0=;
        b=CKLR95HgDTN7qU8vhF7QVz1BFNorTwK32oZ2fp92gAFvtoFxBdzk51D51OCBBQKZWC
         ZhyOG3QLx/paG79KiFXw6i+lTmJbV/0VedsD/0oNYoN/B/XQQhS2hO7WL9VA4rTnuqAr
         0inQZWMliGjkNDGBRPEMzmSt7Qbbt/PvW3eGOTyBDEAAfItvzY5PfYZQRTyqMhSZ2c0s
         OB5rvryIbaG0RhN0Q/ljW7O6zuV2edHXMqoSrLLCdr6XQuT6D+/+JQipZmT+HAn7V0Pa
         sG5DAP/CkKzSmOgOH/Sk7/s93xlO4NTDYv8hr4YoxiHyVkpDr8NxxI+jJCuDMWHyP0tT
         FXKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h+qNzD2Yd+IQYNeNbouiSvYfHA0ZdKwKafy/cYjUYo0=;
        b=s4Opol9Sv1swtK0xuaKHkJk27SAVHqBJNIfL0pM+8yg3JceJK4O9OoE/uyUH1yMNE/
         Xu+vT0CRjkDIY/JKr1paKL71sUVqj0vShMvPnTDoh26LJM467ud2McIxh7Cx+pjgS+zo
         ISJPLhVVZ21aqmI7g0mhqJ3mVEnTrwzQd5mZ0QLHsvqiS+s3PcbsLBLB/X6s8Aob1UH3
         u/n2bimBo4ZzYJNQpgFZml3JAfYY5FuhY7xUASXf6Rxzs4YSKyv7eb2yTUu5nuDUrsaM
         uBWbQiz4LhADORdyunrclZAC3hXS6eweBmIZ9I+XbECmbvvE9XY3ox/CGMM/cnqyeOGd
         aZCQ==
X-Gm-Message-State: AJIora9SzRIXvGaaZpxcBQS08P9HUsFmIOdrf81GMMI/T9Y0uPKCJqFD
        ymBcoaPU/2FV4w+7JmhHJcZa5uWQXJ2iJg==
X-Google-Smtp-Source: AGRyM1ulk5olSi4r+mXPRGnWScKC9qxKE5OBDpFddlsQLLWLh2nVQhbsRdAw1F2EuATfwvTninBGAA==
X-Received: by 2002:a17:906:74c7:b0:722:e657:4220 with SMTP id z7-20020a17090674c700b00722e6574220mr19124547ejl.589.1656442825987;
        Tue, 28 Jun 2022 12:00:25 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 28/29] io_uring: batch submission notif referencing
Date:   Tue, 28 Jun 2022 19:56:50 +0100
Message-Id: <bbf76e9185c50a51c121153cd4c3bd7a6b830778.1653992701.git.asml.silence@gmail.com>
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

Batch get notifier references and use ->msg_ubuf_ref to hand off one ref
per sendzc request to the network layer. This ammortises the submission
side net_zcopy_get() atomics. Note that we always keep at least one
reference in the cache because we do only post send checks on
whether ->msg_ubuf_ref was consumed or not.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 08c98a4d9bd2..78990a130b66 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -374,6 +374,7 @@ struct io_ev_fd {
 };
 
 #define IO_NOTIF_MAX_SLOTS	(1U << 10)
+#define IO_NOTIF_REF_CACHE_NR	64
 
 struct io_notif {
 	struct ubuf_info	uarg;
@@ -384,6 +385,8 @@ struct io_notif {
 	u64			tag;
 	/* see struct io_notif_slot::seq */
 	u32			seq;
+	/* extra uarg->refcnt refs */
+	int			cached_refs;
 	/* hook into ctx->notif_list and ctx->notif_list_locked */
 	struct list_head	cache_node;
 
@@ -2949,14 +2952,30 @@ static struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 
 	notif->seq = slot->seq++;
 	notif->tag = slot->tag;
+	notif->cached_refs = IO_NOTIF_REF_CACHE_NR;
 	/* master ref owned by io_notif_slot, will be dropped on flush */
-	refcount_set(&notif->uarg.refcnt, 1);
+	refcount_set(&notif->uarg.refcnt, IO_NOTIF_REF_CACHE_NR + 1);
 	percpu_ref_get(&ctx->refs);
 	notif->rsrc_node = ctx->rsrc_node;
 	io_charge_rsrc_node(ctx);
 	return notif;
 }
 
+static inline void io_notif_consume_ref(struct io_notif *notif)
+	__must_hold(&ctx->uring_lock)
+{
+	notif->cached_refs--;
+
+	/*
+	 * Issue sends without looking at notif->cached_refs first, so we
+	 * always have to have at least one ref cached
+	 */
+	if (unlikely(!notif->cached_refs)) {
+		refcount_add(IO_NOTIF_REF_CACHE_NR, &notif->uarg.refcnt);
+		notif->cached_refs += IO_NOTIF_REF_CACHE_NR;
+	}
+}
+
 static inline struct io_notif *io_get_notif(struct io_ring_ctx *ctx,
 					    struct io_notif_slot *slot)
 {
@@ -2979,13 +2998,15 @@ static void io_notif_slot_flush(struct io_notif_slot *slot)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_notif *notif = slot->notif;
+	int refs = notif->cached_refs + 1;
 
 	slot->notif = NULL;
+	notif->cached_refs = 0;
 
 	if (WARN_ON_ONCE(in_interrupt()))
 		return;
-	/* drop slot's master ref */
-	if (refcount_dec_and_test(&notif->uarg.refcnt))
+	/* drop all cached refs and the slot's master ref */
+	if (refcount_sub_and_test(refs, &notif->uarg.refcnt))
 		io_notif_complete(notif);
 }
 
@@ -6653,6 +6674,7 @@ static int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
 	msg.msg_managed_data = 1;
+	msg.msg_ubuf_ref = 1;
 
 	if (req->msgzc.zc_flags & IORING_SENDZC_FIXED_BUF) {
 		ret = __io_import_fixed(WRITE, &msg.msg_iter, req->imu,
@@ -6686,6 +6708,10 @@ static int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_ubuf = &notif->uarg;
 	ret = sock_sendmsg(sock, &msg);
 
+	/* check if the send consumed an additional ref */
+	if (likely(!msg.msg_ubuf_ref))
+		io_notif_consume_ref(notif);
+
 	if (likely(ret >= min_ret)) {
 		unsigned zc_flags = req->msgzc.zc_flags;
 
-- 
2.36.1

