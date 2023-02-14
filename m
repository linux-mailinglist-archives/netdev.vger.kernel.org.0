Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B63369721A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 00:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjBNXvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 18:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjBNXu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 18:50:57 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DDF28D3E;
        Tue, 14 Feb 2023 15:50:56 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id k13so18714254plg.0;
        Tue, 14 Feb 2023 15:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6qa9d0wjdZSzWDoohRD0RmplfddG8vBXNpncs00Cr04=;
        b=SSxDj+KYdwBbryAwpgvo3l9UngPoJA0w2EiDdxuvABtsldg5bjsPVWyKfI3hAR+hXN
         89ff6npUjQdzSSRukhbPkmQFgbApMstApL1e/SjCzjXJ6d37JkQjXSm6fSJmKQKLTiVg
         4WAB3KbgYCfFY5Tiy+AOAXfs8gj9FSdPevVuOQ034zRbHL1RJLKTWQXqJPDQ6RZRLY8V
         73xVoaoQ2qf9jneoYwucmYRAMB3aDhTEV2Hw4qlgyNWhSrjIpberOPw/g5Pd8xCWLl6e
         POKZEavlwkin/X5xPs5J7uNOLe3cTn2LunFCCKqypM2MRnWeeS1fnfwMBxZULBbIPmWD
         pXSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6qa9d0wjdZSzWDoohRD0RmplfddG8vBXNpncs00Cr04=;
        b=NPMsAVpxptU+C3Z1DYO1Dt+gtXy6VcdCb+SkcwxXL1WwJD8smRtFM9zLwUtSi8jc2X
         9yDaqfSwUvJb4rIMSCkopkN813ilhFQdfux0RwVA2MQ+5eF2SUw/TKNitSufLzyXCiqN
         dlE0FKv+m3zgupsT3j8Bg2FqwrhJ8/XvmiCVgV4dNlGgbVunV46Dic6KFXa0vBmpDI8+
         lCKzd69yGPIZEuYPW+yPkun3bbqKSJZZb6AWbQCe4NzhPkxSwI82ADSePE3JKiSEkGSR
         CPBBkfhDFI52ehY6ldxYmEPZ3+n8iAEsUbqOQJZoavMKzsjPfk76xZ4aRJwhvX2HYGCn
         YW7A==
X-Gm-Message-State: AO0yUKUCz6nfb6mNG9HTX6x5k6XzGeqvOYbRo8+juYoBNIonLA1YQh+S
        jgOCIjktRDFRQnTQPnK9YFw=
X-Google-Smtp-Source: AK7set8d/EqhdvJoFoynH7bAAXhCIVO2YlPCyDY64PxYjOPOWwZtGFItpnQx3AhT+m8yzyo+a+abxA==
X-Received: by 2002:a17:90b:4b41:b0:233:ebd4:301c with SMTP id mi1-20020a17090b4b4100b00233ebd4301cmr754343pjb.1.1676418655478;
        Tue, 14 Feb 2023 15:50:55 -0800 (PST)
Received: from localhost.localdomain ([2620:10d:c090:400::5:d0de])
        by smtp.gmail.com with ESMTPSA id kn14-20020a17090b480e00b00233d6547000sm87198pjb.54.2023.02.14.15.50.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Feb 2023 15:50:55 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next] selftests/bpf: Fix map_kptr test.
Date:   Tue, 14 Feb 2023 15:50:51 -0800
Message-Id: <20230214235051.22938-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
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

The compiler is optimizing out majority of unref_ptr read/writes, so the test
wasn't testing much. For example, one could delete '__kptr' tag from
'struct prog_test_ref_kfunc __kptr *unref_ptr;' and the test would still "pass".

Convert it to volatile stores. Confirmed by comparing bpf asm before/after.

Fixes: 2cbc469a6fc3 ("selftests/bpf: Add C tests for kptr")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/progs/map_kptr.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/map_kptr.c b/tools/testing/selftests/bpf/progs/map_kptr.c
index eb8217803493..228ec45365a8 100644
--- a/tools/testing/selftests/bpf/progs/map_kptr.c
+++ b/tools/testing/selftests/bpf/progs/map_kptr.c
@@ -62,21 +62,23 @@ extern struct prog_test_ref_kfunc *
 bpf_kfunc_call_test_kptr_get(struct prog_test_ref_kfunc **p, int a, int b) __ksym;
 extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
 
+#define WRITE_ONCE(x, val) ((*(volatile typeof(x) *) &(x)) = (val))
+
 static void test_kptr_unref(struct map_value *v)
 {
 	struct prog_test_ref_kfunc *p;
 
 	p = v->unref_ptr;
 	/* store untrusted_ptr_or_null_ */
-	v->unref_ptr = p;
+	WRITE_ONCE(v->unref_ptr, p);
 	if (!p)
 		return;
 	if (p->a + p->b > 100)
 		return;
 	/* store untrusted_ptr_ */
-	v->unref_ptr = p;
+	WRITE_ONCE(v->unref_ptr, p);
 	/* store NULL */
-	v->unref_ptr = NULL;
+	WRITE_ONCE(v->unref_ptr, NULL);
 }
 
 static void test_kptr_ref(struct map_value *v)
@@ -85,7 +87,7 @@ static void test_kptr_ref(struct map_value *v)
 
 	p = v->ref_ptr;
 	/* store ptr_or_null_ */
-	v->unref_ptr = p;
+	WRITE_ONCE(v->unref_ptr, p);
 	if (!p)
 		return;
 	if (p->a + p->b > 100)
@@ -99,7 +101,7 @@ static void test_kptr_ref(struct map_value *v)
 		return;
 	}
 	/* store ptr_ */
-	v->unref_ptr = p;
+	WRITE_ONCE(v->unref_ptr, p);
 	bpf_kfunc_call_test_release(p);
 
 	p = bpf_kfunc_call_test_acquire(&(unsigned long){0});
-- 
2.30.2

