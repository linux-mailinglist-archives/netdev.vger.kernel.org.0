Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDF85A8C6
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 05:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfF2DtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 23:49:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62962 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726872AbfF2DtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 23:49:24 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5T3e8Ib031190
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 20:49:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=THspIpRnJO0EOeiC8VXLPtRpGHyzIInkvZvGcvizeHI=;
 b=krvU1u6vjSLTusM+gNq28HJ7vehOATSw2y4Y1NHPxSThFIr/pbsfPLx9alj0L8619A+v
 QoVkwwi+OBZ0a/VwbCeFltLK9gWtU4pWWYD33Vqrb0S36IPVDE5g8ubBPbuZpwHaDSft
 zdsNmpLoWqX7M8eORTXyNrR+D9kqOxlf3GU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tdnrgt3yb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 20:49:23 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 28 Jun 2019 20:49:21 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 00EB2860E3E; Fri, 28 Jun 2019 20:49:19 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <sdf@fomichev.me>, <songliubraving@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 6/9] libbpf: add raw tracepoint attach API
Date:   Fri, 28 Jun 2019 20:49:03 -0700
Message-ID: <20190629034906.1209916-7-andriin@fb.com>
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

Add a wrapper utilizing bpf_link "infrastructure" to allow attaching BPF
programs to raw tracepoints.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 tools/lib/bpf/libbpf.c   | 37 +++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  3 +++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 41 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8ad4f915df38..f8c7a7ecb35e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4263,6 +4263,43 @@ struct bpf_link *bpf_program__attach_tracepoint(struct bpf_program *prog,
 	return link;
 }
 
+static int bpf_link__destroy_fd(struct bpf_link *link)
+{
+	struct bpf_link_fd *l = (void *)link;
+
+	return close(l->fd);
+}
+
+struct bpf_link *bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
+						    const char *tp_name)
+{
+	char errmsg[STRERR_BUFSIZE];
+	struct bpf_link_fd *link;
+	int prog_fd, pfd;
+
+	prog_fd = bpf_program__fd(prog);
+	if (prog_fd < 0) {
+		pr_warning("program '%s': can't attach before loaded\n",
+			   bpf_program__title(prog, false));
+		return ERR_PTR(-EINVAL);
+	}
+
+	link = malloc(sizeof(*link));
+	link->link.destroy = &bpf_link__destroy_fd;
+
+	pfd = bpf_raw_tracepoint_open(tp_name, prog_fd);
+	if (pfd < 0) {
+		pfd = -errno;
+		free(link);
+		pr_warning("program '%s': failed to attach to raw tracepoint '%s': %s\n",
+			   bpf_program__title(prog, false), tp_name,
+			   libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
+		return ERR_PTR(pfd);
+	}
+	link->fd = pfd;
+	return (struct bpf_link *)link;
+}
+
 enum bpf_perf_event_ret
 bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 			   void **copy_mem, size_t *copy_size,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 60611f4b4e1d..f55933784f95 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -182,6 +182,9 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_tracepoint(struct bpf_program *prog,
 			       const char *tp_category,
 			       const char *tp_name);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
+				   const char *tp_name);
 
 struct bpf_insn;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 3c618b75ef65..e6b7d4edbc93 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -171,6 +171,7 @@ LIBBPF_0.0.4 {
 		bpf_object__load_xattr;
 		bpf_program__attach_kprobe;
 		bpf_program__attach_perf_event;
+		bpf_program__attach_raw_tracepoint;
 		bpf_program__attach_tracepoint;
 		bpf_program__attach_uprobe;
 		btf_dump__dump_type;
-- 
2.17.1

