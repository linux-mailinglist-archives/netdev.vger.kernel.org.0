Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB8B5F09EF
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiI3LVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiI3LUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:20:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8595D62E0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 04:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664536147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yuN61Gt5Tj3D35BY+nm+KbCeM9+r4XKh89mhiWiDEcI=;
        b=P3yppJabblUuW5zmhJwBTwhNzOhZgFV/rHIck6rmbdxtgG3WwPuUkze8HsTsCGeUnaMaoz
        M45N+E5Gwfevh4++jaXOTVYLA168ZjguCyvYq/uvN4QM83dMJPpJ47OqGVcxF5N1sO4xQl
        1u96jcF3m/MkpTLCznnvuYTxF4BBnUQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-QD_MsY6sPgazuGx5UtEceA-1; Fri, 30 Sep 2022 07:09:04 -0400
X-MC-Unique: QD_MsY6sPgazuGx5UtEceA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A9EC8041B5;
        Fri, 30 Sep 2022 11:09:03 +0000 (UTC)
Received: from samus.usersys.redhat.com (unknown [10.43.17.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FC6D2024CB7;
        Fri, 30 Sep 2022 11:09:02 +0000 (UTC)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jbenc@redhat.com,
        Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next] selftests/bpf: make libbpf_probe_prog_types testcase aware of kernel configuration
Date:   Fri, 30 Sep 2022 13:09:00 +0200
Message-Id: <20220930110900.75492-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment libbpf_probe_prog_types test iterates over all available
BPF_PROG_TYPE regardless of kernel configuration which can exclude some
of those. Unfortunately there is no direct way to tell which types are
available, but we can look at struct bpf_ctx_onvert to tell which ones
are available.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 .../selftests/bpf/prog_tests/libbpf_probes.c  | 33 +++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/libbpf_probes.c b/tools/testing/selftests/bpf/prog_tests/libbpf_probes.c
index 9f766ddd946ab..753ddf79cf5e0 100644
--- a/tools/testing/selftests/bpf/prog_tests/libbpf_probes.c
+++ b/tools/testing/selftests/bpf/prog_tests/libbpf_probes.c
@@ -4,12 +4,29 @@
 #include <test_progs.h>
 #include <bpf/btf.h>
 
+static int find_type_in_ctx_convert(struct btf *btf,
+				    const char *prog_type_name,
+				    const struct btf_type *t)
+{
+	const struct btf_member *m;
+	size_t cmplen = strlen(prog_type_name);
+	int i, n;
+
+	for (m = btf_members(t), i = 0, n = btf_vlen(t); i < n; m++, i++) {
+		const char *member_name = btf__str_by_offset(btf, m->name_off);
+
+		if (!strncmp(prog_type_name, member_name, cmplen))
+			return 1;
+	}
+	return 0;
+}
+
 void test_libbpf_probe_prog_types(void)
 {
 	struct btf *btf;
-	const struct btf_type *t;
+	const struct btf_type *t, *context_convert_t;
 	const struct btf_enum *e;
-	int i, n, id;
+	int i, n, id, context_convert_id;
 
 	btf = btf__parse("/sys/kernel/btf/vmlinux", NULL);
 	if (!ASSERT_OK_PTR(btf, "btf_parse"))
@@ -23,6 +40,14 @@ void test_libbpf_probe_prog_types(void)
 	if (!ASSERT_OK_PTR(t, "bpf_prog_type_enum"))
 		goto cleanup;
 
+	context_convert_id = btf__find_by_name_kind(btf, "bpf_ctx_convert",
+						    BTF_KIND_STRUCT);
+	if (!ASSERT_GT(context_convert_id, 0, "bpf_ctx_convert_id"))
+		goto cleanup;
+	context_convert_t = btf__type_by_id(btf, context_convert_id);
+	if (!ASSERT_OK_PTR(t, "bpf_ctx_convert_type"))
+		goto cleanup;
+
 	for (e = btf_enum(t), i = 0, n = btf_vlen(t); i < n; e++, i++) {
 		const char *prog_type_name = btf__str_by_offset(btf, e->name_off);
 		enum bpf_prog_type prog_type = (enum bpf_prog_type)e->val;
@@ -31,6 +56,10 @@ void test_libbpf_probe_prog_types(void)
 		if (prog_type == BPF_PROG_TYPE_UNSPEC)
 			continue;
 
+		if (!find_type_in_ctx_convert(btf, prog_type_name,
+					      context_convert_t))
+			continue;
+
 		if (!test__start_subtest(prog_type_name))
 			continue;
 
-- 
2.37.3

