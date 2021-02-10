Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9ABB315E1B
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 05:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhBJEOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 23:14:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35476 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229979AbhBJENw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 23:13:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612930345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P6Cl9KL8f7SY7V73YNj6aiJEGdKExA4CdRKAeLw3K88=;
        b=DX2zM/FZNKGHA1IuzNBLlVvEZNFRR0u89XXYr0attQBMiAysdjuTIe6RxqtvusT1m+RCtH
        ioYRx931qmofkiA78KiyTGgT51Z87ZelZ8VJ1n337fUZfLrM+PzTg6jtpiblCq7DU07wAT
        G4TcNPUxf698KluSW/O8B6SpqOuNtUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-OTILhi5nOeS-0KS4noiIZQ-1; Tue, 09 Feb 2021 23:12:23 -0500
X-MC-Unique: OTILhi5nOeS-0KS4noiIZQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 898F5107ACC7;
        Wed, 10 Feb 2021 04:12:22 +0000 (UTC)
Received: from [10.72.12.223] (ovpn-12-223.pek2.redhat.com [10.72.12.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21E735D74B;
        Wed, 10 Feb 2021 04:12:16 +0000 (UTC)
Subject: Re: [PATCH RFC v2 3/4] virtio-net: support transmit timestamp
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        richardcochran@gmail.com, Willem de Bruijn <willemb@google.com>
References: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
 <20210208185558.995292-4-willemdebruijn.kernel@gmail.com>
 <6bfdf48d-c780-bc65-b0b9-24a33f18827b@redhat.com>
 <20210209113643-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d25bce7b-ac29-e189-c399-2c03f57202cc@redhat.com>
Date:   Wed, 10 Feb 2021 12:12:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210209113643-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/10 上午12:38, Michael S. Tsirkin wrote:
> On Tue, Feb 09, 2021 at 01:45:11PM +0800, Jason Wang wrote:
>> On 2021/2/9 上午2:55, Willem de Bruijn wrote:
>>> From: Willem de Bruijn<willemb@google.com>
>>>
>>> Add optional PTP hardware tx timestamp offload for virtio-net.
>>>
>>> Accurate RTT measurement requires timestamps close to the wire.
>>> Introduce virtio feature VIRTIO_NET_F_TX_TSTAMP, the transmit
>>> equivalent to VIRTIO_NET_F_RX_TSTAMP.
>>>
>>> The driver sets VIRTIO_NET_HDR_F_TSTAMP to request a timestamp
>>> returned on completion. If the feature is negotiated, the device
>>> either places the timestamp or clears the feature bit.
>>>
>>> The timestamp straddles (virtual) hardware domains. Like PTP, use
>>> international atomic time (CLOCK_TAI) as global clock base. The driver
>>> must sync with the device, e.g., through kvm-clock.
>>>
>>> Modify can_push to ensure that on tx completion the header, and thus
>>> timestamp, is in a predicatable location at skb_vnet_hdr.
>>>
>>> RFC: this implementation relies on the device writing to the buffer.
>>> That breaks DMA_TO_DEVICE semantics. For now, disable when DMA is on.
>>> The virtio changes should be a separate patch at the least.
>>>
>>> Tested: modified txtimestamp.c to with h/w timestamping:
>>>     -       sock_opt = SOF_TIMESTAMPING_SOFTWARE |
>>>     +       sock_opt = SOF_TIMESTAMPING_RAW_HARDWARE |
>>>     + do_test(family, SOF_TIMESTAMPING_TX_HARDWARE);
>>>
>>> Signed-off-by: Willem de Bruijn<willemb@google.com>
>>> ---
>>>    drivers/net/virtio_net.c        | 61 ++++++++++++++++++++++++++++-----
>>>    drivers/virtio/virtio_ring.c    |  3 +-
>>>    include/linux/virtio.h          |  1 +
>>>    include/uapi/linux/virtio_net.h |  1 +
>>>    4 files changed, 56 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index ac44c5efa0bc..fc8ecd3a333a 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -210,6 +210,12 @@ struct virtnet_info {
>>>    	/* Device will pass rx timestamp. Requires has_rx_tstamp */
>>>    	bool enable_rx_tstamp;
>>> +	/* Device can pass CLOCK_TAI transmit time to the driver */
>>> +	bool has_tx_tstamp;
>>> +
>>> +	/* Device will pass tx timestamp. Requires has_tx_tstamp */
>>> +	bool enable_tx_tstamp;
>>> +
>>>    	/* Has control virtqueue */
>>>    	bool has_cvq;
>>> @@ -1401,6 +1407,20 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
>>>    	return stats.packets;
>>>    }
>>> +static void virtnet_record_tx_tstamp(const struct send_queue *sq,
>>> +				     struct sk_buff *skb)
>>> +{
>>> +	const struct virtio_net_hdr_hash_ts *h = skb_vnet_hdr_ht(skb);
>>> +	const struct virtnet_info *vi = sq->vq->vdev->priv;
>>> +	struct skb_shared_hwtstamps ts;
>>> +
>>> +	if (h->hdr.flags & VIRTIO_NET_HDR_F_TSTAMP &&
>>> +	    vi->enable_tx_tstamp) {
>>> +		ts.hwtstamp = ns_to_ktime(le64_to_cpu(h->tstamp));
>>> +		skb_tstamp_tx(skb, &ts);
>> This probably won't work since the buffer is read-only from the device. (See
>> virtqueue_add_outbuf()).
>>
>> Another issue that I vaguely remember that the virtio spec forbids out
>> buffer after in buffer.
> Both Driver Requirements: Message Framing and Driver Requirements: Scatter-Gather Support
> have this statement:
>
> 	The driver MUST place any device-writable descriptor elements after any device-readable descriptor ele-
> 	ments.
>
>
> similarly
>
> Device Requirements: The Virtqueue Descriptor Table
> 	A device MUST NOT write to a device-readable buffer, and a device SHOULD NOT read a device-writable
> 	buffer.
>
>

Exactly. But I wonder what's the rationale behinds those requirements?

Thanks


