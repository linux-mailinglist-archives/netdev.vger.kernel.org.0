Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11FBB5B08EF
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiIGPpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiIGPpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:45:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B674A81D
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zzJ9iGRxFY7VwR0DTvK6zA/xNig8/8UFuA2SVUAPlTs=;
        b=SGapSvvOFS5WH2sHpp0zFD5OhtLzGqXLkCfMCjkix2kdGpn5GzK52E1MEiELr884JOd7Ea
        7/PfT/1bNxneaCt8mS1H9P+OAZh9TRsl1r5+kBuX23YN7FI43goW/hcuiMY81Bor2/ZtUP
        0IS66D3Hq8HnKo/+0+oAtlfRi7OQKh8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-Jo85jWahNLKQgkxiOFiz_Q-1; Wed, 07 Sep 2022 11:45:07 -0400
X-MC-Unique: Jo85jWahNLKQgkxiOFiz_Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6419811E83;
        Wed,  7 Sep 2022 15:45:06 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 754704010D2A;
        Wed,  7 Sep 2022 15:45:06 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id B1D9430721A6C;
        Wed,  7 Sep 2022 17:45:05 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 01/18] libbpf: factor out BTF loading from
 load_module_btfs()
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Date:   Wed, 07 Sep 2022 17:45:05 +0200
Message-ID: <166256550566.1434226.11682408188276569750.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 tools/lib/bpf/btf.c             |  110 +++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.c          |   52 ++++--------------
 tools/lib/bpf/libbpf_internal.h |    7 ++
 3 files changed, 126 insertions(+), 43 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 361131518d63..cad11c56cf1f 100644
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
@@ -458,6 +466,11 @@ const struct btf *btf__base_btf(const struct btf *btf)
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
@@ -814,6 +827,7 @@ static struct btf *btf_new_empty(struct btf *base_btf)
 	btf->fd = -1;
 	btf->ptr_sz = sizeof(void *);
 	btf->swapped_endian = false;
+	btf->id = 0;
 
 	if (base_btf) {
 		btf->base_btf = base_btf;
@@ -864,6 +878,7 @@ static struct btf *btf_new(const void *data, __u32 size, struct btf *base_btf)
 	btf->start_id = 1;
 	btf->start_str_off = 0;
 	btf->fd = -1;
+	btf->id = 0;
 
 	if (base_btf) {
 		btf->base_btf = base_btf;
@@ -1327,7 +1342,7 @@ const char *btf__name_by_offset(const struct btf *btf, __u32 offset)
 	return btf__str_by_offset(btf, offset);
 }
 
-struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
+static struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
 {
 	struct bpf_btf_info btf_info;
 	__u32 len = sizeof(btf_info);
@@ -1375,6 +1390,8 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
 	}
 
 	btf = btf_new(ptr, btf_info.btf_size, base_btf);
+	if (!IS_ERR_OR_NULL(btf))
+		btf->id = btf_info.id;
 
 exit_free:
 	free(ptr);
@@ -4636,6 +4653,97 @@ static int btf_dedup_remap_types(struct btf_dedup *d)
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
index 3ad139285fad..ff0a2b026cd4 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5341,11 +5341,11 @@ int bpf_core_add_cands(struct bpf_core_cand *local_cand,
 
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
@@ -5362,49 +5362,19 @@ static int load_module_btfs(struct bpf_object *obj)
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
index 377642ff51fc..02d8f544eade 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -367,9 +367,14 @@ int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
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


