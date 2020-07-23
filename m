Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54B422A752
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgGWGKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727871AbgGWGKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:10:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA58CC0619DC;
        Wed, 22 Jul 2020 23:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=WZEyzaS1ykzyi+yQ2LS2wMvQkwL8k8wAtqvtWngMf9k=; b=GkQOrco1ZkuQcjMqhyS87SJRGD
        de3B5cw7G5yO9PMtzI5w0X5s2yopJqUiVbmSr+As98wWMXn6Xl8y79CmwAlaI3j3ebpY9UAteT4Cn
        4frKKigvk1Di9ljBzfXFKftGwds+aPPL5GLXVJjbCp6Lfwgns5RMwKcigxjHrK7cICgV+R/NKR37U
        SMOd4Y2ouS0ew7sS3pWavsl7KIbbei8X3CRKa1fmzw0vOVSoAqB/W9Ie3NBqoKgOKk97nUpIMcDP1
        iQ+w1wBnm6LrsYc5mEgaq6c5MgkmC+YhQvxGnziaBnG3fCFxlBnwCMxWkRXbiG0+qq3YlYZUO7b8q
        DOf9lBbQ==;
Received: from [2001:4bb8:18c:2acc:91df:aae8:fa3b:de9c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyUQN-0003qJ-36; Thu, 23 Jul 2020 06:09:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: [PATCH 26/26] net: optimize the sockptr_t for unified kernel/user address spaces
Date:   Thu, 23 Jul 2020 08:09:08 +0200
Message-Id: <20200723060908.50081-27-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723060908.50081-1-hch@lst.de>
References: <20200723060908.50081-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For architectures like x86 and arm64 we don't need the separate bit to
indicate that a pointer is a kernel pointer as the address spaces are
unified.  That way the sockptr_t can be reduced to a union of two
pointers, which leads to nicer calling conventions.

The only caveat is that we need to check that users don't pass in kernel
address and thus gain access to kernel memory.  Thus the USER_SOCKPTR
helper is replaced with a init_user_sockptr function that does this check
and returns an error if it fails.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/sockptr.h     | 32 ++++++++++++++++++++++++++++++--
 net/ipv4/bpfilter/sockopt.c | 14 ++++++++------
 net/socket.c                |  6 +++++-
 3 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index 700856e13ea0c4..7d5cdb2b30b5f0 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -8,9 +8,34 @@
 #ifndef _LINUX_SOCKPTR_H
 #define _LINUX_SOCKPTR_H
 
+#include <linux/compiler.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+typedef union {
+	void		*kernel;
+	void __user	*user;
+} sockptr_t;
+
+static inline bool sockptr_is_kernel(sockptr_t sockptr)
+{
+	return (unsigned long)sockptr.kernel >= TASK_SIZE;
+}
+
+static inline sockptr_t KERNEL_SOCKPTR(void *p)
+{
+	return (sockptr_t) { .kernel = p };
+}
+
+static inline int __must_check init_user_sockptr(sockptr_t *sp, void __user *p)
+{
+	if ((unsigned long)p >= TASK_SIZE)
+		return -EFAULT;
+	sp->user = p;
+	return 0;
+}
+#else /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
 typedef struct {
 	union {
 		void		*kernel;
@@ -29,10 +54,13 @@ static inline sockptr_t KERNEL_SOCKPTR(void *p)
 	return (sockptr_t) { .kernel = p, .is_kernel = true };
 }
 
-static inline sockptr_t USER_SOCKPTR(void __user *p)
+static inline int __must_check init_user_sockptr(sockptr_t *sp, void __user *p)
 {
-	return (sockptr_t) { .user = p };
+	sp->user = p;
+	sp->is_kernel = false;
+	return 0;
 }
+#endif /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
 
 static inline bool sockptr_is_null(sockptr_t sockptr)
 {
diff --git a/net/ipv4/bpfilter/sockopt.c b/net/ipv4/bpfilter/sockopt.c
index 1b34cb9a7708ec..94f18d2352d007 100644
--- a/net/ipv4/bpfilter/sockopt.c
+++ b/net/ipv4/bpfilter/sockopt.c
@@ -57,16 +57,18 @@ int bpfilter_ip_set_sockopt(struct sock *sk, int optname, sockptr_t optval,
 	return bpfilter_mbox_request(sk, optname, optval, optlen, true);
 }
 
-int bpfilter_ip_get_sockopt(struct sock *sk, int optname, char __user *optval,
-			    int __user *optlen)
+int bpfilter_ip_get_sockopt(struct sock *sk, int optname,
+			    char __user *user_optval, int __user *optlen)
 {
-	int len;
+	sockptr_t optval;
+	int err, len;
 
 	if (get_user(len, optlen))
 		return -EFAULT;
-
-	return bpfilter_mbox_request(sk, optname, USER_SOCKPTR(optval), len,
-				     false);
+	err = init_user_sockptr(&optval, user_optval);
+	if (err)
+		return err;
+	return bpfilter_mbox_request(sk, optname, optval, len, false);
 }
 
 static int __init bpfilter_sockopt_init(void)
diff --git a/net/socket.c b/net/socket.c
index e44b8ac47f6f46..94ca4547cd7c53 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2097,7 +2097,7 @@ static bool sock_use_custom_sol_socket(const struct socket *sock)
 int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
 		int optlen)
 {
-	sockptr_t optval = USER_SOCKPTR(user_optval);
+	sockptr_t optval;
 	char *kernel_optval = NULL;
 	int err, fput_needed;
 	struct socket *sock;
@@ -2105,6 +2105,10 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
 	if (optlen < 0)
 		return -EINVAL;
 
+	err = init_user_sockptr(&optval, user_optval);
+	if (err)
+		return err;
+
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		return err;
-- 
2.27.0

