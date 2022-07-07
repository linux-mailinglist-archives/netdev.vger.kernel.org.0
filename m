Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE16156A14F
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235713AbiGGLxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235276AbiGGLwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:35 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36ABF564DA;
        Thu,  7 Jul 2022 04:52:15 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id n10so652731wrc.4;
        Thu, 07 Jul 2022 04:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vFwRp/uT2nw+K7pbh3+QCIJXYGEcJpL4pQn1YlUGf+0=;
        b=T9cR/BLHNHIrK0oOpk/oBRK4rI8ArYU64vwAEqghwNcpfSgKH6rC98l4HfCo1PCwwu
         q4ryD/ZsZdeYU3/kz8Jo/UY8v9vOvabFv9ckU00vPDD/CTG7eJDTAjs8p8GdzQ5Q2T10
         HLJ7cKaTXoK6O2bsEl0Yicjr/zkpv1tSOgXwx/x0+zcdUEOW+5LGTxHBgRn/7P+EdldJ
         ZEocR14wEy1hGcYbjNIcBb5aubRM0ToFV+23hgh4TGNAfAObHjC6drrmI44XpFb40Qya
         CPhc2orqU4qYiw7+6gibLBUQ7A9YRVqo5NszYU8esw3TySprochpVnbm+Y+jg0ZjALqr
         0gvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vFwRp/uT2nw+K7pbh3+QCIJXYGEcJpL4pQn1YlUGf+0=;
        b=n1OdnCqYz+1QxkNOYNqRF0ORPlAXKLg9M/GDl+U/P/TyWm7jzgvgSrSzhHILuWeJUL
         mo/Jgv+fmAUxVbcXphF69XgIUz3LhWbQXAfUz9qudpRZG4ajqKNm5NdjSHEjpg/xLorF
         WEBHXdXrQ9HdxrO2G707qvNvrLAv6hfsFE22Fm7FZ8CdbBVyVTW+5PcPMKhXDZpTkQg7
         nJwbTjtWj1ut0IIzfCTx7031VOyfQq1vGfacsHPAt21eca3yNXrRLSq4gXLNRpPrnhHK
         gIZuXMHBCpjawDTiHpyIMjUsMjUpg5x/MBS6RRsxVYAtO9vDyvi14wCA5tbmIoNFhlMq
         NQ/Q==
X-Gm-Message-State: AJIora+8/Ult8QMFq3iI/PCKIhJ6dIqBCxiZdpv/lKl6XVkgvrygaes0
        Ddt0U4+/WVtI9r4OYDTOndYws4TpH1PW4Ar41pw=
X-Google-Smtp-Source: AGRyM1tpQzs+FyXhlQEZIBss3MiCgfaUoICvxGnZRvJ0DZpF/zvOORBuOlNM0n4ul3LJkYbLDDF2xg==
X-Received: by 2002:a5d:584e:0:b0:21c:ea0c:3734 with SMTP id i14-20020a5d584e000000b0021cea0c3734mr42204706wrf.420.1657194734356;
        Thu, 07 Jul 2022 04:52:14 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:52:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 24/27] io_uring: rename IORING_OP_FILES_UPDATE
Date:   Thu,  7 Jul 2022 12:49:55 +0100
Message-Id: <ab408ab3cd84dee1f797f2539c60d28aa5c4c418.1657194434.git.asml.silence@gmail.com>
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

IORING_OP_FILES_UPDATE will be a more generic opcode serving different
resource types, rename it into IORING_OP_RSRC_UPDATE and add subtype
handling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 12 +++++++++++-
 io_uring/opdef.c              |  9 +++++----
 io_uring/rsrc.c               | 17 +++++++++++++++--
 io_uring/rsrc.h               |  4 ++--
 4 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 37e0730733f9..9e325179a4f8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -171,7 +171,8 @@ enum io_uring_op {
 	IORING_OP_FALLOCATE,
 	IORING_OP_OPENAT,
 	IORING_OP_CLOSE,
-	IORING_OP_FILES_UPDATE,
+	IORING_OP_RSRC_UPDATE,
+	IORING_OP_FILES_UPDATE = IORING_OP_RSRC_UPDATE,
 	IORING_OP_STATX,
 	IORING_OP_READ,
 	IORING_OP_WRITE,
@@ -220,6 +221,7 @@ enum io_uring_op {
 #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
+
 /*
  * sqe->splice_flags
  * extends splice(2) flags
@@ -286,6 +288,14 @@ enum io_uring_op {
  */
 #define IORING_ACCEPT_MULTISHOT	(1U << 0)
 
+
+/*
+ * IORING_OP_RSRC_UPDATE flags
+ */
+enum {
+	IORING_RSRC_UPDATE_FILES,
+};
+
 /*
  * IORING_OP_MSG_RING command types, stored in sqe->addr
  */
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 8419b50c1d3b..0fb347d1ec16 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -246,12 +246,13 @@ const struct io_op_def io_op_defs[] = {
 		.prep			= io_close_prep,
 		.issue			= io_close,
 	},
-	[IORING_OP_FILES_UPDATE] = {
+	[IORING_OP_RSRC_UPDATE] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
-		.name			= "FILES_UPDATE",
-		.prep			= io_files_update_prep,
-		.issue			= io_files_update,
+		.name			= "RSRC_UPDATE",
+		.prep			= io_rsrc_update_prep,
+		.issue			= io_rsrc_update,
+		.ioprio			= 1,
 	},
 	[IORING_OP_STATX] = {
 		.audit_skip		= 1,
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 1182cf0ea1fc..98ce8a93a816 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -21,6 +21,7 @@ struct io_rsrc_update {
 	u64				arg;
 	u32				nr_args;
 	u32				offset;
+	int				type;
 };
 
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
@@ -658,7 +659,7 @@ __cold int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 	return -EINVAL;
 }
 
-int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+int io_rsrc_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
 
@@ -672,6 +673,7 @@ int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!up->nr_args)
 		return -EINVAL;
 	up->arg = READ_ONCE(sqe->addr);
+	up->type = READ_ONCE(sqe->ioprio);
 	return 0;
 }
 
@@ -711,7 +713,7 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 	return ret;
 }
 
-int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
+static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
 	struct io_ring_ctx *ctx = req->ctx;
@@ -740,6 +742,17 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
+
+	switch (up->type) {
+	case IORING_RSRC_UPDATE_FILES:
+		return io_files_update(req, issue_flags);
+	}
+	return -EINVAL;
+}
+
 int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 			  struct io_rsrc_node *node, void *rsrc)
 {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index af342fd239d0..21813a23215f 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -167,6 +167,6 @@ static inline u64 *io_get_tag_slot(struct io_rsrc_data *data, unsigned int idx)
 	return &data->tags[table_idx][off];
 }
 
-int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
-int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags);
+int io_rsrc_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 #endif
-- 
2.36.1

