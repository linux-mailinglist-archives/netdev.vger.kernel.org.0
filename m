Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253C31F4CA0
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 06:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgFJEwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 00:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgFJEw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 00:52:29 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E33C08C5C4
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 21:52:28 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d66so565667pfd.6
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 21:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IpKTUi8zMT5mefEhrEzwZrhQaGIJc3HKN7JY2SE/kS8=;
        b=FMBc5emJpAkGHMWOKVOtDAmQj3qbqZAfXR2heIFezQ4IbPfJTDTryOUpws/u9JUR6g
         SgnwRfSwlB5VgJZvdi6pkpvjgaIhtbj5AOVwJ+qalxO9pX3W8sq5r9PSDO8e8F7CFCJY
         fyM3DTGdCMTgFlQH0fDiMjjep4C4ZoEc8ys44=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IpKTUi8zMT5mefEhrEzwZrhQaGIJc3HKN7JY2SE/kS8=;
        b=ExHErvsDfD1UOASGR3ul6CtB92GICvAPX4U8hZfLQ8RyCE+gmqNvcb723mU2ix9098
         2o5PIWy3eWFF+SHyz2DR+nR0uv509O36EYXn4V2hcitzomhtyic564PPFQ7T/NpoGoX6
         JAqDDQpbNXEiwz2Jan8sCEO/JhlUd2CbHxVNPEsJaaDBnZaWs51lJYFiNwRYqtOsQQbN
         VAG7FSWd9Z6TJMElBN2TJbffILbU6G4+fAoqK3PexyyuslS5sYm7VX/vz3VNLw9uWw+h
         xPInIVTXsSF77v5GxluZ9ZkDzyEoPWpOVzCzYCHGfz/ll4vOuWUA53ZDAqD+RR0MSVva
         sztg==
X-Gm-Message-State: AOAM5310JFIf215D1fPJq8Htf48fqrdEz4DyOgSfNrwoowUtyyV3k+Bz
        JBhJHrT9J7LMD/KkS0tAAJhUfQ==
X-Google-Smtp-Source: ABdhPJzH5vemnILm8vb66u6LiVfNO2Kf1NJ55FLIWgHE0qYp6ixujlGcGAhYweNUyYvFE2aeRXVBgQ==
X-Received: by 2002:aa7:82cb:: with SMTP id f11mr1094677pfn.81.1591764747473;
        Tue, 09 Jun 2020 21:52:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 10sm11286258pfn.6.2020.06.09.21.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 21:52:25 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian@brauner.io>,
        Sargun Dhillon <sargun@sargun.me>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net/scm: Regularize compat handling of scm_detach_fds()
Date:   Tue,  9 Jun 2020 21:52:13 -0700
Message-Id: <20200610045214.1175600-2-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200610045214.1175600-1-keescook@chromium.org>
References: <20200610045214.1175600-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Duplicate the cleanups from commit 2618d530dd8b ("net/scm: cleanup
scm_detach_fds") into the compat code.

Also moves the check added in commit 1f466e1f15cf ("net: cleanly handle
kernel vs user buffers for ->msg_control") to before the compat call, even
though it should be impossible for an in-kernel call to also be compat.

Regularized any remaining differences, including a whitespace issue, a
checkpatch warning, and adding the check from commit 6900317f5eff ("net,
scm: fix PaX detected msg_controllen overflow in scm_detach_fds") which
fixed an overflow unique to 64-bit. To avoid confusion when comparing
the compat handler to the native handler, just include the same check
in the compat handler.

Fixes: 48a87cc26c13 ("net: netprio: fd passed in SCM_RIGHTS datagram not set correctly")
Fixes: d84295067fc7 ("net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly")
Signed-off-by: Kees Cook <keescook@chromium.org>
---
AFAICT, the following patches are needed for back-porting this to stable:

0462b6bdb644 ("net: add a CMSG_USER_DATA macro")
2618d530dd8b ("net/scm: cleanup scm_detach_fds")
1f466e1f15cf ("net: cleanly handle kernel vs user buffers for ->msg_control")
6e8a4f9dda38 ("net: ignore sock_from_file errors in __scm_install_fd")
---
 include/net/scm.h |  1 +
 net/compat.c      | 55 +++++++++++++++++++++--------------------------
 net/core/scm.c    | 16 +++++++-------
 3 files changed, 34 insertions(+), 38 deletions(-)

diff --git a/include/net/scm.h b/include/net/scm.h
index 1ce365f4c256..4dcc766f15b3 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -37,6 +37,7 @@ struct scm_cookie {
 #endif
 };
 
+int __scm_install_fd(struct file *file, int __user *ufd, int o_flags);
 void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm);
 void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm);
 int __scm_send(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm);
diff --git a/net/compat.c b/net/compat.c
index 5e3041a2c37d..117f1869bf3b 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -281,39 +281,31 @@ int put_cmsg_compat(struct msghdr *kmsg, int level, int type, int len, void *dat
 	return 0;
 }
 
-void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
+static int scm_max_fds_compat(struct msghdr *msg)
 {
-	struct compat_cmsghdr __user *cm = (struct compat_cmsghdr __user *) kmsg->msg_control;
-	int fdmax = (kmsg->msg_controllen - sizeof(struct compat_cmsghdr)) / sizeof(int);
-	int fdnum = scm->fp->count;
-	struct file **fp = scm->fp->fp;
-	int __user *cmfptr;
-	int err = 0, i;
+	if (msg->msg_controllen <= sizeof(struct compat_cmsghdr))
+		return 0;
+	return (msg->msg_controllen - sizeof(struct compat_cmsghdr)) / sizeof(int);
+}
 
-	if (fdnum < fdmax)
-		fdmax = fdnum;
+void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
+{
+	struct compat_cmsghdr __user *cm =
+		(struct compat_cmsghdr __user *)msg->msg_control;
+	int o_flags = (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_CLOEXEC : 0;
+	int fdmax = min_t(int, scm_max_fds_compat(msg), scm->fp->count);
+	int __user *cmsg_data = CMSG_USER_DATA(cm);
+	int err = 0, i;
 
-	for (i = 0, cmfptr = (int __user *) CMSG_COMPAT_DATA(cm); i < fdmax; i++, cmfptr++) {
-		int new_fd;
-		err = security_file_receive(fp[i]);
+	for (i = 0; i < fdmax; i++) {
+		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
 		if (err)
 			break;
-		err = get_unused_fd_flags(MSG_CMSG_CLOEXEC & kmsg->msg_flags
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
-		fd_install(new_fd, get_file(fp[i]));
 	}
 
 	if (i > 0) {
 		int cmlen = CMSG_COMPAT_LEN(i * sizeof(int));
+
 		err = put_user(SOL_SOCKET, &cm->cmsg_level);
 		if (!err)
 			err = put_user(SCM_RIGHTS, &cm->cmsg_type);
@@ -321,16 +313,19 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
 			err = put_user(cmlen, &cm->cmsg_len);
 		if (!err) {
 			cmlen = CMSG_COMPAT_SPACE(i * sizeof(int));
-			kmsg->msg_control += cmlen;
-			kmsg->msg_controllen -= cmlen;
+			if (msg->msg_controllen < cmlen)
+				cmlen = msg->msg_controllen;
+			msg->msg_control += cmlen;
+			msg->msg_controllen -= cmlen;
 		}
 	}
-	if (i < fdnum)
-		kmsg->msg_flags |= MSG_CTRUNC;
+
+	if (i < scm->fp->count || (scm->fp->count && fdmax <= 0))
+		msg->msg_flags |= MSG_CTRUNC;
 
 	/*
-	 * All of the files that fit in the message have had their
-	 * usage counts incremented, so we just free the list.
+	 * All of the files that fit in the message have had their usage counts
+	 * incremented, so we just free the list.
 	 */
 	__scm_destroy(scm);
 }
diff --git a/net/core/scm.c b/net/core/scm.c
index 875df1c2989d..86d96152646f 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -280,7 +280,7 @@ void put_cmsg_scm_timestamping(struct msghdr *msg, struct scm_timestamping_inter
 }
 EXPORT_SYMBOL(put_cmsg_scm_timestamping);
 
-static int __scm_install_fd(struct file *file, int __user *ufd, int o_flags)
+int __scm_install_fd(struct file *file, int __user *ufd, int o_flags)
 {
 	struct socket *sock;
 	int new_fd;
@@ -319,29 +319,29 @@ static int scm_max_fds(struct msghdr *msg)
 
 void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 {
-	struct cmsghdr __user *cm
-		= (__force struct cmsghdr __user*)msg->msg_control;
+	struct cmsghdr __user *cm =
+		(__force struct cmsghdr __user*)msg->msg_control;
 	int o_flags = (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_CLOEXEC : 0;
 	int fdmax = min_t(int, scm_max_fds(msg), scm->fp->count);
 	int __user *cmsg_data = CMSG_USER_DATA(cm);
 	int err = 0, i;
 
+	/* no use for FD passing from kernel space callers */
+	if (WARN_ON_ONCE(!msg->msg_control_is_user))
+		return;
+
 	if (msg->msg_flags & MSG_CMSG_COMPAT) {
 		scm_detach_fds_compat(msg, scm);
 		return;
 	}
 
-	/* no use for FD passing from kernel space callers */
-	if (WARN_ON_ONCE(!msg->msg_control_is_user))
-		return;
-
 	for (i = 0; i < fdmax; i++) {
 		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
 		if (err)
 			break;
 	}
 
-	if (i > 0)  {
+	if (i > 0) {
 		int cmlen = CMSG_LEN(i * sizeof(int));
 
 		err = put_user(SOL_SOCKET, &cm->cmsg_level);
-- 
2.25.1

