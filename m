Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB7C24C83B
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgHTXNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:13:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55968 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728661AbgHTXNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:13:01 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KNA5Yg013971
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:12:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=WDLoYgp0TrTLgFNM0lrYQP5548eLofctgWau85KDG44=;
 b=YQ0pyOoZCMHSqghqxu1KAZwpSfrp8wGwiepp6T4MHuKium3UcmKp+yzdwjbtzx0Przk4
 qIRNvVHmqJ+bqaBrFQLYSdrH9BuvcyEeA96D9eGNySUrvcKzWYVW6pLp5zrAx0e5FFUd
 2g00iIsg1RDCDX8PelzAFxydFySvIB7tP7g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3318g0qhyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:12:57 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 16:12:56 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6FF652EC5F42; Thu, 20 Aug 2020 16:12:56 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 02/16] libbpf: factor out common ELF operations and improve logging
Date:   Thu, 20 Aug 2020 16:12:36 -0700
Message-ID: <20200820231250.1293069-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200820231250.1293069-1-andriin@fb.com>
References: <20200820231250.1293069-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_07:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=9 mlxscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out common ELF operations done throughout the libbpf. This simplif=
ies
usage across multiple places in libbpf, as well as hide error reporting f=
rom
higher-level functions and make error logging more consistent.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 367 +++++++++++++++++++++++------------------
 1 file changed, 206 insertions(+), 161 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0bc1fd813408..1f7e2ac0979e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -398,6 +398,7 @@ struct bpf_object {
 		Elf_Data *rodata;
 		Elf_Data *bss;
 		Elf_Data *st_ops_data;
+		size_t shstrndx; /* section index for section name strings */
 		size_t strtabidx;
 		struct {
 			GElf_Shdr shdr;
@@ -435,6 +436,14 @@ struct bpf_object {
 };
 #define obj_elf_valid(o)	((o)->efile.elf)
=20
+static const char *elf_sym_str(const struct bpf_object *obj, size_t off)=
;
+static const char *elf_sec_str(const struct bpf_object *obj, size_t off)=
;
+static Elf_Scn *elf_sec_by_idx(const struct bpf_object *obj, size_t idx)=
;
+static Elf_Scn *elf_sec_by_name(const struct bpf_object *obj, const char=
 *name);
+static int elf_sec_hdr(const struct bpf_object *obj, Elf_Scn *scn, GElf_=
Shdr *hdr);
+static const char *elf_sec_name(const struct bpf_object *obj, Elf_Scn *s=
cn);
+static Elf_Data *elf_sec_data(const struct bpf_object *obj, Elf_Scn *scn=
);
+
 void bpf_program__unload(struct bpf_program *prog)
 {
 	int i;
@@ -496,7 +505,7 @@ static char *__bpf_program__pin_name(struct bpf_progr=
am *prog)
 }
=20
 static int
-bpf_program__init(void *data, size_t size, char *section_name, int idx,
+bpf_program__init(void *data, size_t size, const char *section_name, int=
 idx,
 		  struct bpf_program *prog)
 {
 	const size_t bpf_insn_sz =3D sizeof(struct bpf_insn);
@@ -545,7 +554,7 @@ bpf_program__init(void *data, size_t size, char *sect=
ion_name, int idx,
=20
 static int
 bpf_object__add_program(struct bpf_object *obj, void *data, size_t size,
-			char *section_name, int idx)
+			const char *section_name, int idx)
 {
 	struct bpf_program prog, *progs;
 	int nr_progs, err;
@@ -570,7 +579,7 @@ bpf_object__add_program(struct bpf_object *obj, void =
*data, size_t size,
 		return -ENOMEM;
 	}
=20
-	pr_debug("found program %s\n", prog.section_name);
+	pr_debug("elf: found program '%s'\n", prog.section_name);
 	obj->programs =3D progs;
 	obj->nr_programs =3D nr_progs + 1;
 	prog.obj =3D obj;
@@ -590,8 +599,7 @@ bpf_object__init_prog_names(struct bpf_object *obj)
=20
 		prog =3D &obj->programs[pi];
=20
-		for (si =3D 0; si < symbols->d_size / sizeof(GElf_Sym) && !name;
-		     si++) {
+		for (si =3D 0; si < symbols->d_size / sizeof(GElf_Sym) && !name; si++)=
 {
 			GElf_Sym sym;
=20
 			if (!gelf_getsym(symbols, si, &sym))
@@ -601,11 +609,9 @@ bpf_object__init_prog_names(struct bpf_object *obj)
 			if (GELF_ST_BIND(sym.st_info) !=3D STB_GLOBAL)
 				continue;
=20
-			name =3D elf_strptr(obj->efile.elf,
-					  obj->efile.strtabidx,
-					  sym.st_name);
+			name =3D elf_sym_str(obj, sym.st_name);
 			if (!name) {
-				pr_warn("failed to get sym name string for prog %s\n",
+				pr_warn("prog '%s': failed to get symbol name\n",
 					prog->section_name);
 				return -LIBBPF_ERRNO__LIBELF;
 			}
@@ -615,17 +621,14 @@ bpf_object__init_prog_names(struct bpf_object *obj)
 			name =3D ".text";
=20
 		if (!name) {
-			pr_warn("failed to find sym for prog %s\n",
+			pr_warn("prog '%s': failed to find program symbol\n",
 				prog->section_name);
 			return -EINVAL;
 		}
=20
 		prog->name =3D strdup(name);
-		if (!prog->name) {
-			pr_warn("failed to allocate memory for prog sym %s\n",
-				name);
+		if (!prog->name)
 			return -ENOMEM;
-		}
 	}
=20
 	return 0;
@@ -1069,7 +1072,7 @@ static int bpf_object__elf_init(struct bpf_object *=
obj)
 	GElf_Ehdr *ep;
=20
 	if (obj_elf_valid(obj)) {
-		pr_warn("elf init: internal error\n");
+		pr_warn("elf: init internal error\n");
 		return -LIBBPF_ERRNO__LIBELF;
 	}
=20
@@ -1087,7 +1090,7 @@ static int bpf_object__elf_init(struct bpf_object *=
obj)
=20
 			err =3D -errno;
 			cp =3D libbpf_strerror_r(err, errmsg, sizeof(errmsg));
-			pr_warn("failed to open %s: %s\n", obj->path, cp);
+			pr_warn("elf: failed to open %s: %s\n", obj->path, cp);
 			return err;
 		}
=20
@@ -1095,22 +1098,36 @@ static int bpf_object__elf_init(struct bpf_object=
 *obj)
 	}
=20
 	if (!obj->efile.elf) {
-		pr_warn("failed to open %s as ELF file\n", obj->path);
+		pr_warn("elf: failed to open %s as ELF file: %s\n", obj->path, elf_err=
msg(-1));
 		err =3D -LIBBPF_ERRNO__LIBELF;
 		goto errout;
 	}
=20
 	if (!gelf_getehdr(obj->efile.elf, &obj->efile.ehdr)) {
-		pr_warn("failed to get EHDR from %s\n", obj->path);
+		pr_warn("elf: failed to get ELF header from %s: %s\n", obj->path, elf_=
errmsg(-1));
 		err =3D -LIBBPF_ERRNO__FORMAT;
 		goto errout;
 	}
 	ep =3D &obj->efile.ehdr;
=20
+	if (elf_getshdrstrndx(obj->efile.elf, &obj->efile.shstrndx)) {
+		pr_warn("elf: failed to get section names section index for %s: %s\n",
+			obj->path, elf_errmsg(-1));
+		err =3D -LIBBPF_ERRNO__FORMAT;
+		goto errout;
+	}
+
+	/* Elf is corrupted/truncated, avoid calling elf_strptr. */
+	if (!elf_rawdata(elf_getscn(obj->efile.elf, obj->efile.shstrndx), NULL)=
) {
+		pr_warn("elf: failed to get section names strings from %s: %s\n",
+			obj->path, elf_errmsg(-1));
+		return -LIBBPF_ERRNO__FORMAT;
+	}
+
 	/* Old LLVM set e_machine to EM_NONE */
 	if (ep->e_type !=3D ET_REL ||
 	    (ep->e_machine && ep->e_machine !=3D EM_BPF)) {
-		pr_warn("%s is not an eBPF object file\n", obj->path);
+		pr_warn("elf: %s is not a valid eBPF object file\n", obj->path);
 		err =3D -LIBBPF_ERRNO__FORMAT;
 		goto errout;
 	}
@@ -1132,7 +1149,7 @@ static int bpf_object__check_endianness(struct bpf_=
object *obj)
 #else
 # error "Unrecognized __BYTE_ORDER__"
 #endif
-	pr_warn("endianness mismatch.\n");
+	pr_warn("elf: endianness mismatch in %s.\n", obj->path);
 	return -LIBBPF_ERRNO__ENDIAN;
 }
=20
@@ -1167,55 +1184,10 @@ static bool bpf_map_type__is_map_in_map(enum bpf_=
map_type type)
 	return false;
 }
=20
-static int bpf_object_search_section_size(const struct bpf_object *obj,
-					  const char *name, size_t *d_size)
-{
-	const GElf_Ehdr *ep =3D &obj->efile.ehdr;
-	Elf *elf =3D obj->efile.elf;
-	Elf_Scn *scn =3D NULL;
-	int idx =3D 0;
-
-	while ((scn =3D elf_nextscn(elf, scn)) !=3D NULL) {
-		const char *sec_name;
-		Elf_Data *data;
-		GElf_Shdr sh;
-
-		idx++;
-		if (gelf_getshdr(scn, &sh) !=3D &sh) {
-			pr_warn("failed to get section(%d) header from %s\n",
-				idx, obj->path);
-			return -EIO;
-		}
-
-		sec_name =3D elf_strptr(elf, ep->e_shstrndx, sh.sh_name);
-		if (!sec_name) {
-			pr_warn("failed to get section(%d) name from %s\n",
-				idx, obj->path);
-			return -EIO;
-		}
-
-		if (strcmp(name, sec_name))
-			continue;
-
-		data =3D elf_getdata(scn, 0);
-		if (!data) {
-			pr_warn("failed to get section(%d) data from %s(%s)\n",
-				idx, name, obj->path);
-			return -EIO;
-		}
-
-		*d_size =3D data->d_size;
-		return 0;
-	}
-
-	return -ENOENT;
-}
-
 int bpf_object__section_size(const struct bpf_object *obj, const char *n=
ame,
 			     __u32 *size)
 {
 	int ret =3D -ENOENT;
-	size_t d_size;
=20
 	*size =3D 0;
 	if (!name) {
@@ -1233,9 +1205,13 @@ int bpf_object__section_size(const struct bpf_obje=
ct *obj, const char *name,
 		if (obj->efile.st_ops_data)
 			*size =3D obj->efile.st_ops_data->d_size;
 	} else {
-		ret =3D bpf_object_search_section_size(obj, name, &d_size);
-		if (!ret)
-			*size =3D d_size;
+		Elf_Scn *scn =3D elf_sec_by_name(obj, name);
+		Elf_Data *data =3D elf_sec_data(obj, scn);
+
+		if (data) {
+			ret =3D 0; /* found it */
+			*size =3D data->d_size;
+		}
 	}
=20
 	return *size ? 0 : ret;
@@ -1260,8 +1236,7 @@ int bpf_object__variable_offset(const struct bpf_ob=
ject *obj, const char *name,
 		    GELF_ST_TYPE(sym.st_info) !=3D STT_OBJECT)
 			continue;
=20
-		sname =3D elf_strptr(obj->efile.elf, obj->efile.strtabidx,
-				   sym.st_name);
+		sname =3D elf_sym_str(obj, sym.st_name);
 		if (!sname) {
 			pr_warn("failed to get sym name string for var %s\n",
 				name);
@@ -1738,12 +1713,12 @@ static int bpf_object__init_user_maps(struct bpf_=
object *obj, bool strict)
 	if (!symbols)
 		return -EINVAL;
=20
-	scn =3D elf_getscn(obj->efile.elf, obj->efile.maps_shndx);
-	if (scn)
-		data =3D elf_getdata(scn, NULL);
+
+	scn =3D elf_sec_by_idx(obj, obj->efile.maps_shndx);
+	data =3D elf_sec_data(obj, scn);
 	if (!scn || !data) {
-		pr_warn("failed to get Elf_Data from map section %d\n",
-			obj->efile.maps_shndx);
+		pr_warn("elf: failed to get legacy map definitions for %s\n",
+			obj->path);
 		return -EINVAL;
 	}
=20
@@ -1765,12 +1740,12 @@ static int bpf_object__init_user_maps(struct bpf_=
object *obj, bool strict)
 		nr_maps++;
 	}
 	/* Assume equally sized map definitions */
-	pr_debug("maps in %s: %d maps in %zd bytes\n",
-		 obj->path, nr_maps, data->d_size);
+	pr_debug("elf: found %d legacy map definitions (%zd bytes) in %s\n",
+		 nr_maps, data->d_size, obj->path);
=20
 	if (!data->d_size || nr_maps =3D=3D 0 || (data->d_size % nr_maps) !=3D =
0) {
-		pr_warn("unable to determine map definition size section %s, %d maps i=
n %zd bytes\n",
-			obj->path, nr_maps, data->d_size);
+		pr_warn("elf: unable to determine legacy map definition size in %s\n",
+			obj->path);
 		return -EINVAL;
 	}
 	map_def_sz =3D data->d_size / nr_maps;
@@ -1791,8 +1766,7 @@ static int bpf_object__init_user_maps(struct bpf_ob=
ject *obj, bool strict)
 		if (IS_ERR(map))
 			return PTR_ERR(map);
=20
-		map_name =3D elf_strptr(obj->efile.elf, obj->efile.strtabidx,
-				      sym.st_name);
+		map_name =3D elf_sym_str(obj, sym.st_name);
 		if (!map_name) {
 			pr_warn("failed to get map #%d name sym string for obj %s\n",
 				i, obj->path);
@@ -2274,12 +2248,11 @@ static int bpf_object__init_user_btf_maps(struct =
bpf_object *obj, bool strict,
 	if (obj->efile.btf_maps_shndx < 0)
 		return 0;
=20
-	scn =3D elf_getscn(obj->efile.elf, obj->efile.btf_maps_shndx);
-	if (scn)
-		data =3D elf_getdata(scn, NULL);
+	scn =3D elf_sec_by_idx(obj, obj->efile.btf_maps_shndx);
+	data =3D elf_sec_data(obj, scn);
 	if (!scn || !data) {
-		pr_warn("failed to get Elf_Data from map section %d (%s)\n",
-			obj->efile.maps_shndx, MAPS_ELF_SEC);
+		pr_warn("elf: failed to get %s map definitions for %s\n",
+			MAPS_ELF_SEC, obj->path);
 		return -EINVAL;
 	}
=20
@@ -2337,20 +2310,12 @@ static int bpf_object__init_maps(struct bpf_objec=
t *obj,
=20
 static bool section_have_execinstr(struct bpf_object *obj, int idx)
 {
-	Elf_Scn *scn;
 	GElf_Shdr sh;
=20
-	scn =3D elf_getscn(obj->efile.elf, idx);
-	if (!scn)
-		return false;
-
-	if (gelf_getshdr(scn, &sh) !=3D &sh)
+	if (elf_sec_hdr(obj, elf_sec_by_idx(obj, idx), &sh))
 		return false;
=20
-	if (sh.sh_flags & SHF_EXECINSTR)
-		return true;
-
-	return false;
+	return sh.sh_flags & SHF_EXECINSTR;
 }
=20
 static bool btf_needs_sanitization(struct bpf_object *obj)
@@ -2594,61 +2559,156 @@ static int bpf_object__sanitize_and_load_btf(str=
uct bpf_object *obj)
 	return err;
 }
=20
+static const char *elf_sym_str(const struct bpf_object *obj, size_t off)
+{
+	const char *name;
+
+	name =3D elf_strptr(obj->efile.elf, obj->efile.strtabidx, off);
+	if (!name) {
+		pr_warn("elf: failed to get section name string at offset %zu from %s:=
 %s\n",
+			off, obj->path, elf_errmsg(-1));
+		return NULL;
+	}
+
+	return name;
+}
+
+static const char *elf_sec_str(const struct bpf_object *obj, size_t off)
+{
+	const char *name;
+
+	name =3D elf_strptr(obj->efile.elf, obj->efile.shstrndx, off);
+	if (!name) {
+		pr_warn("elf: failed to get section name string at offset %zu from %s:=
 %s\n",
+			off, obj->path, elf_errmsg(-1));
+		return NULL;
+	}
+
+	return name;
+}
+
+static Elf_Scn *elf_sec_by_idx(const struct bpf_object *obj, size_t idx)
+{
+	Elf_Scn *scn;
+
+	scn =3D elf_getscn(obj->efile.elf, idx);
+	if (!scn) {
+		pr_warn("elf: failed to get section(%zu) from %s: %s\n",
+			idx, obj->path, elf_errmsg(-1));
+		return NULL;
+	}
+	return scn;
+}
+
+static Elf_Scn *elf_sec_by_name(const struct bpf_object *obj, const char=
 *name)
+{
+	Elf_Scn *scn =3D NULL;
+	Elf *elf =3D obj->efile.elf;
+	const char *sec_name;
+
+	while ((scn =3D elf_nextscn(elf, scn)) !=3D NULL) {
+		sec_name =3D elf_sec_name(obj, scn);
+		if (!sec_name)
+			return NULL;
+
+		if (strcmp(sec_name, name) !=3D 0)
+			continue;
+
+		return scn;
+	}
+	return NULL;
+}
+
+static int elf_sec_hdr(const struct bpf_object *obj, Elf_Scn *scn, GElf_=
Shdr *hdr)
+{
+	if (!scn)
+		return -EINVAL;
+
+	if (gelf_getshdr(scn, hdr) !=3D hdr) {
+		pr_warn("elf: failed to get section(%zu) header from %s: %s\n",
+			elf_ndxscn(scn), obj->path, elf_errmsg(-1));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const char *elf_sec_name(const struct bpf_object *obj, Elf_Scn *s=
cn)
+{
+	const char *name;
+	GElf_Shdr sh;
+
+	if (!scn)
+		return NULL;
+
+	if (elf_sec_hdr(obj, scn, &sh))
+		return NULL;
+
+	name =3D elf_sec_str(obj, sh.sh_name);
+	if (!name) {
+		pr_warn("elf: failed to get section(%zu) name from %s: %s\n",
+			elf_ndxscn(scn), obj->path, elf_errmsg(-1));
+		return NULL;
+	}
+
+	return name;
+}
+
+static Elf_Data *elf_sec_data(const struct bpf_object *obj, Elf_Scn *scn=
)
+{
+	Elf_Data *data;
+
+	if (!scn)
+		return NULL;
+
+	data =3D elf_getdata(scn, 0);
+	if (!data) {
+		pr_warn("elf: failed to get section(%zu) %s data from %s: %s\n",
+			elf_ndxscn(scn), elf_sec_name(obj, scn) ?: "<?>",
+			obj->path, elf_errmsg(-1));
+		return NULL;
+	}
+
+	return data;
+}
+
 static int bpf_object__elf_collect(struct bpf_object *obj)
 {
 	Elf *elf =3D obj->efile.elf;
-	GElf_Ehdr *ep =3D &obj->efile.ehdr;
 	Elf_Data *btf_ext_data =3D NULL;
 	Elf_Data *btf_data =3D NULL;
 	Elf_Scn *scn =3D NULL;
 	int idx =3D 0, err =3D 0;
=20
-	/* Elf is corrupted/truncated, avoid calling elf_strptr. */
-	if (!elf_rawdata(elf_getscn(elf, ep->e_shstrndx), NULL)) {
-		pr_warn("failed to get e_shstrndx from %s\n", obj->path);
-		return -LIBBPF_ERRNO__FORMAT;
-	}
-
 	while ((scn =3D elf_nextscn(elf, scn)) !=3D NULL) {
-		char *name;
+		const char *name;
 		GElf_Shdr sh;
 		Elf_Data *data;
=20
 		idx++;
-		if (gelf_getshdr(scn, &sh) !=3D &sh) {
-			pr_warn("failed to get section(%d) header from %s\n",
-				idx, obj->path);
+
+		if (elf_sec_hdr(obj, scn, &sh))
 			return -LIBBPF_ERRNO__FORMAT;
-		}
=20
-		name =3D elf_strptr(elf, ep->e_shstrndx, sh.sh_name);
-		if (!name) {
-			pr_warn("failed to get section(%d) name from %s\n",
-				idx, obj->path);
+		name =3D elf_sec_str(obj, sh.sh_name);
+		if (!name)
 			return -LIBBPF_ERRNO__FORMAT;
-		}
=20
-		data =3D elf_getdata(scn, 0);
-		if (!data) {
-			pr_warn("failed to get section(%d) data from %s(%s)\n",
-				idx, name, obj->path);
+		data =3D elf_sec_data(obj, scn);
+		if (!data)
 			return -LIBBPF_ERRNO__FORMAT;
-		}
-		pr_debug("section(%d) %s, size %ld, link %d, flags %lx, type=3D%d\n",
+
+		pr_debug("elf: section(%d) %s, size %ld, link %d, flags %lx, type=3D%d=
\n",
 			 idx, name, (unsigned long)data->d_size,
 			 (int)sh.sh_link, (unsigned long)sh.sh_flags,
 			 (int)sh.sh_type);
=20
 		if (strcmp(name, "license") =3D=3D 0) {
-			err =3D bpf_object__init_license(obj,
-						       data->d_buf,
-						       data->d_size);
+			err =3D bpf_object__init_license(obj, data->d_buf, data->d_size);
 			if (err)
 				return err;
 		} else if (strcmp(name, "version") =3D=3D 0) {
-			err =3D bpf_object__init_kversion(obj,
-							data->d_buf,
-							data->d_size);
+			err =3D bpf_object__init_kversion(obj, data->d_buf, data->d_size);
 			if (err)
 				return err;
 		} else if (strcmp(name, "maps") =3D=3D 0) {
@@ -2661,8 +2721,7 @@ static int bpf_object__elf_collect(struct bpf_objec=
t *obj)
 			btf_ext_data =3D data;
 		} else if (sh.sh_type =3D=3D SHT_SYMTAB) {
 			if (obj->efile.symbols) {
-				pr_warn("bpf: multiple SYMTAB in %s\n",
-					obj->path);
+				pr_warn("elf: multiple symbol tables in %s\n", obj->path);
 				return -LIBBPF_ERRNO__FORMAT;
 			}
 			obj->efile.symbols =3D data;
@@ -2675,16 +2734,8 @@ static int bpf_object__elf_collect(struct bpf_obje=
ct *obj)
 				err =3D bpf_object__add_program(obj, data->d_buf,
 							      data->d_size,
 							      name, idx);
-				if (err) {
-					char errmsg[STRERR_BUFSIZE];
-					char *cp;
-
-					cp =3D libbpf_strerror_r(-err, errmsg,
-							       sizeof(errmsg));
-					pr_warn("failed to alloc program %s (%s): %s",
-						name, obj->path, cp);
+				if (err)
 					return err;
-				}
 			} else if (strcmp(name, DATA_SEC) =3D=3D 0) {
 				obj->efile.data =3D data;
 				obj->efile.data_shndx =3D idx;
@@ -2695,7 +2746,8 @@ static int bpf_object__elf_collect(struct bpf_objec=
t *obj)
 				obj->efile.st_ops_data =3D data;
 				obj->efile.st_ops_shndx =3D idx;
 			} else {
-				pr_debug("skip section(%d) %s\n", idx, name);
+				pr_debug("elf: skipping unrecognized data section(%d) %s\n",
+					 idx, name);
 			}
 		} else if (sh.sh_type =3D=3D SHT_REL) {
 			int nr_sects =3D obj->efile.nr_reloc_sects;
@@ -2706,34 +2758,32 @@ static int bpf_object__elf_collect(struct bpf_obj=
ect *obj)
 			if (!section_have_execinstr(obj, sec) &&
 			    strcmp(name, ".rel" STRUCT_OPS_SEC) &&
 			    strcmp(name, ".rel" MAPS_ELF_SEC)) {
-				pr_debug("skip relo %s(%d) for section(%d)\n",
-					 name, idx, sec);
+				pr_debug("elf: skipping relo section(%d) %s for section(%d) %s\n",
+					 idx, name, sec,
+					 elf_sec_name(obj, elf_sec_by_idx(obj, sec)) ?: "<?>");
 				continue;
 			}
=20
 			sects =3D libbpf_reallocarray(sects, nr_sects + 1,
 						    sizeof(*obj->efile.reloc_sects));
-			if (!sects) {
-				pr_warn("reloc_sects realloc failed\n");
+			if (!sects)
 				return -ENOMEM;
-			}
=20
 			obj->efile.reloc_sects =3D sects;
 			obj->efile.nr_reloc_sects++;
=20
 			obj->efile.reloc_sects[nr_sects].shdr =3D sh;
 			obj->efile.reloc_sects[nr_sects].data =3D data;
-		} else if (sh.sh_type =3D=3D SHT_NOBITS &&
-			   strcmp(name, BSS_SEC) =3D=3D 0) {
+		} else if (sh.sh_type =3D=3D SHT_NOBITS && strcmp(name, BSS_SEC) =3D=3D=
 0) {
 			obj->efile.bss =3D data;
 			obj->efile.bss_shndx =3D idx;
 		} else {
-			pr_debug("skip section(%d) %s\n", idx, name);
+			pr_debug("elf: skipping section(%d) %s\n", idx, name);
 		}
 	}
=20
 	if (!obj->efile.strtabidx || obj->efile.strtabidx > idx) {
-		pr_warn("Corrupted ELF file: index of strtab invalid\n");
+		pr_warn("elf: symbol strings section missing or invalid in %s\n", obj-=
>path);
 		return -LIBBPF_ERRNO__FORMAT;
 	}
 	return bpf_object__init_btf(obj, btf_data, btf_ext_data);
@@ -2894,14 +2944,13 @@ static int bpf_object__collect_externs(struct bpf=
_object *obj)
 	if (!obj->efile.symbols)
 		return 0;
=20
-	scn =3D elf_getscn(obj->efile.elf, obj->efile.symbols_shndx);
-	if (!scn)
-		return -LIBBPF_ERRNO__FORMAT;
-	if (gelf_getshdr(scn, &sh) !=3D &sh)
+	scn =3D elf_sec_by_idx(obj, obj->efile.symbols_shndx);
+	if (elf_sec_hdr(obj, scn, &sh))
 		return -LIBBPF_ERRNO__FORMAT;
-	n =3D sh.sh_size / sh.sh_entsize;
=20
+	n =3D sh.sh_size / sh.sh_entsize;
 	pr_debug("looking for externs among %d symbols...\n", n);
+
 	for (i =3D 0; i < n; i++) {
 		GElf_Sym sym;
=20
@@ -2909,8 +2958,7 @@ static int bpf_object__collect_externs(struct bpf_o=
bject *obj)
 			return -LIBBPF_ERRNO__FORMAT;
 		if (!sym_is_extern(&sym))
 			continue;
-		ext_name =3D elf_strptr(obj->efile.elf, obj->efile.strtabidx,
-				      sym.st_name);
+		ext_name =3D elf_sym_str(obj, sym.st_name);
 		if (!ext_name || !ext_name[0])
 			continue;
=20
@@ -3289,16 +3337,15 @@ bpf_program__collect_reloc(struct bpf_program *pr=
og, GElf_Shdr *shdr,
 			return -LIBBPF_ERRNO__FORMAT;
 		}
 		if (!gelf_getsym(symbols, GELF_R_SYM(rel.r_info), &sym)) {
-			pr_warn("relocation: symbol %"PRIx64" not found\n",
-				GELF_R_SYM(rel.r_info));
+			pr_warn("relocation: symbol %zx not found\n",
+				(size_t)GELF_R_SYM(rel.r_info));
 			return -LIBBPF_ERRNO__FORMAT;
 		}
 		if (rel.r_offset % sizeof(struct bpf_insn))
 			return -LIBBPF_ERRNO__FORMAT;
=20
 		insn_idx =3D rel.r_offset / sizeof(struct bpf_insn);
-		name =3D elf_strptr(obj->efile.elf, obj->efile.strtabidx,
-				  sym.st_name) ? : "<?>";
+		name =3D elf_sym_str(obj, sym.st_name) ?: "<?>";
=20
 		pr_debug("relo for shdr %u, symb %zu, value %zu, type %d, bind %d, nam=
e %d (\'%s\'), insn %u\n",
 			 (__u32)sym.st_shndx, (size_t)GELF_R_SYM(rel.r_info),
@@ -5720,8 +5767,7 @@ static int bpf_object__collect_map_relos(struct bpf=
_object *obj,
 				i, (size_t)GELF_R_SYM(rel.r_info));
 			return -LIBBPF_ERRNO__FORMAT;
 		}
-		name =3D elf_strptr(obj->efile.elf, obj->efile.strtabidx,
-				  sym.st_name) ? : "<?>";
+		name =3D elf_sym_str(obj, sym.st_name) ?: "<?>";
 		if (sym.st_shndx !=3D obj->efile.btf_maps_shndx) {
 			pr_warn(".maps relo #%d: '%s' isn't a BTF-defined map\n",
 				i, name);
@@ -7663,8 +7709,7 @@ static int bpf_object__collect_st_ops_relos(struct =
bpf_object *obj,
 			return -LIBBPF_ERRNO__FORMAT;
 		}
=20
-		name =3D elf_strptr(obj->efile.elf, obj->efile.strtabidx,
-				  sym.st_name) ? : "<?>";
+		name =3D elf_sym_str(obj, sym.st_name) ?: "<?>";
 		map =3D find_struct_ops_map_by_offset(obj, rel.r_offset);
 		if (!map) {
 			pr_warn("struct_ops reloc: cannot find map at rel.r_offset %zu\n",
--=20
2.24.1

