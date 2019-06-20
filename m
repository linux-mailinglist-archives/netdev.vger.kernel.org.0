Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD5C24DDA6
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 01:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfFTXKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 19:10:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7178 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbfFTXKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 19:10:24 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5KN9Clw016535
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 16:10:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=jwhzuMokykWkeKjO0gDIUPD10caDCYPJc0wPZ+4/4y4=;
 b=EOOY7If9tW3YdqJi3rRUTqnUBQxz/EKEkiU4g9ysIKGF+jSLr7oVp8ssvcvZxEXl/XuF
 tKdltGj2yJBXwbZcSp+GSQSHbehFg6DLXmRYb1Sh3Kh/wevLbRgpZuxOrVZnDJ+C+0uU
 R32CEKUuDxBfnOB6LHI89locFj+hpu4YBao= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t8d3e9gwf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 16:10:23 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 20 Jun 2019 16:10:21 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 49E0586173D; Thu, 20 Jun 2019 16:10:20 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 4/7] libbpf: add tracepoint/raw tracepoint attach API
Date:   Thu, 20 Jun 2019 16:09:48 -0700
Message-ID: <20190620230951.3155955-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620230951.3155955-1-andriin@fb.com>
References: <20190620230951.3155955-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-20_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906200164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add APIs allowing to attach BPF program to kernel tracepoints. Raw
tracepoint attach API is also added for uniform per-BPF-program API,
but is mostly a wrapper around existing bpf_raw_tracepoint_open call.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c   | 99 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  5 ++
 tools/lib/bpf/libbpf.map |  2 +
 3 files changed, 106 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 11329e05530e..cefe67ba160b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4176,6 +4176,105 @@ int bpf_program__attach_uprobe(struct bpf_program *prog, bool retprobe,
 	return pfd;
 }
 
+static int determine_tracepoint_id(const char* tp_category, const char* tp_name)
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
+	return parse_uint_from_file(file);
+}
+
+static int perf_event_open_tracepoint(const char* tp_category,
+				      const char* tp_name)
+{
+	struct perf_event_attr attr = {};
+	char errmsg[STRERR_BUFSIZE];
+	int tp_id, pfd, err;
+
+	tp_id = determine_tracepoint_id(tp_category, tp_name);
+	if (tp_id < 0){
+		pr_warning("failed to determine tracepoint '%s/%s' perf ID: %s\n",
+			   tp_category, tp_name,
+			   libbpf_strerror_r(tp_id, errmsg, sizeof(errmsg)));
+		return tp_id;
+	}
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.size = sizeof(attr);
+	attr.config = tp_id;
+
+	pfd = syscall( __NR_perf_event_open, &attr, -1 /* pid */, 0 /* cpu */,
+			-1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
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
+int bpf_program__attach_tracepoint(struct bpf_program *prog,
+				   const char *tp_category,
+				   const char *tp_name)
+{
+	char errmsg[STRERR_BUFSIZE];
+	int pfd, err;
+
+	pfd = perf_event_open_tracepoint(tp_category, tp_name);
+	if (pfd < 0) {
+		pr_warning("program '%s': failed to create tracepoint '%s/%s' perf event: %s\n",
+			   bpf_program__title(prog, false),
+			   tp_category, tp_name,
+			   libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
+		return pfd;
+	}
+	err = bpf_program__attach_perf_event(prog, pfd);
+	if (err) {
+		libbpf_perf_event_disable_and_close(pfd);
+		pr_warning("program '%s': failed to attach to tracepoint '%s/%s': %s\n",
+			   bpf_program__title(prog, false),
+			   tp_category, tp_name,
+			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		return err;
+	}
+	return pfd;
+}
+
+int bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
+				       const char *tp_name)
+{
+	char errmsg[STRERR_BUFSIZE];
+	int bpf_fd, pfd;
+
+	bpf_fd = bpf_program__fd(prog);
+	if (bpf_fd < 0) {
+		pr_warning("program '%s': can't attach before loaded\n",
+			   bpf_program__title(prog, false));
+		return -EINVAL;
+	}
+	pfd = bpf_raw_tracepoint_open(tp_name, bpf_fd);
+	if (pfd < 0) {
+		pr_warning("program '%s': failed to attach to raw tracepoint '%s': %s\n",
+			   bpf_program__title(prog, false), tp_name,
+			   libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
+		return pfd;
+	}
+	return pfd;
+}
+
 enum bpf_perf_event_ret
 bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 			   void **copy_mem, size_t *copy_size,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index a7264f06aa5f..bf7020a565c6 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -176,6 +176,11 @@ LIBBPF_API int bpf_program__attach_uprobe(struct bpf_program *prog,
 					  pid_t pid,
 					  const char *binary_path,
 					  size_t func_offset);
+LIBBPF_API int bpf_program__attach_tracepoint(struct bpf_program *prog,
+					      const char *tp_category,
+					      const char *tp_name);
+LIBBPF_API int bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
+						  const char *tp_name);
 
 struct bpf_insn;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 1a982c2e1751..2382fbda4cbb 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -174,6 +174,8 @@ LIBBPF_0.0.4 {
 		bpf_object__load_xattr;
 		bpf_program__attach_kprobe;
 		bpf_program__attach_perf_event;
+		bpf_program__attach_raw_tracepoint;
+		bpf_program__attach_tracepoint;
 		bpf_program__attach_uprobe;
 		libbpf_num_possible_cpus;
 		libbpf_perf_event_disable_and_close;
-- 
2.17.1

