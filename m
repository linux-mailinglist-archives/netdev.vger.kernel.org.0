Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBD91C106
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 05:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfENDiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 23:38:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbfENDiP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 23:38:15 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95D9B307D92F;
        Tue, 14 May 2019 03:38:15 +0000 (UTC)
Received: from [10.72.12.59] (ovpn-12-59.pek2.redhat.com [10.72.12.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 815F2608BB;
        Tue, 14 May 2019 03:38:06 +0000 (UTC)
Subject: Re: [PATCH v2 7/8] vsock/virtio: increase RX buffer size to 64 KiB
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20190510125843.95587-1-sgarzare@redhat.com>
 <20190510125843.95587-8-sgarzare@redhat.com>
 <bf0416f1-0e69-722d-75ce-3d101e6d7d71@redhat.com>
 <20190513175138.4yycad2xi65komw6@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fd934a4c-f7d2-8a04-ed93-a3b690ed0d79@redhat.com>
Date:   Tue, 14 May 2019 11:38:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190513175138.4yycad2xi65komw6@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 14 May 2019 03:38:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/14 上午1:51, Stefano Garzarella wrote:
> On Mon, May 13, 2019 at 06:01:52PM +0800, Jason Wang wrote:
>> On 2019/5/10 下午8:58, Stefano Garzarella wrote:
>>> In order to increase host -> guest throughput with large packets,
>>> we can use 64 KiB RX buffers.
>>>
>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>> ---
>>>    include/linux/virtio_vsock.h | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>> index 84b72026d327..5a9d25be72df 100644
>>> --- a/include/linux/virtio_vsock.h
>>> +++ b/include/linux/virtio_vsock.h
>>> @@ -10,7 +10,7 @@
>>>    #define VIRTIO_VSOCK_DEFAULT_MIN_BUF_SIZE	128
>>>    #define VIRTIO_VSOCK_DEFAULT_BUF_SIZE		(1024 * 256)
>>>    #define VIRTIO_VSOCK_DEFAULT_MAX_BUF_SIZE	(1024 * 256)
>>> -#define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 4)
>>> +#define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 64)
>>>    #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
>>>    #define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
>>
>> We probably don't want such high order allocation. It's better to switch to
>> use order 0 pages in this case. See add_recvbuf_big() for virtio-net. If we
>> get datapath unified, we will get more stuffs set.
> IIUC, you are suggesting to allocate only pages and put them in a
> scatterlist, then add them to the virtqueue.
>
> Is it correct?


Yes since you are using:

                 pkt->buf = kmalloc(buf_len, GFP_KERNEL);
                 if (!pkt->buf) {
                         virtio_transport_free_pkt(pkt);
                         break;
                 }

This is likely to fail when the memory is fragmented which is kind of 
fragile.


>
> The issue that I have here, is that the virtio-vsock guest driver, see
> virtio_vsock_rx_fill(), allocates a struct virtio_vsock_pkt that
> contains the room for the header, then allocates the buffer for the payload.
> At this point it fills the scatterlist with the &virtio_vsock_pkt.hdr and the
> buffer for the payload.


This part should be fine since what is needed is just adding more pages 
to sg[] and call virtuqeueu_add_sg().


>
> Changing this will require several modifications, and if we get datapath
> unified, I'm not sure it's worth it.
> Of course, if we leave the datapaths separated, I'd like to do that later.
>
> What do you think?


For the driver it self, it should not be hard. But I think you mean the 
issue of e.g virtio_vsock_pkt itself which doesn't support sg. For short 
time, maybe we can use kvec instead.

Thanks


>
> Thanks,
> Stefano
