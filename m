Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD042FC323
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbhASWPZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Jan 2021 17:15:25 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:54253 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389168AbhASWNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 17:13:36 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-pESdaNy3OP-4R8EIVaHF8w-1; Tue, 19 Jan 2021 17:12:39 -0500
X-MC-Unique: pESdaNy3OP-4R8EIVaHF8w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A44CF10054FF;
        Tue, 19 Jan 2021 22:12:37 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 745F19CA0;
        Tue, 19 Jan 2021 22:12:34 +0000 (UTC)
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
Subject: [PATCH 2/3] bpf_encoder: Translate SHN_XINDEX in symbol's st_shndx values
Date:   Tue, 19 Jan 2021 23:12:19 +0100
Message-Id: <20210119221220.1745061-3-jolsa@kernel.org>
In-Reply-To: <20210119221220.1745061-1-jolsa@kernel.org>
References: <20210119221220.1745061-1-jolsa@kernel.org>
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
index id needed.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 btf_encoder.c | 18 ++++++++++++++++++
 elf_symtab.c  | 31 ++++++++++++++++++++++++++++++-
 elf_symtab.h  |  1 +
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/btf_encoder.c b/btf_encoder.c
index 5557c9efd365..2ab6815dc2b3 100644
--- a/btf_encoder.c
+++ b/btf_encoder.c
@@ -609,6 +609,24 @@ static int collect_symbols(struct btf_elf *btfe, bool collect_percpu_vars)
 
 	/* search within symtab for percpu variables */
 	elf_symtab__for_each_symbol(btfe->symtab, core_id, sym) {
+		struct elf_symtab *symtab = btfe->symtab;
+
+		/*
+		 * Symbol's st_shndx needs to be translated with the
+		 * extended section index table.
+		 */
+		if (sym.st_shndx == SHN_XINDEX) {
+			Elf32_Word xndx;
+
+			if (!symtab->syms_shndx) {
+				fprintf(stderr, "SHN_XINDEX found, but no symtab shndx section.\n");
+				return -1;
+			}
+
+			if (gelf_getsymshndx(symtab->syms, symtab->syms_shndx, core_id, &sym, &xndx))
+				sym.st_shndx = xndx;
+		}
+
 		if (collect_percpu_vars && collect_percpu_var(btfe, &sym))
 			return -1;
 		if (collect_function(btfe, &sym))
diff --git a/elf_symtab.c b/elf_symtab.c
index 741990ea3ed9..c1def0189652 100644
--- a/elf_symtab.c
+++ b/elf_symtab.c
@@ -17,11 +17,13 @@
 
 struct elf_symtab *elf_symtab__new(const char *name, Elf *elf, GElf_Ehdr *ehdr)
 {
+	size_t index;
+
 	if (name == NULL)
 		name = ".symtab";
 
 	GElf_Shdr shdr;
-	Elf_Scn *sec = elf_section_by_name(elf, ehdr, &shdr, name, NULL);
+	Elf_Scn *sec = elf_section_by_name(elf, ehdr, &shdr, name, &index);
 
 	if (sec == NULL)
 		return NULL;
@@ -29,6 +31,8 @@ struct elf_symtab *elf_symtab__new(const char *name, Elf *elf, GElf_Ehdr *ehdr)
 	if (gelf_getshdr(sec, &shdr) == NULL)
 		return NULL;
 
+	int xindex = elf_scnshndx(sec);
+
 	struct elf_symtab *symtab = malloc(sizeof(*symtab));
 	if (symtab == NULL)
 		return NULL;
@@ -49,6 +53,31 @@ struct elf_symtab *elf_symtab__new(const char *name, Elf *elf, GElf_Ehdr *ehdr)
 	if (symtab->symstrs == NULL)
 		goto out_free_name;
 
+	/*
+	 * The .symtab section has optional extended section index
+	 * table, load its data so it can be used to resolve symbol's
+	 * section index.
+	 **/
+	if (xindex > 0) {
+		GElf_Shdr shdr_shndx;
+		Elf_Scn *sec_shndx;
+
+		sec_shndx = elf_getscn(elf, xindex);
+		if (sec_shndx == NULL)
+			goto out_free_name;
+
+		if (gelf_getshdr(sec_shndx, &shdr_shndx) == NULL)
+			goto out_free_name;
+
+		/* Extra check to verify it belongs to the .symtab */
+		if (index != shdr_shndx.sh_link)
+			goto out_free_name;
+
+		symtab->syms_shndx = elf_getdata(elf_getscn(elf, xindex), NULL);
+		if (symtab->syms_shndx == NULL)
+			goto out_free_name;
+	}
+
 	symtab->nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	return symtab;
diff --git a/elf_symtab.h b/elf_symtab.h
index 359add69c8ab..f9277a48ed4c 100644
--- a/elf_symtab.h
+++ b/elf_symtab.h
@@ -16,6 +16,7 @@ struct elf_symtab {
 	uint32_t  nr_syms;
 	Elf_Data  *syms;
 	Elf_Data  *symstrs;
+	Elf_Data  *syms_shndx;
 	char	  *name;
 };
 
-- 
2.27.0

