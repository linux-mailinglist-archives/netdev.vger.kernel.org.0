Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1421FAD83
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgFPKGX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Jun 2020 06:06:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38973 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728187AbgFPKGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:06:21 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-KFQah0AnORS_9fv3r2C68w-1; Tue, 16 Jun 2020 06:06:11 -0400
X-MC-Unique: KFQah0AnORS_9fv3r2C68w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6B86151308;
        Tue, 16 Jun 2020 10:06:05 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F01225D9D5;
        Tue, 16 Jun 2020 10:05:59 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 09/11] bpf: Add d_path helper
Date:   Tue, 16 Jun 2020 12:05:10 +0200
Message-Id: <20200616100512.2168860-10-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-1-jolsa@kernel.org>
References: <20200616100512.2168860-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding d_path helper function that returns full path
for give 'struct path' object, which needs to be the
kernel BTF 'path' object.

The helper calls directly d_path function.

Updating also bpf.h tools uapi header and adding
'path' to bpf_helpers_doc.py script.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h            |  4 ++++
 include/uapi/linux/bpf.h       | 14 ++++++++++++-
 kernel/bpf/btf_ids.c           | 11 ++++++++++
 kernel/trace/bpf_trace.c       | 38 ++++++++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py     |  2 ++
 tools/include/uapi/linux/bpf.h | 14 ++++++++++++-
 6 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a94e85c2ec50..d35265b6c574 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1752,5 +1752,9 @@ extern int bpf_skb_output_btf_ids[];
 extern int bpf_seq_printf_btf_ids[];
 extern int bpf_seq_write_btf_ids[];
 extern int bpf_xdp_output_btf_ids[];
+extern int bpf_d_path_btf_ids[];
+
+extern int btf_whitelist_d_path[];
+extern int btf_whitelist_d_path_cnt;
 
 #endif /* _LINUX_BPF_H */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c65b374a5090..e308746b9344 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3252,6 +3252,17 @@ union bpf_attr {
  * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
  * 		is returned or the error code -EACCES in case the skb is not
  * 		subject to CHECKSUM_UNNECESSARY.
+ *
+ * int bpf_d_path(struct path *path, char *buf, u32 sz)
+ *	Description
+ *		Return full path for given 'struct path' object, which
+ *		needs to be the kernel BTF 'path' object. The path is
+ *		returned in buffer provided 'buf' of size 'sz'.
+ *
+ *	Return
+ *		length of returned string on success, or a negative
+ *		error in case of failure
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3389,7 +3400,8 @@ union bpf_attr {
 	FN(ringbuf_submit),		\
 	FN(ringbuf_discard),		\
 	FN(ringbuf_query),		\
-	FN(csum_level),
+	FN(csum_level),			\
+	FN(d_path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/btf_ids.c b/kernel/bpf/btf_ids.c
index d8d0df162f04..853c8fd59b06 100644
--- a/kernel/bpf/btf_ids.c
+++ b/kernel/bpf/btf_ids.c
@@ -13,3 +13,14 @@ BTF_ID(struct, seq_file)
 
 BTF_ID_LIST(bpf_xdp_output_btf_ids)
 BTF_ID(struct, xdp_buff)
+
+BTF_ID_LIST(bpf_d_path_btf_ids)
+BTF_ID(struct, path)
+
+BTF_WHITELIST_ENTRY(btf_whitelist_d_path)
+BTF_ID(func, vfs_truncate)
+BTF_ID(func, vfs_fallocate)
+BTF_ID(func, dentry_open)
+BTF_ID(func, vfs_getattr)
+BTF_ID(func, filp_close)
+BTF_WHITELIST_END(btf_whitelist_d_path)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index c1866d76041f..0ff5d8434d40 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1016,6 +1016,42 @@ static const struct bpf_func_proto bpf_send_signal_thread_proto = {
 	.arg1_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
+{
+	char *p = d_path(path, buf, sz - 1);
+	int len;
+
+	if (IS_ERR(p)) {
+		len = PTR_ERR(p);
+	} else {
+		len = strlen(p);
+		if (len && p != buf) {
+			memmove(buf, p, len);
+			buf[len] = 0;
+		}
+	}
+
+	return len;
+}
+
+static bool bpf_d_path_allowed(const struct bpf_prog *prog)
+{
+	return btf_whitelist_search(prog->aux->attach_btf_id,
+				    btf_whitelist_d_path,
+				    btf_whitelist_d_path_cnt);
+}
+
+static const struct bpf_func_proto bpf_d_path_proto = {
+	.func		= bpf_d_path,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE,
+	.btf_id		= bpf_d_path_btf_ids,
+	.allowed	= bpf_d_path_allowed,
+};
+
 const struct bpf_func_proto *
 bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1483,6 +1519,8 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return prog->expected_attach_type == BPF_TRACE_ITER ?
 		       &bpf_seq_write_proto :
 		       NULL;
+	case BPF_FUNC_d_path:
+		return &bpf_d_path_proto;
 	default:
 		return raw_tp_prog_func_proto(func_id, prog);
 	}
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 91fa668fa860..3161bf4ccee4 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -425,6 +425,7 @@ class PrinterHelpers(Printer):
             'struct __sk_buff',
             'struct sk_msg_md',
             'struct xdp_md',
+            'struct path',
     ]
     known_types = {
             '...',
@@ -458,6 +459,7 @@ class PrinterHelpers(Printer):
             'struct sockaddr',
             'struct tcphdr',
             'struct seq_file',
+            'struct path',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c65b374a5090..e308746b9344 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3252,6 +3252,17 @@ union bpf_attr {
  * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
  * 		is returned or the error code -EACCES in case the skb is not
  * 		subject to CHECKSUM_UNNECESSARY.
+ *
+ * int bpf_d_path(struct path *path, char *buf, u32 sz)
+ *	Description
+ *		Return full path for given 'struct path' object, which
+ *		needs to be the kernel BTF 'path' object. The path is
+ *		returned in buffer provided 'buf' of size 'sz'.
+ *
+ *	Return
+ *		length of returned string on success, or a negative
+ *		error in case of failure
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3389,7 +3400,8 @@ union bpf_attr {
 	FN(ringbuf_submit),		\
 	FN(ringbuf_discard),		\
 	FN(ringbuf_query),		\
-	FN(csum_level),
+	FN(csum_level),			\
+	FN(d_path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.25.4

