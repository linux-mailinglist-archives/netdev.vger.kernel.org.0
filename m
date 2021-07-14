Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2463C7AD9
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 03:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237301AbhGNBIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 21:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbhGNBI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 21:08:27 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C1FC0613F0;
        Tue, 13 Jul 2021 18:05:35 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id j9so412381pfc.5;
        Tue, 13 Jul 2021 18:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PDnPozsiQEH5D0xDZSajlCyRC9yDJg8xI1V4UhI3dBY=;
        b=XO0dtnFki4acpsE/hqLn02R79k4JRd3BzKT+scPL/FWafV0jR9gbzye1k/H82qE98O
         g/S1dLOZby4qwFu0hQ8uKMpBGll2agDm1A8ajeCNnFevnsMlfvty0swJuf1zkSdFRhfX
         Brflw6MjLYiK75Qir4vKKSuen+sn4y3minyrMFFd34wSCngYR98d2xd2/cpszC3LeJBW
         vvlHHRw3JFc+POhYpGnO7AMEm4SdXkPF0KKrDbY7R0PZ+xN5sdHFdg3JdBan8Y5z3OUE
         q5itdmuGtXhtmrtn4mspihPu1VCUJhKpLtAYn5D2vqJ7cDHFDx4Id3O0qEKU70taxhjr
         ggMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PDnPozsiQEH5D0xDZSajlCyRC9yDJg8xI1V4UhI3dBY=;
        b=pytdUolXtlWfCJh4NxGQ4jLfgL4kgjjOLi6aeDfdQl0Zwt7dJo7uDiU0OjW9t7YBwg
         EApAsX81JtcMDU6DTQzY6VzptyJGeWlb2FCfArjG2qMxAIu5uxWOqac8eWU1e/TwZ/8L
         2PSZafpY94nLiqpU6gab4cmN1UkhsqvW82XwhMtFXgaRlFuN9ILVUXSEdAsYDF7ynQ4G
         DeEjUZ37ludtwmzvqV19r9rJs2MO3WMTOSxhGyQeJqMcGFxzA5tzaiEU1glWQOFPTm6r
         FsVbZccTvMCKStpY7tPs2TAmPCyAax0T4j9PE5RmxaqdIK3mos0ejUQbggqvjIH4D+Zx
         U5Ew==
X-Gm-Message-State: AOAM532D6wF10Pdl+W9I310W31BjV8PNj/GHgdjLrvhxepap/dlqic+E
        bXuU0o/NzQ2TC3zS/HGivJo=
X-Google-Smtp-Source: ABdhPJxKUP3TiATY6VLEbBXIXuvKXfBp5kCPwBrZIiNKuJBk7+hEPK9I0iQl5/ONNFV0VsnhljCLAA==
X-Received: by 2002:a63:5904:: with SMTP id n4mr6771258pgb.176.1626224735169;
        Tue, 13 Jul 2021 18:05:35 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:10f1])
        by smtp.gmail.com with ESMTPSA id cx4sm4073560pjb.53.2021.07.13.18.05.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jul 2021 18:05:34 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v6 bpf-next 07/11] bpf: Relax verifier recursion check.
Date:   Tue, 13 Jul 2021 18:05:15 -0700
Message-Id: <20210714010519.37922-8-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
References: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

In the following bpf subprogram:
static int timer_cb(void *map, void *key, void *value)
{
    bpf_timer_set_callback(.., timer_cb);
}

the 'timer_cb' is a pointer to a function.
ld_imm64 insn is used to carry this pointer.
bpf_pseudo_func() returns true for such ld_imm64 insn.

Unlike bpf_for_each_map_elem() the bpf_timer_set_callback() is asynchronous.
Relax control flow check to allow such "recursion" that is seen as an infinite
loop by check_cfg(). The distinction between bpf_for_each_map_elem() the
bpf_timer_set_callback() is done in the follow up patch.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index cb393de3c818..1511f92b4cf4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9463,8 +9463,12 @@ static int visit_func_call_insn(int t, int insn_cnt,
 		init_explored_state(env, t + 1);
 	if (visit_callee) {
 		init_explored_state(env, t);
-		ret = push_insn(t, t + insns[t].imm + 1, BRANCH,
-				env, false);
+		ret = push_insn(t, t + insns[t].imm + 1, BRANCH, env,
+				/* It's ok to allow recursion from CFG point of
+				 * view. __check_func_call() will do the actual
+				 * check.
+				 */
+				bpf_pseudo_func(insns + t));
 	}
 	return ret;
 }
-- 
2.30.2

