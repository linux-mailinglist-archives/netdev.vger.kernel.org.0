Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DBD269508
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgINShz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgINSgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:36:25 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365D6C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 11:36:25 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id q5so314031pfl.16
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 11:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=jqsc+1d2ynBuBqET+rkKoXJHN1R2Af7JEusEUeR6x9I=;
        b=E1/s6+lbfZ9KGbZcqp9LYf2HG9JFQ/s6uMO4OucTpDYUOol+ffV08+DB74ivwNhbXK
         9DvNUEYYtbJigLt7k6CV4T3lHwFYszMr75Qx8xJVpu4GX9Ob9bLkVpvCgzaRWqkce940
         VoENTVDP2+NXmOiJukn1Qxp5HyrjTZHkJ+3MlbM502EW+RcqczILRjANDIqK9aoR62DJ
         W1XZBugqbJ6xBno/TcR0sZ5owmE18ABVgho61kc3yjsgKUYRo3phxx71XxLTJPj+Wgi4
         f0YIdzx74iijLQNHPR9f2yqo2J9TOBP2BcVDJX9uZaNmfWpsrKgNQvXlz0sdD8/tzfh3
         Earg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jqsc+1d2ynBuBqET+rkKoXJHN1R2Af7JEusEUeR6x9I=;
        b=Hsfrlj6scpOv6L8R5EJoq+ExsI9EHy9jSZ26cntuYS4Hq93bXzmLXBqb7dd2StxRZp
         rfIU0F00LllSwBRq9IjrouOowH6y8i9Y3qugTFGhQgp1Xvjgg0Q8UYomiflfNFOH3GUY
         Ebl2gHreT7xqvvDq28joHuBnA2166B6LAnrANCAKktSAi3vv6UoyYAE6hHuJVDdai9zP
         gHyUbZ7jVCyk6gvr/RfU8MVg/1DiQsy99F/wdOZSNvj35iHU+JDItAY4fISdfxPulCHk
         uGYhaJNBEmK6eiYtHBI1xlLmbp2LHoPZ89JiWOorfq5avSOUgg6lU2GiOsr9eVh0bZHS
         ya/Q==
X-Gm-Message-State: AOAM532RpM+4YrYMTVjAtjOaUCnnY2CocxAI+KBQLTf7p2tgw0IvWkEI
        PcQuXf5SyVSx7NEU9PmxmvItdQl6hb+XHGr6qNJ+89Fvpu9/p7u2UgZyn+kwg6HB1JQ6YilCR12
        mDLogK1FoW7H1Hy5uFwqeVNlZcc6cL1CsFn+6JVNa+hbda7gn/uQdGg==
X-Google-Smtp-Source: ABdhPJwE120pXjv27VS9DhC/+c5eROjsa4niAXganasQ9i8N010Jt3x/tw5jFq4+ZhkYEq+pxJ8ZG2M=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a17:90a:7ac1:: with SMTP id
 b1mr599998pjl.121.1600108582911; Mon, 14 Sep 2020 11:36:22 -0700 (PDT)
Date:   Mon, 14 Sep 2020 11:36:13 -0700
In-Reply-To: <20200914183615.2038347-1-sdf@google.com>
Message-Id: <20200914183615.2038347-4-sdf@google.com>
Mime-Version: 1.0
References: <20200914183615.2038347-1-sdf@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH bpf-next v5 3/5] libbpf: Add BPF_PROG_BIND_MAP syscall and use
 it on .rodata section
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
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
 tools/lib/bpf/bpf.c      | 16 +++++++++
 tools/lib/bpf/bpf.h      |  8 +++++
 tools/lib/bpf/libbpf.c   | 72 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 4 files changed, 97 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 82b983ff6569..2baa1308737c 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -872,3 +872,19 @@ int bpf_enable_stats(enum bpf_stats_type type)
 
 	return sys_bpf(BPF_ENABLE_STATS, &attr, sizeof(attr));
 }
+
+int bpf_prog_bind_map(int prog_fd, int map_fd,
+		      const struct bpf_prog_bind_opts *opts)
+{
+	union bpf_attr attr;
+
+	if (!OPTS_VALID(opts, bpf_prog_bind_opts))
+		return -EINVAL;
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
index 550950eb1860..b68fa08e2fa9 100644
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
@@ -3894,6 +3900,55 @@ static int probe_kern_probe_read_kernel(void)
 	return probe_fd(bpf_load_program_xattr(&attr, NULL, 0));
 }
 
+static int probe_prog_bind_map(void)
+{
+	struct bpf_load_program_attr prg_attr;
+	struct bpf_create_map_attr map_attr;
+	char *cp, errmsg[STRERR_BUFSIZE];
+	struct bpf_insn insns[] = {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+	int ret, map, prog;
+
+	if (!kernel_supports(FEAT_GLOBAL_DATA))
+		return 0;
+
+	memset(&map_attr, 0, sizeof(map_attr));
+	map_attr.map_type = BPF_MAP_TYPE_ARRAY;
+	map_attr.key_size = sizeof(int);
+	map_attr.value_size = 32;
+	map_attr.max_entries = 1;
+
+	map = bpf_create_map_xattr(&map_attr);
+	if (map < 0) {
+		ret = -errno;
+		cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
+		pr_warn("Error in %s():%s(%d). Couldn't create simple array map.\n",
+			__func__, cp, -ret);
+		return ret;
+	}
+
+	memset(&prg_attr, 0, sizeof(prg_attr));
+	prg_attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
+	prg_attr.insns = insns;
+	prg_attr.insns_cnt = ARRAY_SIZE(insns);
+	prg_attr.license = "GPL";
+
+	prog = bpf_load_program_xattr(&prg_attr, NULL, 0);
+	if (prog < 0) {
+		close(map);
+		return 0;
+	}
+
+	ret = bpf_prog_bind_map(prog, map, NULL);
+
+	close(map);
+	close(prog);
+
+	return ret >= 0;
+}
+
 enum kern_feature_result {
 	FEAT_UNKNOWN = 0,
 	FEAT_SUPPORTED = 1,
@@ -3934,6 +3989,9 @@ static struct kern_feature_desc {
 	},
 	[FEAT_PROBE_READ_KERN] = {
 		"bpf_probe_read_kernel() helper", probe_kern_probe_read_kernel,
+	},
+	[FEAT_PROG_BIND_MAP] = {
+		"BPF_PROG_BIND_MAP support", probe_prog_bind_map,
 	}
 };
 
@@ -6468,6 +6526,20 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
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
index 92ceb48a5ca2..5f054dadf082 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -302,6 +302,7 @@ LIBBPF_0.1.0 {
 
 LIBBPF_0.2.0 {
 	global:
+		bpf_prog_bind_map;
 		bpf_program__section_name;
 		perf_buffer__buffer_cnt;
 		perf_buffer__buffer_fd;
-- 
2.28.0.618.gf4bc123cb7-goog

