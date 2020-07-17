Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82CA223279
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 06:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGQEkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 00:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgGQEki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 00:40:38 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC79C08C5C0;
        Thu, 16 Jul 2020 21:40:38 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q17so4909286pls.9;
        Thu, 16 Jul 2020 21:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UgpOGCoTPa26Yu82By38aivY9QEVyjNXXpyiF9NsswA=;
        b=Igs1TelXjsUb/HKrVN7X50jwTjnsbvq/pB4ayjL2IhJ09qDMkjxzS6olTvhf1LrnGS
         tgySKfyqjGjfS0b/fOQ/XJI8U7WNCDR16FvCNVv5X8AX0aqX5vPwOJLZ0ztURIEQU1Gh
         TtdxjpQnppF9XivMTw8Ykl7/XLfccDolX9Znfbr5UiHs3UBm36ebsD4WMZWP5/JcYUAP
         dkLmigHB50AiF1X6CjNnkKhYyWyAYAiGQu7gBtvC+0lVn91Mrvh8cEFEmEjVFGek+NfS
         /qtn3WJ1MqVzD+Kqq6m2iyUy6CS6Gab/FoXh2mm6CytiGKjDQ5Gf/gkqW0zIRBuglTvp
         RhsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UgpOGCoTPa26Yu82By38aivY9QEVyjNXXpyiF9NsswA=;
        b=SUqoe3ugN1CUJaHAt7jeqUcaDrgqRelZP4RI9g96L2XEuBiO2yZjD94tMIqlqjVTeh
         6hWyT3sRs8Pqjl/FohlQBzH/FM4hrLti0kA28ysE6c1kS2/ILEhqXrqY/oyINsqTYM9G
         6mLqwqS55Frdd4LFKXgyUgvkp1EUv5WR5K3lFIzbIgcVoqT4QH7aPlrAkw5CiO7jMN7k
         lXkxm4SUUv6RqKBFV7nelo+jrkgn/pPmus2SMlsqLKcACdhGyUpHmIOH5F0QwAj+9x9P
         PV0/s7FFgrA0VMuoysaK5m3CzDPNm+4dCjLdkFuyIcQbqAHtkaUji8vTMmmJULTE8eX+
         zfUA==
X-Gm-Message-State: AOAM531tWM9k5c+NhjlGG/tAMZPvg5uQBZqwtAmGveys3okYDmo6l2eX
        KnR+4ROYPHpx6kQ5MSoQbj8ivrV+
X-Google-Smtp-Source: ABdhPJy14mW1ehc/G5CTLdT2Mr+aB2IjN8lMpyHtht8z601dx3yNrf7lTE8rvuZ+vgp3USMyJwJqHg==
X-Received: by 2002:a17:90a:9287:: with SMTP id n7mr7197606pjo.223.1594960837833;
        Thu, 16 Jul 2020 21:40:37 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id e5sm1335389pjy.26.2020.07.16.21.40.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 21:40:37 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 2/4] bpf: Factor out bpf_link_get_by_id() helper.
Date:   Thu, 16 Jul 2020 21:40:29 -0700
Message-Id: <20200717044031.56412-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200717044031.56412-1-alexei.starovoitov@gmail.com>
References: <20200717044031.56412-1-alexei.starovoitov@gmail.com>
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
index 4ede2b0298b3..009e744897d5 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1319,6 +1319,7 @@ int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
 			 struct btf *btf, const struct btf_type *t);
 
 struct bpf_prog *bpf_prog_by_id(u32 id);
+struct bpf_link *bpf_link_by_id(u32 id);
 
 const struct bpf_func_proto *bpf_base_func_proto(enum bpf_func_id func_id);
 #else /* !CONFIG_BPF_SYSCALL */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 86df3daa13f6..85ea56717368 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3975,40 +3975,50 @@ static int link_update(union bpf_attr *attr)
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

