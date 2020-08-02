Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155F7239CCF
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 00:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgHBW35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 18:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgHBW3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 18:29:55 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013FCC06174A;
        Sun,  2 Aug 2020 15:29:55 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p8so2753405pgn.13;
        Sun, 02 Aug 2020 15:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A2Q8y4FxBw8Xm6waqkRnEWnE3Yifk6AakKwtWHNs5Lo=;
        b=m1IUi43vEvh/sSEpumgUqKXsj5RDHyFqpl3TYzbdkRv9aJYcV88aGSHeOO/bVKZyTA
         ciXmh60sBbB6OysbQN34YtMVBFw9YYwO43MDC6xPTkETaYVtCcdWAC0SENH3yD1jms2C
         UqbM2706VBGokD4z6XFH0PXJiddyziQXntYV23crqjIpZ45E49ZYWyTWmveBYmcm/z+P
         OBn1sTkPaRWc2uDApe+DZKa2NzNZUm3idX5qzvZN0eWVMwW2v4C2fxN/XNrkYsZeHtua
         KmUonWcdooG7gOd07PxGXid3y95KDWTGQnlZ+MYyfAumTOYt1CxyIraBlqg6Yg0/V8pw
         SJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=A2Q8y4FxBw8Xm6waqkRnEWnE3Yifk6AakKwtWHNs5Lo=;
        b=cGocTvGRnxMJX/Uj4is60npBC+X1Mq/64+L55L+5MLd60hLanouE51UztnM2wZCVbp
         Dhir/tsMxsT0nOTiceyhNjbk1KqlbIj29toUkD8GjqO8IfDdURGd2J5/lFj1lTe+PCVS
         ZOSkIYZBiPvrXnuR8maZdSg61PLd2A25xs7ruQA6Xjw2ppe2bx98NqhtpMjWGPmwEm1n
         +o1zaw1grxkhZUhrxS9cv6nnQ5+xjMt8pNcZn7nReFJKXTl2T3R3e6Omplj/ViSCpM2q
         +JKZXPe7N/iVMySQwI4jOYnvyZikc5tGR+oxMnIKKw9HwydsIXPqhTerAWheUhI7Q3c5
         R+7w==
X-Gm-Message-State: AOAM530ktWyRVViJyC0COUnIQOKjUJlWVCcfzcSbWIHnfKBzpM/KGLkc
        YWBwn68UZ13KZycmH8a8Tac=
X-Google-Smtp-Source: ABdhPJwGqFAy6a/z89PTTHEvYWBQF57mOIsJm78XK2mFWNJfFMrJg6hSht8iuYT/yupzhlaUS1sxfA==
X-Received: by 2002:a62:164a:: with SMTP id 71mr13428436pfw.266.1596407394501;
        Sun, 02 Aug 2020 15:29:54 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id g5sm15544414pjl.31.2020.08.02.15.29.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Aug 2020 15:29:53 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v5 bpf-next 1/4] bpf: Factor out bpf_link_by_id() helper.
Date:   Sun,  2 Aug 2020 15:29:47 -0700
Message-Id: <20200802222950.34696-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200802222950.34696-1-alexei.starovoitov@gmail.com>
References: <20200802222950.34696-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Refactor the code a bit to extract bpf_link_by_id() helper.
It's similar to existing bpf_prog_by_id().

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf.h  |  1 +
 kernel/bpf/syscall.c | 46 +++++++++++++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cef4ef0d2b4e..f611e03e111c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1356,6 +1356,7 @@ int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
 			 struct btf *btf, const struct btf_type *t);
 
 struct bpf_prog *bpf_prog_by_id(u32 id);
+struct bpf_link *bpf_link_by_id(u32 id);
 
 const struct bpf_func_proto *bpf_base_func_proto(enum bpf_func_id func_id);
 #else /* !CONFIG_BPF_SYSCALL */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2f343ce15747..5d5b0259fab8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4014,40 +4014,50 @@ static int link_detach(union bpf_attr *attr)
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

