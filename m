Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF771080CA
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 22:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfKWV1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 16:27:20 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37910 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWV1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 16:27:19 -0500
Received: by mail-pf1-f196.google.com with SMTP id c13so5362038pfp.5
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 13:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eEz7AMlwqDoL6jAB3xCVkhaNYVXFYiywy/S2Pwpt2PA=;
        b=qvSp40fg2GtdQRIczP8CXEHeV3UoDaSqzzHNN80SSalENRawsAygzyKDjo65BJRxhw
         NkNoFooC+OnOOJeoUnYM6oygDWijDm3EYOVnkywUGoXMUa6VSpCvWkClaGQ+C9UU16I2
         s+YJsP5/EBfc5ox7gUOzLIomBl+qGJAh/Wxrhk5yLAFf1cRjDVWvVpGgP4L+C95MzZzB
         Qx41U90qBnXRqRK1KZ5q+nTSs8QT8oTSksd473zCyy6Q1lhAdjEPS1c1WOq/ZEP5mhqm
         JBSafFuHan9uekunwPBduZS6JkQp2EhlKwqccBymI7fLNA2gEIP+E47Sjupq666Qkp5N
         vGjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eEz7AMlwqDoL6jAB3xCVkhaNYVXFYiywy/S2Pwpt2PA=;
        b=qmzxqx5XTWKT+fu8QM6yVGSU79gzStjQCfP2RcfXzyV9lKxjzCMYU8koPtm6JfmveM
         Iy4vNy2hNt0sl046rkC+k85dbPy2p6DDtX8DAdqjUV6HhihR0TwrEFd+/U6iTTgait5E
         Ykf2aR9IS8/ZfA0mWapQ6P7pTd7RJaQOEKVUMFxiZ5Vi21cERNfnHEmdps5CkQWRLw1i
         F9nf8JHycfPvMZ3P7rSpqoNja/TxsbUTptYosqI2LgM2dKnGQFyFES1TMJ4ehaGPumb7
         qEM6S5SNl85g4TpuAITjE5ltIMlvEQ3NTelaNkI6OjgkyE69g0awVDhnFYAN+DBoUhRD
         lZkg==
X-Gm-Message-State: APjAAAVwsHPbVmMqOrKTztNr4o3X0w57vnujjxgWBmhWkGPLxHQQrSvn
        ApXudF7X/Vh/LdafBNYrV7sn2w==
X-Google-Smtp-Source: APXvYqzVral3dEv0D0w23VHOLRDe7pvWj83vhSZkJKj7zIxTQXeni1tVes/uqLddfnbXR1NVoTrnag==
X-Received: by 2002:a63:115c:: with SMTP id 28mr23368009pgr.6.1574544437246;
        Sat, 23 Nov 2019 13:27:17 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id gx16sm2981169pjb.10.2019.11.23.13.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 13:27:16 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] net: add __sys_connect_file() helper
Date:   Sat, 23 Nov 2019 14:27:08 -0700
Message-Id: <20191123212709.4598-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191123212709.4598-1-axboe@kernel.dk>
References: <20191123212709.4598-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is identical to __sys_connect(), except it takes a struct file
instead of an fd, and it also allows passing in extra file->f_flags
flags. The latter is done to support masking in O_NONBLOCK without
manipulating the original file flags.

No functional changes in this patch.

Cc: netdev@vger.kernel.org
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/socket.h |  3 +++
 net/socket.c           | 30 ++++++++++++++++++++++--------
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index dd061f741bc1..868b906f1840 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -399,6 +399,9 @@ extern int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 			 int __user *upeer_addrlen, int flags);
 extern int __sys_socket(int family, int type, int protocol);
 extern int __sys_bind(int fd, struct sockaddr __user *umyaddr, int addrlen);
+extern int __sys_connect_file(struct file *file,
+			struct sockaddr __user *uservaddr, int addrlen,
+			int file_flags);
 extern int __sys_connect(int fd, struct sockaddr __user *uservaddr,
 			 int addrlen);
 extern int __sys_listen(int fd, int backlog);
diff --git a/net/socket.c b/net/socket.c
index 40ab39f6c5d8..96e44b55d3d3 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1824,32 +1824,46 @@ SYSCALL_DEFINE3(accept, int, fd, struct sockaddr __user *, upeer_sockaddr,
  *	include the -EINPROGRESS status for such sockets.
  */
 
-int __sys_connect(int fd, struct sockaddr __user *uservaddr, int addrlen)
+int __sys_connect_file(struct file *file, struct sockaddr __user *uservaddr,
+		       int addrlen, int file_flags)
 {
 	struct socket *sock;
 	struct sockaddr_storage address;
-	int err, fput_needed;
+	int err;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sock_from_file(file, &err);
 	if (!sock)
 		goto out;
 	err = move_addr_to_kernel(uservaddr, addrlen, &address);
 	if (err < 0)
-		goto out_put;
+		goto out;
 
 	err =
 	    security_socket_connect(sock, (struct sockaddr *)&address, addrlen);
 	if (err)
-		goto out_put;
+		goto out;
 
 	err = sock->ops->connect(sock, (struct sockaddr *)&address, addrlen,
-				 sock->file->f_flags);
-out_put:
-	fput_light(sock->file, fput_needed);
+				 sock->file->f_flags | file_flags);
 out:
 	return err;
 }
 
+int __sys_connect(int fd, struct sockaddr __user *uservaddr, int addrlen)
+{
+	int ret = -EBADF;
+	struct fd f;
+
+	f = fdget(fd);
+	if (f.file) {
+		ret = __sys_connect_file(f.file, uservaddr, addrlen, 0);
+		if (f.flags)
+			fput(f.file);
+	}
+
+	return ret;
+}
+
 SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
 		int, addrlen)
 {
-- 
2.24.0

