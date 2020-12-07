Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912422D0A2A
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 06:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgLGFWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 00:22:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgLGFWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 00:22:01 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH bpf] tools/bpftool: Add/Fix support for modules btf dump
Date:   Sun,  6 Dec 2020 21:20:57 -0800
Message-Id: <20201207052057.397223-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

While playing with BTF for modules, i noticed that executing the command:
$ bpftool btf dump id <module's btf id>

Fails due to lack of information in the BTF data.

Maybe I am missing a step but actually adding the support for this is
very simple.

To completely parse modules BTF data, we need the vmlinux BTF as their
"base btf", which can be easily found by iterating through the btf ids and
looking for btf.name == "vmlinux".

I am not sure why this hasn't been added by the original patchset
"Integrate kernel module BTF support", as adding the support for
this is very trivial. Unless i am missing something, CCing Andrii..

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
CC: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c      | 57 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/btf.h      |  2 ++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 60 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 3c3f2bc6c652..5900cccf82e2 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1370,6 +1370,14 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
 		goto exit_free;
 	}
 
+	/* force base_btf for kernel modules */
+	if (btf_info.kernel_btf && !base_btf) {
+		int id = btf_get_kernel_id();
+
+		/* Double check our btf is not the kernel BTF itself */
+		if (id != btf_info.id)
+			btf__get_from_id(id, &base_btf);
+	}
 	btf = btf_new(ptr, btf_info.btf_size, base_btf);
 
 exit_free:
@@ -4623,3 +4631,52 @@ struct btf *libbpf_find_kernel_btf(void)
 	pr_warn("failed to find valid kernel BTF\n");
 	return ERR_PTR(-ESRCH);
 }
+
+#define foreach_btf_id(id, err) \
+	for (err = bpf_btf_get_next_id((id), (&id)); !err; )
+
+/*
+ * Scan all ids for a kernel btf with name == "vmlinux"
+ */
+int btf_get_kernel_id(void)
+{
+	struct bpf_btf_info info;
+	__u32 len = sizeof(info);
+	char name[64];
+	__u32 id = 0;
+	int err, fd;
+
+	foreach_btf_id(id, err) {
+		fd = bpf_btf_get_fd_by_id(id);
+		if (fd < 0) {
+			if (errno == ENOENT)
+				continue; /* expected race: BTF was unloaded */
+			err = -errno;
+			pr_warn("failed to get BTF object #%d FD: %d\n", id, err);
+			return err;
+		}
+
+		memset(&info, 0, sizeof(info));
+		info.name = ptr_to_u64(name);
+		info.name_len = sizeof(name);
+
+		err = bpf_obj_get_info_by_fd(fd, &info, &len);
+		if (err) {
+			err = -errno;
+			pr_warn("failed to get BTF object #%d info: %d\n", id, err);
+			return err;
+		}
+
+		if (info.kernel_btf && strcmp(name, "vmlinux") == 0)
+			return id;
+
+	}
+
+	if (err && errno != ENOENT) {
+		err = -errno;
+		pr_warn("failed to iterate BTF objects: %d\n", err);
+		return err;
+	}
+
+	return -ENOENT;
+}
\ No newline at end of file
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 1237bcd1dd17..44075b086d1c 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -8,6 +8,7 @@
 #include <stdbool.h>
 #include <linux/btf.h>
 #include <linux/types.h>
+#include <uapi/linux/bpf.h>
 
 #include "libbpf_common.h"
 
@@ -90,6 +91,7 @@ LIBBPF_API __u32 btf_ext__func_info_rec_size(const struct btf_ext *btf_ext);
 LIBBPF_API __u32 btf_ext__line_info_rec_size(const struct btf_ext *btf_ext);
 
 LIBBPF_API struct btf *libbpf_find_kernel_btf(void);
+LIBBPF_API int btf_get_kernel_id(void);
 
 LIBBPF_API int btf__find_str(struct btf *btf, const char *s);
 LIBBPF_API int btf__add_str(struct btf *btf, const char *s);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 7c4126542e2b..727daeb57f35 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -348,4 +348,5 @@ LIBBPF_0.3.0 {
 		btf__new_split;
 		xsk_setup_xdp_prog;
 		xsk_socket__update_xskmap;
+		btf_get_kernel_id
 } LIBBPF_0.2.0;
-- 
2.26.2

