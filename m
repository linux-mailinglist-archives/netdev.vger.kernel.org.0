Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9931CD927
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 13:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgEKL71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 07:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729929AbgEKL7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 07:59:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755D0C061A0C;
        Mon, 11 May 2020 04:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=m94XuRcPv1h4PkxYfvbvIiaz8xMqDRyYdvoeP4c3fSY=; b=IsCYnqZDtISOoknv9P4QglPfk1
        AI8yy9UDLew+7Wt1YwacerYdzYWBWtLdya1s/3LMZIr5GQhiIy1x22JmeWuc57QYAqIZaNuXoS5Rs
        ZMgwZhMJ8lUqjgNAeHISyyWlMJ/Z7OKNr7wAqQe4Bt1cKR5bYe+6drANPiC+Q76/AG823fKcdS2iK
        He++NCfpooVK8cJ2RmH+271aAiHhJenz7+ziViF/cYTaSL73UuZa6F09X9wa284KEqnlu8sgVrk36
        yWDdwMRGbIPCO6+jeMLQXywRzYLtYEmLrT+e2f8L7Z2rkV1Cjw1kmeWdItc3H0sf3wjUywjeuFKeS
        buPdOgNA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jY75f-0007U6-PV; Mon, 11 May 2020 11:59:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] net: cleanly handle kernel vs user buffers for ->msg_control
Date:   Mon, 11 May 2020 13:59:13 +0200
Message-Id: <20200511115913.1420836-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511115913.1420836-1-hch@lst.de>
References: <20200511115913.1420836-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The msg_control field in struct msghdr can either contain a user
pointer when used with the recvmsg system call, or a kernel pointer
when used with sendmsg.  To complicate things further kernel_recvmsg
can stuff a kernel pointer in and then use set_fs to make the uaccess
helpers accept it.

Replace it with a union of a kernel pointer msg_control field, and
a user pointer msg_control_user one, and allow kernel_recvmsg operate
on a proper kernel pointer using a bitfield to override the normal
choice of a user pointer for recvmsg.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/socket.h | 12 ++++++++++-
 net/compat.c           |  5 +++--
 net/core/scm.c         | 49 ++++++++++++++++++++++++------------------
 net/ipv4/ip_sockglue.c |  3 ++-
 net/socket.c           | 22 ++++++-------------
 5 files changed, 50 insertions(+), 41 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 4cc64d611cf49..04d2bc97f497d 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -50,7 +50,17 @@ struct msghdr {
 	void		*msg_name;	/* ptr to socket address structure */
 	int		msg_namelen;	/* size of socket address structure */
 	struct iov_iter	msg_iter;	/* data */
-	void		*msg_control;	/* ancillary data */
+
+	/*
+	 * Ancillary data. msg_control_user is the user buffer used for the
+	 * recv* side when msg_control_is_user is set, msg_control is the kernel
+	 * buffer used for all other cases.
+	 */
+	union {
+		void		*msg_control;
+		void __user	*msg_control_user;
+	};
+	bool		msg_control_is_user : 1;
 	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
 	unsigned int	msg_flags;	/* flags on received message */
 	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
diff --git a/net/compat.c b/net/compat.c
index 4bed96e84d9a6..69fc6d1e4e6e9 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -56,7 +56,8 @@ int __get_compat_msghdr(struct msghdr *kmsg,
 	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
 		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
 
-	kmsg->msg_control = compat_ptr(msg.msg_control);
+	kmsg->msg_control_is_user = true;
+	kmsg->msg_control_user = compat_ptr(msg.msg_control);
 	kmsg->msg_controllen = msg.msg_controllen;
 
 	if (save_addr)
@@ -121,7 +122,7 @@ int get_compat_msghdr(struct msghdr *kmsg,
 	((ucmlen) >= sizeof(struct compat_cmsghdr) && \
 	 (ucmlen) <= (unsigned long) \
 	 ((mhdr)->msg_controllen - \
-	  ((char *)(ucmsg) - (char *)(mhdr)->msg_control)))
+	  ((char __user *)(ucmsg) - (char __user *)(mhdr)->msg_control_user)))
 
 static inline struct compat_cmsghdr __user *cmsg_compat_nxthdr(struct msghdr *msg,
 		struct compat_cmsghdr __user *cmsg, int cmsg_len)
diff --git a/net/core/scm.c b/net/core/scm.c
index 168b006a52ff9..a75cd637a71ff 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -212,16 +212,12 @@ EXPORT_SYMBOL(__scm_send);
 
 int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
 {
-	struct cmsghdr __user *cm
-		= (__force struct cmsghdr __user *)msg->msg_control;
-	struct cmsghdr cmhdr;
 	int cmlen = CMSG_LEN(len);
-	int err;
 
-	if (MSG_CMSG_COMPAT & msg->msg_flags)
+	if (msg->msg_flags & MSG_CMSG_COMPAT)
 		return put_cmsg_compat(msg, level, type, len, data);
 
-	if (cm==NULL || msg->msg_controllen < sizeof(*cm)) {
+	if (!msg->msg_control || msg->msg_controllen < sizeof(struct cmsghdr)) {
 		msg->msg_flags |= MSG_CTRUNC;
 		return 0; /* XXX: return error? check spec. */
 	}
@@ -229,23 +225,30 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
 		msg->msg_flags |= MSG_CTRUNC;
 		cmlen = msg->msg_controllen;
 	}
-	cmhdr.cmsg_level = level;
-	cmhdr.cmsg_type = type;
-	cmhdr.cmsg_len = cmlen;
-
-	err = -EFAULT;
-	if (copy_to_user(cm, &cmhdr, sizeof cmhdr))
-		goto out;
-	if (copy_to_user(CMSG_USER_DATA(cm), data, cmlen - sizeof(*cm)))
-		goto out;
-	cmlen = CMSG_SPACE(len);
-	if (msg->msg_controllen < cmlen)
-		cmlen = msg->msg_controllen;
+
+	if (msg->msg_control_is_user) {
+		struct cmsghdr __user *cm = msg->msg_control_user;
+		struct cmsghdr cmhdr;
+
+		cmhdr.cmsg_level = level;
+		cmhdr.cmsg_type = type;
+		cmhdr.cmsg_len = cmlen;
+		if (copy_to_user(cm, &cmhdr, sizeof cmhdr) ||
+		    copy_to_user(CMSG_USER_DATA(cm), data, cmlen - sizeof(*cm)))
+			return -EFAULT;
+	} else {
+		struct cmsghdr *cm = msg->msg_control;
+
+		cm->cmsg_level = level;
+		cm->cmsg_type = type;
+		cm->cmsg_len = cmlen;
+		memcpy(CMSG_DATA(cm), data, cmlen - sizeof(*cm));
+	}
+
+	cmlen = min(CMSG_SPACE(len), msg->msg_controllen);
 	msg->msg_control += cmlen;
 	msg->msg_controllen -= cmlen;
-	err = 0;
-out:
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL(put_cmsg);
 
@@ -328,6 +331,10 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 		return;
 	}
 
+	/* no use for FD passing from kernel space callers */
+	if (WARN_ON_ONCE(!msg->msg_control_is_user))
+		return;
+
 	for (i = 0; i < fdmax; i++) {
 		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
 		if (err)
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index aa3fd61818c47..8206047d70b6b 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1492,7 +1492,8 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
 		if (sk->sk_type != SOCK_STREAM)
 			return -ENOPROTOOPT;
 
-		msg.msg_control = (__force void *) optval;
+		msg.msg_control_is_user = true;
+		msg.msg_control_user = optval;
 		msg.msg_controllen = len;
 		msg.msg_flags = flags;
 
diff --git a/net/socket.c b/net/socket.c
index 2dd739fba866e..1c9a7260a41de 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -924,14 +924,9 @@ EXPORT_SYMBOL(sock_recvmsg);
 int kernel_recvmsg(struct socket *sock, struct msghdr *msg,
 		   struct kvec *vec, size_t num, size_t size, int flags)
 {
-	mm_segment_t oldfs = get_fs();
-	int result;
-
+	msg->msg_control_is_user = false;
 	iov_iter_kvec(&msg->msg_iter, READ, vec, num, size);
-	set_fs(KERNEL_DS);
-	result = sock_recvmsg(sock, msg, flags);
-	set_fs(oldfs);
-	return result;
+	return sock_recvmsg(sock, msg, flags);
 }
 EXPORT_SYMBOL(kernel_recvmsg);
 
@@ -2239,7 +2234,8 @@ int __copy_msghdr_from_user(struct msghdr *kmsg,
 	if (copy_from_user(&msg, umsg, sizeof(*umsg)))
 		return -EFAULT;
 
-	kmsg->msg_control = (void __force *)msg.msg_control;
+	kmsg->msg_control_is_user = true;
+	kmsg->msg_control_user = msg.msg_control;
 	kmsg->msg_controllen = msg.msg_controllen;
 	kmsg->msg_flags = msg.msg_flags;
 
@@ -2331,16 +2327,10 @@ static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
 				goto out;
 		}
 		err = -EFAULT;
-		/*
-		 * Careful! Before this, msg_sys->msg_control contains a user pointer.
-		 * Afterwards, it will be a kernel pointer. Thus the compiler-assisted
-		 * checking falls down on this.
-		 */
-		if (copy_from_user(ctl_buf,
-				   (void __user __force *)msg_sys->msg_control,
-				   ctl_len))
+		if (copy_from_user(ctl_buf, msg_sys->msg_control_user, ctl_len))
 			goto out_freectl;
 		msg_sys->msg_control = ctl_buf;
+		msg_sys->msg_control_is_user = false;
 	}
 	msg_sys->msg_flags = flags;
 
-- 
2.26.2

