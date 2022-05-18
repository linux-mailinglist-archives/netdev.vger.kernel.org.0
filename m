Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8480952C6F3
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiERW5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbiERW4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:56:12 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A496DF6
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:55:45 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2fecc57ec14so31005277b3.11
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t++i3YZeyLKXd5yp2qTObKh2r4leb+H6PgjBswrw9LU=;
        b=nAQKPNnsOODVnUHENfHijARy11ggS3KsY+usyOU9pDINL9PCNPGMnf+kfgX/xhZS8x
         277MRvL+xzn5AR5OMf1m9r+g58crj6/ShFMiVFZdEm1n2TPx/eEiMiQDJAE/MZlU/jSD
         x/LsquBlsoiFwp0Mfpd0g0o444gUDq+8z4g5kfSATFi8PQH7q09xGemtU9/LpF6nmrcv
         Sl1lUkqLAIJ++UaYc1QNPqU06MVxLc7xgY+6jOfQUTRVTuZRpRC6rfJNkCKWQaWLalUW
         us86hChVeTWSNvmIFXvsGrkkr6yXfdf1ZLs5q39bZ792hzrUQnZ3X+O9a6snIKN5F5b4
         GGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t++i3YZeyLKXd5yp2qTObKh2r4leb+H6PgjBswrw9LU=;
        b=cabq33Z03bu1YX0AIxFAcyz4Spysjhf9LBHYpfsIf9IEHCA130IzUlgwQSFWrw/aia
         qfY7ZZsWBrzc3Fod8wM4ylpsrg70HzzNcUjlDsxiMyljgtL+ErZ2tq+04iM0VkuxuU2+
         G+oB6vNV4FxzrxpwAG2fvh/DGc3lqsDgPdkgRyLMbYLzqmN6JMxc+8JyE4JRk7s7NMfQ
         xRGfmzLvnFIQM5gSXB3tygtY0PsuutS9UtI3oTv0cDtcO2meVRa6ETqGBMsP5AOF2aC0
         XyO7KVsX7m4SuqSrPB+JpdXM1cAlAoLJ/VwzALaDUMrZnuFY8htdwkSXsrVpd5rn3Yov
         WdEg==
X-Gm-Message-State: AOAM531uFL906zwH+WAQv2zT90bROWM7rGWgLfEcUQ+CpMA/DE2zFnkh
        CARuWzvAbJo6REEv6/EoDV7fhBLevXHwEzRX/ojCmztyLgzzHTqqxfamttjCnpTt7dzTqFo9N7b
        8mglM4BdmMGTgjHoXAAyE3nfjJBai7JXW3qPTNGwtAP9JAjNS1RF9lg==
X-Google-Smtp-Source: ABdhPJwj1qMxuUlFL+jQje/M74F6nelIa1299Lsk/ih/8amlHVPTKDJhAZ6YleXy74myNWY3RjAQFpA=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:f763:3448:2567:bf00])
 (user=sdf job=sendgmr) by 2002:a25:21c3:0:b0:64a:b29a:9b0d with SMTP id
 h186-20020a2521c3000000b0064ab29a9b0dmr1809605ybh.59.1652914544190; Wed, 18
 May 2022 15:55:44 -0700 (PDT)
Date:   Wed, 18 May 2022 15:55:25 -0700
In-Reply-To: <20220518225531.558008-1-sdf@google.com>
Message-Id: <20220518225531.558008-6-sdf@google.com>
Mime-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
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
 include/uapi/linux/bpf.h |   5 ++
 kernel/bpf/cgroup.c      | 103 +++++++++++++++++++++++++++------------
 kernel/bpf/syscall.c     |   4 +-
 3 files changed, 81 insertions(+), 31 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b9d2d6de63a7..432fc5f49567 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1432,6 +1432,7 @@ union bpf_attr {
 		__u32		attach_flags;
 		__aligned_u64	prog_ids;
 		__u32		prog_cnt;
+		__aligned_u64	prog_attach_flags; /* output: per-program attach_flags */
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
@@ -5911,6 +5912,10 @@ struct bpf_prog_info {
 	__u64 run_cnt;
 	__u64 recursion_misses;
 	__u32 verified_insns;
+	/* BTF ID of the function to attach to within BTF object identified
+	 * by btf_id.
+	 */
+	__u32 attach_btf_func_id;
 } __attribute__((aligned(8)));
 
 struct bpf_map_info {
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index a959cdd22870..08a1015ee09e 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1074,6 +1074,7 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 			      union bpf_attr __user *uattr)
 {
+	__u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
 	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
 	enum bpf_attach_type type = attr->query.attach_type;
 	enum cgroup_bpf_attach_type atype;
@@ -1081,50 +1082,92 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
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
index 5ed2093e51cc..4137583c04a2 100644
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
@@ -4066,6 +4067,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 
 	if (prog->aux->btf)
 		info.btf_id = btf_obj_id(prog->aux->btf);
+	info.attach_btf_func_id = prog->aux->attach_btf_id;
 
 	ulen = info.nr_func_info;
 	info.nr_func_info = prog->aux->func_info_cnt;
-- 
2.36.1.124.g0e6072fb45-goog

