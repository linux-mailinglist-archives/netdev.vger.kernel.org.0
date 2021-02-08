Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B51313513
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbhBHOYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:24:15 -0500
Received: from mail.xenproject.org ([104.130.215.37]:50998 "EHLO
        mail.xenproject.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbhBHOWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:22:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=5wS9jApuQ6snC1lAYDvURgj8Yzs3/FPfCQanUYhUoH4=; b=bvHCq83LkPUCYauekJ4gj+HboE
        m00kpkrKFq0YE1awNW4Ug94dTN8ctow0FVCufnLzgze73/s/t6WcNUpu98KmYn+gT09Wlk867t2Dc
        60yfQsaFVMWifcGwW0LQmicJ1coBc3N7Pa3jEkGQuU9wsAN95aNedj4fqlpV+lMZaWoQ=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <julien@xen.org>)
        id 1l97PQ-0005JM-59; Mon, 08 Feb 2021 14:21:00 +0000
Received: from [54.239.6.177] (helo=a483e7b01a66.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <julien@xen.org>)
        id 1l97PP-0006Dn-Nb; Mon, 08 Feb 2021 14:20:59 +0000
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
 <6f547bb5-777a-6fc2-eba2-cccb4adfca87@xen.org>
 <0d623c98-a714-1639-cc53-f58ba3f08212@suse.com>
 <28399fd1-9fe8-f31a-6ee8-e78de567155b@xen.org>
 <1831964f-185e-31bb-2446-778f2c18d71b@suse.com>
 <e8c46e36-cf9e-fb30-21b5-fa662834a01a@xen.org>
 <199b76fd-630b-a0c6-926b-3e662103ec42@suse.com>
 <063eff75-56a5-1af7-f684-a2ed4b13c9a7@xen.org>
 <4279cab9-9b36-e83d-bd7a-ff7cd2832054@suse.com>
From:   Julien Grall <julien@xen.org>
Message-ID: <279b741b-09dc-c6af-bf9d-df57922fa465@xen.org>
Date:   Mon, 8 Feb 2021 14:20:56 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <4279cab9-9b36-e83d-bd7a-ff7cd2832054@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Juergen,

On 08/02/2021 13:58, Jürgen Groß wrote:
> On 08.02.21 14:09, Julien Grall wrote:
>> Hi Juergen,
>>
>> On 08/02/2021 12:31, Jürgen Groß wrote:
>>> On 08.02.21 13:16, Julien Grall wrote:
>>>>
>>>>
>>>> On 08/02/2021 12:14, Jürgen Groß wrote:
>>>>> On 08.02.21 11:40, Julien Grall wrote:
>>>>>> Hi Juergen,
>>>>>>
>>>>>> On 08/02/2021 10:22, Jürgen Groß wrote:
>>>>>>> On 08.02.21 10:54, Julien Grall wrote:
>>>>>>>> ... I don't really see how the difference matter here. The idea 
>>>>>>>> is to re-use what's already existing rather than trying to 
>>>>>>>> re-invent the wheel with an extra lock (or whatever we can come 
>>>>>>>> up).
>>>>>>>
>>>>>>> The difference is that the race is occurring _before_ any IRQ is
>>>>>>> involved. So I don't see how modification of IRQ handling would 
>>>>>>> help.
>>>>>>
>>>>>> Roughly our current IRQ handling flow (handle_eoi_irq()) looks like:
>>>>>>
>>>>>> if ( irq in progress )
>>>>>> {
>>>>>>    set IRQS_PENDING
>>>>>>    return;
>>>>>> }
>>>>>>
>>>>>> do
>>>>>> {
>>>>>>    clear IRQS_PENDING
>>>>>>    handle_irq()
>>>>>> } while (IRQS_PENDING is set)
>>>>>>
>>>>>> IRQ handling flow like handle_fasteoi_irq() looks like:
>>>>>>
>>>>>> if ( irq in progress )
>>>>>>    return;
>>>>>>
>>>>>> handle_irq()
>>>>>>
>>>>>> The latter flow would catch "spurious" interrupt and ignore them. 
>>>>>> So it would handle nicely the race when changing the event affinity.
>>>>>
>>>>> Sure? Isn't "irq in progress" being reset way before our "lateeoi" is
>>>>> issued, thus having the same problem again? 
>>>>
>>>> Sorry I can't parse this.
>>>
>>> handle_fasteoi_irq() will do nothing "if ( irq in progress )". When is
>>> this condition being reset again in order to be able to process another
>>> IRQ?
>> It is reset after the handler has been called. See handle_irq_event().
> 
> Right. And for us this is too early, as we want the next IRQ being
> handled only after we have called xen_irq_lateeoi().

It is not really the next IRQ here. It is more a spurious IRQ because we 
don't clear & mask the event right away. Instead, it is done later in 
the handling.

> 
>>
>>> I believe this will be the case before our "lateeoi" handling is
>>> becoming active (more precise: when our IRQ handler is returning to
>>> handle_fasteoi_irq()), resulting in the possibility of the same race we
>>> are experiencing now.
>>
>> I am a bit confused what you mean by "lateeoi" handling is becoming 
>> active. Can you clarify?
> 
> See above: the next call of the handler should be allowed only after
> xen_irq_lateeoi() for the IRQ has been called.
> 
> If the handler is being called earlier we have the race resulting
> in the WARN() splats.

I feel it is dislike to understand race with just words. Can you provide 
a scenario (similar to the one I originally provided) with two vCPUs and 
show how this can happen?

> 
>> Note that are are other IRQ flows existing. We should have a look at 
>> them before trying to fix thing ourself.
> 
> Fine with me, but it either needs to fit all use cases (interdomain,
> IPI, real interrupts) or we need to have a per-type IRQ flow.

AFAICT, we already used different flow based on the use cases. Before 
2011, we used to use the fasteoi one but this was changed by the 
following commit:


commit 7e186bdd0098b34c69fb8067c67340ae610ea499
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Fri May 6 12:27:50 2011 +0100

     xen: do not clear and mask evtchns in __xen_evtchn_do_upcall

     Change the irq handler of evtchns and pirqs that don't need EOI (pirqs
     that correspond to physical edge interrupts) to handle_edge_irq.

     Use handle_fasteoi_irq for pirqs that need eoi (they generally
     correspond to level triggered irqs), no risk in loosing interrupts
     because we have to EOI the irq anyway.

     This change has the following benefits:

     - it uses the very same handlers that Linux would use on native for the
     same irqs (handle_edge_irq for edge irqs and msis, and
     handle_fasteoi_irq for everything else);

     - it uses these handlers in the same way native code would use them: it
     let Linux mask\unmask and ack the irq when Linux want to mask\unmask
     and ack the irq;

     - it fixes a problem occurring when a driver calls disable_irq() in its
     handler: the old code was unconditionally unmasking the evtchn even if
     the irq is disabled when irq_eoi was called.

     See Documentation/DocBook/genericirq.tmpl for more informations.

     Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
     [v1: Fixed space/tab issues]
     Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>


> 
> I think we should fix the issue locally first, then we can start to do
> a thorough rework planning. Its not as if the needed changes with the
> current flow would be so huge, and I'd really like to have a solution
> rather sooner than later. Changing the IRQ flow might have other side
> effects which need to be excluded by thorough testing.
I agree that we need a solution ASAP. But I am a bit worry to:
   1) Add another lock in that event handling path.
   2) Add more complexity in the event handling (it is already fairly 
difficult to reason about the locking/race)

Let see what the local fix look like.

>> Although, the other issue I can see so far is handle_irq_for_port() 
>> will update info->{eoi_cpu, irq_epoch, eoi_time} without any locking. 
>> But it is not clear this is what you mean by "becoming active".
> 
> As long as a single event can't be handled on multiple cpus at the same
> time, there is no locking needed.

Well, it can happen in the current code (see my original scenario). If 
your idea fix it then fine.

Cheers,

-- 
Julien Grall
