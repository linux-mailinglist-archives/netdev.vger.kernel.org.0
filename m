Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E2F58B86
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfF0UTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:19:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46340 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726604AbfF0UTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:19:45 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RKHU1o018030
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:19:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=TgShIAMH2M77hCq39IubGL3sFd/FdE/yllQPmhbxZKo=;
 b=nQMs2JudEbR0cycsMTS0iM3LCVavGKAOfn0bMQlpIyRWBldhfBa0C9E0chm9fNNjjTOb
 FseWebs5ZryTLW5ENAGCkuKv6/Yzg/08pBl7PPC9v4j+QtH1/u9ZaY6BhiiEgHFgCaeZ
 BY+jb6W0gC7cpRhhuR6oJBdjO4CjTF4c5Pk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2td03ws8ur-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:19:44 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Jun 2019 13:19:40 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id F041462E2BE1; Thu, 27 Jun 2019 13:19:38 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <lmb@cloudflare.com>, <jannh@google.com>,
        <gregkh@linuxfoundation.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/4] libbpf: add libbpf_[enable|disable]_sys_bpf()
Date:   Thu, 27 Jun 2019 13:19:22 -0700
Message-ID: <20190627201923.2589391-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627201923.2589391-1-songliubraving@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=961 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270233
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds two more API to libbpf: libbpf_enable_sys_bpf() and
libbpf_disable_sys_bpf().

For root, these two APIs are no-op.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/lib/bpf/libbpf.c   | 54 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  7 ++++++
 tools/lib/bpf/libbpf.map |  2 ++
 3 files changed, 63 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5186b7710430..449764840c5a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -35,6 +35,7 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/vfs.h>
+#include <sys/ioctl.h>
 #include <tools/libc_compat.h>
 #include <libelf.h>
 #include <gelf.h>
@@ -4286,3 +4287,56 @@ int libbpf_num_possible_cpus(void)
 	}
 	return cpus;
 }
+
+LIBBPF_API bool libbpf_enable_sys_bpf(void)
+{
+	char *cp, errmsg[STRERR_BUFSIZE];
+	int fd, ret;
+
+	if (geteuid() == 0)
+		return true;
+
+	fd = open(LIBBPF_DEV_BPF, O_WRONLY);
+	if (fd < 0) {
+		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
+		pr_warning("failed to open %s: %s\n", LIBBPF_DEV_BPF, cp);
+		return false;
+	}
+
+	ret = ioctl(fd, BPF_DEV_IOCTL_ENABLE_SYS_BPF);
+
+	if (ret) {
+		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
+		pr_warning("failed to enable access to sys_bpf(): %s\n", cp);
+		close(fd);
+		return false;
+	}
+	close(fd);
+	pr_debug("enabled access to sys_bpf() for non-privileged user\n");
+	return true;
+}
+
+LIBBPF_API void libbpf_disable_sys_bpf(void)
+{
+	char *cp, errmsg[STRERR_BUFSIZE];
+	int fd, ret;
+
+	if (geteuid() == 0)
+		return;
+
+	fd = open(LIBBPF_DEV_BPF, O_WRONLY);
+	if (fd < 0) {
+		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
+		pr_warning("failed to open %s: %s\n", LIBBPF_DEV_BPF, cp);
+		return;
+	}
+
+	ret = ioctl(fd, BPF_DEV_IOCTL_DISABLE_SYS_BPF);
+	if (ret) {
+		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
+		pr_warning("failed to disable access to sys_bpf(): %s\n", cp);
+		close(fd);
+	}
+	close(fd);
+	pr_debug("disabled access to sys_bpf() for non-privileged user\n");
+}
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index d639f47e3110..0e3b9c0f1cdf 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -470,6 +470,13 @@ bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear);
  */
 LIBBPF_API int libbpf_num_possible_cpus(void);
 
+#define LIBBPF_DEV_BPF "/dev/bpf"
+
+/* (For non-root user) get permission to access bpf() syscall */
+LIBBPF_API bool libbpf_enable_sys_bpf(void);
+/* (For non-root user) put permission to access bpf() syscall */
+LIBBPF_API void libbpf_disable_sys_bpf(void);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 2c6d835620d2..c5951315a3a5 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -173,4 +173,6 @@ LIBBPF_0.0.4 {
 		btf__parse_elf;
 		bpf_object__load_xattr;
 		libbpf_num_possible_cpus;
+		libbpf_enable_sys_bpf;
+		libbpf_disable_sys_bpf;
 } LIBBPF_0.0.3;
-- 
2.17.1

