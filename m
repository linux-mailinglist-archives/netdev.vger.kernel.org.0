Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A471C6B26
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgEFIPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:15:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24164 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728296AbgEFIPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:15:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588752947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tv9gy/STUJAi06/hbYoHmCXzWhvqABgvCJQtoF8duxE=;
        b=CEc5h8upqDIQQoY0i0Hvoo/OLiYWUTrdN25yCaJiTZMx+kIKfPIFKBa6FqMaoZ5AWgvN5+
        11MFDu7FoTKfvF0tMMLF78hYTO2UcCqn0Y0c9QgoSn5pGUJUo1vGBNDkGEIQ9Xm6hqIv/d
        QbfgQU53QonvTJKFItDLC5j3he9VkUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-Frdn5NOzNxabidNppYN08g-1; Wed, 06 May 2020 04:15:42 -0400
X-MC-Unique: Frdn5NOzNxabidNppYN08g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31E84107ACCD;
        Wed,  6 May 2020 08:15:41 +0000 (UTC)
Received: from [10.72.13.165] (ovpn-13-165.pek2.redhat.com [10.72.13.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B784605DF;
        Wed,  6 May 2020 08:15:36 +0000 (UTC)
Subject: Re: [BUG] Inconsistent lock state in virtnet poll
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
References: <87lfm6oa7b.fsf@nanos.tec.linutronix.de>
 <20200505120352-mutt-send-email-mst@kernel.org>
 <87v9lanher.fsf@nanos.tec.linutronix.de>
 <98c4d934-5a27-1cf7-119a-ce0c5a501864@gmail.com>
 <20200505204015-mutt-send-email-mst@kernel.org>
 <4ea7fb92-c4fb-1a31-d83b-483da2fb7a1a@gmail.com>
 <20200505212325-mutt-send-email-mst@kernel.org>
 <71b1b9dd-78e3-9694-2daa-5723355293d4@gmail.com>
 <20200506032237-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1255e119-c58b-f91f-c44f-cf6a0b47fb4b@redhat.com>
Date:   Wed, 6 May 2020 16:15:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506032237-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/6 =E4=B8=8B=E5=8D=883:31, Michael S. Tsirkin wrote:
> On Tue, May 05, 2020 at 07:24:18PM -0700, Eric Dumazet wrote:
>> On 5/5/20 6:25 PM, Michael S. Tsirkin wrote:
>>> On Tue, May 05, 2020 at 06:19:09PM -0700, Eric Dumazet wrote:
>>>> On 5/5/20 5:43 PM, Michael S. Tsirkin wrote:
>>>>> On Tue, May 05, 2020 at 03:40:09PM -0700, Eric Dumazet wrote:
>>>>>> On 5/5/20 3:30 PM, Thomas Gleixner wrote:
>>>>>>> "Michael S. Tsirkin"<mst@redhat.com>  writes:
>>>>>>>> On Tue, May 05, 2020 at 02:08:56PM +0200, Thomas Gleixner wrote:
>>>>>>>>> The following lockdep splat happens reproducibly on 5.7-rc4
>>>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>>>> WARNING: inconsistent lock state
>>>>>>>>> 5.7.0-rc4+ #79 Not tainted
>>>>>>>>> --------------------------------
>>>>>>>>> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
>>>>>>>>> ip/356 [HC0[0]:SC1[1]:HE1:SE0] takes:
>>>>>>>>> f3ee4cd8 (&syncp->seq#2){+.?.}-{0:0}, at: net_rx_action+0xfb/0x=
390
>>>>>>>>> {SOFTIRQ-ON-W} state was registered at:
>>>>>>>>>    lock_acquire+0x82/0x300
>>>>>>>>>    try_fill_recv+0x39f/0x590
>>>>>>>> Weird. Where does try_fill_recv acquire any locks?
>>>>>>>    u64_stats_update_begin(&rq->stats.syncp);
>>>>>>>
>>>>>>> That's a 32bit kernel which uses a seqcount for this. sequence co=
unts
>>>>>>> are "lock" constructs where you need to make sure that writers ar=
e
>>>>>>> serialized.
>>>>>>>
>>>>>>> Actually the problem at hand is that try_fill_recv() is called fr=
om
>>>>>>> fully preemptible context initialy and then from softirq context.
>>>>>>>
>>>>>>> Obviously that's for the open() path a non issue, but lockdep doe=
s not
>>>>>>> know about that. OTOH, there is other code which calls that from
>>>>>>> non-softirq context.
>>>>>>>
>>>>>>> The hack below made it shut up. It's obvioulsy not ideal, but at =
least
>>>>>>> it let me look at the actual problem I was chasing down:)
>>>>>>>
>>>>>>> Thanks,
>>>>>>>
>>>>>>>          tglx
>>>>>>>
>>>>>>> 8<-----------
>>>>>>> --- a/drivers/net/virtio_net.c
>>>>>>> +++ b/drivers/net/virtio_net.c
>>>>>>> @@ -1243,9 +1243,11 @@ static bool try_fill_recv(struct virtnet
>>>>>>>   			break;
>>>>>>>   	} while (rq->vq->num_free);
>>>>>>>   	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)=
) {
>>>>>>> +		local_bh_disable();
>>>>>> Or use u64_stats_update_begin_irqsave() whic is a NOP on 64bit ker=
nels
>>>>> I applied this, but am still trying to think of something that
>>>>> is 0 overhead for all configs.
>>>>> Maybe we can select a lockdep class depending on whether napi
>>>>> is enabled?
>>>> Do you_really_  need 64bit counter for stats.kicks on 32bit kernels =
?
>>>>
>>>> Adding 64bit counters just because we can might be overhead anyway.
>>> Well 32 bit kernels don't fundamentally kick less than 64 bit ones,
>>> and we kick more or less per packet, sometimes per batch,
>>> people expect these to be in sync ..
>> Well, we left many counters in networking stack as 'unsigned long'
>> and nobody complained yet of overflows on 32bit kernels.
> Right.  For TX it is helpful that everything is maintained
> atomically so we do need the seqlock machinery anyway:
>
>          u64_stats_update_begin(&sq->stats.syncp);
>          sq->stats.bytes +=3D bytes;
>          sq->stats.packets +=3D packets;
>          sq->stats.xdp_tx +=3D n;
>          sq->stats.xdp_tx_drops +=3D drops;
>          sq->stats.kicks +=3D kicks;
>          u64_stats_update_end(&sq->stats.syncp);
>
> for RX kicks are currently updated separately.  Which I guess is more o=
r
> less a minor bug.
>
>          if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get=
_vring_size(rq->vq)) / 2) {
>                  if (!try_fill_recv(vi, rq, GFP_ATOMIC))
>                          schedule_delayed_work(&vi->refill, 0);
>          }
>
>          u64_stats_update_begin(&rq->stats.syncp);
>          for (i =3D 0; i < VIRTNET_RQ_STATS_LEN; i++) {
>                  size_t offset =3D virtnet_rq_stats_desc[i].offset;
>                  u64 *item;
>
>                  item =3D (u64 *)((u8 *)&rq->stats + offset);
>                  *item +=3D *(u64 *)((u8 *)&stats + offset);
>          }
>          u64_stats_update_end(&rq->stats.syncp);
>
> we should update kicks in virtnet_receive.
>
> And as long as we do that there's no cost to 64 bit counters ...
>
>

Or find way to use u32 to count kick in workqueue (which should be rare)=20
separately.

Thanks

