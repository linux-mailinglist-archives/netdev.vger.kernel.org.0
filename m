Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94A451010F4
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbfKSBod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:44:33 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:47941 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727385AbfKSBoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:44:32 -0500
Received: by mail-pf1-f202.google.com with SMTP id w16so15570290pfq.14
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 17:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+lN+OnV/OGJwrxgrmDkzu2oxVw2ucT8UYsYGvvebriE=;
        b=SgxZGNUVWYGGXkISad1kgT6U14PAx1pYar/m0xNV/3NNFEf6NzDllpscBgMFeLQ5lF
         dft6a8iZOTnTvVVsdNOmbswFnRj1d1xZiPgX51/b+cBLvg4HO30UIqKU+r+GXogOfJih
         PJO8nmNkKWEEd6+fX2TswwINxJ3CNZjMLmZGHqwLIi/2K/oLIpD30/iV7+UXjB6Mt9uM
         /Qy6ye3RZMM+9nFeLh4kn1mkSH3UTa2EJJOAgCFUSnO7AyWRAC8JZ6gAT27V/rpm6cBH
         BWi/d6AjaKgOg1F+JHm9Z0QT4jNWQCsBCa1j3H3BZ42KB5ivt4pmacFFdzx/k4c5Ov7I
         2wAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+lN+OnV/OGJwrxgrmDkzu2oxVw2ucT8UYsYGvvebriE=;
        b=Q5WGB7OlRLab2Ji7JGp5wZO9C0ptYaQhz4CHWolZIDsovXJyN/QmDcc31dH9LgkJHl
         3o3otskfe0h70C0URIdZ07J2ScgdmFbjKP0KmdE6zcKrVuuvx/pFJ0W+meNVgEp/Pss/
         ws6imiH1oZ0KqWerhvrD+oI6Iu7YU7YTNvg4lSYzVOz3ckzf+/K9pz3Q+UwuFSZ1dspR
         u3ew0C2UO8+WuRLIXa4ME6KO1PYrygQ4YsjcMm8NJ8wdoBvIni9TznGHvjGoiLaGe2AO
         e/g1vebbNf2OWRlVGULUciRgs6xBUXRAIPmkai75SFEjCIiJWwuL3e9KFWQvz5JOOiND
         qdLQ==
X-Gm-Message-State: APjAAAV5tIke6dyBzG9LI/AzwX9yhIUQ2Ol+vbg7BlQANwzUHJmJ40sE
        D63QFWfLpDE68M1DYvCzO6RlQZb+nY79
X-Google-Smtp-Source: APXvYqyB2Y5/Wmt+HsgSIkvPHaLgzw0qyYa7UcYgcIX8FTmQbpHeFUjIzNWtvmKgynWAz8wtTscL+ylNecL6
X-Received: by 2002:a63:4501:: with SMTP id s1mr2642645pga.5.1574127871391;
 Mon, 18 Nov 2019 17:44:31 -0800 (PST)
Date:   Mon, 18 Nov 2019 17:43:55 -0800
In-Reply-To: <20191119014357.98465-1-brianvv@google.com>
Message-Id: <20191119014357.98465-8-brianvv@google.com>
Mime-Version: 1.0
References: <20191119014357.98465-1-brianvv@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH bpf-next 7/9] libbpf: add libbpf support to batch ops
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>, Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

Added four libbpf API functions to support map batch operations:
  . int bpf_map_delete_batch( ... )
  . int bpf_map_lookup_batch( ... )
  . int bpf_map_lookup_and_delete_batch( ... )
  . int bpf_map_update_batch( ... )

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/lib/bpf/bpf.c      | 61 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/bpf.h      | 14 +++++++++
 tools/lib/bpf/libbpf.map |  4 +++
 3 files changed, 79 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 98596e15390fb..9acd9309b47b3 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -443,6 +443,67 @@ int bpf_map_freeze(int fd)
 	return sys_bpf(BPF_MAP_FREEZE, &attr, sizeof(attr));
 }
 
+static int bpf_map_batch_common(int cmd, int fd, void  *in_batch,
+				void *out_batch, void *keys, void *values,
+				__u32 *count, __u64 elem_flags,
+				__u64 flags)
+{
+	union bpf_attr attr = {};
+	int ret;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.batch.map_fd = fd;
+	attr.batch.in_batch = ptr_to_u64(in_batch);
+	attr.batch.out_batch = ptr_to_u64(out_batch);
+	attr.batch.keys = ptr_to_u64(keys);
+	attr.batch.values = ptr_to_u64(values);
+	if (count)
+		attr.batch.count = *count;
+	attr.batch.elem_flags = elem_flags;
+	attr.batch.flags = flags;
+
+	ret = sys_bpf(cmd, &attr, sizeof(attr));
+	if (count)
+		*count = attr.batch.count;
+
+	return ret;
+}
+
+int bpf_map_delete_batch(int fd, void *in_batch, void *out_batch, __u32 *count,
+			 __u64 elem_flags, __u64 flags)
+{
+	return bpf_map_batch_common(BPF_MAP_DELETE_BATCH, fd, in_batch,
+				    out_batch, NULL, NULL, count,
+				    elem_flags, flags);
+}
+
+int bpf_map_lookup_batch(int fd, void *in_batch, void *out_batch, void *keys,
+			 void *values, __u32 *count,
+			 __u64 elem_flags, __u64 flags)
+{
+	return bpf_map_batch_common(BPF_MAP_LOOKUP_BATCH, fd, in_batch,
+				    out_batch, keys, values, count,
+				    elem_flags, flags);
+}
+
+int bpf_map_lookup_and_delete_batch(int fd, void *in_batch, void *out_batch,
+				    void *keys, void *values,
+				    __u32 *count, __u64 elem_flags,
+				    __u64 flags)
+{
+	return bpf_map_batch_common(BPF_MAP_LOOKUP_AND_DELETE_BATCH,
+				    fd, in_batch, out_batch, keys, values,
+				    count, elem_flags, flags);
+}
+
+int bpf_map_update_batch(int fd, void *keys, void *values, __u32 *count,
+			 __u64 elem_flags, __u64 flags)
+{
+	return bpf_map_batch_common(BPF_MAP_UPDATE_BATCH,
+				    fd, NULL, NULL, keys, values,
+				    count, elem_flags, flags);
+}
+
 int bpf_obj_pin(int fd, const char *pathname)
 {
 	union bpf_attr attr;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 3c791fa8e68e8..3ec63384400f1 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -126,6 +126,20 @@ LIBBPF_API int bpf_map_lookup_and_delete_elem(int fd, const void *key,
 LIBBPF_API int bpf_map_delete_elem(int fd, const void *key);
 LIBBPF_API int bpf_map_get_next_key(int fd, const void *key, void *next_key);
 LIBBPF_API int bpf_map_freeze(int fd);
+LIBBPF_API int bpf_map_delete_batch(int fd, void *in_batch, void *out_batch,
+				    __u32 *count, __u64 elem_flags,
+				    __u64 flags);
+LIBBPF_API int bpf_map_lookup_batch(int fd, void *in_batch, void *out_batch,
+				    void *keys, void *values, __u32 *count,
+				    __u64 elem_flags, __u64 flags);
+LIBBPF_API int bpf_map_lookup_and_delete_batch(int fd, void *in_batch,
+					       void *out_batch, void *keys,
+					       void *values, __u32 *count,
+					       __u64 elem_flags, __u64 flags);
+LIBBPF_API int bpf_map_update_batch(int fd, void *keys, void *values,
+				    __u32 *count, __u64 elem_flags,
+				    __u64 flags);
+
 LIBBPF_API int bpf_obj_pin(int fd, const char *pathname);
 LIBBPF_API int bpf_obj_get(const char *pathname);
 LIBBPF_API int bpf_prog_attach(int prog_fd, int attachable_fd,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 8ddc2c40e482d..56462fea66f74 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -207,4 +207,8 @@ LIBBPF_0.0.6 {
 		bpf_program__size;
 		btf__find_by_name_kind;
 		libbpf_find_vmlinux_btf_id;
+		bpf_map_delete_batch;
+		bpf_map_lookup_and_delete_batch;
+		bpf_map_lookup_batch;
+		bpf_map_update_batch;
 } LIBBPF_0.0.5;
-- 
2.24.0.432.g9d3f5f5b63-goog

