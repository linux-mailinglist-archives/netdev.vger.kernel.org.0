Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519661CD932
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgEKL7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 07:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729680AbgEKL7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 07:59:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA3CC061A0C;
        Mon, 11 May 2020 04:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=uRorWmjDh2u9B9We3v9BbbBR+7nfbQ1nnHrY1zlliV4=; b=Y4LeXXEiOkgV4G0f6dFcjoINw7
        pGV0LUx/72qNLNvIUlPj+U+wnUbpC/mh+a4n00JCvbaoBbF7D/vGJPlqCTa2F4bI6Z1u6KgsaST+b
        3E0zhroVS92SX/ShM89H2Lt26IORGxshU15vhFozhXr+IUINEo84fKfyPrcM4ZeYnnBF4WNgwSJ7F
        iJI3RWCkpVuoMw7tgyN5HsBkAX6IEefwBo4DGQCRkFPu1sdD2qZhN/y0DlfnwLr8dGUZCLiPZ1qhr
        S3Mwn4/CY9r0JDtdFAdtggX/PvCBZ3Y8vYKgAwkOdOxNSVCM5gh3Kp/7mzzDnHLs2ydMQ693g8KUC
        L/z+jvyQ==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jY75d-0007Tf-76; Mon, 11 May 2020 11:59:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] net/scm: cleanup scm_detach_fds
Date:   Mon, 11 May 2020 13:59:12 +0200
Message-Id: <20200511115913.1420836-3-hch@lst.de>
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

Factor out two helpes to keep the code tidy.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/core/scm.c | 94 +++++++++++++++++++++++++++-----------------------
 1 file changed, 51 insertions(+), 43 deletions(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index abfdc85a64c1b..168b006a52ff9 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -277,78 +277,86 @@ void put_cmsg_scm_timestamping(struct msghdr *msg, struct scm_timestamping_inter
 }
 EXPORT_SYMBOL(put_cmsg_scm_timestamping);
 
+static int __scm_install_fd(struct file *file, int __user *ufd, int o_flags)
+{
+	struct socket *sock;
+	int new_fd;
+	int error;
+
+	error = security_file_receive(file);
+	if (error)
+		return error;
+
+	new_fd = get_unused_fd_flags(o_flags);
+	if (new_fd < 0)
+		return new_fd;
+
+	error = put_user(new_fd, ufd);
+	if (error) {
+		put_unused_fd(new_fd);
+		return error;
+	}
+
+	/* Bump the usage count and install the file. */
+	sock = sock_from_file(file, &error);
+	if (sock) {
+		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
+		sock_update_classid(&sock->sk->sk_cgrp_data);
+	}
+	fd_install(new_fd, get_file(file));
+	return error;
+}
+
+static int scm_max_fds(struct msghdr *msg)
+{
+	if (msg->msg_controllen <= sizeof(struct cmsghdr))
+		return 0;
+	return (msg->msg_controllen - sizeof(struct cmsghdr)) / sizeof(int);
+}
+
 void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 {
 	struct cmsghdr __user *cm
 		= (__force struct cmsghdr __user*)msg->msg_control;
-
-	int fdmax = 0;
-	int fdnum = scm->fp->count;
-	struct file **fp = scm->fp->fp;
-	int __user *cmfptr;
+	int o_flags = (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_CLOEXEC : 0;
+	int fdmax = min_t(int, scm_max_fds(msg), scm->fp->count);
+	int __user *cmsg_data = CMSG_USER_DATA(cm);
 	int err = 0, i;
 
-	if (MSG_CMSG_COMPAT & msg->msg_flags) {
+	if (msg->msg_flags & MSG_CMSG_COMPAT) {
 		scm_detach_fds_compat(msg, scm);
 		return;
 	}
 
-	if (msg->msg_controllen > sizeof(struct cmsghdr))
-		fdmax = ((msg->msg_controllen - sizeof(struct cmsghdr))
-			 / sizeof(int));
-
-	if (fdnum < fdmax)
-		fdmax = fdnum;
-
-	for (i=0, cmfptr =(int __user *)CMSG_USER_DATA(cm); i<fdmax;
-	     i++, cmfptr++)
-	{
-		struct socket *sock;
-		int new_fd;
-		err = security_file_receive(fp[i]);
+	for (i = 0; i < fdmax; i++) {
+		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
 		if (err)
 			break;
-		err = get_unused_fd_flags(MSG_CMSG_CLOEXEC & msg->msg_flags
-					  ? O_CLOEXEC : 0);
-		if (err < 0)
-			break;
-		new_fd = err;
-		err = put_user(new_fd, cmfptr);
-		if (err) {
-			put_unused_fd(new_fd);
-			break;
-		}
-		/* Bump the usage count and install the file. */
-		sock = sock_from_file(fp[i], &err);
-		if (sock) {
-			sock_update_netprioidx(&sock->sk->sk_cgrp_data);
-			sock_update_classid(&sock->sk->sk_cgrp_data);
-		}
-		fd_install(new_fd, get_file(fp[i]));
 	}
 
-	if (i > 0)
-	{
-		int cmlen = CMSG_LEN(i*sizeof(int));
+	if (i > 0)  {
+		int cmlen = CMSG_LEN(i * sizeof(int));
+
 		err = put_user(SOL_SOCKET, &cm->cmsg_level);
 		if (!err)
 			err = put_user(SCM_RIGHTS, &cm->cmsg_type);
 		if (!err)
 			err = put_user(cmlen, &cm->cmsg_len);
 		if (!err) {
-			cmlen = CMSG_SPACE(i*sizeof(int));
+			cmlen = CMSG_SPACE(i * sizeof(int));
 			if (msg->msg_controllen < cmlen)
 				cmlen = msg->msg_controllen;
 			msg->msg_control += cmlen;
 			msg->msg_controllen -= cmlen;
 		}
 	}
-	if (i < fdnum || (fdnum && fdmax <= 0))
+
+	if (i < scm->fp->count || (scm->fp->count && fdmax <= 0))
 		msg->msg_flags |= MSG_CTRUNC;
 
 	/*
-	 * All of the files that fit in the message have had their
-	 * usage counts incremented, so we just free the list.
+	 * All of the files that fit in the message have had their usage counts
+	 * incremented, so we just free the list.
 	 */
 	__scm_destroy(scm);
 }
-- 
2.26.2

