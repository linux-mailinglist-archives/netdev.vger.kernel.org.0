Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B017C3770C8
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 11:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhEHJLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 05:11:39 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:46053 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229583AbhEHJLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 05:11:16 -0400
X-UUID: 05c39cb8cfc54c1993d0bd60a6fc1790-20210508
X-UUID: 05c39cb8cfc54c1993d0bd60a6fc1790-20210508
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1948520470; Sat, 08 May 2021 17:10:14 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 8 May 2021 17:10:12 +0800
Received: from localhost.localdomain (10.15.20.246) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 8 May 2021 17:10:10 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        <peterz@infradead.org>
CC:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Peter Enderborg <peter.enderborg@sony.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Vitor Massaru Iha <vitor@massaru.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Di Zhu <zhudi21@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upsream@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH][v2] rtnetlink: add rtnl_lock debug log
Date:   Sat, 8 May 2021 16:57:38 +0800
Message-ID: <20210508085738.6296-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We often encounter system hangs caused by certain process
holding rtnl_lock for a long time. Even if there is a lock
detection mechanism in Linux, it is a bit troublesome and
affects the system performance. We hope to add a lightweight
debugging mechanism for detecting rtnl_lock.

Up to now, we have discovered and solved some potential bugs
through this lightweight rtnl_lock debugging mechanism, which
is helpful for us.

When you say Y for RTNL_LOCK_DEBUG, then the kernel will detect
if any function hold rtnl_lock too long and some key information
will be printed out to help locate the problem.

i.e: from the following logs, we can clearly know that the pid=2206
RfxSender_4 process holds rtnl_lock for a long time, causing the
system to hang. And we can also speculate that the delay operation
may be performed in devinet_ioctl(), resulting in rtnl_lock was
not released in time.

<6>[   40.191481][    C6] rtnetlink: -- rtnl_print_btrace start --
<6>[   40.191494][    C6] rtnetlink: RfxSender_4[2206][R] hold rtnl_lock
more than 2 sec, start time: 38181400013
<4>[   40.191510][    C6]  devinet_ioctl+0x1fc/0x75c
<4>[   40.191517][    C6]  inet_ioctl+0xb8/0x1f8
<4>[   40.191527][    C6]  sock_do_ioctl+0x70/0x2ac
<4>[   40.191533][    C6]  sock_ioctl+0x5dc/0xa74
<4>[   40.191541][    C6]  __arm64_sys_ioctl+0x178/0x1fc
<4>[   40.191548][    C6]  el0_svc_common+0xc0/0x24c
<4>[   40.191555][    C6]  el0_svc+0x28/0x88
<4>[   40.191560][    C6]  el0_sync_handler+0x8c/0xf0
<4>[   40.191566][    C6]  el0_sync+0x198/0x1c0
<6>[   40.191571][    C6] Call trace:
<6>[   40.191586][    C6]  rtnl_print_btrace+0xf0/0x124
<6>[   40.191595][    C6]  call_timer_fn+0x5c/0x3b4
<6>[   40.191602][    C6]  expire_timers+0xe0/0x49c
<6>[   40.191609][    C6]  __run_timers+0x34c/0x48c
<6>[   40.191616][    C6]  run_timer_softirq+0x28/0x58
<6>[   40.191621][    C6]  efi_header_end+0x168/0x690
<6>[   40.191628][    C6]  __irq_exit_rcu+0x108/0x124
<6>[   40.191635][    C6]  __handle_domain_irq+0x130/0x1b4
<6>[   40.191643][    C6]  gic_handle_irq.29882+0x6c/0x2d8
<6>[   40.191648][    C6]  el1_irq+0xdc/0x1c0
<6>[   40.191656][    C6]  __delay+0xc0/0x180
<6>[   40.191663][    C6]  devinet_ioctl+0x21c/0x75c
<6>[   40.191668][    C6]  inet_ioctl+0xb8/0x1f8
<6>[   40.191675][    C6]  sock_do_ioctl+0x70/0x2ac
<6>[   40.191682][    C6]  sock_ioctl+0x5dc/0xa74
<6>[   40.191688][    C6]  __arm64_sys_ioctl+0x178/0x1fc
<6>[   40.191694][    C6]  el0_svc_common+0xc0/0x24c
<6>[   40.191699][    C6]  el0_svc+0x28/0x88
<6>[   40.191705][    C6]  el0_sync_handler+0x8c/0xf0
<6>[   40.191710][    C6]  el0_sync+0x198/0x1c0
<6>[   40.191715][    C6] rtnetlink: -- rtnl_print_btrace end --

<6>[   42.181879][ T2206] rtnetlink: rtnl_lock is held by [2206] from
[38181400013] to [42181875177]

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 lib/Kconfig.debug    | 10 ++++++
 net/core/rtnetlink.c | 85 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 678c13967580..f1a722e16bee 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2027,6 +2027,16 @@ config KCOV_IRQ_AREA_SIZE
 	  soft interrupts. This specifies the size of those areas in the
 	  number of unsigned long words.
 
+config RTNL_LOCK_DEBUG
+	bool "rtnl_lock debugging, deadlock detection"
+	depends on STACKTRACE_SUPPORT
+	select STACKTRACE
+	help
+	  If you say Y here then the kernel will detect whether any function
+	  hold rtnl_lock too long and some key information will be printed
+	  out to help locate the problem.
+	  If unsure, say N.
+
 menuconfig RUNTIME_TESTING_MENU
 	bool "Runtime Testing"
 	def_bool y
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 714d5fa38546..4f81086e5a42 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -12,6 +12,8 @@
  *	Vitaly E. Lavrov		RTA_OK arithmetics was wrong.
  */
 
+#define pr_fmt(fmt) "rtnetlink: " fmt
+
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/module.h>
@@ -57,6 +59,81 @@
 #define RTNL_MAX_TYPE		50
 #define RTNL_SLAVE_MAX_TYPE	40
 
+#ifdef CONFIG_RTNL_LOCK_DEBUG
+
+#include <linux/sched/debug.h>
+#include <linux/stacktrace.h>
+
+/* Debug log and btrace will be printed when the rtnl_lock
+ * is held for more than RTNL_LOCK_MAX_HOLD_TIME seconds
+ */
+#define RTNL_LOCK_MAX_HOLD_TIME 2
+
+#define RTNL_LOCK_MAX_TRACE     10    /* stack trace length */
+
+struct rtnl_debug_btrace_t {
+	struct task_struct *task;
+	int pid;
+	unsigned long long start_time;
+	unsigned long long end_time;
+	unsigned long addrs[RTNL_LOCK_MAX_TRACE];
+	unsigned int  nr_entries;
+};
+
+static struct rtnl_debug_btrace_t rtnl_instance;
+
+static void rtnl_print_btrace(struct timer_list *unused);
+static DEFINE_TIMER(rtnl_chk_timer, rtnl_print_btrace);
+
+/* Save stack trace to the given array of RTNL_LOCK_MAX_TRACE size.
+ */
+static int __save_stack_trace(unsigned long *trace)
+{
+	return stack_trace_save(trace, RTNL_LOCK_MAX_TRACE, 0);
+}
+
+static void rtnl_get_btrace(struct task_struct *who)
+{
+	unsigned long expires;
+
+	rtnl_instance.task = who;
+	rtnl_instance.pid = who->pid;
+	rtnl_instance.start_time = sched_clock();
+	rtnl_instance.end_time = 0;
+	rtnl_instance.nr_entries = __save_stack_trace(rtnl_instance.addrs);
+
+	expires = jiffies + RTNL_LOCK_MAX_HOLD_TIME * HZ;
+	mod_timer(&rtnl_chk_timer, expires);
+}
+
+static void rtnl_print_btrace(struct timer_list *unused)
+{
+	pr_info("-- %s start --\n", __func__);
+	pr_info("%s[%d][%c] hold rtnl_lock more than %d sec, start time: %llu\n",
+		rtnl_instance.task->comm,
+		rtnl_instance.pid,
+		task_state_to_char(rtnl_instance.task),
+		RTNL_LOCK_MAX_HOLD_TIME,
+		rtnl_instance.start_time);
+	stack_trace_print(rtnl_instance.addrs, rtnl_instance.nr_entries, 0);
+	show_stack(rtnl_instance.task, NULL, KERN_INFO);
+	pr_info("-- %s end --\n", __func__);
+}
+
+static void rtnl_relase_btrace(void)
+{
+	rtnl_instance.end_time = sched_clock();
+	del_timer_sync(&rtnl_chk_timer);
+
+	if (rtnl_instance.end_time - rtnl_instance.start_time > 2 * NSEC_PER_SEC) {
+		pr_info("rtnl_lock is held by [%d] from [%llu] to [%llu]\n",
+			rtnl_instance.pid,
+			rtnl_instance.start_time,
+			rtnl_instance.end_time);
+	}
+}
+#endif
+
 struct rtnl_link {
 	rtnl_doit_func		doit;
 	rtnl_dumpit_func	dumpit;
@@ -70,6 +147,10 @@ static DEFINE_MUTEX(rtnl_mutex);
 void rtnl_lock(void)
 {
 	mutex_lock(&rtnl_mutex);
+
+#ifdef CONFIG_RTNL_LOCK_DEBUG
+	rtnl_get_btrace(current);
+#endif
 }
 EXPORT_SYMBOL(rtnl_lock);
 
@@ -95,6 +176,10 @@ void __rtnl_unlock(void)
 
 	defer_kfree_skb_list = NULL;
 
+#ifdef CONFIG_RTNL_LOCK_DEBUG
+	rtnl_relase_btrace();
+#endif
+
 	mutex_unlock(&rtnl_mutex);
 
 	while (head) {
-- 
2.18.0

