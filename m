Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48615C626
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 01:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfGAX7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 19:59:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43546 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727010AbfGAX7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 19:59:48 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x61NxPWr026127
        for <netdev@vger.kernel.org>; Mon, 1 Jul 2019 16:59:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=y0EbWBGW8NdOplX7hoU2bVRDW0AdLp3aDDmN0pqMjvM=;
 b=Y5ToDxbQMf5WPZBlzGDIXZ75tjvFl+0ujstQ/kTcCESK4BoQA3daT/iEtmueC46G3kZQ
 udpcnIURRHAWL3RrXFWIGvI1Ku6AIFxu7D3NfUis8qxU6ekqmLDDeutoOWfW6kEYsTJu
 bYg1uJNsnJNp+FCpLn93pWhxjR9/TR48uvw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2tfg1s2qe8-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 16:59:46 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 1 Jul 2019 16:59:17 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id EE67E86149D; Mon,  1 Jul 2019 16:59:14 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <yhs@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v5 bpf-next 5/9] libbpf: add tracepoint attach API
Date:   Mon, 1 Jul 2019 16:58:59 -0700
Message-ID: <20190701235903.660141-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190701235903.660141-1-andriin@fb.com>
References: <20190701235903.660141-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010280
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow attaching BPF programs to kernel tracepoint BPF hooks specified by
category and name.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/libbpf.c   | 79 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  4 ++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 84 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7b6142408b15..d8c1743efc4a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4190,6 +4190,85 @@ struct bpf_link *bpf_program__attach_uprobe(struct bpf_program *prog,
 	return link;
 }
 
+static int determine_tracepoint_id(const char *tp_category,
+				   const char *tp_name)
+{
+	char file[PATH_MAX];
+	int ret;
+
+	ret = snprintf(file, sizeof(file),
+		       "/sys/kernel/debug/tracing/events/%s/%s/id",
+		       tp_category, tp_name);
+	if (ret < 0)
+		return -errno;
+	if (ret >= sizeof(file)) {
+		pr_debug("tracepoint %s/%s path is too long\n",
+			 tp_category, tp_name);
+		return -E2BIG;
+	}
+	return parse_uint_from_file(file, "%d\n");
+}
+
+static int perf_event_open_tracepoint(const char *tp_category,
+				      const char *tp_name)
+{
+	struct perf_event_attr attr = {};
+	char errmsg[STRERR_BUFSIZE];
+	int tp_id, pfd, err;
+
+	tp_id = determine_tracepoint_id(tp_category, tp_name);
+	if (tp_id < 0) {
+		pr_warning("failed to determine tracepoint '%s/%s' perf event ID: %s\n",
+			   tp_category, tp_name,
+			   libbpf_strerror_r(tp_id, errmsg, sizeof(errmsg)));
+		return tp_id;
+	}
+
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.size = sizeof(attr);
+	attr.config = tp_id;
+
+	pfd = syscall(__NR_perf_event_open, &attr, -1 /* pid */, 0 /* cpu */,
+		      -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
+	if (pfd < 0) {
+		err = -errno;
+		pr_warning("tracepoint '%s/%s' perf_event_open() failed: %s\n",
+			   tp_category, tp_name,
+			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		return err;
+	}
+	return pfd;
+}
+
+struct bpf_link *bpf_program__attach_tracepoint(struct bpf_program *prog,
+						const char *tp_category,
+						const char *tp_name)
+{
+	char errmsg[STRERR_BUFSIZE];
+	struct bpf_link *link;
+	int pfd, err;
+
+	pfd = perf_event_open_tracepoint(tp_category, tp_name);
+	if (pfd < 0) {
+		pr_warning("program '%s': failed to create tracepoint '%s/%s' perf event: %s\n",
+			   bpf_program__title(prog, false),
+			   tp_category, tp_name,
+			   libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
+		return ERR_PTR(pfd);
+	}
+	link = bpf_program__attach_perf_event(prog, pfd);
+	if (IS_ERR(link)) {
+		close(pfd);
+		err = PTR_ERR(link);
+		pr_warning("program '%s': failed to attach to tracepoint '%s/%s': %s\n",
+			   bpf_program__title(prog, false),
+			   tp_category, tp_name,
+			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		return link;
+	}
+	return link;
+}
+
 enum bpf_perf_event_ret
 bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 			   void **copy_mem, size_t *copy_size,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index bd767cc11967..60611f4b4e1d 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -178,6 +178,10 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_uprobe(struct bpf_program *prog, bool retprobe,
 			   pid_t pid, const char *binary_path,
 			   size_t func_offset);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_tracepoint(struct bpf_program *prog,
+			       const char *tp_category,
+			       const char *tp_name);
 
 struct bpf_insn;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 57a40fb60718..3c618b75ef65 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -171,6 +171,7 @@ LIBBPF_0.0.4 {
 		bpf_object__load_xattr;
 		bpf_program__attach_kprobe;
 		bpf_program__attach_perf_event;
+		bpf_program__attach_tracepoint;
 		bpf_program__attach_uprobe;
 		btf_dump__dump_type;
 		btf_dump__free;
-- 
2.17.1

