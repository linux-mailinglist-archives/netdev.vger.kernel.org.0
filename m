Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69CDA3C24C
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390995AbfFKEfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:35:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38914 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390907AbfFKEfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:35:17 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5B4ZD3i032364
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:35:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Ms/M1HRzBVmxZJcXEF3o5NdlcpINuLYvEImAKuzlplo=;
 b=BnKaJpMTBg1H5+qlXU71u/N1LTa/qXlvB0bSXoK5rrC3ocRVEAc9awExNTV1DzbgWBOg
 36jPzNdKkhP7cuR7dKtg3gkamp4E+lUV+UfRpelYUB8TxxD2sRLmdb1NN8DvvjhtJ4yw
 0RDLRJvNyUY6Vf1iM6aPQtbFyVetU8Ei7u4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t22j30df9-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:35:16 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Jun 2019 21:35:14 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id C77CF86184B; Mon, 10 Jun 2019 21:35:12 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [RFC PATCH bpf-next 2/8] libbpf: extract BTF loading and simplify ELF parsing logic
Date:   Mon, 10 Jun 2019 21:34:59 -0700
Message-ID: <20190611043505.14664-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611043505.14664-1-andriin@fb.com>
References: <20190611043505.14664-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110031
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation for adding BTF-based BPF map loading, extract .BTF and
.BTF.ext loading logic. Also simplify error handling in
bpf_object__elf_collect() by returning early, as there is no common
clean up to be done.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 137 ++++++++++++++++++++++-------------------
 1 file changed, 75 insertions(+), 62 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ba89d9727137..9e39a0a33aeb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1078,6 +1078,58 @@ static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
 	}
 }
 
+static int bpf_object__load_btf(struct bpf_object *obj,
+				Elf_Data *btf_data,
+				Elf_Data *btf_ext_data)
+{
+	int err = 0;
+
+	if (btf_data) {
+		obj->btf = btf__new(btf_data->d_buf, btf_data->d_size);
+		if (IS_ERR(obj->btf)) {
+			pr_warning("Error loading ELF section %s: %d.\n",
+				   BTF_ELF_SEC, err);
+			goto out;
+		}
+		err = btf__finalize_data(obj, obj->btf);
+		if (err) {
+			pr_warning("Error finalizing %s: %d.\n",
+				   BTF_ELF_SEC, err);
+			goto out;
+		}
+		bpf_object__sanitize_btf(obj);
+		err = btf__load(obj->btf);
+		if (err) {
+			pr_warning("Error loading %s into kernel: %d.\n",
+				   BTF_ELF_SEC, err);
+			goto out;
+		}
+	}
+	if (btf_ext_data) {
+		if (!obj->btf) {
+			pr_debug("Ignore ELF section %s because its depending ELF section %s is not found.\n",
+				 BTF_EXT_ELF_SEC, BTF_ELF_SEC);
+			goto out;
+		}
+		obj->btf_ext = btf_ext__new(btf_ext_data->d_buf,
+					    btf_ext_data->d_size);
+		if (IS_ERR(obj->btf_ext)) {
+			pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\n",
+				   BTF_EXT_ELF_SEC, PTR_ERR(obj->btf_ext));
+			obj->btf_ext = NULL;
+			goto out;
+		}
+		bpf_object__sanitize_btf_ext(obj);
+	}
+out:
+	if (err || IS_ERR(obj->btf)) {
+		if (!IS_ERR_OR_NULL(obj->btf))
+			btf__free(obj->btf);
+		obj->btf = NULL;
+	}
+	return 0;
+}
+
 static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 {
 	Elf *elf = obj->efile.elf;
@@ -1102,24 +1154,21 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 		if (gelf_getshdr(scn, &sh) != &sh) {
 			pr_warning("failed to get section(%d) header from %s\n",
 				   idx, obj->path);
-			err = -LIBBPF_ERRNO__FORMAT;
-			goto out;
+			return -LIBBPF_ERRNO__FORMAT;
 		}
 
 		name = elf_strptr(elf, ep->e_shstrndx, sh.sh_name);
 		if (!name) {
 			pr_warning("failed to get section(%d) name from %s\n",
 				   idx, obj->path);
-			err = -LIBBPF_ERRNO__FORMAT;
-			goto out;
+			return -LIBBPF_ERRNO__FORMAT;
 		}
 
 		data = elf_getdata(scn, 0);
 		if (!data) {
 			pr_warning("failed to get section(%d) data from %s(%s)\n",
 				   idx, name, obj->path);
-			err = -LIBBPF_ERRNO__FORMAT;
-			goto out;
+			return -LIBBPF_ERRNO__FORMAT;
 		}
 		pr_debug("section(%d) %s, size %ld, link %d, flags %lx, type=%d\n",
 			 idx, name, (unsigned long)data->d_size,
@@ -1130,10 +1179,14 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 			err = bpf_object__init_license(obj,
 						       data->d_buf,
 						       data->d_size);
+			if (err)
+				return err;
 		} else if (strcmp(name, "version") == 0) {
 			err = bpf_object__init_kversion(obj,
 							data->d_buf,
 							data->d_size);
+			if (err)
+				return err;
 		} else if (strcmp(name, "maps") == 0) {
 			obj->efile.maps_shndx = idx;
 		} else if (strcmp(name, BTF_ELF_SEC) == 0) {
@@ -1144,11 +1197,10 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 			if (obj->efile.symbols) {
 				pr_warning("bpf: multiple SYMTAB in %s\n",
 					   obj->path);
-				err = -LIBBPF_ERRNO__FORMAT;
-			} else {
-				obj->efile.symbols = data;
-				obj->efile.strtabidx = sh.sh_link;
+				return -LIBBPF_ERRNO__FORMAT;
 			}
+			obj->efile.symbols = data;
+			obj->efile.strtabidx = sh.sh_link;
 		} else if (sh.sh_type == SHT_PROGBITS && data->d_size > 0) {
 			if (sh.sh_flags & SHF_EXECINSTR) {
 				if (strcmp(name, ".text") == 0)
@@ -1162,6 +1214,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 
 					pr_warning("failed to alloc program %s (%s): %s",
 						   name, obj->path, cp);
+					return err;
 				}
 			} else if (strcmp(name, ".data") == 0) {
 				obj->efile.data = data;
@@ -1173,8 +1226,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 				pr_debug("skip section(%d) %s\n", idx, name);
 			}
 		} else if (sh.sh_type == SHT_REL) {
+			int nr_reloc = obj->efile.nr_reloc;
 			void *reloc = obj->efile.reloc;
-			int nr_reloc = obj->efile.nr_reloc + 1;
 			int sec = sh.sh_info; /* points to other section */
 
 			/* Only do relo for section with exec instructions */
@@ -1184,79 +1237,39 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 				continue;
 			}
 
-			reloc = reallocarray(reloc, nr_reloc,
+			reloc = reallocarray(reloc, nr_reloc + 1,
 					     sizeof(*obj->efile.reloc));
 			if (!reloc) {
 				pr_warning("realloc failed\n");
-				err = -ENOMEM;
-			} else {
-				int n = nr_reloc - 1;
+				return -ENOMEM;
+			}
 
-				obj->efile.reloc = reloc;
-				obj->efile.nr_reloc = nr_reloc;
+			obj->efile.reloc = reloc;
+			obj->efile.nr_reloc++;
 
-				obj->efile.reloc[n].shdr = sh;
-				obj->efile.reloc[n].data = data;
-			}
+			obj->efile.reloc[nr_reloc].shdr = sh;
+			obj->efile.reloc[nr_reloc].data = data;
 		} else if (sh.sh_type == SHT_NOBITS && strcmp(name, ".bss") == 0) {
 			obj->efile.bss = data;
 			obj->efile.bss_shndx = idx;
 		} else {
 			pr_debug("skip section(%d) %s\n", idx, name);
 		}
-		if (err)
-			goto out;
 	}
 
 	if (!obj->efile.strtabidx || obj->efile.strtabidx >= idx) {
 		pr_warning("Corrupted ELF file: index of strtab invalid\n");
 		return -LIBBPF_ERRNO__FORMAT;
 	}
-	if (btf_data) {
-		obj->btf = btf__new(btf_data->d_buf, btf_data->d_size);
-		if (IS_ERR(obj->btf)) {
-			pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\n",
-				   BTF_ELF_SEC, PTR_ERR(obj->btf));
-			obj->btf = NULL;
-		} else {
-			err = btf__finalize_data(obj, obj->btf);
-			if (!err) {
-				bpf_object__sanitize_btf(obj);
-				err = btf__load(obj->btf);
-			}
-			if (err) {
-				pr_warning("Error finalizing and loading %s into kernel: %d. Ignored and continue.\n",
-					   BTF_ELF_SEC, err);
-				btf__free(obj->btf);
-				obj->btf = NULL;
-				err = 0;
-			}
-		}
-	}
-	if (btf_ext_data) {
-		if (!obj->btf) {
-			pr_debug("Ignore ELF section %s because its depending ELF section %s is not found.\n",
-				 BTF_EXT_ELF_SEC, BTF_ELF_SEC);
-		} else {
-			obj->btf_ext = btf_ext__new(btf_ext_data->d_buf,
-						    btf_ext_data->d_size);
-			if (IS_ERR(obj->btf_ext)) {
-				pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\n",
-					   BTF_EXT_ELF_SEC,
-					   PTR_ERR(obj->btf_ext));
-				obj->btf_ext = NULL;
-			} else {
-				bpf_object__sanitize_btf_ext(obj);
-			}
-		}
-	}
+	err = bpf_object__load_btf(obj, btf_data, btf_ext_data);
+	if (err)
+		return err;
 	if (bpf_object__has_maps(obj)) {
 		err = bpf_object__init_maps(obj, flags);
 		if (err)
-			goto out;
+			return err;
 	}
 	err = bpf_object__init_prog_names(obj);
-out:
 	return err;
 }
 
-- 
2.17.1

