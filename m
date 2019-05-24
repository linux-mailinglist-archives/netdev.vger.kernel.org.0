Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C437429EAD
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 20:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404098AbfEXS7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 14:59:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54550 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403965AbfEXS7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 14:59:36 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4OIvRuT014164
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 11:59:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=8GLJIPXxTpLKr0PkMeecKUuUYeUhiyoUQ0QfDgUYVQk=;
 b=EtRgzQ1hQdZya1E0b18ZF1itjLBHW2DVHVLo2fuihuQDJbr0XgD8HnBb/o7P4XoC2Z6f
 AJJLxCMacrKquFfiX7YYuREGkEe2a1xZzAWXyZEjeGSYrLblpWywqfKXjcrxNh0YmGGM
 2nYTIFcejONp4obXsg+KRiVEtPPfmUS86Tc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2sphh5s444-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 11:59:35 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 May 2019 11:59:34 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id E77B98613DC; Fri, 24 May 2019 11:59:31 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 10/12] bpftool: add C output format option to btf dump subcommand
Date:   Fri, 24 May 2019 11:59:05 -0700
Message-ID: <20190524185908.3562231-11-andriin@fb.com>
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

Utilize new libbpf's btf_dump API to emit BTF as a C definitions.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/btf.c | 75 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 73 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index a22ef6587ebe..1b8ec91899e6 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -340,11 +340,49 @@ static int dump_btf_raw(const struct btf *btf,
 	return 0;
 }
 
+static void __printf(2, 0) btf_dump_printf(void *ctx,
+					   const char *fmt, va_list args)
+{
+	vfprintf(stdout, fmt, args);
+}
+
+static int dump_btf_c(const struct btf *btf,
+		      __u32 *root_type_ids, int root_type_cnt)
+{
+	struct btf_dump *d;
+	int err = 0, i;
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
+		for (i = 1; i <= cnt; i++) {
+			err = btf_dump__dump_type(d, i);
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
@@ -431,6 +469,29 @@ static int do_dump(int argc, char **argv)
 		goto done;
 	}
 
+	while (argc) {
+		if (is_prefix(*argv, "format")) {
+			NEXT_ARG();
+			if (argc < 1) {
+				p_err("expecting value for 'format' option\n");
+				goto done;
+			}
+			if (strcmp(*argv, "c") == 0) {
+				dump_c = true;
+			} else if (strcmp(*argv, "raw") == 0) {
+				dump_c = false;
+			} else {
+				p_err("unrecognized format specifier: '%s', possible values: raw, c",
+				      *argv);
+				goto done;
+			}
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
@@ -444,7 +505,16 @@ static int do_dump(int argc, char **argv)
 		}
 	}
 
-	dump_btf_raw(btf, root_type_ids, root_type_cnt);
+	if (dump_c) {
+		if (json_output) {
+			p_err("JSON output for C-syntax dump is not supported");
+			err = -ENOTSUP;
+			goto done;
+		}
+		err = dump_btf_c(btf, root_type_ids, root_type_cnt);
+	} else {
+		err = dump_btf_raw(btf, root_type_ids, root_type_cnt);
+	}
 
 done:
 	close(fd);
@@ -460,10 +530,11 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s btf dump BTF_SRC\n"
+		"Usage: %s btf dump BTF_SRC [format FORMAT]\n"
 		"       %s btf help\n"
 		"\n"
 		"       BTF_SRC := { id BTF_ID | prog PROG | map MAP [{key | value | kv | all}] | file FILE }\n"
+		"       FORMAT  := { raw | c }\n"
 		"       " HELP_SPEC_MAP "\n"
 		"       " HELP_SPEC_PROGRAM "\n"
 		"       " HELP_SPEC_OPTIONS "\n"
-- 
2.17.1

