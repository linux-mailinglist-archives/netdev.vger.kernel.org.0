Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84131230334
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgG1Gpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgG1Gps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 02:45:48 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4A6C0619D2
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 23:45:48 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mt12so3563187pjb.4
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 23:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ke46Ku461cG8KukZ4o3LTTt2Jgz/9Y8JbdOY4wJFnww=;
        b=R9ohPN29erKS0fOFdoc8zIsqTDdcirU0OjOh0fUUybl/57ATxxl0AeiwhCgKBeAtQN
         XpCvcfW13RON2qYmDunVyj6kTFT31j6C5/JQUCWoLJLglewm7/ZsoP+Om2D0XAdiWkHR
         WqF7iSFpioyrIk0XevSPjcujH+e48ePm8OEzriP4hVETRdmamODLo4ovB1t9G++zbJFd
         00xxGZoEGXn1Qi4SuldmFTOEi3b/fcPJ39km9jJZqPy3CoOZ2NdRivqmWzAgClA5MtG1
         40aLTRJt/2nFhpCaYV1/jwmGq2q/vP65QVIydbqIQo8AC69LEu1u95CHoi4cno1q2V7j
         PK8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ke46Ku461cG8KukZ4o3LTTt2Jgz/9Y8JbdOY4wJFnww=;
        b=QYB7DkdX4ZR4lfolPfEj53LrSDI2k2lZ2ObsPZd7uVYEcbIbxuo35jBN2hwSubclDl
         +TTYORVDHA690bNd03C2ii4zl/XOe1UG9jP35TJjGLwO3vMDTPl1nGS1GrHTEr9xx2EO
         US9YeTtJSqeXQpSHngvcBq1PPQ9oc3aMy3dhbmLqiXX8RUL0/3vXbGQpwLjBMtfqlLSY
         PYqE2HZfjpbe7lN2tUPhv+NE4a7yWFkKOi8ncJO42rPBeTKqTdmFBbCyajilORoTPsDn
         siXrr9LlLdhKjvgp92OD2wDp32soHxQMgPtCovj+R/a4TorB3O+94aEJ5bGP+8ApgOm7
         7vPQ==
X-Gm-Message-State: AOAM532ylVxgLu2NAQ5N6lS9ixmMDll9I5ZEZww960Sghy+whlXKCEwN
        nKlwNdKJLycvzhodqlpvGSDz3N3YBrvkaA==
X-Google-Smtp-Source: ABdhPJzyNbiswigF3uFnZ7RzZiJDUrzdP0lv6MxPhZkNvHGVIk5805kkjSs7blpesaUHpJEC3mcY9A==
X-Received: by 2002:a17:90a:2846:: with SMTP id p6mr2938979pjf.163.1595918748144;
        Mon, 27 Jul 2020 23:45:48 -0700 (PDT)
Received: from Smcdef-MBP.local.net ([103.136.221.71])
        by smtp.gmail.com with ESMTPSA id y19sm16638834pgj.35.2020.07.27.23.45.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2020 23:45:47 -0700 (PDT)
From:   Muchun Song <songmuchun@bytedance.com>
To:     naveen.n.rao@linux.ibm.com, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, mhiramat@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH] kprobes: fix NULL pointer dereference at kprobe_ftrace_handler
Date:   Tue, 28 Jul 2020 14:45:36 +0800
Message-Id: <20200728064536.24405-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found a case of kernel panic on our server. The stack trace is as
follows(omit some irrelevant information):

  BUG: kernel NULL pointer dereference, address: 0000000000000080
  RIP: 0010:kprobe_ftrace_handler+0x5e/0xe0
  RSP: 0018:ffffb512c6550998 EFLAGS: 00010282
  RAX: 0000000000000000 RBX: ffff8e9d16eea018 RCX: 0000000000000000
  RDX: ffffffffbe1179c0 RSI: ffffffffc0535564 RDI: ffffffffc0534ec0
  RBP: ffffffffc0534ec1 R08: ffff8e9d1bbb0f00 R09: 0000000000000004
  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
  R13: ffff8e9d1f797060 R14: 000000000000bacc R15: ffff8e9ce13eca00
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000080 CR3: 00000008453d0005 CR4: 00000000003606e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <IRQ>
   ftrace_ops_assist_func+0x56/0xe0
   ftrace_call+0x5/0x34
   tcpa_statistic_send+0x5/0x130 [ttcp_engine]

The tcpa_statistic_send is the function being kprobed. After analysis,
the root cause is that the fourth parameter regs of kprobe_ftrace_handler
is NULL. Why regs is NULL? We use the crash tool to analyze the kdump.

  crash> dis tcpa_statistic_send -r
         <tcpa_statistic_send>: callq 0xffffffffbd8018c0 <ftrace_caller>

The tcpa_statistic_send calls ftrace_caller instead of ftrace_regs_caller.
So it is reasonable that the fourth parameter regs of kprobe_ftrace_handler
is NULL. In theory, we should call the ftrace_regs_caller instead of the
ftrace_caller. After in-depth analysis, we found a reproducible path.

  Writing a simple kernel module which starts a periodic timer. The
  timer's handler is named 'kprobe_test_timer_handler'. The module
  name is kprobe_test.ko.

  1) insmod kprobe_test.ko
  2) bpftrace -e 'kretprobe:kprobe_test_timer_handler {}'
  3) echo 0 > /proc/sys/kernel/ftrace_enabled
  4) rmmod kprobe_test
  5) stop step 2) kprobe
  6) insmod kprobe_test.ko
  7) bpftrace -e 'kretprobe:kprobe_test_timer_handler {}'

We mark the kprobe as GONE but not disarm the kprobe in the step 4).
The step 5) also do not disarm the kprobe when unregister kprobe. So
we do not remove the ip from the filter. In this case, when the module
loads again in the step 6), we will replace the code to ftrace_caller
via the ftrace_module_enable(). When we register kprobe again, we will
not replace ftrace_caller to ftrace_regs_caller because the ftrace is
disabled in the step 3). So the step 7) will trigger kernel panic. Fix
this problem by disarming the kprobe when the module is going away.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 kernel/kprobes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 146c648eb943..503add629599 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2148,6 +2148,13 @@ static void kill_kprobe(struct kprobe *p)
 	 * the original probed function (which will be freed soon) any more.
 	 */
 	arch_remove_kprobe(p);
+
+	/*
+	 * The module is going away. We should disarm the kprobe which
+	 * is using ftrace.
+	 */
+	if (kprobe_ftrace(p))
+		disarm_kprobe_ftrace(p);
 }
 
 /* Disable one kprobe */
-- 
2.11.0

