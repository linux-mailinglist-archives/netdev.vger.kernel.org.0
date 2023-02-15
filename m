Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA0C6976D8
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 08:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbjBOHAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 02:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbjBOG70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 01:59:26 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12B7166F0;
        Tue, 14 Feb 2023 22:58:35 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id h4so11536444pll.9;
        Tue, 14 Feb 2023 22:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=asOk41jGENEiElm2QYj9dpFUFvZDrO1L8FiGjQwrbcs=;
        b=Xcyn9jK+xZmrkBRX45B93toBrbG/nxgM/lnoLTkUxRt0NpW5vm/CSVj8nhWwKogfNw
         b9Twi3jssUlcmw3BXm10zyyPaZQ/xdQD1SXiY7TMBfa69GVqnnUs6HFT078auKsgy/a2
         Es4C855nc+0NV3M+oAz0CssgPzWiZA3i8x1g/j1aXYICBsw97Q/xywdw+gEJrch4sW/V
         F3a50q1FKnie0p/ObjcOMTzmpFBe5ZbT5JSxY5J++YojF2CWsarB4bRA/Jr0o3o6M33E
         dd3IZkiGzmlVATIlBmeAYlAQl4A4k5APoZEZ+CtJuiGNZeA61WWoNHYQ6/d3HY1g6TKi
         gStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=asOk41jGENEiElm2QYj9dpFUFvZDrO1L8FiGjQwrbcs=;
        b=WIz8q0wB6SSzJiRJuZwP+MRvE6sPUEYhWplb9Ldc2nlkpc7/8ij2PYU0sbeQNzhtuY
         86PlgFNnGEaq2onADOvn2DXulv8jUHkrajQSKdboN1SwBOunMnKID9yDAeZK+vUixzRq
         iK4ueb8CHsHK4KFFgk3Y8eUxzNU88BwqJCW0+ZZTd+OH+9DDYeSGzkUWD7Ji2zANadpA
         Y/TJVSBXu9M880q4ebUBI+4aQgNmRZ4hZfltfwabEnkx3xAOE7rjmM+nSZ/5pYUkLsBo
         wHjh1Omp5D4r60Ml8sFcuZMIgbfc3m0V/0wf9qF+extvnzNLERaUTHUf44FQGnE8T/GD
         58kw==
X-Gm-Message-State: AO0yUKWzoQXTobJB8SETOZ4y5nj4UBQIq7CjBU0ZuXXdP8kNIiXaTxPb
        xoasKfF24PzCWP+vsbYQXc42ksu+9/E=
X-Google-Smtp-Source: AK7set/xggSomJFbMRZyGNWDKMsEe/W6k5QKSByzdpFAbE8Ui5qD6IIV2EfMSLITRdOcZAP/GRG5Og==
X-Received: by 2002:a17:902:e74f:b0:199:12d5:5b97 with SMTP id p15-20020a170902e74f00b0019912d55b97mr2587406plf.12.1676444308213;
        Tue, 14 Feb 2023 22:58:28 -0800 (PST)
Received: from localhost.localdomain ([2620:10d:c090:400::5:d0de])
        by smtp.gmail.com with ESMTPSA id l3-20020a170903120300b00196053474a8sm11340791plh.53.2023.02.14.22.58.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Feb 2023 22:58:27 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 3/4] selftests/bpf: Add a test case for kptr_rcu.
Date:   Tue, 14 Feb 2023 22:58:11 -0800
Message-Id: <20230215065812.7551-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230215065812.7551-1-alexei.starovoitov@gmail.com>
References: <20230215065812.7551-1-alexei.starovoitov@gmail.com>
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
---
 tools/testing/selftests/bpf/progs/map_kptr.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/map_kptr.c b/tools/testing/selftests/bpf/progs/map_kptr.c
index 4a7da6cb5800..e705972985a7 100644
--- a/tools/testing/selftests/bpf/progs/map_kptr.c
+++ b/tools/testing/selftests/bpf/progs/map_kptr.c
@@ -5,7 +5,7 @@
 
 struct map_value {
 	struct prog_test_ref_kfunc __kptr_untrusted *unref_ptr;
-	struct prog_test_ref_kfunc __kptr *ref_ptr;
+	struct prog_test_ref_kfunc __kptr_rcu *ref_ptr;
 };
 
 struct array_map {
@@ -61,6 +61,7 @@ extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp
 extern struct prog_test_ref_kfunc *
 bpf_kfunc_call_test_kptr_get(struct prog_test_ref_kfunc **p, int a, int b) __ksym;
 extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
+void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p) __ksym;
 
 #define WRITE_ONCE(x, val) ((*(volatile typeof(x) *) &(x)) = (val))
 
@@ -90,12 +91,20 @@ static void test_kptr_ref(struct map_value *v)
 	WRITE_ONCE(v->unref_ptr, p);
 	if (!p)
 		return;
+	/*
+	 * p is trusted_ptr_prog_test_ref_kfunc
+	 * because bpf prog is non-sleepable and runs in RCU CS.
+	 * p can be passed to kfunc that requires KF_TRUSTED_ARGS
+	 */
+	bpf_kfunc_call_test_ref(p);
 	if (p->a + p->b > 100)
 		return;
 	/* store NULL */
 	p = bpf_kptr_xchg(&v->ref_ptr, NULL);
 	if (!p)
 		return;
+	/* p is trusted_ptr_prog_test_ref_kfunc */
+	bpf_kfunc_call_test_ref(p);
 	if (p->a + p->b > 100) {
 		bpf_kfunc_call_test_release(p);
 		return;
@@ -288,6 +297,8 @@ int test_map_kptr_ref2(struct __sk_buff *ctx)
 	if (p_st->cnt.refs.counter != 2)
 		return 6;
 
+	/* p_st is trusted, because we're in RCU CS */
+	bpf_kfunc_call_test_ref(p_st);
 	return 0;
 }
 
-- 
2.30.2

