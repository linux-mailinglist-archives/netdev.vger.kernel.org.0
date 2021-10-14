Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E980C42E2F3
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 22:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhJNU7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 16:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbhJNU7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 16:59:07 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9395FC061570;
        Thu, 14 Oct 2021 13:57:01 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id oa4so5686417pjb.2;
        Thu, 14 Oct 2021 13:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C93j/C9g2C0X7oLz+t8PZb0QsXg4xATKFIGPnk9yGrs=;
        b=gGO386J+AX1yzLxxTn3jYImNnHqL9tIusMs/h6Px4GGYNtP4a/T5f8sLC859fZJyvU
         MR41cvO3OQ3bWFbivb+C9aT/ZENNMNoItWBZGczQfpYmRarOOsi4Dfnk+nMJ71zFYXni
         LdKKVzvI0faghfaIZZmQhW+pe03w/Gmi/tIOSjQJacSHdf8dY/+ISqmIjLvfDSL04ub1
         IkTDpR7YfEKzzWdgbIv+Fvmhyq1afzCZx54KkMtN+f0sv1IiLO/Fs9eUU2tCMCI2jc7o
         TAQjaxOb//EQYH4laVmjdNQaRGGxdgyQ6ohEVZFDmDwPWLgGJkgNH7Vs4/qyvloe0RTs
         DSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C93j/C9g2C0X7oLz+t8PZb0QsXg4xATKFIGPnk9yGrs=;
        b=IESUSaaw6F2iCYx9/q/qtxFoPtjy8s1l1+vxnvfaKWUFYQ7jT3TjOW0/zK8QFKaZ9H
         562mUc4IfkftaMVu6FP2+j+xLCso5kEyDbJ7/nzcyNAsaFkvq/bUiKJE1a1u+eGkDeAJ
         JY9bGXXtXrgc/rRixf1MoPGd0y9LlDMfFBV8/4rEhGNyJmCuCSRoS3NRIgAziCyN+8or
         33hC5IkCoRYeCWfXxim5dH1yqHaSZcSVCHR5GHdsRJZ/5VfTpbehCsFx6fZLKynNxXzG
         CqIstCWTSW2vaysHEBaQoJjkWQYjFdDBqxk2fFU1TDcLkSegfpD+H5U7IC2IxyX7JN4r
         5EBg==
X-Gm-Message-State: AOAM531o6Oky/cyg4EB4RPUDtrY5nVUBLN057gQU5Tj9ADilaCizGL6V
        KTIrdW+5KeWm/TB7OesDwYeaF3IO6jM=
X-Google-Smtp-Source: ABdhPJz9K9akH9gwrn5X3jayVxpoXYvF3dg2IsQAvofjygiH9eqeB3EpfwEUxVPbLZGlRoOC66T7Mg==
X-Received: by 2002:a17:90b:188b:: with SMTP id mn11mr23273927pjb.170.1634245020824;
        Thu, 14 Oct 2021 13:57:00 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id k6sm3557214pfg.18.2021.10.14.13.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 13:57:00 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 4/8] libbpf: Ensure that BPF syscall fds are never 0, 1, or 2
Date:   Fri, 15 Oct 2021 02:26:40 +0530
Message-Id: <20211014205644.1837280-5-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014205644.1837280-1-memxor@gmail.com>
References: <20211014205644.1837280-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=14175; h=from:subject; bh=wjZf41y+0Z6hQF+t8mIIiaBK32Piiu79y7Qw2NZ8dGg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhaJk/k6TgoHoqdz/8xxPEKNZxxBQb1JC4qi2lSK58 jKdhGUWJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWiZPwAKCRBM4MiGSL8RyiysD/ 9iU5jktDLzJI6Nv0MeIytup45Prk8ECP9/LtLFQwf4HtObgKlvkNxbi6xUMA845ID6rnbsEBT78ic/ KVtQBDvriP4D4PWj0gAgnTfmD3usPh9Qi11IZdt5OHug4LoQ08ptGCDVv+hRFIH03qBF7/HDOszqCs iYZZvHjvGdHe+7WlsiQwohNSBwIGBo4WRfHMM5nNIS4zWaKjnYkNLwQwpPNVlmY+Z7BNOBs4j6UR01 pBqfnXPVLExJwaBldAcEBsPnX1Sk5zT9in2FNkEU3MhXC8ZMYSzJalWa5D1Nn9hXZ7EDvDMlW8c2LZ VYm90eKYPySFhZTuiaGcWnlrGrUr8Et7PI1RwhEojA4oBeWh06Vgdm9NUupYyyUwD79R2n+oDyH9x6 EicAA57kbExyNwmZFZKRSJb3dKONC1CYMZYS7KwN94RR/iA+Aspee8dDGYEEH6JFVsEOklRAeRl5xz PhTTIFVUOhjXskcEEOfC0mM4y4a0cufegRQ5+W+906c14i5X9HUIx4jHpIzE3TQ0+PvOo+VeCokjj7 sOf6DrDcI/zxOFRcmDddr6GUx33p0oLc4huO/SjmMI0Nbu6vZY7FrhUg9N8qcL9XnXGmbLYMtNB5T9 TWCf8QRIEDYYFSlvztXs9LqARkQKgP6918OF1EEm05PulfaryVatyvGj+s0A==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a simple wrapper for passing an fd and getting a new one >= 3 if it
is one of 0, 1, or 2. There are two primary reasons to make this change:
First, libbpf relies on the assumption a certain BPF fd is never 0 (e.g.
most recently noticed in [0]). Second, Alexei pointed out in [1] that
some environments reset stdin, stdout, and stderr if they notice an
invalid fd at these numbers. To protect against both these cases, switch
all internal BPF syscall wrappers in libbpf to always return an fd >= 3.
We only need to modify the syscall wrappers and not other code that
assumes a valid fd by doing >= 0, to avoid pointless churn, and because
it is still a valid assumption. The cost paid is two additional syscalls
if fd is in range [0, 2].

This is only done for fds that are held by objects created using libbpf,
or returned from libbpf functions, not for intermediate fds closed soon
after their use is over. This implies that one of the assumptions is
that the environment resetting fds in the starting range [0, 2] only do
so before libbpf function call or after, but never in parallel, since
that would close fds while we dup them.

[0]: e31eec77e4ab ("bpf: selftests: Fix fd cleanup in get_branch_snapshot")
[1]: https://lore.kernel.org/bpf/CAADnVQKVKY8o_3aU8Gzke443+uHa-eGoM0h7W4srChMXU1S4Bg@mail.gmail.com

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf.c             | 28 ++++++++++++-------------
 tools/lib/bpf/libbpf.c          | 36 ++++++++++++++++-----------------
 tools/lib/bpf/libbpf_internal.h | 23 +++++++++++++++++++++
 tools/lib/bpf/linker.c          |  2 +-
 tools/lib/bpf/ringbuf.c         |  2 +-
 tools/lib/bpf/skel_internal.h   | 35 +++++++++++++++++++++++++++++++-
 6 files changed, 91 insertions(+), 35 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 7d1741ceaa32..0e1dedd94ebf 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -74,7 +74,7 @@ static inline int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size)
 		fd = sys_bpf(BPF_PROG_LOAD, attr, size);
 	} while (fd < 0 && errno == EAGAIN && retries-- > 0);
 
-	return fd;
+	return ensure_good_fd(fd);
 }
 
 int bpf_create_map_xattr(const struct bpf_create_map_attr *create_attr)
@@ -104,7 +104,7 @@ int bpf_create_map_xattr(const struct bpf_create_map_attr *create_attr)
 		attr.inner_map_fd = create_attr->inner_map_fd;
 
 	fd = sys_bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
-	return libbpf_err_errno(fd);
+	return libbpf_err_errno(ensure_good_fd(fd));
 }
 
 int bpf_create_map_node(enum bpf_map_type map_type, const char *name,
@@ -182,7 +182,7 @@ int bpf_create_map_in_map_node(enum bpf_map_type map_type, const char *name,
 	}
 
 	fd = sys_bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
-	return libbpf_err_errno(fd);
+	return libbpf_err_errno(ensure_good_fd(fd));
 }
 
 int bpf_create_map_in_map(enum bpf_map_type map_type, const char *name,
@@ -330,7 +330,7 @@ int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
 	/* free() doesn't affect errno, so we don't need to restore it */
 	free(finfo);
 	free(linfo);
-	return libbpf_err_errno(fd);
+	return libbpf_err_errno(ensure_good_fd(fd));
 }
 
 int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
@@ -610,7 +610,7 @@ int bpf_obj_get(const char *pathname)
 	attr.pathname = ptr_to_u64((void *)pathname);
 
 	fd = sys_bpf(BPF_OBJ_GET, &attr, sizeof(attr));
-	return libbpf_err_errno(fd);
+	return libbpf_err_errno(ensure_good_fd(fd));
 }
 
 int bpf_prog_attach(int prog_fd, int target_fd, enum bpf_attach_type type,
@@ -721,7 +721,7 @@ int bpf_link_create(int prog_fd, int target_fd,
 	}
 proceed:
 	fd = sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
-	return libbpf_err_errno(fd);
+	return libbpf_err_errno(ensure_good_fd(fd));
 }
 
 int bpf_link_detach(int link_fd)
@@ -764,7 +764,7 @@ int bpf_iter_create(int link_fd)
 	attr.iter_create.link_fd = link_fd;
 
 	fd = sys_bpf(BPF_ITER_CREATE, &attr, sizeof(attr));
-	return libbpf_err_errno(fd);
+	return libbpf_err_errno(ensure_good_fd(fd));
 }
 
 int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
@@ -922,7 +922,7 @@ int bpf_prog_get_fd_by_id(__u32 id)
 	attr.prog_id = id;
 
 	fd = sys_bpf(BPF_PROG_GET_FD_BY_ID, &attr, sizeof(attr));
-	return libbpf_err_errno(fd);
+	return libbpf_err_errno(ensure_good_fd(fd));
 }
 
 int bpf_map_get_fd_by_id(__u32 id)
@@ -934,7 +934,7 @@ int bpf_map_get_fd_by_id(__u32 id)
 	attr.map_id = id;
 
 	fd = sys_bpf(BPF_MAP_GET_FD_BY_ID, &attr, sizeof(attr));
-	return libbpf_err_errno(fd);
+	return libbpf_err_errno(ensure_good_fd(fd));
 }
 
 int bpf_btf_get_fd_by_id(__u32 id)
@@ -946,7 +946,7 @@ int bpf_btf_get_fd_by_id(__u32 id)
 	attr.btf_id = id;
 
 	fd = sys_bpf(BPF_BTF_GET_FD_BY_ID, &attr, sizeof(attr));
-	return libbpf_err_errno(fd);
+	return libbpf_err_errno(ensure_good_fd(fd));
 }
 
 int bpf_link_get_fd_by_id(__u32 id)
@@ -958,7 +958,7 @@ int bpf_link_get_fd_by_id(__u32 id)
 	attr.link_id = id;
 
 	fd = sys_bpf(BPF_LINK_GET_FD_BY_ID, &attr, sizeof(attr));
-	return libbpf_err_errno(fd);
+	return libbpf_err_errno(ensure_good_fd(fd));
 }
 
 int bpf_obj_get_info_by_fd(int bpf_fd, void *info, __u32 *info_len)
@@ -989,7 +989,7 @@ int bpf_raw_tracepoint_open(const char *name, int prog_fd)
 	attr.raw_tracepoint.prog_fd = prog_fd;
 
 	fd = sys_bpf(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
-	return libbpf_err_errno(fd);
+	return libbpf_err_errno(ensure_good_fd(fd));
 }
 
 int bpf_load_btf(const void *btf, __u32 btf_size, char *log_buf, __u32 log_buf_size,
@@ -1015,7 +1015,7 @@ int bpf_load_btf(const void *btf, __u32 btf_size, char *log_buf, __u32 log_buf_s
 		goto retry;
 	}
 
-	return libbpf_err_errno(fd);
+	return libbpf_err_errno(ensure_good_fd(fd));
 }
 
 int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf, __u32 *buf_len,
@@ -1051,7 +1051,7 @@ int bpf_enable_stats(enum bpf_stats_type type)
 	attr.enable_stats.type = type;
 
 	fd = sys_bpf(BPF_ENABLE_STATS, &attr, sizeof(attr));
-	return libbpf_err_errno(fd);
+	return libbpf_err_errno(ensure_good_fd(fd));
 }
 
 int bpf_prog_bind_map(int prog_fd, int map_fd,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 30a1a6d1b615..0a5ff7f2d16d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1223,7 +1223,7 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 		obj->efile.elf = elf_memory((char *)obj->efile.obj_buf,
 					    obj->efile.obj_buf_sz);
 	} else {
-		obj->efile.fd = open(obj->path, O_RDONLY);
+		obj->efile.fd = ensure_good_fd(open(obj->path, O_RDONLY));
 		if (obj->efile.fd < 0) {
 			char errmsg[STRERR_BUFSIZE], *cp;
 
@@ -9312,10 +9312,10 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
 	attr.config2 = offset;		 /* kprobe_addr or probe_offset */
 
 	/* pid filter is meaningful only for uprobes */
-	pfd = syscall(__NR_perf_event_open, &attr,
-		      pid < 0 ? -1 : pid /* pid */,
-		      pid == -1 ? 0 : -1 /* cpu */,
-		      -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
+	pfd = ensure_good_fd(syscall(__NR_perf_event_open, &attr,
+			     pid < 0 ? -1 : pid /* pid */,
+			     pid == -1 ? 0 : -1 /* cpu */,
+			     -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC));
 	if (pfd < 0) {
 		err = -errno;
 		pr_warn("%s perf_event_open() failed: %s\n",
@@ -9406,10 +9406,10 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
 	attr.config = type;
 	attr.type = PERF_TYPE_TRACEPOINT;
 
-	pfd = syscall(__NR_perf_event_open, &attr,
-		      pid < 0 ? -1 : pid, /* pid */
-		      pid == -1 ? 0 : -1, /* cpu */
-		      -1 /* group_fd */,  PERF_FLAG_FD_CLOEXEC);
+	pfd = ensure_good_fd(syscall(__NR_perf_event_open, &attr,
+			     pid < 0 ? -1 : pid, /* pid */
+			     pid == -1 ? 0 : -1, /* cpu */
+			     -1 /* group_fd */,  PERF_FLAG_FD_CLOEXEC));
 	if (pfd < 0) {
 		err = -errno;
 		pr_warn("legacy kprobe perf_event_open() failed: %s\n",
@@ -9601,10 +9601,10 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	attr.config = type;
 	attr.type = PERF_TYPE_TRACEPOINT;
 
-	pfd = syscall(__NR_perf_event_open, &attr,
-		      pid < 0 ? -1 : pid, /* pid */
-		      pid == -1 ? 0 : -1, /* cpu */
-		      -1 /* group_fd */,  PERF_FLAG_FD_CLOEXEC);
+	pfd = ensure_good_fd(syscall(__NR_perf_event_open, &attr,
+			     pid < 0 ? -1 : pid, /* pid */
+			     pid == -1 ? 0 : -1, /* cpu */
+			     -1 /* group_fd */,  PERF_FLAG_FD_CLOEXEC));
 	if (pfd < 0) {
 		err = -errno;
 		pr_warn("legacy uprobe perf_event_open() failed: %d\n", err);
@@ -9733,8 +9733,8 @@ static int perf_event_open_tracepoint(const char *tp_category,
 	attr.size = sizeof(attr);
 	attr.config = tp_id;
 
-	pfd = syscall(__NR_perf_event_open, &attr, -1 /* pid */, 0 /* cpu */,
-		      -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
+	pfd = ensure_good_fd(syscall(__NR_perf_event_open, &attr, -1 /* pid */, 0 /* cpu */,
+			     -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC));
 	if (pfd < 0) {
 		err = -errno;
 		pr_warn("tracepoint '%s/%s' perf_event_open() failed: %s\n",
@@ -10253,8 +10253,8 @@ perf_buffer__open_cpu_buf(struct perf_buffer *pb, struct perf_event_attr *attr,
 	cpu_buf->cpu = cpu;
 	cpu_buf->map_key = map_key;
 
-	cpu_buf->fd = syscall(__NR_perf_event_open, attr, -1 /* pid */, cpu,
-			      -1, PERF_FLAG_FD_CLOEXEC);
+	cpu_buf->fd = ensure_good_fd(syscall(__NR_perf_event_open, attr, -1 /* pid */, cpu,
+				     -1, PERF_FLAG_FD_CLOEXEC));
 	if (cpu_buf->fd < 0) {
 		err = -errno;
 		pr_warn("failed to open perf buffer event on cpu #%d: %s\n",
@@ -10380,7 +10380,7 @@ static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
 	pb->mmap_size = pb->page_size * page_cnt;
 	pb->map_fd = map_fd;
 
-	pb->epoll_fd = epoll_create1(EPOLL_CLOEXEC);
+	pb->epoll_fd = ensure_good_fd(epoll_create1(EPOLL_CLOEXEC));
 	if (pb->epoll_fd < 0) {
 		err = -errno;
 		pr_warn("failed to create epoll instance: %s\n",
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index f7fd3944d46d..9ae046d3b1c3 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -13,6 +13,8 @@
 #include <limits.h>
 #include <errno.h>
 #include <linux/err.h>
+#include <fcntl.h>
+#include <unistd.h>
 #include "libbpf_legacy.h"
 #include "relo_core.h"
 
@@ -472,4 +474,25 @@ static inline bool is_ldimm64_insn(struct bpf_insn *insn)
 	return insn->code == (BPF_LD | BPF_IMM | BPF_DW);
 }
 
+/* if fd is stdin, stdout, or stderr, dup to a fd greater than 2
+ * Takes ownership of the fd passed in, and closes it if calling
+ * fcntl(fd, F_DUPFD_CLOEXEC, 3).
+ */
+static inline int ensure_good_fd(int fd)
+{
+	int old_fd = fd, save_errno;
+
+	if (unlikely(fd >= 0 && fd < 3)) {
+		fd = fcntl(fd, F_DUPFD_CLOEXEC, 3);
+		if (fd < 0) {
+			save_errno = errno;
+			pr_warn("failed to dup FD %d to FD > 2: %d\n", old_fd, -errno);
+		}
+		close(old_fd);
+		if (fd < 0)
+			errno = save_errno;
+	}
+	return fd;
+}
+
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 2df880cefdae..6106a0b5572a 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -302,7 +302,7 @@ static int init_output_elf(struct bpf_linker *linker, const char *file)
 	if (!linker->filename)
 		return -ENOMEM;
 
-	linker->fd = open(file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
+	linker->fd = ensure_good_fd(open(file, O_WRONLY | O_CREAT | O_TRUNC, 0644));
 	if (linker->fd < 0) {
 		err = -errno;
 		pr_warn("failed to create '%s': %d\n", file, err);
diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
index 8bc117bcc7bc..40bb33ae548b 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -173,7 +173,7 @@ ring_buffer__new(int map_fd, ring_buffer_sample_fn sample_cb, void *ctx,
 
 	rb->page_size = getpagesize();
 
-	rb->epoll_fd = epoll_create1(EPOLL_CLOEXEC);
+	rb->epoll_fd = ensure_good_fd(epoll_create1(EPOLL_CLOEXEC));
 	if (rb->epoll_fd < 0) {
 		err = -errno;
 		pr_warn("ringbuf: failed to create epoll instance: %d\n", err);
diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.h
index 9cf66702fa8d..1322c4de15e2 100644
--- a/tools/lib/bpf/skel_internal.h
+++ b/tools/lib/bpf/skel_internal.h
@@ -6,6 +6,7 @@
 #include <unistd.h>
 #include <sys/syscall.h>
 #include <sys/mman.h>
+#include <fcntl.h>
 
 /* This file is a base header for auto-generated *.lskel.h files.
  * Its contents will change and may become part of auto-generation in the future.
@@ -60,11 +61,39 @@ static inline int skel_closenz(int fd)
 	return -EINVAL;
 }
 
+static inline int skel_reserve_bad_fds(struct bpf_load_and_run_opts *opts, int *fds)
+{
+	int fd, err, i;
+
+	for (i = 0; i < 3; i++) {
+		fd = open("/dev/null", O_RDONLY | O_CLOEXEC);
+		if (fd < 0) {
+			opts->errstr = "failed to reserve fd 0, 1, and 2";
+			err = -errno;
+			return err;
+		}
+		if (__builtin_expect(fd >= 3, 1)) {
+			close(fd);
+			break;
+		}
+		fds[i] = fd;
+	}
+	return 0;
+}
+
 static inline int bpf_load_and_run(struct bpf_load_and_run_opts *opts)
 {
-	int map_fd = -1, prog_fd = -1, key = 0, err;
+	int map_fd = -1, prog_fd = -1, key = 0, err, i;
+	int res_fds[3] = { -1, -1, -1 };
 	union bpf_attr attr;
 
+	/* ensures that we don't open fd 0, 1, or 2 from here on out */
+	err = skel_reserve_bad_fds(opts, res_fds);
+	if (err < 0) {
+		errno = -err;
+		goto out;
+	}
+
 	map_fd = bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "__loader.map", 4,
 				     opts->data_sz, 1, 0);
 	if (map_fd < 0) {
@@ -115,6 +144,10 @@ static inline int bpf_load_and_run(struct bpf_load_and_run_opts *opts)
 	}
 	err = 0;
 out:
+	for (i = 0; i < 3; i++) {
+		if (res_fds[i] >= 0)
+			close(res_fds[i]);
+	}
 	if (map_fd >= 0)
 		close(map_fd);
 	if (prog_fd >= 0)
-- 
2.33.0

