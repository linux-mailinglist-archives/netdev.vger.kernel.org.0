Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C01821BDC9
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 21:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgGJTiT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jul 2020 15:38:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49065 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728402AbgGJTiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 15:38:14 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-kzUhjEaDN-6g3bVtLVEAZw-1; Fri, 10 Jul 2020 15:38:11 -0400
X-MC-Unique: kzUhjEaDN-6g3bVtLVEAZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77217100CCC0;
        Fri, 10 Jul 2020 19:38:10 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F73D100EBA9;
        Fri, 10 Jul 2020 19:38:08 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v6 bpf-next 7/9] bpf: Add info about .BTF_ids section to btf.rst
Date:   Fri, 10 Jul 2020 21:37:52 +0200
Message-Id: <20200710193754.3821104-8-jolsa@kernel.org>
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

Updating btf.rst doc with info about .BTF_ids section

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Documentation/bpf/btf.rst | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
index 4d565d202ce3..c9dec7a565e8 100644
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
+The ``int list[];`` variable is defined to access the list.
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

