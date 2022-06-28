Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051A455EDA9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbiF1TKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbiF1TKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:10:03 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACE61A049;
        Tue, 28 Jun 2022 12:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Cc:From:To:Date:Message-ID;
        bh=jzYbi/j3D57gaWt0HxtaLJPk+sHrnWlq2sHekUsBRVk=; b=amkpGHn3VPVJJIurV1r/PTlvlZ
        9oLWmSVsfLs2fzzbXn6RhEkRFYxNxnU4a+mKV+m99vmznOl2FlP1uKSdB54WPE+J89hu2wVjzfQFF
        KDsnWdDh4xyZRsKYktuk/u1y0uvELHq0MGQ/s72vAboXEHCJCSqCH3Xu3o+PhMO7YzMv6YTDJF7lE
        +4jl30rJAgmo2LSf7K4QNTmx3lwuXg2d6igBhr+bbon7+luq+gi3XHSnzEL7QSPbyDAv5xGxrn2IP
        iZI9Z0Rx/M6BrjHVYlmHTA+CsUIaNO0YXb3Qz6FXQ2z+lbtHdEXnqSitvHwBPDbWareUgxqbfIGVQ
        mkO8VSPl/fbJ5LBVPCHES5LKjcYuPNTb8m7ghpZH5uYwChMcpG1DFhvqVWHSQS5acRaQgZi1+4wIt
        c5f6Zhj1PAdyGd0sb+EEIQASngM7ZejL+mJBKExTonQhMemhUQZ3nxsr9Q4r/zLNjLJP/uVbFA0pp
        QFbV3OcPPM58S/gOpv8HIq8A;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1o6Gb0-0029Pu-7l; Tue, 28 Jun 2022 19:09:58 +0000
Message-ID: <bd2ad505-4d1c-ff13-de87-b4b3d397e159@samba.org>
Date:   Tue, 28 Jun 2022 21:09:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: For 5.20 or 5.19? net: wire up support for
 file_operations->uring_cmd()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jens,

I'm wondering what happened to you patch passing file_ops->uring_cmd()
down to socket layers.

It was part of you work in progress branches...

The latest one I found was this:
https://git.kernel.dk/cgit/linux-block/commit/?h=nvme-passthru-wip.2&id=28b71b85831f5dd303acae12cfdc89e5aaae442b

And this one just having the generic parts were in a separate commit
https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-fops.v7&id=c2ba3bd8940ef0b7d1c09adf4bed01acc8171407
vs.
https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-fops.v7&id=542c38da58841097f97f710d1f05055c2f1039f0

I took this:
https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-fops.v7&id=c2ba3bd8940ef0b7d1c09adf4bed01acc8171407
adapted it on top of v5.19-rc4 and removed stuff that was not really needed.

Even if it's not used in tree, it would be good to have uring_cmd hooks in
struct proto_ops and struct proto, so that out of tree socket implementations
like my smbdirect driver are able to hook into it.

What do you think?

https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=7541d40a482a9f57d580ac05254c5a5982edff15

 From 7541d40a482a9f57d580ac05254c5a5982edff15 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 18 Dec 2020 15:12:46 -0700
Subject: [PATCH] net: wire up support for file_operations->uring_cmd()

Pass it through the proto_ops->uring_cmd() handler, so we can plumb it
through all the way to the proto->uring_cmd() handler later
as required.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
  include/linux/net.h |  4 ++++
  include/net/sock.h  |  7 +++++++
  net/core/sock.c     | 12 ++++++++++++
  net/socket.c        | 13 +++++++++++++
  4 files changed, 36 insertions(+)

diff --git a/include/linux/net.h b/include/linux/net.h
index 12093f4db50c..59d37aade979 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -31,6 +31,7 @@ struct pipe_inode_info;
  struct inode;
  struct file;
  struct net;
+struct io_uring_cmd;

  /* Historically, SOCKWQ_ASYNC_NOSPACE & SOCKWQ_ASYNC_WAITDATA were located
   * in sock->flags, but moved into sk->sk_wq->flags to be RCU protected.
@@ -178,6 +179,9 @@ struct proto_ops {
  	int	 	(*compat_ioctl) (struct socket *sock, unsigned int cmd,
  				      unsigned long arg);
  #endif
+	int		(*uring_cmd)(struct socket *sock,
+				     struct io_uring_cmd *ioucmd,
+				     unsigned issue_flags);
  	int		(*gettstamp) (struct socket *sock, void __user *userstamp,
  				      bool timeval, bool time32);
  	int		(*listen)    (struct socket *sock, int len);
diff --git a/include/net/sock.h b/include/net/sock.h
index 72ca97ccb460..80fd3f45cd09 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -111,6 +111,7 @@ typedef struct {
  struct sock;
  struct proto;
  struct net;
+struct io_uring_cmd;

  typedef __u32 __bitwise __portpair;
  typedef __u64 __bitwise __addrpair;
@@ -1181,6 +1182,9 @@ struct proto {

  	int			(*ioctl)(struct sock *sk, int cmd,
  					 unsigned long arg);
+	int			(*uring_cmd)(struct sock *sk,
+					struct io_uring_cmd *ioucmd,
+					unsigned int issue_flags);
  	int			(*init)(struct sock *sk);
  	void			(*destroy)(struct sock *sk);
  	void			(*shutdown)(struct sock *sk, int how);
@@ -1886,6 +1890,9 @@ int sock_common_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
  int sock_common_setsockopt(struct socket *sock, int level, int optname,
  			   sockptr_t optval, unsigned int optlen);

+int sock_common_uring_cmd(struct socket *sock, struct io_uring_cmd *ioucmd,
+			  unsigned int issue_flags);
+
  void sk_common_release(struct sock *sk);

  /*
diff --git a/net/core/sock.c b/net/core/sock.c
index 2ff40dd0a7a6..42b3def01a5f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3582,6 +3582,18 @@ int sock_common_setsockopt(struct socket *sock, int level, int optname,
  }
  EXPORT_SYMBOL(sock_common_setsockopt);

+int sock_common_uring_cmd(struct socket *sock, struct io_uring_cmd *ioucmd,
+			  unsigned int issue_flags)
+{
+	struct sock *sk = sock->sk;
+
+	if (!sk->sk_prot->uring_cmd)
+		return -EOPNOTSUPP;
+
+	return sk->sk_prot->uring_cmd(sk, ioucmd, issue_flags);
+}
+EXPORT_SYMBOL(sock_common_uring_cmd);
+
  void sk_common_release(struct sock *sk)
  {
  	if (sk->sk_prot->destroy)
diff --git a/net/socket.c b/net/socket.c
index 2bc8773d9dc5..67701c685921 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -87,6 +87,7 @@
  #include <linux/xattr.h>
  #include <linux/nospec.h>
  #include <linux/indirect_call_wrapper.h>
+#include <linux/io_uring.h>

  #include <linux/uaccess.h>
  #include <asm/unistd.h>
@@ -115,6 +116,7 @@ unsigned int sysctl_net_busy_poll __read_mostly;
  static ssize_t sock_read_iter(struct kiocb *iocb, struct iov_iter *to);
  static ssize_t sock_write_iter(struct kiocb *iocb, struct iov_iter *from);
  static int sock_mmap(struct file *file, struct vm_area_struct *vma);
+static int sock_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags);

  static int sock_close(struct inode *inode, struct file *file);
  static __poll_t sock_poll(struct file *file,
@@ -158,6 +160,7 @@ static const struct file_operations socket_file_ops = {
  #ifdef CONFIG_COMPAT
  	.compat_ioctl = compat_sock_ioctl,
  #endif
+	.uring_cmd =	sock_uring_cmd,
  	.mmap =		sock_mmap,
  	.release =	sock_close,
  	.fasync =	sock_fasync,
@@ -1289,6 +1292,16 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
  	return err;
  }

+static int sock_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
+{
+	struct socket *sock = ioucmd->file->private_data;
+
+	if (!sock->ops->uring_cmd)
+		return -EOPNOTSUPP;
+
+	return sock->ops->uring_cmd(sock, ioucmd, issue_flags);
+}
+
  /**
   *	sock_create_lite - creates a socket
   *	@family: protocol family (AF_INET, ...)
-- 
2.34.1

