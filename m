Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E81556A179
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbiGGLxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiGGLwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:21 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5829C564DE;
        Thu,  7 Jul 2022 04:52:11 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id f2so20574414wrr.6;
        Thu, 07 Jul 2022 04:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=omoo5cVZNNBFIFnOaNM6NLvMePhB2gb+Cvuo04exYeA=;
        b=brBXziFLd5ln5hHryX/tpn9+fqyCgr70FpALY5PXPaA0YkczPFGCEGvjbIrRNa2M4Z
         3MyodXjWkkihZLP6UkNyATo+01YM8ysucU11pBAq8duJKPxQJ1b0PYf58XhlXSN2Iuk1
         zwSSAZSvTUrxPz6IUzr2oOxJ0DpZnrdwhMv6LpwvRyMHh6dmpUwQeggfDNp3Vszgh/xC
         6S/I/Ox1qJ9zD/Zk3V7n+jcX5SC0dcFaMuUisQ5DL0w5m+4EJVO3TCffZRxhimhLSar8
         KHzh4KTQNgeO7+3yQ89rNEFshGBBzkDJaWqtNC6qrKvA6u3EgW+Ye+qGWBgTLK/QMHFg
         85dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=omoo5cVZNNBFIFnOaNM6NLvMePhB2gb+Cvuo04exYeA=;
        b=wtvKbDntugkPJLywuIIiNEormwV/xInjZdzyfm9hpbgxp7A6kYbMU5JWrczvq/d1lT
         qNfsZGCNBmoWcxTriHKUnZfkbhdwWfcc24APds/JTEPVD9B5+WscWkjbvKyQA6EVIFJ3
         s140/GxmYKwDHUUywMDFYX09wa0N5peWPqwt1zNo+iZrn7T55wr9cTUDea5FakKQ1W9Q
         7bvr8QBue1LavYE4i4PUja0dhzIOYxVkrEkY5RhwYxhqFpM/K+1zGIaIhotwAodmLe1b
         LPLx9S8sPUTDpr3CwYWfy1J69TYg9+Rt+J+qWiQgEZRkA7sComiT0z8S4Yc1qUdBSdGE
         mZ4A==
X-Gm-Message-State: AJIora+INZv0DGWIIjIPEJZ1qPVHOkntsloVtv0ClX0z52S9pEyYbTdZ
        QuCQfG6jGaSKMJNlK/AqTMQamZf+ygrJAPRi4dc=
X-Google-Smtp-Source: AGRyM1tEgLds10QNWmthl9h5KvVoRezaUvMvpPYja4GtVqUh01IvggKuGXGg392vUO45mB2Z9eEGGA==
X-Received: by 2002:a05:6000:695:b0:21a:3a1a:7b60 with SMTP id bo21-20020a056000069500b0021a3a1a7b60mr41107170wrb.441.1657194730645;
        Thu, 07 Jul 2022 04:52:10 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:52:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 21/27] io_uring: allow to pass addr into sendzc
Date:   Thu,  7 Jul 2022 12:49:52 +0100
Message-Id: <75fbbc1dff3835ddd996346b86eab3b8e83435ff.1657194434.git.asml.silence@gmail.com>
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

Allow to specify an address to zerocopy sends making it more like
sendto(2).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  2 +-
 io_uring/net.c                | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a6844908772a..25278c9ac6d2 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -65,7 +65,7 @@ struct io_uring_sqe {
 		__u32	file_index;
 		struct {
 			__u16	notification_idx;
-			__u16	__pad;
+			__u16	addr_len;
 		};
 	};
 	union {
diff --git a/io_uring/net.c b/io_uring/net.c
index 69273d4f4ef0..2172cf3facd8 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -66,6 +66,8 @@ struct io_sendzc {
 	u16				slot_idx;
 	unsigned			msg_flags;
 	unsigned			flags;
+	unsigned			addr_len;
+	void __user			*addr;
 };
 
 #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
@@ -666,8 +668,7 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sendzc *zc = io_kiocb_to_cmd(req);
 
-	if (READ_ONCE(sqe->addr2) || READ_ONCE(sqe->__pad2[0]) ||
-	    READ_ONCE(sqe->addr3))
+	if (READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3))
 		return -EINVAL;
 
 	zc->flags = READ_ONCE(sqe->ioprio);
@@ -680,6 +681,10 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	zc->slot_idx = READ_ONCE(sqe->notification_idx);
 	if (zc->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
+
+	zc->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	zc->addr_len = READ_ONCE(sqe->addr_len);
+
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		zc->msg_flags |= MSG_CMSG_COMPAT;
@@ -689,6 +694,7 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct sockaddr_storage address;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_sendzc *zc = io_kiocb_to_cmd(req);
 	struct io_notif_slot *notif_slot;
@@ -726,6 +732,14 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		return ret;
 	mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
 
+	if (zc->addr) {
+		ret = move_addr_to_kernel(zc->addr, zc->addr_len, &address);
+		if (unlikely(ret < 0))
+			return ret;
+		msg.msg_name = (struct sockaddr *)&address;
+		msg.msg_namelen = zc->addr_len;
+	}
+
 	msg_flags = zc->msg_flags | MSG_ZEROCOPY;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		msg_flags |= MSG_DONTWAIT;
-- 
2.36.1

