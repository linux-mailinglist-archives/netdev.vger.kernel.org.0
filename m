Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D42621BDC0
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 21:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgGJTiJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jul 2020 15:38:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24090 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728354AbgGJTiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 15:38:07 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-H_GURmi5O1aVilO0lgtFEg-1; Fri, 10 Jul 2020 15:38:04 -0400
X-MC-Unique: H_GURmi5O1aVilO0lgtFEg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47914100CCC8;
        Fri, 10 Jul 2020 19:38:03 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD0EA1002391;
        Fri, 10 Jul 2020 19:38:01 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v6 bpf-next 3/9] bpf: Add BTF_ID_LIST/BTF_ID/BTF_ID_UNUSED macros
Date:   Fri, 10 Jul 2020 21:37:48 +0200
Message-Id: <20200710193754.3821104-4-jolsa@kernel.org>
In-Reply-To: <20200710193754.3821104-1-jolsa@kernel.org>
References: <20200710193754.3821104-1-jolsa@kernel.org>
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

Adding support to generate .BTF_ids section that will hold BTF
ID lists for verifier.

Adding macros that will help to define lists of BTF ID values
placed in .BTF_ids section. They are initially filled with zeros
(during compilation) and resolved later during the linking phase
by resolve_btfids tool.

Following defines list of one BTF ID value:

  BTF_ID_LIST(bpf_skb_output_btf_ids)
  BTF_ID(struct, sk_buff)

It also defines following variable to access the list:

  extern u32 bpf_skb_output_btf_ids[];

The BTF_ID_UNUSED macro defines 4 zero bytes. It's used when we
want to define 'unused' entry in BTF_ID_LIST, like:

  BTF_ID_LIST(bpf_skb_output_btf_ids)
  BTF_ID(struct, sk_buff)
  BTF_ID_UNUSED
  BTF_ID(struct, task_struct)

Suggested-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/asm-generic/vmlinux.lds.h |  4 ++
 include/linux/btf_ids.h           | 87 +++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+)
 create mode 100644 include/linux/btf_ids.h

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
diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
new file mode 100644
index 000000000000..fe019774f8a7
--- /dev/null
+++ b/include/linux/btf_ids.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_BTF_IDS_H
+#define _LINUX_BTF_IDS_H
+
+#include <linux/compiler.h> /* for __PASTE */
+
+/*
+ * Following macros help to define lists of BTF IDs placed
+ * in .BTF_ids section. They are initially filled with zeros
+ * (during compilation) and resolved later during the
+ * linking phase by resolve_btfids tool.
+ *
+ * Any change in list layout must be reflected in resolve_btfids
+ * tool logic.
+ */
+
+#define BTF_IDS_SECTION ".BTF_ids"
+
+#define ____BTF_ID(symbol)				\
+asm(							\
+".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
+".local " #symbol " ;                          \n"	\
+".type  " #symbol ", @object;                  \n"	\
+".size  " #symbol ", 4;                        \n"	\
+#symbol ":                                     \n"	\
+".zero 4                                       \n"	\
+".popsection;                                  \n");
+
+#define __BTF_ID(symbol) \
+	____BTF_ID(symbol)
+
+#define __ID(prefix) \
+	__PASTE(prefix, __COUNTER__)
+
+/*
+ * The BTF_ID defines unique symbol for each ID pointing
+ * to 4 zero bytes.
+ */
+#define BTF_ID(prefix, name) \
+	__BTF_ID(__ID(__BTF_ID__##prefix##__##name##__))
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
+#define __BTF_ID_LIST(name)				\
+asm(							\
+".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
+".local " #name ";                             \n"	\
+#name ":;                                      \n"	\
+".popsection;                                  \n");	\
+
+#define BTF_ID_LIST(name)				\
+__BTF_ID_LIST(name)					\
+extern u32 name[];
+
+/*
+ * The BTF_ID_UNUSED macro defines 4 zero bytes.
+ * It's used when we want to define 'unused' entry
+ * in BTF_ID_LIST, like:
+ *
+ *   BTF_ID_LIST(bpf_skb_output_btf_ids)
+ *   BTF_ID(struct, sk_buff)
+ *   BTF_ID_UNUSED
+ *   BTF_ID(struct, task_struct)
+ */
+
+#define BTF_ID_UNUSED					\
+asm(							\
+".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
+".zero 4                                       \n"	\
+".popsection;                                  \n");
+
+
+#endif
-- 
2.25.4

