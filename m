Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF36F441C3C
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 15:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhKAOKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 10:10:15 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:48592 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbhKAOKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 10:10:14 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 25DFD1FD73;
        Mon,  1 Nov 2021 14:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635775659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JCO02YOtqC3o+QYpVWZbFnMlxhlNKWkgnCq9GR7eOfY=;
        b=rCpSfWbAI96JJfPfUefp3YNvUeZTDPGjfKjwkZITw2oSVBOuuD44X8+Tf2EqJP3BTjF9sx
        GG4pyJNuna9fIR4vJ6+gx8wG2f3v9Lgqc6xO5cHqly6ACyATUhIAjBQ0Wzw/mAXTJkynZw
        xDiFcGbJyW1/WHoPxB6gspVnXb/SGiI=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id F02FCA3B81;
        Mon,  1 Nov 2021 14:07:37 +0000 (UTC)
Date:   Mon, 1 Nov 2021 15:07:03 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     akpm@linux-foundation.org, keescook@chromium.org,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        arnaldo.melo@gmail.com, peterz@infradead.org,
        viro@zeniv.linux.org.uk, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com
Subject: Re: [PATCH v7 00/11] extend task comm from 16 to 24
Message-ID: <YX/0h7j/nDwoBA+J@alley>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101060419.4682-1-laoar.shao@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 2021-11-01 06:04:08, Yafang Shao wrote:
> There're many truncated kthreads in the kernel, which may make trouble
> for the user, for example, the user can't get detailed device
> information from the task comm.
> 
> This patchset tries to improve this problem fundamentally by extending
> the task comm size from 16 to 24, which is a very simple way. 
> 
> In order to do that, we have to do some cleanups first.
> 
> 1. Make the copy of task comm always safe no matter what the task
>    comm size is. For example,
> 
>       Unsafe                 Safe
>       strlcpy                strscpy_pad
>       strncpy                strscpy_pad
>       bpf_probe_read_kernel  bpf_probe_read_kernel_str
>                              bpf_core_read_str
>                              bpf_get_current_comm
>                              perf_event__prepare_comm
>                              prctl(2)
> 
>    After this step, the comm size change won't make any trouble to the
>    kernel or the in-tree tools for example perf, BPF programs.
> 
> 2. Cleanup some old hard-coded 16
>    Actually we don't need to convert all of them to TASK_COMM_LEN or
>    TASK_COMM_LEN_16, what we really care about is if the convert can
>    make the code more reasonable or easier to understand. For
>    example, some in-tree tools read the comm from sched:sched_switch
>    tracepoint, as it is derived from the kernel, we'd better make them
>    consistent with the kernel.

The above changes make sense even if we do not extend comm[] array in
task_struct.


> 3. Extend the task comm size from 16 to 24
>    task_struct is growing rather regularly by 8 bytes. This size change
>    should be acceptable. We used to think about extending the size for
>    CONFIG_BASE_FULL only, but that would be a burden for maintenance
>    and introduce code complexity.
> 
> 4. Print a warning if the kthread comm is still truncated.
> 
> 5. What will happen to the out-of-tree tools after this change?
>    If the tool get task comm through kernel API, for example prctl(2),
>    bpf_get_current_comm() and etc, then it doesn't matter how large the
>    user buffer is, because it will always get a string with a nul
>    terminator. While if it gets the task comm through direct string copy,
>    the user tool must make sure the copied string has a nul terminator
>    itself. As TASK_COMM_LEN is not exposed to userspace, there's no
>    reason that it must require a fixed-size task comm.

The amount of code that has to be updated is really high. I am pretty
sure that there are more potential buffer overflows left.

You did not commented on the concerns in the thread
https://lore.kernel.org/all/CAADnVQKm0Ljj-w5PbkAu1ugLFnZRRPt-Vk-J7AhXxDD5xVompA@mail.gmail.com/

Several people suggested to use a more conservative approach. I mean
to keep comm[16] as is and add a new pointer to the full name. The buffer
for the long name might be dynamically allocated only when needed.

The pointer might be either in task_struct or struct kthread. It might
be used the same way as the full name stored by workqueue kthreads.

The advantage of the separate pointer:

   + would work for names longer than 32
   + will not open security holes in code

Best Regards,
Petr
