Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439CE4639C9
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245376AbhK3PYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245057AbhK3PX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:23:27 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAE2C061377;
        Tue, 30 Nov 2021 07:19:21 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id a18so45274846wrn.6;
        Tue, 30 Nov 2021 07:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fdsU4+l5aV4bfwBaRNCuzeM5yPixDPv1W50l5HuSAKc=;
        b=OloQfj21d5fcemkHQqmCStGgD1ISw8htjoVPBnbhsDeL//2i/uZXlNTRV8Mo8F+oEj
         ZMqLtHxgM7nqh8MdZSJOR6AI47qAoiNPMQOBnU6Ii5Jj/cng5hJwhW6S6vKUXbjn5FQI
         H5ZUcRNMpjORrIHn2YQWuTpxdR8arcIEJGEYgccxbkIDoN2qZKw8jY+tMBsnGP6GTnnf
         iyYW+z0t2A20E5XDxcNPqdUMz57fm5jEwnM8EtQjZ+rDV3MDD8rHKoJuB6fc15FNBtgY
         SGDMOggu1v2NLZcZSdDAd+d+ziK4zQCEcjajJ57I13wmo1Q9Csq/wjET8jnUdPMxXGxy
         YzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fdsU4+l5aV4bfwBaRNCuzeM5yPixDPv1W50l5HuSAKc=;
        b=JSAdOGau8p+S0p4jsuNdVxe2sTNOh1C3uU1norgvz8CZzjvHGkxc8bnY+JfPTBboC4
         qwUQuQTARDOKJHCSjTb51MbKrFQIBD445k3GwQTert9/Gfw1yPQTAehJrHsMVs8HVNYi
         JpON8Kv7XA3Etf8eiCzujwkKYeS+7UaocMkgPVSxxshThLWjNz6vYrvjuioX3283QFMt
         ZzdC22oqol5V1Fhzd469sAkLb/eoB2vAy2vX87wCJhO97zp2Knfst8Cyt6yfTRbSeYg7
         GAf6GttF0TsBCtrlrHQr43wYYD54LRqAvWQUNHr9gGYSBIuzbWFQl2uL0/vpbmjB8Yv0
         JQ+w==
X-Gm-Message-State: AOAM530nhUHFWA0rpRNm06Ki5AIIb9R53ahF7ZzV34JI6oDXH1pEHtyS
        ClGaV5WBGcoJJE7J1fp/mNwsZu+Rn2w=
X-Google-Smtp-Source: ABdhPJzhc1IZ2bs05HmTBtQaH6UqcJmg3N4P5psLtX3rmAaT4Wt+VOypwhmBeKF9ev5gdZaFEhotYw==
X-Received: by 2002:adf:dd0a:: with SMTP id a10mr41470262wrm.60.1638285560235;
        Tue, 30 Nov 2021 07:19:20 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.109])
        by smtp.gmail.com with ESMTPSA id d1sm16168483wrz.92.2021.11.30.07.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:19:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC 02/12] skbuff: pass a struct ubuf_info in msghdr
Date:   Tue, 30 Nov 2021 15:18:50 +0000
Message-Id: <07b21df727d9a3987d836e271946e73a629f4601.1638282789.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
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
2.34.0

