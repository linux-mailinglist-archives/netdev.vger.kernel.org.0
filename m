Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7828C11E
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfHMSz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:55:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48826 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbfHMSzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:55:25 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7DIrvUP004822
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 11:55:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=ozxmwlFSLOCUuTLcBy1B62s0gsHh72N9HGFAjrEGZLE=;
 b=I6VG4wdjK0HZFlSPwcHNLztKlBOQYgdffZeYESvRXAWTxeVa8CnzXUnVpxhRY+E1Qzgx
 zfJqxiDSE3sMj+qSALWak8APNpYM/HurhRwe39z1xaS6bWv8N0Xtr/aWHYsTKrCrOPQ0
 rnam2V70NpvTRewWUpZDOs8IFg6Qio3I2Jg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ubydph0ey-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 11:55:24 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 13 Aug 2019 11:55:22 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id B9C19861677; Tue, 13 Aug 2019 11:55:20 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <acme@redhat.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 2/2] libbpf: attempt to load kernel BTF from sysfs first
Date:   Tue, 13 Aug 2019 11:54:43 -0700
Message-ID: <20190813185443.437829-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190813185443.437829-1-andriin@fb.com>
References: <20190813185443.437829-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=25 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130177
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for loading kernel BTF from sysfs (/sys/kernel/btf/vmlinux)
as a target BTF. Also extend the list of on disk search paths for
vmlinux ELF image with entries that perf is searching for.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 64 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 57 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3abf2dd1b3b5..8462dab02812 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2807,15 +2807,61 @@ static int bpf_core_reloc_insn(struct bpf_program *prog, int insn_off,
 	return 0;
 }
 
+static struct btf *btf_load_raw(const char *path)
+{
+	struct btf *btf;
+	size_t read_cnt;
+	struct stat st;
+	void *data;
+	FILE *f;
+
+	if (stat(path, &st))
+		return ERR_PTR(-errno);
+
+	data = malloc(st.st_size);
+	if (!data)
+		return ERR_PTR(-ENOMEM);
+
+	f = fopen(path, "rb");
+	if (!f) {
+		btf = ERR_PTR(-errno);
+		goto cleanup;
+	}
+
+	read_cnt = fread(data, 1, st.st_size, f);
+	fclose(f);
+	if (read_cnt < st.st_size) {
+		btf = ERR_PTR(-EBADF);
+		goto cleanup;
+	}
+
+	btf = btf__new(data, read_cnt);
+
+cleanup:
+	free(data);
+	return btf;
+}
+
 /*
  * Probe few well-known locations for vmlinux kernel image and try to load BTF
  * data out of it to use for target BTF.
  */
 static struct btf *bpf_core_find_kernel_btf(void)
 {
-	const char *locations[] = {
-		"/lib/modules/%1$s/vmlinux-%1$s",
-		"/usr/lib/modules/%1$s/kernel/vmlinux",
+	struct {
+		const char *path_fmt;
+		bool raw_btf;
+	} locations[] = {
+		/* try canonical vmlinux BTF through sysfs first */
+		{ "/sys/kernel/btf/vmlinux", true /* raw BTF */ },
+		/* fall back to trying to find vmlinux ELF on disk otherwise */
+		{ "/boot/vmlinux-%1$s" },
+		{ "/lib/modules/%1$s/vmlinux-%1$s" },
+		{ "/lib/modules/%1$s/build/vmlinux" },
+		{ "/usr/lib/modules/%1$s/kernel/vmlinux" },
+		{ "/usr/lib/debug/boot/vmlinux-%1$s" },
+		{ "/usr/lib/debug/boot/vmlinux-%1$s.debug" },
+		{ "/usr/lib/debug/lib/modules/%1$s/vmlinux" },
 	};
 	char path[PATH_MAX + 1];
 	struct utsname buf;
@@ -2825,14 +2871,18 @@ static struct btf *bpf_core_find_kernel_btf(void)
 	uname(&buf);
 
 	for (i = 0; i < ARRAY_SIZE(locations); i++) {
-		snprintf(path, PATH_MAX, locations[i], buf.release);
+		snprintf(path, PATH_MAX, locations[i].path_fmt, buf.release);
 
 		if (access(path, R_OK))
 			continue;
 
-		btf = btf__parse_elf(path, NULL);
-		pr_debug("kernel BTF load from '%s': %ld\n",
-			 path, PTR_ERR(btf));
+		if (locations[i].raw_btf)
+			btf = btf_load_raw(path);
+		else
+			btf = btf__parse_elf(path, NULL);
+
+		pr_debug("loading kernel BTF '%s': %ld\n",
+			 path, IS_ERR(btf) ? PTR_ERR(btf) : 0);
 		if (IS_ERR(btf))
 			continue;
 
-- 
2.17.1

