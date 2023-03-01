Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22216A76DB
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 23:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCAWge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 17:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjCAWga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 17:36:30 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE978532A6;
        Wed,  1 Mar 2023 14:36:20 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id h8so12310357plf.10;
        Wed, 01 Mar 2023 14:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jvA1jHWUpzFqO2EmaliTkyRnfSesjl9+i1aVLilCcYU=;
        b=UesHPS2qZkquqXpk408/e1XQXErgSOFeWe1KFx8CrTAMGPMtbJ3FW1k6BIF5mwMFK7
         ZujMRsf12kGLiHq24p3RP9Y7Mp+BOtEyHj+HRrciN5gvY8u1Vts4mfotntE/eOr7PFu1
         emm83gz+uZRIQK+uAEMAIdK6xAb0i4CIlLulvHuhippf3vTgiEV/7lsQVmiWZMzSeMUv
         tIeeDxFch+AQ0yA5jMjGzPOp24cdBCivrD2Ai9rNXetoh8hHx+QfyppnCGPeTqwtYS3/
         cdpLiIEltjNJ8GNEmtEcJrAOSFO4qu4HM7B/uGQj0mH1Kkn0IL0XrCCbg+/ABw9dbimE
         lsgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jvA1jHWUpzFqO2EmaliTkyRnfSesjl9+i1aVLilCcYU=;
        b=PZ0q2fNBNhps+cG6Mbudp2HoXT42X9W63qEm5GyrFLlP7UlQIrOyasx0AO6jPzO7it
         CXnNHd3PDJxwFH6VnpApY5e0qxh3IKie7TIW8nNNCbPZfiCEnVwtLJK7ITLhWeeGF+dF
         +XHeCqhcOtCuP1cA49LvJ4G4I945z4/ZnwJ6fCdirCWvU5q8yqMWsIkk6lujRg6M6FP9
         ZiDnxDR4Fyp677pWGyM756ZjKriOmy4fZf+6myBomygBP07lK3J0jxjqEftJnhJpO5BW
         ldLQkgWUF15+uDhODPyLryY6EAVQzreYvgEjQQTkSPZBJiuRFKy6lBYLj5meZxLM1z5x
         Vy2w==
X-Gm-Message-State: AO0yUKXLNUvZOWsXZvYvagiavXSkz3DuA+jjhS3gjGpSsX0bTUMBYEse
        jI8+6S+7HTW9fNQmwc/r5TY=
X-Google-Smtp-Source: AK7set9KngYn5dmzBf6m4b5ovOooapXcZAHLH0c/e2X/q+2gHFxiLpuebNNPQyOBrgNyT4OWT6yaNg==
X-Received: by 2002:a17:903:11d0:b0:19c:e6c8:db16 with SMTP id q16-20020a17090311d000b0019ce6c8db16mr10260193plh.27.1677710179986;
        Wed, 01 Mar 2023 14:36:19 -0800 (PST)
Received: from localhost.localdomain ([2620:10d:c090:400::5:2f7d])
        by smtp.gmail.com with ESMTPSA id jj22-20020a170903049600b0019a75ea08e5sm8948648plb.33.2023.03.01.14.36.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Mar 2023 14:36:19 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v4 bpf-next 5/6] selftests/bpf: Tweak cgroup kfunc test.
Date:   Wed,  1 Mar 2023 14:35:54 -0800
Message-Id: <20230301223555.84824-6-alexei.starovoitov@gmail.com>
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

Adjust cgroup kfunc test to dereference RCU protected cgroup pointer
as PTR_TRUSTED and pass into KF_TRUSTED_ARGS kfunc.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../testing/selftests/bpf/progs/cgrp_kfunc_success.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c b/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
index 42e13aebdd62..030aff700084 100644
--- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
+++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
@@ -61,7 +61,7 @@ int BPF_PROG(test_cgrp_acquire_leave_in_map, struct cgroup *cgrp, const char *pa
 SEC("tp_btf/cgroup_mkdir")
 int BPF_PROG(test_cgrp_xchg_release, struct cgroup *cgrp, const char *path)
 {
-	struct cgroup *kptr;
+	struct cgroup *kptr, *cg;
 	struct __cgrps_kfunc_map_value *v;
 	long status;
 
@@ -80,6 +80,16 @@ int BPF_PROG(test_cgrp_xchg_release, struct cgroup *cgrp, const char *path)
 		return 0;
 	}
 
+	kptr = v->cgrp;
+	if (!kptr) {
+		err = 4;
+		return 0;
+	}
+
+	cg = bpf_cgroup_ancestor(kptr, 1);
+	if (cg)	/* verifier only check */
+		bpf_cgroup_release(cg);
+
 	kptr = bpf_kptr_xchg(&v->cgrp, NULL);
 	if (!kptr) {
 		err = 3;
-- 
2.39.2

