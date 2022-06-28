Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E5855ED38
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234901AbiF1TA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234067AbiF1TAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:22 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E3CDF05;
        Tue, 28 Jun 2022 11:59:59 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ay16so27701169ejb.6;
        Tue, 28 Jun 2022 11:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z2Qv20zedNy8g3sQlLE59sUUdbI93Xy4dZXDehfqyts=;
        b=TeqIfzcjTVc2mRM1U5TeziQ35hQIeROIcT4yvbV5HXHOIoy0hEaZP4/bExTXk/tyYu
         uKFvG5wD6xNr1HN3kr0y48w0qtn2fAWU5dwOmZCmFV/j3dnNVtjN7G9u2svX2DHrS2nJ
         jDZqqVn1mmOBVS/rbDaXXGB589qsANnvgop/ga+HA+C/utXlatrdcHjhaw4I3zVSyiKx
         lO4e7tU7u9pMF8ygDjsk55XuW4g/F2b3Gtj0gSKbZD2zjPbha2M51Nl6PxH3UZkNDHcn
         GjlruiXzYDKMVqRTlNDLcgI9QybI8VS99Duc6CxPwkBg/PgkXk/bquZvTthzFvfBNEYC
         xMOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z2Qv20zedNy8g3sQlLE59sUUdbI93Xy4dZXDehfqyts=;
        b=Wcu1UqhOOGcNXixPMPVX/dwwx/nLQFtspxNFfOCxc7jAfap8cEVDX6wdNeFBs+zMlG
         8wHSzHcXAz0s4YvoZa8zGOPut22FwkeJFXRKy29BeX4xPQ/B/cLSDuvA4hQ4nSNhg0Zy
         CisRuWeiqWqx76ZmBH2L3kj0Fe2vsZvkZIo69oSOI0RlZhKkj/yAmQ1wOxyrKpoAVJ/+
         FhLvsSF/4BnFj11CihzNfyRIiJEHiu5FWdyJMy50g/WJaHl4R6wfwbX7l91rcrehQAqN
         qGBNVJP54kLy2KPj19C3v2NK6hPOlzp9JDna1CtMu5XQr5iZ3FEFOlvL3W42msH7AAzJ
         EaDQ==
X-Gm-Message-State: AJIora/LcEmLBgeDvqZ3gswiV2EvbRoh6Mhhna8nCtEbHGYK8NY786gD
        QL642ROcPl8CML4xpiHar0YEmHXgf7Mk9w==
X-Google-Smtp-Source: AGRyM1sb/hLLgQxmWZ9et/0ID1KiNvoqUq/Gi7gZXrgCBmhaXijCGgppkjA8RDKs3Px+si88wnwFng==
X-Received: by 2002:a17:906:14d:b0:711:ffc4:3932 with SMTP id 13-20020a170906014d00b00711ffc43932mr19100498ejh.321.1656442797275;
        Tue, 28 Jun 2022 11:59:57 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.11.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:59:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 04/29] skbuff: carry external ubuf_info in msghdr
Date:   Tue, 28 Jun 2022 19:56:26 +0100
Message-Id: <1634a40ad0cf05eeee8dd9e88d89f1558704bf2c.1653992701.git.asml.silence@gmail.com>
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

Make possible for network in-kernel callers like io_uring to pass in a
custom ubuf_info by setting it in a new field of struct msghdr.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c          | 4 ++++
 include/linux/socket.h | 7 +++++++
 net/compat.c           | 2 ++
 net/socket.c           | 6 ++++++
 4 files changed, 19 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8e75539fdc1d..6a57a5ae18fb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6230,6 +6230,8 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
+	msg.msg_ubuf = NULL;
+	msg.msg_managed_data = false;
 
 	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -6500,6 +6502,8 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_flags = 0;
 	msg.msg_controllen = 0;
 	msg.msg_iocb = NULL;
+	msg.msg_ubuf = NULL;
+	msg.msg_managed_data = false;
 
 	flags = sr->msg_flags;
 	if (force_nonblock)
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 17311ad9f9af..ba84ee614d5a 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -66,9 +66,16 @@ struct msghdr {
 	};
 	bool		msg_control_is_user : 1;
 	bool		msg_get_inq : 1;/* return INQ after receive */
+	/*
+	 * The data pages are pinned and won't be released before ->msg_ubuf
+	 * is released. ->msg_iter should point to a bvec and ->msg_ubuf has
+	 * to be non-NULL.
+	 */
+	bool		msg_managed_data : 1;
 	unsigned int	msg_flags;	/* flags on received message */
 	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
 	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
+	struct ubuf_info *msg_ubuf;
 };
 
 struct user_msghdr {
diff --git a/net/compat.c b/net/compat.c
index 210fc3b4d0d8..435846fa85e0 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -80,6 +80,8 @@ int __get_compat_msghdr(struct msghdr *kmsg,
 		return -EMSGSIZE;
 
 	kmsg->msg_iocb = NULL;
+	kmsg->msg_ubuf = NULL;
+	kmsg->msg_managed_data = false;
 	*ptr = msg.msg_iov;
 	*len = msg.msg_iovlen;
 	return 0;
diff --git a/net/socket.c b/net/socket.c
index 2bc8773d9dc5..0963a02b1472 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2106,6 +2106,8 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
+	msg.msg_ubuf = NULL;
+	msg.msg_managed_data = false;
 	if (addr) {
 		err = move_addr_to_kernel(addr, addr_len, &address);
 		if (err < 0)
@@ -2171,6 +2173,8 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 	msg.msg_namelen = 0;
 	msg.msg_iocb = NULL;
 	msg.msg_flags = 0;
+	msg.msg_ubuf = NULL;
+	msg.msg_managed_data = false;
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	err = sock_recvmsg(sock, &msg, flags);
@@ -2409,6 +2413,8 @@ int __copy_msghdr_from_user(struct msghdr *kmsg,
 		return -EMSGSIZE;
 
 	kmsg->msg_iocb = NULL;
+	kmsg->msg_ubuf = NULL;
+	kmsg->msg_managed_data = false;
 	*uiov = msg.msg_iov;
 	*nsegs = msg.msg_iovlen;
 	return 0;
-- 
2.36.1

