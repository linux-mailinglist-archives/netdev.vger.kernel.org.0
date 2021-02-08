Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28301312E3D
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 11:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhBHJ7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 04:59:47 -0500
Received: from mail.xenproject.org ([104.130.215.37]:49814 "EHLO
        mail.xenproject.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbhBHJ4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 04:56:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=DAnR7MzHh3CuEpYPfOXRcoYHW4xu0lHgJg9s/j96+CA=; b=NQGvflJoJaq+BVdv8rdh+MkiSv
        yol9jTaW9vwwwSHp5cMZreqBIOdubT37g1wVGnfYlYuHjdIVeTKUrOIYNxXb/NkBsEkGnK0YWRmVR
        Oy5X/RCcavvyZ/EDQTSzY9UNWcretq8xUfp9jvHU7Azj5q1sWMdWYfbpuZTB3zCUWJ6w=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <julien@xen.org>)
        id 1l93FJ-0000fi-7C; Mon, 08 Feb 2021 09:54:17 +0000
Received: from [54.239.6.177] (helo=a483e7b01a66.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <julien@xen.org>)
        id 1l93FI-00019w-RE; Mon, 08 Feb 2021 09:54:17 +0000
Subject: Re: [PATCH 0/7] xen/events: bug fixes and some diagnostic aids
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210206104932.29064-1-jgross@suse.com>
 <bd63694e-ac0c-7954-ec00-edad05f8da1c@xen.org>
 <eeb62129-d9fc-2155-0e0f-aff1fbb33fbc@suse.com>
 <fcf3181b-3efc-55f5-687c-324937b543e6@xen.org>
 <7aaeeb3d-1e1b-6166-84e9-481153811b62@suse.com>
From:   Julien Grall <julien@xen.org>
Message-ID: <6f547bb5-777a-6fc2-eba2-cccb4adfca87@xen.org>
Date:   Mon, 8 Feb 2021 09:54:13 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <7aaeeb3d-1e1b-6166-84e9-481153811b62@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08/02/2021 09:41, Jürgen Groß wrote:
> On 08.02.21 10:11, Julien Grall wrote:
>> Hi Juergen,
>>
>> On 07/02/2021 12:58, Jürgen Groß wrote:
>>> On 06.02.21 19:46, Julien Grall wrote:
>>>> Hi Juergen,
>>>>
>>>> On 06/02/2021 10:49, Juergen Gross wrote:
>>>>> The first three patches are fixes for XSA-332. The avoid WARN splats
>>>>> and a performance issue with interdomain events.
>>>>
>>>> Thanks for helping to figure out the problem. Unfortunately, I still 
>>>> see reliably the WARN splat with the latest Linux master 
>>>> (1e0d27fce010) + your first 3 patches.
>>>>
>>>> I am using Xen 4.11 (1c7d984645f9) and dom0 is forced to use the 2L 
>>>> events ABI.
>>>>
>>>> After some debugging, I think I have an idea what's went wrong. The 
>>>> problem happens when the event is initially bound from vCPU0 to a 
>>>> different vCPU.
>>>>
>>>>  From the comment in xen_rebind_evtchn_to_cpu(), we are masking the 
>>>> event to prevent it being delivered on an unexpected vCPU. However, 
>>>> I believe the following can happen:
>>>>
>>>> vCPU0                | vCPU1
>>>>                  |
>>>>                  | Call xen_rebind_evtchn_to_cpu()
>>>> receive event X            |
>>>>                  | mask event X
>>>>                  | bind to vCPU1
>>>> <vCPU descheduled>        | unmask event X
>>>>                  |
>>>>                  | receive event X
>>>>                  |
>>>>                  | handle_edge_irq(X)
>>>> handle_edge_irq(X)        |  -> handle_irq_event()
>>>>                  |   -> set IRQD_IN_PROGRESS
>>>>   -> set IRQS_PENDING        |
>>>>                  |   -> evtchn_interrupt()
>>>>                  |   -> clear IRQD_IN_PROGRESS
>>>>                  |  -> IRQS_PENDING is set
>>>>                  |  -> handle_irq_event()
>>>>                  |   -> evtchn_interrupt()
>>>>                  |     -> WARN()
>>>>                  |
>>>>
>>>> All the lateeoi handlers expect a ONESHOT semantic and 
>>>> evtchn_interrupt() is doesn't tolerate any deviation.
>>>>
>>>> I think the problem was introduced by 7f874a0447a9 ("xen/events: fix 
>>>> lateeoi irq acknowledgment") because the interrupt was disabled 
>>>> previously. Therefore we wouldn't do another iteration in 
>>>> handle_edge_irq().
>>>
>>> I think you picked the wrong commit for blaming, as this is just
>>> the last patch of the three patches you were testing.
>>
>> I actually found the right commit for blaming but I copied the 
>> information from the wrong shell :/. The bug was introduced by:
>>
>> c44b849cee8c ("xen/events: switch user event channels to lateeoi model")
>>
>>>
>>>> Aside the handlers, I think it may impact the defer EOI mitigation 
>>>> because in theory if a 3rd vCPU is joining the party (let say vCPU A 
>>>> migrate the event from vCPU B to vCPU C). So info->{eoi_cpu, 
>>>> irq_epoch, eoi_time} could possibly get mangled?
>>>>
>>>> For a fix, we may want to consider to hold evtchn_rwlock with the 
>>>> write permission. Although, I am not 100% sure this is going to 
>>>> prevent everything.
>>>
>>> It will make things worse, as it would violate the locking hierarchy
>>> (xen_rebind_evtchn_to_cpu() is called with the IRQ-desc lock held).
>>
>> Ah, right.
>>
>>>
>>> On a first glance I think we'll need a 3rd masking state ("temporarily
>>> masked") in the second patch in order to avoid a race with lateeoi.
>>>
>>> In order to avoid the race you outlined above we need an "event is being
>>> handled" indicator checked via test_and_set() semantics in
>>> handle_irq_for_port() and reset only when calling clear_evtchn().
>>
>> It feels like we are trying to workaround the IRQ flow we are using 
>> (i.e. handle_edge_irq()).
> 
> I'm not really sure this is the main problem here. According to your
> analysis the main problem is occurring when handling the event, not when
> handling the IRQ: the event is being received on two vcpus.

I don't think we can easily divide the two because we rely on the IRQ 
framework to handle the lifecycle of the event. So...

> 
> Our problem isn't due to the IRQ still being pending, but due it being
> raised again, which should happen for a one shot IRQ the same way.

... I don't really see how the difference matter here. The idea is to 
re-use what's already existing rather than trying to re-invent the wheel 
with an extra lock (or whatever we can come up).

Cheers,

-- 
Julien Grall
