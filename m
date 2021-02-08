Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88A431295F
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 04:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhBHDbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 22:31:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229537AbhBHDbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 22:31:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612754977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kXh3A4geCXGeNGqA59TB0OGZGPsBee1kOFk8AXr/HJw=;
        b=heFe2EdOo/NqNTVekxxw9Td+oxGsPsKdu8xf0KHc+nm4X/0St2LLyFYyHZYgLHV9Rk+mJj
        t2yTHRPlBcK0Pic7LTTCyL+wSdUEx1A9dz/+Qr+ihmqrNclN5vnbk78Xtlv1nZrQpjt6OX
        daTWv38v0Q+g5qyIrpBxFgd47KR6vcw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-UgYeyIcRN0yxVuHmcpPd1Q-1; Sun, 07 Feb 2021 22:29:35 -0500
X-MC-Unique: UgYeyIcRN0yxVuHmcpPd1Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55AB2100A614;
        Mon,  8 Feb 2021 03:29:34 +0000 (UTC)
Received: from [10.72.13.185] (ovpn-13-185.pek2.redhat.com [10.72.13.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05741629DB;
        Mon,  8 Feb 2021 03:29:31 +0000 (UTC)
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
References: <20210129002136.70865-1-weiwan@google.com>
 <a0b2cb8d-eb8f-30fb-2a22-678e6dd2f58f@redhat.com>
 <CAF=yD-+aPBF2RaCR8L5orTM37bf7Z4Z8Qko2D2LZjOz0khHTUg@mail.gmail.com>
 <3a3e005d-f9b2-c16a-5ada-6e04242c618e@redhat.com>
 <CAF=yD-+NVKiwS6P2=cS=gk2nLcsWP1anMyy4ghdPiNrhOmLRDw@mail.gmail.com>
 <9b0b8f2a-8476-697e-9002-e9947e3eab63@redhat.com>
 <CA+FuTScVOuoHKtrdrRFswjA3Zq1-7sgMVhnP2iMB5sYFFS8NFg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <50ae0b71-df87-f26c-8b4d-8035f9f6a58d@redhat.com>
Date:   Mon, 8 Feb 2021 11:29:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTScVOuoHKtrdrRFswjA3Zq1-7sgMVhnP2iMB5sYFFS8NFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/5 上午4:50, Willem de Bruijn wrote:
> On Wed, Feb 3, 2021 at 10:06 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/2/4 上午2:28, Willem de Bruijn wrote:
>>> On Wed, Feb 3, 2021 at 12:33 AM Jason Wang <jasowang@redhat.com> wrote:
>>>> On 2021/2/2 下午10:37, Willem de Bruijn wrote:
>>>>> On Mon, Feb 1, 2021 at 10:09 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>> On 2021/1/29 上午8:21, Wei Wang wrote:
>>>>>>> With the implementation of napi-tx in virtio driver, we clean tx
>>>>>>> descriptors from rx napi handler, for the purpose of reducing tx
>>>>>>> complete interrupts. But this could introduce a race where tx complete
>>>>>>> interrupt has been raised, but the handler found there is no work to do
>>>>>>> because we have done the work in the previous rx interrupt handler.
>>>>>>> This could lead to the following warning msg:
>>>>>>> [ 3588.010778] irq 38: nobody cared (try booting with the
>>>>>>> "irqpoll" option)
>>>>>>> [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
>>>>>>> 5.3.0-19-generic #20~18.04.2-Ubuntu
>>>>>>> [ 3588.017940] Call Trace:
>>>>>>> [ 3588.017942]  <IRQ>
>>>>>>> [ 3588.017951]  dump_stack+0x63/0x85
>>>>>>> [ 3588.017953]  __report_bad_irq+0x35/0xc0
>>>>>>> [ 3588.017955]  note_interrupt+0x24b/0x2a0
>>>>>>> [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
>>>>>>> [ 3588.017957]  handle_irq_event+0x3b/0x60
>>>>>>> [ 3588.017958]  handle_edge_irq+0x83/0x1a0
>>>>>>> [ 3588.017961]  handle_irq+0x20/0x30
>>>>>>> [ 3588.017964]  do_IRQ+0x50/0xe0
>>>>>>> [ 3588.017966]  common_interrupt+0xf/0xf
>>>>>>> [ 3588.017966]  </IRQ>
>>>>>>> [ 3588.017989] handlers:
>>>>>>> [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
>>>>>>> [ 3588.025099] Disabling IRQ #38
>>>>>>>
>>>>>>> This patch adds a new param to struct vring_virtqueue, and we set it for
>>>>>>> tx virtqueues if napi-tx is enabled, to suppress the warning in such
>>>>>>> case.
>>>>>>>
>>>>>>> Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
>>>>>>> Reported-by: Rick Jones <jonesrick@google.com>
>>>>>>> Signed-off-by: Wei Wang <weiwan@google.com>
>>>>>>> Signed-off-by: Willem de Bruijn <willemb@google.com>
>>>>>> Please use get_maintainer.pl to make sure Michael and me were cced.
>>>>> Will do. Sorry about that. I suggested just the virtualization list, my bad.
>>>>>
>>>>>>> ---
>>>>>>>      drivers/net/virtio_net.c     | 19 ++++++++++++++-----
>>>>>>>      drivers/virtio/virtio_ring.c | 16 ++++++++++++++++
>>>>>>>      include/linux/virtio.h       |  2 ++
>>>>>>>      3 files changed, 32 insertions(+), 5 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>>>> index 508408fbe78f..e9a3f30864e8 100644
>>>>>>> --- a/drivers/net/virtio_net.c
>>>>>>> +++ b/drivers/net/virtio_net.c
>>>>>>> @@ -1303,13 +1303,22 @@ static void virtnet_napi_tx_enable(struct virtnet_info *vi,
>>>>>>>                  return;
>>>>>>>          }
>>>>>>>
>>>>>>> +     /* With napi_tx enabled, free_old_xmit_skbs() could be called from
>>>>>>> +      * rx napi handler. Set work_steal to suppress bad irq warning for
>>>>>>> +      * IRQ_NONE case from tx complete interrupt handler.
>>>>>>> +      */
>>>>>>> +     virtqueue_set_work_steal(vq, true);
>>>>>>> +
>>>>>>>          return virtnet_napi_enable(vq, napi);
>>>>>> Do we need to force the ordering between steal set and napi enable?
>>>>> The warning only occurs after one hundred spurious interrupts, so not
>>>>> really.
>>>> Ok, so it looks like a hint. Then I wonder how much value do we need to
>>>> introduce helper like virtqueue_set_work_steal() that allows the caller
>>>> to toggle. How about disable the check forever during virtqueue
>>>> initialization?
>>> Yes, that is even simpler.
>>>
>>> We still need the helper, as the internal variables of vring_virtqueue
>>> are not accessible from virtio-net. An earlier patch added the
>>> variable to virtqueue itself, but I think it belongs in
>>> vring_virtqueue. And the helper is not a lot of code.
>>
>> It's better to do this before the allocating the irq. But it looks not
>> easy unless we extend find_vqs().
> Can you elaborate why that is better? At virtnet_open the interrupts
> are not firing either.


I think you meant NAPI actually?


>
> I have no preference. Just curious, especially if it complicates the patch.
>

My understanding is that. It's probably ok for net. But we probably need 
to document the assumptions to make sure it was not abused in other drivers.

Introduce new parameters for find_vqs() can help to eliminate the subtle 
stuffs but I agree it looks like a overkill.

(Btw, I forget the numbers but wonder how much difference if we simple 
remove the free_old_xmits() from the rx NAPI path?)

Thanks


