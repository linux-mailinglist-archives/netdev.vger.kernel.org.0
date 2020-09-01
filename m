Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729D725855D
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 03:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIABuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 21:50:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6878 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726130AbgIABuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 21:50:14 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0811oCD4014914
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=QW4UyBhQv4+GsYvi9VOq+Hxw6wgrRheCnzlMhUOthEI=;
 b=XPVabcXSBSamC3tN4dF/kW6dH3Cjs6YeIcE1or0KVlaD2pYFDT+WLWxmcUhwtsXMuvUZ
 ooCfbMr5MniHOY2gkv5Nm7hd4MY7o60W9FrVLAhVCLyeInh6OfKAwt4KotFrFjB2UEvb
 zgVleZAoMAKKLmQLINPusRCiQ8JOHGrrjY8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 337jh03bc8-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:12 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 18:50:10 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 53F382EC663B; Mon, 31 Aug 2020 18:50:07 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v2 bpf-next 01/14] libbpf: ensure ELF symbols table is found before further ELF processing
Date:   Mon, 31 Aug 2020 18:49:50 -0700
Message-ID: <20200901015003.2871861-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200901015003.2871861-1-andriin@fb.com>
References: <20200901015003.2871861-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_01:2020-08-31,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 phishscore=0 suspectscore=8 impostorscore=0 mlxlogscore=759 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010014
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf ELF parsing logic might need symbols available before ELF parsing =
is
completed, so we need to make sure that symbols table section is found in
a separate pass before all the subsequent sections are processed.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b688aadf09c5..ac56d4db6d3e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2720,14 +2720,38 @@ static int bpf_object__elf_collect(struct bpf_obj=
ect *obj)
 	Elf *elf =3D obj->efile.elf;
 	Elf_Data *btf_ext_data =3D NULL;
 	Elf_Data *btf_data =3D NULL;
-	Elf_Scn *scn =3D NULL;
 	int idx =3D 0, err =3D 0;
+	const char *name;
+	Elf_Data *data;
+	Elf_Scn *scn;
+	GElf_Shdr sh;
=20
+	/* a bunch of ELF parsing functionality depends on processing symbols,
+	 * so do the first pass and find the symbol table
+	 */
+	scn =3D NULL;
 	while ((scn =3D elf_nextscn(elf, scn)) !=3D NULL) {
-		const char *name;
-		GElf_Shdr sh;
-		Elf_Data *data;
+		if (elf_sec_hdr(obj, scn, &sh))
+			return -LIBBPF_ERRNO__FORMAT;
+
+		if (sh.sh_type =3D=3D SHT_SYMTAB) {
+			if (obj->efile.symbols) {
+				pr_warn("elf: multiple symbol tables in %s\n", obj->path);
+				return -LIBBPF_ERRNO__FORMAT;
+			}
=20
+			data =3D elf_sec_data(obj, scn);
+			if (!data)
+				return -LIBBPF_ERRNO__FORMAT;
+
+			obj->efile.symbols =3D data;
+			obj->efile.symbols_shndx =3D elf_ndxscn(scn);
+			obj->efile.strtabidx =3D sh.sh_link;
+		}
+	}
+
+	scn =3D NULL;
+	while ((scn =3D elf_nextscn(elf, scn)) !=3D NULL) {
 		idx++;
=20
 		if (elf_sec_hdr(obj, scn, &sh))
@@ -2766,13 +2790,7 @@ static int bpf_object__elf_collect(struct bpf_obje=
ct *obj)
 		} else if (strcmp(name, BTF_EXT_ELF_SEC) =3D=3D 0) {
 			btf_ext_data =3D data;
 		} else if (sh.sh_type =3D=3D SHT_SYMTAB) {
-			if (obj->efile.symbols) {
-				pr_warn("elf: multiple symbol tables in %s\n", obj->path);
-				return -LIBBPF_ERRNO__FORMAT;
-			}
-			obj->efile.symbols =3D data;
-			obj->efile.symbols_shndx =3D idx;
-			obj->efile.strtabidx =3D sh.sh_link;
+			/* already processed during the first pass above */
 		} else if (sh.sh_type =3D=3D SHT_PROGBITS && data->d_size > 0) {
 			if (sh.sh_flags & SHF_EXECINSTR) {
 				if (strcmp(name, ".text") =3D=3D 0)
--=20
2.24.1

