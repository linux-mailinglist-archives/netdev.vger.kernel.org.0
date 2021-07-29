Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04833DA8D8
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbhG2QVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbhG2QUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:20:47 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20406C0613D5
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:20:44 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id d8so7636138wrm.4
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xKR/VqjQCMViD/BBhgCDfJMife0SJ78QiGT3qxry5Ck=;
        b=wj3GcmAssPxsnNCPm8nkXstw6PRG+kqXSN2c7HhMXxCx65AGPK/Ism78nRtIeAzOPk
         /jV/ThM4D4Z7DHbFzEfNA7g9sNgtKR1JiNpexUFZM8axviBqXtiM1E4URIVNWmSC7Suf
         A4QJNBEZn9/jsPAmuERwkaZNmGdHQWJ0RELZjmAJk9GZy6A+5o1k5G3QLQdkrvWHb8WO
         WNyX5jv0rN0tX5YSu5KA89p/Yo54/EGS+35JpPN8k8JdDy+dXxyKwyxmNoCWcDRAP2kv
         JvkW/7Ft4lnbjdGH+gipd/b01uX0rTztDYD3/Px9/NY90s6kFvHLHuM9+evoPW20ArxS
         tYVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xKR/VqjQCMViD/BBhgCDfJMife0SJ78QiGT3qxry5Ck=;
        b=psfjOfRoZMZ7JmxwCjivm+FN16dIqQYbfwj1rWqkiOS6OH7+s95NvJrOOgJEL25AHe
         SvxGBNZUafG/g3TyufBTBIPzxLo4IO8Dc3BW7UyV6PiJqfo2tDu+nZeQZxkdRwDGN9Fx
         zNRdDpLshN4SdlmHOphtZSROBervNVVbO+hvKBzss0u3PRIF4IdeUJ/LO+xnkfT37uDw
         V+TgIX3fJxUBKGae5HUQ/ZRhRuM5VRDfT+9kQew/OIkNRhDbNMZLVkSuv2vxrOfHJa1K
         H+ZAOtky1zZfgHXrVrmVfYbZ85A1khPYlO8sIRDoBPILfuQ6bTyy92NHllGx58+3DbmP
         ButA==
X-Gm-Message-State: AOAM5329wJUbdQq2NiuIqRMgZCrspTttmmMzRM/dlcdj+Xnfi+hTeAJB
        Xrie82lgIL2uVmYrnsVUip5sAg==
X-Google-Smtp-Source: ABdhPJw9fkBHZl8iN922EREZu9iMKWAgHw70CYpO/b/GYjI0EglCWiMLEmHJS97IhfD0eMddpDqHBQ==
X-Received: by 2002:a5d:4410:: with SMTP id z16mr5770950wrq.173.1627575642574;
        Thu, 29 Jul 2021 09:20:42 -0700 (PDT)
Received: from localhost.localdomain ([149.86.66.250])
        by smtp.gmail.com with ESMTPSA id c10sm3854853wmb.40.2021.07.29.09.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:20:41 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next v3 5/8] tools: replace btf__get_from_id() with btf__load_from_kernel_by_id()
Date:   Thu, 29 Jul 2021 17:20:25 +0100
Message-Id: <20210729162028.29512-6-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729162028.29512-1-quentin@isovalent.com>
References: <20210729162028.29512-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the calls to function btf__get_from_id(), which we plan to
deprecate before the library reaches v1.0, with calls to
btf__load_from_kernel_by_id() in tools/ (bpftool, perf, selftests).
Update the surrounding code accordingly (instead of passing a pointer to
the btf struct, get it as a return value from the function).

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/bpf/bpftool/btf.c                      |  8 ++-----
 tools/bpf/bpftool/btf_dumper.c               |  6 +++--
 tools/bpf/bpftool/map.c                      | 14 ++++++------
 tools/bpf/bpftool/prog.c                     | 24 +++++++++++++-------
 tools/perf/util/bpf-event.c                  |  7 +++---
 tools/perf/util/bpf_counter.c                |  9 ++++++--
 tools/testing/selftests/bpf/prog_tests/btf.c |  3 ++-
 7 files changed, 42 insertions(+), 29 deletions(-)

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
index 09ae0381205b..7e7f748bb0be 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -807,10 +807,11 @@ static struct btf *get_map_kv_btf(const struct bpf_map_info *info)
 	} else if (info->btf_value_type_id) {
 		int err;
 
-		err = btf__get_from_id(info->btf_id, &btf);
-		if (err || !btf) {
+		btf = btf__load_from_kernel_by_id(info->btf_id);
+		err = libbpf_get_error(btf);
+		if (err) {
 			p_err("failed to get btf");
-			btf = err ? ERR_PTR(err) : ERR_PTR(-ESRCH);
+			btf = ERR_PTR(err);
 		}
 	}
 
@@ -1039,11 +1040,10 @@ static void print_key_value(struct bpf_map_info *info, void *key,
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
index 9d709b427665..b1996b8f1d42 100644
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
@@ -2014,12 +2017,17 @@ static char *profile_target_name(int tgt_fd)
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
diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 17a9844e4fbf..996d025b8ed8 100644
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
@@ -478,7 +478,8 @@ static void perf_env__add_bpf_info(struct perf_env *env, u32 id)
 	if (btf_id == 0)
 		goto out;
 
-	if (btf__get_from_id(btf_id, &btf)) {
+	btf = btf__load_from_kernel_by_id(btf_id);
+	if (libbpf_get_error(btf)) {
 		pr_debug("%s: failed to get BTF of id %u, aborting\n",
 			 __func__, btf_id);
 		goto out;
diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
index beca55129b0b..ba0f20853651 100644
--- a/tools/perf/util/bpf_counter.c
+++ b/tools/perf/util/bpf_counter.c
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
diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index 68e415f4d33c..649f87382c8d 100644
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
 
-- 
2.30.2

