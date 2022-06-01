Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3420E53AF2F
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 00:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiFAVA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 17:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiFAVAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 17:00:04 -0400
Received: from mail-oi1-x24a.google.com (mail-oi1-x24a.google.com [IPv6:2607:f8b0:4864:20::24a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF2621C3BC
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 14:00:02 -0700 (PDT)
Received: by mail-oi1-x24a.google.com with SMTP id s7-20020aca4507000000b0032c20f7f5baso1534830oia.19
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 14:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RXKl9EM4qib7IbD/zrHgEWRk4S4fWpIVCE5G5HO5GOU=;
        b=mhB+WeznATLkYl2LbdHUewk/1U/ZysZB6fqyK0rpfIPuuTMnLJ6gcRHvOtbTdoIK/4
         zPhvMiQupAFL76HJ24aCCy7sHZ3kuJgqrBDZc5/tzhoVZkUH/No8JNGMGGoK4npwTjgM
         K0kPbj0WqH9Dp0DnSU25vA7SQTT+V+QYT8jmXp3HNONWN6dvAVarHrAJXiV/FkF/3dON
         MGar8Xpij604YOHwpJ4Jtj0WUT8Fypkt2DsBm+c2NeajIWM1Y1Sd75r4mb3u42Hi18QU
         55o0EyOX61cj53DRHpFFwHGTp/uRPP1Ox0gufo1vBt+WmbwgxuPTo+bJH7MY81LethMX
         Zfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RXKl9EM4qib7IbD/zrHgEWRk4S4fWpIVCE5G5HO5GOU=;
        b=f8DYe0Ev+X7aKCZxBixdwzE5Cvf06jv+CeQNIAU1PeoZsW/0YFk/QFouTFKslL/8MU
         nBRgBvD2L+R8MZ2mcUxb7IzLzPLOcPY8luGE8+R2uUbg7xO3o3IYZk2jox4skjjGvoKI
         mapKSrTElKouxPII1etI6AUYuUlRqwKI/DyBgfzn5EI3nDjcGGpftg9xu7XxCKQSurFP
         w/pMVDfY+dh7VDPuU4ccNgrNkWvKT25acpbU1mZIGVa5yqa33r6KoTM/nSlBAdRC1kB/
         lR5kVQ4u1PRA11QwBvNfHM9WYuEAtUhSgpT1J/LxFginGkM0FxSj1Qgh4IQNuSricgWb
         u96Q==
X-Gm-Message-State: AOAM531F1XD/o4eJbJyPalP/132QAyP1GD40qSBx0E9wwZXkaXRTncod
        QgRKRnlBGpTQuPr78DAQpn6WOYPLd/rumS1SXLIkFVEOIbgMSjOe9PKhIjO7kEjFPYUq447DASE
        q10vcB0XwP/D2L8fdwDCv4J6T+K46x7iSGqYwODX/Zi9+lwa8ct2GhA==
X-Google-Smtp-Source: ABdhPJzojwUo6eFF1QyJpEP+hioorPSnRmbi6POqS3MVEZ1iJmso/k6SCYPa7RGCfqF1MUZvMm3oBVY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr3309pje.0.1654110148549; Wed, 01 Jun
 2022 12:02:28 -0700 (PDT)
Date:   Wed,  1 Jun 2022 12:02:12 -0700
In-Reply-To: <20220601190218.2494963-1-sdf@google.com>
Message-Id: <20220601190218.2494963-6-sdf@google.com>
Mime-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH bpf-next v8 05/11] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
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
 include/uapi/linux/bpf.h |   3 ++
 kernel/bpf/cgroup.c      | 103 +++++++++++++++++++++++++++------------
 kernel/bpf/syscall.c     |   6 ++-
 3 files changed, 81 insertions(+), 31 deletions(-)

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
index a27a6a7bd852..cb3338ef01e0 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1035,6 +1035,7 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 			      union bpf_attr __user *uattr)
 {
+	__u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
 	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
 	enum bpf_attach_type type = attr->query.attach_type;
 	enum cgroup_bpf_attach_type atype;
@@ -1042,50 +1043,92 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	struct hlist_head *progs;
 	struct bpf_prog *prog;
 	int cnt, ret = 0, i;
+	int total_cnt = 0;
 	u32 flags;
 
-	atype = to_cgroup_bpf_attach_type(type);
-	if (atype < 0)
-		return -EINVAL;
+	enum cgroup_bpf_attach_type from_atype, to_atype;
 
-	progs = &cgrp->bpf.progs[atype];
-	flags = cgrp->bpf.flags[atype];
+	if (type == BPF_LSM_CGROUP) {
+		from_atype = CGROUP_LSM_START;
+		to_atype = CGROUP_LSM_END;
+	} else {
+		from_atype = to_cgroup_bpf_attach_type(type);
+		if (from_atype < 0)
+			return -EINVAL;
+		to_atype = from_atype;
+	}
 
-	effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
-					      lockdep_is_held(&cgroup_mutex));
+	for (atype = from_atype; atype <= to_atype; atype++) {
+		progs = &cgrp->bpf.progs[atype];
+		flags = cgrp->bpf.flags[atype];
 
-	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
-		cnt = bpf_prog_array_length(effective);
-	else
-		cnt = prog_list_length(progs);
+		effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
+						      lockdep_is_held(&cgroup_mutex));
 
-	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
-		return -EFAULT;
-	if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
+		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
+			total_cnt += bpf_prog_array_length(effective);
+		else
+			total_cnt += prog_list_length(progs);
+	}
+
+	if (type != BPF_LSM_CGROUP)
+		if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
+			return -EFAULT;
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
+	for (atype = from_atype; atype <= to_atype; atype++) {
+		if (total_cnt <= 0)
+			break;
 
-		i = 0;
-		hlist_for_each_entry(pl, progs, node) {
-			prog = prog_list_prog(pl);
-			id = prog->aux->id;
-			if (copy_to_user(prog_ids + i, &id, sizeof(id)))
-				return -EFAULT;
-			if (++i == cnt)
-				break;
+		progs = &cgrp->bpf.progs[atype];
+		flags = cgrp->bpf.flags[atype];
+
+		effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
+						      lockdep_is_held(&cgroup_mutex));
+
+		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
+			cnt = bpf_prog_array_length(effective);
+		else
+			cnt = prog_list_length(progs);
+
+		if (cnt >= total_cnt)
+			cnt = total_cnt;
+
+		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
+			ret = bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
+		} else {
+			struct bpf_prog_list *pl;
+			u32 id;
+
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
+		if (prog_attach_flags)
+			for (i = 0; i < cnt; i++)
+				if (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
+					return -EFAULT;
+
+		prog_ids += cnt;
+		total_cnt -= cnt;
+		if (prog_attach_flags)
+			prog_attach_flags += cnt;
 	}
 	return ret;
 }
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a237be4f8bb3..27492d44133f 100644
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
@@ -4066,6 +4067,9 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 
 	if (prog->aux->btf)
 		info.btf_id = btf_obj_id(prog->aux->btf);
+	info.attach_btf_id = prog->aux->attach_btf_id;
+	if (prog->aux->attach_btf)
+		info.attach_btf_obj_id = btf_obj_id(prog->aux->attach_btf);
 
 	ulen = info.nr_func_info;
 	info.nr_func_info = prog->aux->func_info_cnt;
-- 
2.36.1.255.ge46751e96f-goog

