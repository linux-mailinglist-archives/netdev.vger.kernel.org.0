Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9131D4DDAB
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 01:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfFTXKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 19:10:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17078 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725941AbfFTXKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 19:10:24 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5KN4Bjc012591
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 16:10:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=lIXnS3RyQDIoBmUp/PACSUFFKQUlJ/Q+92IPiIPlvF0=;
 b=aMYjA3UyxMfk373joF7D9wenmgZlsGKxnvsNzoOmbILhLKlekqiDA2k5CHjhdCerZeQX
 RQE+AXUmvWhqKPvLMx4fHDxYmoUzMlL/YXSqLFdTMAcfM9CPBxOdkq12Vma4LMc0PgiV
 7drUYWuZy4f4S6E20LXFRU6hraTN/UtudsM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2t8dffsdut-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 16:10:23 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 20 Jun 2019 16:10:19 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 4069086173D; Thu, 20 Jun 2019 16:10:18 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 3/7] libbpf: add kprobe/uprobe attach API
Date:   Thu, 20 Jun 2019 16:09:47 -0700
Message-ID: <20190620230951.3155955-4-andriin@fb.com>
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
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906200163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to attach to kernel and user probes and retprobes.
Implementation depends on perf event support for kprobes/uprobes.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c   | 207 +++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |   8 ++
 tools/lib/bpf/libbpf.map |   2 +
 3 files changed, 217 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2bb1fa008be3..11329e05530e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3969,6 +3969,213 @@ int bpf_program__attach_perf_event(struct bpf_program *prog, int pfd)
 	return 0;
 }
 
+static int parse_uint(const char *buf)
+{
+	int ret;
+
+	errno = 0;
+	ret = (int)strtol(buf, NULL, 10);
+	if (errno) {
+		ret = -errno;
+		pr_debug("failed to parse '%s' as unsigned int\n", buf);
+		return ret;
+	}
+	if (ret < 0) {
+		pr_debug("failed to parse '%s' as unsigned int\n", buf);
+		return -EINVAL;
+	}
+	return ret;
+}
+
+static int parse_uint_from_file(const char* file)
+{
+	char buf[STRERR_BUFSIZE];
+	int fd, ret;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		ret = -errno;
+		pr_debug("failed to open '%s': %s\n", file,
+			 libbpf_strerror_r(ret, buf, sizeof(buf)));
+		return ret;
+	}
+	ret = read(fd, buf, sizeof(buf));
+	close(fd);
+	if (ret < 0) {
+		ret = -errno;
+		pr_debug("failed to read '%s': %s\n", file,
+			libbpf_strerror_r(ret, buf, sizeof(buf)));
+		return ret;
+	}
+	if (ret == 0 || ret >= sizeof(buf)) {
+		buf[sizeof(buf) - 1] = 0;
+		pr_debug("unexpected input from '%s': '%s'\n", file, buf);
+		return -EINVAL;
+	}
+	return parse_uint(buf);
+}
+
+static int determine_kprobe_perf_type(void)
+{
+	const char *file = "/sys/bus/event_source/devices/kprobe/type";
+	return parse_uint_from_file(file);
+}
+
+static int determine_uprobe_perf_type(void)
+{
+	const char *file = "/sys/bus/event_source/devices/uprobe/type";
+	return parse_uint_from_file(file);
+}
+
+static int parse_config_from_file(const char *file)
+{
+	char buf[STRERR_BUFSIZE];
+	int fd, ret;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		ret = -errno;
+		pr_debug("failed to open '%s': %s\n", file,
+			 libbpf_strerror_r(ret, buf, sizeof(buf)));
+		return ret;
+	}
+	ret = read(fd, buf, sizeof(buf));
+	close(fd);
+	if (ret < 0) {
+		ret = -errno;
+		pr_debug("failed to read '%s': %s\n", file,
+			libbpf_strerror_r(ret, buf, sizeof(buf)));
+		return ret;
+	}
+	if (ret == 0 || ret >= sizeof(buf)) {
+		buf[sizeof(buf) - 1] = 0;
+		pr_debug("unexpected input from '%s': '%s'\n", file, buf);
+		return -EINVAL;
+	}
+	if (strncmp(buf, "config:", 7)) {
+		pr_debug("expected 'config:' prefix, found '%s'\n", buf);
+		return -EINVAL;
+	}
+	return parse_uint(buf + 7);
+}
+
+static int determine_kprobe_retprobe_bit(void)
+{
+	const char *file = "/sys/bus/event_source/devices/kprobe/format/retprobe";
+	return parse_config_from_file(file);
+}
+
+static int determine_uprobe_retprobe_bit(void)
+{
+	const char *file = "/sys/bus/event_source/devices/uprobe/format/retprobe";
+	return parse_config_from_file(file);
+}
+
+static int perf_event_open_probe(bool uprobe, bool retprobe, const char* name,
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
+int bpf_program__attach_kprobe(struct bpf_program *prog, bool retprobe,
+			       const char *func_name)
+{
+	char errmsg[STRERR_BUFSIZE];
+	int pfd, err;
+
+	pfd = perf_event_open_probe(false /* uprobe */, retprobe, func_name,
+				    0 /* offset */, -1 /* pid */);
+	if (pfd < 0) {
+		pr_warning("program '%s': failed to create %s '%s' perf event: %s\n",
+			   bpf_program__title(prog, false),
+			   retprobe ? "kretprobe" : "kprobe", func_name,
+			   libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
+		return pfd;
+	}
+	err = bpf_program__attach_perf_event(prog, pfd);
+	if (err) {
+		libbpf_perf_event_disable_and_close(pfd);
+		pr_warning("program '%s': failed to attach to %s '%s': %s\n",
+			   bpf_program__title(prog, false),
+			   retprobe ? "kretprobe" : "kprobe", func_name,
+			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		return err;
+	}
+	return pfd;
+}
+
+int bpf_program__attach_uprobe(struct bpf_program *prog, bool retprobe,
+			       pid_t pid, const char *binary_path,
+			       size_t func_offset)
+{
+	char errmsg[STRERR_BUFSIZE];
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
+		return pfd;
+	}
+	err = bpf_program__attach_perf_event(prog, pfd);
+	if (err) {
+		libbpf_perf_event_disable_and_close(pfd);
+		pr_warning("program '%s': failed to attach to %s '%s:0x%zx': %s\n",
+			   bpf_program__title(prog, false),
+			   retprobe ? "uretprobe" : "uprobe",
+			   binary_path, func_offset,
+			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		return err;
+	}
+	return pfd;
+}
+
 enum bpf_perf_event_ret
 bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 			   void **copy_mem, size_t *copy_size,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 76db1bbc0dac..a7264f06aa5f 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -168,6 +168,14 @@ LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
 LIBBPF_API int libbpf_perf_event_disable_and_close(int pfd);
 LIBBPF_API int bpf_program__attach_perf_event(struct bpf_program *prog,
 					      int pfd);
+LIBBPF_API int bpf_program__attach_kprobe(struct bpf_program *prog,
+					  bool retprobe,
+					  const char *func_name);
+LIBBPF_API int bpf_program__attach_uprobe(struct bpf_program *prog,
+					  bool retprobe,
+					  pid_t pid,
+					  const char *binary_path,
+					  size_t func_offset);
 
 struct bpf_insn;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index d27406982b5a..1a982c2e1751 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -172,7 +172,9 @@ LIBBPF_0.0.4 {
 		btf_dump__new;
 		btf__parse_elf;
 		bpf_object__load_xattr;
+		bpf_program__attach_kprobe;
 		bpf_program__attach_perf_event;
+		bpf_program__attach_uprobe;
 		libbpf_num_possible_cpus;
 		libbpf_perf_event_disable_and_close;
 } LIBBPF_0.0.3;
-- 
2.17.1

