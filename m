Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1950E22CF8D
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 22:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgGXUii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 16:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgGXUif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 16:38:35 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEDCC0619D3;
        Fri, 24 Jul 2020 13:38:35 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a9so6021948pjd.3;
        Fri, 24 Jul 2020 13:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vkEBXlSGnLLRxbmDjbBrer57/0xI11aAve+FNUgGjvk=;
        b=mdFL+kQLqjy6HH8P0EIu8vsCu+lVUUyrpjIaG+YlNvv7B0raED1ih0OAy7V+/Zw8Mq
         tpTGqnK0bIvjAM6GqesX4rWy+Wa6QxgrGhBSsYKQOZWPZqBBgGNTVbJC+YZUvo7nYstm
         XsHxUwqTooVhJMjaj6Ctnai+KdcSjpWy8X225Ae01DX67UVaXlXrIkqubd8p4niFt/PL
         4ZJPmcWrH+yM51/90mtC7yHkQnNOwC/HqaM8hSRDbebhokPPEXMgc8dkP3M+ct9e+phQ
         yhMiefmHurxgyWN+rCx96JNdB267QrYXixX0rlKLWzps21l9h7XOPlCVKa2Eq8bIBt/X
         r2hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vkEBXlSGnLLRxbmDjbBrer57/0xI11aAve+FNUgGjvk=;
        b=ceKTIwfSwHF0hQwXCT2SjrVYTQqAVwefIENtbeocndGDpupEp+QU/lHG0Zigo5uwdT
         FQqgMzwDjJfcJdh9oWOqswBnuT73I1qnn/r4vwg5HYX6qqyHwj3fd2xM4q2VqRGRZ/Ls
         qX83TFKn1UFvYWS+Ie/FjWk42zLPVhGB7Di92w71rlRCrhYGrQ3JAphvjVIIMngd5vLX
         QMf6XrsrXLK8w3Mxu30g+zsSusQhL8IzXFgxVYHEHh7C//0/khHrOND2UvS6vBm+yvNV
         H1N2hqWD8GJmRB3AxdrtZvLccv2nlP02WfZT0/jjJthm9YEf7+innlH1e+CO8j4DaUa7
         JgYQ==
X-Gm-Message-State: AOAM533emD0zffCfY6zt5XqDx25XPqFHy0TyKv/nNMh1vPY889ThMDQ3
        yLHwHjzGIX4AoYc+M2SjHK4=
X-Google-Smtp-Source: ABdhPJwhK+yNKBk/1zq/pJ74+h2XffeXiJgBmimO/Ek4witC8laCQEhb+rrETWOjFBf0+KFOsZPaHw==
X-Received: by 2002:a17:90a:ce02:: with SMTP id f2mr7505343pju.159.1595623114713;
        Fri, 24 Jul 2020 13:38:34 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id lr1sm8114461pjb.27.2020.07.24.13.38.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2020 13:38:33 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 bpf-next 1/4] bpf: Factor out bpf_link_get_by_id() helper.
Date:   Fri, 24 Jul 2020 13:38:27 -0700
Message-Id: <20200724203830.81531-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200724203830.81531-1-alexei.starovoitov@gmail.com>
References: <20200724203830.81531-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Refactor the code a bit to extract bpf_link_get_by_id() helper.
It's similar to existing bpf_prog_by_id().

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h  |  1 +
 kernel/bpf/syscall.c | 46 +++++++++++++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8357be349133..d5c4e2cc24a0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1355,6 +1355,7 @@ int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
 			 struct btf *btf, const struct btf_type *t);
 
 struct bpf_prog *bpf_prog_by_id(u32 id);
+struct bpf_link *bpf_link_by_id(u32 id);
 
 const struct bpf_func_proto *bpf_base_func_proto(enum bpf_func_id func_id);
 #else /* !CONFIG_BPF_SYSCALL */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ee290b1f2d9e..42eb0d622980 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3984,40 +3984,50 @@ static int link_update(union bpf_attr *attr)
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

