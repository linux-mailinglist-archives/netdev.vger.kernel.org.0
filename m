Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7708560EE1F
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 04:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbiJ0CyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 22:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234106AbiJ0CyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 22:54:19 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4BE147D10
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 19:54:12 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id t10-20020a17090a4e4a00b0020af4bcae10so183546pjl.3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 19:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3uDzj3xfoqua/ReBQcTFPxgbHPXWlBiMpS7ZejnRM0Q=;
        b=4Eylhn+7+ibRf+ZpoLNfl1xWoM/yIjNPedJrB82jdccOprR5LGAT5zd5Neh/3bcMV1
         8PTL4g1XORCtjwfjjM8eZjO91WGc5Sa9dTu9um3/Dzmg29cHkBeK2YRh1nNhsV0+lnx4
         /h2a1cyXTDUE/myxdkDFplbuYO0NF22lmivCvNZ1z2Hf4+bbSDR2J1dyl5t3hg31WK21
         DbO7ZAzVqZEJTv3ISiZeYOij8tr4n4iI1Lu2u2aihnxy5nFLjb15DstiOndEZCrqqnOs
         LKSh6qLark3An7QWz7+RDHmmYQf+5ifHwl6DyOgxtyzeLnZh5NAkjEkGUwfW7ucJ14wI
         pUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3uDzj3xfoqua/ReBQcTFPxgbHPXWlBiMpS7ZejnRM0Q=;
        b=XKUkwzHcH6aPl1r4GzuCErp0dqyorSE+u3W12wqygM5f5HJcxInR2E9hPzz4Skwux7
         hj/Svnk6PVKr96CQJyR8o4Dsu0I8d+pAg/z26z4WcUiy1RI1snVvpue4sYsBrObl3F+c
         Hp/f/R3mUBUk57zvo8BDg9TKIlqL0uvg09bZzyvccyzON6CY22DNkAXWZM/UgGL7QhQo
         WQMe/OW0y9+wmyeJK6CSOlo4zf7vD+x4iC8n2AjixMXgcOcqTov+lL5Y+1ipr9i+I73l
         kVSHIKCCenJWOgM90Im5zp2MFzvV/6A+HKUJSxIIrRdcUKiUufaCUHBSqwUkG90tbq7C
         2TEw==
X-Gm-Message-State: ACrzQf05vz1ik9MAOZ9IaiLW9LNmtiEg62WlEIvwbK3xPuwLe9nKgNsq
        X6Q6mwpnjlETCIpBlue7918pSA==
X-Google-Smtp-Source: AMsMyM7voE4RrfzGTYSyChsln1Sy6eKR8E94edHCJUVA0dL+cwvzM0+ZyIR6IvaSA+JqofhQMyJZaw==
X-Received: by 2002:a17:90b:4b4a:b0:213:35c:bf7 with SMTP id mi10-20020a17090b4b4a00b00213035c0bf7mr7551157pjb.14.1666839252279;
        Wed, 26 Oct 2022 19:54:12 -0700 (PDT)
Received: from C02FT5A6MD6R.bytedance.net ([61.120.150.75])
        by smtp.gmail.com with ESMTPSA id o1-20020aa79781000000b0056b6a22d6c9sm79783pfp.212.2022.10.26.19.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 19:54:11 -0700 (PDT)
From:   Gang Li <ligang.bdlg@bytedance.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Gang Li <ligang.bdlg@bytedance.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v5 2/2] sched/numa: add per-process numa_balancing
Date:   Thu, 27 Oct 2022 10:53:02 +0800
Message-Id: <20221027025302.45766-3-ligang.bdlg@bytedance.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20221027025302.45766-1-ligang.bdlg@bytedance.com>
References: <20221027025302.45766-1-ligang.bdlg@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PR_NUMA_BALANCING in prctl.

A large number of page faults will cause performance loss when numa
balancing is performing. Thus those processes which care about worst-case
performance need numa balancing disabled. Others, on the contrary, allow a
temporary performance loss in exchange for higher average performance, so
enable numa balancing is better for them.

Numa balancing can only be controlled globally by
/proc/sys/kernel/numa_balancing. Due to the above case, we want to
disable/enable numa_balancing per-process instead.

Set per-process numa balancing:
	prctl(PR_NUMA_BALANCING, PR_SET_NUMA_BALANCING_DISABLE); //disable
	prctl(PR_NUMA_BALANCING, PR_SET_NUMA_BALANCING_ENABLE);  //enable
	prctl(PR_NUMA_BALANCING, PR_SET_NUMA_BALANCING_DEFAULT); //follow global
Get numa_balancing state:
	prctl(PR_NUMA_BALANCING, PR_GET_NUMA_BALANCING, &ret);
	cat /proc/<pid>/status | grep NumaB_mode

Cc: linux-api@vger.kernel.org
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
---
 Documentation/filesystems/proc.rst   |  2 ++
 fs/proc/task_mmu.c                   | 20 ++++++++++++
 include/linux/mm_types.h             |  3 ++
 include/linux/sched/numa_balancing.h | 45 ++++++++++++++++++++++++++
 include/uapi/linux/prctl.h           |  7 +++++
 kernel/fork.c                        |  4 +++
 kernel/sched/fair.c                  |  9 +++---
 kernel/sys.c                         | 47 ++++++++++++++++++++++++++++
 mm/mprotect.c                        |  6 ++--
 9 files changed, 137 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index ec6cfdf1796a..e7f058c4e906 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -193,6 +193,7 @@ read the file /proc/PID/status::
   VmLib:      1412 kB
   VmPTE:        20 kb
   VmSwap:        0 kB
+  NumaB_mode:  default
   HugetlbPages:          0 kB
   CoreDumping:    0
   THP_enabled:	  1
@@ -274,6 +275,7 @@ It's slow but very precise.
  VmPTE                       size of page table entries
  VmSwap                      amount of swap used by anonymous private data
                              (shmem swap usage is not included)
+ NumaB_mode                  numa balancing mode, set by prctl(PR_NUMA_BALANCING, ...)
  HugetlbPages                size of hugetlb memory portions
  CoreDumping                 process's memory is currently being dumped
                              (killing the process may lead to a corrupted core)
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 8a74cdcc9af0..835b68ec218b 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -19,6 +19,8 @@
 #include <linux/shmem_fs.h>
 #include <linux/uaccess.h>
 #include <linux/pkeys.h>
+#include <linux/sched/numa_balancing.h>
+#include <linux/prctl.h>
 
 #include <asm/elf.h>
 #include <asm/tlb.h>
@@ -75,6 +77,24 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
 		    " kB\nVmPTE:\t", mm_pgtables_bytes(mm) >> 10, 8);
 	SEQ_PUT_DEC(" kB\nVmSwap:\t", swap);
 	seq_puts(m, " kB\n");
+#ifdef CONFIG_NUMA_BALANCING
+	seq_puts(m, "NumaB_mode:\t");
+	switch (mm->numa_balancing_mode) {
+	case PR_SET_NUMA_BALANCING_DEFAULT:
+		seq_puts(m, "default");
+		break;
+	case PR_SET_NUMA_BALANCING_DISABLED:
+		seq_puts(m, "disabled");
+		break;
+	case PR_SET_NUMA_BALANCING_ENABLED:
+		seq_puts(m, "enabled");
+		break;
+	default:
+		seq_puts(m, "unknown");
+		break;
+	}
+	seq_putc(m, '\n');
+#endif
 	hugetlb_report_usage(m, mm);
 }
 #undef SEQ_PUT_DEC
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a82f06ab18a1..b789acf1f69c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -679,6 +679,9 @@ struct mm_struct {
 
 		/* numa_scan_seq prevents two threads remapping PTEs. */
 		int numa_scan_seq;
+
+		/* Controls whether NUMA balancing is active for this mm. */
+		int numa_balancing_mode;
 #endif
 		/*
 		 * An operation with batched TLB flushing is going on. Anything
diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index 3988762efe15..aa8629dfde45 100644
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -8,6 +8,8 @@
  */
 
 #include <linux/sched.h>
+#include <linux/sched/sysctl.h>
+#include <linux/prctl.h>
 
 #define TNF_MIGRATED	0x01
 #define TNF_NO_GROUP	0x02
@@ -16,12 +18,47 @@
 #define TNF_MIGRATE_FAIL 0x10
 
 #ifdef CONFIG_NUMA_BALANCING
+DECLARE_STATIC_KEY_FALSE(sched_numa_balancing);
 extern void task_numa_fault(int last_node, int node, int pages, int flags);
 extern pid_t task_numa_group_id(struct task_struct *p);
 extern void set_numabalancing_state(bool enabled);
 extern void task_numa_free(struct task_struct *p, bool final);
 extern bool should_numa_migrate_memory(struct task_struct *p, struct page *page,
 					int src_nid, int dst_cpu);
+static inline bool numa_balancing_enabled(struct task_struct *p)
+{
+	if (!static_branch_unlikely(&sched_numa_balancing))
+		return false;
+
+	if (p->mm) switch (p->mm->numa_balancing_mode) {
+	case PR_SET_NUMA_BALANCING_ENABLED:
+		return true;
+	case PR_SET_NUMA_BALANCING_DISABLED:
+		return false;
+	default:
+		break;
+	}
+
+	return sysctl_numa_balancing_mode;
+}
+static inline int numa_balancing_mode(struct mm_struct *mm)
+{
+	if (!static_branch_unlikely(&sched_numa_balancing))
+		return PR_SET_NUMA_BALANCING_DISABLED;
+
+	if (mm) switch (mm->numa_balancing_mode) {
+	case PR_SET_NUMA_BALANCING_ENABLED:
+		return sysctl_numa_balancing_mode == NUMA_BALANCING_DISABLED ?
+			NUMA_BALANCING_NORMAL : sysctl_numa_balancing_mode;
+	case PR_SET_NUMA_BALANCING_DISABLED:
+		return NUMA_BALANCING_DISABLED;
+	case PR_SET_NUMA_BALANCING_DEFAULT:
+	default:
+		break;
+	}
+
+	return sysctl_numa_balancing_mode;
+}
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   int flags)
@@ -42,6 +79,14 @@ static inline bool should_numa_migrate_memory(struct task_struct *p,
 {
 	return true;
 }
+static inline int numa_balancing_mode(struct mm_struct *mm)
+{
+	return 0;
+}
+static inline bool numa_balancing_enabled(struct task_struct *p)
+{
+	return 0;
+}
 #endif
 
 #endif /* _LINUX_SCHED_NUMA_BALANCING_H */
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index a5e06dcbba13..25477fe0b4ef 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -284,4 +284,11 @@ struct prctl_mm_map {
 #define PR_SET_VMA		0x53564d41
 # define PR_SET_VMA_ANON_NAME		0
 
+/* Set/get enabled per-process numa_balancing */
+#define PR_NUMA_BALANCING		65
+# define PR_SET_NUMA_BALANCING_DISABLED	0
+# define PR_SET_NUMA_BALANCING_ENABLED	1
+# define PR_SET_NUMA_BALANCING_DEFAULT	2
+# define PR_GET_NUMA_BALANCING		3
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index cfb09ca1b1bc..7811fa5e098d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -97,6 +97,7 @@
 #include <linux/scs.h>
 #include <linux/io_uring.h>
 #include <linux/bpf.h>
+#include <linux/prctl.h>
 
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
@@ -1133,6 +1134,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	init_tlb_flush_pending(mm);
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
 	mm->pmd_huge_pte = NULL;
+#endif
+#ifdef CONFIG_NUMA_BALANCING
+	mm->numa_balancing_mode = PR_SET_NUMA_BALANCING_DEFAULT;
 #endif
 	mm_init_uprobes_state(mm);
 	hugetlb_count_init(mm);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e4a0b8bd941c..94fd6f48fd45 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -47,6 +47,7 @@
 #include <linux/psi.h>
 #include <linux/ratelimit.h>
 #include <linux/task_work.h>
+#include <linux/prctl.h>
 
 #include <asm/switch_to.h>
 
@@ -2830,7 +2831,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	struct numa_group *ng;
 	int priv;
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!numa_balancing_enabled(p))
 		return;
 
 	/* for example, ksmd faulting in a user's mm */
@@ -3151,7 +3152,7 @@ static void update_scan_period(struct task_struct *p, int new_cpu)
 	int src_nid = cpu_to_node(task_cpu(p));
 	int dst_nid = cpu_to_node(new_cpu);
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!numa_balancing_enabled(p))
 		return;
 
 	if (!p->mm || !p->numa_faults || (p->flags & PF_EXITING))
@@ -7996,7 +7997,7 @@ static int migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 	unsigned long src_weight, dst_weight;
 	int src_nid, dst_nid, dist;
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!numa_balancing_enabled(p))
 		return -1;
 
 	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
@@ -11584,7 +11585,7 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 		entity_tick(cfs_rq, se, queued);
 	}
 
-	if (static_branch_unlikely(&sched_numa_balancing))
+	if (numa_balancing_enabled(curr))
 		task_tick_numa(rq, curr);
 
 	update_misfit_status(curr, rq);
diff --git a/kernel/sys.c b/kernel/sys.c
index 5fd54bf0e886..f683fb065bc7 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -60,6 +60,7 @@
 #include <linux/sched/coredump.h>
 #include <linux/sched/task.h>
 #include <linux/sched/cputime.h>
+#include <linux/sched/numa_balancing.h>
 #include <linux/rcupdate.h>
 #include <linux/uidgid.h>
 #include <linux/cred.h>
@@ -2104,6 +2105,35 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
 	return 0;
 }
 
+#ifdef CONFIG_NUMA_BALANCING
+static int prctl_pid_numa_balancing_write(int numa_balancing)
+{
+	int old_numa_balancing;
+
+	if (numa_balancing != PR_SET_NUMA_BALANCING_DEFAULT &&
+	    numa_balancing != PR_SET_NUMA_BALANCING_DISABLED &&
+	    numa_balancing != PR_SET_NUMA_BALANCING_ENABLED)
+		return -EINVAL;
+
+	old_numa_balancing = xchg(&current->mm->numa_balancing_mode, numa_balancing);
+
+	if (numa_balancing == old_numa_balancing)
+		return 0;
+
+	if (numa_balancing == 1)
+		static_branch_inc(&sched_numa_balancing);
+	else if (old_numa_balancing == 1)
+		static_branch_dec(&sched_numa_balancing);
+
+	return 0;
+}
+
+static int prctl_pid_numa_balancing_read(void)
+{
+	return current->mm->numa_balancing_mode;
+}
+#endif
+
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
@@ -2618,6 +2648,23 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		error = set_syscall_user_dispatch(arg2, arg3, arg4,
 						  (char __user *) arg5);
 		break;
+#ifdef CONFIG_NUMA_BALANCING
+	case PR_NUMA_BALANCING:
+		switch (arg2) {
+		case PR_SET_NUMA_BALANCING_DEFAULT:
+		case PR_SET_NUMA_BALANCING_DISABLED:
+		case PR_SET_NUMA_BALANCING_ENABLED:
+			error = prctl_pid_numa_balancing_write((int)arg2);
+			break;
+		case PR_GET_NUMA_BALANCING:
+			error = put_user(prctl_pid_numa_balancing_read(), (int __user *)arg3);
+			break;
+		default:
+			error = -EINVAL;
+			break;
+		}
+		break;
+#endif
 #ifdef CONFIG_SCHED_CORE
 	case PR_SCHED_CORE:
 		error = sched_core_share_pid(arg2, arg3, arg4, arg5);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 99762403cc8f..968a389467d5 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -30,6 +30,7 @@
 #include <linux/mm_inline.h>
 #include <linux/pgtable.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/numa_balancing.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/memory-tiers.h>
 #include <asm/cacheflush.h>
@@ -158,10 +159,11 @@ static unsigned long change_pte_range(struct mmu_gather *tlb,
 				 * Skip scanning top tier node if normal numa
 				 * balancing is disabled
 				 */
-				if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
+				if (!(numa_balancing_mode(vma->vm_mm) & NUMA_BALANCING_NORMAL) &&
 				    toptier)
 					continue;
-				if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING &&
+				if (numa_balancing_mode(vma->vm_mm) &
+				    NUMA_BALANCING_MEMORY_TIERING &&
 				    !toptier)
 					xchg_page_access_time(page,
 						jiffies_to_msecs(jiffies));
-- 
2.20.1

