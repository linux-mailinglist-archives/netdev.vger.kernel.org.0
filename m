Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF59A2AC44A
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbgKIS6H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Nov 2020 13:58:07 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:36221 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729451AbgKIS6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 13:58:05 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-dPqptwy7MQiaH7u9vZ87jQ-1; Mon, 09 Nov 2020 13:58:00 -0500
X-MC-Unique: dPqptwy7MQiaH7u9vZ87jQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 883A81074654;
        Mon,  9 Nov 2020 18:57:58 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E2FE7664C;
        Mon,  9 Nov 2020 18:57:55 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCHv5 bpf] bpf: Move iterator functions into special init section
Date:   Mon,  9 Nov 2020 19:57:54 +0100
Message-Id: <20201109185754.377373-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With upcoming changes to pahole, that change the way how and
which kernel functions are stored in BTF data, we need a way
to recognize iterator functions.

Iterator functions need to be in BTF data, but have no real
body and are currently placed in .init.text section, so they
are freed after kernel init and are filtered out of BTF data
because of that.

The solution is to place these functions under new section:
  .init.bpf.preserve_type

And add 2 new symbols to mark that area:
  __init_bpf_preserve_type_begin
  __init_bpf_preserve_type_end

The code in pahole responsible for picking up the functions will
be able to recognize functions from this section and add them to
the BTF data and filter out all other .init.text functions.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Suggested-by: Yonghong Song <yhs@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
v5 changes:
  - use "" in __section macro due to:
    33def8498fdde180 ("treewide: Convert macro and uses of __section(foo) to __section("foo")")
    [Arnaldo]

v4: https://lore.kernel.org/bpf/20201106222512.52454-1-jolsa@kernel.org/

 include/asm-generic/vmlinux.lds.h | 16 +++++++++++++++-
 include/linux/bpf.h               |  8 +++++++-
 include/linux/init.h              |  1 +
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b2b3d81b1535..f91029b3443b 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -685,8 +685,21 @@
 	.BTF_ids : AT(ADDR(.BTF_ids) - LOAD_OFFSET) {			\
 		*(.BTF_ids)						\
 	}
+
+/*
+ * .init.bpf.preserve_type
+ *
+ * This section store special BPF function and marks them
+ * with begin/end symbols pair for the sake of pahole tool.
+ */
+#define INIT_BPF_PRESERVE_TYPE						\
+	__init_bpf_preserve_type_begin = .;                             \
+	*(.init.bpf.preserve_type)                                      \
+	__init_bpf_preserve_type_end = .;				\
+	MEM_DISCARD(init.bpf.preserve_type)
 #else
 #define BTF
+#define INIT_BPF_PRESERVE_TYPE
 #endif
 
 /*
@@ -741,7 +754,8 @@
 #define INIT_TEXT							\
 	*(.init.text .init.text.*)					\
 	*(.text.startup)						\
-	MEM_DISCARD(init.text*)
+	MEM_DISCARD(init.text*)						\
+	INIT_BPF_PRESERVE_TYPE
 
 #define EXIT_DATA							\
 	*(.exit.data .exit.data.*)					\
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2b16bf48aab6..73e8ededde3e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1276,10 +1276,16 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
 
+#ifdef CONFIG_DEBUG_INFO_BTF
+#define BPF_INIT __init_bpf_preserve_type
+#else
+#define BPF_INIT __init
+#endif
+
 #define BPF_ITER_FUNC_PREFIX "bpf_iter_"
 #define DEFINE_BPF_ITER_FUNC(target, args...)			\
 	extern int bpf_iter_ ## target(args);			\
-	int __init bpf_iter_ ## target(args) { return 0; }
+	int BPF_INIT bpf_iter_ ## target(args) { return 0; }
 
 struct bpf_iter_aux_info {
 	struct bpf_map *map;
diff --git a/include/linux/init.h b/include/linux/init.h
index 7b53cb3092ee..a7c71e3b5f9a 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -52,6 +52,7 @@
 #define __initconst	__section(".init.rodata")
 #define __exitdata	__section(".exit.data")
 #define __exit_call	__used __section(".exitcall.exit")
+#define __init_bpf_preserve_type __section(".init.bpf.preserve_type")
 
 /*
  * modpost check for section mismatches during the kernel build.
-- 
2.26.2

