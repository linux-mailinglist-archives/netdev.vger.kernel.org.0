Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0BC56A168
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbiGGLwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235297AbiGGLv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:51:56 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7354F4507D;
        Thu,  7 Jul 2022 04:51:54 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l68so10472623wml.3;
        Thu, 07 Jul 2022 04:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9kzjVmEHp0xWSH6Tr3m/YVyGiLjtMkCIxQTqGUOMCmQ=;
        b=kjucAiROc06+6tyOEb4nnt9d67DZpGghK0fN6luEXyXIxpiBQGj/+sSZyIUGAY73bH
         6zY21G8rpAaPLZlyVTnH5he6cCFoI2bo/fNFN3qkOzOGEkndq3VAea1ZlkMJbDtgqgfq
         m9iyv97G8YpXMxHqflK41NskttI1PudpozTO+o/m9VbGNcWIISL1TQu0XzubQ/sZV+He
         ry4YWe/fxSMA3BrvGPD7rV/11NtwuMC5ALQaQehWduDmYya5tst1ZgCpJy9gpa6lT5SF
         vmwhd1pfSy67byLo67LBhTdG2IzcuXFJhGl7Ccdg7insjgMzxk6ZQjjx2qVNVrB4/fMt
         QrsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9kzjVmEHp0xWSH6Tr3m/YVyGiLjtMkCIxQTqGUOMCmQ=;
        b=1cZfPpdIkHr1kjN+tKcWFe7UerSXg2cocchTlRmS4iuvipyPcL9eK+LdqI2y7SK2nH
         D+v6rUsUTYd4cgEmyN6R1bzv65P2zPNEfqng3ryGYV7UG7vsPLyqxy31LHgQ3nKTMVl+
         ksK49L+S/PALorrnVkR2t7hQTg+5xPLOA5sKY/bv8jwVjGJrwNiVAc4dnubHMWo9rI5r
         Exu8kBY503VDKCk4SazIx2ZN6299uo1Rj001/tshvvn16im6JmENll0apfE/Jw3T7cDg
         pXHVRhPE+/b6EydCmJqD1N7GWbZ+dXWCu84YPb42NsYr2YOXr7IAibE7Ct2X3LXNzERY
         qIcw==
X-Gm-Message-State: AJIora/lFS45lsgK6zIff5WWKHz5Zzv2Myx9G1Ilj09YF9dYIDpeLSk0
        l1+qIBTnVp9fa5nFJx1E/oYlM9Tjst7aeKwcTLA=
X-Google-Smtp-Source: AGRyM1ttWJHRhPymQcdP4SpvE8yHJStZN/mxeyktm3r0+NL+ImAbRHLdSF20kBZAG1USwqjr8olA8Q==
X-Received: by 2002:a1c:7306:0:b0:3a1:8ed1:6198 with SMTP id d6-20020a1c7306000000b003a18ed16198mr4082858wmb.122.1657194712694;
        Thu, 07 Jul 2022 04:51:52 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:51:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 05/27] skbuff: carry external ubuf_info in msghdr
Date:   Thu,  7 Jul 2022 12:49:36 +0100
Message-Id: <2c3ce22ec6939856cef4329d8c95e4c8dfb355d8.1657194434.git.asml.silence@gmail.com>
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

Make possible for network in-kernel callers like io_uring to pass in a
custom ubuf_info by setting it in a new field of struct msghdr.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/socket.h | 1 +
 net/compat.c           | 1 +
 net/socket.c           | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 17311ad9f9af..7bac9fc1cee0 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -69,6 +69,7 @@ struct msghdr {
 	unsigned int	msg_flags;	/* flags on received message */
 	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
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
index 2bc8773d9dc5..ed061609265e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2106,6 +2106,7 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
+	msg.msg_ubuf = NULL;
 	if (addr) {
 		err = move_addr_to_kernel(addr, addr_len, &address);
 		if (err < 0)
@@ -2171,6 +2172,7 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 	msg.msg_namelen = 0;
 	msg.msg_iocb = NULL;
 	msg.msg_flags = 0;
+	msg.msg_ubuf = NULL;
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	err = sock_recvmsg(sock, &msg, flags);
@@ -2409,6 +2411,7 @@ int __copy_msghdr_from_user(struct msghdr *kmsg,
 		return -EMSGSIZE;
 
 	kmsg->msg_iocb = NULL;
+	kmsg->msg_ubuf = NULL;
 	*uiov = msg.msg_iov;
 	*nsegs = msg.msg_iovlen;
 	return 0;
-- 
2.36.1

