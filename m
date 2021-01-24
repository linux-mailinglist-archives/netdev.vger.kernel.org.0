Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF8C301F28
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 23:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbhAXWQx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 24 Jan 2021 17:16:53 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:46609 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726608AbhAXWQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 17:16:43 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-5AiBYZKkMmqhuJK12LSdWg-1; Sun, 24 Jan 2021 17:15:40 -0500
X-MC-Unique: 5AiBYZKkMmqhuJK12LSdWg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5ED1192FDA0;
        Sun, 24 Jan 2021 22:15:38 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DCE65B4D1;
        Sun, 24 Jan 2021 22:15:35 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     dwarves@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Subject: [PATCH 2/2] bpf_encoder: Translate SHN_XINDEX in symbol's st_shndx values
Date:   Sun, 24 Jan 2021 23:15:19 +0100
Message-Id: <20210124221519.219750-3-jolsa@kernel.org>
In-Reply-To: <20210124221519.219750-1-jolsa@kernel.org>
References: <20210124221519.219750-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For very large ELF objects (with many sections), we could
get special value SHN_XINDEX (65535) for symbol's st_shndx.

This patch is adding code to detect the optional extended
section index table and use it to resolve symbol's section
index.

Adding elf_symtab__for_each_symbol_index macro that returns
symbol's section index and usign it in collect functions.

Tested by running pahole on kernel compiled with:
  make KCFLAGS="-ffunction-sections -fdata-sections" -j$(nproc) vmlinux

and ensure FUNC records are generated and match normal
build (without above KCFLAGS).

Also bpf selftest passed and generated kernel BTF,
is same as without the patch.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 btf_encoder.c | 33 +++++++++++++++++----------------
 elf_symtab.c  | 41 +++++++++++++++++++++++++++++++++++++++--
 elf_symtab.h  | 29 +++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 18 deletions(-)

diff --git a/btf_encoder.c b/btf_encoder.c
index 5557c9efd365..b124ec20a689 100644
--- a/btf_encoder.c
+++ b/btf_encoder.c
@@ -63,13 +63,13 @@ static void delete_functions(void)
 #define max(x, y) ((x) < (y) ? (y) : (x))
 #endif
 
-static int collect_function(struct btf_elf *btfe, GElf_Sym *sym)
+static int collect_function(struct btf_elf *btfe, GElf_Sym *sym,
+			    size_t sym_sec_idx)
 {
 	struct elf_function *new;
 	static GElf_Shdr sh;
-	static int last_idx;
+	static size_t last_idx;
 	const char *name;
-	int idx;
 
 	if (elf_sym__type(sym) != STT_FUNC)
 		return 0;
@@ -90,12 +90,10 @@ static int collect_function(struct btf_elf *btfe, GElf_Sym *sym)
 		functions = new;
 	}
 
-	idx = elf_sym__section(sym);
-
-	if (idx != last_idx) {
-		if (!elf_section_by_idx(btfe->elf, &sh, idx))
+	if (sym_sec_idx != last_idx) {
+		if (!elf_section_by_idx(btfe->elf, &sh, sym_sec_idx))
 			return 0;
-		last_idx = idx;
+		last_idx = sym_sec_idx;
 	}
 
 	functions[functions_cnt].name = name;
@@ -542,14 +540,15 @@ static bool percpu_var_exists(uint64_t addr, uint32_t *sz, const char **name)
 	return true;
 }
 
-static int collect_percpu_var(struct btf_elf *btfe, GElf_Sym *sym)
+static int collect_percpu_var(struct btf_elf *btfe, GElf_Sym *sym,
+			      size_t sym_sec_idx)
 {
 	const char *sym_name;
 	uint64_t addr;
 	uint32_t size;
 
 	/* compare a symbol's shndx to determine if it's a percpu variable */
-	if (elf_sym__section(sym) != btfe->percpu_shndx)
+	if (sym_sec_idx != btfe->percpu_shndx)
 		return 0;
 	if (elf_sym__type(sym) != STT_OBJECT)
 		return 0;
@@ -585,12 +584,13 @@ static int collect_percpu_var(struct btf_elf *btfe, GElf_Sym *sym)
 	return 0;
 }
 
-static void collect_symbol(GElf_Sym *sym, struct funcs_layout *fl)
+static void collect_symbol(GElf_Sym *sym, struct funcs_layout *fl,
+			   size_t sym_sec_idx)
 {
 	if (!fl->mcount_start &&
 	    !strcmp("__start_mcount_loc", elf_sym__name(sym, btfe->symtab))) {
 		fl->mcount_start = sym->st_value;
-		fl->mcount_sec_idx = sym->st_shndx;
+		fl->mcount_sec_idx = sym_sec_idx;
 	}
 
 	if (!fl->mcount_stop &&
@@ -601,6 +601,7 @@ static void collect_symbol(GElf_Sym *sym, struct funcs_layout *fl)
 static int collect_symbols(struct btf_elf *btfe, bool collect_percpu_vars)
 {
 	struct funcs_layout fl = { };
+	Elf32_Word sym_sec_idx;
 	uint32_t core_id;
 	GElf_Sym sym;
 
@@ -608,12 +609,12 @@ static int collect_symbols(struct btf_elf *btfe, bool collect_percpu_vars)
 	percpu_var_cnt = 0;
 
 	/* search within symtab for percpu variables */
-	elf_symtab__for_each_symbol(btfe->symtab, core_id, sym) {
-		if (collect_percpu_vars && collect_percpu_var(btfe, &sym))
+	elf_symtab__for_each_symbol_index(btfe->symtab, core_id, sym, sym_sec_idx) {
+		if (collect_percpu_vars && collect_percpu_var(btfe, &sym, sym_sec_idx))
 			return -1;
-		if (collect_function(btfe, &sym))
+		if (collect_function(btfe, &sym, sym_sec_idx))
 			return -1;
-		collect_symbol(&sym, &fl);
+		collect_symbol(&sym, &fl, sym_sec_idx);
 	}
 
 	if (collect_percpu_vars) {
diff --git a/elf_symtab.c b/elf_symtab.c
index 741990ea3ed9..77c5dc423c56 100644
--- a/elf_symtab.c
+++ b/elf_symtab.c
@@ -17,11 +17,13 @@
 
 struct elf_symtab *elf_symtab__new(const char *name, Elf *elf, GElf_Ehdr *ehdr)
 {
+	size_t symtab_index;
+
 	if (name == NULL)
 		name = ".symtab";
 
 	GElf_Shdr shdr;
-	Elf_Scn *sec = elf_section_by_name(elf, ehdr, &shdr, name, NULL);
+	Elf_Scn *sec = elf_section_by_name(elf, ehdr, &shdr, name, &symtab_index);
 
 	if (sec == NULL)
 		return NULL;
@@ -29,7 +31,7 @@ struct elf_symtab *elf_symtab__new(const char *name, Elf *elf, GElf_Ehdr *ehdr)
 	if (gelf_getshdr(sec, &shdr) == NULL)
 		return NULL;
 
-	struct elf_symtab *symtab = malloc(sizeof(*symtab));
+	struct elf_symtab *symtab = zalloc(sizeof(*symtab));
 	if (symtab == NULL)
 		return NULL;
 
@@ -41,6 +43,12 @@ struct elf_symtab *elf_symtab__new(const char *name, Elf *elf, GElf_Ehdr *ehdr)
 	if (symtab->syms == NULL)
 		goto out_free_name;
 
+	/*
+	 * This returns extended section index table's
+	 * section index, if it exists.
+	 */
+	int symtab_xindex = elf_scnshndx(sec);
+
 	sec = elf_getscn(elf, shdr.sh_link);
 	if (sec == NULL)
 		goto out_free_name;
@@ -49,6 +57,35 @@ struct elf_symtab *elf_symtab__new(const char *name, Elf *elf, GElf_Ehdr *ehdr)
 	if (symtab->symstrs == NULL)
 		goto out_free_name;
 
+	/*
+	 * The .symtab section has optional extended section index
+	 * table, load its data so it can be used to resolve symbol's
+	 * section index.
+	 **/
+	if (symtab_xindex > 0) {
+		GElf_Shdr shdr_xindex;
+		Elf_Scn *sec_xindex;
+
+		sec_xindex = elf_getscn(elf, symtab_xindex);
+		if (sec_xindex == NULL)
+			goto out_free_name;
+
+		if (gelf_getshdr(sec_xindex, &shdr_xindex) == NULL)
+			goto out_free_name;
+
+		/* Extra check to verify it's correct type */
+		if (shdr_xindex.sh_type != SHT_SYMTAB_SHNDX)
+			goto out_free_name;
+
+		/* Extra check to verify it belongs to the .symtab */
+		if (symtab_index != shdr_xindex.sh_link)
+			goto out_free_name;
+
+		symtab->syms_sec_idx_table = elf_getdata(elf_getscn(elf, symtab_xindex), NULL);
+		if (symtab->syms_sec_idx_table == NULL)
+			goto out_free_name;
+	}
+
 	symtab->nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	return symtab;
diff --git a/elf_symtab.h b/elf_symtab.h
index 359add69c8ab..489e2b1a3505 100644
--- a/elf_symtab.h
+++ b/elf_symtab.h
@@ -16,6 +16,8 @@ struct elf_symtab {
 	uint32_t  nr_syms;
 	Elf_Data  *syms;
 	Elf_Data  *symstrs;
+	/* Data of SHT_SYMTAB_SHNDX section. */
+	Elf_Data  *syms_sec_idx_table;
 	char	  *name;
 };
 
@@ -77,6 +79,19 @@ static inline bool elf_sym__is_local_object(const GElf_Sym *sym)
 	       sym->st_shndx != SHN_UNDEF;
 }
 
+static inline bool
+elf_sym__get(Elf_Data *syms, Elf_Data *syms_sec_idx_table,
+	     int id, GElf_Sym *sym, Elf32_Word *sym_sec_idx)
+{
+	if (!gelf_getsymshndx(syms, syms_sec_idx_table, id, sym, sym_sec_idx))
+		return false;
+
+	if (sym->st_shndx != SHN_XINDEX)
+		*sym_sec_idx = sym->st_shndx;
+
+	return true;
+}
+
 /**
  * elf_symtab__for_each_symbol - iterate thru all the symbols
  *
@@ -89,4 +104,18 @@ static inline bool elf_sym__is_local_object(const GElf_Sym *sym)
 	     index < symtab->nr_syms; \
 	     index++, gelf_getsym(symtab->syms, index, &sym))
 
+/**
+ * elf_symtab__for_each_symbol_index - iterate through all the symbols,
+ * that takes extended symbols indexes into account
+ *
+ * @symtab: struct elf_symtab instance to iterate
+ * @index: uint32_t index
+ * @sym: GElf_Sym iterator
+ * @sym_sec_idx: symbol's index
+ */
+#define elf_symtab__for_each_symbol_index(symtab, id, sym, sym_sec_idx)		\
+	for (id = 0; id < symtab->nr_syms; id++)				\
+		if (elf_sym__get(symtab->syms, symtab->syms_sec_idx_table,	\
+				 id, &sym, &sym_sec_idx))
+
 #endif /* _ELF_SYMTAB_H_ */
-- 
2.26.2

