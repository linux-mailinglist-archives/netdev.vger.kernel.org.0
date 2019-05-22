Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490BF26EA1
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731313AbfEVTvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:51:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60140 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732161AbfEVTvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:51:06 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MJcEhB024043
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 12:51:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=+mILvYwWaBUx7FgpXAhY0YoQRQqTm6Z7WFLbUfSA5hQ=;
 b=qxRqHZznoxfLvhePOld5UVRcUgh97XTfNvi/+fdmGfbleWkyYciTL1/ZTja1fGPgt+Ef
 XLnUSt1K4/2QkSHdtElLOjK277NFzqDA+YoGEwtrpO6MyiUDF6yFFT5QljKawgo56vxK
 KLBlL8J2FFYoYxuvC39h0yj9z6VPRfluGgA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn8rt93a1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 12:51:06 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 12:51:04 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 2DA6B862334; Wed, 22 May 2019 12:51:01 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 03/12] bpftool: use libbpf's btf__parse_elf API
Date:   Wed, 22 May 2019 12:50:44 -0700
Message-ID: <20190522195053.4017624-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190522195053.4017624-1-andriin@fb.com>
References: <20190522195053.4017624-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220137
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use btf__parse_elf() API, provided by libbpf, instead of implementing
ELF parsing by itself.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/btf.c | 117 +++-------------------------------------
 1 file changed, 8 insertions(+), 109 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 7317438ecd9e..a22ef6587ebe 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -8,8 +8,8 @@
 #include <stdio.h>
 #include <string.h>
 #include <unistd.h>
-#include <gelf.h>
 #include <bpf.h>
+#include <libbpf.h>
 #include <linux/btf.h>
 
 #include "btf.h"
@@ -340,112 +340,6 @@ static int dump_btf_raw(const struct btf *btf,
 	return 0;
 }
 
-static bool check_btf_endianness(GElf_Ehdr *ehdr)
-{
-	static unsigned int const endian = 1;
-
-	switch (ehdr->e_ident[EI_DATA]) {
-	case ELFDATA2LSB:
-		return *(unsigned char const *)&endian == 1;
-	case ELFDATA2MSB:
-		return *(unsigned char const *)&endian == 0;
-	default:
-		return 0;
-	}
-}
-
-static int btf_load_from_elf(const char *path, struct btf **btf)
-{
-	int err = -1, fd = -1, idx = 0;
-	Elf_Data *btf_data = NULL;
-	Elf_Scn *scn = NULL;
-	Elf *elf = NULL;
-	GElf_Ehdr ehdr;
-
-	if (elf_version(EV_CURRENT) == EV_NONE) {
-		p_err("failed to init libelf for %s", path);
-		return -1;
-	}
-
-	fd = open(path, O_RDONLY);
-	if (fd < 0) {
-		p_err("failed to open %s: %s", path, strerror(errno));
-		return -1;
-	}
-
-	elf = elf_begin(fd, ELF_C_READ, NULL);
-	if (!elf) {
-		p_err("failed to open %s as ELF file", path);
-		goto done;
-	}
-	if (!gelf_getehdr(elf, &ehdr)) {
-		p_err("failed to get EHDR from %s", path);
-		goto done;
-	}
-	if (!check_btf_endianness(&ehdr)) {
-		p_err("non-native ELF endianness is not supported");
-		goto done;
-	}
-	if (!elf_rawdata(elf_getscn(elf, ehdr.e_shstrndx), NULL)) {
-		p_err("failed to get e_shstrndx from %s\n", path);
-		goto done;
-	}
-
-	while ((scn = elf_nextscn(elf, scn)) != NULL) {
-		GElf_Shdr sh;
-		char *name;
-
-		idx++;
-		if (gelf_getshdr(scn, &sh) != &sh) {
-			p_err("failed to get section(%d) header from %s",
-			      idx, path);
-			goto done;
-		}
-		name = elf_strptr(elf, ehdr.e_shstrndx, sh.sh_name);
-		if (!name) {
-			p_err("failed to get section(%d) name from %s",
-			      idx, path);
-			goto done;
-		}
-		if (strcmp(name, BTF_ELF_SEC) == 0) {
-			btf_data = elf_getdata(scn, 0);
-			if (!btf_data) {
-				p_err("failed to get section(%d, %s) data from %s",
-				      idx, name, path);
-				goto done;
-			}
-			break;
-		}
-	}
-
-	if (!btf_data) {
-		p_err("%s ELF section not found in %s", BTF_ELF_SEC, path);
-		goto done;
-	}
-
-	*btf = btf__new(btf_data->d_buf, btf_data->d_size);
-	if (IS_ERR(*btf)) {
-		err = PTR_ERR(*btf);
-		*btf = NULL;
-		p_err("failed to load BTF data from %s: %s",
-		      path, strerror(err));
-		goto done;
-	}
-
-	err = 0;
-done:
-	if (err) {
-		if (*btf) {
-			btf__free(*btf);
-			*btf = NULL;
-		}
-	}
-	if (elf)
-		elf_end(elf);
-	close(fd);
-	return err;
-}
-
 static int do_dump(int argc, char **argv)
 {
 	struct btf *btf = NULL;
@@ -522,9 +416,14 @@ static int do_dump(int argc, char **argv)
 		}
 		NEXT_ARG();
 	} else if (is_prefix(src, "file")) {
-		err = btf_load_from_elf(*argv, &btf);
-		if (err)
+		btf = btf__parse_elf(*argv, NULL);
+		if (IS_ERR(btf)) {
+			err = PTR_ERR(btf);
+			btf = NULL;
+			p_err("failed to load BTF from %s: %s", 
+			      *argv, strerror(err));
 			goto done;
+		}
 		NEXT_ARG();
 	} else {
 		err = -1;
-- 
2.17.1

