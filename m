Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F682635EA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgIISY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgIISYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:24:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBCAC061786
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:24:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s3so3065146ybi.18
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 11:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Kp0FBrpofhNJI+kmmwHfi2Nq63x0XIfSCSb00FSkJPA=;
        b=afXZik5cfyiAAg4USSINaxi07eTcXvUFDvmzMlaDDJ69cxoQ8TqAy8YUwqmzPn5Zrc
         MvInKeEjqhq7jyCwSZO9Dw7xolMNyyZTyZ3abQn0/InrVHnEiUAUgP7fDMlvCCu7EWsb
         O0L0jdU4aZyxJlWV0x808jRMdGYpTdOLk7j1fQF8KQ4O+gdVfn9KpUOOH2HQFKIe/nZ+
         D2nruda2SA8Vd3tNw4+6S/OZCHZmTSutViGTiO3uRn13XeB6RlR7bjH4Y79FL33CoLDA
         5i6xQx5R/95i4uKxajUD57/M/pd1Qu6/oANb6K8uvXnXYeGH4UQXedigrbEctBSWXeV8
         o3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Kp0FBrpofhNJI+kmmwHfi2Nq63x0XIfSCSb00FSkJPA=;
        b=ZECSzpqQMRIDYbVN/Y+QQxbUg8e0rtq1T2mfS3YAzfC/PdEW8mEuXtgNSN1g+1Eupd
         nnn3ZufG1LSxBWmkZSvTcGZe67uCTggLYQaCOGxFahI4n9sqNrNCPC/iM9O5u47VLht7
         yN1BFqm+GuqyyYUN0D/s/M+FxEW+xzYN8PySTuCO2bE2M7uxEApelMTa1WezwL+Dic3J
         L63V0gbfoJjDL1ynWPXmLUOUUPViD35cP22u68S57t4e5jjmDHlwNG0HpVl88KusisET
         3s/Q4rCO/psm30RGQHbou2DEtoA6VWmMOf+ziq1s2MnK3MqOhTr+W4dItdolFOy+Uq0I
         tmqw==
X-Gm-Message-State: AOAM530vvL/Q3fySP/R0cPlnvI5qmVo4MyXZxH4sINS+v6OItj5fVLv2
        jHlGhcCK+XC4AIi1+KXf8s0b0Vgr/6n7ZxtEhv+BaqvUe8wxy7lE99iDGue2Er/NEcqS6aajnzP
        z2Gzqd2iqNkliGjiMMEVZpkjQrs57H8ldD4PIfLhmnVgM+UtnmzcqBA==
X-Google-Smtp-Source: ABdhPJzdQl/DtmvRdisK6Z1bgExtHgErmst9kwdRUu1Taswo9nYt99YEmvxDUscE5M+j96/rOv1cMh0=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:d348:: with SMTP id e69mr7964941ybf.273.1599675853854;
 Wed, 09 Sep 2020 11:24:13 -0700 (PDT)
Date:   Wed,  9 Sep 2020 11:24:04 -0700
In-Reply-To: <20200909182406.3147878-1-sdf@google.com>
Message-Id: <20200909182406.3147878-4-sdf@google.com>
Mime-Version: 1.0
References: <20200909182406.3147878-1-sdf@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v4 3/5] libbpf: Add BPF_PROG_BIND_MAP syscall and use
 it on .metadata section
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YiFei Zhu <zhuyifei@google.com>

The patch adds a simple wrapper bpf_prog_bind_map around the syscall.
When the libbpf tries to load a program, it will probe the kernel for
the support of this syscall and unconditionally bind .rodata section
to the program.

Cc: YiFei Zhu <zhuyifei1999@gmail.com>
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/bpf.c      | 13 ++++++
 tools/lib/bpf/bpf.h      |  8 ++++
 tools/lib/bpf/libbpf.c   | 94 ++++++++++++++++++++++++++++++++--------
 tools/lib/bpf/libbpf.map |  1 +
 4 files changed, 98 insertions(+), 18 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 82b983ff6569..5f6c5676cc45 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -872,3 +872,16 @@ int bpf_enable_stats(enum bpf_stats_type type)
 
 	return sys_bpf(BPF_ENABLE_STATS, &attr, sizeof(attr));
 }
+
+int bpf_prog_bind_map(int prog_fd, int map_fd,
+		      const struct bpf_prog_bind_opts *opts)
+{
+	union bpf_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.prog_bind_map.prog_fd = prog_fd;
+	attr.prog_bind_map.map_fd = map_fd;
+	attr.prog_bind_map.flags = OPTS_GET(opts, flags, 0);
+
+	return sys_bpf(BPF_PROG_BIND_MAP, &attr, sizeof(attr));
+}
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 015d13f25fcc..8c1ac4b42f90 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -243,6 +243,14 @@ LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf,
 enum bpf_stats_type; /* defined in up-to-date linux/bpf.h */
 LIBBPF_API int bpf_enable_stats(enum bpf_stats_type type);
 
+struct bpf_prog_bind_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	__u32 flags;
+};
+#define bpf_prog_bind_opts__last_field flags
+
+LIBBPF_API int bpf_prog_bind_map(int prog_fd, int map_fd,
+				 const struct bpf_prog_bind_opts *opts);
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 550950eb1860..f500ae7e9126 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -174,6 +174,8 @@ enum kern_feature_id {
 	FEAT_EXP_ATTACH_TYPE,
 	/* bpf_probe_read_{kernel,user}[_str] helpers */
 	FEAT_PROBE_READ_KERN,
+	/* BPF_PROG_BIND_MAP is supported */
+	FEAT_PROG_BIND_MAP,
 	__FEAT_CNT,
 };
 
@@ -409,6 +411,7 @@ struct bpf_object {
 	struct extern_desc *externs;
 	int nr_extern;
 	int kconfig_map_idx;
+	int rodata_map_idx;
 
 	bool loaded;
 	bool has_subcalls;
@@ -1070,6 +1073,7 @@ static struct bpf_object *bpf_object__new(const char *path,
 	obj->efile.bss_shndx = -1;
 	obj->efile.st_ops_shndx = -1;
 	obj->kconfig_map_idx = -1;
+	obj->rodata_map_idx = -1;
 
 	obj->kern_version = get_kernel_version();
 	obj->loaded = false;
@@ -1428,6 +1432,8 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
 						    obj->efile.rodata->d_size);
 		if (err)
 			return err;
+
+		obj->rodata_map_idx = obj->nr_maps - 1;
 	}
 	if (obj->efile.bss_shndx >= 0) {
 		err = bpf_object__init_internal_map(obj, LIBBPF_MAP_BSS,
@@ -3729,18 +3735,13 @@ static int probe_kern_prog_name(void)
 	return probe_fd(ret);
 }
 
-static int probe_kern_global_data(void)
+static void probe_create_global_data(int *prog, int *map,
+				     struct bpf_insn *insns, size_t insns_cnt)
 {
 	struct bpf_load_program_attr prg_attr;
 	struct bpf_create_map_attr map_attr;
 	char *cp, errmsg[STRERR_BUFSIZE];
-	struct bpf_insn insns[] = {
-		BPF_LD_MAP_VALUE(BPF_REG_1, 0, 16),
-		BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 42),
-		BPF_MOV64_IMM(BPF_REG_0, 0),
-		BPF_EXIT_INSN(),
-	};
-	int ret, map;
+	int err;
 
 	memset(&map_attr, 0, sizeof(map_attr));
 	map_attr.map_type = BPF_MAP_TYPE_ARRAY;
@@ -3748,26 +3749,40 @@ static int probe_kern_global_data(void)
 	map_attr.value_size = 32;
 	map_attr.max_entries = 1;
 
-	map = bpf_create_map_xattr(&map_attr);
-	if (map < 0) {
-		ret = -errno;
-		cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
+	*map = bpf_create_map_xattr(&map_attr);
+	if (*map < 0) {
+		err = errno;
+		cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
 		pr_warn("Error in %s():%s(%d). Couldn't create simple array map.\n",
-			__func__, cp, -ret);
-		return ret;
+			__func__, cp, -err);
+		return;
 	}
 
-	insns[0].imm = map;
+	insns[0].imm = *map;
 
 	memset(&prg_attr, 0, sizeof(prg_attr));
 	prg_attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
 	prg_attr.insns = insns;
-	prg_attr.insns_cnt = ARRAY_SIZE(insns);
+	prg_attr.insns_cnt = insns_cnt;
 	prg_attr.license = "GPL";
 
-	ret = bpf_load_program_xattr(&prg_attr, NULL, 0);
+	*prog = bpf_load_program_xattr(&prg_attr, NULL, 0);
+}
+
+static int probe_kern_global_data(void)
+{
+	struct bpf_insn insns[] = {
+		BPF_LD_MAP_VALUE(BPF_REG_1, 0, 16),
+		BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 42),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+	int prog = -1, map = -1;
+
+	probe_create_global_data(&prog, &map, insns, ARRAY_SIZE(insns));
+
 	close(map);
-	return probe_fd(ret);
+	return probe_fd(prog);
 }
 
 static int probe_kern_btf(void)
@@ -3894,6 +3909,32 @@ static int probe_kern_probe_read_kernel(void)
 	return probe_fd(bpf_load_program_xattr(&attr, NULL, 0));
 }
 
+static int probe_prog_bind_map(void)
+{
+	struct bpf_insn insns[] = {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+	int prog = -1, map = -1, ret = 0;
+
+	if (!kernel_supports(FEAT_GLOBAL_DATA))
+		return 0;
+
+	probe_create_global_data(&prog, &map, insns, ARRAY_SIZE(insns));
+
+	if (map >= 0 && prog < 0) {
+		close(map);
+		return 0;
+	}
+
+	if (!bpf_prog_bind_map(prog, map, NULL))
+		ret = 1;
+
+	close(map);
+	close(prog);
+	return ret;
+}
+
 enum kern_feature_result {
 	FEAT_UNKNOWN = 0,
 	FEAT_SUPPORTED = 1,
@@ -3934,6 +3975,9 @@ static struct kern_feature_desc {
 	},
 	[FEAT_PROBE_READ_KERN] = {
 		"bpf_probe_read_kernel() helper", probe_kern_probe_read_kernel,
+	},
+	[FEAT_PROG_BIND_MAP] = {
+		"BPF_PROG_BIND_MAP support", probe_prog_bind_map,
 	}
 };
 
@@ -6468,6 +6512,20 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	if (ret >= 0) {
 		if (log_buf && load_attr.log_level)
 			pr_debug("verifier log:\n%s", log_buf);
+
+		if (prog->obj->rodata_map_idx >= 0 &&
+		    kernel_supports(FEAT_PROG_BIND_MAP)) {
+			struct bpf_map *rodata_map =
+				&prog->obj->maps[prog->obj->rodata_map_idx];
+
+			if (bpf_prog_bind_map(ret, bpf_map__fd(rodata_map), NULL)) {
+				cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
+				pr_warn("prog '%s': failed to bind .rodata map: %s\n",
+					prog->name, cp);
+				/* Don't fail hard if can't bind rodata. */
+			}
+		}
+
 		*pfd = ret;
 		ret = 0;
 		goto out;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 92ceb48a5ca2..0b7830f4ff8b 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -308,4 +308,5 @@ LIBBPF_0.2.0 {
 		perf_buffer__epoll_fd;
 		perf_buffer__consume_buffer;
 		xsk_socket__create_shared;
+		bpf_prog_bind_map;
 } LIBBPF_0.1.0;
-- 
2.28.0.526.ge36021eeef-goog

