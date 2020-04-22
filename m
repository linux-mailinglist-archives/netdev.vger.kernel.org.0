Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEB71B3EB2
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 12:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbgDVKan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 06:30:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:33356 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731058AbgDVKa0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 06:30:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 96307AB5F;
        Wed, 22 Apr 2020 10:30:22 +0000 (UTC)
Subject: Re: [PATCH 3/5] sysctl: remove all extern declaration from sysctl.c
To:     Christoph Hellwig <hch@lst.de>, Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20200421171539.288622-1-hch@lst.de>
 <20200421171539.288622-4-hch@lst.de>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <13b10b87-6753-7e7c-fa56-20d7793250d6@suse.cz>
Date:   Wed, 22 Apr 2020 12:30:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200421171539.288622-4-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/20 7:15 PM, Christoph Hellwig wrote:
> Extern declarations in .c files are a bad style and can lead to
> mismatches.  Use existing definitions in headers where they exist,
> and otherwise move the external declarations to suitable header
> files.

Your cleanup reminds me of this Andrew's sigh from last week [1].
I'm not saying your series should do that too, just wondering if some of the
moves you are doing now would be better suited for the hypothetical new header
to avoid moving them again later (but I admit I haven't looked closer).

[1]
https://lore.kernel.org/linux-api/20200417174654.9af0c51afb5d9e35e5519113@linux-foundation.org/

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/coredump.h |  6 ++++++
>  include/linux/file.h     |  2 ++
>  include/linux/mm.h       |  2 ++
>  include/linux/mmzone.h   |  2 ++
>  include/linux/sysctl.h   |  8 +++++++
>  kernel/sysctl.c          | 45 +++-------------------------------------
>  6 files changed, 23 insertions(+), 42 deletions(-)
> 
> diff --git a/include/linux/coredump.h b/include/linux/coredump.h
> index abf4b4e65dbb..0fe8f3131e97 100644
> --- a/include/linux/coredump.h
> +++ b/include/linux/coredump.h
> @@ -22,4 +22,10 @@ extern void do_coredump(const kernel_siginfo_t *siginfo);
>  static inline void do_coredump(const kernel_siginfo_t *siginfo) {}
>  #endif
>  
> +extern int core_uses_pid;
> +extern char core_pattern[];
> +extern unsigned int core_pipe_limit;
> +extern int pid_max;
> +extern int pid_max_min, pid_max_max;
> +
>  #endif /* _LINUX_COREDUMP_H */
> diff --git a/include/linux/file.h b/include/linux/file.h
> index 142d102f285e..122f80084a3e 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -94,4 +94,6 @@ extern void fd_install(unsigned int fd, struct file *file);
>  extern void flush_delayed_fput(void);
>  extern void __fput_sync(struct file *);
>  
> +extern unsigned int sysctl_nr_open_min, sysctl_nr_open_max;
> +
>  #endif /* __LINUX_FILE_H */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5a323422d783..9c4e7e76dedd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3140,5 +3140,7 @@ unsigned long wp_shared_mapping_range(struct address_space *mapping,
>  				      pgoff_t first_index, pgoff_t nr);
>  #endif
>  
> +extern int sysctl_nr_trim_pages;
> +
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_MM_H */
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index f37bb8f187fc..b2af594ef0f7 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -909,6 +909,7 @@ static inline int is_highmem(struct zone *zone)
>  
>  /* These two functions are used to setup the per zone pages min values */
>  struct ctl_table;
> +
>  int min_free_kbytes_sysctl_handler(struct ctl_table *, int,
>  					void __user *, size_t *, loff_t *);
>  int watermark_scale_factor_sysctl_handler(struct ctl_table *, int,
> @@ -925,6 +926,7 @@ int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *, int,
>  
>  extern int numa_zonelist_order_handler(struct ctl_table *, int,
>  			void __user *, size_t *, loff_t *);
> +extern int percpu_pagelist_fraction;
>  extern char numa_zonelist_order[];
>  #define NUMA_ZONELIST_ORDER_LEN	16
>  
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 02fa84493f23..36143ca40b56 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -207,7 +207,15 @@ void unregister_sysctl_table(struct ctl_table_header * table);
>  
>  extern int sysctl_init(void);
>  
> +extern int pwrsw_enabled;
> +extern int unaligned_enabled;
> +extern int unaligned_dump_stack;
> +extern int no_unaligned_warning;
> +
>  extern struct ctl_table sysctl_mount_point[];
> +extern struct ctl_table random_table[];
> +extern struct ctl_table firmware_config_table[];
> +extern struct ctl_table epoll_table[];
>  
>  #else /* CONFIG_SYSCTL */
>  static inline struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 99d27acf4646..31b934865ebc 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -68,6 +68,9 @@
>  #include <linux/bpf.h>
>  #include <linux/mount.h>
>  #include <linux/userfaultfd_k.h>
> +#include <linux/coredump.h>
> +#include <linux/latencytop.h>
> +#include <linux/pid.h>
>  
>  #include "../lib/kstrtox.h"
>  
> @@ -103,22 +106,6 @@
>  
>  #if defined(CONFIG_SYSCTL)
>  
> -/* External variables not in a header file. */
> -extern int suid_dumpable;
> -#ifdef CONFIG_COREDUMP
> -extern int core_uses_pid;
> -extern char core_pattern[];
> -extern unsigned int core_pipe_limit;
> -#endif
> -extern int pid_max;
> -extern int pid_max_min, pid_max_max;
> -extern int percpu_pagelist_fraction;
> -extern int latencytop_enabled;
> -extern unsigned int sysctl_nr_open_min, sysctl_nr_open_max;
> -#ifndef CONFIG_MMU
> -extern int sysctl_nr_trim_pages;
> -#endif
> -
>  /* Constants used for minimum and  maximum */
>  #ifdef CONFIG_LOCKUP_DETECTOR
>  static int sixty = 60;
> @@ -160,24 +147,6 @@ static unsigned long hung_task_timeout_max = (LONG_MAX/HZ);
>  #ifdef CONFIG_INOTIFY_USER
>  #include <linux/inotify.h>
>  #endif
> -#ifdef CONFIG_SPARC
> -#endif
> -
> -#ifdef CONFIG_PARISC
> -extern int pwrsw_enabled;
> -#endif
> -
> -#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_ALLOW
> -extern int unaligned_enabled;
> -#endif
> -
> -#ifdef CONFIG_IA64
> -extern int unaligned_dump_stack;
> -#endif
> -
> -#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_NO_WARN
> -extern int no_unaligned_warning;
> -#endif
>  
>  #ifdef CONFIG_PROC_SYSCTL
>  
> @@ -243,14 +212,6 @@ static struct ctl_table vm_table[];
>  static struct ctl_table fs_table[];
>  static struct ctl_table debug_table[];
>  static struct ctl_table dev_table[];
> -extern struct ctl_table random_table[];
> -#ifdef CONFIG_EPOLL
> -extern struct ctl_table epoll_table[];
> -#endif
> -
> -#ifdef CONFIG_FW_LOADER_USER_HELPER
> -extern struct ctl_table firmware_config_table[];
> -#endif
>  
>  #if defined(HAVE_ARCH_PICK_MMAP_LAYOUT) || \
>      defined(CONFIG_ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT)
> 

