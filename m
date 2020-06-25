Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7020720A820
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 00:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407508AbgFYWOJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 18:14:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50364 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2407499AbgFYWOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 18:14:07 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-z_oPBcBxMi6pAFxeG6pQwg-1; Thu, 25 Jun 2020 18:13:58 -0400
X-MC-Unique: z_oPBcBxMi6pAFxeG6pQwg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 403431085947;
        Thu, 25 Jun 2020 22:13:56 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E10279C56;
        Thu, 25 Jun 2020 22:13:52 +0000 (UTC)
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
Subject: [PATCH v4 bpf-next 11/14] tools headers: Adopt verbatim copy of btf_ids.h from kernel sources
Date:   Fri, 26 Jun 2020 00:13:01 +0200
Message-Id: <20200625221304.2817194-12-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-1-jolsa@kernel.org>
References: <20200625221304.2817194-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

It will be needed by bpf selftest for resolve_btfids tool.

Also adding __PASTE macro as btf_ids.h dependency, which is
defined in:

  include/linux/compiler_types.h

but because tools/include do not have this header, I'm putting
the macro into linux/compiler.h header.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/include/linux/btf_ids.h  | 108 +++++++++++++++++++++++++++++++++
 tools/include/linux/compiler.h |   4 ++
 2 files changed, 112 insertions(+)
 create mode 100644 tools/include/linux/btf_ids.h

diff --git a/tools/include/linux/btf_ids.h b/tools/include/linux/btf_ids.h
new file mode 100644
index 000000000000..5eb8983ee0a0
--- /dev/null
+++ b/tools/include/linux/btf_ids.h
@@ -0,0 +1,108 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_BTF_IDS_H
+#define _LINUX_BTF_IDS_H 1
+
+#include <linux/compiler.h> /* for __PASTE */
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
+#define BTF_IDS_SECTION ".BTF.ids"
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
+extern int name[];
+
+struct btf_id_set {
+	u32 cnt;
+	u32 ids[];
+};
+
+/*
+ * The BTF_SET_START/END macros pair defines sorted list of
+ * BTF IDs plus its members count, with following layout:
+ *
+ * BTF_SET_START(list)
+ * BTF_ID(type1, name1)
+ * BTF_ID(type2, name2)
+ * BTF_SET_END(list)
+ *
+ * __BTF_ID__set__list:
+ * .zero 4
+ * list:
+ * __BTF_ID__type1__name1__3:
+ * .zero 4
+ * __BTF_ID__type2__name2__4:
+ * .zero 4
+ *
+ */
+#define BTF_SET_START(name)				\
+__BTF_ID_LIST(name)					\
+asm(							\
+".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
+".local __BTF_ID__set__" #name ";              \n"	\
+"__BTF_ID__set__" #name ":;                    \n"	\
+".zero 4                                       \n"	\
+".popsection;                                  \n");	\
+
+#define BTF_SET_END(name)				\
+asm(							\
+".pushsection " BTF_IDS_SECTION ",\"a\";      \n"	\
+".size __BTF_ID__set__" #name ", .-" #name "  \n"	\
+".popsection;                                 \n");	\
+extern struct btf_id_set name;
+
+#endif
diff --git a/tools/include/linux/compiler.h b/tools/include/linux/compiler.h
index 9f9002734e19..6eac24d44e81 100644
--- a/tools/include/linux/compiler.h
+++ b/tools/include/linux/compiler.h
@@ -201,4 +201,8 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 # define __fallthrough
 #endif
 
+/* Indirect macros required for expanded argument pasting, eg. __LINE__. */
+#define ___PASTE(a, b) a##b
+#define __PASTE(a, b) ___PASTE(a, b)
+
 #endif /* _TOOLS_LINUX_COMPILER_H */
-- 
2.25.4

