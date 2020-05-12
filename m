Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C971CF5F7
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 15:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbgELNih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 09:38:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:42708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgELNih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 09:38:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EE0BAAD71;
        Tue, 12 May 2020 13:38:37 +0000 (UTC)
Subject: Re: [PATCH net-next v9 1/2] xen networking: add basic XDP support for
 xen-netfront
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     paul@xen.org, netdev@vger.kernel.org, brouer@redhat.com,
        wei.liu@kernel.org, ilias.apalodimas@linaro.org
References: <1589192541-11686-1-git-send-email-kda@linux-powerpc.org>
 <1589192541-11686-2-git-send-email-kda@linux-powerpc.org>
 <649c940c-200b-f644-8932-7d54ac21a98b@suse.com>
 <CAOJe8K29vn6TK8t7g7j387F41ig-9yY-jT-k=mVpDQW3xmDPSg@mail.gmail.com>
 <62f29aba-93d5-9a7d-a4ac-7fae1ac46f22@suse.com>
 <CAOJe8K3mQuf_wj6rZ-hSHixosBsdvHZkgZRYHRGJjqaXHNoPxw@mail.gmail.com>
 <eb54bbfb-a97d-7cd8-e354-8828b74548fc@suse.com>
 <CAOJe8K3EHevDJ+3P59=F6AU7dVBvubR4-yUbeLGQ1WbFK5icZg@mail.gmail.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <a569a270-7146-c548-73cf-134221647ca7@suse.com>
Date:   Tue, 12 May 2020 15:38:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAOJe8K3EHevDJ+3P59=F6AU7dVBvubR4-yUbeLGQ1WbFK5icZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.05.20 15:21, Denis Kirjanov wrote:
> On 5/12/20, Jürgen Groß <jgross@suse.com> wrote:
>> On 12.05.20 14:27, Denis Kirjanov wrote:
>>> On 5/12/20, Jürgen Groß <jgross@suse.com> wrote:
>>>> On 11.05.20 19:27, Denis Kirjanov wrote:
>>>>> On 5/11/20, Jürgen Groß <jgross@suse.com> wrote:
>>>>>> On 11.05.20 12:22, Denis Kirjanov wrote:
>>>>>>> The patch adds a basic XDP processing to xen-netfront driver.
>>>>>>>
>>>>>>> We ran an XDP program for an RX response received from netback
>>>>>>> driver. Also we request xen-netback to adjust data offset for
>>>>>>> bpf_xdp_adjust_head() header space for custom headers.
>>>>>>>
>>>>>>> synchronization between frontend and backend parts is done
>>>>>>> by using xenbus state switching:
>>>>>>> Reconfiguring -> Reconfigured- > Connected
>>>>>>>
>>>>>>> UDP packets drop rate using xdp program is around 310 kpps
>>>>>>> using ./pktgen_sample04_many_flows.sh and 160 kpps without the patch.
>>>>>>
>>>>>> I'm still not seeing proper synchronization between frontend and
>>>>>> backend when an XDP program is activated.
>>>>>>
>>>>>> Consider the following:
>>>>>>
>>>>>> 1. XDP program is not active, so RX responses have no XDP headroom
>>>>>> 2. netback has pushed one (or more) RX responses to the ring page
>>>>>> 3. XDP program is being activated -> Reconfiguring
>>>>>> 4. netback acknowledges, will add XDP headroom for following RX
>>>>>>        responses
>>>>>> 5. netfront reads RX response (2.) without XDP headroom from ring page
>>>>>> 6. boom!
>>>>>
>>>>> One thing that could be easily done is to set the offset on
>>>>> xen-netback
>>>>> side
>>>>> in  xenvif_rx_data_slot().  Are you okay with that?
>>>>
>>>> How does this help in above case?
>>>>
>>>> I think you haven't understood the problem I'm seeing.
>>>>
>>>> There can be many RX responses in the ring page which haven't been
>>>> consumed by the frontend yet. You are doing the switch to XDP via a
>>>> different communication channel (Xenstore), so you need some way to
>>>> synchronize both communication channels.
>>>>
>>>> Either you make sure you have read all RX responses before doing the
>>>> switch (this requires stopping netback to push out more RX responses),
>>>> or you need to have a flag in the RX responses indicating whether XDP
>>>> headroom is provided or not (requires an addition to the Xen netif
>>>> protocol).
>>> Hi Jürgen,
>>>
>>> I see your point that we can have a shared ring with mixed RX responses
>>> offset.
>>> Since the offset field is set always  to 0 on netback side we can
>>> adjust it and thus mark that a response has the offset adjusted or
>>> it's not (if the offset filed is set to 0).
>>
>> For one I don't see your code in netfront to test this condition.
> 
> Right, it's not in the current version.
> 
>>
>> And I don't think this is a guaranteed interface. Have you checked all
>> netback versions in older kernels, in qemu, and in BSD?
>>
>> BTW, I'm pretty sure the old xen-linux netback sometimes used an offset
>> not being 0. And yes, those kernels are still active in some cases (e.g.
>> SLES11-SP4 is still supported for customers having a long time service
>> agreement and this version is based on xen-linux).
> 
> I see, good to know.
> I think that I can add a new flag like XEN_NETRXF_xdp_headroom in this case

This will need to be defined in the related header in the Xen tree first
as this is the canonical source for all implementations of the Xen PV
network interface. See the file xen/include/public/io/netif.h in the Xen
tree (git://xenbits.xen.org/xen.git, patches should be sent to
xen-devel@lists.xenproject.org). When the interface change has been
approved I'd take the related change of the header in the Linux kernel.

This adds another question - is XDP_PACKET_HEADROOM guaranteed to always
have the same value across all implementations, or could it change e.g.
from one Linux kernel version to another, or are there other OS's with
XDP program support, possibly using a different value?

It might be a better idea to use a specific RX request for turning on
XDP support with the needed XDP_PACKET_HEADROOM value in it. This would
automatically solve the synchronization issue, as the related response
would automatically mark the synchronization point. And it would even
allow to have different headroom values in a netfront implementation
(maybe other OS's could use that capability).


Juergen
