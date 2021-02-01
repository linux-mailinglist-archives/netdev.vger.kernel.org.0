Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B1930AF2D
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbhBASQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:16:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232447AbhBASQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:16:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612203288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ya219FEouxc4ey9Bi9QzBAa/NZQvOAmPCVPDKerIZso=;
        b=iIZtqWz/qJNacYfIb3nU6UIphsbxeQiZTrNTghI4W2s4CsnEUh4KQmZmrl7dX8Ue2Gb6Fl
        MNAlp9yD3peuWklY0Fa/d2O/KDRGOFc3Wy8qdCSt/jyBomi+qJaxqcOUouvVHOQpzfNxF2
        NkyHTfFyI6O+x9OKV4gvjKP1lrJSXZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-SpHaUQK0P_mfjJSgm04W6g-1; Mon, 01 Feb 2021 13:14:46 -0500
X-MC-Unique: SpHaUQK0P_mfjJSgm04W6g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26B3259;
        Mon,  1 Feb 2021 18:14:44 +0000 (UTC)
Received: from llong.remote.csb (ovpn-118-89.rdu2.redhat.com [10.10.118.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B82860C05;
        Mon,  1 Feb 2021 18:14:42 +0000 (UTC)
Subject: Re: corrupted pvqspinlock in htab_map_update_elem
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
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
 <5936f4a4-f150-e56e-f07d-1efee06eba16@redhat.com>
 <CACT4Y+ZEPG0keEM5BzeqxnqOETyjPsa+7_cvGk=VDH+ErhyF-Q@mail.gmail.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <19ca1c9f-090b-e97f-d9c7-827fa2f9fee5@redhat.com>
Date:   Mon, 1 Feb 2021 13:14:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CACT4Y+ZEPG0keEM5BzeqxnqOETyjPsa+7_cvGk=VDH+ErhyF-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/21 1:09 PM, Dmitry Vyukov wrote:
> On Mon, Feb 1, 2021 at 6:54 PM Waiman Long <longman@redhat.com> wrote:
>> On 2/1/21 6:23 AM, Peter Zijlstra wrote:
>>> On Mon, Feb 01, 2021 at 10:50:58AM +0100, Peter Zijlstra wrote:
>>>
>>>>>    queued_spin_unlock arch/x86/include/asm/qspinlock.h:56 [inline]
>>>>>    lockdep_unlock+0x10e/0x290 kernel/locking/lockdep.c:124
>>>>>    debug_locks_off_graph_unlock kernel/locking/lockdep.c:165 [inline]
>>>>>    print_usage_bug kernel/locking/lockdep.c:3710 [inline]
>>>> Ha, I think you hit a bug in lockdep.
>>> Something like so I suppose.
>>>
>>> ---
>>> Subject: locking/lockdep: Avoid unmatched unlock
>>> From: Peter Zijlstra <peterz@infradead.org>
>>> Date: Mon Feb 1 11:55:38 CET 2021
>>>
>>> Commit f6f48e180404 ("lockdep: Teach lockdep about "USED" <- "IN-NMI"
>>> inversions") overlooked that print_usage_bug() releases the graph_lock
>>> and called it without the graph lock held.
>>>
>>> Fixes: f6f48e180404 ("lockdep: Teach lockdep about "USED" <- "IN-NMI" inversions")
>>> Reported-by: Dmitry Vyukov <dvyukov@google.com>
>>> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>>> ---
>>>    kernel/locking/lockdep.c |    3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> --- a/kernel/locking/lockdep.c
>>> +++ b/kernel/locking/lockdep.c
>>> @@ -3773,7 +3773,7 @@ static void
>>>    print_usage_bug(struct task_struct *curr, struct held_lock *this,
>>>                enum lock_usage_bit prev_bit, enum lock_usage_bit new_bit)
>>>    {
>>> -     if (!debug_locks_off_graph_unlock() || debug_locks_silent)
>>> +     if (!debug_locks_off() || debug_locks_silent)
>>>                return;
>>>
>>>        pr_warn("\n");
>>> @@ -3814,6 +3814,7 @@ valid_state(struct task_struct *curr, st
>>>            enum lock_usage_bit new_bit, enum lock_usage_bit bad_bit)
>>>    {
>>>        if (unlikely(hlock_class(this)->usage_mask & (1 << bad_bit))) {
>>> +             graph_unlock()
>>>                print_usage_bug(curr, this, bad_bit, new_bit);
>>>                return 0;
>>>        }
>> I have also suspected doing unlock without a corresponding lock. This
>> patch looks good to me.
>>
>> Acked-by: Waiman Long <longman@redhat.com>
> Just so that it's not lost: there is still a bug related to bpf map lock, right?
>
That is right. This patch just fixes the bug in lockdep.

Cheers,
Longman

