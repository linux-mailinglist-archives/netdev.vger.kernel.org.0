Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5857C19AA7C
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732437AbgDALJ2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Apr 2020 07:09:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54367 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732352AbgDALJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 07:09:27 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-dM95Zu_jML2EgRodxeAK9w-1; Wed, 01 Apr 2020 07:09:23 -0400
X-MC-Unique: dM95Zu_jML2EgRodxeAK9w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EB6418A5500;
        Wed,  1 Apr 2020 11:09:21 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.194.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8427C10027AF;
        Wed,  1 Apr 2020 11:09:16 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/3] bpf: Add d_path helper
Date:   Wed,  1 Apr 2020 13:09:06 +0200
Message-Id: <20200401110907.2669564-3-jolsa@kernel.org>
In-Reply-To: <20200401110907.2669564-1-jolsa@kernel.org>
References: <20200401110907.2669564-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
 include/uapi/linux/bpf.h       | 14 +++++++++++++-
 kernel/trace/bpf_trace.c       | 31 +++++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py     |  2 ++
 tools/include/uapi/linux/bpf.h | 14 +++++++++++++-
 4 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2e29a671d67e..8da1b4750364 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3025,6 +3025,17 @@ union bpf_attr {
  *		* **-EOPNOTSUPP**	Unsupported operation, for example a
  *					call from outside of TC ingress.
  *		* **-ESOCKTNOSUPPORT**	Socket type not supported (reuseport).
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
@@ -3151,7 +3162,8 @@ union bpf_attr {
 	FN(xdp_output),			\
 	FN(get_netns_cookie),		\
 	FN(get_current_ancestor_cgroup_id),	\
-	FN(sk_assign),
+	FN(sk_assign),			\
+	FN(d_path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1796747a77..6ca390b2b26e 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -779,6 +779,35 @@ static const struct bpf_func_proto bpf_send_signal_thread_proto = {
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
+static u32 bpf_d_path_btf_ids[3];
+static const struct bpf_func_proto bpf_d_path_proto = {
+	.func		= bpf_d_path,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE,
+	.btf_id		= bpf_d_path_btf_ids,
+};
+
 const struct bpf_func_proto *
 bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1224,6 +1253,8 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_xdp_output:
 		return &bpf_xdp_output_proto;
 #endif
+	case BPF_FUNC_d_path:
+		return &bpf_d_path_proto;
 	default:
 		return raw_tp_prog_func_proto(func_id, prog);
 	}
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index f43d193aff3a..8f62cbc4c3ff 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -418,6 +418,7 @@ class PrinterHelpers(Printer):
             'struct __sk_buff',
             'struct sk_msg_md',
             'struct xdp_md',
+            'struct path',
     ]
     known_types = {
             '...',
@@ -450,6 +451,7 @@ class PrinterHelpers(Printer):
             'struct sk_reuseport_md',
             'struct sockaddr',
             'struct tcphdr',
+            'struct path',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 2e29a671d67e..8da1b4750364 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3025,6 +3025,17 @@ union bpf_attr {
  *		* **-EOPNOTSUPP**	Unsupported operation, for example a
  *					call from outside of TC ingress.
  *		* **-ESOCKTNOSUPPORT**	Socket type not supported (reuseport).
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
@@ -3151,7 +3162,8 @@ union bpf_attr {
 	FN(xdp_output),			\
 	FN(get_netns_cookie),		\
 	FN(get_current_ancestor_cgroup_id),	\
-	FN(sk_assign),
+	FN(sk_assign),			\
+	FN(d_path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.25.2

