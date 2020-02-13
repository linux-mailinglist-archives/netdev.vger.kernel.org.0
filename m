Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93EC215CCCC
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 22:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgBMVBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 16:01:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29730 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727984AbgBMVB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 16:01:29 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01DL0ilb022097
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 13:01:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=v8Lkrz2gobavw9Yz2OAUEmb8WVq6qGCJLbPN7UHU4CM=;
 b=PoCedZYrdwLAzqfymYhS5tiGNRatX7R3Fg8ce+zTRPr7Z69lpkNZeiEHu2wbzLOwK0VJ
 jHhrKlu9YiM0zXyWJRjZRzCuY7Tw/tKXAX50wWILj11HkZonYiU/6gTXDQu4HT2v8QD+
 +BM9/cDI6JKzWf4vMZZBGyVbiJOaB1bHpeE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2y58h1hxev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 13:01:28 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 13 Feb 2020 13:01:27 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id E76CA62E1D26; Thu, 13 Feb 2020 13:01:21 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC bpf-next 2/4] libbpf: introduce bpf_program__overwrite_section_name()
Date:   Thu, 13 Feb 2020 13:01:13 -0800
Message-ID: <20200213210115.1455809-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200213210115.1455809-1-songliubraving@fb.com>
References: <20200213210115.1455809-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-13_08:2020-02-12,2020-02-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 mlxlogscore=972 lowpriorityscore=0 adultscore=0 phishscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a temporary solution before Eelco Chaudron's work for
bpf_program__set_attach_target():

https://patchwork.ozlabs.org/patch/1237539/

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/lib/bpf/libbpf.c   | 13 ++++++++++++-
 tools/lib/bpf/libbpf.h   |  4 ++++
 tools/lib/bpf/libbpf.map |  5 +++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 514b1a524abb..4c29a7181d57 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -238,6 +238,8 @@ struct bpf_program {
 	__u32 line_info_rec_size;
 	__u32 line_info_cnt;
 	__u32 prog_flags;
+
+	char *overwritten_section_name;
 };
 
 struct bpf_struct_ops {
@@ -442,6 +444,7 @@ static void bpf_program__exit(struct bpf_program *prog)
 	zfree(&prog->pin_name);
 	zfree(&prog->insns);
 	zfree(&prog->reloc_desc);
+	zfree(&prog->overwritten_section_name);
 
 	prog->nr_reloc = 0;
 	prog->insns_cnt = 0;
@@ -6637,7 +6640,7 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog)
 {
 	enum bpf_attach_type attach_type = prog->expected_attach_type;
 	__u32 attach_prog_fd = prog->attach_prog_fd;
-	const char *name = prog->section_name;
+	const char *name = prog->overwritten_section_name ? : prog->section_name;
 	int i, err;
 
 	if (!name)
@@ -8396,3 +8399,11 @@ void bpf_object__destroy_skeleton(struct bpf_object_skeleton *s)
 	free(s->progs);
 	free(s);
 }
+
+char *bpf_program__overwrite_section_name(struct bpf_program *prog,
+					  const char *sec_name)
+{
+	prog->overwritten_section_name = strdup(sec_name);
+
+	return prog->overwritten_section_name;
+}
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 3fe12c9d1f92..02f0d8b57cc4 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -595,6 +595,10 @@ bpf_program__bpil_addr_to_offs(struct bpf_prog_info_linear *info_linear);
 LIBBPF_API void
 bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear);
 
+LIBBPF_API char *
+bpf_program__overwrite_section_name(struct bpf_program *prog,
+				    const char *sec_name);
+
 /*
  * A helper function to get the number of possible CPUs before looking up
  * per-CPU maps. Negative errno is returned on failure.
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b035122142bb..ed26c20729db 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -235,3 +235,8 @@ LIBBPF_0.0.7 {
 		btf__align_of;
 		libbpf_find_kernel_btf;
 } LIBBPF_0.0.6;
+
+LIBBPF_0.0.8 {
+	global:
+		bpf_program__overwrite_section_name;
+} LIBBPF_0.0.7;
-- 
2.17.1

