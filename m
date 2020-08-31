Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B390257E04
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgHaPv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbgHaPv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:51:58 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65078C061573;
        Mon, 31 Aug 2020 08:51:58 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ls14so1636pjb.3;
        Mon, 31 Aug 2020 08:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P+X307cfCvP+dK56x5pdxUZYmtAZXdTIss1v20XmJCU=;
        b=YV3fV7ZMSzuwqZcb479wRT8p+XXyxDSe1PCxl+PUX3mVPdL8viBghQL+AYksOv7uo1
         5Ctm5YwlpzUVe8F8FdRbfel6qr+o7lRq9yUi7cQASdlKovby9mTkPMeGrJlI7WHX8Xcn
         u7y89colnAAfCM0gMjjgHxPYQqt8lfh9zL2mHvwDN/04rwUxw+iV3iA/ZO7g/zArZ386
         Eg/iNV+A6r6rP8bNb9BdpLS0Y7RRwzoLFBUpGoprx8yEqjHD79pwWnyYK3E1rMvBPrmL
         diukXFFU3tqjeYxiKI0seQOjU56l3bf611udwGvYjdurjV4HL8srRd+Gy/gJy1gVOcPP
         shHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P+X307cfCvP+dK56x5pdxUZYmtAZXdTIss1v20XmJCU=;
        b=fnP6da58AnaWqrGJIPDfmMFgd+OJi8Z/NQ/CSpY5nfk0SMZpf1rzuuhrZwE1kdxfVh
         8Rx8YI8TE01o2Dbl50eOzsOg5F/rAqOCBig8ygTjeE52VmnWaqcaLBlLBaPwu8z4V4uX
         mfGkWi/rfsa9eBpflxU4gZgD1bdpek0RpZN9JehjWeFjALMTobesIArvvCP+pAO+UJVk
         TCOIbqU1Jp8GeYCHYvcWoFmasrxyF2vGg714nCvgnoilxOLw71fj0bJePBDSqcXmHMfX
         yVutFtd+oy2b72kIGdyriRe0FxLTi2szQK7C7UVeuPg2vqEZqi/m5PrDDHK+1yLrQT6x
         fpXg==
X-Gm-Message-State: AOAM533zSZX1C7mqxMwZkPEz9fH+sVAY2/RuM7EHjR20cZhlJyaq1ddQ
        ONWvVipuBueQbxoTW3rS6DdnKDbJp24=
X-Google-Smtp-Source: ABdhPJyxuHUc0o3hXmnsFVLfI/Nffo4GJ0VlH3vWaSs8JfyBp1UkgWdd7VArdmo7JftO6bjI0lAtqw==
X-Received: by 2002:a17:902:bd06:: with SMTP id p6mr1526890pls.255.1598889117850;
        Mon, 31 Aug 2020 08:51:57 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id b185sm8093210pfg.71.2020.08.31.08.51.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 Aug 2020 08:51:57 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next] bpf: Fix build without BPF_SYSCALL, but with BPF_JIT.
Date:   Mon, 31 Aug 2020 08:51:55 -0700
Message-Id: <20200831155155.62754-1-alexei.starovoitov@gmail.com>
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

This is due to:
obj-$(CONFIG_BPF_JIT) += trampoline.o
obj-$(CONFIG_BPF_JIT) += dispatcher.o
There is a number of functions that arch/x86/net/bpf_jit_comp.c is
using from these two files, but none of them will be used when
only cBPF is on (which is the case for BPF_SYSCALL=n BPF_JIT=y).

Add rcu_trace functions to rcupdate_trace.h. The JITed code won't execute them
and BPF trampoline logic won't be used without BPF_SYSCALL.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/rcupdate_trace.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/rcupdate_trace.h b/include/linux/rcupdate_trace.h
index d9015aac78c6..aaaac8ac927c 100644
--- a/include/linux/rcupdate_trace.h
+++ b/include/linux/rcupdate_trace.h
@@ -82,7 +82,14 @@ static inline void rcu_read_unlock_trace(void)
 void call_rcu_tasks_trace(struct rcu_head *rhp, rcu_callback_t func);
 void synchronize_rcu_tasks_trace(void);
 void rcu_barrier_tasks_trace(void);
-
+#else
+/*
+ * The BPF JIT forms these addresses even when it doesn't call these
+ * functions, so provide definitions that result in runtime errors.
+ */
+static inline void call_rcu_tasks_trace(struct rcu_head *rhp, rcu_callback_t func) { BUG(); }
+static inline void rcu_read_lock_trace(void) { BUG(); }
+static inline void rcu_read_unlock_trace(void) { BUG(); }
 #endif /* #ifdef CONFIG_TASKS_TRACE_RCU */
 
 #endif /* __LINUX_RCUPDATE_TRACE_H */
-- 
2.23.0

