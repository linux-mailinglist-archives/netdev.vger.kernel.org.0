Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D3C45DCA5
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355949AbhKYOvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:51:25 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:34456 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344978AbhKYOtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:49:24 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4948921958;
        Thu, 25 Nov 2021 14:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637851572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jp9Byyv2i/lpogY+ZZSli8+lqVck+WI312/v0Kss16Y=;
        b=oY5yPIYjnGTpVQ0lsxAecwzuyZTYraOlbDanHMiKlAbOsEBgBsBoa93v6+EHr3Pq9aqQ5X
        0PkOCZkz4LdjdKVtLxF9X63lfc7GCgd9AGEKfo0oWjj+34wLJynzKaT16DhgLGA1yM2NVg
        oZRvBpqR+Cf35Itth5CwlIi39nqw7nk=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 96986A3B84;
        Thu, 25 Nov 2021 14:46:11 +0000 (UTC)
Date:   Thu, 25 Nov 2021 15:46:11 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] kthread: dynamically allocate memory to store
 kthread's full name
Message-ID: <YZ+hsx52TyDuHvE1@alley>
References: <20211120112850.46047-1-laoar.shao@gmail.com>
 <435fab0b-d345-3698-79af-ff858181666a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <435fab0b-d345-3698-79af-ff858181666a@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 2021-11-25 10:36:49, David Hildenbrand wrote:
> On 20.11.21 12:28, Yafang Shao wrote:
> > When I was implementing a new per-cpu kthread cfs_migration, I found the
> > comm of it "cfs_migration/%u" is truncated due to the limitation of
> > TASK_COMM_LEN. For example, the comm of the percpu thread on CPU10~19 are
> > all with the same name "cfs_migration/1", which will confuse the user. This
> > issue is not critical, because we can get the corresponding CPU from the
> > task's Cpus_allowed. But for kthreads correspoinding to other hardware
> > devices, it is not easy to get the detailed device info from task comm,
> > for example,
> > 
> >     jbd2/nvme0n1p2-
> >     xfs-reclaim/sdf
> > 
> > Currently there are so many truncated kthreads:
> > 
> >     rcu_tasks_kthre
> >     rcu_tasks_rude_
> >     rcu_tasks_trace
> >     poll_mpt3sas0_s
> >     ext4-rsv-conver
> >     xfs-reclaim/sd{a, b, c, ...}
> >     xfs-blockgc/sd{a, b, c, ...}
> >     xfs-inodegc/sd{a, b, c, ...}
> >     audit_send_repl
> >     ecryptfs-kthrea
> >     vfio-irqfd-clea
> >     jbd2/nvme0n1p2-
> >     ...
> > 
> > We can shorten these names to work around this problem, but it may be
> > not applied to all of the truncated kthreads. Take 'jbd2/nvme0n1p2-' for
> > example, it is a nice name, and it is not a good idea to shorten it.
> > 
> > One possible way to fix this issue is extending the task comm size, but
> > as task->comm is used in lots of places, that may cause some potential
> > buffer overflows. Another more conservative approach is introducing a new
> > pointer to store kthread's full name if it is truncated, which won't
> > introduce too much overhead as it is in the non-critical path. Finally we
> > make a dicision to use the second approach. See also the discussions in
> > this thread:
> > https://lore.kernel.org/lkml/20211101060419.4682-1-laoar.shao@gmail.com/
> > 
> > After this change, the full name of these truncated kthreads will be
> > displayed via /proc/[pid]/comm:
> > 
> >     rcu_tasks_kthread
> >     rcu_tasks_rude_kthread
> >     rcu_tasks_trace_kthread
> >     poll_mpt3sas0_statu
> >     ext4-rsv-conversion
> >     xfs-reclaim/sdf1
> >     xfs-blockgc/sdf1
> >     xfs-inodegc/sdf1
> >     audit_send_reply
> >     ecryptfs-kthread
> >     vfio-irqfd-cleanup
> >     jbd2/nvme0n1p2-8
> 
> I do wonder if that could break some user space that assumes these names
> have maximum length ..

There is high chance that we will be on the safe side. Workqueue
kthreads already provided longer names. They are even dynamic
because the currently handled workqueue name is part of the name,
see wq_worker_comm().

Best Regards,
Petr
