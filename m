Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD51243DF9
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 19:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgHMRGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 13:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgHMRGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 13:06:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DD3C061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 10:06:46 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d26so7487676yba.20
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 10:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=yfKufJQb9JsLPTurQyFuWcXtWP9BKtW1++KmwekwEII=;
        b=Ho7fKmwE0spqh8lO0Z/YVJ9H+YHxkkCNDY2F2dLYgB7+J0KNMAbZBsbPnEPxWPdyqw
         +BH+SyqM5Qs6mzod5lKggd5i8rQMuLYPh4OLlEYWTFOjwfQgWumchmafvUxbDAQKIzkE
         LXGnz5qT92goCFkmXav/yK8LJauFOwlYxwBvef60l2XDremUAB6jIAxNYWAbk21x0b5T
         CW+Q2ZOs5CJM9C5tjN0aKRWMuZiX4PFpXnw83wCMOLjZY7DSbg0Kz/RO+ZpAT+iLivFZ
         Vzjdj2aMXXe7WWK3SrDGT/NrUFdd4NLCufzK2bYI7CgznPBCVFgyY5WSIE8o21hr+xZO
         q3vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=yfKufJQb9JsLPTurQyFuWcXtWP9BKtW1++KmwekwEII=;
        b=qe/aoCK+ROSqPQvSwy6jn2JxoUTObz5FBP5bww+oKrIZHSky5j4Dh3g6Vd83An/tic
         ajhNxr//EnzopRDE3Z0JXxy/RrQXSeO3AhE/xbAE7Ilt5vOeecp/wcVU2oAtXmuPCAYJ
         /5drUUdBonKYdrg+zWskCgIkTTYJBo3Rd9i7v4vQEr8Slbv07674bGQPqgAbPCmbJaPY
         7r4pPNoZ5Lqrpzw9iOD9bCvJfGzB/jtQYWiVD2oGJWbfNyH7xg2Kdqj6lipYA6NC98Mk
         X3HJBMfBD/iGBj3juHeGMwLPGAScvI9iHGI644JoKLXjgAm2kxyGz7ryutgnexslA0dF
         tNJA==
X-Gm-Message-State: AOAM532so+/J5pY54aXxSmqrY8MHD3UFAhrDzfKKeSfOTZyWnM5H3Lzz
        3b4Pv3UdbPqhrIPDjKyDtKrkCf/syG6MlQ==
X-Google-Smtp-Source: ABdhPJxOiJG/MKHxpOu5t6gvXiZtZWAWHFE9WHngq1jmDi3NAb2hhjinxS0/glMDEtCiIXqd/mq2CqVQHShg6Q==
X-Received: by 2002:a25:ef50:: with SMTP id w16mr7901878ybm.140.1597338405859;
 Thu, 13 Aug 2020 10:06:45 -0700 (PDT)
Date:   Thu, 13 Aug 2020 10:06:43 -0700
Message-Id: <20200813170643.4031609-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net] random32: add a tracepoint for prandom_u32()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Sedat Dilek <sedat.dilek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There has been some heat around prandom_u32() lately, and some people
were wondering if there was a simple way to determine how often
it was used, before considering making it maybe 10 times more expensive.

This tracepoint exports the generated pseudo random value.

Tested:

perf list | grep prandom_u32
  random:prandom_u32                                 [Tracepoint event]

perf record -a [-g] [-C1] -e random:prandom_u32 sleep 1
[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 259.748 MB perf.data (924087 samples) ]

perf report --nochildren
    ...
    97.67%  ksoftirqd/1     [kernel.vmlinux]  [k] prandom_u32
            |
            ---prandom_u32
               prandom_u32
               |
               |--48.86%--tcp_v4_syn_recv_sock
               |          tcp_check_req
               |          tcp_v4_rcv
               |          ...
                --48.81%--tcp_conn_request
                          tcp_v4_conn_request
                          tcp_rcv_state_process
                          ...
perf script

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
---
According to MAINTAINERS, lib/random32.c is part of networking...

 include/trace/events/random.h | 17 +++++++++++++++++
 lib/random32.c                |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/include/trace/events/random.h b/include/trace/events/random.h
index 32c10a515e2d5438e8d620a0c2313aab5f849b2b..9570a10cb949b5792c4290ba8e82a077ac655069 100644
--- a/include/trace/events/random.h
+++ b/include/trace/events/random.h
@@ -307,6 +307,23 @@ TRACE_EVENT(urandom_read,
 		  __entry->pool_left, __entry->input_left)
 );
 
+TRACE_EVENT(prandom_u32,
+
+	TP_PROTO(unsigned int ret),
+
+	TP_ARGS(ret),
+
+	TP_STRUCT__entry(
+		__field(   unsigned int, ret)
+	),
+
+	TP_fast_assign(
+		__entry->ret = ret;
+	),
+
+	TP_printk("ret=%u" , __entry->ret)
+);
+
 #endif /* _TRACE_RANDOM_H */
 
 /* This part must be outside protection */
diff --git a/lib/random32.c b/lib/random32.c
index 3d749abb9e80d54d8e330e07fb8b773b7bec2b83..932345323af092a93fc2690b0ebbf4f7485ae4f3 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -39,6 +39,7 @@
 #include <linux/random.h>
 #include <linux/sched.h>
 #include <asm/unaligned.h>
+#include <trace/events/random.h>
 
 #ifdef CONFIG_RANDOM32_SELFTEST
 static void __init prandom_state_selftest(void);
@@ -82,6 +83,7 @@ u32 prandom_u32(void)
 	u32 res;
 
 	res = prandom_u32_state(state);
+	trace_prandom_u32(res);
 	put_cpu_var(net_rand_state);
 
 	return res;
-- 
2.28.0.220.ged08abb693-goog

