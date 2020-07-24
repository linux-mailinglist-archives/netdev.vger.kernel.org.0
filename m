Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B47C22BDC9
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 07:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgGXF7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 01:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgGXF67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 01:58:59 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BB3C0619D3;
        Thu, 23 Jul 2020 22:58:58 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 1so4495737pfn.9;
        Thu, 23 Jul 2020 22:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vkEBXlSGnLLRxbmDjbBrer57/0xI11aAve+FNUgGjvk=;
        b=JcJQa+kU68UOXfr/7fDYSO3wdcDeYDIPJwtEuX4NJCO+kfk8x6cuMeT8NjlrJ1PtGu
         lgww1+hLs6oQ6bmp+RUDiTQadI5ymvkQuy0Avufbdm1JkTe07CiN2BO+4OUHbsk6rful
         EddOUubYHxv5MnTfhN4dTj91XLwOUDLlNa3BrKHyfl2G7NlBE98tgBJwa1U0afc+iZ+J
         JF7T3D2hvpx4f1XjL2OZJe9YAIYrC8DguJ7pAFK/nme6m9txL20RECBI7rAuMLNOm7a4
         fGmXuEft0zrA4bIR7+WG7VfxpowjcZyQ5m6tLqRIN9e38d+ubuqHZGBojIV2n950cSym
         dzzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vkEBXlSGnLLRxbmDjbBrer57/0xI11aAve+FNUgGjvk=;
        b=fC0wLdm4CpHlB+jukjE62ccQq5LCsLCtDio0/9q4GA3ij6MPsVpzwQA2gPk+N5C9dw
         OMiB1mqkaGKi+/4qEWLmuNSNB3OO0aOqMt9ZFU6BXVl3CUH+R6nGTvtCjD5MAQ3tiDLC
         S/VoW4qZ/9G9/ZFkTd4wZxnpZowRc9FfiLo5N8GzCTNOGa7nFBck8AQvEo8tVXvLGQvD
         mT9hDpjPSzPgABNHqMgGeOgvybcKHr0zXzfPucildMaS147e4bG1lJhZhM+RUrGPqN7o
         BbGqs+xRyNgGzslmtabrgpCB7fm/Xx3VKNMaZDuFa6WLEoqLKHXZUBuWEvZ3dm2fZZ/g
         XshQ==
X-Gm-Message-State: AOAM5301WiToHn4UPLad7ILKp8UIrzXoBA8D24zt9NTey+LTn9o9jIRA
        vXvteIUz6DQz6dTEfV6dwXfFWtYE
X-Google-Smtp-Source: ABdhPJzGvCO3EuaXtROEEn6Mme7jw31Ce50/2I6amvmxHB08Flf+5eL41yLscy60JoXs9y3eJM2OUg==
X-Received: by 2002:a63:1d5e:: with SMTP id d30mr7185345pgm.179.1595570338473;
        Thu, 23 Jul 2020 22:58:58 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id j10sm4909893pgh.28.2020.07.23.22.58.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Jul 2020 22:58:57 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 1/4] bpf: Factor out bpf_link_get_by_id() helper.
Date:   Thu, 23 Jul 2020 22:58:51 -0700
Message-Id: <20200724055854.59013-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200724055854.59013-1-alexei.starovoitov@gmail.com>
References: <20200724055854.59013-1-alexei.starovoitov@gmail.com>
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

