Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3B929EA3
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 20:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403836AbfEXS7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 14:59:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44838 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391703AbfEXS7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 14:59:22 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4OIxLP6004940
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 11:59:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=reoIu8CTCfZFn4hPEGYBrurk6pU2WZP4kpqTBi4df4E=;
 b=VpA1YkquGg0N9WgpstkXTWfnOC80zXM1bVyb9dbK1gJ6LbFuoMWFA9zQoB2cd/oeOAQ3
 mt1Jj0lqU3jZQeVidClmLK72BymvfR5O9RUp2DOGxkv4lVZZubv1vmpI4AxR7ur8hNKl
 eoQuSesTQpGhEWYgkbU4TQHK0fgoTMkpvVk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2spbs6a4gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 11:59:21 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 May 2019 11:59:20 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 8C3BC8613DC; Fri, 24 May 2019 11:59:18 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 04/12] selftests/bpf: use btf__parse_elf to check presence of BTF/BTF.ext
Date:   Fri, 24 May 2019 11:58:59 -0700
Message-ID: <20190524185908.3562231-5-andriin@fb.com>
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
 mlxlogscore=918 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905240123
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch test_btf.c to rely on btf__parse_elf to check presence of BTF and
BTF.ext data, instead of implementing its own ELF parsing.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_btf.c | 71 +++++---------------------
 1 file changed, 13 insertions(+), 58 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selftests/bpf/test_btf.c
index 42c1ce988945..289daf54dec4 100644
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/test_btf.c
@@ -4025,62 +4025,13 @@ static struct btf_file_test file_tests[] = {
 },
 };
 
-static int file_has_btf_elf(const char *fn, bool *has_btf_ext)
-{
-	Elf_Scn *scn = NULL;
-	GElf_Ehdr ehdr;
-	int ret = 0;
-	int elf_fd;
-	Elf *elf;
-
-	if (CHECK(elf_version(EV_CURRENT) == EV_NONE,
-		  "elf_version(EV_CURRENT) == EV_NONE"))
-		return -1;
-
-	elf_fd = open(fn, O_RDONLY);
-	if (CHECK(elf_fd == -1, "open(%s): errno:%d", fn, errno))
-		return -1;
-
-	elf = elf_begin(elf_fd, ELF_C_READ, NULL);
-	if (CHECK(!elf, "elf_begin(%s): %s", fn, elf_errmsg(elf_errno()))) {
-		ret = -1;
-		goto done;
-	}
-
-	if (CHECK(!gelf_getehdr(elf, &ehdr), "!gelf_getehdr(%s)", fn)) {
-		ret = -1;
-		goto done;
-	}
-
-	while ((scn = elf_nextscn(elf, scn))) {
-		const char *sh_name;
-		GElf_Shdr sh;
-
-		if (CHECK(gelf_getshdr(scn, &sh) != &sh,
-			  "file:%s gelf_getshdr != &sh", fn)) {
-			ret = -1;
-			goto done;
-		}
-
-		sh_name = elf_strptr(elf, ehdr.e_shstrndx, sh.sh_name);
-		if (!strcmp(sh_name, BTF_ELF_SEC))
-			ret = 1;
-		if (!strcmp(sh_name, BTF_EXT_ELF_SEC))
-			*has_btf_ext = true;
-	}
-
-done:
-	close(elf_fd);
-	elf_end(elf);
-	return ret;
-}
-
 static int do_test_file(unsigned int test_num)
 {
 	const struct btf_file_test *test = &file_tests[test_num - 1];
 	const char *expected_fnames[] = {"_dummy_tracepoint",
 					 "test_long_fname_1",
 					 "test_long_fname_2"};
+	struct btf_ext *btf_ext = NULL;
 	struct bpf_prog_info info = {};
 	struct bpf_object *obj = NULL;
 	struct bpf_func_info *finfo;
@@ -4095,15 +4046,19 @@ static int do_test_file(unsigned int test_num)
 	fprintf(stderr, "BTF libbpf test[%u] (%s): ", test_num,
 		test->file);
 
-	err = file_has_btf_elf(test->file, &has_btf_ext);
-	if (err == -1)
-		return err;
-
-	if (err == 0) {
-		fprintf(stderr, "SKIP. No ELF %s found", BTF_ELF_SEC);
-		skip_cnt++;
-		return 0;
+	btf = btf__parse_elf(test->file, &btf_ext);
+	if (IS_ERR(btf)) {
+		if (PTR_ERR(btf) == -ENOENT) {
+			fprintf(stderr, "SKIP. No ELF %s found", BTF_ELF_SEC);
+			skip_cnt++;
+			return 0;
+		}
+		return PTR_ERR(btf);
 	}
+	btf__free(btf);
+
+	has_btf_ext = btf_ext != NULL;
+	btf_ext__free(btf_ext);
 
 	obj = bpf_object__open(test->file);
 	if (CHECK(IS_ERR(obj), "obj: %ld", PTR_ERR(obj)))
-- 
2.17.1

