Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C2B1FAD6C
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgFPKFo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Jun 2020 06:05:44 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49019 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728264AbgFPKFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:05:44 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-8mdyV8RgP5S6h5xXJWpPuw-1; Tue, 16 Jun 2020 06:05:38 -0400
X-MC-Unique: 8mdyV8RgP5S6h5xXJWpPuw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52A231083E88;
        Tue, 16 Jun 2020 10:05:35 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 488BA5D9DD;
        Tue, 16 Jun 2020 10:05:30 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
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
Subject: [PATCH 03/11] bpf: Add btf_ids object
Date:   Tue, 16 Jun 2020 12:05:04 +0200
Message-Id: <20200616100512.2168860-4-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-1-jolsa@kernel.org>
References: <20200616100512.2168860-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to generate .BTF_ids section that would
hold various BTF IDs list for verifier.

Adding macros help to define lists of BTF IDs placed in
.BTF_ids section. They are initially filled with zeros
(during compilation) and resolved later during the
linking phase by btfid tool.

Following defines list of one BTF ID that is accessible
within kernel code as bpf_skb_output_btf_ids array.

  extern int bpf_skb_output_btf_ids[];

  BTF_ID_LIST(bpf_skb_output_btf_ids)
  BTF_ID(struct, sk_buff)

Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/asm-generic/vmlinux.lds.h |  4 ++
 kernel/bpf/Makefile               |  2 +-
 kernel/bpf/btf_ids.c              |  3 ++
 kernel/bpf/btf_ids.h              | 70 +++++++++++++++++++++++++++++++
 4 files changed, 78 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/btf_ids.c
 create mode 100644 kernel/bpf/btf_ids.h

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index db600ef218d7..0be2ee265931 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -641,6 +641,10 @@
 		__start_BTF = .;					\
 		*(.BTF)							\
 		__stop_BTF = .;						\
+	}								\
+	. = ALIGN(4);							\
+	.BTF_ids : AT(ADDR(.BTF_ids) - LOAD_OFFSET) {			\
+		*(.BTF_ids)						\
 	}
 #else
 #define BTF
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 1131a921e1a6..21e4fc7c25ab 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list
 obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
 obj-$(CONFIG_BPF_SYSCALL) += disasm.o
 obj-$(CONFIG_BPF_JIT) += trampoline.o
-obj-$(CONFIG_BPF_SYSCALL) += btf.o
+obj-$(CONFIG_BPF_SYSCALL) += btf.o btf_ids.o
 obj-$(CONFIG_BPF_JIT) += dispatcher.o
 ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_BPF_SYSCALL) += devmap.o
diff --git a/kernel/bpf/btf_ids.c b/kernel/bpf/btf_ids.c
new file mode 100644
index 000000000000..e7f9d94ad293
--- /dev/null
+++ b/kernel/bpf/btf_ids.c
@@ -0,0 +1,3 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "btf_ids.h"
diff --git a/kernel/bpf/btf_ids.h b/kernel/bpf/btf_ids.h
new file mode 100644
index 000000000000..68aa5c38a37f
--- /dev/null
+++ b/kernel/bpf/btf_ids.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __BTF_IDS_H__
+#define __BTF_IDS_H__
+
+#include <linux/stringify.h>
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+
+
+/*
+ * Following macros help to define lists of BTF IDs placed
+ * in .BTF_ids section. They are initially filled with zeros
+ * (during compilation) and resolved later during the
+ * linking phase by btfid tool.
+ *
+ * Any change in list layout must be reflected in btfid
+ * tool logic.
+ */
+
+#define SECTION ".BTF_ids"
+
+#define ____BTF_ID(symbol)				\
+asm(							\
+".pushsection " SECTION ",\"a\";               \n"	\
+".local " #symbol " ;                          \n"	\
+".type  " #symbol ", @object;                  \n"	\
+".size  " #symbol ", 4;                        \n"	\
+#symbol ":                                     \n"	\
+".zero 4                                       \n"	\
+".popsection;                                  \n");
+
+#define __BTF_ID(...) \
+	____BTF_ID(__VA_ARGS__)
+
+#define __ID(prefix) \
+	__PASTE(prefix, __COUNTER__)
+
+
+/*
+ * The BTF_ID defines unique symbol for each ID pointing
+ * to 4 zero bytes.
+ */
+#define BTF_ID(prefix, name) \
+	__BTF_ID(__ID(__BTF_ID__##prefix##__##name##__))
+
+
+/*
+ * The BTF_ID_LIST macro defines pure (unsorted) list
+ * of BTF IDs, with following layout:
+ *
+ * BTF_ID_LIST(list1)
+ * BTF_ID(type1, name1)
+ * BTF_ID(type2, name2)
+ *
+ * list1:
+ * __BTF_ID__type1__name1__1:
+ * .zero 4
+ * __BTF_ID__type2__name2__2:
+ * .zero 4
+ *
+ */
+#define BTF_ID_LIST(name)				\
+asm(							\
+".pushsection " SECTION ",\"a\";               \n"	\
+".global " #name ";                            \n"	\
+#name ":;                                      \n"	\
+".popsection;                                  \n");
+
+#endif
-- 
2.25.4

