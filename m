Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389F231E5E2
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhBRFqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:46:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40997 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231235AbhBRFl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:41:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613626775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UhTlxA1FLz1h5UBYFU/B2CUChRQ+ZuRS8//lQ8J+LZ4=;
        b=RfmzTJYOPHCxm3c+cZcOw+z23QO3sYwVfddk7YEiZGpl+UGpWvkdP/ySfVDLU/EX2Bhpn7
        yoeWw4K1vNoBgsqpL5W5O3HP0L5zHET0BV5jJRTwyb4FXUzMdNkE2fW5SNmFBZtxPNMgKN
        YdNmkkegpKm+htQIGSicqRwkBcw00ww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-IXJnW8ceNM2IaYZxlPlt1A-1; Thu, 18 Feb 2021 00:39:31 -0500
X-MC-Unique: IXJnW8ceNM2IaYZxlPlt1A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CDCE100830D;
        Thu, 18 Feb 2021 05:39:30 +0000 (UTC)
Received: from [10.72.13.28] (ovpn-13-28.pek2.redhat.com [10.72.13.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C32B5C730;
        Thu, 18 Feb 2021 05:39:21 +0000 (UTC)
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     "Michael S. Tsirkin" <mst@redhat.com>, Wei Wang <weiwan@google.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
References: <CAF=yD-+aPBF2RaCR8L5orTM37bf7Z4Z8Qko2D2LZjOz0khHTUg@mail.gmail.com>
 <3a3e005d-f9b2-c16a-5ada-6e04242c618e@redhat.com>
 <CAF=yD-+NVKiwS6P2=cS=gk2nLcsWP1anMyy4ghdPiNrhOmLRDw@mail.gmail.com>
 <9b0b8f2a-8476-697e-9002-e9947e3eab63@redhat.com>
 <CA+FuTScVOuoHKtrdrRFswjA3Zq1-7sgMVhnP2iMB5sYFFS8NFg@mail.gmail.com>
 <50ae0b71-df87-f26c-8b4d-8035f9f6a58d@redhat.com>
 <CAF=yD-J5-60D=JDwvpecjaO6J03SZHoHJyCsR3B1HbP1-jbqng@mail.gmail.com>
 <00de1b0f-f2aa-de54-9c7e-472643400417@redhat.com>
 <CAF=yD-K9xTBStGR5BEiS6WZd=znqM_ENcj9_nb=rrpcMORqE8g@mail.gmail.com>
 <CAEA6p_Bi1OMTas0W4VuxAMz8Frf+vBNc8c7xCDUxb_uwUy8Zgw@mail.gmail.com>
 <20210210040802-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9b077d6c-aeca-8266-4579-fae02c8b31de@redhat.com>
Date:   Thu, 18 Feb 2021 13:39:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210210040802-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/10 下午5:14, Michael S. Tsirkin wrote:
> On Tue, Feb 09, 2021 at 10:00:22AM -0800, Wei Wang wrote:
>> On Tue, Feb 9, 2021 at 6:58 AM Willem de Bruijn
>> <willemdebruijn.kernel@gmail.com> wrote:
>>>>>>> I have no preference. Just curious, especially if it complicates the patch.
>>>>>>>
>>>>>> My understanding is that. It's probably ok for net. But we probably need
>>>>>> to document the assumptions to make sure it was not abused in other drivers.
>>>>>>
>>>>>> Introduce new parameters for find_vqs() can help to eliminate the subtle
>>>>>> stuffs but I agree it looks like a overkill.
>>>>>>
>>>>>> (Btw, I forget the numbers but wonder how much difference if we simple
>>>>>> remove the free_old_xmits() from the rx NAPI path?)
>>>>> The committed patchset did not record those numbers, but I found them
>>>>> in an earlier iteration:
>>>>>
>>>>>     [PATCH net-next 0/3] virtio-net tx napi
>>>>>     https://lists.openwall.net/netdev/2017/04/02/55
>>>>>
>>>>> It did seem to significantly reduce compute cycles ("Gcyc") at the
>>>>> time. For instance:
>>>>>
>>>>>       TCP_RR Latency (us):
>>>>>       1x:
>>>>>         p50              24       24       21
>>>>>         p99              27       27       27
>>>>>         Gcycles         299      432      308
>>>>>
>>>>> I'm concerned that removing it now may cause a regression report in a
>>>>> few months. That is higher risk than the spurious interrupt warning
>>>>> that was only reported after years of use.
>>>>
>>>> Right.
>>>>
>>>> So if Michael is fine with this approach, I'm ok with it. But we
>>>> probably need to a TODO to invent the interrupt handlers that can be
>>>> used for more than one virtqueues. When MSI-X is enabled, the interrupt
>>>> handler (vring_interrup()) assumes the interrupt is used by a single
>>>> virtqueue.
>>> Thanks.
>>>
>>> The approach to schedule tx-napi from virtnet_poll_cleantx instead of
>>> cleaning directly in this rx-napi function was not effective at
>>> suppressing the warning, I understand.
>> Correct. I tried the approach to schedule tx napi instead of directly
>> do free_old_xmit_skbs() in virtnet_poll_cleantx(). But the warning
>> still happens.
> Two questions here: is the device using packed or split vqs?
> And is event index enabled?
>
> I think one issue is that at the moment with split and event index we
> don't actually disable events at all.


Do we really have a way to disable that? (We don't have a flag like 
packed virtqueue)

Or you mean the trick [1] when I post tx interrupt RFC?

Thanks

[1] https://lkml.org/lkml/2015/2/9/113


>
> static void virtqueue_disable_cb_split(struct virtqueue *_vq)
> {
>          struct vring_virtqueue *vq = to_vvq(_vq);
>
>          if (!(vq->split.avail_flags_shadow & VRING_AVAIL_F_NO_INTERRUPT)) {
>                  vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
>                  if (!vq->event)
>                          vq->split.vring.avail->flags =
>                                  cpu_to_virtio16(_vq->vdev,
>                                                  vq->split.avail_flags_shadow);
>          }
> }
>
> Can you try your napi patch + disable event index?
>
>

