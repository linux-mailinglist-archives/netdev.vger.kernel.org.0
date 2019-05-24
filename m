Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4E429EA0
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 20:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391692AbfEXS7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 14:59:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53066 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391592AbfEXS7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 14:59:20 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4OIwkm1026041
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 11:59:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=+mILvYwWaBUx7FgpXAhY0YoQRQqTm6Z7WFLbUfSA5hQ=;
 b=cmeshws5kppv3vKjMKdTI9QwLbPybyZTeibG6WmaSAZRIMjicRktBGkQub7b5lNIzqf/
 FIDpfNCeeart6k8BYZ8w6ibruNiFke5TnpJj0DjxdwqAB5IEe57VuGfPXzbehTLDWpc8
 3oaUYbjPSv9/AMI2WXT0DDzWWY8mPPDGUcg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2sphggs5kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 11:59:18 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 24 May 2019 11:59:17 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 658B78613DC; Fri, 24 May 2019 11:59:16 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 03/12] bpftool: use libbpf's btf__parse_elf API
Date:   Fri, 24 May 2019 11:58:58 -0700
Message-ID: <20190524185908.3562231-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190524185908.3562231-1-andriin@fb.com>
References: <20190524185908.3562231-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-24_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905240123
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

