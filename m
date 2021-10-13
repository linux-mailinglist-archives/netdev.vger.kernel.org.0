Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEEE42B934
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238494AbhJMHgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbhJMHgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:36:10 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B783C061570;
        Wed, 13 Oct 2021 00:34:07 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id v20so1211369plo.7;
        Wed, 13 Oct 2021 00:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rig70eEn2BvUKouvKXgifKYiYAh+T90NFpKpqehMHT8=;
        b=D/luNIrgLhqOBQcCL42BvIDhthowaa8cfuNU2LvJNUDlzhvgaD9cwUA+ixMnTnLnld
         KcTuqrOabwyBY9uygApr3baS04e60mOU2Hv74ssmv1SMFD+O75j2cFsYyKR8icFQT81C
         jgrQic2XgtH52egw0oG2Fgg+/BZMWytOmcvAC4GUE0CGNgFTXQ5tW9zfE2dZmBvnBraU
         3Rcw4hIsJTWj+y8SI2+zndjKh+1q79/qzw66VghTLZwtzgtSIhf0bYJJopSU6VSHgfcI
         HkO6PhDstqAMxGYsyTGVpqkkj+t6Bzwq5WFiIZHrhz0NFbFqoVI/NwpiWKEafkzkMvmG
         MU/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rig70eEn2BvUKouvKXgifKYiYAh+T90NFpKpqehMHT8=;
        b=oAY6zecW2vct6v4fhEYjWFZe6LH9IV3wOiEOifqjRyyJ4w8SbWil+ooyVkcgaKPSP7
         VYZAso82TPTDLNu6o9e8D/Cs6i7qK0KJJ9HE0gvtxU2LZsJi7lTLZ/TexCRVvQm1z9ao
         5p9JgbKDMwJhISuPHoYMYxw+4ntaOFjZ6ZySJZpQL1rmBWCsmAU2ehk/W2r0lCTVc7GL
         hugYn1IArtY6Ef3g4wPZi5a2FooIaswxeQJj1MdzBwqOji1Y4JNDtzPDxERMGFgYfsd3
         kawiBzMbIgoOsGQdqYIRjjgMbut0ghvxVjyoYpoF3UoUipusQPafpOhMjoTkpom0s2Sg
         zD3Q==
X-Gm-Message-State: AOAM532pMeKPW0siwJegWJkkEjQbxtsUm4U4+89AKZz1Y1ccx2p20fQz
        13EnoJmuf3W16eLLIdHjQKTODs3NV9o=
X-Google-Smtp-Source: ABdhPJwF+KzESxmQvkopq5vZ9Ro0MbsMixgfMxi7+UxJhjlxa7v4aeA1LLcwAMRaiLtedn0LZ2qqew==
X-Received: by 2002:a17:90a:644d:: with SMTP id y13mr11793545pjm.10.1634110446750;
        Wed, 13 Oct 2021 00:34:06 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id t126sm5146528pfc.80.2021.10.13.00.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:34:06 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 5/8] libbpf: Use O_CLOEXEC uniformly when opening fds
Date:   Wed, 13 Oct 2021 13:03:45 +0530
Message-Id: <20211013073348.1611155-6-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013073348.1611155-1-memxor@gmail.com>
References: <20211013073348.1611155-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4473; h=from:subject; bh=K1W+2L5BFp8O5YWnBnRFncl2VCf3i48rE2WUw+BSgGI=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhZovSTD/3e0oiXVBu7DiJ/svNCER/m2NQh+kbLrb6 qLocnxqJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWaL0gAKCRBM4MiGSL8RylZpEA CA/auWuCPFlpTTDsC4MA6Fb2U2MGA0eTEPU8a1sVgxiY6vqE+RFaHCwEzh19VqJvE1Iu1wgXqEciVq 7NQgOwV7CYvNnueNf0WN1GAE5KeeXkyvzR5MaRZ5Dl6jv2Zzo0g8oRkw1bveIq+EQfGZ/91af4mU/0 OC8Hg/ywtejWQ1GS5wRcm2tpqi4uBTcHE26LeWkti3QhYUvGF6hlpGJwVcQexDAKHVMK/lbhsnS46U 13YS2Y6pecjqSx5JuoDU5Ju28Zohlz3FPbyHev4fH48aH8U1suM/SjKdR1HhjFIB+su+hm1HMAI99D S8A1Ntjjzxmee3qBZ1GZp6vhJMYtY2G2JgeHoEeTQq+NmuNqdQ8hfpnZbE8qu0r+wyquxrGzGpzWgH sKWUZx6S4gG6/2hymWToPKztb6nZhElC4jyGKurJ6wYC8tU60fhYtnk7iZb6zjQRsHiUpvxelc3Po6 jj7gRd7Qldy+aNw1/DSzUCFeOv5Sov4I416FUSOedE0MaddVOeDNqFVME+M5O/LghC69iYmxsG6Gba MelIaiTi5GcUZpX1AJ7L6Hs91BnoxoST96ZMosv/suLkopOiLJV3TmnZZNB5jA7/yWTJodwgdNgse0 zlnUFTHP1waCXG3BxBiPDzsIKSNb4j0LW1Sd0U7dKlYFltl+LZnYd52qoXsA==
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
index 60fbd1c6d466..06a7a4e52134 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -886,7 +886,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
 		return ERR_PTR(-LIBBPF_ERRNO__LIBELF);
 	}
 
-	fd = open(path, O_RDONLY);
+	fd = open(path, O_RDONLY | O_CLOEXEC);
 	if (fd < 0) {
 		err = -errno;
 		pr_warn("failed to open %s: %s\n", path, strerror(errno));
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 00ddc430e4b9..82f807ccbb2a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1223,7 +1223,7 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 		obj->efile.elf = elf_memory((char *)obj->efile.obj_buf,
 					    obj->efile.obj_buf_sz);
 	} else {
-		obj->efile.fd = ensure_good_fd(open(obj->path, O_RDONLY));
+		obj->efile.fd = ensure_good_fd(open(obj->path, O_RDONLY | O_CLOEXEC));
 		if (obj->efile.fd < 0) {
 			char errmsg[STRERR_BUFSIZE], *cp;
 
@@ -9331,7 +9331,7 @@ static int append_to_file(const char *file, const char *fmt, ...)
 	int fd, n, err = 0;
 	va_list ap;
 
-	fd = open(file, O_WRONLY | O_APPEND, 0);
+	fd = open(file, O_WRONLY | O_APPEND | O_CLOEXEC, 0);
 	if (fd < 0)
 		return -errno;
 
@@ -10976,7 +10976,7 @@ int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz)
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
index 6106a0b5572a..f993706eff77 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -302,7 +302,7 @@ static int init_output_elf(struct bpf_linker *linker, const char *file)
 	if (!linker->filename)
 		return -ENOMEM;
 
-	linker->fd = ensure_good_fd(open(file, O_WRONLY | O_CREAT | O_TRUNC, 0644));
+	linker->fd = ensure_good_fd(open(file, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0644));
 	if (linker->fd < 0) {
 		err = -errno;
 		pr_warn("failed to create '%s': %d\n", file, err);
@@ -557,7 +557,7 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
 
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
2.33.0

