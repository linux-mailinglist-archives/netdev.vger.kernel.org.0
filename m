Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142AC55EE25
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiF1Tu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiF1Tut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:49 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE9F3A704;
        Tue, 28 Jun 2022 12:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445741; x=1687981741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pQr3fCJrk4WXxCYLImyg32mOo+swJBRtDbJmx5XeYg8=;
  b=Qb6+wwwKBBVgNEnIllsp5ZfJL5X/aHS/ynQdSeTc2vkfZo0G+ko16ko2
   FALj+HTaU1bgc1/Aw1AqHUEJ4iWGC9eDKLHKKlrYsTK0Z0lPIIDE6wfZH
   zuwZ/KS87FATbzBGKBeKP53AgjRILlCltugzzaKp/APDStQNhpXSKGbkC
   ZXlyc7dvCIy5z2II8MnsLs+1H0uW082avgozwOJGmixmutV1u5SGRUJPq
   BCgNLCEdqafcN4J6+SyHz0qH8wJ0aK1Xe/6EsOFdqt8N3vz5y0QDwgGp+
   z6fQevnMjuRZXp07EsFeBfD/zJQQ+X3Ec7XFTCVl2C9KDb+xKrUf/xN49
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="307319464"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="307319464"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="594927452"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 28 Jun 2022 12:48:56 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr91022013;
        Tue, 28 Jun 2022 20:48:55 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 01/52] libbpf: factor out BTF loading from load_module_btfs()
Date:   Tue, 28 Jun 2022 21:47:21 +0200
Message-Id: <20220628194812.1453059-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Larysa Zaremba <larysa.zaremba@intel.com>

In order to be able to reuse BTF loading logics, move it to the new
btf_load_next_with_info() and call it from load_module_btfs()
instead.
To still be able to get the ID, introduce the ID field to the
userspace struct btf and return it via the new btf_obj_id().
To still be able to use bpf_btf_info::name as a string, locally add
a counterpart to ptr_to_u64() - u64_to_ptr() and use it to filter
vmlinux/module BTFs.
Also, add a definition for easy bpf_btf_info name declaration and
make btf_get_from_fd() static as it's now used only in btf.c.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/lib/bpf/btf.c             | 110 +++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf.c          |  52 ++++-----------
 tools/lib/bpf/libbpf_internal.h |   7 +-
 3 files changed, 126 insertions(+), 43 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index ae1520f7e1b0..7e4dbf71fd52 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -121,6 +121,9 @@ struct btf {
 
 	/* Pointer size (in bytes) for a target architecture of this BTF */
 	int ptr_sz;
+
+	/* BTF object ID, valid for vmlinux and module BTF */
+	__u32 id;
 };
 
 static inline __u64 ptr_to_u64(const void *ptr)
@@ -128,6 +131,11 @@ static inline __u64 ptr_to_u64(const void *ptr)
 	return (__u64) (unsigned long) ptr;
 }
 
+static inline const void *u64_to_ptr(__u64 val)
+{
+	return (const void *)(unsigned long)val;
+}
+
 /* Ensure given dynamically allocated memory region pointed to by *data* with
  * capacity of *cap_cnt* elements each taking *elem_sz* bytes has enough
  * memory to accommodate *add_cnt* new elements, assuming *cur_cnt* elements
@@ -463,6 +471,11 @@ const struct btf *btf__base_btf(const struct btf *btf)
 	return btf->base_btf;
 }
 
+__u32 btf_obj_id(const struct btf *btf)
+{
+	return btf->id;
+}
+
 /* internal helper returning non-const pointer to a type */
 struct btf_type *btf_type_by_id(const struct btf *btf, __u32 type_id)
 {
@@ -819,6 +832,7 @@ static struct btf *btf_new_empty(struct btf *base_btf)
 	btf->fd = -1;
 	btf->ptr_sz = sizeof(void *);
 	btf->swapped_endian = false;
+	btf->id = 0;
 
 	if (base_btf) {
 		btf->base_btf = base_btf;
@@ -869,6 +883,7 @@ static struct btf *btf_new(const void *data, __u32 size, struct btf *base_btf)
 	btf->start_id = 1;
 	btf->start_str_off = 0;
 	btf->fd = -1;
+	btf->id = 0;
 
 	if (base_btf) {
 		btf->base_btf = base_btf;
@@ -1334,7 +1349,7 @@ const char *btf__name_by_offset(const struct btf *btf, __u32 offset)
 	return btf__str_by_offset(btf, offset);
 }
 
-struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
+static struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
 {
 	struct bpf_btf_info btf_info;
 	__u32 len = sizeof(btf_info);
@@ -1382,6 +1397,8 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
 	}
 
 	btf = btf_new(ptr, btf_info.btf_size, base_btf);
+	if (!IS_ERR_OR_NULL(btf))
+		btf->id = btf_info.id;
 
 exit_free:
 	free(ptr);
@@ -4819,6 +4836,97 @@ static int btf_dedup_remap_types(struct btf_dedup *d)
 	return 0;
 }
 
+/**
+ * btf_load_next_with_info - get first BTF with ID bigger than the input one.
+ * @start_id: ID to start the search from
+ * @info: buffer to put BTF info to
+ * @base_btf: base BTF, can be %NULL if @vmlinux is true
+ * @vmlinux: true to look for the vmlinux BTF instead of a module BTF
+ *
+ * Obtains the first BTF with the ID bigger than the @start_id. @info::name and
+ * @info::name_len must be initialized by the caller. The default name buffer
+ * size is %BTF_NAME_BUF_LEN.
+ * FD must be closed after BTF is no longer needed. If @vmlinux is true, FD can
+ * be closed and set to -1 right away without preventing later usage.
+ *
+ * Returns pointer to the BTF loaded from the kernel or an error pointer.
+ */
+struct btf *btf_load_next_with_info(__u32 start_id, struct bpf_btf_info *info,
+				    struct btf *base_btf, bool vmlinux)
+{
+	__u32 name_len = info->name_len;
+	__u64 name = info->name;
+	const char *name_str;
+	__u32 id = start_id;
+
+	if (!name)
+		return ERR_PTR(-EINVAL);
+
+	name_str = u64_to_ptr(name);
+
+	while (true) {
+		__u32 len = sizeof(*info);
+		struct btf *btf;
+		int err, fd;
+
+		err = bpf_btf_get_next_id(id, &id);
+		if (err) {
+			err = -errno;
+			if (err != -ENOENT)
+				pr_warn("failed to iterate BTF objects: %d\n",
+					err);
+			return ERR_PTR(err);
+		}
+
+		fd = bpf_btf_get_fd_by_id(id);
+		if (fd < 0) {
+			err = -errno;
+			if (err == -ENOENT)
+				/* Expected race: non-vmlinux BTF was
+				 * unloaded
+				 */
+				continue;
+			pr_warn("failed to get BTF object #%d FD: %d\n",
+				id, err);
+			return ERR_PTR(err);
+		}
+
+		memset(info, 0, len);
+		info->name = name;
+		info->name_len = name_len;
+
+		err = bpf_obj_get_info_by_fd(fd, info, &len);
+		if (err) {
+			err = -errno;
+			pr_warn("failed to get BTF object #%d info: %d\n",
+				id, err);
+			goto err_out;
+		}
+
+		/* Filter BTFs */
+		if (!info->kernel_btf ||
+		    !strcmp(name_str, "vmlinux") != vmlinux) {
+			close(fd);
+			continue;
+		}
+
+		btf = btf_get_from_fd(fd, base_btf);
+		err = libbpf_get_error(btf);
+		if (err) {
+			pr_warn("failed to load module [%s]'s BTF object #%d: %d\n",
+				name_str, id, err);
+			goto err_out;
+		}
+
+		btf->fd = fd;
+		return btf;
+
+err_out:
+		close(fd);
+		return ERR_PTR(err);
+	}
+}
+
 /*
  * Probe few well-known locations for vmlinux kernel image and try to load BTF
  * data out of it to use for target BTF.
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 335467ece75f..8e27bad5e80f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5559,11 +5559,11 @@ int bpf_core_add_cands(struct bpf_core_cand *local_cand,
 
 static int load_module_btfs(struct bpf_object *obj)
 {
-	struct bpf_btf_info info;
+	char name[BTF_NAME_BUF_LEN] = { };
 	struct module_btf *mod_btf;
+	struct bpf_btf_info info;
 	struct btf *btf;
-	char name[64];
-	__u32 id = 0, len;
+	__u32 id = 0;
 	int err, fd;
 
 	if (obj->btf_modules_loaded)
@@ -5580,49 +5580,19 @@ static int load_module_btfs(struct bpf_object *obj)
 		return 0;
 
 	while (true) {
-		err = bpf_btf_get_next_id(id, &id);
-		if (err && errno == ENOENT)
-			return 0;
-		if (err) {
-			err = -errno;
-			pr_warn("failed to iterate BTF objects: %d\n", err);
-			return err;
-		}
-
-		fd = bpf_btf_get_fd_by_id(id);
-		if (fd < 0) {
-			if (errno == ENOENT)
-				continue; /* expected race: BTF was unloaded */
-			err = -errno;
-			pr_warn("failed to get BTF object #%d FD: %d\n", id, err);
-			return err;
-		}
-
-		len = sizeof(info);
 		memset(&info, 0, sizeof(info));
 		info.name = ptr_to_u64(name);
 		info.name_len = sizeof(name);
 
-		err = bpf_obj_get_info_by_fd(fd, &info, &len);
-		if (err) {
-			err = -errno;
-			pr_warn("failed to get BTF object #%d info: %d\n", id, err);
-			goto err_out;
-		}
-
-		/* ignore non-module BTFs */
-		if (!info.kernel_btf || strcmp(name, "vmlinux") == 0) {
-			close(fd);
-			continue;
-		}
-
-		btf = btf_get_from_fd(fd, obj->btf_vmlinux);
+		btf = btf_load_next_with_info(id, &info, obj->btf_vmlinux,
+					      false);
 		err = libbpf_get_error(btf);
-		if (err) {
-			pr_warn("failed to load module [%s]'s BTF object #%d: %d\n",
-				name, id, err);
-			goto err_out;
-		}
+		if (err)
+			return err == -ENOENT ? 0 : err;
+
+		fd = btf__fd(btf);
+		btf__set_fd(btf, -1);
+		id = btf_obj_id(btf);
 
 		err = libbpf_ensure_mem((void **)&obj->btf_modules, &obj->btf_module_cap,
 				        sizeof(*obj->btf_modules), obj->btf_module_cnt + 1);
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index a1ad145ffa74..9b0bbd4a5f64 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -366,9 +366,14 @@ int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
 			 const char *str_sec, size_t str_len);
 int btf_load_into_kernel(struct btf *btf, char *log_buf, size_t log_sz, __u32 log_level);
 
-struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf);
 void btf_get_kernel_prefix_kind(enum bpf_attach_type attach_type,
 				const char **prefix, int *kind);
+__u32 btf_obj_id(const struct btf *btf);
+
+#define BTF_NAME_BUF_LEN 64
+
+struct btf *btf_load_next_with_info(__u32 start_id, struct bpf_btf_info *info,
+				    struct btf *base_btf, bool vmlinux);
 
 struct btf_ext_info {
 	/*
-- 
2.36.1

