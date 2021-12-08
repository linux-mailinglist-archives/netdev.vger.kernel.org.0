Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBFC46D5A0
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbhLHOa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235110AbhLHOaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:30:55 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8005CC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 06:27:23 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso2881500ots.6
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 06:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gKEuWqDxaf+v8PlpTBRxSfkFLN0nNRDulAlwNZc2PaY=;
        b=LFBt4S/qOy2XvIe44iftTi62TWhwR7cohI0xSQ41kocjhxwhecnUKUOvI63xB21blv
         VSreyrzFbXXjesfkUT7Rpt4xPOoCkpMMP5zbTCrczGPJsDQ/7ED8bTSXSUc71YomXx8d
         63E/MZKInAlR855LNp44KIP5QUSjaH5vQRrbmpM0QxGjb/Py+7IaRB48OTnGlT46kUIN
         kB2wAUOAjcTTyHYi1mA/2K+ZFsUzuZc1tC/wDK+ttJwNL6rsFPvTkV9zMlD4DO0KIlu6
         vmgLRLM0+fYbJV1zPHyxat+3Hfnpqy1t0iTeskkaAlGo0/Nf1psCvPxxwwJp5MP23Nsr
         CfVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gKEuWqDxaf+v8PlpTBRxSfkFLN0nNRDulAlwNZc2PaY=;
        b=ctsIfJK6svM0ArVM09W0zB3PLvWgDIpg2jfHWAlnq8my41lNCZakFX5RS4XF6bQpwl
         EZtWKWob2dj1rL9LgWQR22PL5izhM0qovzS2hZhGu8XULeQwQW7FiNE5c0+aRhM0Hq9H
         ewVPp/BNDM/c9PH2S1q1wwJaqfCe83JgUOusJ5ECzEfZCGXKwyBhKP0Ft9nh1R7xQ3Tt
         LaTa5sDD+vEvVuYJhoPBRhVrYcegkiLzuW2AjUu8F0vqRT8R2KFrNafiZc68Ew6IGigc
         u0Snnz409q/GPBhFh2YUBsLzcERzITZOlaDlWFjInvxlfzbo8Yfsw+Q88rRTVb5QyHzH
         ZmAw==
X-Gm-Message-State: AOAM530UvekwmHfrOzMmvi1kqjLOAm+56ghedtAcXVLAIE3hCI/FFinR
        UOywzgFB8JOeWOSDUl/ghTUtJrKmg9MTto3czJHlsw==
X-Google-Smtp-Source: ABdhPJwKbmr6jMPOHeqeGPrJvVjLbXjjMKmmcge3g5B7hhuXPvqmdflmXhJJ96zWExligXj3u7dgUpHDqaCIJqpfu6M=
X-Received: by 2002:a05:6830:2425:: with SMTP id k5mr41279275ots.319.1638973642515;
 Wed, 08 Dec 2021 06:27:22 -0800 (PST)
MIME-Version: 1.0
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <20211205042217.982127-2-eric.dumazet@gmail.com> <3d80c863-8f1d-5e94-44c8-cc1193cca06a@intel.com>
In-Reply-To: <3d80c863-8f1d-5e94-44c8-cc1193cca06a@intel.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 8 Dec 2021 15:27:10 +0100
Message-ID: <CACT4Y+a8aXJRU5u31=4Nu4czBZCUaH06TV1VjiFxRGo9zeYjKQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 01/23] lib: add reference counting tracking infrastructure
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 at 15:09, Andrzej Hajda <andrzej.hajda@intel.com> wrote:
>
> Hi Eric,
>
>
> I've spotted this patchset thanks to LWN, anyway it was merged very
> quickly, I think it missed more broader review.
>
> As the patch touches kernel lib I have added few people who could be
> interested.
>
>
> On 05.12.2021 05:21, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > It can be hard to track where references are taken and released.
> >
> > In networking, we have annoying issues at device or netns dismantles,
> > and we had various proposals to ease root causing them.
> >
> > This patch adds new infrastructure pairing refcount increases
> > and decreases. This will self document code, because programmers
> > will have to associate increments/decrements.
> >
> > This is controled by CONFIG_REF_TRACKER which can be selected
> > by users of this feature.
> >
> > This adds both cpu and memory costs, and thus should probably be
> > used with care.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
> > ---
>
>
> Life is surprising, I was working on my own framework, solving the same
> issue, with intention to publish it in few days :)
>
>
> My approach was little different:
>
> 1. Instead of creating separate framework I have extended debug_objects.
>
> 2. There were no additional fields in refcounted object and trackers -
> infrastructure of debug_objects was reused - debug_objects tracked both
> pointers of refcounted object and its users.
>
> Have you considered using debug_object? it seems to be good place to put
> it there, I am not sure about performance differences.

Hi Andrzej,

How exactly did you do it? Do you have a link to your patch?
There still should be something similar to `struct ref_tracker` in
this patch, right? Or how do you match decrements with increments and
understand when a double-decrement happens?


> One more thing about design - as I understand CONFIG_REF_TRACKER turns
> on all trackers in whole kernel, have you considered possibility/helpers
> to enable/disable tracking per class of objects?
>
>
> >   include/linux/ref_tracker.h |  73 +++++++++++++++++++
> >   lib/Kconfig                 |   5 ++
> >   lib/Makefile                |   2 +
> >   lib/ref_tracker.c           | 140 ++++++++++++++++++++++++++++++++++++
> >   4 files changed, 220 insertions(+)
> >   create mode 100644 include/linux/ref_tracker.h
> >   create mode 100644 lib/ref_tracker.c
> >
> > diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
> > new file mode 100644
> > index 0000000000000000000000000000000000000000..c11c9db5825cf933acf529c83db441a818135f29
> > --- /dev/null
> > +++ b/include/linux/ref_tracker.h
> > @@ -0,0 +1,73 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +#ifndef _LINUX_REF_TRACKER_H
> > +#define _LINUX_REF_TRACKER_H
> > +#include <linux/refcount.h>
> > +#include <linux/types.h>
> > +#include <linux/spinlock.h>
> > +
> > +struct ref_tracker;
>
>
> With sth similar to:
>
> #ifdef CONFIG_REF_TRACKER
>
> typedef struct ref_tracker *ref_tracker_p;
> #else
> typedef struct {} ref_tracker_p;
> #endif
>
> you can eliminate unused field in user's structures.
>
> Beside this it looks OK to me.
>
>
> Regards
>
> Andrzej
>
>
> > +
> > +struct ref_tracker_dir {
> > +#ifdef CONFIG_REF_TRACKER
> > +     spinlock_t              lock;
> > +     unsigned int            quarantine_avail;
> > +     refcount_t              untracked;
> > +     struct list_head        list; /* List of active trackers */
> > +     struct list_head        quarantine; /* List of dead trackers */
> > +#endif
> > +};
> > +
> > +#ifdef CONFIG_REF_TRACKER
> > +static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
> > +                                     unsigned int quarantine_count)
> > +{
> > +     INIT_LIST_HEAD(&dir->list);
> > +     INIT_LIST_HEAD(&dir->quarantine);
> > +     spin_lock_init(&dir->lock);
> > +     dir->quarantine_avail = quarantine_count;
> > +     refcount_set(&dir->untracked, 1);
> > +}
> > +
> > +void ref_tracker_dir_exit(struct ref_tracker_dir *dir);
> > +
> > +void ref_tracker_dir_print(struct ref_tracker_dir *dir,
> > +                        unsigned int display_limit);
> > +
> > +int ref_tracker_alloc(struct ref_tracker_dir *dir,
> > +                   struct ref_tracker **trackerp, gfp_t gfp);
> > +
> > +int ref_tracker_free(struct ref_tracker_dir *dir,
> > +                  struct ref_tracker **trackerp);
> > +
> > +#else /* CONFIG_REF_TRACKER */
> > +
> > +static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
> > +                                     unsigned int quarantine_count)
> > +{
> > +}
> > +
> > +static inline void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
> > +{
> > +}
> > +
> > +static inline void ref_tracker_dir_print(struct ref_tracker_dir *dir,
> > +                                      unsigned int display_limit)
> > +{
> > +}
> > +
> > +static inline int ref_tracker_alloc(struct ref_tracker_dir *dir,
> > +                                 struct ref_tracker **trackerp,
> > +                                 gfp_t gfp)
> > +{
> > +     return 0;
> > +}
> > +
> > +static inline int ref_tracker_free(struct ref_tracker_dir *dir,
> > +                                struct ref_tracker **trackerp)
> > +{
> > +     return 0;
> > +}
> > +
> > +#endif
> > +
> > +#endif /* _LINUX_REF_TRACKER_H */
> > diff --git a/lib/Kconfig b/lib/Kconfig
> > index 5e7165e6a346c9bec878b78c8c8c3d175fc98dfd..655b0e43f260bfca63240794191e3f1890b2e801 100644
> > --- a/lib/Kconfig
> > +++ b/lib/Kconfig
> > @@ -680,6 +680,11 @@ config STACK_HASH_ORDER
> >        Select the hash size as a power of 2 for the stackdepot hash table.
> >        Choose a lower value to reduce the memory impact.
> >
> > +config REF_TRACKER
> > +     bool
> > +     depends on STACKTRACE_SUPPORT
> > +     select STACKDEPOT
> > +
> >   config SBITMAP
> >       bool
> >
> > diff --git a/lib/Makefile b/lib/Makefile
> > index 364c23f1557816f73aebd8304c01224a4846ac6c..c1fd9243ddb9cc1ac5252d7eb8009f9290782c4a 100644
> > --- a/lib/Makefile
> > +++ b/lib/Makefile
> > @@ -270,6 +270,8 @@ obj-$(CONFIG_STACKDEPOT) += stackdepot.o
> >   KASAN_SANITIZE_stackdepot.o := n
> >   KCOV_INSTRUMENT_stackdepot.o := n
> >
> > +obj-$(CONFIG_REF_TRACKER) += ref_tracker.o
> > +
> >   libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o \
> >              fdt_empty_tree.o fdt_addresses.o
> >   $(foreach file, $(libfdt_files), \
> > diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
> > new file mode 100644
> > index 0000000000000000000000000000000000000000..0ae2e66dcf0fdb976f4cb99e747c9448b37f22cc
> > --- /dev/null
> > +++ b/lib/ref_tracker.c
> > @@ -0,0 +1,140 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +#include <linux/export.h>
> > +#include <linux/ref_tracker.h>
> > +#include <linux/slab.h>
> > +#include <linux/stacktrace.h>
> > +#include <linux/stackdepot.h>
> > +
> > +#define REF_TRACKER_STACK_ENTRIES 16
> > +
> > +struct ref_tracker {
> > +     struct list_head        head;   /* anchor into dir->list or dir->quarantine */
> > +     bool                    dead;
> > +     depot_stack_handle_t    alloc_stack_handle;
> > +     depot_stack_handle_t    free_stack_handle;
> > +};
> > +
> > +void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
> > +{
> > +     struct ref_tracker *tracker, *n;
> > +     unsigned long flags;
> > +     bool leak = false;
> > +
> > +     spin_lock_irqsave(&dir->lock, flags);
> > +     list_for_each_entry_safe(tracker, n, &dir->quarantine, head) {
> > +             list_del(&tracker->head);
> > +             kfree(tracker);
> > +             dir->quarantine_avail++;
> > +     }
> > +     list_for_each_entry_safe(tracker, n, &dir->list, head) {
> > +             pr_err("leaked reference.\n");
> > +             if (tracker->alloc_stack_handle)
> > +                     stack_depot_print(tracker->alloc_stack_handle);
> > +             leak = true;
> > +             list_del(&tracker->head);
> > +             kfree(tracker);
> > +     }
> > +     spin_unlock_irqrestore(&dir->lock, flags);
> > +     WARN_ON_ONCE(leak);
> > +     WARN_ON_ONCE(refcount_read(&dir->untracked) != 1);
> > +}
> > +EXPORT_SYMBOL(ref_tracker_dir_exit);
> > +
> > +void ref_tracker_dir_print(struct ref_tracker_dir *dir,
> > +                        unsigned int display_limit)
> > +{
> > +     struct ref_tracker *tracker;
> > +     unsigned long flags;
> > +     unsigned int i = 0;
> > +
> > +     spin_lock_irqsave(&dir->lock, flags);
> > +     list_for_each_entry(tracker, &dir->list, head) {
> > +             if (i < display_limit) {
> > +                     pr_err("leaked reference.\n");
> > +                     if (tracker->alloc_stack_handle)
> > +                             stack_depot_print(tracker->alloc_stack_handle);
> > +                     i++;
> > +             } else {
> > +                     break;
> > +             }
> > +     }
> > +     spin_unlock_irqrestore(&dir->lock, flags);
> > +}
> > +EXPORT_SYMBOL(ref_tracker_dir_print);
> > +
> > +int ref_tracker_alloc(struct ref_tracker_dir *dir,
> > +                   struct ref_tracker **trackerp,
> > +                   gfp_t gfp)
> > +{
> > +     unsigned long entries[REF_TRACKER_STACK_ENTRIES];
> > +     struct ref_tracker *tracker;
> > +     unsigned int nr_entries;
> > +     unsigned long flags;
> > +
> > +     *trackerp = tracker = kzalloc(sizeof(*tracker), gfp | __GFP_NOFAIL);
> > +     if (unlikely(!tracker)) {
> > +             pr_err_once("memory allocation failure, unreliable refcount tracker.\n");
> > +             refcount_inc(&dir->untracked);
> > +             return -ENOMEM;
> > +     }
> > +     nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
> > +     nr_entries = filter_irq_stacks(entries, nr_entries);
> > +     tracker->alloc_stack_handle = stack_depot_save(entries, nr_entries, gfp);
> > +
> > +     spin_lock_irqsave(&dir->lock, flags);
> > +     list_add(&tracker->head, &dir->list);
> > +     spin_unlock_irqrestore(&dir->lock, flags);
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(ref_tracker_alloc);
> > +
> > +int ref_tracker_free(struct ref_tracker_dir *dir,
> > +                  struct ref_tracker **trackerp)
> > +{
> > +     unsigned long entries[REF_TRACKER_STACK_ENTRIES];
> > +     struct ref_tracker *tracker = *trackerp;
> > +     depot_stack_handle_t stack_handle;
> > +     unsigned int nr_entries;
> > +     unsigned long flags;
> > +
> > +     if (!tracker) {
> > +             refcount_dec(&dir->untracked);
> > +             return -EEXIST;
> > +     }
> > +     nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
> > +     nr_entries = filter_irq_stacks(entries, nr_entries);
> > +     stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);
> > +
> > +     spin_lock_irqsave(&dir->lock, flags);
> > +     if (tracker->dead) {
> > +             pr_err("reference already released.\n");
> > +             if (tracker->alloc_stack_handle) {
> > +                     pr_err("allocated in:\n");
> > +                     stack_depot_print(tracker->alloc_stack_handle);
> > +             }
> > +             if (tracker->free_stack_handle) {
> > +                     pr_err("freed in:\n");
> > +                     stack_depot_print(tracker->free_stack_handle);
> > +             }
> > +             spin_unlock_irqrestore(&dir->lock, flags);
> > +             WARN_ON_ONCE(1);
> > +             return -EINVAL;
> > +     }
> > +     tracker->dead = true;
> > +
> > +     tracker->free_stack_handle = stack_handle;
> > +
> > +     list_move_tail(&tracker->head, &dir->quarantine);
> > +     if (!dir->quarantine_avail) {
> > +             tracker = list_first_entry(&dir->quarantine, struct ref_tracker, head);
> > +             list_del(&tracker->head);
> > +     } else {
> > +             dir->quarantine_avail--;
> > +             tracker = NULL;
> > +     }
> > +     spin_unlock_irqrestore(&dir->lock, flags);
> > +
> > +     kfree(tracker);
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(ref_tracker_free);
