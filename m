Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE0113CC5D
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgAOSnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:43:41 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:47575 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbgAOSnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:43:40 -0500
Received: by mail-pf1-f201.google.com with SMTP id e62so11409561pfh.14
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RCyrkp6zT5EPgtnS5mYgbeYBhIOvjRmdaqV1JP6GZIM=;
        b=BKVmoDfcMdak267QSTOLD7Kr7mys7DR6FMqoEiJoy7U2bcelFMYINew1NNR4zVak31
         1i6qmI3np3uqMC+7PEJQ6MzpuUDdRc35ffj1NQIp5imJ8flKY6SahNdy07V/tr+Ohsd8
         gwd1pTlMOero2dI3lesFWGgb+JTkeQLlYBqB4sAAeNRdjur4PmVjFzd/Cs4w/h9SwnJx
         x0lJR3yiR2n+MOzKWMnuTsmWiZvDGjW7QvUUQkJ2xs8TPH61M5qe9bE2Ms/pAvsSLfVR
         XZRsFbf6YL02n0R6TYFFBePCYEGjBFV7BL2O6wSuvMR4eC8PJc3+Q3eRxORDxj7Ojuoc
         j9aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RCyrkp6zT5EPgtnS5mYgbeYBhIOvjRmdaqV1JP6GZIM=;
        b=ICh5ouJf387nZh11XIuPk8yk03twClg4EzAnwnXaubxnqLyCjSL1L4ZKFd457L2dym
         Dz+b2+2ZravFu8pW3+4OFbdJeP9j//K+m2ZK7WZZxavShnSgdXWfYneI1IMX8Q8s11iK
         b9IM53rljhv3kbWcw6+wl0VYYRj8pp5JjGBLRzFBItTCJZFgZAlpThXwwFYXMppq9gA3
         cbZOXZXwzxw/u5PJ0Bc4bMDEXm1FZyCCfqi8NLWikI68vZ4elVDgCRCkhRJ3PJI7tFsg
         1+8Gr2XgjqwSo8toS3T1plTCBe5oe2XbrlRu0N8Vup53Z5SlfquuEQbptUSaZscIYZBt
         ct6w==
X-Gm-Message-State: APjAAAVUdW9S3m8G1+yLOX9P3k1hIxUqDv/WvvsHO9IT14ecaLo2ONuE
        ycHk3A0HMr0FdTAEPE3at5oM9Ou/GvKo
X-Google-Smtp-Source: APXvYqxBGB2djjbxfuFloBwlEqrpQuPjeGkUt4dRVDs6EOS8BdEBorETWbyKwbpHtdwR9cBDpJQCgtgjN2lY
X-Received: by 2002:a63:d20a:: with SMTP id a10mr33681152pgg.273.1579113819263;
 Wed, 15 Jan 2020 10:43:39 -0800 (PST)
Date:   Wed, 15 Jan 2020 10:43:06 -0800
In-Reply-To: <20200115184308.162644-1-brianvv@google.com>
Message-Id: <20200115184308.162644-8-brianvv@google.com>
Mime-Version: 1.0
References: <20200115184308.162644-1-brianvv@google.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v5 bpf-next 7/9] libbpf: add libbpf support to batch ops
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
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
 tools/lib/bpf/bpf.c      | 58 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/bpf.h      | 22 +++++++++++++++
 tools/lib/bpf/libbpf.map |  4 +++
 3 files changed, 84 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 500afe478e94a..317727d612149 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -452,6 +452,64 @@ int bpf_map_freeze(int fd)
 	return sys_bpf(BPF_MAP_FREEZE, &attr, sizeof(attr));
 }
 
+static int bpf_map_batch_common(int cmd, int fd, void  *in_batch,
+				void *out_batch, void *keys, void *values,
+				__u32 *count,
+				const struct bpf_map_batch_opts *opts)
+{
+	union bpf_attr attr = {};
+	int ret;
+
+	if (!OPTS_VALID(opts, bpf_map_batch_opts))
+		return -EINVAL;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.batch.map_fd = fd;
+	attr.batch.in_batch = ptr_to_u64(in_batch);
+	attr.batch.out_batch = ptr_to_u64(out_batch);
+	attr.batch.keys = ptr_to_u64(keys);
+	attr.batch.values = ptr_to_u64(values);
+	attr.batch.count = *count;
+	attr.batch.elem_flags  = OPTS_GET(opts, elem_flags, 0);
+	attr.batch.flags = OPTS_GET(opts, flags, 0);
+
+	ret = sys_bpf(cmd, &attr, sizeof(attr));
+	*count = attr.batch.count;
+
+	return ret;
+}
+
+int bpf_map_delete_batch(int fd, void *keys, __u32 *count,
+			 const struct bpf_map_batch_opts *opts)
+{
+	return bpf_map_batch_common(BPF_MAP_DELETE_BATCH, fd, NULL,
+				    NULL, keys, NULL, count, opts);
+}
+
+int bpf_map_lookup_batch(int fd, void *in_batch, void *out_batch, void *keys,
+			 void *values, __u32 *count,
+			 const struct bpf_map_batch_opts *opts)
+{
+	return bpf_map_batch_common(BPF_MAP_LOOKUP_BATCH, fd, in_batch,
+				    out_batch, keys, values, count, opts);
+}
+
+int bpf_map_lookup_and_delete_batch(int fd, void *in_batch, void *out_batch,
+				    void *keys, void *values, __u32 *count,
+				    const struct bpf_map_batch_opts *opts)
+{
+	return bpf_map_batch_common(BPF_MAP_LOOKUP_AND_DELETE_BATCH,
+				    fd, in_batch, out_batch, keys, values,
+				    count, opts);
+}
+
+int bpf_map_update_batch(int fd, void *keys, void *values, __u32 *count,
+			 const struct bpf_map_batch_opts *opts)
+{
+	return bpf_map_batch_common(BPF_MAP_UPDATE_BATCH, fd, NULL, NULL,
+				    keys, values, count, opts);
+}
+
 int bpf_obj_pin(int fd, const char *pathname)
 {
 	union bpf_attr attr;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 56341d117e5ba..b976e77316cca 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -127,6 +127,28 @@ LIBBPF_API int bpf_map_lookup_and_delete_elem(int fd, const void *key,
 LIBBPF_API int bpf_map_delete_elem(int fd, const void *key);
 LIBBPF_API int bpf_map_get_next_key(int fd, const void *key, void *next_key);
 LIBBPF_API int bpf_map_freeze(int fd);
+
+struct bpf_map_batch_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	__u64 elem_flags;
+	__u64 flags;
+};
+#define bpf_map_batch_opts__last_field flags
+
+LIBBPF_API int bpf_map_delete_batch(int fd, void *keys,
+				    __u32 *count,
+				    const struct bpf_map_batch_opts *opts);
+LIBBPF_API int bpf_map_lookup_batch(int fd, void *in_batch, void *out_batch,
+				    void *keys, void *values, __u32 *count,
+				    const struct bpf_map_batch_opts *opts);
+LIBBPF_API int bpf_map_lookup_and_delete_batch(int fd, void *in_batch,
+					void *out_batch, void *keys,
+					void *values, __u32 *count,
+					const struct bpf_map_batch_opts *opts);
+LIBBPF_API int bpf_map_update_batch(int fd, void *keys, void *values,
+				    __u32 *count,
+				    const struct bpf_map_batch_opts *opts);
+
 LIBBPF_API int bpf_obj_pin(int fd, const char *pathname);
 LIBBPF_API int bpf_obj_get(const char *pathname);
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index a19f04e6e3d96..1902a0fc6afcc 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -214,6 +214,10 @@ LIBBPF_0.0.7 {
 		btf_dump__emit_type_decl;
 		bpf_link__disconnect;
 		bpf_map__attach_struct_ops;
+		bpf_map_delete_batch;
+		bpf_map_lookup_and_delete_batch;
+		bpf_map_lookup_batch;
+		bpf_map_update_batch;
 		bpf_object__find_program_by_name;
 		bpf_object__attach_skeleton;
 		bpf_object__destroy_skeleton;
-- 
2.25.0.rc1.283.g88dfdc4193-goog

