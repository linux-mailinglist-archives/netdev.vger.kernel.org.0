Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDE8546B1E
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350010AbiFJQ6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349939AbiFJQ6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:58:20 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099B5326E6
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:58:15 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c10-20020a170903234a00b00168b5f7661bso1866339plh.6
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tx6LbVboUVrxxeG1EvvJOHAKWfDXdJsAG+b7UJkNdZ4=;
        b=kYlo/GaRFEBSw2MLnDSpnE5+EF+10d1KGsKSfVtuogBjMExFOx+PSTsWaSWYz6FbVI
         E21N5eIqKIhfl8FNIJLl3GNQilUtuJbE5tZsxk4FURzmGMaGIVsCkdfFaq5MLr7+z3qH
         WtpsWesk7yVypgnMjKoEULcVcMcmH9rSejh5UKryTL4q/CHmxbEKNWfIFsOM95diNfBf
         /khIcO0hOxtBcz2zojN+bZOQywBt1gRfl0BUmsVqfsBF7UUkJwu+a6imhv2q6MxON/K4
         jsAfZg21gyILNFUKIPkWqzPKvJ2xumJPmKP+Lk4n5syuKydsV3CqrmH6tqk94XPo6+ls
         Yg0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tx6LbVboUVrxxeG1EvvJOHAKWfDXdJsAG+b7UJkNdZ4=;
        b=AmMEdHQy7GvaMcLGP6wR1qAMoT5NEAlaS2E8N+ZNM7FU1mt1VRnHEFUvPSydtrVwLL
         sHMKNd9l575qfKmjEoUD72kSGLCwBCVyg/9qCs+h5xfRohbNLqZGLrjeXbsXh/WZ1gKn
         ZCNwAVx30Ln+dRPZ94T8QCzGrLc3lyVxz0oBGWdqVOtUGUwAcpP+tRhj3eSR6uSBP6CK
         B4h7zDx1oYrvLuwuf/b6WQCmGHvlPE2EtaAYiO65zxwcS5Y5ofxOrqyLrEHPIvXRp4q4
         VBndd26bwZ8hb4mPFxg/6IvYw4s4z4FUUMSAvZLxhU6XH0Nu2etWOPLye1Zc4maqVxQe
         h0nw==
X-Gm-Message-State: AOAM530P5nanj8C1djPs7+XW0KKzo9IDoHVeju5L/k9rPAOa+RNIVsAL
        ud08i6bzDy138kBDWz1jPP64C+EAQl8hHbvypy5t5rEdv+UWyy5HgrkhGE9A24dg8kTBDoJAYqP
        Le75GPH0gaya6BBVCdYtjCgb1g5jilLIUNVIGgFPI+TF7DvvtPG0/XA==
X-Google-Smtp-Source: ABdhPJwk2vNOMpNCXjVPKm++ohUehgFbhFhUNF0yhEvw/hX0oq/NAE0rpr1v3W9l5Cc4a8xK8kFA9oo=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:c89:b0:51c:2ad8:47ad with SMTP id
 a9-20020a056a000c8900b0051c2ad847admr24141768pfv.42.1654880294354; Fri, 10
 Jun 2022 09:58:14 -0700 (PDT)
Date:   Fri, 10 Jun 2022 09:57:58 -0700
In-Reply-To: <20220610165803.2860154-1-sdf@google.com>
Message-Id: <20220610165803.2860154-6-sdf@google.com>
Mime-Version: 1.0
References: <20220610165803.2860154-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH bpf-next v9 05/10] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have two options:
1. Treat all BPF_LSM_CGROUP the same, regardless of attach_btf_id
2. Treat BPF_LSM_CGROUP+attach_btf_id as a separate hook point

I was doing (2) in the original patch, but switching to (1) here:

* bpf_prog_query returns all attached BPF_LSM_CGROUP programs
regardless of attach_btf_id
* attach_btf_id is exported via bpf_prog_info

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/uapi/linux/bpf.h |  3 ++
 kernel/bpf/cgroup.c      | 91 +++++++++++++++++++++++++++-------------
 kernel/bpf/syscall.c     |  8 +++-
 3 files changed, 73 insertions(+), 29 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index fa64b0b612fd..4271ef3c2afb 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1432,6 +1432,7 @@ union bpf_attr {
 		__u32		attach_flags;
 		__aligned_u64	prog_ids;
 		__u32		prog_cnt;
+		__aligned_u64	prog_attach_flags; /* output: per-program attach_flags */
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
@@ -5996,6 +5997,8 @@ struct bpf_prog_info {
 	__u64 run_cnt;
 	__u64 recursion_misses;
 	__u32 verified_insns;
+	__u32 attach_btf_obj_id;
+	__u32 attach_btf_id;
 } __attribute__((aligned(8)));
 
 struct bpf_map_info {
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index ba402d50e130..c869317479ec 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1029,57 +1029,92 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 			      union bpf_attr __user *uattr)
 {
+	__u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
 	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
 	enum bpf_attach_type type = attr->query.attach_type;
+	enum cgroup_bpf_attach_type from_atype, to_atype;
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog_array *effective;
 	struct hlist_head *progs;
 	struct bpf_prog *prog;
 	int cnt, ret = 0, i;
+	int total_cnt = 0;
 	u32 flags;
 
-	atype = to_cgroup_bpf_attach_type(type);
-	if (atype < 0)
-		return -EINVAL;
+	if (type == BPF_LSM_CGROUP) {
+		if (attr->query.prog_cnt && prog_ids && !prog_attach_flags)
+			return -EINVAL;
 
-	progs = &cgrp->bpf.progs[atype];
-	flags = cgrp->bpf.flags[atype];
+		from_atype = CGROUP_LSM_START;
+		to_atype = CGROUP_LSM_END;
+		flags = 0;
+	} else {
+		from_atype = to_cgroup_bpf_attach_type(type);
+		if (from_atype < 0)
+			return -EINVAL;
+		to_atype = from_atype;
+		flags = cgrp->bpf.flags[from_atype];
+	}
 
-	effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
-					      lockdep_is_held(&cgroup_mutex));
+	for (atype = from_atype; atype <= to_atype; atype++) {
+		progs = &cgrp->bpf.progs[atype];
 
-	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
-		cnt = bpf_prog_array_length(effective);
-	else
-		cnt = prog_list_length(progs);
+		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
+			effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
+							      lockdep_is_held(&cgroup_mutex));
+			total_cnt += bpf_prog_array_length(effective);
+		} else {
+			total_cnt += prog_list_length(progs);
+		}
+	}
 
 	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
 		return -EFAULT;
-	if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
+	if (copy_to_user(&uattr->query.prog_cnt, &total_cnt, sizeof(total_cnt)))
 		return -EFAULT;
-	if (attr->query.prog_cnt == 0 || !prog_ids || !cnt)
+	if (attr->query.prog_cnt == 0 || !prog_ids || !total_cnt)
 		/* return early if user requested only program count + flags */
 		return 0;
-	if (attr->query.prog_cnt < cnt) {
-		cnt = attr->query.prog_cnt;
+
+	if (attr->query.prog_cnt < total_cnt) {
+		total_cnt = attr->query.prog_cnt;
 		ret = -ENOSPC;
 	}
 
-	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
-		return bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
-	} else {
-		struct bpf_prog_list *pl;
-		u32 id;
+	for (atype = from_atype; atype <= to_atype && total_cnt; atype++) {
+		progs = &cgrp->bpf.progs[atype];
+		flags = cgrp->bpf.flags[atype];
 
-		i = 0;
-		hlist_for_each_entry(pl, progs, node) {
-			prog = prog_list_prog(pl);
-			id = prog->aux->id;
-			if (copy_to_user(prog_ids + i, &id, sizeof(id)))
-				return -EFAULT;
-			if (++i == cnt)
-				break;
+		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
+			effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
+							      lockdep_is_held(&cgroup_mutex));
+			cnt = min_t(int, bpf_prog_array_length(effective), total_cnt);
+			ret = bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
+		} else {
+			struct bpf_prog_list *pl;
+			u32 id;
+
+			cnt = min_t(int, prog_list_length(progs), total_cnt);
+			i = 0;
+			hlist_for_each_entry(pl, progs, node) {
+				prog = prog_list_prog(pl);
+				id = prog->aux->id;
+				if (copy_to_user(prog_ids + i, &id, sizeof(id)))
+					return -EFAULT;
+				if (++i == cnt)
+					break;
+			}
 		}
+
+		if (prog_attach_flags) {
+			for (i = 0; i < cnt; i++)
+				if (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
+					return -EFAULT;
+			prog_attach_flags += cnt;
+		}
+
+		prog_ids += cnt;
+		total_cnt -= cnt;
 	}
 	return ret;
 }
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a237be4f8bb3..b826247de971 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3520,7 +3520,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	}
 }
 
-#define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
+#define BPF_PROG_QUERY_LAST_FIELD query.prog_attach_flags
 
 static int bpf_prog_query(const union bpf_attr *attr,
 			  union bpf_attr __user *uattr)
@@ -3556,6 +3556,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_SYSCTL:
 	case BPF_CGROUP_GETSOCKOPT:
 	case BPF_CGROUP_SETSOCKOPT:
+	case BPF_LSM_CGROUP:
 		return cgroup_bpf_prog_query(attr, uattr);
 	case BPF_LIRC_MODE2:
 		return lirc_prog_query(attr, uattr);
@@ -4066,6 +4067,11 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 
 	if (prog->aux->btf)
 		info.btf_id = btf_obj_id(prog->aux->btf);
+	info.attach_btf_id = prog->aux->attach_btf_id;
+	if (prog->aux->attach_btf)
+		info.attach_btf_obj_id = btf_obj_id(prog->aux->attach_btf);
+	else if (prog->aux->dst_prog)
+		info.attach_btf_obj_id = btf_obj_id(prog->aux->dst_prog->aux->attach_btf);
 
 	ulen = info.nr_func_info;
 	info.nr_func_info = prog->aux->func_info_cnt;
-- 
2.36.1.476.g0c4daa206d-goog

