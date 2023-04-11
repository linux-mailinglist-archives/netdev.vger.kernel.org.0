Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481A96DDAB7
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjDKM0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjDKM0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:26:33 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B2211707;
        Tue, 11 Apr 2023 05:26:31 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 419EFD75;
        Tue, 11 Apr 2023 05:27:15 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.65])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D1ECC3F6C4;
        Tue, 11 Apr 2023 05:26:29 -0700 (PDT)
From:   Kevin Brodsky <kevin.brodsky@arm.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: Finish up ->msg_control{,_user} split
Date:   Tue, 11 Apr 2023 13:26:25 +0100
Message-Id: <20230411122625.3902339-1-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 1f466e1f15cf ("net: cleanly handle kernel vs user buffers for
->msg_control") introduced the msg_control_user and
msg_control_is_user fields in struct msghdr to ensure user pointers
are represented as such. It also took care of converting most users
of struct msghdr::msg_control where user pointers are involved. It
did however miss a number of cases, and some code using msg_control
inappropriately has also appeared in the meantime.

This patch is attempting to complete the split. Most issues are about
msg_control being used when in fact a user pointer is stored in the
union; msg_control_user is now used instead. An exception is made
for null checks, as it should be safe to use msg_control
unconditionally for that purpose.

Additionally, a special situation in
cmsghdr_from_user_compat_to_kern() is addressed. There the input
struct msghdr holds a user pointer (msg_control_user), but a kernel
pointer is stored in msg_control when returning. msg_control_is_user
is now updated accordingly.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
Note: this issue was discovered during the porting of Linux on
Morello [1].

[1] https://git.morello-project.org/morello/kernel/linux

 net/compat.c             | 13 +++++++------
 net/core/scm.c           |  9 ++++++---
 net/ipv4/tcp.c           |  4 ++--
 net/ipv6/ipv6_sockglue.c |  1 +
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/net/compat.c b/net/compat.c
index 161b7bea1f62..6564720f32b7 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -113,7 +113,7 @@ int get_compat_msghdr(struct msghdr *kmsg,
 
 #define CMSG_COMPAT_FIRSTHDR(msg)			\
 	(((msg)->msg_controllen) >= sizeof(struct compat_cmsghdr) ?	\
-	 (struct compat_cmsghdr __user *)((msg)->msg_control) :		\
+	 (struct compat_cmsghdr __user *)((msg)->msg_control_user) :	\
 	 (struct compat_cmsghdr __user *)NULL)
 
 #define CMSG_COMPAT_OK(ucmlen, ucmsg, mhdr) \
@@ -126,7 +126,7 @@ static inline struct compat_cmsghdr __user *cmsg_compat_nxthdr(struct msghdr *ms
 		struct compat_cmsghdr __user *cmsg, int cmsg_len)
 {
 	char __user *ptr = (char __user *)cmsg + CMSG_COMPAT_ALIGN(cmsg_len);
-	if ((unsigned long)(ptr + 1 - (char __user *)msg->msg_control) >
+	if ((unsigned long)(ptr + 1 - (char __user *)msg->msg_control_user) >
 			msg->msg_controllen)
 		return NULL;
 	return (struct compat_cmsghdr __user *)ptr;
@@ -211,6 +211,7 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr *kmsg, struct sock *sk,
 		goto Einval;
 
 	/* Ok, looks like we made it.  Hook it up and return success. */
+	kmsg->msg_control_is_user = false;
 	kmsg->msg_control = kcmsg_base;
 	kmsg->msg_controllen = kcmlen;
 	return 0;
@@ -225,7 +226,7 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr *kmsg, struct sock *sk,
 
 int put_cmsg_compat(struct msghdr *kmsg, int level, int type, int len, void *data)
 {
-	struct compat_cmsghdr __user *cm = (struct compat_cmsghdr __user *) kmsg->msg_control;
+	struct compat_cmsghdr __user *cm = (struct compat_cmsghdr __user *) kmsg->msg_control_user;
 	struct compat_cmsghdr cmhdr;
 	struct old_timeval32 ctv;
 	struct old_timespec32 cts[3];
@@ -274,7 +275,7 @@ int put_cmsg_compat(struct msghdr *kmsg, int level, int type, int len, void *dat
 	cmlen = CMSG_COMPAT_SPACE(len);
 	if (kmsg->msg_controllen < cmlen)
 		cmlen = kmsg->msg_controllen;
-	kmsg->msg_control += cmlen;
+	kmsg->msg_control_user += cmlen;
 	kmsg->msg_controllen -= cmlen;
 	return 0;
 }
@@ -289,7 +290,7 @@ static int scm_max_fds_compat(struct msghdr *msg)
 void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
 {
 	struct compat_cmsghdr __user *cm =
-		(struct compat_cmsghdr __user *)msg->msg_control;
+		(struct compat_cmsghdr __user *)msg->msg_control_user;
 	unsigned int o_flags = (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_CLOEXEC : 0;
 	int fdmax = min_t(int, scm_max_fds_compat(msg), scm->fp->count);
 	int __user *cmsg_data = CMSG_COMPAT_DATA(cm);
@@ -313,7 +314,7 @@ void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
 			cmlen = CMSG_COMPAT_SPACE(i * sizeof(int));
 			if (msg->msg_controllen < cmlen)
 				cmlen = msg->msg_controllen;
-			msg->msg_control += cmlen;
+			msg->msg_control_user += cmlen;
 			msg->msg_controllen -= cmlen;
 		}
 	}
diff --git a/net/core/scm.c b/net/core/scm.c
index acb7d776fa6e..3cd7dd377e53 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -250,7 +250,10 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
 	}
 
 	cmlen = min(CMSG_SPACE(len), msg->msg_controllen);
-	msg->msg_control += cmlen;
+	if (msg->msg_control_is_user)
+		msg->msg_control_user += cmlen;
+	else
+		msg->msg_control += cmlen;
 	msg->msg_controllen -= cmlen;
 	return 0;
 
@@ -299,7 +302,7 @@ static int scm_max_fds(struct msghdr *msg)
 void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 {
 	struct cmsghdr __user *cm =
-		(__force struct cmsghdr __user *)msg->msg_control;
+		(__force struct cmsghdr __user *)msg->msg_control_user;
 	unsigned int o_flags = (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_CLOEXEC : 0;
 	int fdmax = min_t(int, scm_max_fds(msg), scm->fp->count);
 	int __user *cmsg_data = CMSG_USER_DATA(cm);
@@ -332,7 +335,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 			cmlen = CMSG_SPACE(i * sizeof(int));
 			if (msg->msg_controllen < cmlen)
 				cmlen = msg->msg_controllen;
-			msg->msg_control += cmlen;
+			msg->msg_control_user += cmlen;
 			msg->msg_controllen -= cmlen;
 		}
 	}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 288693981b00..6fa7a3fa9abd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2164,7 +2164,7 @@ static void tcp_zc_finalize_rx_tstamp(struct sock *sk,
 	struct msghdr cmsg_dummy;
 
 	msg_control_addr = (unsigned long)zc->msg_control;
-	cmsg_dummy.msg_control = (void *)msg_control_addr;
+	cmsg_dummy.msg_control_user = (void __user *)msg_control_addr;
 	cmsg_dummy.msg_controllen =
 		(__kernel_size_t)zc->msg_controllen;
 	cmsg_dummy.msg_flags = in_compat_syscall()
@@ -2175,7 +2175,7 @@ static void tcp_zc_finalize_rx_tstamp(struct sock *sk,
 	    zc->msg_controllen == cmsg_dummy.msg_controllen) {
 		tcp_recv_timestamp(&cmsg_dummy, sk, tss);
 		zc->msg_control = (__u64)
-			((uintptr_t)cmsg_dummy.msg_control);
+			((uintptr_t)cmsg_dummy.msg_control_user);
 		zc->msg_controllen =
 			(__u64)cmsg_dummy.msg_controllen;
 		zc->msg_flags = (__u32)cmsg_dummy.msg_flags;
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 2917dd8d198c..ae818ff46224 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -716,6 +716,7 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 			goto done;
 
 		msg.msg_controllen = optlen;
+		msg.msg_control_is_user = false;
 		msg.msg_control = (void *)(opt+1);
 		ipc6.opt = opt;
 
-- 
2.38.1

