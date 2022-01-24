Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64BE497C4B
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 10:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbiAXJnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 04:43:39 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:60036 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234683AbiAXJni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 04:43:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0V2iRB-._1643017411;
Received: from hao-A29R.hz.ali.com(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V2iRB-._1643017411)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 24 Jan 2022 17:43:32 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     netdev@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 3/3] io_uring: zerocopy receive
Date:   Mon, 24 Jan 2022 17:43:20 +0800
Message-Id: <20220124094320.900713-4-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124094320.900713-1-haoxu@linux.alibaba.com>
References: <20220124094320.900713-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Integrate the current zerocopy receive solution to io_uring for eazier
use. The current calling process is:
  1) mmap a range of virtual address
  2) poll() to wait for data ready of the sockfd
  3) call getsockopt() to map the address in 1) to physical pages
  4) access the data.

By integrating it to io_uring, 2) and 3) can be merged:
  1) mmap a range of virtual address
  2) prepare a sqe and submit
  3) get a cqe which indicates data is ready and mapped
  4) access the data

which reduce one system call and make users be unaware of 3)

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c                 | 72 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 73 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 422d6de48688..5826d84400f6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -81,6 +81,7 @@
 #include <linux/tracehook.h>
 #include <linux/audit.h>
 #include <linux/security.h>
+#include <net/tcp.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -581,6 +582,12 @@ struct io_sr_msg {
 	size_t				len;
 };
 
+struct io_recvzc {
+	struct file			*file;
+	char __user			*u_zc;
+	int __user			*u_len;
+};
+
 struct io_open {
 	struct file			*file;
 	int				dfd;
@@ -855,6 +862,7 @@ struct io_kiocb {
 		struct io_mkdir		mkdir;
 		struct io_symlink	symlink;
 		struct io_hardlink	hardlink;
+		struct io_recvzc	recvzc;
 	};
 
 	u8				opcode;
@@ -1105,6 +1113,12 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
 	[IORING_OP_LINKAT] = {},
+	[IORING_OP_RECVZC] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.audit_skip		= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -5243,6 +5257,59 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_recvzc *recvzc = &req->recvzc;
+
+#ifndef CONFIG_MMU
+	return -EOPNOTSUPP;
+#endif
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->len || sqe->buf_index)
+		return -EINVAL;
+
+	recvzc->u_zc = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	recvzc->u_len = u64_to_user_ptr(READ_ONCE(sqe->off));
+
+	return 0;
+}
+
+static int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct scm_timestamping_internal tss;
+	struct io_recvzc *recvzc = &req->recvzc;
+	struct tcp_zerocopy_receive zc;
+	char __user *u_zc = recvzc->u_zc;
+	int __user *u_len = recvzc->u_len;
+	int len = 0;
+	struct socket *sock;
+	struct sock *sk;
+	int err;
+
+	if (!(req->flags & REQ_F_POLLED))
+		return -EAGAIN;
+
+	err = zc_receive_check(&zc, &len, u_zc, u_len);
+	if (err)
+		goto out;
+
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	sk = sock->sk;
+	lock_sock(sk);
+	err = tcp_zerocopy_receive(sk, &zc, &tss);
+	release_sock(sk);
+	err = zc_receive_update(sk, &zc, len, u_zc, &tss, err);
+
+out:
+	__io_req_complete(req, issue_flags, err, 0);
+
+	return 0;
+}
+
 static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = &req->accept;
@@ -6563,6 +6630,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_symlinkat_prep(req, sqe);
 	case IORING_OP_LINKAT:
 		return io_linkat_prep(req, sqe);
+	case IORING_OP_RECVZC:
+		return io_recvzc_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6846,6 +6915,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_LINKAT:
 		ret = io_linkat(req, issue_flags);
 		break;
+	case IORING_OP_RECVZC:
+		ret = io_recvzc(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 787f491f0d2a..79eb43c64da2 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -143,6 +143,7 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_RECVZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

