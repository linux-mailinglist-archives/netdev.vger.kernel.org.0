Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E08B257089
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 22:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgH3Unf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 16:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgH3Unc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 16:43:32 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AB0C061573;
        Sun, 30 Aug 2020 13:43:32 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id g6so1941111pjl.0;
        Sun, 30 Aug 2020 13:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Oh8xG+Ar04/HJQCkwoKYtEL7HKSwnJ6TRqdL3Jwg8HQ=;
        b=Ml8o1SnX7BEL7i6UAH7Y8PYeSWEExEPsUypvqIPd+vHZwlIYGVLRe4U2hq1tPOjs2q
         bdEjucShyp5BX9ZVnPyJIIA8cg9ELCR9EkLEygiMfSYbCqRl/EovEcYWLEtnekgi+6y9
         2ltsbEEjDbhVCwp2LjEpQLYOKuF0RHVoEx5FUHJPgKH7YLLjw/pkrqUpxN+thIiQUS1b
         iBSWKNLUvRzfmJf0B5OW9ksToqjls0MgpNXNbHpUApG9FhE49VrWlMHvzbQfg/VR+JfR
         tOXHDHIVpIQgZTcLda2gudlEt+mGu/3BsJ9zTDy+LGh/SgYFrARhLbGb54ATVC+B1Adb
         MLyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Oh8xG+Ar04/HJQCkwoKYtEL7HKSwnJ6TRqdL3Jwg8HQ=;
        b=WJvFrW87dUF2M5EIAsAsN8Yoa5xiZbHM16uoPXCVo1lWI2r2rLrDGTRYkZScG2FvOZ
         0Ijdmh4wbvty2UpuzGYdsBHBfVv6AIEyKpPNavO7XXr+CWo5OYiJnFKpD1mCMJsXDhxG
         aik8B0YSXT9X2w6/i/WRxYdBuYvuV32o8ZaDdHZwsLCfFfbG45Rql7E+2d+N6UYQofP1
         S4gnR7HqRLKUNhtSAGnGuCmlB7k9kbK6BL/Fjvn2sNgoSR/JITlUM9gG8kAgGMyuP4ek
         dmXHX9O6H/bomnvDSzpwBuqvzVt2T7LswaWhox6PLYEccDGIjzKKevOil+80d8SKVccz
         2xJg==
X-Gm-Message-State: AOAM531GnAYa1FVh3hhVCClPdACjS09irK2p3u4AzGIKat0+Op3Re6CY
        aEkjHwxkYQsx3kHNcF13CcefPFJdOFc=
X-Google-Smtp-Source: ABdhPJwcEFzT46B+n+Az+Bd/Mk4n257ugVML4JbyvkoL7868R/LhayvQfkwL0arr+7dRjiAZasriOQ==
X-Received: by 2002:a17:90b:1487:: with SMTP id js7mr1147343pjb.187.1598820211691;
        Sun, 30 Aug 2020 13:43:31 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id 72sm2025155pfx.79.2020.08.30.13.43.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Aug 2020 13:43:30 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, josef@toxicpanda.com, paulmck@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next] bpf: Fix build without BPF_SYSCALL, but with BPF_JIT.
Date:   Sun, 30 Aug 2020 13:43:28 -0700
Message-Id: <20200830204328.50419-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

When CONFIG_BPF_SYSCALL is not set, but CONFIG_BPF_JIT=y
the kernel build fails:
In file included from ../kernel/bpf/trampoline.c:11:
../kernel/bpf/trampoline.c: In function ‘bpf_trampoline_update’:
../kernel/bpf/trampoline.c:220:39: error: ‘call_rcu_tasks_trace’ undeclared
../kernel/bpf/trampoline.c: In function ‘__bpf_prog_enter_sleepable’:
../kernel/bpf/trampoline.c:411:2: error: implicit declaration of function ‘rcu_read_lock_trace’
../kernel/bpf/trampoline.c: In function ‘__bpf_prog_exit_sleepable’:
../kernel/bpf/trampoline.c:416:2: error: implicit declaration of function ‘rcu_read_unlock_trace’

Add these functions to rcupdate_trace.h.
The JIT won't call them and BPF trampoline logic won't be used without BPF_SYSCALL.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/rcupdate_trace.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/rcupdate_trace.h b/include/linux/rcupdate_trace.h
index d9015aac78c6..334840f4f245 100644
--- a/include/linux/rcupdate_trace.h
+++ b/include/linux/rcupdate_trace.h
@@ -82,7 +82,19 @@ static inline void rcu_read_unlock_trace(void)
 void call_rcu_tasks_trace(struct rcu_head *rhp, rcu_callback_t func);
 void synchronize_rcu_tasks_trace(void);
 void rcu_barrier_tasks_trace(void);
-
+#else
+static inline void call_rcu_tasks_trace(struct rcu_head *rhp, rcu_callback_t func)
+{
+	BUG();
+}
+static inline void rcu_read_lock_trace(void)
+{
+	BUG();
+}
+static inline void rcu_read_unlock_trace(void)
+{
+	BUG();
+}
 #endif /* #ifdef CONFIG_TASKS_TRACE_RCU */
 
 #endif /* __LINUX_RCUPDATE_TRACE_H */
-- 
2.23.0

