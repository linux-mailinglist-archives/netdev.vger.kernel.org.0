Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD956A9020
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 05:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjCCEPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 23:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCCEPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 23:15:16 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E75427D69;
        Thu,  2 Mar 2023 20:15:11 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id oj5so1274073pjb.5;
        Thu, 02 Mar 2023 20:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AOx3lpduGPYUuMFsH8k9SiSIZAva0zjTgRzjnqfpx2M=;
        b=TkHbgkAyeitX1ER2NHOdXtqrA3Og4puMoi2Or4mef6KGnjcc74yAqazKrLmmLYQL7W
         2bNyKPfG5+rF7DMJXjyUtv4FnmHiOxKoqs54qx6zLMyxNlqz+OYXJODLi7viiQrrMcAT
         c8jMR+rGTC+QWx2eO+2yhrbtf39l8WOxb/7SQmuDSjjZYQjNG8QNuAoKIUUm0qZnCtQb
         FNmtZtPlgPifpbqVO/T7pzY94LcWG1TnMpoIa9sa7q/QkMMU4BJOyaOhWjYgu3T8x2xM
         rtWsRop5rxeHCeGYHdf1bFBVPWMoE/IVCAn5SRCKmAbGCJylP6VJSZh+I6LUZfsg1El7
         cL6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AOx3lpduGPYUuMFsH8k9SiSIZAva0zjTgRzjnqfpx2M=;
        b=p0lKCyuu+y4OGo+ug3fyFiaXCTTV0x2XEqp7LIL0pEoZcOHFmtWEJTy0dBc/7k8HpA
         pbq8zDU3oM+HPWjJhKJ6RtxsXRfApDkDLnO3qCr5VaDgSj7SCr8FexE303R+KsyzJZLt
         Fw1dNy98/qqoAmiSQzVCYVtZMpQio15BD+dEUrWxVw16ES7g3AoTih0seuSRnwrPhXDO
         sSSw4ri02QKmYFshevryoaBdBhaC/HzBQkkawAyZc0yKROC4Ov5tfdxPiBuRixlwTmft
         6itMrDGpBl41SMbMSJEH5XgsH6hnyJXv8UZXXV90ZCkWYwCK9fNgMUiAMEHHz58zzkZk
         2OJg==
X-Gm-Message-State: AO0yUKWAcKOGynUTRdOrtTHer6qd52QrESsTOh0eH7eLeZ01eKm6umeD
        jNBWtzDG+Px5g7FqTzWy4ag=
X-Google-Smtp-Source: AK7set8U57A2P2zUEEQRB5HkZvJV4zRn28Mg0V8FNxBCe4wtAvj3dfnuxP0PKbP0/81M3E40CnoHxg==
X-Received: by 2002:a17:902:d34a:b0:19d:297:f2fb with SMTP id l10-20020a170902d34a00b0019d0297f2fbmr522539plk.53.1677816910801;
        Thu, 02 Mar 2023 20:15:10 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:5ad7])
        by smtp.gmail.com with ESMTPSA id li11-20020a170903294b00b0017a032d7ae4sm437861plb.104.2023.03.02.20.15.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Mar 2023 20:15:10 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v5 bpf-next 5/6] selftests/bpf: Tweak cgroup kfunc test.
Date:   Thu,  2 Mar 2023 20:14:45 -0800
Message-Id: <20230303041446.3630-6-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230303041446.3630-1-alexei.starovoitov@gmail.com>
References: <20230303041446.3630-1-alexei.starovoitov@gmail.com>
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
Acked-by: David Vernet <void@manifault.com>
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
2.30.2

