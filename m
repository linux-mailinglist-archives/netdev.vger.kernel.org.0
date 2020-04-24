Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BF91B6E52
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 08:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgDXGny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 02:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726698AbgDXGnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 02:43:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601FEC09B045;
        Thu, 23 Apr 2020 23:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wDEsYStynWhsUFcoHz/u9cJV2oOwZ01DZ19l8vEDOnA=; b=Pb7GxTWZvrN0QfDT3trhg4dHja
        Wza06KbuV1LLIhTqUf9vD1FqNZ5EDxET87WSr4LGS4nDlrJMsIS398Cb34eJ8ewO8bdtGglq7/ICo
        tQtnmpTn/AmTFAilxNdS6yWd6wmeHpf9Gad2oriHpcgy7V0WcrDprJ3ur7nMou4lKa0MUL1lYU0zG
        v1gZzLUWYNKvoF54qNM5D4MidEzmCIb8Ykjo1NFhCNpvwUTcekytvS6cSev/91bLNJ1KWp9P290tM
        ju9LyRftpd3tI0Qd49IEwgG0/8pjw8JM4CRKGjVTiMDy7qnG+WP8XbdKWd78DokEwgyKG2J2hBrMW
        1dNjq+aw==;
Received: from [2001:4bb8:193:f203:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRs3x-00014P-4p; Fri, 24 Apr 2020 06:43:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 3/5] sysctl: remove all extern declaration from sysctl.c
Date:   Fri, 24 Apr 2020 08:43:36 +0200
Message-Id: <20200424064338.538313-4-hch@lst.de>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200424064338.538313-1-hch@lst.de>
References: <20200424064338.538313-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extern declarations in .c files are a bad style and can lead to
mismatches.  Use existing definitions in headers where they exist,
and otherwise move the external declarations to suitable header
files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/coredump.h |  4 ++++
 include/linux/file.h     |  2 ++
 include/linux/mm.h       |  2 ++
 include/linux/mmzone.h   |  2 ++
 include/linux/pid.h      |  3 +++
 include/linux/sysctl.h   |  8 +++++++
 kernel/sysctl.c          | 45 +++-------------------------------------
 7 files changed, 24 insertions(+), 42 deletions(-)

diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index abf4b4e65dbb9..7a899e83835d5 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -22,4 +22,8 @@ extern void do_coredump(const kernel_siginfo_t *siginfo);
 static inline void do_coredump(const kernel_siginfo_t *siginfo) {}
 #endif
 
+extern int core_uses_pid;
+extern char core_pattern[];
+extern unsigned int core_pipe_limit;
+
 #endif /* _LINUX_COREDUMP_H */
diff --git a/include/linux/file.h b/include/linux/file.h
index 142d102f285e5..122f80084a3ef 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -94,4 +94,6 @@ extern void fd_install(unsigned int fd, struct file *file);
 extern void flush_delayed_fput(void);
 extern void __fput_sync(struct file *);
 
+extern unsigned int sysctl_nr_open_min, sysctl_nr_open_max;
+
 #endif /* __LINUX_FILE_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5a323422d783d..9c4e7e76deddc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3140,5 +3140,7 @@ unsigned long wp_shared_mapping_range(struct address_space *mapping,
 				      pgoff_t first_index, pgoff_t nr);
 #endif
 
+extern int sysctl_nr_trim_pages;
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f37bb8f187fc7..b2af594ef0f7c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -909,6 +909,7 @@ static inline int is_highmem(struct zone *zone)
 
 /* These two functions are used to setup the per zone pages min values */
 struct ctl_table;
+
 int min_free_kbytes_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 int watermark_scale_factor_sysctl_handler(struct ctl_table *, int,
@@ -925,6 +926,7 @@ int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *, int,
 
 extern int numa_zonelist_order_handler(struct ctl_table *, int,
 			void __user *, size_t *, loff_t *);
+extern int percpu_pagelist_fraction;
 extern char numa_zonelist_order[];
 #define NUMA_ZONELIST_ORDER_LEN	16
 
diff --git a/include/linux/pid.h b/include/linux/pid.h
index cc896f0fc4e34..93543cbc0e6b3 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -108,6 +108,9 @@ extern void transfer_pid(struct task_struct *old, struct task_struct *new,
 struct pid_namespace;
 extern struct pid_namespace init_pid_ns;
 
+extern int pid_max;
+extern int pid_max_min, pid_max_max;
+
 /*
  * look up a PID in the hash table. Must be called with the tasklist_lock
  * or rcu_read_lock() held.
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 02fa84493f237..36143ca40b56b 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -207,7 +207,15 @@ void unregister_sysctl_table(struct ctl_table_header * table);
 
 extern int sysctl_init(void);
 
+extern int pwrsw_enabled;
+extern int unaligned_enabled;
+extern int unaligned_dump_stack;
+extern int no_unaligned_warning;
+
 extern struct ctl_table sysctl_mount_point[];
+extern struct ctl_table random_table[];
+extern struct ctl_table firmware_config_table[];
+extern struct ctl_table epoll_table[];
 
 #else /* CONFIG_SYSCTL */
 static inline struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 99d27acf46465..31b934865ebc3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -68,6 +68,9 @@
 #include <linux/bpf.h>
 #include <linux/mount.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/coredump.h>
+#include <linux/latencytop.h>
+#include <linux/pid.h>
 
 #include "../lib/kstrtox.h"
 
@@ -103,22 +106,6 @@
 
 #if defined(CONFIG_SYSCTL)
 
-/* External variables not in a header file. */
-extern int suid_dumpable;
-#ifdef CONFIG_COREDUMP
-extern int core_uses_pid;
-extern char core_pattern[];
-extern unsigned int core_pipe_limit;
-#endif
-extern int pid_max;
-extern int pid_max_min, pid_max_max;
-extern int percpu_pagelist_fraction;
-extern int latencytop_enabled;
-extern unsigned int sysctl_nr_open_min, sysctl_nr_open_max;
-#ifndef CONFIG_MMU
-extern int sysctl_nr_trim_pages;
-#endif
-
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_LOCKUP_DETECTOR
 static int sixty = 60;
@@ -160,24 +147,6 @@ static unsigned long hung_task_timeout_max = (LONG_MAX/HZ);
 #ifdef CONFIG_INOTIFY_USER
 #include <linux/inotify.h>
 #endif
-#ifdef CONFIG_SPARC
-#endif
-
-#ifdef CONFIG_PARISC
-extern int pwrsw_enabled;
-#endif
-
-#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_ALLOW
-extern int unaligned_enabled;
-#endif
-
-#ifdef CONFIG_IA64
-extern int unaligned_dump_stack;
-#endif
-
-#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_NO_WARN
-extern int no_unaligned_warning;
-#endif
 
 #ifdef CONFIG_PROC_SYSCTL
 
@@ -243,14 +212,6 @@ static struct ctl_table vm_table[];
 static struct ctl_table fs_table[];
 static struct ctl_table debug_table[];
 static struct ctl_table dev_table[];
-extern struct ctl_table random_table[];
-#ifdef CONFIG_EPOLL
-extern struct ctl_table epoll_table[];
-#endif
-
-#ifdef CONFIG_FW_LOADER_USER_HELPER
-extern struct ctl_table firmware_config_table[];
-#endif
 
 #if defined(HAVE_ARCH_PICK_MMAP_LAYOUT) || \
     defined(CONFIG_ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT)
-- 
2.26.1

