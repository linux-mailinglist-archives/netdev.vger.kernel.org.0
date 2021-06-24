Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDAE3B24F7
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 04:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhFXC14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFXC1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 22:27:48 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E07C06175F;
        Wed, 23 Jun 2021 19:25:29 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i4so2140222plt.12;
        Wed, 23 Jun 2021 19:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=61Zxou0shJyo7s954QoZWDRB4SKwIIim+C6QfK326Cg=;
        b=r7ek+O1+drk+sgcif5X3Xre7ZUJNjstnxZaxoEFdOSf+Kxb3bDLD+PqvuYNAuAdGL1
         A/zgTXL2q2lxVOm9y0/wcwjsowpzyACiBnutlBc3CoKWreDGwx/zFcie9f8f0JsZeWYo
         ViOwJgCKwxMrLBhF+KhM/rJ0bZ2tGW4OjGhokvwltuzf2j9toyMlnEp3e2U5Az5kWDaS
         s6kA/v6yRh82gebwmxWwFBqfOagojpdB0KOIl1y3vUS8jC6/oTFqiAt4JqRKsQg7kX2v
         FS1MFt9P9XVOs/3QT0z/L5IeCyCcHfJfbQWL/QpgGkqz++bNn266oevbyVg8BeQcRSqt
         scFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=61Zxou0shJyo7s954QoZWDRB4SKwIIim+C6QfK326Cg=;
        b=QlWKi/xQ2DdAl/LyIiyq3p3HbyJwQTziwTWVA/+45PGgfoGz7KCttp6X2FeJoNOgVN
         3a2RrHZSYsXGuXE9Es2oIJy07lf5Xmv40kDvrGilSTv+B4T1V7F6B+Elkx76nDldnDCo
         mED85I9mKCAozNvajgiLmYSrMIyIAwwGnCt4aZxaNKOMWZn87c0tKl4PTNTko53gnvCV
         kZ0nrKu0Rgf+YWqLLr/F+kgbf2arnCuljIw2DvU4dsYsGihI19VtGRjJ/RHzwEsuLHrA
         l+FHxZ8iBhZOwIxQpTglMUqUj8bcvIrNoNDOC1302Ru/RZOuVAssKGotz+ttHBN9nZZv
         IJyg==
X-Gm-Message-State: AOAM5308GGSZ+uV5FFWSQWnDYpIuIQeZIDuszeHXlRsj9mBAHJuSIam3
        o7h2zaNGXlTcDksKcROaQDc=
X-Google-Smtp-Source: ABdhPJwH3+tZ82MCupZ8p4rXCHCuNiKuj0GNtx+HasA34t3N1G1qTYghIRGrO1W0Rw+ymyTKn4+F9w==
X-Received: by 2002:a17:90a:a108:: with SMTP id s8mr12501742pjp.85.1624501528556;
        Wed, 23 Jun 2021 19:25:28 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:a319])
        by smtp.gmail.com with ESMTPSA id f17sm4675965pjj.21.2021.06.23.19.25.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jun 2021 19:25:28 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 4/8] bpf: Relax verifier recursion check.
Date:   Wed, 23 Jun 2021 19:25:14 -0700
Message-Id: <20210624022518.57875-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

In the following bpf subprogram:
static int timer_cb(void *map, void *key, void *value)
{
    bpf_timer_start(.., timer_cb, ..);
}

the 'timer_cb' is a pointer to a function.
ld_imm64 insn is used to carry this pointer.
bpf_pseudo_func() returns true for such ld_imm64 insn.

Unlike bpf_for_each_map_elem() the bpf_timer_start() callback is asynchronous.
Relax control flow check to allow such "recursion" that is seen as an infinite
loop by check_cfg(). The distinction between bpf_for_each_map_elem() the
bpf_timer_start() is done in the follow up patch.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7868481af61c..c88caec4ad28 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9387,8 +9387,12 @@ static int visit_func_call_insn(int t, int insn_cnt,
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

