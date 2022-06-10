Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361CE546137
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 11:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245484AbiFJJOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 05:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348190AbiFJJNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 05:13:00 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA712A25C2;
        Fri, 10 Jun 2022 02:10:33 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654852232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OAhcAWO2n5DotCrhvKKOV+N7U3sEpoP6u6cyCNbvdlI=;
        b=WqAK1kQynXnQDJAKZ35wjkaOGZIyVWB1S6dKZ0KlbbgwXZB19grXYmZBvUSvBMWGyP97Pi
        EPoeEHA9SMSUm3W8WCE/p+5hzy21Xace5nxj6+DCstng/ZLjwjL1AK8Ye8HRGS0H2Gt/hY
        ZZuYutiWyV24u7wHoAqctu+4JNFaWYQ=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: make __sys_accept4_file() static
Date:   Fri, 10 Jun 2022 17:10:17 +0800
Message-Id: <20220610091017.1991892-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__sys_accept4_file() isn't used outside of the file, make it static.

As the same time, move file_flags and nofile parameters into
__sys_accept4_file().

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/linux/socket.h |  4 ----
 net/socket.c           | 15 ++++++---------
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 17311ad9f9af..414b8c7bb8f7 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -428,10 +428,6 @@ extern int __sys_recvfrom(int fd, void __user *ubuf, size_t size,
 extern int __sys_sendto(int fd, void __user *buff, size_t len,
 			unsigned int flags, struct sockaddr __user *addr,
 			int addr_len);
-extern int __sys_accept4_file(struct file *file, unsigned file_flags,
-			struct sockaddr __user *upeer_sockaddr,
-			 int __user *upeer_addrlen, int flags,
-			 unsigned long nofile);
 extern struct file *do_accept(struct file *file, unsigned file_flags,
 			      struct sockaddr __user *upeer_sockaddr,
 			      int __user *upeer_addrlen, int flags);
diff --git a/net/socket.c b/net/socket.c
index 2bc8773d9dc5..1b6f5e2ebef5 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1878,10 +1878,8 @@ struct file *do_accept(struct file *file, unsigned file_flags,
 	return ERR_PTR(err);
 }
 
-int __sys_accept4_file(struct file *file, unsigned file_flags,
-		       struct sockaddr __user *upeer_sockaddr,
-		       int __user *upeer_addrlen, int flags,
-		       unsigned long nofile)
+static int __sys_accept4_file(struct file *file, struct sockaddr __user *upeer_sockaddr,
+			      int __user *upeer_addrlen, int flags)
 {
 	struct file *newfile;
 	int newfd;
@@ -1892,11 +1890,11 @@ int __sys_accept4_file(struct file *file, unsigned file_flags,
 	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
 		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
 
-	newfd = __get_unused_fd_flags(flags, nofile);
+	newfd = get_unused_fd_flags(flags);
 	if (unlikely(newfd < 0))
 		return newfd;
 
-	newfile = do_accept(file, file_flags, upeer_sockaddr, upeer_addrlen,
+	newfile = do_accept(file, 0, upeer_sockaddr, upeer_addrlen,
 			    flags);
 	if (IS_ERR(newfile)) {
 		put_unused_fd(newfd);
@@ -1926,9 +1924,8 @@ int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 
 	f = fdget(fd);
 	if (f.file) {
-		ret = __sys_accept4_file(f.file, 0, upeer_sockaddr,
-						upeer_addrlen, flags,
-						rlimit(RLIMIT_NOFILE));
+		ret = __sys_accept4_file(f.file, upeer_sockaddr,
+					 upeer_addrlen, flags);
 		fdput(f);
 	}
 
-- 
2.25.1

