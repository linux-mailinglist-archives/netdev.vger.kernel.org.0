Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFC6D28BAA
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388222AbfEWUmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:42:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48586 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388188AbfEWUmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:42:38 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NKcXDs002881
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:42:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=H4iFFNeF6bMTbWj+SDJf/Xgp4wGllDGHfaNd12oZ43c=;
 b=CQNy6GRAqy0aukikHmeqfOvUGmdwRLYSFFHFhYvghFyox3JUUr4rapPpWConjh/Cji5w
 ILyd3u8dVVOrxwKg6veJXXuAbBThAKZQfxrNf5vzOoZmc0SzaRFEzQ5EOwlRyHggRUVz
 XdYRgXOPOEQ6Onji0f0AcAosUtgBDspOzGE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2snu991qy2-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:42:37 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 23 May 2019 13:42:30 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id B42EC861799; Thu, 23 May 2019 13:42:29 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 02/12] libbpf: add btf__parse_elf API to load .BTF and .BTF.ext
Date:   Thu, 23 May 2019 13:42:12 -0700
Message-ID: <20190523204222.3998365-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523204222.3998365-1-andriin@fb.com>
References: <20190523204222.3998365-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Loading BTF and BTF.ext from ELF file is a common need. Instead of
requiring every user to re-implement it, let's provide this API from
libbpf itself. It's mostly copy/paste from `bpftool btf dump`
implementation, which will be switched to libbpf's version in next
patch. btf__parse_elf allows to load BTF and optionally BTF.ext.
This is also useful for tests that need to load/work with BTF, loaded
from test ELF files.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c      | 128 +++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/btf.h      |   2 +
 tools/lib/bpf/libbpf.map |   5 ++
 3 files changed, 135 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 03348c4d6bd4..6139550810a1 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -4,10 +4,12 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <fcntl.h>
 #include <unistd.h>
 #include <errno.h>
 #include <linux/err.h>
 #include <linux/btf.h>
+#include <gelf.h>
 #include "btf.h"
 #include "bpf.h"
 #include "libbpf.h"
@@ -417,6 +419,132 @@ struct btf *btf__new(__u8 *data, __u32 size)
 	return btf;
 }
 
+static bool btf_check_endianness(const GElf_Ehdr *ehdr)
+{
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	return ehdr->e_ident[EI_DATA] == ELFDATA2LSB;
+#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	return ehdr->e_ident[EI_DATA] == ELFDATA2MSB;
+#else
+# error "Unrecognized __BYTE_ORDER__"
+#endif
+}
+
+struct btf *btf__parse_elf(const char *path, struct btf_ext **btf_ext)
+{
+	Elf_Data *btf_data = NULL, *btf_ext_data = NULL;
+	int err = 0, fd = -1, idx = 0;
+	struct btf *btf = NULL;
+	Elf_Scn *scn = NULL;
+	Elf *elf = NULL;
+	GElf_Ehdr ehdr;
+
+	if (elf_version(EV_CURRENT) == EV_NONE) {
+		pr_warning("failed to init libelf for %s\n", path);
+		return ERR_PTR(-LIBBPF_ERRNO__LIBELF);
+	}
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		err = -errno;
+		pr_warning("failed to open %s: %s\n", path, strerror(errno));
+		return ERR_PTR(err);
+	}
+
+	err = -LIBBPF_ERRNO__FORMAT;
+
+	elf = elf_begin(fd, ELF_C_READ, NULL);
+	if (!elf) {
+		pr_warning("failed to open %s as ELF file\n", path);
+		goto done;
+	}
+	if (!gelf_getehdr(elf, &ehdr)) {
+		pr_warning("failed to get EHDR from %s\n", path);
+		goto done;
+	}
+	if (!btf_check_endianness(&ehdr)) {
+		pr_warning("non-native ELF endianness is not supported\n");
+		goto done;
+	}
+	if (!elf_rawdata(elf_getscn(elf, ehdr.e_shstrndx), NULL)) {
+		pr_warning("failed to get e_shstrndx from %s\n", path);
+		goto done;
+	}
+
+	while ((scn = elf_nextscn(elf, scn)) != NULL) {
+		GElf_Shdr sh;
+		char *name;
+
+		idx++;
+		if (gelf_getshdr(scn, &sh) != &sh) {
+			pr_warning("failed to get section(%d) header from %s\n",
+				   idx, path);
+			goto done;
+		}
+		name = elf_strptr(elf, ehdr.e_shstrndx, sh.sh_name);
+		if (!name) {
+			pr_warning("failed to get section(%d) name from %s\n",
+				   idx, path);
+			goto done;
+		}
+		if (strcmp(name, BTF_ELF_SEC) == 0) {
+			btf_data = elf_getdata(scn, 0);
+			if (!btf_data) {
+				pr_warning("failed to get section(%d, %s) data from %s\n",
+					   idx, name, path);
+				goto done;
+			}
+			continue;
+		} else if (btf_ext && strcmp(name, BTF_EXT_ELF_SEC) == 0) {
+			btf_ext_data = elf_getdata(scn, 0);
+			if (!btf_ext_data) {
+				pr_warning("failed to get section(%d, %s) data from %s\n",
+					   idx, name, path);
+				goto done;
+			}
+			continue;
+		}
+	}
+
+	err = 0;
+
+	if (!btf_data) {
+		err = -ENOENT;
+		goto done;
+	}
+	btf = btf__new(btf_data->d_buf, btf_data->d_size);
+	if (IS_ERR(btf))
+		goto done;
+
+	if (btf_ext && btf_ext_data) {
+		*btf_ext = btf_ext__new(btf_ext_data->d_buf,
+					btf_ext_data->d_size);
+		if (IS_ERR(*btf_ext))
+			goto done;
+	} else if (btf_ext) {
+		*btf_ext = NULL;
+	}
+done:
+	if (elf)
+		elf_end(elf);
+	close(fd);
+
+	if (err)
+		return ERR_PTR(err);
+	/*
+	 * btf is always parsed before btf_ext, so no need to clean up
+	 * btf_ext, if btf loading failed
+	 */
+	if (IS_ERR(btf))
+		return btf;
+	if (btf_ext && IS_ERR(*btf_ext)) {
+		btf__free(btf);
+		err = PTR_ERR(*btf_ext);
+		return ERR_PTR(err);
+	}
+	return btf;
+}
+
 static int compare_vsi_off(const void *_a, const void *_b)
 {
 	const struct btf_var_secinfo *a = _a;
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index c7b399e81fce..bded210df9e8 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -59,6 +59,8 @@ struct btf_ext_header {
 
 LIBBPF_API void btf__free(struct btf *btf);
 LIBBPF_API struct btf *btf__new(__u8 *data, __u32 size);
+LIBBPF_API struct btf *btf__parse_elf(const char *path,
+				      struct btf_ext **btf_ext);
 LIBBPF_API int btf__finalize_data(struct bpf_object *obj, struct btf *btf);
 LIBBPF_API int btf__load(struct btf *btf);
 LIBBPF_API __s32 btf__find_by_name(const struct btf *btf,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 673001787cba..6ea5ce19b9e0 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -164,3 +164,8 @@ LIBBPF_0.0.3 {
 		bpf_map_freeze;
 		btf__finalize_data;
 } LIBBPF_0.0.2;
+
+LIBBPF_0.0.4 {
+	global:
+		btf__parse_elf;
+} LIBBPF_0.0.3;
-- 
2.17.1

