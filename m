Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923D320A81C
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 00:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407497AbgFYWOG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 18:14:06 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30029 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407496AbgFYWOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 18:14:05 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-faoY__PJPGWrPQ7dxs7s0g-1; Thu, 25 Jun 2020 18:13:56 -0400
X-MC-Unique: faoY__PJPGWrPQ7dxs7s0g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8E91A0BEB;
        Thu, 25 Jun 2020 22:13:52 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70D9779303;
        Thu, 25 Jun 2020 22:13:49 +0000 (UTC)
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
Subject: [PATCH v4 bpf-next 10/14] bpf: Add d_path helper
Date:   Fri, 26 Jun 2020 00:13:00 +0200
Message-Id: <20200625221304.2817194-11-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-1-jolsa@kernel.org>
References: <20200625221304.2817194-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 include/uapi/linux/bpf.h       | 14 +++++++++-
 kernel/trace/bpf_trace.c       | 47 ++++++++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py     |  2 ++
 tools/include/uapi/linux/bpf.h | 14 +++++++++-
 4 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0cb8ec948816..23274c81f244 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3285,6 +3285,17 @@ union bpf_attr {
  *		Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
  *	Return
  *		*sk* if casting is valid, or NULL otherwise.
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
@@ -3427,7 +3438,8 @@ union bpf_attr {
 	FN(skc_to_tcp_sock),		\
 	FN(skc_to_tcp_timewait_sock),	\
 	FN(skc_to_tcp_request_sock),	\
-	FN(skc_to_udp6_sock),
+	FN(skc_to_udp6_sock),		\
+	FN(d_path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b124d468688c..6f31e21565b6 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1060,6 +1060,51 @@ static const struct bpf_func_proto bpf_send_signal_thread_proto = {
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
+BTF_SET_START(btf_whitelist_d_path)
+BTF_ID(func, vfs_truncate)
+BTF_ID(func, vfs_fallocate)
+BTF_ID(func, dentry_open)
+BTF_ID(func, vfs_getattr)
+BTF_ID(func, filp_close)
+BTF_SET_END(btf_whitelist_d_path)
+
+static bool bpf_d_path_allowed(const struct bpf_prog *prog)
+{
+	return btf_id_set_contains(&btf_whitelist_d_path, prog->aux->attach_btf_id);
+}
+
+BTF_ID_LIST(bpf_d_path_btf_ids)
+BTF_ID(struct, path)
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
@@ -1539,6 +1584,8 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return prog->expected_attach_type == BPF_TRACE_ITER ?
 		       &bpf_seq_write_proto :
 		       NULL;
+	case BPF_FUNC_d_path:
+		return &bpf_d_path_proto;
 	default:
 		return raw_tp_prog_func_proto(func_id, prog);
 	}
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 6bab40ff442e..bacc0a2856c7 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -430,6 +430,7 @@ class PrinterHelpers(Printer):
             'struct __sk_buff',
             'struct sk_msg_md',
             'struct xdp_md',
+            'struct path',
     ]
     known_types = {
             '...',
@@ -468,6 +469,7 @@ class PrinterHelpers(Printer):
             'struct tcp_timewait_sock',
             'struct tcp_request_sock',
             'struct udp6_sock',
+            'struct path',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 0cb8ec948816..23274c81f244 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3285,6 +3285,17 @@ union bpf_attr {
  *		Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
  *	Return
  *		*sk* if casting is valid, or NULL otherwise.
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
@@ -3427,7 +3438,8 @@ union bpf_attr {
 	FN(skc_to_tcp_sock),		\
 	FN(skc_to_tcp_timewait_sock),	\
 	FN(skc_to_tcp_request_sock),	\
-	FN(skc_to_udp6_sock),
+	FN(skc_to_udp6_sock),		\
+	FN(d_path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.25.4

