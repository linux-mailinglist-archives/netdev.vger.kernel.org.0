Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA79057B5D5
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240815AbiGTLrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240730AbiGTLrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:47:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6ACF872ED2
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658317619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xmw0qJN/J7YRsfD4NK6d4JdhY2WGiXTb+5lcFAP4Rtw=;
        b=W223zgZFV3kQfES1DCQfmPKzeUOTguIIE2DoHG87xZC8ct+gFTujdxawM7pMsR6AqPzddj
        mLLWIdYJD54ZYP8Zovldk7Vi8gJVxQbRmvmrRckbTFFpHvoMCAa4KiGTRaIhtffHc/XqV4
        /6ncnQF+YAkAAsTlJAQfvAnDiI58VZ0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-myivAjZ3NSicRo3ogUQlrg-1; Wed, 20 Jul 2022 07:46:56 -0400
X-MC-Unique: myivAjZ3NSicRo3ogUQlrg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 694631C0514E;
        Wed, 20 Jul 2022 11:46:55 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EFEC22166B29;
        Wed, 20 Jul 2022 11:46:54 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 0B7061C03BC; Wed, 20 Jul 2022 13:46:54 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next 4/4] bpf: export crash_kexec() as destructive kfunc
Date:   Wed, 20 Jul 2022 13:46:52 +0200
Message-Id: <20220720114652.3020467-5-asavkov@redhat.com>
In-Reply-To: <20220720114652.3020467-1-asavkov@redhat.com>
References: <20220720114652.3020467-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 kernel/kexec_core.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 4d34c78334ce4..a21fe8d326a8e 100644
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
@@ -1238,3 +1240,23 @@ void __weak arch_kexec_protect_crashkres(void)
 
 void __weak arch_kexec_unprotect_crashkres(void)
 {}
+
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+BTF_SET_START(kexec_btf_ids)
+BTF_ID(func, crash_kexec)
+BTF_SET_END(kexec_btf_ids)
+
+static const struct btf_kfunc_id_set kexec_kfunc_set = {
+	.owner			= THIS_MODULE,
+	.check_set		= &kexec_btf_ids,
+	.destructive_set	= &kexec_btf_ids,
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

