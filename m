Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC9326EAA
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388002AbfEVTvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:51:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60948 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732137AbfEVTvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:51:18 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4MJmjkq027411
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 12:51:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Q9t3NR/CCWC66/s4qrK4lUuBQGfLabUUVExDUwQm1A4=;
 b=MbLBRZfkTNOQ3kKP03oSlF9HfMJyFbN3PialUy/iOP0nDCF6oCrA/GylZPodpEqddUjJ
 EujmyreAfSMjIdl+S2pKR6cG0gFSkY4XZCpe7EHSG9p1fbyLLgZJbNRv2pIZr5mQaF9w
 WIpCR5sHhxWI42DiuZWUOHyUxmkWt3op19M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2smqj248jv-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 12:51:17 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 12:51:16 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 79707862334; Wed, 22 May 2019 12:51:15 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 10/12] bpftool: add C output format option to btf dump subcommand
Date:   Wed, 22 May 2019 12:50:51 -0700
Message-ID: <20190522195053.4017624-11-andriin@fb.com>
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
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize new libbpf's btf_dump API to emit BTF as a C definitions.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/btf.c | 63 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index a22ef6587ebe..ed3d3221cc78 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -1,5 +1,12 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
-/* Copyright (C) 2019 Facebook */
+
+/*
+ * BTF dumping command.
+ * Load BTF from multiple possible sources and outptu entirety or subset of
+ * types in either raw format or C-syntax format.
+ *
+ * Copyright (C) 2019 Facebook
+ */
 
 #include <errno.h>
 #include <fcntl.h>
@@ -340,11 +347,48 @@ static int dump_btf_raw(const struct btf *btf,
 	return 0;
 }
 
+static void btf_dump_printf(void *ctx, const char *fmt, va_list args)
+{
+	vfprintf(stdout, fmt, args);
+}
+
+static int dump_btf_c(const struct btf *btf,
+		      __u32 *root_type_ids, int root_type_cnt)
+{
+	struct btf_dump *d;
+	int err = 0, i, id;
+
+	d = btf_dump__new(btf, NULL, NULL, btf_dump_printf);
+	if (IS_ERR(d))
+		return PTR_ERR(d);
+
+	if (root_type_cnt) {
+		for (i = 0; i < root_type_cnt; i++) {
+			err = btf_dump__dump_type(d, root_type_ids[i]);
+			if (err)
+				goto done;
+		}
+	} else {
+		int cnt = btf__get_nr_types(btf);
+
+		for (id = 1; id <= cnt; id++) {
+			err = btf_dump__dump_type(d, id);
+			if (err)
+				goto done;
+		}
+	}
+
+done:
+	btf_dump__free(d);
+	return err;
+}
+
 static int do_dump(int argc, char **argv)
 {
 	struct btf *btf = NULL;
 	__u32 root_type_ids[2];
 	int root_type_cnt = 0;
+	bool dump_c = false;
 	__u32 btf_id = -1;
 	const char *src;
 	int fd = -1;
@@ -431,6 +475,16 @@ static int do_dump(int argc, char **argv)
 		goto done;
 	}
 
+	while (argc) {
+		if (strcmp(*argv, "c") == 0) {
+			dump_c = true;
+			NEXT_ARG();
+		} else {
+			p_err("unrecognized option: '%s'", *argv);
+			goto done;
+		}
+	}
+
 	if (!btf) {
 		err = btf__get_from_id(btf_id, &btf);
 		if (err) {
@@ -444,7 +498,10 @@ static int do_dump(int argc, char **argv)
 		}
 	}
 
-	dump_btf_raw(btf, root_type_ids, root_type_cnt);
+	if (dump_c)
+		dump_btf_c(btf, root_type_ids, root_type_cnt);
+	else
+		dump_btf_raw(btf, root_type_ids, root_type_cnt);
 
 done:
 	close(fd);
@@ -460,7 +517,7 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s btf dump BTF_SRC\n"
+		"Usage: %s btf dump BTF_SRC [c]\n"
 		"       %s btf help\n"
 		"\n"
 		"       BTF_SRC := { id BTF_ID | prog PROG | map MAP [{key | value | kv | all}] | file FILE }\n"
-- 
2.17.1

