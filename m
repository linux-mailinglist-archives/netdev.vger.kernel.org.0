Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4B86D842B
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbjDEQzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbjDEQzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:55:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3340A4228
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680713634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QAACn2mr7ooi1DdUlemHLPNq4itk2LGg3Qvic6fgj7U=;
        b=GNRFITE9X4momIJo8VU7T+mXQ4C7g8UqgqUBezeRzZamkmP3y5a5oW1AcY8cYyIJU1Ch/w
        XeoepaWgO8uvi7yoWWXTRIQ4X3ulvm+NrVUi7cr+eWJqs28I6o1MaVs+8YTi2Puq5ORZko
        3xC1KcLfRKHczFc3ngLrM5UPlPboc3I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-CL3O1Pd0MuC9cMWkPeSHyw-1; Wed, 05 Apr 2023 12:53:51 -0400
X-MC-Unique: CL3O1Pd0MuC9cMWkPeSHyw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82003185A791;
        Wed,  5 Apr 2023 16:53:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A251400F57;
        Wed,  5 Apr 2023 16:53:48 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next v4 02/20] net: Declare MSG_SPLICE_PAGES internal sendmsg() flag
Date:   Wed,  5 Apr 2023 17:53:21 +0100
Message-Id: <20230405165339.3468808-3-dhowells@redhat.com>
In-Reply-To: <20230405165339.3468808-1-dhowells@redhat.com>
References: <20230405165339.3468808-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
is cleared by sendmsg syscalls on entry.

This is intended as a replacement for the ->sendpage() op, allowing a way
to splice in several multipage folios in one go.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 include/linux/socket.h | 3 +++
 net/socket.c           | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 13c3a237b9c9..bd1cc3238851 100644
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
 
+/* Flags to be cleared on entry by sendmsg and sendmmsg syscalls */
+#define MSG_INTERNAL_SENDMSG_FLAGS (MSG_SPLICE_PAGES)
 
 /* Setsockoptions(2) level. Thanks to BSD these must match IPPROTO_xxx */
 #define SOL_IP		0
diff --git a/net/socket.c b/net/socket.c
index 73e493da4589..b3fd3f7f7e03 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2136,6 +2136,7 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 		msg.msg_name = (struct sockaddr *)&address;
 		msg.msg_namelen = addr_len;
 	}
+	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	msg.msg_flags = flags;
@@ -2483,6 +2484,7 @@ static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
 	}
 	msg_sys->msg_flags = flags;
 
+	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
 	if (sock->file->f_flags & O_NONBLOCK)
 		msg_sys->msg_flags |= MSG_DONTWAIT;
 	/*

