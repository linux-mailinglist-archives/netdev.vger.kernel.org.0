Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E882CB55E
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 07:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgLBGyA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Dec 2020 01:54:00 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26684 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbgLBGx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 01:53:59 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B26mbXV029292
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 22:53:19 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35615f98ft-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 22:53:19 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 22:52:55 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B592A2ECA750; Tue,  1 Dec 2020 22:52:52 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 3/3] tools/bpftool: auto-detect split BTFs in common cases
Date:   Tue, 1 Dec 2020 22:52:43 -0800
Message-ID: <20201202065244.530571-4-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201202065244.530571-1-andrii@kernel.org>
References: <20201202065244.530571-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_01:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxscore=0
 adultscore=0 mlxlogscore=909 suspectscore=25 clxscore=1034
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012020040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of working with module's split BTF from /sys/kernel/btf/*,
auto-substitute /sys/kernel/btf/vmlinux as the base BTF. This makes using
bpftool with module BTFs faster and simpler.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/bpftool/btf.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index bd46af6a61cc..94cd3bad5430 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -357,11 +357,13 @@ static int dump_btf_raw(const struct btf *btf,
 			dump_btf_type(btf, root_type_ids[i], t);
 		}
 	} else {
+		const struct btf *base;
 		int cnt = btf__get_nr_types(btf);
 		int start_id = 1;
 
-		if (base_btf)
-			start_id = btf__get_nr_types(base_btf) + 1;
+		base = btf__base_btf(btf);
+		if (base)
+			start_id = btf__get_nr_types(base) + 1;
 
 		for (i = start_id; i <= cnt; i++) {
 			t = btf__type_by_id(btf, i);
@@ -428,7 +430,7 @@ static int dump_btf_c(const struct btf *btf,
 
 static int do_dump(int argc, char **argv)
 {
-	struct btf *btf = NULL;
+	struct btf *btf = NULL, *base = NULL;
 	__u32 root_type_ids[2];
 	int root_type_cnt = 0;
 	bool dump_c = false;
@@ -502,7 +504,21 @@ static int do_dump(int argc, char **argv)
 		}
 		NEXT_ARG();
 	} else if (is_prefix(src, "file")) {
-		btf = btf__parse_split(*argv, base_btf);
+		const char sysfs_prefix[] = "/sys/kernel/btf/";
+		const char sysfs_vmlinux[] = "/sys/kernel/btf/vmlinux";
+
+		if (!base_btf &&
+		    strncmp(*argv, sysfs_prefix, sizeof(sysfs_prefix) - 1) == 0 &&
+		    strcmp(*argv, sysfs_vmlinux) != 0) {
+			base = btf__parse(sysfs_vmlinux, NULL);
+			if (libbpf_get_error(base)) {
+				p_err("failed to parse vmlinux BTF at '%s': %ld\n",
+				      sysfs_vmlinux, libbpf_get_error(base));
+				base = NULL;
+			}
+		}
+
+		btf = btf__parse_split(*argv, base ?: base_btf);
 		if (IS_ERR(btf)) {
 			err = -PTR_ERR(btf);
 			btf = NULL;
@@ -567,6 +583,7 @@ static int do_dump(int argc, char **argv)
 done:
 	close(fd);
 	btf__free(btf);
+	btf__free(base);
 	return err;
 }
 
-- 
2.24.1

