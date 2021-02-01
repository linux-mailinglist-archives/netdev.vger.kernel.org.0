Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B515230AE8A
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhBARzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:55:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232258AbhBARz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:55:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612202041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TItgm0+VXZQkzT+vjmzxyshp9Ksb9PzGNBOZr7Z/D5g=;
        b=QwVdmJo8JFtZMmTxBO9Xjt2LLnmu0X4puSwrKgIWQIGnII1ajdh4TYIsiQFr4mT7q60AWW
        IXC+VGMicx85Nrc8/oFlS8PSwDq3AZZvpr8ERvu7guEaiT8b6WUS/f8QMhVE21Zr8TPtBZ
        DWCxceS2Muu5aPRWztRbMcdqNOB/lDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-TVApnOdZMD-FJdEy0ErIwg-1; Mon, 01 Feb 2021 12:53:57 -0500
X-MC-Unique: TVApnOdZMD-FJdEy0ErIwg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAEE259;
        Mon,  1 Feb 2021 17:53:55 +0000 (UTC)
Received: from llong.remote.csb (ovpn-118-89.rdu2.redhat.com [10.10.118.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 000A419716;
        Mon,  1 Feb 2021 17:53:53 +0000 (UTC)
Subject: Re: corrupted pvqspinlock in htab_map_update_elem
To:     Peter Zijlstra <peterz@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
References: <CACT4Y+YJp0t0HA3+wDsAVxgTK4J+Pvht-J4-ENkOtS=C=Fhtzg@mail.gmail.com>
 <YBfPAvBa8bbSU2nZ@hirez.programming.kicks-ass.net>
 <YBfkuyIfB1+VRxXP@hirez.programming.kicks-ass.net>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <5936f4a4-f150-e56e-f07d-1efee06eba16@redhat.com>
Date:   Mon, 1 Feb 2021 12:53:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YBfkuyIfB1+VRxXP@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/21 6:23 AM, Peter Zijlstra wrote:
> On Mon, Feb 01, 2021 at 10:50:58AM +0100, Peter Zijlstra wrote:
>
>>>   queued_spin_unlock arch/x86/include/asm/qspinlock.h:56 [inline]
>>>   lockdep_unlock+0x10e/0x290 kernel/locking/lockdep.c:124
>>>   debug_locks_off_graph_unlock kernel/locking/lockdep.c:165 [inline]
>>>   print_usage_bug kernel/locking/lockdep.c:3710 [inline]
>> Ha, I think you hit a bug in lockdep.
> Something like so I suppose.
>
> ---
> Subject: locking/lockdep: Avoid unmatched unlock
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Mon Feb 1 11:55:38 CET 2021
>
> Commit f6f48e180404 ("lockdep: Teach lockdep about "USED" <- "IN-NMI"
> inversions") overlooked that print_usage_bug() releases the graph_lock
> and called it without the graph lock held.
>
> Fixes: f6f48e180404 ("lockdep: Teach lockdep about "USED" <- "IN-NMI" inversions")
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>   kernel/locking/lockdep.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -3773,7 +3773,7 @@ static void
>   print_usage_bug(struct task_struct *curr, struct held_lock *this,
>   		enum lock_usage_bit prev_bit, enum lock_usage_bit new_bit)
>   {
> -	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
> +	if (!debug_locks_off() || debug_locks_silent)
>   		return;
>   
>   	pr_warn("\n");
> @@ -3814,6 +3814,7 @@ valid_state(struct task_struct *curr, st
>   	    enum lock_usage_bit new_bit, enum lock_usage_bit bad_bit)
>   {
>   	if (unlikely(hlock_class(this)->usage_mask & (1 << bad_bit))) {
> +		graph_unlock()
>   		print_usage_bug(curr, this, bad_bit, new_bit);
>   		return 0;
>   	}

I have also suspected doing unlock without a corresponding lock. This 
patch looks good to me.

Acked-by: Waiman Long <longman@redhat.com>

Cheers,
Longman

