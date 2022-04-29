Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF93515692
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbiD2VT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236410AbiD2VTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:19:15 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B471178916
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:15:55 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2dc7bdd666fso85278687b3.7
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=X2Cg854Oom7fwXXWuPGII556CBoUddkSPG7ZUUP7Sik=;
        b=tLy/KXwStr8wHDdcFdUc0cmdAf4v/x4WaPv/T8SWsV0fyg9MqTIGfEmkC2X4j/dvt+
         g32VESX6y42KvsJCt54Bg5z34IsS4xTg8leco2JA2irdVAjHzVoyp2ABrlWI5lESrZ65
         7zS9uhX0A9UcsLrhVE1VTdYGw89Le6DIJfz9dUYsAqHUVpif2dD5NNkoA08yBAxoWlYr
         pHkF9H9gNYTnWanX+4ZVlEyUC/jkxTuK8Cxc6k3ybkiY17HlhdHGIpMdHSOtfabbF4at
         +Lf//p+DIruwLp9VCuCm3iqhIA8uaSZPa52R+v1yIEyLWGB1g+og5z2GKTiefhJtIBYx
         FP4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=X2Cg854Oom7fwXXWuPGII556CBoUddkSPG7ZUUP7Sik=;
        b=vQpfqDHUvPC8GWde08Atn2T+sbbAFkt2E+IQ/j8ehPSHzf8JaZvmcQTR6kH1UzmiJB
         At536XC2+vX2EzTEKPOgrxx+KKTJJzrDWB8qR5OhmAbBOKHqy1vj3sKIJBIYoiema67M
         ICQJOqS2RSSLvGAsNgDAWT2JOJiECniRlViDstfYf1cTeANTGmF1blBNmXaWl9xtu6Qb
         6khXAEObkBL14+gvbiuR8+LCoavMsVrA3Vs/8NfLfly4uD5GtmD42phHgWwRTrq/h3Rg
         0wNapEhQDBcUPBw3XbxhkCkUo16u9FJ+CndQkgjn+y7U0ZLVpqYO1uhyJGX5RxnBhMQV
         SJCw==
X-Gm-Message-State: AOAM531cqtEuGvToi2k65SdoWJjs5XSRM4/nz0XaEvur1fFzk5QYdGHj
        YxTHyofxImkQnIBaJQW/mGPbgXUYbWEs66DQM9HOaxXImJIRJp4mjZfR2IQ3ePJebJw9UmcySAJ
        5RMqn6O0GjuUJh1ZibB01cCcPasrDOMHmaNC06Y9EWxkzBAdsQkhnUg==
X-Google-Smtp-Source: ABdhPJz9lEggw7/UYJuxdjPk5ftI+jGASrwoc3V9aHmILnQq/kBfmOV0uozy93WEm/lrakGLJ6I4XqU=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:b0cc:7605:1029:2d96])
 (user=sdf job=sendgmr) by 2002:a25:40c9:0:b0:645:71c9:b3a1 with SMTP id
 n192-20020a2540c9000000b0064571c9b3a1mr1378923yba.557.1651266954910; Fri, 29
 Apr 2022 14:15:54 -0700 (PDT)
Date:   Fri, 29 Apr 2022 14:15:35 -0700
In-Reply-To: <20220429211540.715151-1-sdf@google.com>
Message-Id: <20220429211540.715151-6-sdf@google.com>
Mime-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH bpf-next v6 05/10] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have two options:
1. Treat all BPF_LSM_CGROUP as the same, regardless of attach_btf_id
2. Treat BPF_LSM_CGROUP+attach_btf_id as a separate hook point

I'm doing (2) here and adding attach_btf_id as a new BPF_PROG_QUERY
argument. The downside is that it requires iterating over all possible
bpf_lsm_ hook points in the userspace which might take some time.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/cgroup.c            | 43 ++++++++++++++++++++++++----------
 kernel/bpf/syscall.c           |  3 ++-
 tools/include/uapi/linux/bpf.h |  1 +
 tools/lib/bpf/bpf.c            | 42 ++++++++++++++++++++++++++-------
 tools/lib/bpf/bpf.h            | 15 ++++++++++++
 tools/lib/bpf/libbpf.map       |  1 +
 7 files changed, 85 insertions(+), 21 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 112e396bbe65..e38ea0b47b6a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1431,6 +1431,7 @@ union bpf_attr {
 		__u32		attach_flags;
 		__aligned_u64	prog_ids;
 		__u32		prog_cnt;
+		__u32		attach_btf_id;	/* for BPF_LSM_CGROUP */
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 787ff6cf8d42..0add465c06b9 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1051,9 +1051,15 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	int cnt, ret = 0, i;
 	u32 flags;
 
-	atype = to_cgroup_bpf_attach_type(type);
-	if (atype < 0)
-		return -EINVAL;
+	if (type == BPF_LSM_CGROUP) {
+		atype = bpf_lsm_attach_type_get(attr->query.attach_btf_id);
+		if (atype < 0)
+			return atype;
+	} else {
+		atype = to_cgroup_bpf_attach_type(type);
+		if (atype < 0)
+			return -EINVAL;
+	}
 
 	progs = &cgrp->bpf.progs[atype];
 	flags = cgrp->bpf.flags[atype];
@@ -1066,20 +1072,26 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	else
 		cnt = prog_list_length(progs);
 
-	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
-		return -EFAULT;
-	if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
-		return -EFAULT;
-	if (attr->query.prog_cnt == 0 || !prog_ids || !cnt)
+	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags))) {
+		ret = -EFAULT;
+		goto cleanup_attach_type;
+	}
+	if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt))) {
+		ret = -EFAULT;
+		goto cleanup_attach_type;
+	}
+	if (attr->query.prog_cnt == 0 || !prog_ids || !cnt) {
 		/* return early if user requested only program count + flags */
-		return 0;
+		ret = 0;
+		goto cleanup_attach_type;
+	}
 	if (attr->query.prog_cnt < cnt) {
 		cnt = attr->query.prog_cnt;
 		ret = -ENOSPC;
 	}
 
 	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
-		return bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
+		ret = bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
 	} else {
 		struct bpf_prog_list *pl;
 		u32 id;
@@ -1088,12 +1100,19 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		hlist_for_each_entry(pl, progs, node) {
 			prog = prog_list_prog(pl);
 			id = prog->aux->id;
-			if (copy_to_user(prog_ids + i, &id, sizeof(id)))
-				return -EFAULT;
+			if (copy_to_user(prog_ids + i, &id, sizeof(id))) {
+				ret = -EFAULT;
+				goto cleanup_attach_type;
+			}
 			if (++i == cnt)
 				break;
 		}
 	}
+
+cleanup_attach_type:
+	if (type == BPF_LSM_CGROUP)
+		bpf_lsm_attach_type_put(attr->query.attach_btf_id);
+
 	return ret;
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 53fe0ae9f8cf..cdf1937b71ca 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3525,7 +3525,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	}
 }
 
-#define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
+#define BPF_PROG_QUERY_LAST_FIELD query.attach_btf_id
 
 static int bpf_prog_query(const union bpf_attr *attr,
 			  union bpf_attr __user *uattr)
@@ -3561,6 +3561,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_SYSCTL:
 	case BPF_CGROUP_GETSOCKOPT:
 	case BPF_CGROUP_SETSOCKOPT:
+	case BPF_LSM_CGROUP:
 		return cgroup_bpf_prog_query(attr, uattr);
 	case BPF_LIRC_MODE2:
 		return lirc_prog_query(attr, uattr);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 112e396bbe65..e38ea0b47b6a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1431,6 +1431,7 @@ union bpf_attr {
 		__u32		attach_flags;
 		__aligned_u64	prog_ids;
 		__u32		prog_cnt;
+		__u32		attach_btf_id;	/* for BPF_LSM_CGROUP */
 	} query;
 
 	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index a9d292c106c2..f62823451b99 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -946,28 +946,54 @@ int bpf_iter_create(int link_fd)
 	return libbpf_err_errno(fd);
 }
 
-int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
-		   __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
+int bpf_prog_query2(int target_fd,
+		    enum bpf_attach_type type,
+		    struct bpf_prog_query_opts *opts)
 {
 	union bpf_attr attr;
 	int ret;
 
 	memset(&attr, 0, sizeof(attr));
+
+	if (!OPTS_VALID(opts, bpf_prog_query_opts))
+		return libbpf_err(-EINVAL);
+
 	attr.query.target_fd	= target_fd;
 	attr.query.attach_type	= type;
-	attr.query.query_flags	= query_flags;
-	attr.query.prog_cnt	= *prog_cnt;
-	attr.query.prog_ids	= ptr_to_u64(prog_ids);
+	attr.query.query_flags	= OPTS_GET(opts, query_flags, 0);
+	attr.query.prog_cnt	= OPTS_GET(opts, prog_cnt, 0);
+	attr.query.prog_ids	= ptr_to_u64(OPTS_GET(opts, prog_ids, NULL));
+	attr.query.attach_btf_id = OPTS_GET(opts, attach_btf_id, 0);
 
 	ret = sys_bpf(BPF_PROG_QUERY, &attr, sizeof(attr));
 
-	if (attach_flags)
-		*attach_flags = attr.query.attach_flags;
-	*prog_cnt = attr.query.prog_cnt;
+	if (OPTS_HAS(opts, prog_cnt))
+		opts->prog_cnt = attr.query.prog_cnt;
+	if (OPTS_HAS(opts, attach_flags))
+		opts->attach_flags = attr.query.attach_flags;
 
 	return libbpf_err_errno(ret);
 }
 
+int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
+		   __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
+{
+	LIBBPF_OPTS(bpf_prog_query_opts, p);
+	int ret;
+
+	p.query_flags = query_flags;
+	p.prog_ids = prog_ids;
+	p.prog_cnt = *prog_cnt;
+
+	ret = bpf_prog_query2(target_fd, type, &p);
+
+	if (attach_flags)
+		*attach_flags = p.attach_flags;
+	*prog_cnt = p.prog_cnt;
+
+	return ret;
+}
+
 int bpf_prog_test_run(int prog_fd, int repeat, void *data, __u32 size,
 		      void *data_out, __u32 *size_out, __u32 *retval,
 		      __u32 *duration)
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index f4b4afb6d4ba..6b1ff77ac984 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -480,9 +480,24 @@ LIBBPF_API int bpf_map_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_btf_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_link_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_obj_get_info_by_fd(int bpf_fd, void *info, __u32 *info_len);
+
+struct bpf_prog_query_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	__u32 query_flags;
+	__u32 attach_flags; /* output argument */
+	__u32 *prog_ids;
+	__u32 prog_cnt; /* input+output argument */
+	__u32 attach_btf_id;
+};
+#define bpf_prog_query_opts__last_field attach_btf_id
+
+LIBBPF_API int bpf_prog_query2(int target_fd,
+			       enum bpf_attach_type type,
+			       struct bpf_prog_query_opts *opts);
 LIBBPF_API int bpf_prog_query(int target_fd, enum bpf_attach_type type,
 			      __u32 query_flags, __u32 *attach_flags,
 			      __u32 *prog_ids, __u32 *prog_cnt);
+
 LIBBPF_API int bpf_raw_tracepoint_open(const char *name, int prog_fd);
 LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf,
 				 __u32 *buf_len, __u32 *prog_id, __u32 *fd_type,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b5bc84039407..5e5bb3e437cc 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -450,4 +450,5 @@ LIBBPF_0.8.0 {
 		bpf_program__attach_usdt;
 		libbpf_register_prog_handler;
 		libbpf_unregister_prog_handler;
+		bpf_prog_query2;
 } LIBBPF_0.7.0;
-- 
2.36.0.464.gb9c8b46e94-goog

