Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727CC21BDC7
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 21:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgGJTiR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jul 2020 15:38:17 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46501 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728406AbgGJTiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 15:38:14 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-LPs1ADbxM-mLuTA1WtJ0Dg-1; Fri, 10 Jul 2020 15:38:10 -0400
X-MC-Unique: LPs1ADbxM-mLuTA1WtJ0Dg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A843F100CCC8;
        Fri, 10 Jul 2020 19:38:08 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 403AA100EBA9;
        Fri, 10 Jul 2020 19:38:07 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v6 bpf-next 6/9] bpf: Use BTF_ID to resolve bpf_ctx_convert struct
Date:   Fri, 10 Jul 2020 21:37:51 +0200
Message-Id: <20200710193754.3821104-7-jolsa@kernel.org>
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

This way the ID is resolved during compile time,
and we can remove the runtime name search.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/btf.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 71140b73ae3c..a710e3ee1f18 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -18,6 +18,7 @@
 #include <linux/sort.h>
 #include <linux/bpf_verifier.h>
 #include <linux/btf.h>
+#include <linux/btf_ids.h>
 #include <linux/skmsg.h>
 #include <linux/perf_event.h>
 #include <net/sock.h>
@@ -3621,12 +3622,15 @@ static int btf_translate_to_vmlinux(struct bpf_verifier_log *log,
 	return kern_ctx_type->type;
 }
 
+BTF_ID_LIST(bpf_ctx_convert_btf_id)
+BTF_ID(struct, bpf_ctx_convert)
+
 struct btf *btf_parse_vmlinux(void)
 {
 	struct btf_verifier_env *env = NULL;
 	struct bpf_verifier_log *log;
 	struct btf *btf = NULL;
-	int err, btf_id;
+	int err;
 
 	env = kzalloc(sizeof(*env), GFP_KERNEL | __GFP_NOWARN);
 	if (!env)
@@ -3659,14 +3663,8 @@ struct btf *btf_parse_vmlinux(void)
 	if (err)
 		goto errout;
 
-	/* find struct bpf_ctx_convert for type checking later */
-	btf_id = btf_find_by_name_kind(btf, "bpf_ctx_convert", BTF_KIND_STRUCT);
-	if (btf_id < 0) {
-		err = btf_id;
-		goto errout;
-	}
 	/* btf_parse_vmlinux() runs under bpf_verifier_lock */
-	bpf_ctx_convert.t = btf_type_by_id(btf, btf_id);
+	bpf_ctx_convert.t = btf_type_by_id(btf, bpf_ctx_convert_btf_id[0]);
 
 	/* find bpf map structs for map_ptr access checking */
 	err = btf_vmlinux_map_ids_init(btf, log);
-- 
2.25.4

