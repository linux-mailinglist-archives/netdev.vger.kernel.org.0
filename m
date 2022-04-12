Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8D44FE983
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 22:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiDLUkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 16:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiDLUj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 16:39:56 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AFEA27CC
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:35:40 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id w127so20227553oig.10
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ueKQiaOwXWfO1zTh53PpaKJgbzCNJb2g84lcVyQKwFo=;
        b=7VxnOEQ9Ueusg4iiUr4Ng9ShyQFNu4rc5xSfsFuwKmE1w+/3KoMDSZdinNaIf3YCr/
         7ka35af4fX2nc1T7VGvYVlnDXIz2QWMPlgAi04jnSB2iuf9CfNhT0JAOlfmMy2u4Xy5r
         C1HlRaMghMVfaipiUNI9j1dm4g1TlFV9G+hkzaRYjfrKRd7e4PQa+BJfRwcZ0JRsCJA8
         ZNuAC0+pQmk+QQogz3c0B8mlPLeZY6W1kwd8O1fc1u2gj3UxYUjtectfHCd/lAUSWNfX
         WS610zP9V7xQZMNF66ZzhbrFAJVvPEa2MEFDASbzOGT0eql9Yw1RnCFQmAud81v77mgw
         7LlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ueKQiaOwXWfO1zTh53PpaKJgbzCNJb2g84lcVyQKwFo=;
        b=ovMyc2Y8y2wXd+9CLAiH8ELYySK3Fi7InWkTR0YxSGNoiru72TxgqqD8iwXHKOqikA
         UKB1yCa3BeGN4bNsf3h97LOvU/QQ8XhRckmxrI95GrwaZ32210HkMFzGHlfoUKtGAtOx
         PDBpw7G/4yxb5VtpED5H21WIajDMluAwbsRClRe9eokNsdn5VV6HQ2IshxL18BoZ2STj
         m7JAg8gV2j3hevXFvuOplRmTsRwq30J6/YS4n90MxN+OkLTaBlzm73kXZBHUN0aZJqUk
         q0qv89fQ7d3HFO+1dnLgMZourivZBYMg8YfXNTS/US+DhNLM/ykc0oVZD3EmktN6P+K2
         767g==
X-Gm-Message-State: AOAM533Fhz7AHTeEYbM7Q+XGNqps0A39hY7yRBbez30DIdOPlCyzXMVc
        wq8ToUHf64+hZQI9d5ins4ObEAn/GEr+dJAx
X-Google-Smtp-Source: ABdhPJxxGOJpZrS5Z7s7jUuALDyKOR+u1VMtR7kbGQyCtniJpNOovNYrUGaaFNLskM3jhPZGp56dpQ==
X-Received: by 2002:a17:90b:390c:b0:1c7:9a94:1797 with SMTP id ob12-20020a17090b390c00b001c79a941797mr6861472pjb.221.1649794964278;
        Tue, 12 Apr 2022 13:22:44 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 2-20020a17090a0f0200b001cb6621403csm359541pjy.24.2022.04.12.13.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:22:43 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] net: add __sys_socket_file()
Date:   Tue, 12 Apr 2022 14:22:39 -0600
Message-Id: <20220412202240.234207-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412202240.234207-1-axboe@kernel.dk>
References: <20220412202240.234207-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This works like __sys_socket(), except instead of allocating and
returning a socket fd, it just returns the file associated with the
socket. No fd is installed into the process file table.

This is similar to do_accept(), and allows io_uring to use this without
instantiating a file descriptor in the process file table.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/socket.h |  1 +
 net/socket.c           | 52 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 6f85f5d957ef..a1882e1e71d2 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -434,6 +434,7 @@ extern struct file *do_accept(struct file *file, unsigned file_flags,
 extern int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 			 int __user *upeer_addrlen, int flags);
 extern int __sys_socket(int family, int type, int protocol);
+extern struct file *__sys_socket_file(int family, int type, int protocol);
 extern int __sys_bind(int fd, struct sockaddr __user *umyaddr, int addrlen);
 extern int __sys_connect_file(struct file *file, struct sockaddr_storage *addr,
 			      int addrlen, int file_flags);
diff --git a/net/socket.c b/net/socket.c
index 6887840682bb..bb6a1a12fbde 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -504,7 +504,7 @@ static int sock_map_fd(struct socket *sock, int flags)
 struct socket *sock_from_file(struct file *file)
 {
 	if (file->f_op == &socket_file_ops)
-		return file->private_data;	/* set in sock_map_fd */
+		return file->private_data;	/* set in sock_alloc_file */
 
 	return NULL;
 }
@@ -1538,11 +1538,10 @@ int sock_create_kern(struct net *net, int family, int type, int protocol, struct
 }
 EXPORT_SYMBOL(sock_create_kern);
 
-int __sys_socket(int family, int type, int protocol)
+static struct socket *__sys_socket_create(int family, int type, int protocol)
 {
-	int retval;
 	struct socket *sock;
-	int flags;
+	int retval;
 
 	/* Check the SOCK_* constants for consistency.  */
 	BUILD_BUG_ON(SOCK_CLOEXEC != O_CLOEXEC);
@@ -1550,17 +1549,50 @@ int __sys_socket(int family, int type, int protocol)
 	BUILD_BUG_ON(SOCK_CLOEXEC & SOCK_TYPE_MASK);
 	BUILD_BUG_ON(SOCK_NONBLOCK & SOCK_TYPE_MASK);
 
-	flags = type & ~SOCK_TYPE_MASK;
-	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
-		return -EINVAL;
+	if ((type & ~SOCK_TYPE_MASK) & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
+		return ERR_PTR(-EINVAL);
 	type &= SOCK_TYPE_MASK;
 
+	retval = sock_create(family, type, protocol, &sock);
+	if (retval < 0)
+		return ERR_PTR(retval);
+
+	return sock;
+}
+
+struct file *__sys_socket_file(int family, int type, int protocol)
+{
+	struct socket *sock;
+	struct file *file;
+	int flags;
+
+	sock = __sys_socket_create(family, type, protocol);
+	if (IS_ERR(sock))
+		return ERR_CAST(sock);
+
+	flags = type & ~SOCK_TYPE_MASK;
 	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
 		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
 
-	retval = sock_create(family, type, protocol, &sock);
-	if (retval < 0)
-		return retval;
+	file = sock_alloc_file(sock, flags, NULL);
+	if (IS_ERR(file))
+		sock_release(sock);
+
+	return file;
+}
+
+int __sys_socket(int family, int type, int protocol)
+{
+	struct socket *sock;
+	int flags;
+
+	sock = __sys_socket_create(family, type, protocol);
+	if (IS_ERR(sock))
+		return PTR_ERR(sock);
+
+	flags = type & ~SOCK_TYPE_MASK;
+	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
+		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
 
 	return sock_map_fd(sock, flags & (O_CLOEXEC | O_NONBLOCK));
 }
-- 
2.35.1

