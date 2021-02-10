Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBDC315E26
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 05:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhBJERY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 23:17:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38814 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229684AbhBJERQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 23:17:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612930550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KWkZGceImgODZQt4JilFUnzdPSObR5bScucQBFdzS90=;
        b=TRRsR+phzw3J1aJOYpwIFnAQ+pjEaYCzkX9F/wZJbBTQyElkbvAPbN3Pgrf3TBnwIi0MUM
        /RJi4XNn9/dCeHMVr/9TxAQkcS99SOBlKDh4Fo3+m2BGyVVULQ8p6u4102zJOWEv27pAvb
        iC2jARarxvdWDa5TIYrckMGkINX29qw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-uHbe-3d8PpiZJtK2MnObKQ-1; Tue, 09 Feb 2021 23:15:46 -0500
X-MC-Unique: uHbe-3d8PpiZJtK2MnObKQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2B72801962;
        Wed, 10 Feb 2021 04:15:44 +0000 (UTC)
Received: from [10.72.12.223] (ovpn-12-223.pek2.redhat.com [10.72.12.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC00D60C4D;
        Wed, 10 Feb 2021 04:15:38 +0000 (UTC)
Subject: Re: [PATCH RFC v2 3/4] virtio-net: support transmit timestamp
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Willem de Bruijn <willemb@google.com>
References: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
 <20210208185558.995292-4-willemdebruijn.kernel@gmail.com>
 <6bfdf48d-c780-bc65-b0b9-24a33f18827b@redhat.com>
 <20210209113643-mutt-send-email-mst@kernel.org>
 <CAF=yD-Lw7LKypTLEfQmcqR9SwcL6f9wH=_yjQdyGak4ORegRug@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <af5b16fb-8b22-f081-3aa0-92839b7153d6@redhat.com>
Date:   Wed, 10 Feb 2021 12:15:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-Lw7LKypTLEfQmcqR9SwcL6f9wH=_yjQdyGak4ORegRug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/10 上午10:36, Willem de Bruijn wrote:
> On Tue, Feb 9, 2021 at 11:39 AM Michael S. Tsirkin<mst@redhat.com>  wrote:
>> On Tue, Feb 09, 2021 at 01:45:11PM +0800, Jason Wang wrote:
>>> On 2021/2/9 上午2:55, Willem de Bruijn wrote:
>>>> From: Willem de Bruijn<willemb@google.com>
>>>>
>>>> Add optional PTP hardware tx timestamp offload for virtio-net.
>>>>
>>>> Accurate RTT measurement requires timestamps close to the wire.
>>>> Introduce virtio feature VIRTIO_NET_F_TX_TSTAMP, the transmit
>>>> equivalent to VIRTIO_NET_F_RX_TSTAMP.
>>>>
>>>> The driver sets VIRTIO_NET_HDR_F_TSTAMP to request a timestamp
>>>> returned on completion. If the feature is negotiated, the device
>>>> either places the timestamp or clears the feature bit.
>>>>
>>>> The timestamp straddles (virtual) hardware domains. Like PTP, use
>>>> international atomic time (CLOCK_TAI) as global clock base. The driver
>>>> must sync with the device, e.g., through kvm-clock.
>>>>
>>>> Modify can_push to ensure that on tx completion the header, and thus
>>>> timestamp, is in a predicatable location at skb_vnet_hdr.
>>>>
>>>> RFC: this implementation relies on the device writing to the buffer.
>>>> That breaks DMA_TO_DEVICE semantics. For now, disable when DMA is on.
>>>> The virtio changes should be a separate patch at the least.
>>>>
>>>> Tested: modified txtimestamp.c to with h/w timestamping:
>>>>     -       sock_opt = SOF_TIMESTAMPING_SOFTWARE |
>>>>     +       sock_opt = SOF_TIMESTAMPING_RAW_HARDWARE |
>>>>     + do_test(family, SOF_TIMESTAMPING_TX_HARDWARE);
>>>>
>>>> Signed-off-by: Willem de Bruijn<willemb@google.com>
>>>> ---
>>>>    drivers/net/virtio_net.c        | 61 ++++++++++++++++++++++++++++-----
>>>>    drivers/virtio/virtio_ring.c    |  3 +-
>>>>    include/linux/virtio.h          |  1 +
>>>>    include/uapi/linux/virtio_net.h |  1 +
>>>>    4 files changed, 56 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>> index ac44c5efa0bc..fc8ecd3a333a 100644
>>>> --- a/drivers/net/virtio_net.c
>>>> +++ b/drivers/net/virtio_net.c
>>>> @@ -210,6 +210,12 @@ struct virtnet_info {
>>>>      /* Device will pass rx timestamp. Requires has_rx_tstamp */
>>>>      bool enable_rx_tstamp;
>>>> +   /* Device can pass CLOCK_TAI transmit time to the driver */
>>>> +   bool has_tx_tstamp;
>>>> +
>>>> +   /* Device will pass tx timestamp. Requires has_tx_tstamp */
>>>> +   bool enable_tx_tstamp;
>>>> +
>>>>      /* Has control virtqueue */
>>>>      bool has_cvq;
>>>> @@ -1401,6 +1407,20 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
>>>>      return stats.packets;
>>>>    }
>>>> +static void virtnet_record_tx_tstamp(const struct send_queue *sq,
>>>> +                                struct sk_buff *skb)
>>>> +{
>>>> +   const struct virtio_net_hdr_hash_ts *h = skb_vnet_hdr_ht(skb);
>>>> +   const struct virtnet_info *vi = sq->vq->vdev->priv;
>>>> +   struct skb_shared_hwtstamps ts;
>>>> +
>>>> +   if (h->hdr.flags & VIRTIO_NET_HDR_F_TSTAMP &&
>>>> +       vi->enable_tx_tstamp) {
>>>> +           ts.hwtstamp = ns_to_ktime(le64_to_cpu(h->tstamp));
>>>> +           skb_tstamp_tx(skb, &ts);
>>> This probably won't work since the buffer is read-only from the device. (See
>>> virtqueue_add_outbuf()).
>>>
>>> Another issue that I vaguely remember that the virtio spec forbids out
>>> buffer after in buffer.
>> Both Driver Requirements: Message Framing and Driver Requirements: Scatter-Gather Support
>> have this statement:
>>
>>          The driver MUST place any device-writable descriptor elements after any device-readable descriptor ele-
>>          ments.
>>
>>
>> similarly
>>
>> Device Requirements: The Virtqueue Descriptor Table
>>          A device MUST NOT write to a device-readable buffer, and a device SHOULD NOT read a device-writable
>>          buffer.
> Thanks. That's clear. So the clean solution would be to add a
> device-writable descriptor after the existing device-readable ones.


I think so, but a question is the format for this tailer. I think it 
might be better to post a spec patch to discuss.

Thanks


>
> And the device must be aware that this is to return the tstamp only.
> In the example implementation of vhost, it has to exclude this last
> descriptor from the msg->msg_iter iovec array with packet data
> initialized at get_tx_bufs/init_iov_iter.
>

