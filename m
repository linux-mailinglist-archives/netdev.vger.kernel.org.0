Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FEB6A016E
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 04:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbjBWDHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 22:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbjBWDHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 22:07:41 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B59E1C7EB;
        Wed, 22 Feb 2023 19:07:34 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id cp7-20020a17090afb8700b0023756229427so2355186pjb.1;
        Wed, 22 Feb 2023 19:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KOk3Vym9nGE4EgQZXZOKt2VRaxDq+MExRT/H8oWqXsA=;
        b=d1nRcOMo6yIKpcrRbqqqv+QPtNyQWvxSQqqMBKP2ny37CeD07zglmWqGMJMAw8QiFX
         dQqh9dz+n8W2uwZ+D4MJIIUJrDVLHJiPq2CcpUfaYam6CSr2FbweAMDcD7Jm3q7mmzLs
         qLxsakpfIAz61Nkr3XjipMWVYnn/SjFo2uHtu8f7sZMOCQfAIDMNBgWd4Py0tIU28Tiu
         1pdSZ2li4XPpoUgUzcjlhAwnDzHZa8Lx5hI3GKgip97nzigVdWZF4fPG25vekRTRoRg3
         Wa+yLaj9iuMGEgF3gGXL9W/q8+eRU90upqgKxX+2HSejNWYq/NpzyOaIZA/nE95tz8er
         +1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KOk3Vym9nGE4EgQZXZOKt2VRaxDq+MExRT/H8oWqXsA=;
        b=K3dUliHAtXElc8sE0RLDU02fUzHslPHOonfl/hpHx1QrI8YRnIYqy978GSGoSLCPk4
         C/mw9ae+siv9ValMR4vOMG1jIdNjcVw60HpnTG/USQNNGQLkNKO6xQewCZ8cbuXDr9J3
         VPXc+MUZLtQB+CIx3h8oaEgqlzOLDUKFtCCMrZKTF0sd6cOS+dRZW3lM7C3lUi6e2A9x
         loywtpcvxRZoApgWwHgQRW+rW69/NdXicYEodJ97RB7wOV91TMNDeLHolcurYuftDHAQ
         QhC0gqDcNEMkd7ImXuyRSAbE7YkCjEp+uUoHMgXNu+uWRWgi9Ap+wryyYZoR7+mw7qFE
         xFsw==
X-Gm-Message-State: AO0yUKUwBYCS1AY4zFf0S4jdRZ892dV9tVhaXwWkgJdvb9qbVM21AApI
        ba0IFl8A38nYmGZwrSYOdd0=
X-Google-Smtp-Source: AK7set9LdzR1HvwTHVh2xVTUYaFUb1VESgOT+j09s2VS1KbxN4yrzZA9CNMoFTXO6AXla4fUiHQoyQ==
X-Received: by 2002:a17:903:1cc:b0:19a:6b55:a453 with SMTP id e12-20020a17090301cc00b0019a6b55a453mr12460126plh.9.1677121653866;
        Wed, 22 Feb 2023 19:07:33 -0800 (PST)
Received: from localhost.localdomain ([2620:10d:c090:400::5:9cb3])
        by smtp.gmail.com with ESMTPSA id i4-20020a170902eb4400b0019a9436d2a0sm7155359pli.89.2023.02.22.19.07.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Feb 2023 19:07:33 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 3/4] selftests/bpf: Add a test case for kptr_rcu.
Date:   Wed, 22 Feb 2023 19:07:16 -0800
Message-Id: <20230223030717.58668-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230223030717.58668-1-alexei.starovoitov@gmail.com>
References: <20230223030717.58668-1-alexei.starovoitov@gmail.com>
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
 tools/testing/selftests/bpf/progs/map_kptr.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/map_kptr.c b/tools/testing/selftests/bpf/progs/map_kptr.c
index 4a7da6cb5800..539659ed75c5 100644
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
 
@@ -90,12 +91,23 @@ static void test_kptr_ref(struct map_value *v)
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
@@ -288,6 +300,8 @@ int test_map_kptr_ref2(struct __sk_buff *ctx)
 	if (p_st->cnt.refs.counter != 2)
 		return 6;
 
+	/* p_st is MEM_RCU, because we're in RCU CS */
+	bpf_kfunc_call_test_ref(p_st);
 	return 0;
 }
 
-- 
2.30.2

