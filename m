Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE2B41D048
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347815AbhI3ABX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347392AbhI3ABR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:01:17 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32B2C06161C;
        Wed, 29 Sep 2021 16:59:35 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 66so3992370pgc.9;
        Wed, 29 Sep 2021 16:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JIw+Y+DTysQH7IehrMLsYxxL0MIr+/Ahsscemw7/EJU=;
        b=YpW6abztrYEGLLouXdE6fFRRjGSGlSNfHFcND79FHdP0xAebFNHExGuX0JGhgyJHEw
         aVA1+JUQYZ63z/2tedut8gWu0CJGxL89Edrn15iL9SuihsjLb0VzMs9c+Rf9Si7pM8/k
         x4TkCNbS/SWBoeudUQQzS56MFKUTmhajg65cqE7PVrEKrGkMr+h453v1+GUBJmQA0GJ8
         DvYZ9yZp8TLLXd7KI+SABLN1qNAli1wQCV06JLE+kPRNbIGUGhvMyPjpXc0Bt1gxvZ8o
         jkLYN9XNvjDQ0aTGWBZIBEct//WWcv0OfzU4gT/nFX93lgFgsClvtqVd0wunV85Mmb2j
         YTFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JIw+Y+DTysQH7IehrMLsYxxL0MIr+/Ahsscemw7/EJU=;
        b=Q3+QjOS+o98Eh3Hj/VGSlozou1ZQPqJoYrVuwfi0Ib24SwxAJde1oQxOtUUIDOpgJ9
         xpxz3MbfjMWGCspNQX0Sn56Na+g9NmypYN4BHOyBnSCmUm+D6+mljfkVFj8Zr/PHvuHY
         dM78f7Yb/uu+ZWqX2PZRQhAgz+AFyEVrflvKy3qcNAwlH6tXRtCNvHvjG6r0YZcxs++J
         tuVMSynnmj9A1RgXn9N/J7VmTNJZoTlrolwvClXObAlBZu0qFHQ/zZvzEQyWLGdNDTkb
         cBhO5eaEUvskgSm9mqSzzK18ltms+bIe1uJzwdMd+Pircimy7Sbfd6vKvkXBFVyuDdRs
         baAA==
X-Gm-Message-State: AOAM533AFj+O8USUGfiv/TV1VGjWwZVP4dGGL9Ek6MZNXDp/HD1yIdgc
        OjDsn0I8xxd7PmeKHcShMQ==
X-Google-Smtp-Source: ABdhPJyjt+suW77j4cG5gLmsKsYkZX1s1VL6pHV4rn/OaecjCLJovJd1kf0aowBPVhCra2ljOT9OBQ==
X-Received: by 2002:a63:b04c:: with SMTP id z12mr2237956pgo.371.1632959975292;
        Wed, 29 Sep 2021 16:59:35 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mr18sm681907pjb.17.2021.09.29.16.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:59:35 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v2 05/13] bpf: Enable creation of BPF_LINK_TYPE_MAP_TRACE
Date:   Wed, 29 Sep 2021 23:59:02 +0000
Message-Id: <20210929235910.1765396-6-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Add new link type, BPF_LINK_TYPE_MAP_TRACE. This link attaches map
tracing programs to maps. At attachment time, the program's read-write
accesses are verified against the map's key/value size.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 include/linux/bpf.h       |   2 +
 include/linux/bpf_types.h |   1 +
 include/uapi/linux/bpf.h  |  12 ++++
 kernel/bpf/map_trace.c    | 147 ++++++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c      |   3 +
 5 files changed, 165 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3ae12ab97720..6f7aeeedca07 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1557,6 +1557,8 @@ const struct bpf_func_proto *
 bpf_iter_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog);
 bool bpf_map_trace_prog_supported(struct bpf_prog *prog);
 int bpf_map_trace_reg_target(const struct bpf_map_trace_reg *reg_info);
+int bpf_map_trace_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
+			      struct bpf_prog *prog);
 int bpf_iter_link_attach(const union bpf_attr *attr, bpfptr_t uattr, struct bpf_prog *prog);
 int bpf_iter_new_fd(struct bpf_link *link);
 bool bpf_link_is_iter(struct bpf_link *link);
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 9c81724e4b98..074153968b00 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -139,3 +139,4 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_XDP, xdp)
 #ifdef CONFIG_PERF_EVENTS
 BPF_LINK_TYPE(BPF_LINK_TYPE_PERF_EVENT, perf)
 #endif
+BPF_LINK_TYPE(BPF_LINK_TYPE_MAP_TRACE, map_trace)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0883c5dfb5d8..3d5d3dafc066 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -100,6 +100,11 @@ enum bpf_map_trace_type {
 	MAX_BPF_MAP_TRACE_TYPE,
 };
 
+struct bpf_map_trace_link_info {
+	__u32   map_fd;
+	enum bpf_map_trace_type trace_type;
+};
+
 #define BPF_MAP_TRACE_FUNC(trace_type) "bpf_map_trace__" #trace_type
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
@@ -1018,6 +1023,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_MAP_TRACE = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1465,6 +1471,12 @@ union bpf_attr {
 				 */
 				__u64		bpf_cookie;
 			} perf_event;
+			struct {
+				/* extra bpf_map_trace_link_info */
+				__aligned_u64	map_trace_info;
+				/* map_trace_info length */
+				__u32		map_trace_info_len;
+			};
 		};
 	} link_create;
 
diff --git a/kernel/bpf/map_trace.c b/kernel/bpf/map_trace.c
index 35906d59ba3c..ed0cbc941522 100644
--- a/kernel/bpf/map_trace.c
+++ b/kernel/bpf/map_trace.c
@@ -148,3 +148,150 @@ static const struct bpf_link_ops bpf_map_trace_link_ops = {
 	.update_prog = bpf_map_trace_link_replace,
 };
 
+int bpf_map_attach_trace(struct bpf_prog *prog,
+			 struct bpf_map *map,
+			 struct bpf_map_trace_link_info *linfo)
+{
+	u32 key_acc_size, value_acc_size, key_size, value_size;
+	struct bpf_map_trace_progs *trace_progs;
+	struct bpf_map_trace_prog *trace_prog;
+	bool is_percpu = false;
+	int err = -EINVAL;
+
+	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
+	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH ||
+	    map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
+		is_percpu = true;
+	else if (map->map_type != BPF_MAP_TYPE_HASH &&
+		 map->map_type != BPF_MAP_TYPE_LRU_HASH &&
+		 map->map_type != BPF_MAP_TYPE_ARRAY)
+		goto put_map;
+
+	key_acc_size = prog->aux->max_rdonly_access;
+	value_acc_size = prog->aux->max_rdwr_access;
+	key_size = map->key_size;
+	if (!is_percpu)
+		value_size = map->value_size;
+	else
+		value_size = round_up(map->value_size, 8) * num_possible_cpus();
+
+	if (key_acc_size > key_size || value_acc_size > value_size) {
+		err = -EACCES;
+		goto put_map;
+	}
+
+	trace_prog = kmalloc(sizeof(*trace_prog), GFP_KERNEL);
+	if (!trace_prog) {
+		err = -ENOMEM;
+		goto put_map;
+	}
+	INIT_LIST_HEAD(&trace_prog->list);
+	trace_prog->prog = prog;
+
+	err = bpf_map_initialize_trace_progs(map);
+	if (err)
+		goto put_map;
+
+	trace_progs = map->trace_progs;
+	mutex_lock(&trace_progs->mutex);
+	if (trace_progs->length[linfo->trace_type] >= BPF_MAP_TRACE_MAX_PROGS)
+		err = -E2BIG;
+	else {
+		err = 0;
+		trace_progs->length[linfo->trace_type] += 1;
+		list_add_tail_rcu(&trace_prog->list,
+				  &trace_progs->progs[linfo->trace_type].list);
+	}
+	mutex_unlock(&trace_progs->mutex);
+
+	return err;
+
+put_map:
+	bpf_map_put_with_uref(map);
+	return err;
+}
+
+int bpf_map_trace_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
+			      struct bpf_prog *prog)
+{
+	struct bpf_map_trace_target_info *tinfo;
+	struct bpf_map_trace_link_info linfo;
+	struct bpf_link_primer link_primer;
+	struct bpf_map_trace_link *link;
+	u32 prog_btf_id, linfo_len;
+	bool existed = false;
+	struct bpf_map *map;
+	bpfptr_t ulinfo;
+	int err;
+
+	if (attr->link_create.target_fd || attr->link_create.flags)
+		return -EINVAL;
+
+	memset(&linfo, 0, sizeof(struct bpf_map_trace_link_info));
+
+	ulinfo = make_bpfptr(attr->link_create.map_trace_info,
+			     uattr.is_kernel);
+	linfo_len = attr->link_create.iter_info_len;
+	if (bpfptr_is_null(ulinfo) || !linfo_len)
+		return -EINVAL;
+
+	err = bpf_check_uarg_tail_zero(ulinfo, sizeof(linfo),
+				       linfo_len);
+	if (err)
+		return err;
+	linfo_len = min_t(u32, linfo_len, sizeof(linfo));
+	if (copy_from_bpfptr(&linfo, ulinfo, linfo_len))
+		return -EFAULT;
+
+	if (!linfo.map_fd)
+		return -EBADF;
+
+	prog_btf_id = prog->aux->attach_btf_id;
+	mutex_lock(&targets_mutex);
+	list_for_each_entry(tinfo, &targets, list) {
+		if (tinfo->btf_id == prog_btf_id) {
+			existed = true;
+			break;
+		}
+	}
+	mutex_unlock(&targets_mutex);
+	if (!existed)
+		return -ENOENT;
+
+	map = bpf_map_get_with_uref(linfo.map_fd);
+	if (IS_ERR(map))
+		return PTR_ERR(map);
+	if (tinfo->reg_info->trace_type != linfo.trace_type) {
+		err = -EINVAL;
+		goto map_put;
+	}
+
+	link = kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);
+	if (!link) {
+		err = -ENOMEM;
+		goto map_put;
+	}
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_MAP_TRACE,
+		      &bpf_map_trace_link_ops, prog);
+	link->tinfo = tinfo;
+	link->map = map;
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err) {
+		kfree(link);
+		goto map_put;
+	}
+
+	err = bpf_map_attach_trace(prog, map, &linfo);
+	if (err) {
+		bpf_link_cleanup(&link_primer);
+		goto map_put;
+	}
+
+	return bpf_link_settle(&link_primer);
+map_put:
+	bpf_map_put_with_uref(map);
+	return err;
+}
+
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e6179755fd3b..dd71853a858f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3136,6 +3136,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 	case BPF_CGROUP_SETSOCKOPT:
 		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
 	case BPF_TRACE_ITER:
+	case BPF_TRACE_MAP:
 		return BPF_PROG_TYPE_TRACING;
 	case BPF_SK_LOOKUP:
 		return BPF_PROG_TYPE_SK_LOOKUP;
@@ -4192,6 +4193,8 @@ static int tracing_bpf_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 
 	if (prog->expected_attach_type == BPF_TRACE_ITER)
 		return bpf_iter_link_attach(attr, uattr, prog);
+	else if (prog->expected_attach_type == BPF_TRACE_MAP)
+		return bpf_map_trace_link_attach(attr, uattr, prog);
 	else if (prog->type == BPF_PROG_TYPE_EXT)
 		return bpf_tracing_prog_attach(prog,
 					       attr->link_create.target_fd,
-- 
2.33.0.685.g46640cef36-goog

