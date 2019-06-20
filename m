Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 570674DDA2
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 01:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfFTXKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 19:10:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64864 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbfFTXKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 19:10:19 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5KN39vT031709
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 16:10:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Y1FWKdBI5j0avkYfXEmpyA8NTajFIFgoZI9ySoULmg8=;
 b=flooIDXOYP65Ma2lpxW2EQrFXkbPnZ9Jm03O2DFRInPoqoE6UorAW7EX1yxkXxIHjIiK
 D3nrKUk8SR4uoOBVWSAkdtccXXwoRevtKu2CDI4O1beIMdDSHEYwK1h8Z5C7O8D2l9Kh
 mM1VhJTOLYBwwUnYDOnxSzDJdsF2lcXqVX4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t8gch8pue-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 16:10:18 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 20 Jun 2019 16:10:17 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 34DE486173D; Thu, 20 Jun 2019 16:10:16 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 2/7] libbpf: add ability to attach/detach BPF to perf event
Date:   Thu, 20 Jun 2019 16:09:46 -0700
Message-ID: <20190620230951.3155955-3-andriin@fb.com>
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

bpf_program__attach_perf_event allows to attach BPF program to existing
perf event, providing most generic and most low-level way to attach BPF
programs.

libbpf_perf_event_disable_and_close API is added to disable and close
existing perf event by its FD.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c   | 41 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  4 ++++
 tools/lib/bpf/libbpf.map |  2 ++
 3 files changed, 47 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8ce3beba8551..2bb1fa008be3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -32,6 +32,7 @@
 #include <linux/limits.h>
 #include <linux/perf_event.h>
 #include <linux/ring_buffer.h>
+#include <sys/ioctl.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/vfs.h>
@@ -3928,6 +3929,46 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 	return 0;
 }
 
+int libbpf_perf_event_disable_and_close(int pfd)
+{
+	int err;
+
+	if (pfd < 0)
+		return 0;
+
+	err = ioctl(pfd, PERF_EVENT_IOC_DISABLE, 0);
+	close(pfd);
+	return err;
+}
+
+int bpf_program__attach_perf_event(struct bpf_program *prog, int pfd)
+{
+	char errmsg[STRERR_BUFSIZE];
+	int bpf_fd, err;
+
+	bpf_fd = bpf_program__fd(prog);
+	if (bpf_fd < 0) {
+		pr_warning("program '%s': can't attach before loaded\n",
+			   bpf_program__title(prog, false));
+		return -EINVAL;
+	}
+	if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, bpf_fd) < 0) {
+		err = -errno;
+		pr_warning("program '%s': failed to attach to pfd %d: %s\n",
+			   bpf_program__title(prog, false), pfd,
+			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		return err;
+	}
+	if (ioctl(pfd, PERF_EVENT_IOC_ENABLE, 0) < 0) {
+		err = -errno;
+		pr_warning("program '%s': failed to enable pfd %d: %s\n",
+			   bpf_program__title(prog, false), pfd,
+			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		return err;
+	}
+	return 0;
+}
+
 enum bpf_perf_event_ret
 bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 			   void **copy_mem, size_t *copy_size,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index d639f47e3110..76db1bbc0dac 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -165,6 +165,10 @@ LIBBPF_API int bpf_program__pin(struct bpf_program *prog, const char *path);
 LIBBPF_API int bpf_program__unpin(struct bpf_program *prog, const char *path);
 LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
 
+LIBBPF_API int libbpf_perf_event_disable_and_close(int pfd);
+LIBBPF_API int bpf_program__attach_perf_event(struct bpf_program *prog,
+					      int pfd);
+
 struct bpf_insn;
 
 /*
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 2c6d835620d2..d27406982b5a 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -172,5 +172,7 @@ LIBBPF_0.0.4 {
 		btf_dump__new;
 		btf__parse_elf;
 		bpf_object__load_xattr;
+		bpf_program__attach_perf_event;
 		libbpf_num_possible_cpus;
+		libbpf_perf_event_disable_and_close;
 } LIBBPF_0.0.3;
-- 
2.17.1

