Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05CB47C2ED
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239444AbhLUPgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239400AbhLUPf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:35:56 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98530C061574;
        Tue, 21 Dec 2021 07:35:55 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id r17so27375656wrc.3;
        Tue, 21 Dec 2021 07:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dPSlVpr7txUPmQgAHE8W7WBCYuNNpGMD5iocgyvoTWA=;
        b=KtT4yTdaGYMM2K8v0RtSMUOk/6W3ELsHAkE662xdRsmOGdpceVDrVoAvQGdq4xtyRL
         4f5Kibf+ms2jCHgHxkl1UnyTlyee0ddndSR20egA9NEoLx2q64ecpERRAbXLuxu/pqK2
         EXmePyJ9U61RSKC18rEmXHsQTBwuYzYjEKkatCWn9LjduRwG3F/kHBoi7UUzz3+pzrl0
         khUzYFSVxV2Ko3RsqFSZ/llfyLhFx7whdXUpKrN38PwopgTG1EBkBkHOVcg1A0TMc+Wq
         IXU3QKbOqxcFrWX5OHBfnb0IyHy/jdcac6p7st5czHYKB+QGEtd+HtLHup1rvdc5THyE
         EtKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dPSlVpr7txUPmQgAHE8W7WBCYuNNpGMD5iocgyvoTWA=;
        b=zWQ/i1k/84JnQVfTm5lv2qI/vy/rLRzeSjrzkOVbLeslvWh+6GjQsb6xz80QjbjKj6
         YD4oY5TLnEDvWTtALK9gxXV2FVVLMNWxJdhBKtEU44DMQsLca1kdCefCAHLUc+oPl2nb
         dw6j2Iw8paq6bklxklytA3RSy4Nii60mTpUwQzWDugtd66tmiG8ZzXUjf40Y4H3AFP8B
         lA3GgU2KGIPEnI3OSOFwaXoHoCDX4BsVHF2+MaB9rKdYO8SS8jYDMkCY0wcC6ubMWCF/
         q9LsqH9oKGpT2DxiAPzoFw+h7FBJ4kJ3bsE14PlAFf/dkaVkBUF6x2KVR7qdjm1Gtv/G
         /4tw==
X-Gm-Message-State: AOAM530ebiA1ze/t3bf+veFqU/qbqrnM+fak0ZyBuhWjHSZDNXWqUelr
        CLoeaSFHyiCLW/u18ei2dvUjgIOG0Dg=
X-Google-Smtp-Source: ABdhPJx6vPTXtXPaU+lTMdgO0I0/v13+zI5/SuAU7CIhKZunOTh+dW6yumzbdv2kSQN1HhUK5X1D8w==
X-Received: by 2002:adf:e791:: with SMTP id n17mr2907897wrm.719.1640100954090;
        Tue, 21 Dec 2021 07:35:54 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:35:53 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC v2 02/19] skbuff: pass a struct ubuf_info in msghdr
Date:   Tue, 21 Dec 2021 15:35:24 +0000
Message-Id: <7dae2f61ee9a1ad38822870764fcafad43a3fe4e.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of the net stack managing ubuf_info, allow to pass it in from
outside in a struct msghdr (in-kernel structure), so io_uring can make
use of it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c          | 2 ++
 include/linux/socket.h | 1 +
 net/compat.c           | 1 +
 net/socket.c           | 3 +++
 4 files changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 72da3a75521a..59380e3454ad 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4911,6 +4911,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
+	msg.msg_ubuf = NULL;
 
 	flags = req->sr_msg.msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -5157,6 +5158,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_namelen = 0;
 	msg.msg_iocb = NULL;
 	msg.msg_flags = 0;
+	msg.msg_ubuf = NULL;
 
 	flags = req->sr_msg.msg_flags;
 	if (force_nonblock)
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 8ef26d89ef49..6bd2c6b0c6f2 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -65,6 +65,7 @@ struct msghdr {
 	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
 	unsigned int	msg_flags;	/* flags on received message */
 	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
+	struct ubuf_info *msg_ubuf;
 };
 
 struct user_msghdr {
diff --git a/net/compat.c b/net/compat.c
index 210fc3b4d0d8..6cd2e7683dd0 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -80,6 +80,7 @@ int __get_compat_msghdr(struct msghdr *kmsg,
 		return -EMSGSIZE;
 
 	kmsg->msg_iocb = NULL;
+	kmsg->msg_ubuf = NULL;
 	*ptr = msg.msg_iov;
 	*len = msg.msg_iovlen;
 	return 0;
diff --git a/net/socket.c b/net/socket.c
index 7f64a6eccf63..0a29b616a38c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2023,6 +2023,7 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
+	msg.msg_ubuf = NULL;
 	if (addr) {
 		err = move_addr_to_kernel(addr, addr_len, &address);
 		if (err < 0)
@@ -2088,6 +2089,7 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 	msg.msg_namelen = 0;
 	msg.msg_iocb = NULL;
 	msg.msg_flags = 0;
+	msg.msg_ubuf = NULL;
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	err = sock_recvmsg(sock, &msg, flags);
@@ -2326,6 +2328,7 @@ int __copy_msghdr_from_user(struct msghdr *kmsg,
 		return -EMSGSIZE;
 
 	kmsg->msg_iocb = NULL;
+	kmsg->msg_ubuf = NULL;
 	*uiov = msg.msg_iov;
 	*nsegs = msg.msg_iovlen;
 	return 0;
-- 
2.34.1

