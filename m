Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AFF240B52
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 18:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgHJQmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 12:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgHJQmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 12:42:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF83C061756;
        Mon, 10 Aug 2020 09:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=0gNEY5Uv1ZkTqXZzTvCE95coh5FKKxp18NgRISISDKM=; b=Z7G2rkO8kDefAvSPfeT4ryYwZB
        Q83kptDsfUHDNOro3ep1o88Az8fSP/ODnUCCuL4uIescM78U93TfWfCWrliPm15/bF0hrEmgUUHCR
        zYu63X/4PH+YQ/W1L4ZNeUzEsjd2KevSaw26+oWjmwULxlMRVC416rqNudhrRyiLsPtOeTs1be0bt
        2ThHGVYy67PLsHVjWTOhrEjCOsiLTc4+QUol1XPk3yoS2I9GWZHLxdLoTkz8VpOL90KhlrYkoqIgE
        VlXLq6aasjbKoocpeOgPIO+1a9VDvaKrDjw3WlrS9tp5QEhuMEdN/26h782IwtUnnbm2gDdP7GB6D
        AoZO7Ihw==;
Received: from [2a02:810d:9c0:47ac::c443] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k5AsJ-0002QK-0W; Mon, 10 Aug 2020 16:42:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] net: Revert "net: optimize the sockptr_t for unified kernel/user address spaces"
Date:   Mon, 10 Aug 2020 18:42:14 +0200
Message-Id: <20200810164214.9978-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commits 6d04fe15f78acdf8e32329e208552e226f7a8ae6 and
a31edb2059ed4e498f9aa8230c734b59d0ad797a.

It turns out the idea to share a single pointer for both kernel and user
space address causes various kinds of problems.  So use the slightly less
optimal version that uses an extra bit, but which is guaranteed to be safe
everywhere.

Fixes: 6d04fe15f78a ("net: optimize the sockptr_t for unified kernel/user address spaces")
Reported-by: Eric Dumazet <edumazet@google.com>
Reported-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/sockptr.h     | 26 ++------------------------
 net/ipv4/bpfilter/sockopt.c | 14 ++++++--------
 net/socket.c                |  6 +-----
 3 files changed, 9 insertions(+), 37 deletions(-)

diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index 96840def9d69cc..ea193414298b7f 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -8,26 +8,9 @@
 #ifndef _LINUX_SOCKPTR_H
 #define _LINUX_SOCKPTR_H
 
-#include <linux/compiler.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
-#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
-typedef union {
-	void		*kernel;
-	void __user	*user;
-} sockptr_t;
-
-static inline bool sockptr_is_kernel(sockptr_t sockptr)
-{
-	return (unsigned long)sockptr.kernel >= TASK_SIZE;
-}
-
-static inline sockptr_t KERNEL_SOCKPTR(void *p)
-{
-	return (sockptr_t) { .kernel = p };
-}
-#else /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
 typedef struct {
 	union {
 		void		*kernel;
@@ -45,15 +28,10 @@ static inline sockptr_t KERNEL_SOCKPTR(void *p)
 {
 	return (sockptr_t) { .kernel = p, .is_kernel = true };
 }
-#endif /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
 
-static inline int __must_check init_user_sockptr(sockptr_t *sp, void __user *p,
-		size_t size)
+static inline sockptr_t USER_SOCKPTR(void __user *p)
 {
-	if (!access_ok(p, size))
-		return -EFAULT;
-	*sp = (sockptr_t) { .user = p };
-	return 0;
+	return (sockptr_t) { .user = p };
 }
 
 static inline bool sockptr_is_null(sockptr_t sockptr)
diff --git a/net/ipv4/bpfilter/sockopt.c b/net/ipv4/bpfilter/sockopt.c
index 545b2640f0194d..1b34cb9a7708ec 100644
--- a/net/ipv4/bpfilter/sockopt.c
+++ b/net/ipv4/bpfilter/sockopt.c
@@ -57,18 +57,16 @@ int bpfilter_ip_set_sockopt(struct sock *sk, int optname, sockptr_t optval,
 	return bpfilter_mbox_request(sk, optname, optval, optlen, true);
 }
 
-int bpfilter_ip_get_sockopt(struct sock *sk, int optname,
-			    char __user *user_optval, int __user *optlen)
+int bpfilter_ip_get_sockopt(struct sock *sk, int optname, char __user *optval,
+			    int __user *optlen)
 {
-	sockptr_t optval;
-	int err, len;
+	int len;
 
 	if (get_user(len, optlen))
 		return -EFAULT;
-	err = init_user_sockptr(&optval, user_optval, len);
-	if (err)
-		return err;
-	return bpfilter_mbox_request(sk, optname, optval, len, false);
+
+	return bpfilter_mbox_request(sk, optname, USER_SOCKPTR(optval), len,
+				     false);
 }
 
 static int __init bpfilter_sockopt_init(void)
diff --git a/net/socket.c b/net/socket.c
index aff52e81653ce3..e44b8ac47f6f46 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2097,7 +2097,7 @@ static bool sock_use_custom_sol_socket(const struct socket *sock)
 int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
 		int optlen)
 {
-	sockptr_t optval;
+	sockptr_t optval = USER_SOCKPTR(user_optval);
 	char *kernel_optval = NULL;
 	int err, fput_needed;
 	struct socket *sock;
@@ -2105,10 +2105,6 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
 	if (optlen < 0)
 		return -EINVAL;
 
-	err = init_user_sockptr(&optval, user_optval, optlen);
-	if (err)
-		return err;
-
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		return err;
-- 
2.28.0

