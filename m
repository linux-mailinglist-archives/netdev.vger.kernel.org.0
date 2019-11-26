Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D175C109794
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 02:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKZBby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 20:31:54 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:34384 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbfKZBbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 20:31:53 -0500
Received: by mail-il1-f196.google.com with SMTP id p6so16118817ilp.1
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 17:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WlgH2RDjNSOXYswpwLDegnrZomn5J62sHM7WI8d93YU=;
        b=usWbjVAhcViloEn0w1gGt6z/WTzV2nmrjLwgioW6xLaGcTD8vPxVxwtGjKGGMFhLp3
         zH5jsYrppPIiqX6rBMH4LR3pYNDdd8+HQr1BKa20rybfWs2TpqF7yEPNQte+ewXZCEqV
         hlUkJz8U7Vue/6IFsWToV23eX0jBZP04eBEpZHhATnONm73ulZ8i0iRK/scLbwwU3Jvs
         kzhMH5kdPY5DbBDckNI/TpVK/gc/liaedXnpk2MdY/ubIzu3KhH+WKxOLIVjRPArRABM
         DDmvOJMUOScWkAGmneLf7Zvi9tiJE3hK0FKXzbisHr1Uak4Z7HBA2rC63EsYE+DQkM+r
         fhIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WlgH2RDjNSOXYswpwLDegnrZomn5J62sHM7WI8d93YU=;
        b=LKn5O55ifWyCRFvWwBUeJSpnr3cJslJgqDT1EioWp5AziiYcXtuO8zRMKwbf3/PyDN
         WlvbFQx3bhMCAFkeAdYUn6JSK1RlivDTQMNetnmrTOXk4O+H0RFE0FkY1xBYNTTwlJY9
         kRLDhIHkIlq7Kbml0pr62ITMbdoaqj91YBaLTdtwdh6hVTZYymfVnkPm6uakcReWf+UB
         9fQG5hxvVJ9y2FZ+v6lzu77TDSRXDBVILDfpn+rxYyGYQ+HJ2GX/44l1Q5dB6P8fCDiH
         HfS3uxxvNbfgfhLzTCzKgUEIj8BSOnGApG3jO5CN6VijCtjDZI4Wc2jePfaIAevxQU+w
         928g==
X-Gm-Message-State: APjAAAUQGYx/t4GXYVKH2yr6OsDdHdUeVWv85sFV1QYCbWHsgagET3zI
        Pd1KiRYBA/yd6dHmnexuiuSglwpk2zEm+A==
X-Google-Smtp-Source: APXvYqwpnpy5eJgH0htgxVjrypLtKvOBFazNsDUpoaONoLl/wguNOwsTxYnSJugB2TUrv8wulSPStg==
X-Received: by 2002:a92:c981:: with SMTP id y1mr35125175iln.53.1574731912121;
        Mon, 25 Nov 2019 17:31:52 -0800 (PST)
Received: from localhost.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v15sm2723353ilk.8.2019.11.25.17.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 17:31:51 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] net: disallow ancillary data for __sys_{send,recv}msg_file()
Date:   Mon, 25 Nov 2019 18:31:45 -0700
Message-Id: <20191126013145.23426-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191126013145.23426-1-axboe@kernel.dk>
References: <20191126013145.23426-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only io_uring uses (and added) these, and we want to disallow the
use of sendmsg/recvmsg for anything but regular data transfers.
Use the newly added prep helper to split the msghdr copy out from
the core function, to check for msg_control and msg_controllen
settings. If either is set, we return -EINVAL.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 net/socket.c | 43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index da729df8f03d..2d6083b881ab 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2388,12 +2388,27 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 /*
  *	BSD sendmsg interface
  */
-long __sys_sendmsg_sock(struct socket *sock, struct user_msghdr __user *msg,
+long __sys_sendmsg_sock(struct socket *sock, struct user_msghdr __user *umsg,
 			unsigned int flags)
 {
-	struct msghdr msg_sys;
+	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	struct sockaddr_storage address;
+	struct msghdr msg = { .msg_name = &address };
+	ssize_t err;
+
+	err = sendmsg_copy_msghdr(&msg, umsg, flags, &iov);
+	if (err)
+		return err;
+	/* disallow ancillary data requests from this path */
+	if (msg.msg_control || msg.msg_controllen) {
+		err = -EINVAL;
+		goto out;
+	}
 
-	return ___sys_sendmsg(sock, msg, &msg_sys, flags, NULL, 0);
+	err = ____sys_sendmsg(sock, &msg, flags, NULL, 0);
+out:
+	kfree(iov);
+	return err;
 }
 
 long __sys_sendmsg(int fd, struct user_msghdr __user *msg, unsigned int flags,
@@ -2592,12 +2607,28 @@ static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
  *	BSD recvmsg interface
  */
 
-long __sys_recvmsg_sock(struct socket *sock, struct user_msghdr __user *msg,
+long __sys_recvmsg_sock(struct socket *sock, struct user_msghdr __user *umsg,
 			unsigned int flags)
 {
-	struct msghdr msg_sys;
+	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	struct sockaddr_storage address;
+	struct msghdr msg = { .msg_name = &address };
+	struct sockaddr __user *uaddr;
+	ssize_t err;
 
-	return ___sys_recvmsg(sock, msg, &msg_sys, flags, 0);
+	err = recvmsg_copy_msghdr(&msg, umsg, flags, &uaddr, &iov);
+	if (err)
+		return err;
+	/* disallow ancillary data requests from this path */
+	if (msg.msg_control || msg.msg_controllen) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = ____sys_recvmsg(sock, &msg, umsg, uaddr, flags, 0);
+out:
+	kfree(iov);
+	return err;
 }
 
 long __sys_recvmsg(int fd, struct user_msghdr __user *msg, unsigned int flags,
-- 
2.24.0

