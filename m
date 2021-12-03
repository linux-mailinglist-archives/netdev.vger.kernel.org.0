Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63B1467030
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378239AbhLCCum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378229AbhLCCul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:50:41 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB73C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:47:18 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id v19so1102547plo.7
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aGbL3Gnq4e/kpPuB+kdBYIQcENIxUxFUX/W3zTVIrn4=;
        b=TDCoBXtbpNU+umBIGT7jXoQdZHpvwFucpRodk0bKVAB2t2qYn1yvdCTTEy7o9Ia5v/
         ngD3Lb92iI6FNTMKeElPY0fLk4RW/0vTiSLQ98aAmFoaXWz/Qq7hPuBI96flpgcqa07h
         EbBa0gmJWFwgUttAadC6sYyuWf0/GUxQFMzJ6xUn6Lj2wzw3uTtW0csLrHWU5W7TdOrq
         YRvA+ZUR8Mt3ytPaheNHXWULMQcuWETcnaranRrVi+nY6jbz7dylth6aUSPqImGEEqUc
         VEliOkS8IQPSCzfZ59iZvm+20BvsaHvn8J0290qmA3mciFOwFJMuAjz5AKTuziLYYryn
         7Fgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aGbL3Gnq4e/kpPuB+kdBYIQcENIxUxFUX/W3zTVIrn4=;
        b=I242eezwGVI8MfB7NagGgu3g+Qu+U9PpPMDKB0TpRvee+nW6X2gtIemishcvkPCvj5
         Aw4uLUmweJ+8XYUYQGPos0V7l8k3Y6CMS/zhTxKZOJz4eJlxL3p9owes3x6TFdpFEZ90
         YjUohZE+B/5VyVhXcABME//BZ1FFlgsBTgv4gpgDQoEiHTTgv+PQKecXo/juBCzzVIRC
         SR6W7w4NWML4HddANy7HVxqk/MTLojSSz0Cx6EqHjI5r6pv2Ly6vr26iELYaYP+P7whZ
         2t6tnEELCkxUN1AvolmXuXBHceoPnummxgLEubt6Ug6o9VtRp4D66rSxNByNROh3YnkM
         bWfg==
X-Gm-Message-State: AOAM532bi5mz/a7+PJrOui32hI0l3oT1qHcdGdUXYDo3cydgBbNDckmh
        bqA/I0iP5eMECqVXOd4YnPYpNfmyAFQ=
X-Google-Smtp-Source: ABdhPJzUbvRGH0by9dVy2/6Hr6ntAdJY+3xMWPwx82L3sWjhsK0y05FpNGbH2+eIL170TSTLgW2v3g==
X-Received: by 2002:a17:90b:38c7:: with SMTP id nn7mr10655323pjb.105.1638499637807;
        Thu, 02 Dec 2021 18:47:17 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:47:17 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 02/23] lib: add tests for reference tracker
Date:   Thu,  2 Dec 2021 18:46:19 -0800
Message-Id: <20211203024640.1180745-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This module uses reference tracker, forcing two issues.

1) Double free of a tracker

2) leak of two trackers, one being allocated from softirq context.

"modprobe test_ref_tracker" would emit the following traces.
(Use scripts/decode_stacktrace.sh if necessary)

[  171.648681] reference already released.
[  171.653213] allocated in:
[  171.656523]  alloctest_ref_tracker_alloc2+0x1c/0x20 [test_ref_tracker]
[  171.656526]  init_module+0x86/0x1000 [test_ref_tracker]
[  171.656528]  do_one_initcall+0x9c/0x220
[  171.656532]  do_init_module+0x60/0x240
[  171.656536]  load_module+0x32b5/0x3610
[  171.656538]  __do_sys_init_module+0x148/0x1a0
[  171.656540]  __x64_sys_init_module+0x1d/0x20
[  171.656542]  do_syscall_64+0x4a/0xb0
[  171.656546]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  171.656549] freed in:
[  171.659520]  alloctest_ref_tracker_free+0x13/0x20 [test_ref_tracker]
[  171.659522]  init_module+0xec/0x1000 [test_ref_tracker]
[  171.659523]  do_one_initcall+0x9c/0x220
[  171.659525]  do_init_module+0x60/0x240
[  171.659527]  load_module+0x32b5/0x3610
[  171.659529]  __do_sys_init_module+0x148/0x1a0
[  171.659532]  __x64_sys_init_module+0x1d/0x20
[  171.659534]  do_syscall_64+0x4a/0xb0
[  171.659536]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  171.659575] ------------[ cut here ]------------
[  171.659576] WARNING: CPU: 5 PID: 13016 at lib/ref_tracker.c:112 ref_tracker_free+0x224/0x270
[  171.659581] Modules linked in: test_ref_tracker(+)
[  171.659591] CPU: 5 PID: 13016 Comm: modprobe Tainted: G S                5.16.0-smp-DEV #290
[  171.659595] RIP: 0010:ref_tracker_free+0x224/0x270
[  171.659599] Code: 5e 41 5f 5d c3 48 c7 c7 04 9c 74 a6 31 c0 e8 62 ee 67 00 83 7b 14 00 75 1a 83 7b 18 00 75 30 4c 89 ff 4c 89 f6 e8 9c 00 69 00 <0f> 0b bb ea ff ff ff eb ae 48 c7 c7 3a 0a 77 a6 31 c0 e8 34 ee 67
[  171.659601] RSP: 0018:ffff89058ba0bbd0 EFLAGS: 00010286
[  171.659603] RAX: 0000000000000029 RBX: ffff890586b19780 RCX: 08895bff57c7d100
[  171.659604] RDX: c0000000ffff7fff RSI: 0000000000000282 RDI: ffffffffc0407000
[  171.659606] RBP: ffff89058ba0bc88 R08: 0000000000000000 R09: ffffffffa6f342e0
[  171.659607] R10: 00000000ffff7fff R11: 0000000000000000 R12: 000000008f000000
[  171.659608] R13: 0000000000000014 R14: 0000000000000282 R15: ffffffffc0407000
[  171.659609] FS:  00007f97ea29d740(0000) GS:ffff8923ff940000(0000) knlGS:0000000000000000
[  171.659611] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  171.659613] CR2: 00007f97ea299000 CR3: 0000000186b4a004 CR4: 00000000001706e0
[  171.659614] Call Trace:
[  171.659615]  <TASK>
[  171.659631]  ? alloctest_ref_tracker_free+0x13/0x20 [test_ref_tracker]
[  171.659633]  ? init_module+0x105/0x1000 [test_ref_tracker]
[  171.659636]  ? do_one_initcall+0x9c/0x220
[  171.659638]  ? do_init_module+0x60/0x240
[  171.659641]  ? load_module+0x32b5/0x3610
[  171.659644]  ? __do_sys_init_module+0x148/0x1a0
[  171.659646]  ? __x64_sys_init_module+0x1d/0x20
[  171.659649]  ? do_syscall_64+0x4a/0xb0
[  171.659652]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
[  171.659656]  ? 0xffffffffc040a000
[  171.659658]  alloctest_ref_tracker_free+0x13/0x20 [test_ref_tracker]
[  171.659660]  init_module+0x105/0x1000 [test_ref_tracker]
[  171.659663]  do_one_initcall+0x9c/0x220
[  171.659666]  do_init_module+0x60/0x240
[  171.659669]  load_module+0x32b5/0x3610
[  171.659672]  __do_sys_init_module+0x148/0x1a0
[  171.659676]  __x64_sys_init_module+0x1d/0x20
[  171.659678]  do_syscall_64+0x4a/0xb0
[  171.659694]  ? exc_page_fault+0x6e/0x140
[  171.659696]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  171.659698] RIP: 0033:0x7f97ea3dbe7a
[  171.659700] Code: 48 8b 0d 61 8d 06 00 f7 d8 64 89 01 48 83 c8 ff c3 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 49 89 ca b8 af 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2e 8d 06 00 f7 d8 64 89 01 48
[  171.659701] RSP: 002b:00007ffea67ce608 EFLAGS: 00000246 ORIG_RAX: 00000000000000af
[  171.659703] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f97ea3dbe7a
[  171.659704] RDX: 00000000013a0ba0 RSI: 0000000000002808 RDI: 00007f97ea299000
[  171.659705] RBP: 00007ffea67ce670 R08: 0000000000000003 R09: 0000000000000000
[  171.659706] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000013a1048
[  171.659707] R13: 00000000013a0ba0 R14: 0000000001399930 R15: 00000000013a1030
[  171.659709]  </TASK>
[  171.659710] ---[ end trace f5dbd6afa41e60a9 ]---
[  171.659712] leaked reference.
[  171.663393]  alloctest_ref_tracker_alloc0+0x1c/0x20 [test_ref_tracker]
[  171.663395]  test_ref_tracker_timer_func+0x9/0x20 [test_ref_tracker]
[  171.663397]  call_timer_fn+0x31/0x140
[  171.663401]  expire_timers+0x46/0x110
[  171.663403]  __run_timers+0x16f/0x1b0
[  171.663404]  run_timer_softirq+0x1d/0x40
[  171.663406]  __do_softirq+0x148/0x2d3
[  171.663408] leaked reference.
[  171.667101]  alloctest_ref_tracker_alloc1+0x1c/0x20 [test_ref_tracker]
[  171.667103]  init_module+0x81/0x1000 [test_ref_tracker]
[  171.667104]  do_one_initcall+0x9c/0x220
[  171.667106]  do_init_module+0x60/0x240
[  171.667108]  load_module+0x32b5/0x3610
[  171.667111]  __do_sys_init_module+0x148/0x1a0
[  171.667113]  __x64_sys_init_module+0x1d/0x20
[  171.667115]  do_syscall_64+0x4a/0xb0
[  171.667117]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  171.667131] ------------[ cut here ]------------
[  171.667132] WARNING: CPU: 5 PID: 13016 at lib/ref_tracker.c:30 ref_tracker_dir_exit+0x104/0x130
[  171.667136] Modules linked in: test_ref_tracker(+)
[  171.667144] CPU: 5 PID: 13016 Comm: modprobe Tainted: G S      W         5.16.0-smp-DEV #290
[  171.667147] RIP: 0010:ref_tracker_dir_exit+0x104/0x130
[  171.667150] Code: 01 00 00 00 00 ad de 48 89 03 4c 89 63 08 48 89 df e8 20 a0 d5 ff 4c 89 f3 4d 39 ee 75 a8 4c 89 ff 48 8b 75 d0 e8 7c 05 69 00 <0f> 0b eb 0c 4c 89 ff 48 8b 75 d0 e8 6c 05 69 00 41 8b 47 08 83 f8
[  171.667151] RSP: 0018:ffff89058ba0bc68 EFLAGS: 00010286
[  171.667154] RAX: 08895bff57c7d100 RBX: ffffffffc0407010 RCX: 000000000000003b
[  171.667156] RDX: 000000000000003c RSI: 0000000000000282 RDI: ffffffffc0407000
[  171.667157] RBP: ffff89058ba0bc98 R08: 0000000000000000 R09: ffffffffa6f342e0
[  171.667159] R10: 00000000ffff7fff R11: 0000000000000000 R12: dead000000000122
[  171.667160] R13: ffffffffc0407010 R14: ffffffffc0407010 R15: ffffffffc0407000
[  171.667162] FS:  00007f97ea29d740(0000) GS:ffff8923ff940000(0000) knlGS:0000000000000000
[  171.667164] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  171.667166] CR2: 00007f97ea299000 CR3: 0000000186b4a004 CR4: 00000000001706e0
[  171.667169] Call Trace:
[  171.667170]  <TASK>
[  171.667171]  ? 0xffffffffc040a000
[  171.667173]  init_module+0x126/0x1000 [test_ref_tracker]
[  171.667175]  do_one_initcall+0x9c/0x220
[  171.667179]  do_init_module+0x60/0x240
[  171.667182]  load_module+0x32b5/0x3610
[  171.667186]  __do_sys_init_module+0x148/0x1a0
[  171.667189]  __x64_sys_init_module+0x1d/0x20
[  171.667192]  do_syscall_64+0x4a/0xb0
[  171.667194]  ? exc_page_fault+0x6e/0x140
[  171.667196]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  171.667199] RIP: 0033:0x7f97ea3dbe7a
[  171.667200] Code: 48 8b 0d 61 8d 06 00 f7 d8 64 89 01 48 83 c8 ff c3 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 49 89 ca b8 af 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2e 8d 06 00 f7 d8 64 89 01 48
[  171.667201] RSP: 002b:00007ffea67ce608 EFLAGS: 00000246 ORIG_RAX: 00000000000000af
[  171.667203] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f97ea3dbe7a
[  171.667204] RDX: 00000000013a0ba0 RSI: 0000000000002808 RDI: 00007f97ea299000
[  171.667205] RBP: 00007ffea67ce670 R08: 0000000000000003 R09: 0000000000000000
[  171.667206] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000013a1048
[  171.667207] R13: 00000000013a0ba0 R14: 0000000001399930 R15: 00000000013a1030
[  171.667209]  </TASK>
[  171.667210] ---[ end trace f5dbd6afa41e60aa ]---

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 lib/Kconfig.debug      |  10 ++++
 lib/Makefile           |   2 +-
 lib/test_ref_tracker.c | 115 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 126 insertions(+), 1 deletion(-)
 create mode 100644 lib/test_ref_tracker.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 5c12bde10996cf97b5f075d318089b1be73f71d7..d005f555872147e15d3e0a65d2a03e1a5c44f5f0 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2106,6 +2106,16 @@ config BACKTRACE_SELF_TEST
 
 	  Say N if you are unsure.
 
+config TEST_REF_TRACKER
+	tristate "Self test for reference tracker"
+	depends on DEBUG_KERNEL
+	select REF_TRACKER
+	help
+	  This option provides a kernel module performing tests
+	  using reference tracker infrastructure.
+
+	  Say N if you are unsure.
+
 config RBTREE_TEST
 	tristate "Red-Black tree test"
 	depends on DEBUG_KERNEL
diff --git a/lib/Makefile b/lib/Makefile
index c1fd9243ddb9cc1ac5252d7eb8009f9290782c4a..b213a7bbf3fda2eb9f234fb7473b8f1b617bed6b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -101,7 +101,7 @@ obj-$(CONFIG_TEST_LOCKUP) += test_lockup.o
 obj-$(CONFIG_TEST_HMM) += test_hmm.o
 obj-$(CONFIG_TEST_FREE_PAGES) += test_free_pages.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
-
+obj-$(CONFIG_TEST_REF_TRACKER) += test_ref_tracker.o
 #
 # CFLAGS for compiling floating point code inside the kernel. x86/Makefile turns
 # off the generation of FPU/SSE* instructions for kernel proper but FPU_FLAGS
diff --git a/lib/test_ref_tracker.c b/lib/test_ref_tracker.c
new file mode 100644
index 0000000000000000000000000000000000000000..19d7dec70cc62f0a7b274cd5ec8bf8cec62b0af3
--- /dev/null
+++ b/lib/test_ref_tracker.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Referrence tracker self test.
+ *
+ * Copyright (c) 2021 Eric Dumazet <edumazet@google.com>
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/ref_tracker.h>
+#include <linux/slab.h>
+#include <linux/timer.h>
+
+static struct ref_tracker_dir ref_dir;
+static struct ref_tracker *tracker[20];
+
+#define TRT_ALLOC(X) static noinline void 				\
+	alloctest_ref_tracker_alloc##X(struct ref_tracker_dir *dir, 	\
+				    struct ref_tracker **trackerp)	\
+	{								\
+		ref_tracker_alloc(dir, trackerp, GFP_KERNEL);		\
+	}
+
+TRT_ALLOC(1)
+TRT_ALLOC(2)
+TRT_ALLOC(3)
+TRT_ALLOC(4)
+TRT_ALLOC(5)
+TRT_ALLOC(6)
+TRT_ALLOC(7)
+TRT_ALLOC(8)
+TRT_ALLOC(9)
+TRT_ALLOC(10)
+TRT_ALLOC(11)
+TRT_ALLOC(12)
+TRT_ALLOC(13)
+TRT_ALLOC(14)
+TRT_ALLOC(15)
+TRT_ALLOC(16)
+TRT_ALLOC(17)
+TRT_ALLOC(18)
+TRT_ALLOC(19)
+
+#undef TRT_ALLOC
+
+static noinline void
+alloctest_ref_tracker_free(struct ref_tracker_dir *dir,
+			   struct ref_tracker **trackerp)
+{
+	ref_tracker_free(dir, trackerp);
+}
+
+
+static struct timer_list test_ref_tracker_timer;
+static atomic_t test_ref_timer_done = ATOMIC_INIT(0);
+
+static void test_ref_tracker_timer_func(struct timer_list *t)
+{
+	ref_tracker_alloc(&ref_dir, &tracker[0], GFP_ATOMIC);
+	atomic_set(&test_ref_timer_done, 1);
+}
+
+static int __init test_ref_tracker_init(void)
+{
+	int i;
+
+	ref_tracker_dir_init(&ref_dir, 100);
+
+	timer_setup(&test_ref_tracker_timer, test_ref_tracker_timer_func, 0);
+	mod_timer(&test_ref_tracker_timer, jiffies + 1);
+
+	alloctest_ref_tracker_alloc1(&ref_dir, &tracker[1]);
+	alloctest_ref_tracker_alloc2(&ref_dir, &tracker[2]);
+	alloctest_ref_tracker_alloc3(&ref_dir, &tracker[3]);
+	alloctest_ref_tracker_alloc4(&ref_dir, &tracker[4]);
+	alloctest_ref_tracker_alloc5(&ref_dir, &tracker[5]);
+	alloctest_ref_tracker_alloc6(&ref_dir, &tracker[6]);
+	alloctest_ref_tracker_alloc7(&ref_dir, &tracker[7]);
+	alloctest_ref_tracker_alloc8(&ref_dir, &tracker[8]);
+	alloctest_ref_tracker_alloc9(&ref_dir, &tracker[9]);
+	alloctest_ref_tracker_alloc10(&ref_dir, &tracker[10]);
+	alloctest_ref_tracker_alloc11(&ref_dir, &tracker[11]);
+	alloctest_ref_tracker_alloc12(&ref_dir, &tracker[12]);
+	alloctest_ref_tracker_alloc13(&ref_dir, &tracker[13]);
+	alloctest_ref_tracker_alloc14(&ref_dir, &tracker[14]);
+	alloctest_ref_tracker_alloc15(&ref_dir, &tracker[15]);
+	alloctest_ref_tracker_alloc16(&ref_dir, &tracker[16]);
+	alloctest_ref_tracker_alloc17(&ref_dir, &tracker[17]);
+	alloctest_ref_tracker_alloc18(&ref_dir, &tracker[18]);
+	alloctest_ref_tracker_alloc19(&ref_dir, &tracker[19]);
+
+	/* free all trackers but first 0 and 1. */
+	for (i = 2; i < ARRAY_SIZE(tracker); i++)
+		alloctest_ref_tracker_free(&ref_dir, &tracker[i]);
+
+	/* Attempt to free an already freed tracker. */
+	alloctest_ref_tracker_free(&ref_dir, &tracker[2]);
+
+	while (!atomic_read(&test_ref_timer_done))
+		msleep(1);
+
+	/* This should warn about tracker[0] & tracker[1] being not freed. */
+	ref_tracker_dir_exit(&ref_dir);
+
+	return 0;
+}
+
+static void __exit test_ref_tracker_exit(void)
+{
+}
+
+module_init(test_ref_tracker_init);
+module_exit(test_ref_tracker_exit);
+
+MODULE_LICENSE("GPL v2");
-- 
2.34.1.400.ga245620fadb-goog

