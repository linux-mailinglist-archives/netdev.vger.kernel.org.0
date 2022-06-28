Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D08655ED52
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiF1TBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbiF1TAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:31 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA3C1A049;
        Tue, 28 Jun 2022 12:00:17 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id h23so27614715ejj.12;
        Tue, 28 Jun 2022 12:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oOGRlNTNJY51QXUFrfFxWPWq7Z2HbWhlV6gca7goiwg=;
        b=ja4zCRNwBj18hSgwwv3X4sTg9KeDiSX5k7tdpGg2AIfifMAq2k8bNeD6F8wq7iLqY6
         XzbD8QyWyA2I70EYpBJTNaq+oUkBUqa1Rverg2GeYp6AcKCs3GtPDJIZ6gb7WKVK9hOE
         a+AtX+C7xK0aHc1pHgCj/6SLT3K247sGTaRRx9pI6/QyClV/uYVuTvk61nPzVD2Tdh+T
         moyg1fG21eK4S9goKmnXS0diOAG2+hOu1jNy1EaKaP+sHh+B868gatFkqqpMZ7SUFJe1
         sVPziRScbE367FS6TVL/3RnvGT6tt7kYYm4iZH3yHc8IQwobSfD1x6SyApXFyfnMLiTw
         F1yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oOGRlNTNJY51QXUFrfFxWPWq7Z2HbWhlV6gca7goiwg=;
        b=6Zk7Mm88XXSBGic+E2KX+S5CN7oe5ReZFAtNPhTMjyuqvKdp0fHr/LUs0XtyRLs1jg
         DZQzZqocNQozYtkLeqmD4wpGE5gw5R+njsI5YQ4YdKf1AdyBzlmpUf0Z9KCflm4BwmeV
         e8EV9fKKY0Aq5w3Ucvr791uhD+SDYM5IQwR2ma04A+encN00ZFwdc+ITTrR1EpbkfkB2
         //Yajcfmv1GOBBoZzBWedBuNxy6IqUmbypkJgEu5eVs8qo+OwlxOKB3r/Lj9yzaV4liO
         QfauZS4gQyqGB0db/Iml7Wr+WAjvsy7i4/+Q7igS0egxuocN9Bh1OzA9HUtusSIyTOmP
         o3dg==
X-Gm-Message-State: AJIora/pu8vtIPqlzB7eEgQ8yUURMsKPZoWRtyRljfNkYof41Qu8VVFD
        H0JLguWmYLSWJ9v/2+gkKhBRk8XFXpErLg==
X-Google-Smtp-Source: AGRyM1unAJh+uP60Gs7yhxS83ZH+GB3ChuXyJeXrL9PJ4d+W7MTYnnkWAxVGJ71q+zRqfgbI/jQ8Ew==
X-Received: by 2002:a17:906:9c82:b0:6df:c5f0:d456 with SMTP id fj2-20020a1709069c8200b006dfc5f0d456mr19574221ejc.287.1656442816320;
        Tue, 28 Jun 2022 12:00:16 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 20/29] io_uring: add zc notification flush requests
Date:   Tue, 28 Jun 2022 19:56:42 +0100
Message-Id: <dcde76fb17478a0555771647105e57ee7b1b12bf.1653992701.git.asml.silence@gmail.com>
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

Overlay notification control onto IORING_OP_RSRC_UPDATE (former
IORING_OP_FILES_UPDATE). It allows to flush a range of zc notifications
from slots with indexes [sqe->off, sqe->off+sqe->len). If sqe->arg is
not zero, it also copies sqe->arg as a new tag for all flushed
notifications.

Note, it doesn't flush a notification of a slot if there was no requests
attached to it (since last flush or registration).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 47 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 48 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e9fc7e076c7f..a88c9c73ed1d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1284,6 +1284,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_RSRC_UPDATE] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
+		.ioprio			= 1,
 	},
 	[IORING_OP_STATX] = {
 		.audit_skip		= 1,
@@ -2953,6 +2954,16 @@ static void io_notif_slot_flush(struct io_notif_slot *slot)
 		io_notif_complete(notif);
 }
 
+static inline void io_notif_slot_flush_submit(struct io_notif_slot *slot,
+					      unsigned int issue_flags)
+{
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		slot->notif->task = current;
+		io_get_task_refs(1);
+	}
+	io_notif_slot_flush(slot);
+}
+
 static __cold int io_notif_unregister(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
@@ -8286,6 +8297,40 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 	return 0;
 }
 
+static int io_notif_update(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	unsigned len = req->rsrc_update.nr_args;
+	unsigned idx_end, idx = req->rsrc_update.offset;
+	int ret = 0;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	if (unlikely(check_add_overflow(idx, len, &idx_end))) {
+		ret = -EOVERFLOW;
+		goto out;
+	}
+	if (unlikely(idx_end > ctx->nr_notif_slots)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	for (; idx < idx_end; idx++) {
+		struct io_notif_slot *slot = &ctx->notif_slots[idx];
+
+		if (!slot->notif)
+			continue;
+		if (req->rsrc_update.arg)
+			slot->tag = req->rsrc_update.arg;
+		io_notif_slot_flush_submit(slot, issue_flags);
+	}
+out:
+	io_ring_submit_unlock(ctx, issue_flags);
+	if (ret < 0)
+		req_set_fail(req);
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
 static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -8315,6 +8360,8 @@ static int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags)
 	switch (req->rsrc_update.type) {
 	case IORING_RSRC_UPDATE_FILES:
 		return io_files_update(req, issue_flags);
+	case IORING_RSRC_UPDATE_NOTIF:
+		return io_notif_update(req, issue_flags);
 	}
 	return -EINVAL;
 }
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5f574558b96c..19b9d7a2da29 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -266,6 +266,7 @@ enum io_uring_op {
  */
 enum {
 	IORING_RSRC_UPDATE_FILES,
+	IORING_RSRC_UPDATE_NOTIF,
 };
 
 /*
-- 
2.36.1

