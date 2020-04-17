Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E9F1AD647
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 08:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgDQGmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 02:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728210AbgDQGmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 02:42:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5C7C061A0C;
        Thu, 16 Apr 2020 23:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ok/T6f00mRwkZnYv/iXe2ICHaiF/AV6gzPr72akuPj0=; b=ToFzdsC6uzf2JAkxt30vYl2bJQ
        +MruH+hIRzqzP+FiS8jy+ivTVSxPh/jnZyirdrC7wCLXZ5to4pAkYLhoOZSpfdXRPV/AFcsm1xeB8
        3uTAsQTLG0JTPyDqbKrNU6+N3CaoftzVEZCpsCeFmsqrNg69a7a/XaaXuue67ApBs9eWr2QTslZJM
        lnegZHKi1Sz2A3SGWz1NLYnvWkBLfgbBM8pa/7eBYhAVPb6Q7I+luiRbKo8gxC0FjcmPfQdP4rO6k
        76JOtJm1e97Aegble2q5AcR1GWwJv+8MxyeIPIdwHc2ib3s7AzkBlrZNeObZ8jMofCFIoY9ShgQwO
        +vXVjhxw==;
Received: from [2001:4bb8:184:4aa1:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPKhM-0002iW-IB; Fri, 17 Apr 2020 06:42:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 4/6] sysctl: remove all extern declaration from sysctl.c
Date:   Fri, 17 Apr 2020 08:41:44 +0200
Message-Id: <20200417064146.1086644-5-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200417064146.1086644-1-hch@lst.de>
References: <20200417064146.1086644-1-hch@lst.de>
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
 include/linux/coredump.h |  6 ++++++
 include/linux/file.h     |  2 ++
 include/linux/mm.h       |  2 ++
 include/linux/mmzone.h   |  2 ++
 include/linux/sysctl.h   |  8 +++++++
 kernel/sysctl.c          | 45 +++-------------------------------------
 6 files changed, 23 insertions(+), 42 deletions(-)

diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index abf4b4e65dbb..0fe8f3131e97 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -22,4 +22,10 @@ extern void do_coredump(const kernel_siginfo_t *siginfo);
 static inline void do_coredump(const kernel_siginfo_t *siginfo) {}
 #endif
 
+extern int core_uses_pid;
+extern char core_pattern[];
+extern unsigned int core_pipe_limit;
+extern int pid_max;
+extern int pid_max_min, pid_max_max;
+
 #endif /* _LINUX_COREDUMP_H */
diff --git a/include/linux/file.h b/include/linux/file.h
index 142d102f285e..122f80084a3e 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -94,4 +94,6 @@ extern void fd_install(unsigned int fd, struct file *file);
 extern void flush_delayed_fput(void);
 extern void __fput_sync(struct file *);
 
+extern unsigned int sysctl_nr_open_min, sysctl_nr_open_max;
+
 #endif /* __LINUX_FILE_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5a323422d783..9c4e7e76dedd 100644
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
index f37bb8f187fc..b2af594ef0f7 100644
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
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 02fa84493f23..36143ca40b56 100644
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
index 99d27acf4646..31b934865ebc 100644
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
2.25.1

