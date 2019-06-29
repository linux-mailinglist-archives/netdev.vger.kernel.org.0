Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4CA5A8BC
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 05:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfF2DtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 23:49:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6480 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726822AbfF2DtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 23:49:14 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5T3ekV1031279
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 20:49:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=HzGwsfkncdH7mMfcKGMr9doo4TgeIc6YX9Ri8YWitM8=;
 b=d987tzuzWNrv4ZImS9fV6FtMA2g9hmTK5U6bkxeozrVXZqD+PoHggFCN3rpsOQyIYYYh
 ovlOoRW5KilqiYsBgpjaXSaSglYA9QRJI8f8UGVa2DtqEG+Q5h82vY5MxDkq9vhRNIe1
 1O4escyE7yWdZE6eEL7QXgda+0FMBYJTpd8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tdnrgt3y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 20:49:13 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 28 Jun 2019 20:49:12 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id CB1A2860C89; Fri, 28 Jun 2019 20:49:11 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <sdf@fomichev.me>, <songliubraving@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 2/9] libbpf: introduce concept of bpf_link
Date:   Fri, 28 Jun 2019 20:48:59 -0700
Message-ID: <20190629034906.1209916-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190629034906.1209916-1-andriin@fb.com>
References: <20190629034906.1209916-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-29_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906290043
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_link is and abstraction of an association of a BPF program and one
of many possible BPF attachment points (hooks). This allows to have
uniform interface for detaching BPF programs regardless of the nature of
link and how it was created. Details of creation and setting up of
a specific bpf_link is handled by corresponding attachment methods
(bpf_program__attach_xxx) added in subsequent commits. Once successfully
created, bpf_link has to be eventually destroyed with
bpf_link__destroy(), at which point BPF program is disassociated from
a hook and all the relevant resources are freed.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 tools/lib/bpf/libbpf.c   | 17 +++++++++++++++++
 tools/lib/bpf/libbpf.h   |  4 ++++
 tools/lib/bpf/libbpf.map |  3 ++-
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6e6ebef11ba3..455795e6f8af 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3941,6 +3941,23 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 	return 0;
 }
 
+struct bpf_link {
+	int (*destroy)(struct bpf_link *link);
+};
+
+int bpf_link__destroy(struct bpf_link *link)
+{
+	int err;
+
+	if (!link)
+		return 0;
+
+	err = link->destroy(link);
+	free(link);
+
+	return err;
+}
+
 enum bpf_perf_event_ret
 bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 			   void **copy_mem, size_t *copy_size,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index d639f47e3110..5082a5ebb0c2 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -165,6 +165,10 @@ LIBBPF_API int bpf_program__pin(struct bpf_program *prog, const char *path);
 LIBBPF_API int bpf_program__unpin(struct bpf_program *prog, const char *path);
 LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
 
+struct bpf_link;
+
+LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
+
 struct bpf_insn;
 
 /*
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 2c6d835620d2..3cde850fc8da 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -167,10 +167,11 @@ LIBBPF_0.0.3 {
 
 LIBBPF_0.0.4 {
 	global:
+		bpf_link__destroy;
+		bpf_object__load_xattr;
 		btf_dump__dump_type;
 		btf_dump__free;
 		btf_dump__new;
 		btf__parse_elf;
-		bpf_object__load_xattr;
 		libbpf_num_possible_cpus;
 } LIBBPF_0.0.3;
-- 
2.17.1

