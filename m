Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9E724C83E
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgHTXNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:13:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62322 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728695AbgHTXNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:13:05 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KNAHGg013508
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:13:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=J13fnIjqMTyChhGBoi9XOpf1lzpcFEkacQngwm27Ykg=;
 b=btNgSDFQBjDKMKX2pdNz/pdIiPIMLa4QycJBWr+/bsaLnq3edMb41zms+UqG8BxwmWm0
 6hLRGGYqJV1gGqB9a81dizAQasD+EMXC0mrFP+aQdp5z7RFkh6WXlEiE259QKApdq4hC
 sHNS9RH/vzuFAi9cXFtEwqTf8tti30HynG0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304ny18as-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:13:03 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 16:13:02 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CAF6D2EC5F42; Thu, 20 Aug 2020 16:13:00 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 04/16] libbpf: skip well-known ELF sections when iterating ELF
Date:   Thu, 20 Aug 2020 16:12:38 -0700
Message-ID: <20200820231250.1293069-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200820231250.1293069-1-andriin@fb.com>
References: <20200820231250.1293069-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_07:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=850 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 suspectscore=8
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Skip and don't log ELF sections that libbpf knows about and ignores durin=
g ELF
processing. This allows to not unnecessarily log details about those ELF
sections and cleans up libbpf debug log. Ignored sections include DWARF d=
ata,
string table, empty .text section and few special (e.g., .llvm_addrsig)
useless sections.

With such ELF sections out of the way, log unrecognized ELF sections at
pr_info level to increase visibility.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 55 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1f7e2ac0979e..a7318e5a312b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2672,6 +2672,46 @@ static Elf_Data *elf_sec_data(const struct bpf_obj=
ect *obj, Elf_Scn *scn)
 	return data;
 }
=20
+static bool is_sec_name_dwarf(const char *name)
+{
+	/* approximation, but the actual list is too long */
+	return strncmp(name, ".debug_", sizeof(".debug_") - 1) =3D=3D 0;
+}
+
+static bool ignore_elf_section(GElf_Shdr *hdr, const char *name)
+{
+	/* no special handling of .strtab */
+	if (hdr->sh_type =3D=3D SHT_STRTAB)
+		return true;
+
+	/* ignore .llvm_addrsig section as well */
+	if (hdr->sh_type =3D=3D 0x6FFF4C03 /* SHT_LLVM_ADDRSIG */)
+		return true;
+
+	/* no subprograms will lead to an empty .text section, ignore it */
+	if (hdr->sh_type =3D=3D SHT_PROGBITS && hdr->sh_size =3D=3D 0 &&
+	    strcmp(name, ".text") =3D=3D 0)
+		return true;
+
+	/* DWARF sections */
+	if (is_sec_name_dwarf(name))
+		return true;
+
+	if (strncmp(name, ".rel", sizeof(".rel") - 1) =3D=3D 0) {
+		name +=3D sizeof(".rel") - 1;
+		/* DWARF section relocations */
+		if (is_sec_name_dwarf(name))
+			return true;
+
+		/* .BTF and .BTF.ext don't need relocations */
+		if (strcmp(name, BTF_ELF_SEC) =3D=3D 0 ||
+		    strcmp(name, BTF_EXT_ELF_SEC) =3D=3D 0)
+			return true;
+	}
+
+	return false;
+}
+
 static int bpf_object__elf_collect(struct bpf_object *obj)
 {
 	Elf *elf =3D obj->efile.elf;
@@ -2694,6 +2734,9 @@ static int bpf_object__elf_collect(struct bpf_objec=
t *obj)
 		if (!name)
 			return -LIBBPF_ERRNO__FORMAT;
=20
+		if (ignore_elf_section(&sh, name))
+			continue;
+
 		data =3D elf_sec_data(obj, scn);
 		if (!data)
 			return -LIBBPF_ERRNO__FORMAT;
@@ -2746,8 +2789,8 @@ static int bpf_object__elf_collect(struct bpf_objec=
t *obj)
 				obj->efile.st_ops_data =3D data;
 				obj->efile.st_ops_shndx =3D idx;
 			} else {
-				pr_debug("elf: skipping unrecognized data section(%d) %s\n",
-					 idx, name);
+				pr_info("elf: skipping unrecognized data section(%d) %s\n",
+					idx, name);
 			}
 		} else if (sh.sh_type =3D=3D SHT_REL) {
 			int nr_sects =3D obj->efile.nr_reloc_sects;
@@ -2758,9 +2801,9 @@ static int bpf_object__elf_collect(struct bpf_objec=
t *obj)
 			if (!section_have_execinstr(obj, sec) &&
 			    strcmp(name, ".rel" STRUCT_OPS_SEC) &&
 			    strcmp(name, ".rel" MAPS_ELF_SEC)) {
-				pr_debug("elf: skipping relo section(%d) %s for section(%d) %s\n",
-					 idx, name, sec,
-					 elf_sec_name(obj, elf_sec_by_idx(obj, sec)) ?: "<?>");
+				pr_info("elf: skipping relo section(%d) %s for section(%d) %s\n",
+					idx, name, sec,
+					elf_sec_name(obj, elf_sec_by_idx(obj, sec)) ?: "<?>");
 				continue;
 			}
=20
@@ -2778,7 +2821,7 @@ static int bpf_object__elf_collect(struct bpf_objec=
t *obj)
 			obj->efile.bss =3D data;
 			obj->efile.bss_shndx =3D idx;
 		} else {
-			pr_debug("elf: skipping section(%d) %s\n", idx, name);
+			pr_info("elf: skipping section(%d) %s (size %zu)\n", idx, name, sh.sh=
_size);
 		}
 	}
=20
--=20
2.24.1

