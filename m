Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA3E5550BA
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376477AbiFVQEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376410AbiFVQEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:04:09 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3CE2F670
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:03:58 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m17-20020a170902d19100b0016a0e65a433so7539069plb.8
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3zMvun7ClqeQJCp2dBkhWh6+UVMmIJSwgyjJdLsLxHw=;
        b=MWvBWrI4LMsZz/K/l1cDakmRSI2zapVNscKI7SQItCxn8N1D8uZRUDNCH0wEnRqIBt
         c5GBm9aBzfzCYzLyOiq3O4GJA6y/9iNoA4LdQ3IcyEINfdb6gOELigw8BcJaIYz2Egaf
         bEMG8+F2pQvbeeC5CTyzC8WAU2q0cnAXAuH5g05CHBLrZzCIUAnD8FY5zEfbYuVwkVVV
         12st2N6rOkOkfpAQmnGSXb28BZtA8aSFEvBMsmemab/kZUcX04a4QU9NXgDya1mCvbQa
         bSAiQXbRaTWX7FLmWn7ifkY1i8hMBVUnEYgpt+C+aDywmLfB/ecbbfP8uYK668IB2goC
         Qnug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3zMvun7ClqeQJCp2dBkhWh6+UVMmIJSwgyjJdLsLxHw=;
        b=F5E37adXkObB6lUoB8FEcZt9Rh1FvBVvY9htfzRfJ1K+OEoiHKRyikKz2n49HLnYSx
         0oikwMln4dMNwNjORVlEaKlU5C6xUes/cOqDe7B0sBrIkD3LuJZRM5cJZ8KMpRCRHKxk
         x2mIVqNPQcVMU8CXlLbJTL/akPS+hlw/VL16ZZvi6poeii2j2TcT0IRHcI724VL+TIoh
         SD4ZWfgBS5omPQVKUWOpzob5vH6FtgbNPA4TBA6LvBKaATeVJDPZoBiAuyNjgJxeTRba
         EXJBaAP3EqbJ4Tq++chJ8o9pchr/VUxDVzV2r3ZEyFx/92+zoYyVxuE7m1DjCK3a6ES3
         vWdA==
X-Gm-Message-State: AJIora+L++AS2GKuGwfl6PeR1vln2brT7jaM79/sSf8Zt9G+ESvR2LEs
        +GvnWOvhoO1jiRwXK7lteYV0iDiSwVJX9NxPQMLPWGFr/9SUkyD5fasQ/2sGkb0w5NQR+tfVQ4L
        /LarvAx2hFfcZHHZdTRbgdmlCf/y2g46i3TpNWpc/Q6eoUHS+R8WEwA==
X-Google-Smtp-Source: AGRyM1unXOrIn48hQwecqpWChzsLf7JXcmpX4uWAZD+Bv+EcuTKYt6QPGtdPv3RoFldS3/WfruzPiEE=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr10241pje.0.1655913837482; Wed, 22 Jun
 2022 09:03:57 -0700 (PDT)
Date:   Wed, 22 Jun 2022 09:03:40 -0700
In-Reply-To: <20220622160346.967594-1-sdf@google.com>
Message-Id: <20220622160346.967594-6-sdf@google.com>
Mime-Version: 1.0
References: <20220622160346.967594-1-sdf@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH bpf-next v10 05/11] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
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

Reviewed-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/uapi/linux/bpf.h |  3 ++
 kernel/bpf/cgroup.c      | 95 +++++++++++++++++++++++++++-------------
 kernel/bpf/syscall.c     |  8 +++-
 3 files changed, 74 insertions(+), 32 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b7479898c879..ad9e7311c4cf 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1432,6 +1432,7 @@ union bpf_attr {
 		__u32		attach_flags;
 		__aligned_u64	prog_ids;
 		__u32		prog_cnt;
+		__aligned_u64	prog_attach_flags; /* output: per-program attach_flags */
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
@@ -6076,6 +6077,8 @@ struct bpf_prog_info {
 	__u64 run_cnt;
 	__u64 recursion_misses;
 	__u32 verified_insns;
+	__u32 attach_btf_obj_id;
+	__u32 attach_btf_id;
 } __attribute__((aligned(8)));
 
 struct bpf_map_info {
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 169cbd0de797..59b7eb60d5b4 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1017,57 +1017,90 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 			      union bpf_attr __user *uattr)
 {
+	__u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
 	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
 	enum bpf_attach_type type = attr->query.attach_type;
+	enum cgroup_bpf_attach_type from_atype, to_atype;
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog_array *effective;
-	struct hlist_head *progs;
-	struct bpf_prog *prog;
 	int cnt, ret = 0, i;
+	int total_cnt = 0;
 	u32 flags;
 
-	atype = to_cgroup_bpf_attach_type(type);
-	if (atype < 0)
-		return -EINVAL;
-
-	progs = &cgrp->bpf.progs[atype];
-	flags = cgrp->bpf.flags[atype];
+	if (type == BPF_LSM_CGROUP) {
+		if (attr->query.prog_cnt && prog_ids && !prog_attach_flags)
+			return -EINVAL;
 
-	effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
-					      lockdep_is_held(&cgroup_mutex));
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
 
-	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
-		cnt = bpf_prog_array_length(effective);
-	else
-		cnt = prog_list_length(progs);
+	for (atype = from_atype; atype <= to_atype; atype++) {
+		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
+			effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
+							      lockdep_is_held(&cgroup_mutex));
+			total_cnt += bpf_prog_array_length(effective);
+		} else {
+			total_cnt += prog_list_length(&cgrp->bpf.progs[atype]);
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
+		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
+			effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
+							      lockdep_is_held(&cgroup_mutex));
+			cnt = min_t(int, bpf_prog_array_length(effective), total_cnt);
+			ret = bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
+		} else {
+			struct hlist_head *progs;
+			struct bpf_prog_list *pl;
+			struct bpf_prog *prog;
+			u32 id;
+
+			progs = &cgrp->bpf.progs[atype];
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
+		}
 
-		i = 0;
-		hlist_for_each_entry(pl, progs, node) {
-			prog = prog_list_prog(pl);
-			id = prog->aux->id;
-			if (copy_to_user(prog_ids + i, &id, sizeof(id)))
-				return -EFAULT;
-			if (++i == cnt)
-				break;
+		if (prog_attach_flags) {
+			flags = cgrp->bpf.flags[atype];
+
+			for (i = 0; i < cnt; i++)
+				if (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
+					return -EFAULT;
+			prog_attach_flags += cnt;
 		}
+
+		prog_ids += cnt;
+		total_cnt -= cnt;
 	}
 	return ret;
 }
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 626b8f7d237b..ab688d85b2c6 100644
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
2.37.0.rc0.104.g0611611a94-goog

