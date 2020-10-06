Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E452854DF
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 01:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgJFXRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 19:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJFXRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 19:17:10 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99C6C0613D3
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 16:17:09 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s4so157733pgk.17
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 16:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=VySQMLcpvwdaQwxN1j3WmXvvfiQlhoZC1gK89XJ/g5w=;
        b=SXgcLOEhtgtayhfk/lI0LBIgpNCwL5GxWEYnx5/x7x+FfcRLqVsVg43/aCmz81P61b
         uzmuYKxe0U3RIMMxcNfHKbnUQ4v+9/2KD4FyPA9HntrB32AbeZdxcd+s6ygX/YTiEs1i
         TwsXdL73ffPOef03BW4xzZsAZU4hckfJMwrWByq4/7bBS5fBLHdKaT/qbzaBA/qVZ34u
         QuuLT7mStF19IB+0oZimzsivfU89yKoLoxBTXQXDFqHBvhYA12vM2Feg/b5MoPEuFOPE
         tWjLdjxG+oVYL5iGo/NiASKkutdCTKO8tSoPzWc2X0AU5LTtwUT4Yj2H+m6r/W8Q9y/2
         fdbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=VySQMLcpvwdaQwxN1j3WmXvvfiQlhoZC1gK89XJ/g5w=;
        b=Zc9MeXcTeQU4NW/RKsWkMwK6wMFYLm5d6qe47DLIvfgmGyKd6xPl+GR4uG1wTLtXOv
         rLvE1pf9udxP0i42mjH/qshGBezju3XG4lbzNw/logAcVioE9AaXUhw0gp12N47e7QOA
         eCOCr4g1pfaFbNv9h82YkIAn9pCeL/+JxkJO64g8aVu0MWwhsk+nbvPsU8vB36K5+NXH
         XpX9swrKKc+Xks491ZviBqS1rujvBSHOAY7Ri9iS2SDmxZtPn/pFG9sjlQ5VXWxrVyOy
         1j3H8DyDM08ev688myxezfjM1lbW6Wnklk4uwpf+Pk4gOfPglZoByDUxu22A1Z9lwD+T
         0/9g==
X-Gm-Message-State: AOAM531Hjf0SB8WY7ivelP1SzrlsjRDgFhUd8h7kgJJpbocX72fw1and
        /RpwQUbDGrWVTjLoMoqNSRcNwm9owyxB0JkVQtl/CJbp6vwp+WVRc8lW4+bq3m6YzzZKp4C9wjb
        R2qJyGW22/6YY8R0ZKNXckzRMKdwfI+ShZ7DkI+EH4ZPwY8lPs0u6s+sFQnXmag==
X-Google-Smtp-Source: ABdhPJzTFN3yuwQqJWyMD96v7WuoK0hZd60QG8joPjfL/EAKrjL9X0KXv86U4SMONrsWCK0OBT1RHhjrNyQ=
Sender: "haoluo via sendgmr" <haoluo@haoluo.svl.corp.google.com>
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a17:90a:c706:: with SMTP id
 o6mr359030pjt.185.1602026229067; Tue, 06 Oct 2020 16:17:09 -0700 (PDT)
Date:   Tue,  6 Oct 2020 16:17:06 -0700
Message-Id: <20201006231706.2744579-1-haoluo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH] bpf: Fix test_verifier after introducing resolve_pseudo_ldimm64
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 4976b718c355 ("bpf: Introduce pseudo_btf_id") switched
the order of check_subprogs() and resolve_pseudo_ldimm() in
the verifier. Now an empty prog and the prog of a single
invalid ldimm expect to see the error "last insn is not an
exit or jmp" instead, because the check for subprogs comes
first. Fix the expection of the error message.

Tested:
 # ./test_verifier
 Summary: 1130 PASSED, 538 SKIPPED, 0 FAILED
 and the full set of bpf selftests.

Fixes: 4976b718c355 ("bpf: Introduce pseudo_btf_id")
Signed-off-by: Hao Luo <haoluo@google.com>
---
 tools/testing/selftests/bpf/verifier/basic.c    | 2 +-
 tools/testing/selftests/bpf/verifier/ld_imm64.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/basic.c b/tools/testing/selftests/bpf/verifier/basic.c
index b8d18642653a..de84f0d57082 100644
--- a/tools/testing/selftests/bpf/verifier/basic.c
+++ b/tools/testing/selftests/bpf/verifier/basic.c
@@ -2,7 +2,7 @@
 	"empty prog",
 	.insns = {
 	},
-	.errstr = "unknown opcode 00",
+	.errstr = "last insn is not an exit or jmp",
 	.result = REJECT,
 },
 {
diff --git a/tools/testing/selftests/bpf/verifier/ld_imm64.c b/tools/testing/selftests/bpf/verifier/ld_imm64.c
index 3856dba733e9..f300ba62edd0 100644
--- a/tools/testing/selftests/bpf/verifier/ld_imm64.c
+++ b/tools/testing/selftests/bpf/verifier/ld_imm64.c
@@ -55,7 +55,7 @@
 	.insns = {
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 0),
 	},
-	.errstr = "invalid bpf_ld_imm64 insn",
+	.errstr = "last insn is not an exit or jmp",
 	.result = REJECT,
 },
 {
-- 
2.28.0.806.g8561365e88-goog

