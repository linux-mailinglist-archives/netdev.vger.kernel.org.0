Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B0624CDFD
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgHUGa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgHUGa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 02:30:56 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE00BC061386
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 23:30:55 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id d9so659405qvl.10
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 23:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=t1ahybeSocYxG75mFEOjBUStE3/N8dMepfEKhYa+PgY=;
        b=N6pGa6uUQfVSX6lSk34Ndz7XM0iWnAthacC9zfJHhg/RhcgDq78jz6dqetSkTKI8fx
         1hjmd6co/CwJ++gl9kTgBFWAMjnwcbgnYkbI2cyxAcD/tOI3cokeyiTplznwH5EF8Fh2
         Flc1zjcQl60kc4U/8hLFi9Lc3mpJ7EqfUwhju48qmeRKu7Vvh925E/8LtI5obSVdxufd
         p9zH3W4hCESmZNo7VZqFvpLClT2QuqeBAvgdRBem51KT3iteCYaUMP8fYDREaNs2oLHI
         eLszLstRVI/KUH5G90O7VC2OSEXubYO/tro6JEI/flcTve+pMVzeube0jURHG+m5HTxY
         1YJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=t1ahybeSocYxG75mFEOjBUStE3/N8dMepfEKhYa+PgY=;
        b=kVz+T+rOJxIBqJjQOfV/LkHY5LjTDhrsyZkxZyTEmrzatDigymsfN26Fin5EjFo4Nz
         7EEXM0SRTIDkGSKgXfGVtLwDimj2EwD5Lm1hJp8qerPDkNNQCyPiW1C3BV7Lv2yAR47e
         i/tigQNaN2sxD6VeBj3DtvbKkm2otx8X3XM4NAKkynLAFBuhw6+U8m74gPN9D2JOXnhm
         OMVSC7b6INri7ze/FnVCtQ5pAgB66Fq1mJdX1ZtD+/BrTgsC/HfEg8qkUDPsfXrSYJGq
         UQiGQD82ffi2sB3spcYO/9LwAQl2QYOolOVQqRhW7+9+6u7MezZKQXhGTl8sXpKxtzvE
         SdmA==
X-Gm-Message-State: AOAM531iyth20j431ORWY3x17ojMofqmTYrcx5dnK15WAPUwZJ3PaWkG
        mWrcPj4ob4wNZne4XsPm06VH2nVPEg==
X-Google-Smtp-Source: ABdhPJysfSt3QWU2JgWJDoarnQbxJp0A96gYx030HqTPN0Gj4l6c13UQz9JiYt1rigEkHWmjo+sJNNwG3Q==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:15:13:f693:9fff:fef4:2449])
 (user=elver job=sendgmr) by 2002:a05:6214:140d:: with SMTP id
 n13mr1254243qvx.69.1597991452992; Thu, 20 Aug 2020 23:30:52 -0700 (PDT)
Date:   Fri, 21 Aug 2020 08:30:43 +0200
Message-Id: <20200821063043.1949509-1-elver@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH] random32: Use rcuidle variant for tracepoint
From:   Marco Elver <elver@google.com>
To:     elver@google.com
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With KCSAN enabled, prandom_u32() may be called from any context,
including idle CPUs.

Therefore, switch to using trace_prandom_u32_rcuidle(), to avoid various
issues due to recursion and lockdep warnings when KCSAN and tracing is
enabled.

Fixes: 94c7eb54c4b8 ("random32: add a tracepoint for prandom_u32()")
Link: https://lkml.kernel.org/r/20200820155923.3d5c4873@oasis.local.home
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Marco Elver <elver@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 lib/random32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/random32.c b/lib/random32.c
index 932345323af0..1c5607a411d4 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -83,7 +83,7 @@ u32 prandom_u32(void)
 	u32 res;
 
 	res = prandom_u32_state(state);
-	trace_prandom_u32(res);
+	trace_prandom_u32_rcuidle(res);
 	put_cpu_var(net_rand_state);
 
 	return res;
-- 
2.28.0.297.g1956fa8f8d-goog

