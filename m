Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653D05879A9
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 11:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbiHBJKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 05:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236146AbiHBJKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 05:10:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0505167E0
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 02:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659431437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TwBb9lEjHn3drMZDMM/zYMhet6xNvu6dn9eorLLxNfM=;
        b=U6sRuAIE2frv7dC4yJejAIJMIyMBI5YcF3PvW8VCboOgb099OQYO3fEd25MIH4wfubXOoy
        JNj/fhfYS0pUVl/T79t5w6Qh11x4Titzyn+G/KZvGknJ6ddjFgYpCt2RYrwYjzvA1o9xSw
        rnB36ObcnKRTxog11NSuFBIZpGf/16Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-Glkrt58cPx6Frhho0-hlzA-1; Tue, 02 Aug 2022 05:10:33 -0400
X-MC-Unique: Glkrt58cPx6Frhho0-hlzA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C87AA3802B82;
        Tue,  2 Aug 2022 09:10:32 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 86DD990A04;
        Tue,  2 Aug 2022 09:10:32 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 8C4521C0291; Tue,  2 Aug 2022 11:10:31 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next v2 2/3] bpf: export crash_kexec() as destructive kfunc
Date:   Tue,  2 Aug 2022 11:10:29 +0200
Message-Id: <20220802091030.3742334-3-asavkov@redhat.com>
In-Reply-To: <20220802091030.3742334-1-asavkov@redhat.com>
References: <20220802091030.3742334-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow properly marked bpf programs to call crash_kexec().

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 kernel/kexec_core.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 4d34c78334ce..9259ea3bd693 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -39,6 +39,8 @@
 #include <linux/hugetlb.h>
 #include <linux/objtool.h>
 #include <linux/kmsg_dump.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -1238,3 +1240,22 @@ void __weak arch_kexec_protect_crashkres(void)
 
 void __weak arch_kexec_unprotect_crashkres(void)
 {}
+
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+BTF_SET8_START(kexec_btf_ids)
+BTF_ID_FLAGS(func, crash_kexec, KF_DESTRUCTIVE)
+BTF_SET8_END(kexec_btf_ids)
+
+static const struct btf_kfunc_id_set kexec_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &kexec_btf_ids,
+};
+
+static int __init crash_kfunc_init(void)
+{
+	register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &kexec_kfunc_set);
+	return 0;
+}
+
+subsys_initcall(crash_kfunc_init);
+#endif
-- 
2.35.3

