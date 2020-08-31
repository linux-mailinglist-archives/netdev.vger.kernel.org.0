Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D759258436
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 00:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgHaWt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 18:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgHaWtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 18:49:53 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA765C061575
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 15:49:52 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id m203so2713333qke.16
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 15:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=lsejbdV/YJeNxRqBDrAM85EBWsJ6w6R31JBoDDcAVKw=;
        b=LUekSZnLLaT2oDK9/2Rbz8Jd6nMzsh3bFAVy7rsATTCt3j5BD7m3SK8NzR4k8TzPg4
         A4QruQNA71TYblk3RMNxQrbX1EyX0iEbH9KQ6Gjz1h6RvPKK3nJHba2XFy8DMSHnX3mV
         66iLC9nQBKiCIQzJr0ctfzfUzagCWS0VQ2wASUhZnTvlZpL2hSaxUVgOl+gbFll99RBM
         0zIqR2nkQn63dJKzdcf7WI97Ty1g33U5wrnSAaMy3T3W7vuayV6gDN1SiaoewGHzhJRA
         I/7juz/2TsWGACUEqPTXFbh7u+AOaD41jpRBClIP3yJhvO5eknDeNS3lsrBwLXTXnaPD
         FsFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=lsejbdV/YJeNxRqBDrAM85EBWsJ6w6R31JBoDDcAVKw=;
        b=SKgySSLx6LpgLz0qKBoV2XqrmD/jzI1GOn7AdrB4JWGPV8v0FMZ5cHs35uM2NtFuv6
         HjWwD1k+PeUCRmmXqJY1i6lKTrjzyANFWBulpL+5VY2L0hkZKlAiPlzoXBGi5SoBy4jX
         pcm+N4acuNQ8lc4kYWqCME6LrHBADatUfxPqElvEQ5Rp7CSB72xmX/kI5P06p9zkgLf4
         yvT1Ai5+vWSHwR/K3QQu9YYKTGI/3/yf25v4iE10WPQN2k/IPY/pkyxLGYvppKzXYdbt
         WoAq0fmJNgss4kURZ/p5etEt9QGarw1Vz8j47CciYyaHa4qw7MitTNy22jjAUzn6iG90
         9PTg==
X-Gm-Message-State: AOAM530rXldPP4vpVC6T6d309xyheVszRo9gxinKJfpOdZLRo8kPILVT
        7wKThJtRZGZTVAQo2JfXddBTWm4y
X-Google-Smtp-Source: ABdhPJx2tAjaaQbp7takpRRLRqxo3GJGDbS49dWqYyIfWseIXB4WdFQfYMpIZlsnvs4m4RnCiQN/pefi
X-Received: from gnomeregan.cam.corp.google.com ([2620:15c:6:14:1ea0:b8ff:fe76:1e48])
 (user=brho job=sendgmr) by 2002:a0c:ea34:: with SMTP id t20mr3387381qvp.233.1598914189559;
 Mon, 31 Aug 2020 15:49:49 -0700 (PDT)
Date:   Mon, 31 Aug 2020 18:49:33 -0400
Message-Id: <20200831224933.2129891-1-brho@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [RFC PATCH] libbpf: Support setting map max_entries at runtime
From:   Barret Rhoden <brho@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The max_entries for a BPF map may depend on runtime parameters.
Currently, we need to know the maximum value at BPF compile time.  For
instance, if you want an array map with NR_CPUS entries, you would hard
code your architecture's largest value for CONFIG_NR_CPUS.  This wastes
memory at runtime.

For the NR_CPU case, one could use a PERCPU map type, but those maps are
limited in functionality.  For instance, BPF programs can only access
their own PERCPU part of the map, and the maps are not mmappable.

This commit allows the use of sentinel values in BPF map definitions,
which libbpf patches at runtime.

For starters, we support NUM_POSSIBLE_CPUS: e.g.

struct {
        __uint(type, BPF_MAP_TYPE_ARRAY);
        __uint(max_entries, NUM_POSSIBLE_CPUS);
        __type(key, u32);
        __type(value, struct cpu_data);
} cpu_blobs SEC(".maps");

This can be extended to other runtime dependent values, such as the
maximum number of threads (/proc/sys/kernel/threads-max).

Signed-off-by: Barret Rhoden <brho@google.com>
---
 tools/lib/bpf/bpf_helpers.h |  4 ++++
 tools/lib/bpf/libbpf.c      | 40 ++++++++++++++++++++++++++++++-------
 tools/lib/bpf/libbpf.h      |  4 ++++
 3 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index f67dce2af802..38b431d85ac6 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -74,6 +74,10 @@ enum libbpf_tristate {
 	TRI_MODULE = 2,
 };
 
+enum libbpf_max_entries {
+	NUM_POSSIBLE_CPUS = (unsigned int)-1,
+};
+
 #define __kconfig __attribute__((section(".kconfig")))
 
 #endif
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 11e4725b8b1c..7d0e9792e015 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1868,36 +1868,55 @@ resolve_func_ptr(const struct btf *btf, __u32 id, __u32 *res_id)
  * encodes `type => BPF_MAP_TYPE_ARRAY` key/value pair completely using BTF
  * type definition, while using only sizeof(void *) space in ELF data section.
  */
-static bool get_map_field_int(const char *map_name, const struct btf *btf,
-			      const struct btf_member *m, __u32 *res)
+static struct btf_array *get_map_field_arr_info(const char *map_name,
+						const struct btf *btf,
+						const struct btf_member *m)
 {
 	const struct btf_type *t = skip_mods_and_typedefs(btf, m->type, NULL);
 	const char *name = btf__name_by_offset(btf, m->name_off);
-	const struct btf_array *arr_info;
 	const struct btf_type *arr_t;
 
 	if (!btf_is_ptr(t)) {
 		pr_warn("map '%s': attr '%s': expected PTR, got %u.\n",
 			map_name, name, btf_kind(t));
-		return false;
+		return NULL;
 	}
 
 	arr_t = btf__type_by_id(btf, t->type);
 	if (!arr_t) {
 		pr_warn("map '%s': attr '%s': type [%u] not found.\n",
 			map_name, name, t->type);
-		return false;
+		return NULL;
 	}
 	if (!btf_is_array(arr_t)) {
 		pr_warn("map '%s': attr '%s': expected ARRAY, got %u.\n",
 			map_name, name, btf_kind(arr_t));
-		return false;
+		return NULL;
 	}
-	arr_info = btf_array(arr_t);
+	return btf_array(arr_t);
+}
+
+static bool get_map_field_int(const char *map_name, const struct btf *btf,
+			      const struct btf_member *m, __u32 *res)
+{
+	const struct btf_array *arr_info;
+
+	arr_info = get_map_field_arr_info(map_name, btf, m);
+	if (arr_info == NULL)
+		return false;
 	*res = arr_info->nelems;
 	return true;
 }
 
+static void set_map_field_int(const char *map_name, const struct btf *btf,
+			      const struct btf_member *m, __u32 val)
+{
+	struct btf_array *arr_info;
+
+	arr_info = get_map_field_arr_info(map_name, btf, m);
+	arr_info->nelems = val;
+}
+
 static int build_map_pin_path(struct bpf_map *map, const char *path)
 {
 	char buf[PATH_MAX];
@@ -1951,6 +1970,13 @@ static int parse_btf_map_def(struct bpf_object *obj,
 				return -EINVAL;
 			pr_debug("map '%s': found max_entries = %u.\n",
 				 map->name, map->def.max_entries);
+			if (map->def.max_entries == NUM_POSSIBLE_CPUS) {
+				map->def.max_entries = libbpf_num_possible_cpus();
+				set_map_field_int(map->name, obj->btf, m,
+						  map->def.max_entries);
+				pr_debug("map '%s': adjusting max_entries = %u.\n",
+					 map->name, map->def.max_entries);
+			}
 		} else if (strcmp(name, "map_flags") == 0) {
 			if (!get_map_field_int(map->name, obj->btf, m,
 					       &map->def.map_flags))
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 334437af3014..42cba5bb1b04 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -717,6 +717,10 @@ enum libbpf_tristate {
 	TRI_MODULE = 2,
 };
 
+enum libbpf_max_entries {
+	NUM_POSSIBLE_CPUS = -1,
+};
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
-- 
2.28.0.402.g5ffc5be6b7-goog

