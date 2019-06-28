Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 448C3593C5
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 07:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfF1FxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 01:53:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52768 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727033AbfF1FxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 01:53:22 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5S5q6IC009139
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 22:53:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=mNtmyLcUuEqO4e+kQljW1QtWCrdL75VjHRtuB0aLBX4=;
 b=E6ekCykCyoEHwl6Sq1/9+y/P9BbHfTVin9dzjIT4nwZt0zvi2ITy2pZPzAJ77D1fQ6Ty
 uwvvE5GSPV002M2d28tD+zGvqd9rj3v6lbfS38X7xVK8zYorBPM8lbuyIDyw69SDnk69
 5Dv1jOlPawe8Yo1XYQ/jxvZ3IhqQV2ScUu4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2td1bvjda4-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 22:53:20 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 27 Jun 2019 22:53:17 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 992EC861468; Thu, 27 Jun 2019 22:53:15 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <sdf@fomichev.me>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 3/9] libbpf: add ability to attach/detach BPF program to perf event
Date:   Thu, 27 Jun 2019 22:52:57 -0700
Message-ID: <20190628055303.1249758-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628055303.1249758-1-andriin@fb.com>
References: <20190628055303.1249758-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280066
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_program__attach_perf_event allows to attach BPF program to existing
perf event hook, providing most generic and most low-level way to attach BPF
programs. It returns struct bpf_link, which should be passed to
bpf_link__destroy to detach and free resources, associated with a link.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c   | 58 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  3 +++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 62 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 455795e6f8af..606705f878ba 100644
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
@@ -3958,6 +3959,63 @@ int bpf_link__destroy(struct bpf_link *link)
 	return err;
 }
 
+struct bpf_link_fd {
+	struct bpf_link link; /* has to be at the top of struct */
+	int fd; /* hook FD */
+};
+
+static int bpf_link__destroy_perf_event(struct bpf_link *link)
+{
+	struct bpf_link_fd *l = (void *)link;
+	int err;
+
+	if (l->fd < 0)
+		return 0;
+
+	err = ioctl(l->fd, PERF_EVENT_IOC_DISABLE, 0);
+	close(l->fd);
+	return err;
+}
+
+struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
+						int pfd)
+{
+	char errmsg[STRERR_BUFSIZE];
+	struct bpf_link_fd *link;
+	int bpf_fd, err;
+
+	bpf_fd = bpf_program__fd(prog);
+	if (bpf_fd < 0) {
+		pr_warning("program '%s': can't attach before loaded\n",
+			   bpf_program__title(prog, false));
+		return ERR_PTR(-EINVAL);
+	}
+
+	link = malloc(sizeof(*link));
+	if (!link)
+		return ERR_PTR(-ENOMEM);
+	link->link.destroy = &bpf_link__destroy_perf_event;
+	link->fd = pfd;
+
+	if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, bpf_fd) < 0) {
+		err = -errno;
+		free(link);
+		pr_warning("program '%s': failed to attach to pfd %d: %s\n",
+			   bpf_program__title(prog, false), pfd,
+			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		return ERR_PTR(err);
+	}
+	if (ioctl(pfd, PERF_EVENT_IOC_ENABLE, 0) < 0) {
+		err = -errno;
+		free(link);
+		pr_warning("program '%s': failed to enable pfd %d: %s\n",
+			   bpf_program__title(prog, false), pfd,
+			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		return ERR_PTR(err);
+	}
+	return (struct bpf_link *)link;
+}
+
 enum bpf_perf_event_ret
 bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 			   void **copy_mem, size_t *copy_size,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 5082a5ebb0c2..1bf66c4a9330 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -169,6 +169,9 @@ struct bpf_link;
 
 LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
 
+LIBBPF_API struct bpf_link *
+bpf_program__attach_perf_event(struct bpf_program *prog, int pfd);
+
 struct bpf_insn;
 
 /*
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 3cde850fc8da..756f5aa802e9 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -169,6 +169,7 @@ LIBBPF_0.0.4 {
 	global:
 		bpf_link__destroy;
 		bpf_object__load_xattr;
+		bpf_program__attach_perf_event;
 		btf_dump__dump_type;
 		btf_dump__free;
 		btf_dump__new;
-- 
2.17.1

