Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C626CB365
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 05:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbfJDDBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 23:01:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59704 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731648AbfJDDBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 23:01:09 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x942OeJG022711
        for <netdev@vger.kernel.org>; Thu, 3 Oct 2019 20:01:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=EAmVK2yiAFtyekfAOIPfaE7kcfinWwUyJHaIpnYqUrc=;
 b=pqt1iuD+emTydkIE/FTMwP9waKCNcBZlHXLTdNGjVPGlfuwOR+Rx/ik4BS44bPfzlaxx
 5n3eyUxKMRpy2ZKuhhrYlYdmvVfGxcJDnBLh1E6DfUyEC4E8oZoa2HI3mp2ttr3kSHVO
 jOLQ2uS9pw81TQ+/+mc3I83hKfoDlTsBAVs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vdaa44wr8-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 20:01:08 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 3 Oct 2019 20:01:07 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 19B0C861895; Thu,  3 Oct 2019 20:01:02 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 1/2] libbpf: stop enforcing kern_version, populate it for users
Date:   Thu, 3 Oct 2019 20:00:57 -0700
Message-ID: <20191004030058.2248514-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191004030058.2248514-1-andriin@fb.com>
References: <20191004030058.2248514-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-04_01:2019-10-03,2019-10-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=8 spamscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910040018
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel version enforcement for kprobes/kretprobes was removed from
5.0 kernel in 6c4fc209fcf9 ("bpf: remove useless version check for prog load").
Since then, BPF programs were specifying SEC("version") just to please
libbpf. We should stop enforcing this in libbpf, if even kernel doesn't
care. Furthermore, libbpf now will pre-populate current kernel version
of the host system, in case we are still running on old kernel.

This patch also removes __bpf_object__open_xattr from libbpf.h, as
nothing in libbpf is relying on having it in that header. That function
was never exported as LIBBPF_API and even name suggests its internal
version. So this should be safe to remove, as it doesn't break ABI.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c                        | 79 ++++++-------------
 tools/lib/bpf/libbpf.h                        |  2 -
 .../selftests/bpf/progs/test_attach_probe.c   |  1 -
 .../bpf/progs/test_get_stack_rawtp.c          |  1 -
 .../selftests/bpf/progs/test_perf_buffer.c    |  1 -
 .../selftests/bpf/progs/test_stacktrace_map.c |  1 -
 6 files changed, 22 insertions(+), 63 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e0276520171b..056769ce4fd0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -33,6 +33,7 @@
 #include <linux/limits.h>
 #include <linux/perf_event.h>
 #include <linux/ring_buffer.h>
+#include <linux/version.h>
 #include <sys/epoll.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
@@ -255,7 +256,7 @@ struct bpf_object {
 	 */
 	struct {
 		int fd;
-		void *obj_buf;
+		const void *obj_buf;
 		size_t obj_buf_sz;
 		Elf *elf;
 		GElf_Ehdr ehdr;
@@ -491,8 +492,19 @@ bpf_object__init_prog_names(struct bpf_object *obj)
 	return 0;
 }
 
+static __u32 get_kernel_version(void)
+{
+	__u32 major, minor, patch;
+	struct utsname info;
+
+	uname(&info);
+	if (sscanf(info.release, "%u.%u.%u", &major, &minor, &patch) != 3)
+		return 0;
+	return KERNEL_VERSION(major, minor, patch);
+}
+
 static struct bpf_object *bpf_object__new(const char *path,
-					  void *obj_buf,
+					  const void *obj_buf,
 					  size_t obj_buf_sz)
 {
 	struct bpf_object *obj;
@@ -526,6 +538,7 @@ static struct bpf_object *bpf_object__new(const char *path,
 	obj->efile.rodata_shndx = -1;
 	obj->efile.bss_shndx = -1;
 
+	obj->kern_version = get_kernel_version();
 	obj->loaded = false;
 
 	INIT_LIST_HEAD(&obj->list);
@@ -569,7 +582,7 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 		 * obj_buf should have been validated by
 		 * bpf_object__open_buffer().
 		 */
-		obj->efile.elf = elf_memory(obj->efile.obj_buf,
+		obj->efile.elf = elf_memory((char *)obj->efile.obj_buf,
 					    obj->efile.obj_buf_sz);
 	} else {
 		obj->efile.fd = open(obj->path, O_RDONLY);
@@ -3551,54 +3564,9 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 	return 0;
 }
 
-static bool bpf_prog_type__needs_kver(enum bpf_prog_type type)
-{
-	switch (type) {
-	case BPF_PROG_TYPE_SOCKET_FILTER:
-	case BPF_PROG_TYPE_SCHED_CLS:
-	case BPF_PROG_TYPE_SCHED_ACT:
-	case BPF_PROG_TYPE_XDP:
-	case BPF_PROG_TYPE_CGROUP_SKB:
-	case BPF_PROG_TYPE_CGROUP_SOCK:
-	case BPF_PROG_TYPE_LWT_IN:
-	case BPF_PROG_TYPE_LWT_OUT:
-	case BPF_PROG_TYPE_LWT_XMIT:
-	case BPF_PROG_TYPE_LWT_SEG6LOCAL:
-	case BPF_PROG_TYPE_SOCK_OPS:
-	case BPF_PROG_TYPE_SK_SKB:
-	case BPF_PROG_TYPE_CGROUP_DEVICE:
-	case BPF_PROG_TYPE_SK_MSG:
-	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
-	case BPF_PROG_TYPE_LIRC_MODE2:
-	case BPF_PROG_TYPE_SK_REUSEPORT:
-	case BPF_PROG_TYPE_FLOW_DISSECTOR:
-	case BPF_PROG_TYPE_UNSPEC:
-	case BPF_PROG_TYPE_TRACEPOINT:
-	case BPF_PROG_TYPE_RAW_TRACEPOINT:
-	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
-	case BPF_PROG_TYPE_PERF_EVENT:
-	case BPF_PROG_TYPE_CGROUP_SYSCTL:
-	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
-		return false;
-	case BPF_PROG_TYPE_KPROBE:
-	default:
-		return true;
-	}
-}
-
-static int bpf_object__validate(struct bpf_object *obj, bool needs_kver)
-{
-	if (needs_kver && obj->kern_version == 0) {
-		pr_warning("%s doesn't provide kernel version\n",
-			   obj->path);
-		return -LIBBPF_ERRNO__KVERSION;
-	}
-	return 0;
-}
-
 static struct bpf_object *
-__bpf_object__open(const char *path, void *obj_buf, size_t obj_buf_sz,
-		   bool needs_kver, int flags)
+__bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
+		   int flags)
 {
 	struct bpf_object *obj;
 	int err;
@@ -3617,7 +3585,6 @@ __bpf_object__open(const char *path, void *obj_buf, size_t obj_buf_sz,
 	CHECK_ERR(bpf_object__probe_caps(obj), err, out);
 	CHECK_ERR(bpf_object__elf_collect(obj, flags), err, out);
 	CHECK_ERR(bpf_object__collect_reloc(obj), err, out);
-	CHECK_ERR(bpf_object__validate(obj, needs_kver), err, out);
 
 	bpf_object__elf_finish(obj);
 	return obj;
@@ -3626,8 +3593,8 @@ __bpf_object__open(const char *path, void *obj_buf, size_t obj_buf_sz,
 	return ERR_PTR(err);
 }
 
-struct bpf_object *__bpf_object__open_xattr(struct bpf_object_open_attr *attr,
-					    int flags)
+static struct bpf_object *
+__bpf_object__open_xattr(struct bpf_object_open_attr *attr, int flags)
 {
 	/* param validation */
 	if (!attr->file)
@@ -3635,9 +3602,7 @@ struct bpf_object *__bpf_object__open_xattr(struct bpf_object_open_attr *attr,
 
 	pr_debug("loading %s\n", attr->file);
 
-	return __bpf_object__open(attr->file, NULL, 0,
-				  bpf_prog_type__needs_kver(attr->prog_type),
-				  flags);
+	return __bpf_object__open(attr->file, NULL, 0, flags);
 }
 
 struct bpf_object *bpf_object__open_xattr(struct bpf_object_open_attr *attr)
@@ -3673,7 +3638,7 @@ struct bpf_object *bpf_object__open_buffer(void *obj_buf,
 	}
 	pr_debug("loading object '%s' from buffer\n", name);
 
-	return __bpf_object__open(name, obj_buf, obj_buf_sz, true, true);
+	return __bpf_object__open(name, obj_buf, obj_buf_sz, true);
 }
 
 int bpf_object__unload(struct bpf_object *obj)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index e8f70977d137..2905dffd70b2 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -70,8 +70,6 @@ struct bpf_object_open_attr {
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
 bpf_object__open_xattr(struct bpf_object_open_attr *attr);
-struct bpf_object *__bpf_object__open_xattr(struct bpf_object_open_attr *attr,
-					    int flags);
 LIBBPF_API struct bpf_object *bpf_object__open_buffer(void *obj_buf,
 						      size_t obj_buf_sz,
 						      const char *name);
diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
index 63a8dfef893b..534621e38906 100644
--- a/tools/testing/selftests/bpf/progs/test_attach_probe.c
+++ b/tools/testing/selftests/bpf/progs/test_attach_probe.c
@@ -49,4 +49,3 @@ int handle_uprobe_return(struct pt_regs *ctx)
 }
 
 char _license[] SEC("license") = "GPL";
-__u32 _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
index f8ffa3f3d44b..736b6955bba7 100644
--- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
+++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
@@ -100,4 +100,3 @@ int bpf_prog1(void *ctx)
 }
 
 char _license[] SEC("license") = "GPL";
-__u32 _version SEC("version") = 1; /* ignored by tracepoints, required by libbpf.a */
diff --git a/tools/testing/selftests/bpf/progs/test_perf_buffer.c b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
index 876c27deb65a..07c09ca5546a 100644
--- a/tools/testing/selftests/bpf/progs/test_perf_buffer.c
+++ b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
@@ -22,4 +22,3 @@ int handle_sys_nanosleep_entry(struct pt_regs *ctx)
 }
 
 char _license[] SEC("license") = "GPL";
-__u32 _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
index fa0be3e10a10..3b7e1dca8829 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
@@ -74,4 +74,3 @@ int oncpu(struct sched_switch_args *ctx)
 }
 
 char _license[] SEC("license") = "GPL";
-__u32 _version SEC("version") = 1; /* ignored by tracepoints, required by libbpf.a */
-- 
2.17.1

