Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22FC116A79
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 11:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfLIKEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 05:04:15 -0500
Received: from relay.sw.ru ([185.231.240.75]:57726 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfLIKEO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 05:04:14 -0500
Received: from dhcp-172-16-24-104.sw.ru ([172.16.24.104] helo=localhost.localdomain)
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1ieFtE-0002QD-US; Mon, 09 Dec 2019 13:03:41 +0300
Subject: [PATCH net-next v2 1/2] net: Allow to show socket-specific
 information in /proc/[pid]/fdinfo/[fd]
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, axboe@kernel.dk,
        pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, hare@suse.com, tglx@linutronix.de,
        edumazet@google.com, arnd@arndb.de, ktkhai@virtuozzo.com
Date:   Mon, 09 Dec 2019 13:03:40 +0300
Message-ID: <157588582083.223723.6487930747091350337.stgit@localhost.localdomain>
In-Reply-To: <157588565669.223723.2766246342567340687.stgit@localhost.localdomain>
References: <157588565669.223723.2766246342567340687.stgit@localhost.localdomain>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds .show_fdinfo to socket_file_ops, so protocols will be able
to print their specific data in fdinfo.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 include/linux/net.h |    1 +
 net/socket.c        |   12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/net.h b/include/linux/net.h
index 9cafb5f353a9..6451425e828f 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -171,6 +171,7 @@ struct proto_ops {
 	int		(*compat_getsockopt)(struct socket *sock, int level,
 				      int optname, char __user *optval, int __user *optlen);
 #endif
+	void		(*show_fdinfo)(struct seq_file *m, struct socket *sock);
 	int		(*sendmsg)   (struct socket *sock, struct msghdr *m,
 				      size_t total_len);
 	/* Notes for implementing recvmsg:
diff --git a/net/socket.c b/net/socket.c
index 4d38d49d6ad9..532f123e0459 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -128,6 +128,7 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
 static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
 				struct pipe_inode_info *pipe, size_t len,
 				unsigned int flags);
+static void sock_show_fdinfo(struct seq_file *m, struct file *f);
 
 /*
  *	Socket files have a set of 'special' operations as well as the generic file ones. These don't appear
@@ -150,6 +151,9 @@ static const struct file_operations socket_file_ops = {
 	.sendpage =	sock_sendpage,
 	.splice_write = generic_splice_sendpage,
 	.splice_read =	sock_splice_read,
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo =	sock_show_fdinfo,
+#endif
 };
 
 /*
@@ -993,6 +997,14 @@ static ssize_t sock_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	return res;
 }
 
+static void sock_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct socket *sock = f->private_data;
+
+	if (sock->ops->show_fdinfo)
+		sock->ops->show_fdinfo(m, sock);
+}
+
 /*
  * Atomic setting of ioctl hooks to avoid race
  * with module unload.


