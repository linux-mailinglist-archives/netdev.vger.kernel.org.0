Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B67D09D6FC
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 21:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732934AbfHZTrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 15:47:02 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:2747 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731124AbfHZTrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 15:47:02 -0400
Received: from smtp.aristanetworks.com (localhost [127.0.0.1])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 7209742C3FA;
        Mon, 26 Aug 2019 12:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1566848263;
        bh=P6qcBeZLPJpeVxQ8zSOSXiPxmRjanZu8toPXO61DwXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=DY6w3wqt1y2vmlcj7hh99UzRuze5GxzrPhVe5S8cdFJX9U0SjwndBAk1vjneLxhzw
         QJKwNxpg5rqRBisyx3mTsVP1f4FqIW39Kk6wm9aKJe090AjZrhq9C7rXDBuMDt1ury
         LgqC6RNuM8KJWuT7m0KSSbnagy7btMmK0Cc5WJcldRZApECszFyfBDVyd5Znorv4KN
         ImJ14c8qnjoZs4/N3gmjvqrL8IbA3mlBLbKzDODpEVgw1zZ9CHF2VwCYkZXyLWIsPR
         N1InihTRrLuXSQtfUC73d+6zYuk7h6uwAADSg7BzpRJ+jCDcQOnBsdI+CLb6NeCPyH
         0zaV2M/JEvx6g==
Received: from egc101.sjc.aristanetworks.com (unknown [172.20.210.50])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 5B91542C3E7;
        Mon, 26 Aug 2019 12:37:43 -0700 (PDT)
From:   Edward Chron <echron@arista.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, colona@arista.com,
        Edward Chron <echron@arista.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 10/10] mm/oom_debug: Add Enhanced Process Print Information
Date:   Mon, 26 Aug 2019 12:36:38 -0700
Message-Id: <20190826193638.6638-11-echron@arista.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190826193638.6638-1-echron@arista.com>
References: <20190826193638.6638-1-echron@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add OOM Debug code that prints additional detailed information about
users processes that were considered for OOM killing for any print
selected processes. The information is displayed for each user process
that OOM prints in the output.

This supplemental per user process information is very helpful for
determing how process memory is used to allow OOM event root cause
identifcation that might not otherwise be possible.

Configuring Enhanced Process Print Information
----------------------------------------------
The DEBUG_OOM_ENHANCED_PROCESS_PRINT is the config entry defined for
this OOM Debug option.  This option is dependent on the OOM Debug
option DEBUG_OOM_SELECT_PROCESS which adds code to allow processes
that are considered for OOM kill to be selectively printed, only
printing processes that use a specified minimum amount of memory.

The kernel configuration entry for this option can be found in the
config file at: Kernel hacking, Memory Debugging, Debug OOM,
Debug OOM Process Selection, Debug OOM Enhanced Process Print.
Both Debug OOM Process Selection and Debug OOM Enhanced Process Print
entries must be selected.

Dynamic disable or re-enable this OOM Debug option
--------------------------------------------------
This option may be disabled or re-enabled using the debugfs entry for
this OOM debug option. The debugfs file to enable this entry is found at:
/sys/kernel/debug/oom/process_enhanced_print_enabled where the enabled
file's value determines whether the facility is enabled or disabled.
A value of 1 is enabled (default) and a value of 0 is disabled.

Content and format of process record and Task state headers
-----------------------------------------------------------
Each OOM process entry printed include memory information about the
process. Memory usage is specified in KiB for memory values instead of
pages. Each entry includes the following fields:
pid, ppid, ruid, euid, tgid, State (S), the oom_score_adjust (Adjust),
task comm value (name), and also memory values (all in KB): VmemKiB,
MaxRssKiB, CurRssKiB, PteKiB, SwapKiB, socket pages (SockKiB), LibKiB,
TextPgKiB, HeapPgKiB, StackKiB, FileKiB and shared memory (ShmemKiB).
Counts of page reads (ReadPgs) and page faults (FaultPgs) are included.

Sample Output
-------------
OOM Process select print headers and line of process enhanced output:

Aug  6 09:37:21 egc103 kernel: Tasks state (memory values in KiB):
Aug  6 09:37:21 egc103 kernel: [  pid  ]    ppid    ruid    euid
    tgid S  utimeSec  stimeSec   VmemKiB MaxRssKiB CurRssKiB
    PteKiB   SwapKiB   SockKiB     LibKiB   TextKiB   HeapKiB
  StackKiB   FileKiB  ShmemKiB   ReadPgs  FaultPgs   LockKiB
 PinnedKiB Adjust name

Aug  6 09:37:21 egc103 kernel: [   7707]    7553   10383   10383
    7707 S     0.132     0.350   1056804   1054040   1052796
      2092         0         0       1944       684   1052860
       136         4         0         0         0         0
         0   1000 oomprocs


Signed-off-by: Edward Chron <echron@arista.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 mm/Kconfig.debug    |  23 +++++
 mm/oom_kill.c       |  23 ++++-
 mm/oom_kill_debug.c | 236 ++++++++++++++++++++++++++++++++++++++++++++
 mm/oom_kill_debug.h |   5 +
 4 files changed, 285 insertions(+), 2 deletions(-)

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 4414e46f72c6..2bc843727968 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -320,3 +320,26 @@ config DEBUG_OOM_PROCESS_SELECT_PRINT
 	  print limit value of 10 or 1% of memory.
 
 	  If unsure, say N.
+
+config DEBUG_OOM_ENHANCED_PROCESS_PRINT
+	bool "Debug OOM Enhanced Process Print"
+	depends on DEBUG_OOM_PROCESS_SELECT_PRINT
+	help
+	  Each OOM process entry printed include memory information about
+	  the process. Memory usage is specified in KiB (KB) for memory
+	  values, not pages. Each entry includes the following fields:
+	  pid, ppid, ruid, euid, tgid, State (S), utime in seconds,
+	  stime in seconds, the number of read pages (ReadPgs), number of
+	  page faults (FaultPgs), the number of lock pages (LockPgs), the
+	  oom_score_adjust value (Adjust), memory percentage used (MemPct),
+	  oom_score (Score), task comm value (name), and also memory values
+	  (all in KB): VmemKiB, MaxRssKiB, CurRssKiB, PteKiB, SwapKiB,
+	  socket pages (SockKiB), LibKiB, TextPgKiB, HeapPgKiB, StackKiB,
+	  FileKiB and shared memory pages (ShmemKiB).
+
+	  If the option is configured it is enabled/disabled by setting
+	  the value of the file entry in the debugfs OOM interface at:
+	  /sys/kernel/debug/oom/process_enhanced_print_enabled
+	  A value of 1 is enabled (default) and a value of 0 is disabled.
+
+	  If unsure, say N.
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index cbea289c6345..cf37caea9c5c 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -417,6 +417,13 @@ static int dump_task(struct task_struct *p, void *arg)
 	}
 #endif
 
+#ifdef CONFIG_DEBUG_OOM_ENHANCED_PROCESS_PRINT
+	if (oom_kill_debug_enhanced_process_print_enabled()) {
+		dump_task_prt(task, rsspgs, swappgs, pgtbl);
+		task_unlock(task);
+		return 1;
+	}
+#endif
 	pr_info("[%7d] %5d %5d %8lu %8lu %8ld %8lu         %5hd %s\n",
 		task->pid, from_kuid(&init_user_ns, task_uid(task)),
 		task->tgid, task->mm->total_vm, rsspgs, pgtbl, swappgs,
@@ -426,6 +433,19 @@ static int dump_task(struct task_struct *p, void *arg)
 	return 1;
 }
 
+static void dump_tasks_headers(void)
+{
+#ifdef CONFIG_DEBUG_OOM_ENHANCED_PROCESS_PRINT
+	if (oom_kill_debug_enhanced_process_print_enabled()) {
+		pr_info("Tasks state (memory values in KiB):\n");
+		pr_info("[  pid  ]    ppid    ruid    euid    tgid S  utimeSec  stimeSec   VmemKiB MaxRssKiB CurRssKiB    PteKiB   SwapKiB   SockKiB     LibKiB   TextKiB   HeapKiB  StackKiB   FileKiB  ShmemKiB     ReadPgs    FaultPgs   LockKiB PinnedKiB Adjust name\n");
+		return;
+	}
+#endif
+	pr_info("Tasks state (memory values in pages):\n");
+	pr_info("[  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name\n");
+}
+
 #define K(x) ((x) << (PAGE_SHIFT-10))
 
 /**
@@ -443,8 +463,7 @@ static void dump_tasks(struct oom_control *oc)
 	u32 total = 0;
 	u32 prted = 0;
 
-	pr_info("Tasks state (memory values in pages):\n");
-	pr_info("[  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name\n");
+	dump_tasks_headers();
 
 #ifdef CONFIG_DEBUG_OOM_PROCESS_SELECT_PRINT
 	oc->minpgs = oom_kill_debug_min_task_pages(oc->totalpages);
diff --git a/mm/oom_kill_debug.c b/mm/oom_kill_debug.c
index ad937b3d59f3..467f7add4397 100644
--- a/mm/oom_kill_debug.c
+++ b/mm/oom_kill_debug.c
@@ -171,6 +171,12 @@
 #ifdef CONFIG_DEBUG_OOM_VMALLOC_SELECT_PRINT
 #include <linux/vmalloc.h>
 #endif
+#ifdef CONFIG_DEBUG_OOM_ENHANCED_PROCESS_PRINT
+#include <linux/fdtable.h>
+#include <linux/net.h>
+#include <net/sock.h>
+#include <linux/sched/cputime.h>
+#endif
 
 #define OOMD_MAX_FNAME 48
 #define OOMD_MAX_OPTNAME 32
@@ -250,6 +256,12 @@ static struct oom_debug_option oom_debug_options_table[] = {
 		.option_name	= "slab_enhanced_print_",
 		.support_tpercent = false,
 	},
+#endif
+#ifdef CONFIG_DEBUG_OOM_ENHANCED_PROCESS_PRINT
+	{
+		.option_name	= "process_enhanced_print_",
+		.support_tpercent = false,
+	},
 #endif
 	{}
 };
@@ -282,6 +294,9 @@ enum oom_debug_options_index {
 #endif
 #ifdef CONFIG_DEBUG_OOM_ENHANCED_SLAB_PRINT
 	ENHANCED_SLAB_STATE,
+#endif
+#ifdef CONFIG_DEBUG_OOM_ENHANCED_PROCESS_PRINT
+	ENHANCED_PROCESS_STATE,
 #endif
 	OUT_OF_BOUNDS
 };
@@ -365,6 +380,12 @@ bool oom_kill_debug_enhanced_slab_print_information_enabled(void)
 	return oom_kill_debug_enabled(ENHANCED_SLAB_STATE);
 }
 #endif
+#ifdef CONFIG_DEBUG_OOM_ENHANCED_PROCESS_PRINT
+bool oom_kill_debug_enhanced_process_print_enabled(void)
+{
+	return oom_kill_debug_enabled(ENHANCED_PROCESS_STATE);
+}
+#endif
 
 #ifdef CONFIG_DEBUG_OOM_SYSTEM_STATE
 /*
@@ -513,6 +534,221 @@ u32 oom_kill_debug_oom_event_is(void)
 	return oom_kill_debug_oom_events;
 }
 
+#ifdef CONFIG_DEBUG_OOM_ENHANCED_PROCESS_PRINT
+/*
+ *  Account for socket(s) buffer memory in use by a task.
+ *  A task may have one or more sockets consuming socket buffer space.
+ *  Account for how much socket space each task has in use.
+ */
+static unsigned long account_for_socket_buffers(struct task_struct *task,
+						char *incomplete)
+{
+	unsigned long sockpgs = 0;
+	struct files_struct *files = task->files;
+	struct fdtable *fdt;
+	struct file **fds;
+	int openfilecount;
+	struct inode *inode;
+	struct socket *sock;
+	struct sock *sk;
+	unsigned long bytes;
+	int fdtsize;
+	int i;
+
+	/* Just to make sure the fds don't get closed */
+	atomic_inc(&files->count);
+	/* Make a best effort, but no reason to get hung up here */
+	if (!spin_trylock(&files->file_lock)) {
+		*incomplete = '*';
+		atomic_dec(&files->count);
+		return 0;
+	}
+
+	rcu_read_lock();
+	fdt = files_fdtable(files);
+	fdtsize = fdt->max_fds;
+	/* Determine how many words we need to check for open files */
+	for (i = fdtsize / BITS_PER_LONG; i > 0; ) {
+		if (fdt->open_fds[--i])
+			break;
+	}
+	openfilecount = (i + 1) * BITS_PER_LONG;  // Check each fd in the word
+	fds = fdt->fd;
+	for (i = openfilecount; i != 0; i--) {
+		struct file *fp = *fds++;
+
+		if (fp) {
+			/* Any continue case doesn't need to be counted */
+			if (fp->f_path.dentry == NULL)
+				continue;
+			inode = fp->f_path.dentry->d_inode;
+			if (inode == NULL || !S_ISSOCK(inode->i_mode))
+				continue;
+			sock = fp->private_data;
+			if (sock == NULL)
+				continue;
+			sk = sock->sk;
+			if (sk == NULL)
+				continue;
+			bytes = roundup(sk->sk_rcvbuf, PAGE_SIZE);
+			sockpgs = bytes / PAGE_SIZE;
+			bytes = roundup(sk->sk_sndbuf, PAGE_SIZE);
+			sockpgs += bytes / PAGE_SIZE;
+		}
+	}
+	rcu_read_unlock();
+
+	spin_unlock(&files->file_lock);
+	/* We're done looking at the fds */
+	atomic_dec(&files->count);
+
+	return sockpgs;
+}
+
+static u64 power10(u32 index)
+{
+	static u64 pwr10[11] = {1, 10, 100, 1000, 10000, 100000, 1000000,
+				10000000, 100000000, 1000000000,
+				10000000000};
+
+	return pwr10[index];
+}
+
+static u32 num_digits(u64 num)
+{
+	u32 i;
+
+	for (i = 1; i < 11; ++i) {
+		if (power10(i) > num)
+			return i;
+	}
+	return i;
+}
+
+static void digits_and_fraction(u64 num, u32 *p_digits, u32 *p_frac, u32 chars)
+{
+	*p_digits = num_digits(num);
+	// Allow for decimal place for fractional output
+	if (chars - 1 > *p_digits)
+		*p_frac = chars - 1 - *p_digits;
+	else
+		*p_frac = 0;
+}
+
+#define MAX_NUM_FIELD_SIZE	10
+/*
+ * Format timespec into seconds and possibly fraction, must fit in 9 bytes.
+ * Linux kernel doesn't support floating point so format as best we can.
+ * With 9 digits in seconds convers 31.7 years and where we can we provide
+ * fractions of a second up to miliseconds.
+ */
+static void timespec_format(u64 nsecs_time, char *p_time, size_t time_size)
+{
+	struct timespec64 tspec = ns_to_timespec64(nsecs_time);
+	u32 digits, fracs, bytes, min;
+	u64 fraction;
+
+	digits_and_fraction(tspec.tv_sec, &digits, &fracs, time_size);
+
+	bytes = sprintf(p_time, "%llu", tspec.tv_sec);
+
+	if (fracs > 0) {
+		u32 frsize = num_digits(tspec.tv_nsec);
+
+		p_time += bytes;
+		if (frsize >= 3) {
+			if (fracs >= 3)
+				min = frsize - 3;
+			else if (fracs >= 2)
+				min = frsize - 2;
+			else
+				min = frsize - 1;
+		} else if (frsize >= 2) {
+			if (fracs >= 2)
+				min = frsize - 2;
+			else
+				min = frsize - 1;
+		} else {
+			min = frsize - 1;
+		}
+		fraction = tspec.tv_nsec / power10(min);
+		sprintf(p_time, ".%llu", fraction);
+	}
+}
+
+/*
+ * Format utime, stime in seconds and possibly fractions, must fit in 9 bytes.
+ */
+static void time_format(struct task_struct *task, char *p_utime, char *p_stime)
+{
+	size_t num_size = MAX_NUM_FIELD_SIZE;
+	u64 utime, stime;
+
+	task_cputime_adjusted(task, &utime, &stime);
+	memset(p_utime, 0, num_size);
+	timespec_format(utime, p_utime, num_size - 1);
+	memset(p_stime, 0, num_size);
+	timespec_format(stime, p_stime, num_size - 1);
+}
+
+/* task_index_to_char kernel function is missing options so use this */
+#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKWP"
+static const char task_to_char[] = TASK_STATE_TO_CHAR_STR;
+static const char get_task_state(struct task_struct *p_task, ulong state)
+{
+	int bit = state ? __ffs(state) + 1 : 0;
+
+	if (p_task->tgid == 0)
+		return 'I';
+	return bit < sizeof(task_to_char) - 1 ? task_to_char[bit] : '?';
+}
+
+/*
+ * Code that prints the information about the specified task.
+ * Assumes task lock is held at entry.
+ */
+void dump_task_prt(struct task_struct *task,
+		   unsigned long rsspg, unsigned long swappg,
+		   unsigned long pgtbl)
+{
+	char c_utime[MAX_NUM_FIELD_SIZE], c_stime[MAX_NUM_FIELD_SIZE];
+	unsigned long vmkb, sockkb, text, maxrsspg, pgtblpg;
+	unsigned long libkb, textkb, pgtblkb;
+	struct mm_struct *mm;
+	char incomp = ' ';
+	kuid_t ruid, euid;
+	char tstate;
+
+	mm = task->mm;
+	maxrsspg = rsspg;
+	pgtblpg = pgtbl >> PAGE_SHIFT;
+	ruid = __task_cred(task)->uid;
+	euid = __task_cred(task)->euid;
+	vmkb = K(mm->total_vm);
+	if (maxrsspg < mm->hiwater_rss)
+		maxrsspg = mm->hiwater_rss;
+	sockkb = K(account_for_socket_buffers(task, &incomp));
+	text = (PAGE_ALIGN(mm->end_code) -
+		 (mm->start_code & PAGE_MASK));
+	text = min(text, mm->exec_vm << PAGE_SHIFT);
+	textkb = text >> 10;
+	libkb = ((mm->exec_vm << PAGE_SHIFT) - text) >> 10;
+	pgtblkb = pgtbl >> 10;
+	tstate = get_task_state(task, task->state);
+	time_format(task, c_utime, c_stime);
+
+	pr_info("[%7d] %7d %7d %7d %7d %c %9s %9s %9lu %9lu %9lu %9lu %9ld %9lu%c %9lu %9lu %9lu %9lu %9lu %9lu %11lu %11lu %9lu %9llu  %5hd %s\n",
+		task->pid, task_ppid_nr(task), ruid.val, euid.val, task->tgid,
+		tstate, c_utime, c_stime, vmkb, K(maxrsspg), K(rsspg), pgtblkb,
+		K(swappg), sockkb, incomp, libkb, textkb, K(mm->data_vm),
+		K(mm->stack_vm), K(get_mm_counter(mm, MM_FILEPAGES)),
+		K(get_mm_counter(mm, MM_SHMEMPAGES)), task->signal->cmaj_flt,
+		task->signal->cmin_flt,
+		K(mm->locked_vm), K((u64)atomic64_read(&mm->pinned_vm)),
+		task->signal->oom_score_adj, task->comm);
+}
+#endif /* CONFIG_DEBUG_OOM_ENHANCED_PROCESS_PRINT */
+
 static void __init oom_debug_init(void)
 {
 	/* Ensure we have a debugfs oom root directory */
diff --git a/mm/oom_kill_debug.h b/mm/oom_kill_debug.h
index a39bc275980e..faebb4c6097c 100644
--- a/mm/oom_kill_debug.h
+++ b/mm/oom_kill_debug.h
@@ -9,6 +9,11 @@
 #ifndef __MM_OOM_KILL_DEBUG_H__
 #define __MM_OOM_KILL_DEBUG_H__
 
+#ifdef CONFIG_DEBUG_OOM_ENHANCED_PROCESS_PRINT
+extern bool oom_kill_debug_enhanced_process_print_enabled(void);
+extern void dump_task_prt(struct task_struct *task, unsigned long rsspg,
+			  unsigned long swappg, unsigned long pgtbl);
+#endif
 #ifdef CONFIG_DEBUG_OOM_PROCESS_SELECT_PRINT
 extern unsigned long oom_kill_debug_min_task_pages(unsigned long totalpages);
 #endif
-- 
2.20.1

