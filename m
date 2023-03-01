Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9191F6A76D9
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 23:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjCAWg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 17:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCAWgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 17:36:24 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FB255045;
        Wed,  1 Mar 2023 14:36:16 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p20so14397643plw.13;
        Wed, 01 Mar 2023 14:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EfRwdNNEi/2+7+6J8QxLfiLl6zVXmSw2KcnizOxBRSA=;
        b=F8HZ1ItSeQE+W4EwdHK4oVPA8q/hgehNoNcNfsmAa8oK70ugtVHQgVEEYfmsTKOexG
         cbmQavpyVEnTtVobRe10X91cLeBzvECNcI3wdtdtXa86FnKpF5MyEUq6Aep0lUm1wgTP
         XBTcc2TmZO6ZmvAB24iBqMGk2IRN8zxKImfON3KE/kfE3XqmXyrKkkJbRKzZQPSpTKuV
         2LFf5JFFbfYCSWUxVtBPO9C/6mVwKwtxae6bZ+8yyvSz1svnk2+GkZDQW/J2616FOiEq
         JgVTCC5J+c/wvTJc+6T9j/bqeKhy9YfeTiniCpv7UqaQim9fYq4aApBvjy/fu11JpPF3
         RbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EfRwdNNEi/2+7+6J8QxLfiLl6zVXmSw2KcnizOxBRSA=;
        b=joFlM4IXO+VH5GgY1k1N+3v777YV4LHoPkg4aE0TCQmLR3giAj4KzDBypc8IHiKqfJ
         HumMkmnC1cEucMrnFGzVSXlXS2ubbZWF+K/p3Fqcnje9p9Cib+PJmx7Un6DX0OCMgz/A
         bx+wXI+gb3bU3LN5k+EP5r5R36A8bUTcFcx23bHO/e7O9b6L/2BmZqjSKVswZaJbqOKB
         lKczZd1v6+kn8eP8EsPDg6ehatilZM94GOcQkj1Cfio4y4tOMgmoU/JYhPyT4rBlOmxa
         omzT/Y2LZlT6kfYwybWrNRu+GzFsRTxIPnmAwbCObU1FMGjVNNfOgr42ZEKYYb5lGaFN
         Qh5Q==
X-Gm-Message-State: AO0yUKVul5PR7fTVRxXO2EQJsFQu4xS9rCoQ36FlkKpGFsWf2ikwYbNM
        6cSiZxX55EKSJjW01Ta617I=
X-Google-Smtp-Source: AK7set+Qh9A9uWArFUsc4o8Y1zoanA5/xFTUfpQJUvpW44f4+4XRoRDdnDXnf8lBxfLqHyiGZ5iKDw==
X-Received: by 2002:a17:903:27d0:b0:19e:21d0:5b95 with SMTP id km16-20020a17090327d000b0019e21d05b95mr7066994plb.10.1677710175887;
        Wed, 01 Mar 2023 14:36:15 -0800 (PST)
Received: from localhost.localdomain ([2620:10d:c090:400::5:2f7d])
        by smtp.gmail.com with ESMTPSA id 1-20020a170902c24100b0019a8468cbe7sm8458465plg.224.2023.03.01.14.36.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Mar 2023 14:36:15 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v4 bpf-next 4/6] selftests/bpf: Add a test case for kptr_rcu.
Date:   Wed,  1 Mar 2023 14:35:53 -0800
Message-Id: <20230301223555.84824-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230301223555.84824-1-alexei.starovoitov@gmail.com>
References: <20230301223555.84824-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Tweak existing map_kptr test to check kptr_rcu.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: David Vernet <void@manifault.com>
---
 tools/testing/selftests/bpf/progs/map_kptr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/map_kptr.c b/tools/testing/selftests/bpf/progs/map_kptr.c
index 3fe7cde4cbfd..3903d30217b8 100644
--- a/tools/testing/selftests/bpf/progs/map_kptr.c
+++ b/tools/testing/selftests/bpf/progs/map_kptr.c
@@ -118,6 +118,7 @@ extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp
 extern struct prog_test_ref_kfunc *
 bpf_kfunc_call_test_kptr_get(struct prog_test_ref_kfunc **p, int a, int b) __ksym;
 extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
+void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p) __ksym;
 
 #define WRITE_ONCE(x, val) ((*(volatile typeof(x) *) &(x)) = (val))
 
@@ -147,12 +148,23 @@ static void test_kptr_ref(struct map_value *v)
 	WRITE_ONCE(v->unref_ptr, p);
 	if (!p)
 		return;
+	/*
+	 * p is rcu_ptr_prog_test_ref_kfunc,
+	 * because bpf prog is non-sleepable and runs in RCU CS.
+	 * p can be passed to kfunc that requires KF_RCU.
+	 */
+	bpf_kfunc_call_test_ref(p);
 	if (p->a + p->b > 100)
 		return;
 	/* store NULL */
 	p = bpf_kptr_xchg(&v->ref_ptr, NULL);
 	if (!p)
 		return;
+	/*
+	 * p is trusted_ptr_prog_test_ref_kfunc.
+	 * p can be passed to kfunc that requires KF_RCU.
+	 */
+	bpf_kfunc_call_test_ref(p);
 	if (p->a + p->b > 100) {
 		bpf_kfunc_call_test_release(p);
 		return;
-- 
2.39.2

