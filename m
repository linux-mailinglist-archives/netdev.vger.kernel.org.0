Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA76465F2A
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbhLBIQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 03:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238808AbhLBIQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 03:16:25 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6898BC061574
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 00:13:02 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id e136so70876292ybc.4
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 00:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TaTwUOrVIlvT6DO9TV98Dy6Gpsa9XZdqFpvDVno6hSQ=;
        b=GqeajfBznKPXXOx7UXkTDCiuqRdDSysZqCVhmGuxyn9tLMTnpupzByEGnorGfZEIn6
         /PShPthHXQOIgEacwJlS3mR1g/xb27xbG8aEqV59blH/LQ8AGqqQa3EFSewxG0cS0v/X
         89Ypa5zBHqx/03DD98Rw+4UT+YU129ZTh333dDUL6Q8kma8XqvpAawWvQgyfk0SbHYcs
         RAbFJ04Ewn+0Z+WBFwE5TlgMNRbDsmwVwSls8eO+QVhYh9UoUbXcs4M3qh922zR/yCz+
         FMX2Yt+ZVVLyL+0lpj3hyyg/pWWHF/X0VF9wo5P+zTqpO2B5y/C8eJwFC4hjdMWq7ccF
         bMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TaTwUOrVIlvT6DO9TV98Dy6Gpsa9XZdqFpvDVno6hSQ=;
        b=5Qp4G4nSKQUN+e/KNFrbUcI3eoRfkGqmaTk+ijP38cYoTWrA8vn8SSSIUICzJ3j5F9
         7m7ESQe0ITY2cXESYAAX4ZpH5dW6eTjkia9RPDIGiiAg7bNcdaiOWoyV3KIywcvXos3b
         XLc1tp3xxDF7SU78xJaoOowwWRpVR607uFTHVa23+56Hcb/PNoV8dS4WyH6TTyiXuqnT
         E7YEq4rv5hpElQkFgsD2+qFYm5MvaftTTtJeNB3uNEnSYgf0bLsDXud68hFqvp5lPz9I
         mFmJlvMvPH5+1vze2zH6xORamSGBvdBOA2H54MGOnvvp6jnRggxFM9yifqC/EAPzmmWj
         FVLQ==
X-Gm-Message-State: AOAM533Dv5vcTgt0vgblYdDwnH3HI3BHTryN2KJQIgJyzQlm+lNsEayc
        rEHsU7E2yg5SdpSz4LdcrcqUF8lkFCpQfY0XJUSX9Q==
X-Google-Smtp-Source: ABdhPJxWVXdSgUsRWT1nMV2IJr+6pGu8FPYg9rrrircTvgVZPlAOY03cJhTEA46lOUL7iWKQ15QQklrpSqYuJaMiCP0=
X-Received: by 2002:a25:3b11:: with SMTP id i17mr13840380yba.259.1638432781261;
 Thu, 02 Dec 2021 00:13:01 -0800 (PST)
MIME-Version: 1.0
References: <20211202032139.3156411-1-eric.dumazet@gmail.com> <20211202032139.3156411-2-eric.dumazet@gmail.com>
In-Reply-To: <20211202032139.3156411-2-eric.dumazet@gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 2 Dec 2021 09:12:49 +0100
Message-ID: <CACT4Y+ZUOZsuK84tiwWt62EFySAgVO0A2FnYyU5aBoxosSO9xA@mail.gmail.com>
Subject: Re: [PATCH net-next 01/19] lib: add reference counting tracking infrastructure
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Dec 2021 at 04:21, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> It can be hard to track where references are taken and released.
>
> In networking, we have annoying issues at device or netns dismantles,
> and we had various proposals to ease root causing them.
>
> This patch adds new infrastructure pairing refcount increases
> and decreases. This will self document code, because programmers
> will have to associate increments/decrements.
>
> This is controled by CONFIG_REF_TRACKER which can be selected
> by users of this feature.
>
> This adds both cpu and memory costs, and thus should probably be
> used with care.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>


Reviewed-by: Dmitry Vyukov <dvyukov@google.com>


> ---
>  include/linux/ref_tracker.h |  73 +++++++++++++++++++
>  lib/Kconfig                 |   4 ++
>  lib/Makefile                |   2 +
>  lib/ref_tracker.c           | 140 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 219 insertions(+)
>  create mode 100644 include/linux/ref_tracker.h
>  create mode 100644 lib/ref_tracker.c
>
> diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
> new file mode 100644
> index 0000000000000000000000000000000000000000..c11c9db5825cf933acf529c83db441a818135f29
> --- /dev/null
> +++ b/include/linux/ref_tracker.h
> @@ -0,0 +1,73 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +#ifndef _LINUX_REF_TRACKER_H
> +#define _LINUX_REF_TRACKER_H
> +#include <linux/refcount.h>
> +#include <linux/types.h>
> +#include <linux/spinlock.h>
> +
> +struct ref_tracker;
> +
> +struct ref_tracker_dir {
> +#ifdef CONFIG_REF_TRACKER
> +       spinlock_t              lock;
> +       unsigned int            quarantine_avail;
> +       refcount_t              untracked;
> +       struct list_head        list; /* List of active trackers */
> +       struct list_head        quarantine; /* List of dead trackers */
> +#endif
> +};
> +
> +#ifdef CONFIG_REF_TRACKER
> +static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
> +                                       unsigned int quarantine_count)
> +{
> +       INIT_LIST_HEAD(&dir->list);
> +       INIT_LIST_HEAD(&dir->quarantine);
> +       spin_lock_init(&dir->lock);
> +       dir->quarantine_avail = quarantine_count;
> +       refcount_set(&dir->untracked, 1);
> +}
> +
> +void ref_tracker_dir_exit(struct ref_tracker_dir *dir);
> +
> +void ref_tracker_dir_print(struct ref_tracker_dir *dir,
> +                          unsigned int display_limit);
> +
> +int ref_tracker_alloc(struct ref_tracker_dir *dir,
> +                     struct ref_tracker **trackerp, gfp_t gfp);
> +
> +int ref_tracker_free(struct ref_tracker_dir *dir,
> +                    struct ref_tracker **trackerp);
> +
> +#else /* CONFIG_REF_TRACKER */
> +
> +static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
> +                                       unsigned int quarantine_count)
> +{
> +}
> +
> +static inline void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
> +{
> +}
> +
> +static inline void ref_tracker_dir_print(struct ref_tracker_dir *dir,
> +                                        unsigned int display_limit)
> +{
> +}
> +
> +static inline int ref_tracker_alloc(struct ref_tracker_dir *dir,
> +                                   struct ref_tracker **trackerp,
> +                                   gfp_t gfp)
> +{
> +       return 0;
> +}
> +
> +static inline int ref_tracker_free(struct ref_tracker_dir *dir,
> +                                  struct ref_tracker **trackerp)
> +{
> +       return 0;
> +}
> +
> +#endif
> +
> +#endif /* _LINUX_REF_TRACKER_H */
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 5e7165e6a346c9bec878b78c8c8c3d175fc98dfd..d01be8e9593992a7d94a46bd1716460bc33c3ae1 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -680,6 +680,10 @@ config STACK_HASH_ORDER
>          Select the hash size as a power of 2 for the stackdepot hash table.
>          Choose a lower value to reduce the memory impact.
>
> +config REF_TRACKER
> +       bool
> +       select STACKDEPOT
> +
>  config SBITMAP
>         bool
>
> diff --git a/lib/Makefile b/lib/Makefile
> index 364c23f1557816f73aebd8304c01224a4846ac6c..c1fd9243ddb9cc1ac5252d7eb8009f9290782c4a 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -270,6 +270,8 @@ obj-$(CONFIG_STACKDEPOT) += stackdepot.o
>  KASAN_SANITIZE_stackdepot.o := n
>  KCOV_INSTRUMENT_stackdepot.o := n
>
> +obj-$(CONFIG_REF_TRACKER) += ref_tracker.o
> +
>  libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o \
>                fdt_empty_tree.o fdt_addresses.o
>  $(foreach file, $(libfdt_files), \
> diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..0ae2e66dcf0fdb976f4cb99e747c9448b37f22cc
> --- /dev/null
> +++ b/lib/ref_tracker.c
> @@ -0,0 +1,140 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +#include <linux/export.h>
> +#include <linux/ref_tracker.h>
> +#include <linux/slab.h>
> +#include <linux/stacktrace.h>
> +#include <linux/stackdepot.h>
> +
> +#define REF_TRACKER_STACK_ENTRIES 16
> +
> +struct ref_tracker {
> +       struct list_head        head;   /* anchor into dir->list or dir->quarantine */
> +       bool                    dead;
> +       depot_stack_handle_t    alloc_stack_handle;
> +       depot_stack_handle_t    free_stack_handle;
> +};
> +
> +void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
> +{
> +       struct ref_tracker *tracker, *n;
> +       unsigned long flags;
> +       bool leak = false;
> +
> +       spin_lock_irqsave(&dir->lock, flags);
> +       list_for_each_entry_safe(tracker, n, &dir->quarantine, head) {
> +               list_del(&tracker->head);
> +               kfree(tracker);
> +               dir->quarantine_avail++;
> +       }
> +       list_for_each_entry_safe(tracker, n, &dir->list, head) {
> +               pr_err("leaked reference.\n");
> +               if (tracker->alloc_stack_handle)
> +                       stack_depot_print(tracker->alloc_stack_handle);
> +               leak = true;
> +               list_del(&tracker->head);
> +               kfree(tracker);
> +       }
> +       spin_unlock_irqrestore(&dir->lock, flags);
> +       WARN_ON_ONCE(leak);
> +       WARN_ON_ONCE(refcount_read(&dir->untracked) != 1);
> +}
> +EXPORT_SYMBOL(ref_tracker_dir_exit);
> +
> +void ref_tracker_dir_print(struct ref_tracker_dir *dir,
> +                          unsigned int display_limit)
> +{
> +       struct ref_tracker *tracker;
> +       unsigned long flags;
> +       unsigned int i = 0;
> +
> +       spin_lock_irqsave(&dir->lock, flags);
> +       list_for_each_entry(tracker, &dir->list, head) {
> +               if (i < display_limit) {
> +                       pr_err("leaked reference.\n");
> +                       if (tracker->alloc_stack_handle)
> +                               stack_depot_print(tracker->alloc_stack_handle);
> +                       i++;
> +               } else {
> +                       break;
> +               }
> +       }
> +       spin_unlock_irqrestore(&dir->lock, flags);
> +}
> +EXPORT_SYMBOL(ref_tracker_dir_print);
> +
> +int ref_tracker_alloc(struct ref_tracker_dir *dir,
> +                     struct ref_tracker **trackerp,
> +                     gfp_t gfp)
> +{
> +       unsigned long entries[REF_TRACKER_STACK_ENTRIES];
> +       struct ref_tracker *tracker;
> +       unsigned int nr_entries;
> +       unsigned long flags;
> +
> +       *trackerp = tracker = kzalloc(sizeof(*tracker), gfp | __GFP_NOFAIL);
> +       if (unlikely(!tracker)) {
> +               pr_err_once("memory allocation failure, unreliable refcount tracker.\n");
> +               refcount_inc(&dir->untracked);
> +               return -ENOMEM;
> +       }
> +       nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
> +       nr_entries = filter_irq_stacks(entries, nr_entries);
> +       tracker->alloc_stack_handle = stack_depot_save(entries, nr_entries, gfp);
> +
> +       spin_lock_irqsave(&dir->lock, flags);
> +       list_add(&tracker->head, &dir->list);
> +       spin_unlock_irqrestore(&dir->lock, flags);
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(ref_tracker_alloc);
> +
> +int ref_tracker_free(struct ref_tracker_dir *dir,
> +                    struct ref_tracker **trackerp)
> +{
> +       unsigned long entries[REF_TRACKER_STACK_ENTRIES];
> +       struct ref_tracker *tracker = *trackerp;
> +       depot_stack_handle_t stack_handle;
> +       unsigned int nr_entries;
> +       unsigned long flags;
> +
> +       if (!tracker) {
> +               refcount_dec(&dir->untracked);

Nice approach.

> +               return -EEXIST;
> +       }
> +       nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
> +       nr_entries = filter_irq_stacks(entries, nr_entries);

Marco sent a patch to do this as part of stack_depot_save() as we spoke:
https://lore.kernel.org/lkml/20211130095727.2378739-1-elver@google.com/
I am not sure in what order these patches will reach trees, but
ultimately filter_irq_stacks() won't be needed here anymore...

> +       stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);
> +
> +       spin_lock_irqsave(&dir->lock, flags);
> +       if (tracker->dead) {
> +               pr_err("reference already released.\n");
> +               if (tracker->alloc_stack_handle) {
> +                       pr_err("allocated in:\n");
> +                       stack_depot_print(tracker->alloc_stack_handle);
> +               }
> +               if (tracker->free_stack_handle) {
> +                       pr_err("freed in:\n");
> +                       stack_depot_print(tracker->free_stack_handle);
> +               }
> +               spin_unlock_irqrestore(&dir->lock, flags);
> +               WARN_ON_ONCE(1);
> +               return -EINVAL;
> +       }
> +       tracker->dead = true;
> +
> +       tracker->free_stack_handle = stack_handle;
> +
> +       list_move_tail(&tracker->head, &dir->quarantine);
> +       if (!dir->quarantine_avail) {
> +               tracker = list_first_entry(&dir->quarantine, struct ref_tracker, head);
> +               list_del(&tracker->head);
> +       } else {
> +               dir->quarantine_avail--;
> +               tracker = NULL;
> +       }
> +       spin_unlock_irqrestore(&dir->lock, flags);
> +
> +       kfree(tracker);
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(ref_tracker_free);
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
