Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76D63EA794
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238115AbhHLPas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238055AbhHLPap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 11:30:45 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC45C0613D9
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 08:30:19 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 12-20020ac8570c0000b029029624d5a057so3394365qtw.12
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 08:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FKmBhBBmRifwAw1wud9HfRzter1UnR4c92xc+2b6/5s=;
        b=rYggVfve59E5l2FDPgU103fdU6dGEbIyX1IJmrjbutp2ueeWXsTlxMMgmjKTKLjEkU
         8JsKv+B0lzkMkVIRiPQBgcqZUq0sCgIF6S4yUSvI+gAmJeynz0HhZceseIhff9OOOLgq
         cygHt2ctYoa716ivGpuO8rCicHfyDoJYW8dlRnDXEGjl4oghw9cQqUIpffGj1z18txzi
         yWMH/FUQq///zwLHKeJ8WYF4/ckKMPiAuoDgnJW0YpEz0Hyc5jei54I9gBc6cNsppZ/0
         TF1OPc7T1e9yXx4Y96aKLIygPpqFru5aoTnC8gXnzL9pp69rTqD1kP5L9hLHCzRZcVor
         1RgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FKmBhBBmRifwAw1wud9HfRzter1UnR4c92xc+2b6/5s=;
        b=ZcUKNVq3ukEEc5l/4NqQUuKQSUGNqs/FWNdPICU7zm0Mmv26DA5LFEoIfY2GmQ0BBq
         sIFTXZFnTi2fXYpcOiC1crMVGBysPX30q5KkUYgqc1rpLvfhKuY31RmRuVRvKbhOWVDU
         v+0la5z7ZdH6K/7YYGl8ywZ53DbG/V7zT0mRXCZBNu8sV5UWU+6MkIF+Qi9z/EKLO1Eg
         I9BiSFW8LQ1qeJrt+lWgn91s+PUt+pWdjUS0O2/lsWxkNqKiRMZ78yDxcnasdnQvns7e
         zneq4TEkoreqArTdnNkmM+eZX0gQ6cYaXfp+T3UdyWk53sBwx4YQ1z7qWAMQy2pKsMFI
         9WbA==
X-Gm-Message-State: AOAM5313ozdCXS1lG5U10PTm/2mEolUP4fw6TQJJhh6CqKg1QC8eDQhu
        JeCb6r8yOSEA1zNnFwQO3Vb+0MoUMbl3HSaYgwyLem8CgH8D/Y6zQxE+PnuL8cQl8CD8CewqigN
        DAkB5XDJ6IriL+itkFUmaa1jn9fwI+74IP8eSyZ/kNaCzH/593gBpzg==
X-Google-Smtp-Source: ABdhPJyl20Z+uSrL5WekJdVuznMqlTbOmdP6c3tP7LTydERHeX7PQVn4yaU7xEawZH9kEzN2gTkEW/M=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:fa15:8621:e6d2:7ad4])
 (user=sdf job=sendgmr) by 2002:a0c:c441:: with SMTP id t1mr4375766qvi.25.1628782218847;
 Thu, 12 Aug 2021 08:30:18 -0700 (PDT)
Date:   Thu, 12 Aug 2021 08:30:11 -0700
In-Reply-To: <20210812153011.983006-1-sdf@google.com>
Message-Id: <20210812153011.983006-3-sdf@google.com>
Mime-Version: 1.0
References: <20210812153011.983006-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: verify bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT
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

