Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A94428BB6
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388225AbfEWUmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:42:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36260 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388279AbfEWUmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:42:50 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NKaDLE012362
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:42:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=qDA84gQPmuXsqGBy6ZlKtDhCAM20+luDeYsbIGVbViY=;
 b=KKiA/dB/Ti2cpYnsipuDbdtKRYRRMZFZ4wCxEfP0OI8LZIP09uyf1TrCBB7ScZNrcjo1
 UGrspKmuk/o7R1X835h/RkfvGLjbvm/x//FuQwyUkYTBUgVq59euzXdWQPdsTA8sV/mB
 CNefzWJDvrPfW/wK2X7O7vkaKN2MsfDx3lk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2snspaa0gb-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:42:49 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 May 2019 13:42:47 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 1B873861799; Thu, 23 May 2019 13:42:46 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 10/12] bpftool: add C output format option to btf dump subcommand
Date:   Thu, 23 May 2019 13:42:20 -0700
Message-ID: <20190523204222.3998365-11-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523204222.3998365-1-andriin@fb.com>
References: <20190523204222.3998365-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_17:,,
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

Utilize new libbpf's btf_dump API to emit BTF as a C definitions.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/btf.c | 74 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index a22ef6587ebe..1cdbfad42b38 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -340,11 +340,48 @@ static int dump_btf_raw(const struct btf *btf,
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
@@ -431,6 +468,29 @@ static int do_dump(int argc, char **argv)
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
+				p_err("unrecognized format specifier: '%s'",
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
@@ -444,7 +504,16 @@ static int do_dump(int argc, char **argv)
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
@@ -460,10 +529,11 @@ static int do_help(int argc, char **argv)
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

