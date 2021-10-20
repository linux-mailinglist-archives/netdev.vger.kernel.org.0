Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C2A4353A4
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 21:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhJTTSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 15:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbhJTTR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 15:17:58 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C636C061749;
        Wed, 20 Oct 2021 12:15:44 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id oa4so3182454pjb.2;
        Wed, 20 Oct 2021 12:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DVPpc1rAae+UZqEfr1sY2yTeZpvr1omuSKhOaWNSHGQ=;
        b=p2Q3HcQY0xOUIQHKiqUrMQFUdE7qVabHPcUDVbT8WorioousE2BreoJfNgThmVCB8N
         fRlqXQT3VfVQv8Q+IuOLT2slnJa8OoXmu0ydQvhdV37nVLqn8txwUFqWkFVUvTkvhsE+
         uTYED3IpoLDlJaeRUSIwT8cSQF0H0ZXDcntdRffNKST6ZGLmYjxLHc7QFrSjMIRKHUby
         Quz+5uEpPReDE9/uDFE6pBHDakyZRkPFWg26xuVXFA/F4gXhkIP2tkWRnSdhKBFsQ0Gr
         UnBKOrRjEHIkhyYAoRvsiVlYbAXhsTzvIFWOMmT9R02Qlss+a68PNbpEFqCPzW5h7T2S
         GGSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DVPpc1rAae+UZqEfr1sY2yTeZpvr1omuSKhOaWNSHGQ=;
        b=nGe3fqLb0TMRbAVXMBc23NPU4GG9b/WxPX5n7+IeYoblS0K+sltpklwzQPgGWn3Ol+
         wEJERhskX846n5qjwT8asc9Nvn3B+Pcv/cpWYcfoA0HLheAsSHXWgOwcxjjQPjoYbS8t
         /1VNZfl3QNM+GLdyQMGkvUrVJ+iJa1URHirRhzrYqLwSsYy8iw1PjT5n+5cpSWSfl3NC
         vGzRkctOsIJ4ffjj2yhD0m5IwKkqSYJcXmut2z1Zdvi23U38PLmn69Kicuw6PBrYtN/P
         0halg5zNEaAE0YyfmbtV2hkAsT1w1DCjsF6pnebGUzUVm5qbwm9dXGQtOSDrTgiJzjv3
         gSCQ==
X-Gm-Message-State: AOAM530nN2koChMHTbQEnhJkacyZlVKj19GsuV/9U34jRfWKQtfXxskI
        E4+cCvr0sbyWuGJ8dZ3VrT0ZenWoeqZcyg==
X-Google-Smtp-Source: ABdhPJxVprJq4QKFa/vbfis1+40M5pJDUaBJdgywu/5ZG84YbyN0TJ/Uy3tzDobomjwOWoXdzUo9tg==
X-Received: by 2002:a17:90a:cc01:: with SMTP id b1mr867596pju.104.1634757343801;
        Wed, 20 Oct 2021 12:15:43 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id z8sm3129520pgi.45.2021.10.20.12.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 12:15:43 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 5/8] libbpf: Use O_CLOEXEC uniformly when opening fds
Date:   Thu, 21 Oct 2021 00:45:23 +0530
Message-Id: <20211020191526.2306852-6-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211020191526.2306852-1-memxor@gmail.com>
References: <20211020191526.2306852-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4473; h=from:subject; bh=rX+5LiYpzXmH+4ph+z9ZP8wDHvlDbsfNxLPjoYVLK/Q=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhcGoeeARTlt6PgEHnCdG5yPKNIjMzOpeIdk3tiGjk klF2CwuJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXBqHgAKCRBM4MiGSL8Ryt84D/ 0QNAvW8Fr9oxGrgB3e6s6ps3sB2B0t9NofrLHJhqOfMN8EKuxKYnyK5evCl7WziKFZkFORQE9jatOd JF1Ita6TXKi/49SaCzNudRrMMwo/mbuKu0RZSqkyoobSKq4rqLfxvVaRl/RFA9nENJvtkD2e4nwag5 V/lJJqC5thJe1VMSW/sUSewH4N2p6oICLOvEBZdyVGgk9jIl8kO7lipb5/oM8DYXRSIhWHfBzHa/Zw 4L7vwSXD+SoGcT3VEHJta0EiHFjEhnHcNHUReseve9jhLrPy5H8i9LMy6V7+QNbLEzWWKoqsOsJlHT 66jFXGgqyOSIKpjXzlule/XqI0TVamIp3K5Qkn/jm4oiDyx9Jc6Hp3D5iorf3tVGKvGcZcA+oUeTWL I3RuErH3w/oqqvj85FP2/uFqmd/fw2wk4BTl6Tz1sWfu9wvbnDFS3mmAPJSjKbqeblVCvqa8xYrJ0j nwrGA2i04Lc6sV96tzjmHRFfsZLVBRQqSzz+GGDkjoJ1T8qVrV+fcdVtcn9fHzH5RkcqmNgCtwlQOE Rj6jV2J4GaFNTz6JlHnnwCUahiCaBw57/eKXEzrs5LK8innxsjVPlO0i/amG7a7vI/SQjMh9+5caFn pk1hex4gPizfSubcxericsDZaKg5kWa3ZSMs2o22w8va31mZI1TBos2tqGEw==
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
index 1f6dea11f600..6e02f11e71ef 100644
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
index d4d2842e31ea..003368435170 100644
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
 
@@ -9329,7 +9329,7 @@ static int append_to_file(const char *file, const char *fmt, ...)
 	int fd, n, err = 0;
 	va_list ap;
 
-	fd = open(file, O_WRONLY | O_APPEND, 0);
+	fd = open(file, O_WRONLY | O_APPEND | O_CLOEXEC, 0);
 	if (fd < 0)
 		return -errno;
 
@@ -10974,7 +10974,7 @@ int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz)
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
2.33.1

