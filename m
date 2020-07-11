Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FA921C687
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 23:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgGKVxv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 11 Jul 2020 17:53:51 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33924 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728180AbgGKVxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 17:53:49 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-wwaWyGBKMPutCB8ThLphvA-1; Sat, 11 Jul 2020 17:53:46 -0400
X-MC-Unique: wwaWyGBKMPutCB8ThLphvA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DC021083;
        Sat, 11 Jul 2020 21:53:45 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C85FE60BEC;
        Sat, 11 Jul 2020 21:53:43 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v7 bpf-next 7/9] bpf: Add info about .BTF_ids section to btf.rst
Date:   Sat, 11 Jul 2020 23:53:27 +0200
Message-Id: <20200711215329.41165-8-jolsa@kernel.org>
In-Reply-To: <20200711215329.41165-1-jolsa@kernel.org>
References: <20200711215329.41165-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updating btf.rst doc with info about .BTF_ids section

Acked-by: Andrii Nakryiko <andriin@fb.com>
Tested-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Documentation/bpf/btf.rst | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
index 4d565d202ce3..b5361b8621c9 100644
--- a/Documentation/bpf/btf.rst
+++ b/Documentation/bpf/btf.rst
@@ -691,6 +691,42 @@ kernel API, the ``insn_off`` is the instruction offset in the unit of ``struct
 bpf_insn``. For ELF API, the ``insn_off`` is the byte offset from the
 beginning of section (``btf_ext_info_sec->sec_name_off``).
 
+4.2 .BTF_ids section
+====================
+
+The .BTF_ids section encodes BTF ID values that are used within the kernel.
+
+This section is created during the kernel compilation with the help of
+macros defined in ``include/linux/btf_ids.h`` header file. Kernel code can
+use them to create lists and sets (sorted lists) of BTF ID values.
+
+The ``BTF_ID_LIST`` and ``BTF_ID`` macros define unsorted list of BTF ID values,
+with following syntax::
+
+  BTF_ID_LIST(list)
+  BTF_ID(type1, name1)
+  BTF_ID(type2, name2)
+
+resulting in following layout in .BTF_ids section::
+
+  __BTF_ID__type1__name1__1:
+  .zero 4
+  __BTF_ID__type2__name2__2:
+  .zero 4
+
+The ``u32 list[];`` variable is defined to access the list.
+
+The ``BTF_ID_UNUSED`` macro defines 4 zero bytes. It's used when we
+want to define unused entry in BTF_ID_LIST, like::
+
+      BTF_ID_LIST(bpf_skb_output_btf_ids)
+      BTF_ID(struct, sk_buff)
+      BTF_ID_UNUSED
+      BTF_ID(struct, task_struct)
+
+All the BTF ID lists and sets are compiled in the .BTF_ids section and
+resolved during the linking phase of kernel build by ``resolve_btfids`` tool.
+
 5. Using BTF
 ************
 
-- 
2.25.4

