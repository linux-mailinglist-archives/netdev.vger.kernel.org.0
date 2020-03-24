Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B427191D8E
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgCXXb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:31:26 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:51793 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgCXXb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:31:26 -0400
Received: by mail-qk1-f202.google.com with SMTP id s130so86233qke.18
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 16:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PT/MWuZ7SA7hBzLYl9mF76R2EBAF0dWL8M0nfy7RbDQ=;
        b=mg3UefJ7KwGRwb4hGnrVu8LXiy0YBQAVa7mY95S3SyftRz3m7Fipk24W8qgT/viPFZ
         NhzWDfXainEC0FmsDKrYLf/xxEtqHVDO7ZljV9to3Cnhc+TFaehQcQwUXbIBsyyRFYEQ
         QiXkRPpoIcxG4E3Q/sMCn9j3EV/nf+uwDOHQdQ3OAmiZYrWNPMiEVruH6gQV8DLm4bYA
         WpbRH2PL83o6lFJ/MF+EtOYbQqCFf5ov/Xfm9p7rmNIsT3d3z9NyRD2BgkmhmQVjd07i
         hjIXVVWZ2S8Cgg4mni9NjjgmG7EfVnvjP3lIN3ZT4xtzo8K+1x9s4/goADBGlZhA4pis
         qogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PT/MWuZ7SA7hBzLYl9mF76R2EBAF0dWL8M0nfy7RbDQ=;
        b=jHWhm9LOOrp/kEt4iNTJQ8cLOILg26r/D2y3cfBxwuBmMR8ndtjYOO7WD2pS0x0bhL
         ss7aa+vEwYMuHxpqdU9J8PL4aNTl6t01n4tnuvWcNMAVAWoEXMkpoIYvJL+xdWqmSZP6
         uxjYUXd8H5Fdrwpnac+hCONF6E3WH15Z8Y4qKcPaodk2UGLNW0z3eYZAe1CdtpqtzPfs
         gA6OqoYuH0rqIg06m/1IFAnG33InolkmnVvcM+mWkVpm7Xwk4QrZT3QknhTk2mFm67AV
         NibQwyjZI6OpZ7t5rh3WplX/mgxn4fXN7YeDQesIiASsCfjktYqwVrb36tjYIzSRQioU
         Ag3g==
X-Gm-Message-State: ANhLgQ1CMaGirhoc0gMb6uGYXkhraE+kP1bZ8DE0IH9EsgGjhfSFgqqi
        1euuMv5XpEdJnDI17DFkG8hf0OfRtOUgNcC9IAqC3XK2rRRiAnCv58uvOPAvu3SFQzlmqjckRGO
        oZK1pl/Nc4MHFsWRoaHpzX+nmaiAKf0FYtkxehJNs8Yiq2/Ip2UDWNw==
X-Google-Smtp-Source: ADFU+vtkiV43eIQRaDiBUs88K/GD/IL0hk+zT61nUTYyMrs+9XCt43Vb1o34lp1v8hd7X9RLPtGTbvQ=
X-Received: by 2002:a0c:9aea:: with SMTP id k42mr628210qvf.91.1585092683800;
 Tue, 24 Mar 2020 16:31:23 -0700 (PDT)
Date:   Tue, 24 Mar 2020 16:31:20 -0700
Message-Id: <20200324233120.66314-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
Subject: [PATCH bpf-next] libbpf: don't allocate 16M for log buffer by default
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For each prog/btf load we allocate and free 16 megs of verifier buffer.
On production systems it doesn't really make sense because the
programs/btf have gone through extensive testing and (mostly) guaranteed
to successfully load.

Let's switch to a much smaller buffer by default (128 bytes, sys_bpf
doesn't accept smaller log buffer) and resize it if the kernel returns
ENOSPC. On the first ENOSPC error we resize the buffer to BPF_LOG_BUF_SIZE
and then, on each subsequent ENOSPC, we keep doubling the buffer.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/btf.c             | 10 +++++++++-
 tools/lib/bpf/libbpf.c          | 10 ++++++++--
 tools/lib/bpf/libbpf_internal.h |  2 ++
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 3d1c25fc97ae..53c7efc3b347 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -657,13 +657,14 @@ int btf__finalize_data(struct bpf_object *obj, struct btf *btf)
 
 int btf__load(struct btf *btf)
 {
-	__u32 log_buf_size = BPF_LOG_BUF_SIZE;
+	__u32 log_buf_size = BPF_MIN_LOG_BUF_SIZE;
 	char *log_buf = NULL;
 	int err = 0;
 
 	if (btf->fd >= 0)
 		return -EEXIST;
 
+retry_load:
 	log_buf = malloc(log_buf_size);
 	if (!log_buf)
 		return -ENOMEM;
@@ -673,6 +674,13 @@ int btf__load(struct btf *btf)
 	btf->fd = bpf_load_btf(btf->data, btf->data_size,
 			       log_buf, log_buf_size, false);
 	if (btf->fd < 0) {
+		if (errno == ENOSPC) {
+			log_buf_size = max((__u32)BPF_LOG_BUF_SIZE,
+					   log_buf_size << 1);
+			free(log_buf);
+			goto retry_load;
+		}
+
 		err = -errno;
 		pr_warn("Error loading BTF: %s(%d)\n", strerror(errno), errno);
 		if (*log_buf)
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 085e41f9b68e..793c81b35ccc 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4855,7 +4855,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 {
 	struct bpf_load_program_attr load_attr;
 	char *cp, errmsg[STRERR_BUFSIZE];
-	int log_buf_size = BPF_LOG_BUF_SIZE;
+	size_t log_buf_size = BPF_MIN_LOG_BUF_SIZE;
 	char *log_buf;
 	int btf_fd, ret;
 
@@ -4911,7 +4911,13 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	}
 
 	if (errno == ENOSPC) {
-		log_buf_size <<= 1;
+		if (errno == ENOSPC) {
+			log_buf_size = max((size_t)BPF_LOG_BUF_SIZE,
+					   log_buf_size << 1);
+			free(log_buf);
+			goto retry_load;
+		}
+
 		free(log_buf);
 		goto retry_load;
 	}
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 8c3afbd97747..2720f3366798 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -23,6 +23,8 @@
 #define BTF_PARAM_ENC(name, type) (name), (type)
 #define BTF_VAR_SECINFO_ENC(type, offset, size) (type), (offset), (size)
 
+#define BPF_MIN_LOG_BUF_SIZE 128
+
 #ifndef min
 # define min(x, y) ((x) < (y) ? (x) : (y))
 #endif
-- 
2.25.1.696.g5e7596f4ac-goog

