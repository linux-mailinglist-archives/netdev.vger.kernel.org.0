Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96B33D129E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240040AbhGUO5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240029AbhGUO5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 10:57:40 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4F2C0613D3
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:38:16 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id l17-20020a05600c1d11b029021f84fcaf75so3687404wms.1
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dEVfozjGZK/3dXowqh2UjKyafiJ11/pLn4v/JLvZ33I=;
        b=SYO393XMjJOWmHhl4A/je2qayJn67baAap99xgciGM0jVUBSQ6KaVLEW1RZYxXiG3K
         hXwxPT1FI+GnMxIz8ziNXoXHQqmXrosSUVMqQ9VjuDq0nU5VADvAVekv/MxzuozWACes
         CDUJzulXKB32msdDORX91hMunLFquMXDGDO9zS9bQDqnWRL7AeZBUr2dZOIvpFVguFSj
         Z5PO53lwqn1fbCco2FtdIZA3PPgbYL8FwxYxmBJJh5BiZVdJTlAYgpJRffN/kNap+xU2
         Dex+h2W40wVcouWVHjrqRvENZ5bmrBxPPES+uEhsYa6LDEo53VsxqWG126FHK3NBd96x
         ie+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dEVfozjGZK/3dXowqh2UjKyafiJ11/pLn4v/JLvZ33I=;
        b=uUKiaSf3u7Pr4/hoi4dMSS8csTsM0p0QV1GeZjhcRvbugpGVXtYWBco3UXo9/F9edf
         dNe9L/axJIA5piokUebHpM6Bn2PRhS3PnWYFJauGfkcVuwjHO6aYyrIuKoaddayEUrWd
         6V10ZKfxyL/FNEh8AD+bnYJhyHiTzd0UnM4pTi/t0SP5dOSCK/13lM7HfhEWiLgH5FPW
         DIpg7YuWRVP733+oxMNngT8vEAQ46ch1oAH0dR3QsZU6/ooVBXqzlG+4JNmwCF5Q0i+n
         tmCqKvppdqB8p2yaP/PnXWI0HrXpqENN8oTV8cDJgeArAC0p56NTVlxtMxG8RmUB76MX
         eECA==
X-Gm-Message-State: AOAM5322gYswbm7sNN9m9rtJkpCCN0lnQEKoBR9uPbd77jo72Gh2kBzZ
        Qzd2Z+7qgIRO4DMluFw6LLg6vg==
X-Google-Smtp-Source: ABdhPJydFT/Bb3DVweRNhn4GiJL0rY4pJ7EL4qDmDnOvoFRor1cSBIDu76Se4LhODFWIQTUK9QaA9g==
X-Received: by 2002:a7b:c844:: with SMTP id c4mr4715597wml.107.1626881894983;
        Wed, 21 Jul 2021 08:38:14 -0700 (PDT)
Received: from localhost.localdomain ([149.86.71.195])
        by smtp.gmail.com with ESMTPSA id n18sm26209714wrt.89.2021.07.21.08.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 08:38:14 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next v2 3/5] tools: replace btf__get_from_id() with btf__load_from_kernel_by_id()
Date:   Wed, 21 Jul 2021 16:38:06 +0100
Message-Id: <20210721153808.6902-4-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721153808.6902-1-quentin@isovalent.com>
References: <20210721153808.6902-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the calls to deprecated function btf__get_from_id() with calls
to btf__load_from_kernel_by_id() in tools/ (bpftool, perf, selftests).
Update the surrounding code accordingly (instead of passing a pointer to
the btf struct, get it as a return value from the function). Also make
sure that btf__free() is called on the pointer after use.

v2:
- Given that btf__load_from_kernel_by_id() has changed since v1, adapt
  the code accordingly instead of just renaming the function. Also add a
  few calls to btf__free() when necessary.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/bpf/bpftool/btf.c                      |  8 ++----
 tools/bpf/bpftool/btf_dumper.c               |  6 ++--
 tools/bpf/bpftool/map.c                      | 16 +++++------
 tools/bpf/bpftool/prog.c                     | 29 ++++++++++++++------
 tools/perf/util/bpf-event.c                  | 11 ++++----
 tools/perf/util/bpf_counter.c                | 12 ++++++--
 tools/testing/selftests/bpf/prog_tests/btf.c |  4 ++-
 7 files changed, 51 insertions(+), 35 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 385d5c955cf3..9162a18e84c0 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -580,16 +580,12 @@ static int do_dump(int argc, char **argv)
 	}
 
 	if (!btf) {
-		err = btf__get_from_id(btf_id, &btf);
+		btf = btf__load_from_kernel_by_id(btf_id);
+		err = libbpf_get_error(btf);
 		if (err) {
 			p_err("get btf by id (%u): %s", btf_id, strerror(err));
 			goto done;
 		}
-		if (!btf) {
-			err = -ENOENT;
-			p_err("can't find btf with ID (%u)", btf_id);
-			goto done;
-		}
 	}
 
 	if (dump_c) {
diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 7ca54d046362..9c25286a5c73 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -64,8 +64,10 @@ static int dump_prog_id_as_func_ptr(const struct btf_dumper *d,
 	}
 	info = &prog_info->info;
 
-	if (!info->btf_id || !info->nr_func_info ||
-	    btf__get_from_id(info->btf_id, &prog_btf))
+	if (!info->btf_id || !info->nr_func_info)
+		goto print;
+	prog_btf = btf__load_from_kernel_by_id(info->btf_id);
+	if (libbpf_get_error(prog_btf))
 		goto print;
 	finfo = u64_to_ptr(info->func_info);
 	func_type = btf__type_by_id(prog_btf, finfo->type_id);
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 09ae0381205b..12787758ce03 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -805,12 +805,11 @@ static struct btf *get_map_kv_btf(const struct bpf_map_info *info)
 		}
 		return btf_vmlinux;
 	} else if (info->btf_value_type_id) {
-		int err;
-
-		err = btf__get_from_id(info->btf_id, &btf);
-		if (err || !btf) {
+		btf = btf__load_from_kernel_by_id(info->btf_id);
+		if (libbpf_get_error(btf)) {
 			p_err("failed to get btf");
-			btf = err ? ERR_PTR(err) : ERR_PTR(-ESRCH);
+			if (!btf)
+				btf = ERR_PTR(-ESRCH);
 		}
 	}
 
@@ -1039,11 +1038,10 @@ static void print_key_value(struct bpf_map_info *info, void *key,
 			    void *value)
 {
 	json_writer_t *btf_wtr;
-	struct btf *btf = NULL;
-	int err;
+	struct btf *btf;
 
-	err = btf__get_from_id(info->btf_id, &btf);
-	if (err) {
+	btf = btf__load_from_kernel_by_id(info->btf_id);
+	if (libbpf_get_error(btf)) {
 		p_err("failed to get btf");
 		return;
 	}
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index cc48726740ad..b1996b8f1d42 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -249,10 +249,10 @@ static void show_prog_metadata(int fd, __u32 num_maps)
 	struct bpf_map_info map_info;
 	struct btf_var_secinfo *vsi;
 	bool printed_header = false;
-	struct btf *btf = NULL;
 	unsigned int i, vlen;
 	void *value = NULL;
 	const char *name;
+	struct btf *btf;
 	int err;
 
 	if (!num_maps)
@@ -263,8 +263,8 @@ static void show_prog_metadata(int fd, __u32 num_maps)
 	if (!value)
 		return;
 
-	err = btf__get_from_id(map_info.btf_id, &btf);
-	if (err || !btf)
+	btf = btf__load_from_kernel_by_id(map_info.btf_id);
+	if (libbpf_get_error(btf))
 		goto out_free;
 
 	t_datasec = btf__type_by_id(btf, map_info.btf_value_type_id);
@@ -646,9 +646,12 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 		member_len = info->xlated_prog_len;
 	}
 
-	if (info->btf_id && btf__get_from_id(info->btf_id, &btf)) {
-		p_err("failed to get btf");
-		return -1;
+	if (info->btf_id) {
+		btf = btf__load_from_kernel_by_id(info->btf_id);
+		if (libbpf_get_error(btf)) {
+			p_err("failed to get btf");
+			return -1;
+		}
 	}
 
 	func_info = u64_to_ptr(info->func_info);
@@ -781,6 +784,8 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 		kernel_syms_destroy(&dd);
 	}
 
+	btf__free(btf);
+
 	return 0;
 }
 
@@ -2002,8 +2007,8 @@ static char *profile_target_name(int tgt_fd)
 	struct bpf_prog_info_linear *info_linear;
 	struct bpf_func_info *func_info;
 	const struct btf_type *t;
+	struct btf *btf = NULL;
 	char *name = NULL;
-	struct btf *btf;
 
 	info_linear = bpf_program__get_prog_info_linear(
 		tgt_fd, 1UL << BPF_PROG_INFO_FUNC_INFO);
@@ -2012,12 +2017,17 @@ static char *profile_target_name(int tgt_fd)
 		return NULL;
 	}
 
-	if (info_linear->info.btf_id == 0 ||
-	    btf__get_from_id(info_linear->info.btf_id, &btf)) {
+	if (info_linear->info.btf_id == 0) {
 		p_err("prog FD %d doesn't have valid btf", tgt_fd);
 		goto out;
 	}
 
+	btf = btf__load_from_kernel_by_id(info_linear->info.btf_id);
+	if (libbpf_get_error(btf)) {
+		p_err("failed to load btf for prog FD %d", tgt_fd);
+		goto out;
+	}
+
 	func_info = u64_to_ptr(info_linear->info.func_info);
 	t = btf__type_by_id(btf, func_info[0].type_id);
 	if (!t) {
@@ -2027,6 +2037,7 @@ static char *profile_target_name(int tgt_fd)
 	}
 	name = strdup(btf__name_by_offset(btf, t->name_off));
 out:
+	btf__free(btf);
 	free(info_linear);
 	return name;
 }
diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index cdecda1ddd36..996d025b8ed8 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -223,10 +223,10 @@ static int perf_event__synthesize_one_bpf_prog(struct perf_session *session,
 			free(info_linear);
 			return -1;
 		}
-		if (btf__get_from_id(info->btf_id, &btf)) {
+		btf = btf__load_from_kernel_by_id(info->btf_id);
+		if (libbpf_get_error(btf)) {
 			pr_debug("%s: failed to get BTF of id %u, aborting\n", __func__, info->btf_id);
 			err = -1;
-			btf = NULL;
 			goto out;
 		}
 		perf_env__fetch_btf(env, info->btf_id, btf);
@@ -296,7 +296,7 @@ static int perf_event__synthesize_one_bpf_prog(struct perf_session *session,
 
 out:
 	free(info_linear);
-	free(btf);
+	btf__free(btf);
 	return err ? -1 : 0;
 }
 
@@ -478,7 +478,8 @@ static void perf_env__add_bpf_info(struct perf_env *env, u32 id)
 	if (btf_id == 0)
 		goto out;
 
-	if (btf__get_from_id(btf_id, &btf)) {
+	btf = btf__load_from_kernel_by_id(btf_id);
+	if (libbpf_get_error(btf)) {
 		pr_debug("%s: failed to get BTF of id %u, aborting\n",
 			 __func__, btf_id);
 		goto out;
@@ -486,7 +487,7 @@ static void perf_env__add_bpf_info(struct perf_env *env, u32 id)
 	perf_env__fetch_btf(env, btf_id, btf);
 
 out:
-	free(btf);
+	btf__free(btf);
 	close(fd);
 }
 
diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
index 8150e03367bb..ba0f20853651 100644
--- a/tools/perf/util/bpf_counter.c
+++ b/tools/perf/util/bpf_counter.c
@@ -64,8 +64,8 @@ static char *bpf_target_prog_name(int tgt_fd)
 	struct bpf_prog_info_linear *info_linear;
 	struct bpf_func_info *func_info;
 	const struct btf_type *t;
+	struct btf *btf = NULL;
 	char *name = NULL;
-	struct btf *btf;
 
 	info_linear = bpf_program__get_prog_info_linear(
 		tgt_fd, 1UL << BPF_PROG_INFO_FUNC_INFO);
@@ -74,12 +74,17 @@ static char *bpf_target_prog_name(int tgt_fd)
 		return NULL;
 	}
 
-	if (info_linear->info.btf_id == 0 ||
-	    btf__get_from_id(info_linear->info.btf_id, &btf)) {
+	if (info_linear->info.btf_id == 0) {
 		pr_debug("prog FD %d doesn't have valid btf\n", tgt_fd);
 		goto out;
 	}
 
+	btf = btf__load_from_kernel_by_id(info_linear->info.btf_id);
+	if (libbpf_get_error(btf)) {
+		pr_debug("failed to load btf for prog FD %d\n", tgt_fd);
+		goto out;
+	}
+
 	func_info = u64_to_ptr(info_linear->info.func_info);
 	t = btf__type_by_id(btf, func_info[0].type_id);
 	if (!t) {
@@ -89,6 +94,7 @@ static char *bpf_target_prog_name(int tgt_fd)
 	}
 	name = strdup(btf__name_by_offset(btf, t->name_off));
 out:
+	btf__free(btf);
 	free(info_linear);
 	return name;
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index 857e3f26086f..649f87382c8d 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -4350,7 +4350,8 @@ static void do_test_file(unsigned int test_num)
 		goto done;
 	}
 
-	err = btf__get_from_id(info.btf_id, &btf);
+	btf = btf__load_from_kernel_by_id(info.btf_id);
+	err = libbpf_get_error(btf);
 	if (CHECK(err, "cannot get btf from kernel, err: %d", err))
 		goto done;
 
@@ -4386,6 +4387,7 @@ static void do_test_file(unsigned int test_num)
 	fprintf(stderr, "OK");
 
 done:
+	btf__free(btf);
 	free(func_info);
 	bpf_object__close(obj);
 }
-- 
2.30.2

