Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 488A65C623
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 01:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfGAX7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 19:59:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57616 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727025AbfGAX7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 19:59:33 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61NsrWY022359
        for <netdev@vger.kernel.org>; Mon, 1 Jul 2019 16:59:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=z9xTrkl9u5eKjkX321IhwdRq05abOct5L4I//pM3ppM=;
 b=QFPNLOHkoX6LyONoBwiI33lSKGwfYE8otP5PEAZ8RfynrnzbdaWmwyk9z+CELvBMzYLO
 WXVfWtyHGw00MNVS+7aWNYq6bQ9Eowj/wrlvnqx2LeKssCDWSBQP0jeTCe2kcrguHJvW
 zA7fMWZlrmkyKCCTe29VHUGLtzO1/TiPoQ8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tfv6xg0qx-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 16:59:32 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 1 Jul 2019 16:59:13 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id E1FFC86149D; Mon,  1 Jul 2019 16:59:12 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <yhs@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v5 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
Date:   Mon, 1 Jul 2019 16:58:58 -0700
Message-ID: <20190701235903.660141-5-andriin@fb.com>
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
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010279
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to attach to kernel and user probes and retprobes.
Implementation depends on perf event support for kprobes/uprobes.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/libbpf.c   | 169 +++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |   7 ++
 tools/lib/bpf/libbpf.map |   2 +
 3 files changed, 178 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index bcaa294f819d..7b6142408b15 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4021,6 +4021,175 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
 	return (struct bpf_link *)link;
 }
 
+/*
+ * this function is expected to parse integer in the range of [0, 2^31-1] from
+ * given file using scanf format string fmt. If actual parsed value is
+ * negative, the result might be indistinguishable from error
+ */
+static int parse_uint_from_file(const char *file, const char *fmt)
+{
+	char buf[STRERR_BUFSIZE];
+	int err, ret;
+	FILE *f;
+
+	f = fopen(file, "r");
+	if (!f) {
+		err = -errno;
+		pr_debug("failed to open '%s': %s\n", file,
+			 libbpf_strerror_r(err, buf, sizeof(buf)));
+		return err;
+	}
+	err = fscanf(f, fmt, &ret);
+	if (err != 1) {
+		err = err == EOF ? -EIO : -errno;
+		pr_debug("failed to parse '%s': %s\n", file,
+			libbpf_strerror_r(err, buf, sizeof(buf)));
+		fclose(f);
+		return err;
+	}
+	fclose(f);
+	return ret;
+}
+
+static int determine_kprobe_perf_type(void)
+{
+	const char *file = "/sys/bus/event_source/devices/kprobe/type";
+
+	return parse_uint_from_file(file, "%d\n");
+}
+
+static int determine_uprobe_perf_type(void)
+{
+	const char *file = "/sys/bus/event_source/devices/uprobe/type";
+
+	return parse_uint_from_file(file, "%d\n");
+}
+
+static int determine_kprobe_retprobe_bit(void)
+{
+	const char *file = "/sys/bus/event_source/devices/kprobe/format/retprobe";
+
+	return parse_uint_from_file(file, "config:%d\n");
+}
+
+static int determine_uprobe_retprobe_bit(void)
+{
+	const char *file = "/sys/bus/event_source/devices/uprobe/format/retprobe";
+
+	return parse_uint_from_file(file, "config:%d\n");
+}
+
+static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
+				 uint64_t offset, int pid)
+{
+	struct perf_event_attr attr = {};
+	char errmsg[STRERR_BUFSIZE];
+	int type, pfd, err;
+
+	type = uprobe ? determine_uprobe_perf_type()
+		      : determine_kprobe_perf_type();
+	if (type < 0) {
+		pr_warning("failed to determine %s perf type: %s\n",
+			   uprobe ? "uprobe" : "kprobe",
+			   libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
+		return type;
+	}
+	if (retprobe) {
+		int bit = uprobe ? determine_uprobe_retprobe_bit()
+				 : determine_kprobe_retprobe_bit();
+
+		if (bit < 0) {
+			pr_warning("failed to determine %s retprobe bit: %s\n",
+				   uprobe ? "uprobe" : "kprobe",
+				   libbpf_strerror_r(bit, errmsg,
+						     sizeof(errmsg)));
+			return bit;
+		}
+		attr.config |= 1 << bit;
+	}
+	attr.size = sizeof(attr);
+	attr.type = type;
+	attr.config1 = (uint64_t)(void *)name; /* kprobe_func or uprobe_path */
+	attr.config2 = offset;		       /* kprobe_addr or probe_offset */
+
+	/* pid filter is meaningful only for uprobes */
+	pfd = syscall(__NR_perf_event_open, &attr,
+		      pid < 0 ? -1 : pid /* pid */,
+		      pid == -1 ? 0 : -1 /* cpu */,
+		      -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
+	if (pfd < 0) {
+		err = -errno;
+		pr_warning("%s perf_event_open() failed: %s\n",
+			   uprobe ? "uprobe" : "kprobe",
+			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		return err;
+	}
+	return pfd;
+}
+
+struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
+					    bool retprobe,
+					    const char *func_name)
+{
+	char errmsg[STRERR_BUFSIZE];
+	struct bpf_link *link;
+	int pfd, err;
+
+	pfd = perf_event_open_probe(false /* uprobe */, retprobe, func_name,
+				    0 /* offset */, -1 /* pid */);
+	if (pfd < 0) {
+		pr_warning("program '%s': failed to create %s '%s' perf event: %s\n",
+			   bpf_program__title(prog, false),
+			   retprobe ? "kretprobe" : "kprobe", func_name,
+			   libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
+		return ERR_PTR(pfd);
+	}
+	link = bpf_program__attach_perf_event(prog, pfd);
+	if (IS_ERR(link)) {
+		close(pfd);
+		err = PTR_ERR(link);
+		pr_warning("program '%s': failed to attach to %s '%s': %s\n",
+			   bpf_program__title(prog, false),
+			   retprobe ? "kretprobe" : "kprobe", func_name,
+			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		return link;
+	}
+	return link;
+}
+
+struct bpf_link *bpf_program__attach_uprobe(struct bpf_program *prog,
+					    bool retprobe, pid_t pid,
+					    const char *binary_path,
+					    size_t func_offset)
+{
+	char errmsg[STRERR_BUFSIZE];
+	struct bpf_link *link;
+	int pfd, err;
+
+	pfd = perf_event_open_probe(true /* uprobe */, retprobe,
+				    binary_path, func_offset, pid);
+	if (pfd < 0) {
+		pr_warning("program '%s': failed to create %s '%s:0x%zx' perf event: %s\n",
+			   bpf_program__title(prog, false),
+			   retprobe ? "uretprobe" : "uprobe",
+			   binary_path, func_offset,
+			   libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
+		return ERR_PTR(pfd);
+	}
+	link = bpf_program__attach_perf_event(prog, pfd);
+	if (IS_ERR(link)) {
+		close(pfd);
+		err = PTR_ERR(link);
+		pr_warning("program '%s': failed to attach to %s '%s:0x%zx': %s\n",
+			   bpf_program__title(prog, false),
+			   retprobe ? "uretprobe" : "uprobe",
+			   binary_path, func_offset,
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
index 1bf66c4a9330..bd767cc11967 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -171,6 +171,13 @@ LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
 
 LIBBPF_API struct bpf_link *
 bpf_program__attach_perf_event(struct bpf_program *prog, int pfd);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_kprobe(struct bpf_program *prog, bool retprobe,
+			   const char *func_name);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_uprobe(struct bpf_program *prog, bool retprobe,
+			   pid_t pid, const char *binary_path,
+			   size_t func_offset);
 
 struct bpf_insn;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 756f5aa802e9..57a40fb60718 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -169,7 +169,9 @@ LIBBPF_0.0.4 {
 	global:
 		bpf_link__destroy;
 		bpf_object__load_xattr;
+		bpf_program__attach_kprobe;
 		bpf_program__attach_perf_event;
+		bpf_program__attach_uprobe;
 		btf_dump__dump_type;
 		btf_dump__free;
 		btf_dump__new;
-- 
2.17.1

