Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0F8212D8C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 22:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgGBUDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 16:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGBUDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 16:03:35 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5401DC08C5C1;
        Thu,  2 Jul 2020 13:03:35 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id g17so11712632plq.12;
        Thu, 02 Jul 2020 13:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oYEQw5sK91IXtBQJhGPBbECumskzywdPa6a9TiRo08Y=;
        b=gpVYU2zxRA3BeLZPFUv1I5vddX0zdy+pXeGZYHnTnOwoKZ18Zvp0D7HvnWWq12jti5
         qUWkipdeD/TBMoH5Ud8CiNaiqLn0J27oIFaAFgdb+Ai/eXHwkWTttiLJRW/fdm+1/0JH
         OVU0j0hqr5uUBgq8xNKGKRG4JSIjkjrcvxhKjbBAE55GG/uofEUpj357VrYlnSsAMW/p
         e2fBSw/bviJ1BIa9//q6iWNbQ8/37NIrxfZJXRo9mw/qcAJuUQ7zch3dX2a6425mK5Ns
         JSCXxRRZkGPmjRBsXY9v0gOPuJF5BzouKPkZtcL1zXxEk4OmKOk3LaFcNkI2gItKQ6QT
         V3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oYEQw5sK91IXtBQJhGPBbECumskzywdPa6a9TiRo08Y=;
        b=Xa+xngp9OtB4T0lSWnaWyljZzuKy0GfBdD8RGWy500wZtBWPiwOPuD2f3JMG8UP2JH
         kmnaLZ8bNFEd4ATUl+EwRm2etMf/3ax+/yKe4Kbg65qGQqRXpvcyhnoE1lifS8nDinpl
         DLJ7Dv4n0MNIQNuTGXYtTltKadpSgH6DWdNlhBlIdWjYEnBJ62MHdConETKm+ZrUxA14
         5sN2MCe/OFka05Y+X6KNAvbnBMJOJD9zRXidWf40HikVrrficJkVlMuQhJfks8XuLtKQ
         dAHVCX5HiyYtzJBiUyiRsdcAq3esbG4iOjDnRs5XiuGbDd3KOg4tgjZKX51CBuCQHQbQ
         EKOQ==
X-Gm-Message-State: AOAM5305lv6BFRErG6q6xlNJHqmGl6bIp4Ep+sohWyHF0w/PQIubSGAt
        3StolHR94m/+n44ncvA2veI=
X-Google-Smtp-Source: ABdhPJy4+9Pqz4N9YkVjoQ2y6PfVNg28vAjnQvxgMrQTMF9sIfJJsLII5yny7CWLAWeMCx9FyT+EDg==
X-Received: by 2002:a17:90a:9c9:: with SMTP id 67mr35874713pjo.196.1593720214835;
        Thu, 02 Jul 2020 13:03:34 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id 83sm9663466pfu.60.2020.07.02.13.03.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jul 2020 13:03:34 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     davem@davemloft.net, daniel@iogearbox.net, ebiederm@xmission.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 1/3] bpf: Factor out bpf_link_get_by_id() helper.
Date:   Thu,  2 Jul 2020 13:03:27 -0700
Message-Id: <20200702200329.83224-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200702200329.83224-1-alexei.starovoitov@gmail.com>
References: <20200702200329.83224-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Refactor the code a bit to extract bpf_link_get_by_id() helper.
It's similar to existing bpf_prog_by_id().

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h  |  1 +
 kernel/bpf/syscall.c | 46 +++++++++++++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3c659f36591d..4fcff4895f27 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1319,6 +1319,7 @@ int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
 			 struct btf *btf, const struct btf_type *t);
 
 struct bpf_prog *bpf_prog_by_id(u32 id);
+struct bpf_link *bpf_link_by_id(u32 id);
 
 const struct bpf_func_proto *bpf_base_func_proto(enum bpf_func_id func_id);
 #else /* !CONFIG_BPF_SYSCALL */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e236a6c0aea4..a2ce46f4a987 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3969,40 +3969,50 @@ static int link_update(union bpf_attr *attr)
 	return ret;
 }
 
-static int bpf_link_inc_not_zero(struct bpf_link *link)
+static struct bpf_link *bpf_link_inc_not_zero(struct bpf_link *link)
 {
-	return atomic64_fetch_add_unless(&link->refcnt, 1, 0) ? 0 : -ENOENT;
+	return atomic64_fetch_add_unless(&link->refcnt, 1, 0) ? link : ERR_PTR(-ENOENT);
 }
 
-#define BPF_LINK_GET_FD_BY_ID_LAST_FIELD link_id
-
-static int bpf_link_get_fd_by_id(const union bpf_attr *attr)
+struct bpf_link *bpf_link_by_id(u32 id)
 {
 	struct bpf_link *link;
-	u32 id = attr->link_id;
-	int fd, err;
 
-	if (CHECK_ATTR(BPF_LINK_GET_FD_BY_ID))
-		return -EINVAL;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
+	if (!id)
+		return ERR_PTR(-ENOENT);
 
 	spin_lock_bh(&link_idr_lock);
-	link = idr_find(&link_idr, id);
 	/* before link is "settled", ID is 0, pretend it doesn't exist yet */
+	link = idr_find(&link_idr, id);
 	if (link) {
 		if (link->id)
-			err = bpf_link_inc_not_zero(link);
+			link = bpf_link_inc_not_zero(link);
 		else
-			err = -EAGAIN;
+			link = ERR_PTR(-EAGAIN);
 	} else {
-		err = -ENOENT;
+		link = ERR_PTR(-ENOENT);
 	}
 	spin_unlock_bh(&link_idr_lock);
+	return link;
+}
 
-	if (err)
-		return err;
+#define BPF_LINK_GET_FD_BY_ID_LAST_FIELD link_id
+
+static int bpf_link_get_fd_by_id(const union bpf_attr *attr)
+{
+	struct bpf_link *link;
+	u32 id = attr->link_id;
+	int fd;
+
+	if (CHECK_ATTR(BPF_LINK_GET_FD_BY_ID))
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	link = bpf_link_by_id(id);
+	if (IS_ERR(link))
+		return PTR_ERR(link);
 
 	fd = bpf_link_new_fd(link);
 	if (fd < 0)
-- 
2.23.0

