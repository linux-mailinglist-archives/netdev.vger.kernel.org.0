Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A536E0D01
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 13:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjDMLsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 07:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjDMLr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 07:47:58 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AA60AD09;
        Thu, 13 Apr 2023 04:47:34 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7EC3211FB;
        Thu, 13 Apr 2023 04:48:03 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.65])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0E2C93F73F;
        Thu, 13 Apr 2023 04:47:17 -0700 (PDT)
From:   Kevin Brodsky <kevin.brodsky@arm.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 1/3] net: Ensure ->msg_control_user is used for user buffers
Date:   Thu, 13 Apr 2023 12:47:03 +0100
Message-Id: <20230413114705.157046-2-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230413114705.157046-1-kevin.brodsky@arm.com>
References: <20230413114705.157046-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 1f466e1f15cf ("net: cleanly handle kernel vs user
buffers for ->msg_control"), pointers to user buffers should be
stored in struct msghdr::msg_control_user, instead of the
msg_control field.  Most users of msg_control have already been
converted (where user buffers are involved), but not all of them.

This patch attempts to address the remaining cases. An exception is
made for null checks, as it should be safe to use msg_control
unconditionally for that purpose.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 net/compat.c   | 12 ++++++------
 net/core/scm.c |  9 ++++++---
 net/ipv4/tcp.c |  4 ++--
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/net/compat.c b/net/compat.c
index 161b7bea1f62..000a2e054d4c 100644
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
@@ -225,7 +225,7 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr *kmsg, struct sock *sk,
 
 int put_cmsg_compat(struct msghdr *kmsg, int level, int type, int len, void *data)
 {
-	struct compat_cmsghdr __user *cm = (struct compat_cmsghdr __user *) kmsg->msg_control;
+	struct compat_cmsghdr __user *cm = (struct compat_cmsghdr __user *) kmsg->msg_control_user;
 	struct compat_cmsghdr cmhdr;
 	struct old_timeval32 ctv;
 	struct old_timespec32 cts[3];
@@ -274,7 +274,7 @@ int put_cmsg_compat(struct msghdr *kmsg, int level, int type, int len, void *dat
 	cmlen = CMSG_COMPAT_SPACE(len);
 	if (kmsg->msg_controllen < cmlen)
 		cmlen = kmsg->msg_controllen;
-	kmsg->msg_control += cmlen;
+	kmsg->msg_control_user += cmlen;
 	kmsg->msg_controllen -= cmlen;
 	return 0;
 }
@@ -289,7 +289,7 @@ static int scm_max_fds_compat(struct msghdr *msg)
 void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
 {
 	struct compat_cmsghdr __user *cm =
-		(struct compat_cmsghdr __user *)msg->msg_control;
+		(struct compat_cmsghdr __user *)msg->msg_control_user;
 	unsigned int o_flags = (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_CLOEXEC : 0;
 	int fdmax = min_t(int, scm_max_fds_compat(msg), scm->fp->count);
 	int __user *cmsg_data = CMSG_COMPAT_DATA(cm);
@@ -313,7 +313,7 @@ void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
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
-- 
2.38.1

