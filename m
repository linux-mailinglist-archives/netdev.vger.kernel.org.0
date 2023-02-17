Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A2769A302
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 01:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjBQAmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 19:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjBQAmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 19:42:02 -0500
Received: from out-213.mta1.migadu.com (out-213.mta1.migadu.com [IPv6:2001:41d0:203:375::d5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449F354D1F
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 16:42:01 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676594519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BK4EIwclfy9b/MVDGKaCXh3czkS81PrYon1iQIiRpwc=;
        b=GU73UyrhtNDg/Ala8NLY7sXThPrHj4TDJ23rAyVbCMFyFOi3LWsMObWzJ4pI3OXb3LNgpS
        a+e+AOkR8SvPowx/GH4z+iziyRzY62sx0qgIjn212Pb8bojT4XpkIAeyaHFGzGSMygQ0f6
        hA/nEvufvKM89yCD6MSGKuQbyhlWbYc=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH bpf-next 1/4] bpf: Disable bh in bpf_test_run for xdp and tc prog
Date:   Thu, 16 Feb 2023 16:41:47 -0800
Message-Id: <20230217004150.2980689-2-martin.lau@linux.dev>
In-Reply-To: <20230217004150.2980689-1-martin.lau@linux.dev>
References: <20230217004150.2980689-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

Some of the bpf helpers require bh disabled. eg. The bpf_fib_lookup
helper that will be used in a latter selftest. In particular, it
calls ___neigh_lookup_noref that expects the bh disabled.

This patch disables bh before calling bpf_prog_run[_xdp], so
the testing prog can also use those helpers.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 net/bpf/test_run.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 1ab396a2b87f..982e81bba6cf 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -413,10 +413,12 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 	old_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 	do {
 		run_ctx.prog_item = &item;
+		local_bh_disable();
 		if (xdp)
 			*retval = bpf_prog_run_xdp(prog, ctx);
 		else
 			*retval = bpf_prog_run(prog, ctx);
+		local_bh_enable();
 	} while (bpf_test_timer_continue(&t, 1, repeat, &ret, time));
 	bpf_reset_run_ctx(old_ctx);
 	bpf_test_timer_leave(&t);
-- 
2.30.2

