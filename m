Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B2C23E7C9
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 09:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgHGHT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 03:19:57 -0400
Received: from verein.lst.de ([213.95.11.211]:52834 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGHT5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 03:19:57 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 889B368D0E; Fri,  7 Aug 2020 09:19:54 +0200 (CEST)
Date:   Fri, 7 Aug 2020 09:19:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     John Stultz <john.stultz@linaro.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Todd Kjos <tkjos@google.com>,
        Amit Pundir <amit.pundir@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [GIT] Networking
Message-ID: <20200807071954.GA2086@lst.de>
References: <20200805.185559.1225246192723680518.davem@davemloft.net> <CANcMJZA1pSz8T9gkRtwYHy_vVfoMj35Wd-+qqxQBg+GRaXS0_Q@mail.gmail.com> <011a0a3b-74ac-fa61-2a04-73cb9897e8e8@gmail.com> <CALAqxLVDyTygzoktGK+aYnT2dQdOTPFAD=P=Kr1x+TmLuUC=NA@mail.gmail.com> <CALAqxLWKGfoPya3u9pbvZcbMAhjXKmYvp8b6L7hpk4bNWyt7sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLWKGfoPya3u9pbvZcbMAhjXKmYvp8b6L7hpk4bNWyt7sQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 06, 2020 at 11:23:34PM -0700, John Stultz wrote:
> So I've finally rebase-bisected it down to:
>   a31edb2059ed ("net: improve the user pointer check in init_user_sockptr")
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a31edb2059ed4e498f9aa8230c734b59d0ad797a
> 
> And reverting that from linus/HEAD (at least from this morning) seems
> to avoid it.
> 
> Seems like it is just adding extra checks on the data passed, so maybe
> existing trouble from a different driver is the issue here, but it's
> not really clear from the crash what might be wrong.
> 
> Suggestions would be greatly appreciated!

I think the sockpt optimization is just a little to clever for its
own sake, as also chown by the other issue pointed out by Eric.

Can you try this revert that just goes back to the "boring" normal
version for everyone?

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
