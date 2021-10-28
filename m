Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3859243DB42
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhJ1Ghv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhJ1Ghp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:37:45 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8361C061745;
        Wed, 27 Oct 2021 23:35:18 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a26so4999615pfr.11;
        Wed, 27 Oct 2021 23:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E728jRgc5RifUJJoFvo2ksnCyTjnc1///UaATzCSbME=;
        b=pWy0gyw/FOVR7+P4+FQ6ZQ5w4h7nD24a/9i1OGXuklMK7tFXpbe6VG5ck/mboApJE6
         qd+cNG+3YhhDBlOD2FCY8+CX4zd51J5K+67mbjSzyVUMrdA0CWsn/1OmWeDjyHrH5KlY
         mjCiYWAI+zdv3x4VNHwc/ILvjuh2/gK6/pyuwQovFsIHVV1fy/JzEkcczLF9q71bMPg9
         vN4KeeUGxGrJNhpeKlyWcqFV8WAPcMQkgNNnDrvWnJw/AwIcaR6AyYYi/wTr7NXSzwyR
         MNpxPfPySKHKmNgTWdeG5kTWXqyd8XohJ2iSSvs9Xvwg3HqcmGi7GJslElEDNsLPNYx0
         0Yrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E728jRgc5RifUJJoFvo2ksnCyTjnc1///UaATzCSbME=;
        b=0+pPo0/mYcSgEX7VTh6NQ07l8VBCipnevUjPmgmY2MS5PjD742xPWZGnsSBjx5/yXR
         gaRvHBNJVQ1SjzQMoX+ZTI98K31GYj5y32HxyPr7BjJR134bFWivQ8YXaJH8hhEldqpc
         ttKwl8+BTk4diJpZzwe+w51p34E9LSyIAHrNBlj+VJ/tDhm8H/HMYD5YuUah6RVkbUGk
         ApAvv4EPtVyoagvVUg831H23kpqYSF5Z8qIuCjuiFh4SFwYXzrF+GzOkf1KczWIXZKOD
         mp0B4Oym3qIKn2lrHa+2DIORVAnWB2sjsCbFSCg1SiDeOKW8hV3l7foN1vx+eVB1nPGw
         tyeA==
X-Gm-Message-State: AOAM531pTTLTsUp4JnR5oqBLSjIyTCpim8XAVOyzF86L9WkgSL7kGAh1
        BY5RdarUceE4v4sHB3AwBK1F3KHbqqQ/vQ==
X-Google-Smtp-Source: ABdhPJz3dN3uXsPboc5+EcgMWfL7bNN8y0ILur0E2lKDMPqJ6gN5t3ZfnL4JSDVp+o+8Mwr/P9seog==
X-Received: by 2002:a63:e651:: with SMTP id p17mr1862004pgj.66.1635402918223;
        Wed, 27 Oct 2021 23:35:18 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id t8sm1699539pgk.66.2021.10.27.23.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 23:35:18 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 5/8] libbpf: Use O_CLOEXEC uniformly when opening fds
Date:   Thu, 28 Oct 2021 12:04:58 +0530
Message-Id: <20211028063501.2239335-6-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211028063501.2239335-1-memxor@gmail.com>
References: <20211028063501.2239335-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4395; h=from:subject; bh=bHGBfP4vELjcDu+ZJbPMjZRoifbVrxhQkcDor0lcoIw=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhekR/Y+bCaypZajOrSKOTlC5rzoKTR2N4Dtj1O68b /6EELW2JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXpEfwAKCRBM4MiGSL8RyhOOD/ 9PX3PyhyaJoaNi9HYa4ZEQaW4rQ6S8aavrG9RK8t3fIrDrr5Rgcw2z75A4sdit0cUbin/z4QywVc5d uIWXvKngy2wxI7AZ5xzC6V9k69VCqGAbJrKvByZ8Lu1AcLkXq1PsEz88uI8mt6L9pZLitcS9y09FZT MKgv6qZnjuFXkamxW5dT3LXW/w9BAd3vKGvlsb4vWZlZuIeGWex/fn5llHgZER6KuW1ZfHfCi0C312 v+ETkCIBVW5nYRwN/+1fo1PUdptfzeK/ZzxVqyGtReHQyfd7OLZ8sL+LSL33f7vQJljLvarJ/bM+3a prv+T9GWo90Mh0J4Zy63kCP/Y2KbPaABLkpxNV3Ea0fxOFe6fpdkaamSHBNcKdO9700PsFll/yafee JDEJXz1+dP77V5eraDd3cM3G+jQdBH64XtDiUreBOpVfyXR7ME+8DssvGopizYVVHxXJ3E2TWlS8Md MUVXMYcwekGF2Hy9IXBDHTkUBIvHfruHFIr/PoIk10SM9C9YWpjp8gQHDwYyLnhFadFGICwrkpKZsY vSFTSEPQ2WI/idhb9xR2Zib/9oAQns2IhfDWBVpy+vMre9KtS65s0AA2aa0rdw6BfFx6TagZV8nqwW Udpm11q3v/P35PQhx1VyP+g13EAJ+uyp0VAl+w1sF1z9KiX+a1OFFSxpy0PQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some instances where we don't use O_CLOEXEC when opening an
fd, fix these up. Otherwise, it is possible that a parallel fork causes
these fds to leak into a child process on execve.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/btf.c           | 2 +-
 tools/lib/bpf/libbpf.c        | 6 +++---
 tools/lib/bpf/libbpf_probes.c | 2 +-
 tools/lib/bpf/linker.c        | 4 ++--
 tools/lib/bpf/xsk.c           | 6 +++---
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 0c628c33e23b..7e4c5586bd87 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -897,7 +897,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
 		return ERR_PTR(-LIBBPF_ERRNO__LIBELF);
 	}
 
-	fd = open(path, O_RDONLY);
+	fd = open(path, O_RDONLY | O_CLOEXEC);
 	if (fd < 0) {
 		err = -errno;
 		pr_warn("failed to open %s: %s\n", path, strerror(errno));
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 61d666dc5646..f284c8ce83f1 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1231,7 +1231,7 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 		 */
 		elf = elf_memory((char *)obj->efile.obj_buf, obj->efile.obj_buf_sz);
 	} else {
-		obj->efile.fd = open(obj->path, O_RDONLY);
+		obj->efile.fd = open(obj->path, O_RDONLY | O_CLOEXEC);
 		if (obj->efile.fd < 0) {
 			char errmsg[STRERR_BUFSIZE], *cp;
 
@@ -9587,7 +9587,7 @@ static int append_to_file(const char *file, const char *fmt, ...)
 	int fd, n, err = 0;
 	va_list ap;
 
-	fd = open(file, O_WRONLY | O_APPEND, 0);
+	fd = open(file, O_WRONLY | O_APPEND | O_CLOEXEC, 0);
 	if (fd < 0)
 		return -errno;
 
@@ -11232,7 +11232,7 @@ int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz)
 	int fd, err = 0, len;
 	char buf[128];
 
-	fd = open(fcpu, O_RDONLY);
+	fd = open(fcpu, O_RDONLY | O_CLOEXEC);
 	if (fd < 0) {
 		err = -errno;
 		pr_warn("Failed to open cpu mask file %s: %d\n", fcpu, err);
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index cd8c703dde71..68f2dbf364aa 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -33,7 +33,7 @@ static int get_vendor_id(int ifindex)
 
 	snprintf(path, sizeof(path), "/sys/class/net/%s/device/vendor", ifname);
 
-	fd = open(path, O_RDONLY);
+	fd = open(path, O_RDONLY | O_CLOEXEC);
 	if (fd < 0)
 		return -1;
 
diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index ce0800e61dc7..f677dccdeae4 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -301,7 +301,7 @@ static int init_output_elf(struct bpf_linker *linker, const char *file)
 	if (!linker->filename)
 		return -ENOMEM;
 
-	linker->fd = open(file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
+	linker->fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0644);
 	if (linker->fd < 0) {
 		err = -errno;
 		pr_warn("failed to create '%s': %d\n", file, err);
@@ -556,7 +556,7 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
 
 	obj->filename = filename;
 
-	obj->fd = open(filename, O_RDONLY);
+	obj->fd = open(filename, O_RDONLY | O_CLOEXEC);
 	if (obj->fd < 0) {
 		err = -errno;
 		pr_warn("failed to open file '%s': %d\n", filename, err);
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index a2111696ba91..81f8fbc85e70 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -300,7 +300,7 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 	if (!umem)
 		return -ENOMEM;
 
-	umem->fd = socket(AF_XDP, SOCK_RAW, 0);
+	umem->fd = socket(AF_XDP, SOCK_RAW | SOCK_CLOEXEC, 0);
 	if (umem->fd < 0) {
 		err = -errno;
 		goto out_umem_alloc;
@@ -549,7 +549,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 	struct ifreq ifr = {};
 	int fd, err, ret;
 
-	fd = socket(AF_LOCAL, SOCK_DGRAM, 0);
+	fd = socket(AF_LOCAL, SOCK_DGRAM | SOCK_CLOEXEC, 0);
 	if (fd < 0)
 		return -errno;
 
@@ -1046,7 +1046,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	}
 
 	if (umem->refcount++ > 0) {
-		xsk->fd = socket(AF_XDP, SOCK_RAW, 0);
+		xsk->fd = socket(AF_XDP, SOCK_RAW | SOCK_CLOEXEC, 0);
 		if (xsk->fd < 0) {
 			err = -errno;
 			goto out_xsk_alloc;
-- 
2.33.1

