Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F70355ED55
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbiF1TBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbiF1TAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:34 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D791CB0D;
        Tue, 28 Jun 2022 12:00:20 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id fd6so18898459edb.5;
        Tue, 28 Jun 2022 12:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tGCN/782OTAuVAlm4NhC1meQ0mDdrYQikPz7yxO4s3c=;
        b=QSfKJbVUSlX701ZwcjuVu/k9eDD9nXSrrcmYKZS3Tn8WEIh1KbT9ujqQr/TR9q/lbY
         hhBWwY5qUE4FYGbhdsX4VJ/nPqdXCJKDCx5Icqpm0zPWsTQWuNxM55LiRa9qKbnhvFLO
         FB6h1d18kPy7imiyUyybON+0jjlO4t6S0nHu8WOzV+gkSjQPGdhGGabMpRazMDhMMNhw
         aulkQ4N0bPSlizeG/GIL4UuzIEllkSVTyGiZKAaxeO59lFImuUxKHIlesirAXdlnc7Y/
         aDJ83ofvZV9x/Ynu7qWECB1DWTxp9pKcEZSDO3ZQ5yue3seYDfb5nH72Tq7dF/0YYkf/
         PwvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tGCN/782OTAuVAlm4NhC1meQ0mDdrYQikPz7yxO4s3c=;
        b=ng5IuSposrxeARSu+t2TqYFDlZihUCEP26sbANbQPsnZ3P/q3YjWJh4kCM5hvifb6U
         AakM0LehXZpgg2lM2mEXaHmk+j41D3xVArFccgHD/YwzZPBA837XWJ1w4eEZolxZzTIr
         tARIbB6q0YgcrUr5H+uLjwh2e1bsRD77b/ffBnpyI3VHoVGWfEu9NapgInxxdPNtDMAM
         s1+pW4wOWay2eMdzUdoW648T1AdTWTJ4NnI2TSKhG+4Fidr1kxpxRA/9+EprF99VXDQI
         zxKtxhNbna8Ka/JL25gNdkJrZu9zwYkPiL9L2aw45MEl8TFi3/cAI4nISVOMjBQ3cWHR
         MMyA==
X-Gm-Message-State: AJIora8Nc0Ryd45lw1q4C+cDFqf41zPFz4X/ep3RSMyGnyDA8uqaZEwM
        2ZNqpQw/L5lJ9TpH0sXMsUjhAvvgjKkwZw==
X-Google-Smtp-Source: AGRyM1uA/U423K/SUXtBeAD0+1+t7dMIhzGv0ilmdOFqj8DaQ9bEOtc3QI+LwroT8+RT3KttwU+qUA==
X-Received: by 2002:a50:fb9a:0:b0:435:6c0e:3342 with SMTP id e26-20020a50fb9a000000b004356c0e3342mr25930016edq.337.1656442819981;
        Tue, 28 Jun 2022 12:00:19 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 23/29] io_uring: allow to pass addr into sendzc
Date:   Tue, 28 Jun 2022 19:56:45 +0100
Message-Id: <228d4841af5eeb9a4b73955136559f18cb7e43a0.1653992701.git.asml.silence@gmail.com>
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

Allow to specify an address to zerocopy sends making it more like
sendto(2).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 16 +++++++++++++++-
 include/uapi/linux/io_uring.h |  2 +-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 838030477456..a1e9405a3f1b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -722,6 +722,8 @@ struct io_sendzc {
 	size_t				len;
 	u16				slot_idx;
 	int				msg_flags;
+	int				addr_len;
+	void __user			*addr;
 };
 
 struct io_open {
@@ -6572,7 +6574,7 @@ static int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sendzc *zc = &req->msgzc;
 
-	if (READ_ONCE(sqe->ioprio) || READ_ONCE(sqe->addr2) || READ_ONCE(sqe->__pad2[0]))
+	if (READ_ONCE(sqe->ioprio) || READ_ONCE(sqe->__pad2[0]))
 		return -EINVAL;
 
 	zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -6581,6 +6583,9 @@ static int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	zc->slot_idx = READ_ONCE(sqe->notification_idx);
 	if (zc->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
+	zc->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	zc->addr_len = READ_ONCE(sqe->addr_len);
+
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		zc->msg_flags |= MSG_CMSG_COMPAT;
@@ -6590,6 +6595,7 @@ static int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct sockaddr_storage address;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_sendzc *zc = &req->msgzc;
 	struct io_notif_slot *notif_slot;
@@ -6624,6 +6630,14 @@ static int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
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
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6c6f20ae5a95..689aa1444cd4 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -63,7 +63,7 @@ struct io_uring_sqe {
 		__u32	file_index;
 		struct {
 			__u16	notification_idx;
-			__u16	__pad;
+			__u16	addr_len;
 		} __attribute__((packed));
 	};
 	union {
-- 
2.36.1

