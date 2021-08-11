Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C923E9AED
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhHKW2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbhHKW2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 18:28:19 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3444BC0613D5
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 15:27:55 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id m22-20020a05622a1196b029026549e62339so2135311qtk.1
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 15:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FKmBhBBmRifwAw1wud9HfRzter1UnR4c92xc+2b6/5s=;
        b=KtorBMIjMc7PRX+Eu8q9UZfgz7ozjZS/YIQxhZ4KL2/4npw/Ogxow4rDpoky8ge4wv
         GshTjP/p/8DWUfc0HZ0Y+Y4ouTaLdunkIN62NhsetlQ3m6MJ94G9o87D9Bm22V193IzH
         31YGKStXfGLmoTo+khXW+88VsRbjHBxAuF4Hp96MM/EzVXEuHdn6gAuQm1Xj4tDdmueY
         0eXLXctdGi/e+K3LxI4858JIrEa+lnb5ywM5jMd8Nc73ZKL5CLgZ5957OdyDbR9PM6ET
         +9bc1Gpucb7t5QEBxooDyIXpHAWE27/4h1D5vXWwiab1J0GYLfyrygDL+Vvw+Rzf+jmn
         JzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FKmBhBBmRifwAw1wud9HfRzter1UnR4c92xc+2b6/5s=;
        b=Pea5eE8dbbYAgxK1jKE36vWmbYvBpT1wVu1oB2CUjmXo51Y3DB4DRAwV7OQaGh2UNK
         kOfp6KP7DMmJZkgglazTqV+rvJySRTswVJ13N3rNqRg8gUfaSzaPBaCG/Fmq9LUGr1Ep
         Re3wRHNrCmo7doTSLd/hV8eVqPwMdC8YFe/iRi8FyWxdnjrqKiXI/VMHDiSBfWEzPLVf
         I7NzgObi++o4DLkgGvQlyDu+cJsyF3+0UgTE0djRIVyF70b2AmODdlOl00wtEObBhqiY
         fkX0ZHlReVJoEE0n/U6458V/kg6qmBnrL6MhHTLq1Yu2STV0ZoehO2xmRfTbbx5aB4bM
         9+gQ==
X-Gm-Message-State: AOAM530jV3TXky8TcT5s4Zh+boFO07hoheSx+D5hqySd8xLwBtBp00hd
        sAdbEwUjo6GYWmnyuy4AE2BqhLC1ytD7FZVMddtxke+/L8CNlHAD0465kRjjGTUHmcCSbSFwgFm
        lNkD7FS/jv9cXDVi/H62A1pKZKJSo0em2k9zO5DTDq8XUt6ivQ1n4uA==
X-Google-Smtp-Source: ABdhPJwLgIPSwzO3YGooos4qruEZJUyvIjVnraAgI9++Ha844zvdXoIktyQ1NnwmY8hMo+rSbaGgx68=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:c78e:f5dc:8780:ed29])
 (user=sdf job=sendgmr) by 2002:a0c:a321:: with SMTP id u30mr846227qvu.57.1628720874259;
 Wed, 11 Aug 2021 15:27:54 -0700 (PDT)
Date:   Wed, 11 Aug 2021 15:27:47 -0700
In-Reply-To: <20210811222747.3041445-1-sdf@google.com>
Message-Id: <20210811222747.3041445-3-sdf@google.com>
Mime-Version: 1.0
References: <20210811222747.3041445-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH bpf-next 2/2] selftests/bpf: verify bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add verifier ctx test to call bpf_get_netns_cookie from
cgroup/setsockopt.

  #269/p pass ctx or null check, 1: ctx Did not run the program (not supported) OK
  #270/p pass ctx or null check, 2: null Did not run the program (not supported) OK
  #271/p pass ctx or null check, 3: 1 OK
  #272/p pass ctx or null check, 4: ctx - const OK
  #273/p pass ctx or null check, 5: null (connect) Did not run the program (not supported) OK
  #274/p pass ctx or null check, 6: null (bind) Did not run the program (not supported) OK
  #275/p pass ctx or null check, 7: ctx (bind) Did not run the program (not supported) OK
  #276/p pass ctx or null check, 8: null (bind) OK
  #277/p pass ctx or null check, 9: ctx (cgroup/setsockopt) Did not run the program (not supported) OK
  #278/p pass ctx or null check, 10: null (cgroup/setsockopt) Did not run the program (not supported) OK

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/verifier/ctx.c | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/ctx.c b/tools/testing/selftests/bpf/verifier/ctx.c
index 23080862aafd..3e7fdbf898b1 100644
--- a/tools/testing/selftests/bpf/verifier/ctx.c
+++ b/tools/testing/selftests/bpf/verifier/ctx.c
@@ -195,3 +195,28 @@
 	.result = REJECT,
 	.errstr = "R1 type=inv expected=ctx",
 },
+{
+	"pass ctx or null check, 9: ctx (cgroup/setsockopt)",
+	.insns = {
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+			     BPF_FUNC_get_netns_cookie),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SOCKOPT,
+	.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+	.result = ACCEPT,
+},
+{
+	"pass ctx or null check, 10: null (cgroup/setsockopt)",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_1, 0),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+			     BPF_FUNC_get_netns_cookie),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SOCKOPT,
+	.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
+	.result = ACCEPT,
+},
-- 
2.33.0.rc1.237.g0d66db33f3-goog

