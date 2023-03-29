Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B7B6CDBD8
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjC2OQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjC2OQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:16:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24924C30
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680099254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jo7xD6cW+5TTIp8oqR2hYvnkWHwWe/N8CbruF8cE9GA=;
        b=XSorInbJHYv7h0BCJsb/2BlcJsTxSyyglGtCgq/izDeFljKyhqfM0I8+mZxo/kg4Y6YZgR
        YP7gqXE8Ghnsea46ocW0FpYKxg/MWCGwZPuhsQgP3Z3MZpzNo5P8R16sR+5r13ZxxUsUnq
        DqFqOEzAQdBHRBR7zJaY8dmQ7pl4khw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-hXJAadh0MrOcoI5-BRrEXg-1; Wed, 29 Mar 2023 10:14:11 -0400
X-MC-Unique: hXJAadh0MrOcoI5-BRrEXg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42E2B185A78B;
        Wed, 29 Mar 2023 14:14:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BD8D2166B33;
        Wed, 29 Mar 2023 14:14:08 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [RFC PATCH v2 04/48] net: Declare MSG_SPLICE_PAGES internal sendmsg() flag
Date:   Wed, 29 Mar 2023 15:13:10 +0100
Message-Id: <20230329141354.516864-5-dhowells@redhat.com>
In-Reply-To: <20230329141354.516864-1-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Declare MSG_SPLICE_PAGES, an internal sendmsg() flag, that hints to a
network protocol that it should splice pages from the source iterator
rather than copying the data if it can.  This flag is added to a list that
is cleared by sendmsg and recvmsg syscalls on entry.

This is intended as a replacement for the ->sendpage() op, allowing a way
to splice in several multipage folios in one go.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 include/linux/socket.h | 3 +++
 net/socket.c           | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 13c3a237b9c9..c2fa0f800999 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -327,6 +327,7 @@ struct ucred {
 					  */
 
 #define MSG_ZEROCOPY	0x4000000	/* Use user data in kernel path */
+#define MSG_SPLICE_PAGES 0x8000000	/* Splice the pages from the iterator in sendmsg() */
 #define MSG_FASTOPEN	0x20000000	/* Send data in TCP SYN */
 #define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exec for file
 					   descriptor received through
@@ -337,6 +338,8 @@ struct ucred {
 #define MSG_CMSG_COMPAT	0		/* We never have 32 bit fixups */
 #endif
 
+/* Flags to be cleared on entry by sendmsg, recvmsg, sendmmsg and recvmmsg syscalls */
+#define MSG_INTERNAL_FLAGS (MSG_SPLICE_PAGES)
 
 /* Setsockoptions(2) level. Thanks to BSD these must match IPPROTO_xxx */
 #define SOL_IP		0
diff --git a/net/socket.c b/net/socket.c
index 6bae8ce7059e..dfb912bbed62 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2139,6 +2139,7 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 		msg.msg_name = (struct sockaddr *)&address;
 		msg.msg_namelen = addr_len;
 	}
+	flags &= ~MSG_INTERNAL_FLAGS;
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	msg.msg_flags = flags;
@@ -2192,6 +2193,7 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 	if (!sock)
 		goto out;
 
+	flags &= ~MSG_INTERNAL_FLAGS;
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	err = sock_recvmsg(sock, &msg, flags);
@@ -2579,6 +2581,7 @@ long __sys_sendmsg(int fd, struct user_msghdr __user *msg, unsigned int flags,
 
 	if (forbid_cmsg_compat && (flags & MSG_CMSG_COMPAT))
 		return -EINVAL;
+	flags &= ~MSG_INTERNAL_FLAGS;
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
@@ -2627,6 +2630,7 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 	entry = mmsg;
 	compat_entry = (struct compat_mmsghdr __user *)mmsg;
 	err = 0;
+	flags &= ~MSG_INTERNAL_FLAGS;
 	flags |= MSG_BATCH;
 
 	while (datagrams < vlen) {
@@ -2775,6 +2779,7 @@ long __sys_recvmsg_sock(struct socket *sock, struct msghdr *msg,
 			struct user_msghdr __user *umsg,
 			struct sockaddr __user *uaddr, unsigned int flags)
 {
+	flags &= ~MSG_INTERNAL_FLAGS;
 	return ____sys_recvmsg(sock, msg, umsg, uaddr, flags, 0);
 }
 
@@ -2787,6 +2792,7 @@ long __sys_recvmsg(int fd, struct user_msghdr __user *msg, unsigned int flags,
 
 	if (forbid_cmsg_compat && (flags & MSG_CMSG_COMPAT))
 		return -EINVAL;
+	flags &= ~MSG_INTERNAL_FLAGS;
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
@@ -2839,6 +2845,7 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 			goto out_put;
 		}
 	}
+	flags &= ~MSG_INTERNAL_FLAGS;
 
 	entry = mmsg;
 	compat_entry = (struct compat_mmsghdr __user *)mmsg;

