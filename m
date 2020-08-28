Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D988F256165
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 21:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgH1Tgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 15:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgH1TgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 15:36:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094EAC061235
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 12:36:12 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 83so327595ybf.2
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 12:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=tDZ6kf3qnF108YJ8FqrzfUCa129eRJXC+UYCuWDM+2Y=;
        b=vhj11wnWyqvvn0AUOrDbZAlHJIETQY1drh4H0GCsZgL9K+0Vvbr9VNRJDQV83xkfkZ
         vwdZIdgt3WIg40J2LV98WyWwOUosSBCw/lmrgbI1gkk5kg7BE+WR2U3k6kl7i1w2xDxf
         nvKBC+o5VKL5oL/oWOsTWlc64ocMAPAJlczMcylvgCDvaUl8TcL4ghUZHqiQMI7yLj+Z
         KYZue7zdmzCNszWeHFok8h2K7kD/CzI4js0offvjYAB6/QrbhUxUzWDvPZ4Niey/HLzq
         eqqUfy8w+y2itze5q7fcoMX4WepeUQ1xyw0XCIPIaE0vDhhWFTcylFfo0X6HLBeDmzke
         GYSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tDZ6kf3qnF108YJ8FqrzfUCa129eRJXC+UYCuWDM+2Y=;
        b=D9tOMxAnQaMdlGGtl4KeJFyG6CGknzoPa4ktKezRvStdezQjCARYoEqlK87qXUuVdV
         DBLnmExFGHNHOAwIDUgomyXzaK66o6vALmOgLt4pC1hAj5LMxzIxKpFzT20pKLdyb3B6
         tnIyBZOfvdWCRHqhbEgHFOVrSqJuoiCj+c0ixeYedLpYg0/8n3Q2hB5EuTqhXovptiOy
         Ar+S+c7fKdr4YnQWSOd+343srgsEGK4IUisgrg2QOo2rKoZU8JDSgpGbtkxtChsGaLYh
         Si54ApGYUqR/kLZr7vZbHucwpRqlfLa5wPpBgNup6pU5eu5vnrJf2SnQPPgqpBHvaUIE
         l+Kg==
X-Gm-Message-State: AOAM5332uQylGXHgR6qiSCXVI4WARUrVUfLiHgjHLAlnDplgvwNuQ5dm
        9Ae9MhS1Xe1M8X7CWilhd724QeO9cL+ZWKi81uDj9Go4p8WwFgJUmDut7uSfFrRsFtaei6IVrI7
        3vfc4zIjXOiwYW+eOQ2MNdJl3FyZdujQpdLHWXQv+ImvlbVe4O0Q1cQ==
X-Google-Smtp-Source: ABdhPJxVz2sA93H+xe6AmLuUpKL4UB6BJzQm75pqqMLQzJpVvHNMcBwFwm+B58NvrZZUEQtRrIf4zpM=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:ab34:: with SMTP id u49mr4553934ybi.516.1598643371155;
 Fri, 28 Aug 2020 12:36:11 -0700 (PDT)
Date:   Fri, 28 Aug 2020 12:35:58 -0700
In-Reply-To: <20200828193603.335512-1-sdf@google.com>
Message-Id: <20200828193603.335512-4-sdf@google.com>
Mime-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH bpf-next v3 3/8] libbpf: Add BPF_PROG_BIND_MAP syscall and use
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
And when using libbpf to load a program, it will probe the kernel for
the support of this syscall, and scan for the .metadata ELF section
and load it as an internal map like a .data section.

In the case that kernel supports the BPF_PROG_BIND_MAP syscall and
a .metadata section exists, the map will be explicitly bound to
the program via the syscall immediately after program is loaded.
-EEXIST is ignored for this syscall.

Cc: YiFei Zhu <zhuyifei1999@gmail.com>
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/bpf.c      |  13 ++++
 tools/lib/bpf/bpf.h      |   8 +++
 tools/lib/bpf/libbpf.c   | 130 ++++++++++++++++++++++++++++++++-------
 tools/lib/bpf/libbpf.map |   1 +
 4 files changed, 131 insertions(+), 21 deletions(-)

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
index 8cdb2528482e..2b21021b66bb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -176,6 +176,8 @@ enum kern_feature_id {
 	FEAT_EXP_ATTACH_TYPE,
 	/* bpf_probe_read_{kernel,user}[_str] helpers */
 	FEAT_PROBE_READ_KERN,
+	/* BPF_PROG_BIND_MAP is supported */
+	FEAT_PROG_BIND_MAP,
 	__FEAT_CNT,
 };
 
@@ -285,6 +287,7 @@ struct bpf_struct_ops {
 #define KCONFIG_SEC ".kconfig"
 #define KSYMS_SEC ".ksyms"
 #define STRUCT_OPS_SEC ".struct_ops"
+#define METADATA_SEC ".metadata"
 
 enum libbpf_map_type {
 	LIBBPF_MAP_UNSPEC,
@@ -292,6 +295,7 @@ enum libbpf_map_type {
 	LIBBPF_MAP_BSS,
 	LIBBPF_MAP_RODATA,
 	LIBBPF_MAP_KCONFIG,
+	LIBBPF_MAP_METADATA,
 };
 
 static const char * const libbpf_type_to_btf_name[] = {
@@ -299,6 +303,7 @@ static const char * const libbpf_type_to_btf_name[] = {
 	[LIBBPF_MAP_BSS]	= BSS_SEC,
 	[LIBBPF_MAP_RODATA]	= RODATA_SEC,
 	[LIBBPF_MAP_KCONFIG]	= KCONFIG_SEC,
+	[LIBBPF_MAP_METADATA]	= METADATA_SEC,
 };
 
 struct bpf_map {
@@ -381,6 +386,7 @@ struct bpf_object {
 	struct extern_desc *externs;
 	int nr_extern;
 	int kconfig_map_idx;
+	int metadata_map_idx;
 
 	bool loaded;
 	bool has_pseudo_calls;
@@ -400,6 +406,7 @@ struct bpf_object {
 		Elf_Data *rodata;
 		Elf_Data *bss;
 		Elf_Data *st_ops_data;
+		Elf_Data *metadata;
 		size_t shstrndx; /* section index for section name strings */
 		size_t strtabidx;
 		struct {
@@ -416,6 +423,7 @@ struct bpf_object {
 		int rodata_shndx;
 		int bss_shndx;
 		int st_ops_shndx;
+		int metadata_shndx;
 	} efile;
 	/*
 	 * All loaded bpf_object is linked in a list, which is
@@ -1027,11 +1035,13 @@ static struct bpf_object *bpf_object__new(const char *path,
 	obj->efile.obj_buf_sz = obj_buf_sz;
 	obj->efile.maps_shndx = -1;
 	obj->efile.btf_maps_shndx = -1;
+	obj->efile.metadata_shndx = -1;
 	obj->efile.data_shndx = -1;
 	obj->efile.rodata_shndx = -1;
 	obj->efile.bss_shndx = -1;
 	obj->efile.st_ops_shndx = -1;
 	obj->kconfig_map_idx = -1;
+	obj->metadata_map_idx = -1;
 
 	obj->kern_version = get_kernel_version();
 	obj->loaded = false;
@@ -1343,7 +1353,8 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
 	def->key_size = sizeof(int);
 	def->value_size = data_sz;
 	def->max_entries = 1;
-	def->map_flags = type == LIBBPF_MAP_RODATA || type == LIBBPF_MAP_KCONFIG
+	def->map_flags = type == LIBBPF_MAP_RODATA || type == LIBBPF_MAP_KCONFIG ||
+			 type == LIBBPF_MAP_METADATA
 			 ? BPF_F_RDONLY_PROG : 0;
 	def->map_flags |= BPF_F_MMAPABLE;
 
@@ -1399,6 +1410,16 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
 		if (err)
 			return err;
 	}
+	if (obj->efile.metadata_shndx >= 0) {
+		err = bpf_object__init_internal_map(obj, LIBBPF_MAP_METADATA,
+						    obj->efile.metadata_shndx,
+						    obj->efile.metadata->d_buf,
+						    obj->efile.metadata->d_size);
+		if (err)
+			return err;
+
+		obj->metadata_map_idx = obj->nr_maps - 1;
+	}
 	return 0;
 }
 
@@ -2790,6 +2811,9 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 			} else if (strcmp(name, STRUCT_OPS_SEC) == 0) {
 				obj->efile.st_ops_data = data;
 				obj->efile.st_ops_shndx = idx;
+			} else if (strcmp(name, METADATA_SEC) == 0) {
+				obj->efile.metadata = data;
+				obj->efile.metadata_shndx = idx;
 			} else {
 				pr_info("elf: skipping unrecognized data section(%d) %s\n",
 					idx, name);
@@ -3201,7 +3225,8 @@ static bool bpf_object__shndx_is_data(const struct bpf_object *obj,
 {
 	return shndx == obj->efile.data_shndx ||
 	       shndx == obj->efile.bss_shndx ||
-	       shndx == obj->efile.rodata_shndx;
+	       shndx == obj->efile.rodata_shndx ||
+	       shndx == obj->efile.metadata_shndx;
 }
 
 static bool bpf_object__shndx_is_maps(const struct bpf_object *obj,
@@ -3222,6 +3247,8 @@ bpf_object__section_to_libbpf_map_type(const struct bpf_object *obj, int shndx)
 		return LIBBPF_MAP_RODATA;
 	else if (shndx == obj->efile.symbols_shndx)
 		return LIBBPF_MAP_KCONFIG;
+	else if (shndx == obj->efile.metadata_shndx)
+		return LIBBPF_MAP_METADATA;
 	else
 		return LIBBPF_MAP_UNSPEC;
 }
@@ -3592,18 +3619,13 @@ static int probe_kern_prog_name(void)
 	return probe_fd(ret);
 }
 
-static int probe_kern_global_data(void)
+static void __probe_create_global_data(int *prog, int *map,
+				       struct bpf_insn *insns, size_t insns_cnt)
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
@@ -3611,26 +3633,40 @@ static int probe_kern_global_data(void)
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
+	__probe_create_global_data(&prog, &map, insns, ARRAY_SIZE(insns));
+
 	close(map);
-	return probe_fd(ret);
+	return probe_fd(prog);
 }
 
 static int probe_kern_btf(void)
@@ -3757,6 +3793,32 @@ static int probe_kern_probe_read_kernel(void)
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
+	__probe_create_global_data(&prog, &map, insns, ARRAY_SIZE(insns));
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
@@ -3797,6 +3859,9 @@ static struct kern_feature_desc {
 	},
 	[FEAT_PROBE_READ_KERN] = {
 		"bpf_probe_read_kernel() helper", probe_kern_probe_read_kernel,
+	},
+	[FEAT_PROG_BIND_MAP] = {
+		"BPF_PROG_BIND_MAP support", probe_prog_bind_map,
 	}
 };
 
@@ -3897,7 +3962,8 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 	}
 
 	/* Freeze .rodata and .kconfig map as read-only from syscall side. */
-	if (map_type == LIBBPF_MAP_RODATA || map_type == LIBBPF_MAP_KCONFIG) {
+	if (map_type == LIBBPF_MAP_RODATA || map_type == LIBBPF_MAP_KCONFIG ||
+	    map_type == LIBBPF_MAP_METADATA) {
 		err = bpf_map_freeze(map->fd);
 		if (err) {
 			err = -errno;
@@ -6057,6 +6123,28 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	if (ret >= 0) {
 		if (log_buf && load_attr.log_level)
 			pr_debug("verifier log:\n%s", log_buf);
+
+		if (prog->obj->metadata_map_idx >= 0 &&
+		    kernel_supports(FEAT_PROG_BIND_MAP)) {
+			struct bpf_map *metadata_map =
+				&prog->obj->maps[prog->obj->metadata_map_idx];
+
+			/* EEXIST to bpf_prog_bind_map means the map is already
+			 * bound to the program. This can happen if the program
+			 * refers to the map in its code. Since all we are doing
+			 * is to make sure when we iterate the program's maps
+			 * metadata map is always inside, EXIST is okay; we
+			 * ignore this errno
+			 */
+			if (bpf_prog_bind_map(ret, bpf_map__fd(metadata_map), NULL) &&
+			    errno != EEXIST) {
+				cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
+				pr_warn("prog '%s': failed to bind .metadata map: %s\n",
+					prog->name, cp);
+				/* Don't fail hard if can't load metadata. */
+			}
+		}
+
 		*pfd = ret;
 		ret = 0;
 		goto out;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 66a6286d0716..529b99c0c2c3 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -302,6 +302,7 @@ LIBBPF_0.1.0 {
 
 LIBBPF_0.2.0 {
 	global:
+		bpf_prog_bind_map;
 		perf_buffer__buffer_cnt;
 		perf_buffer__buffer_fd;
 		perf_buffer__epoll_fd;
-- 
2.28.0.402.g5ffc5be6b7-goog

