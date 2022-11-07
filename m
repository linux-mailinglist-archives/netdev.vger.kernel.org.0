Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD9762010D
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 22:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbiKGVZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 16:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbiKGVYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 16:24:43 -0500
Received: from smtp.smtpout.orange.fr (smtp-24.smtpout.orange.fr [80.12.242.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6BA2F663
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 13:24:12 -0800 (PST)
Received: from [192.168.1.18] ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id s9bCo3csCUoLVs9bCoTgdm; Mon, 07 Nov 2022 22:24:10 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 07 Nov 2022 22:24:10 +0100
X-ME-IP: 86.243.100.34
Message-ID: <6a0adc0d-da54-9c9b-3596-3422353e285d@wanadoo.fr>
Date:   Mon, 7 Nov 2022 22:24:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [RFC PATCH v3 01/11] virtio/vsock: rework packet allocation logic
Content-Language: fr, en-CA
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
References: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru>
 <f896b8fd-50d2-2512-3966-3775245e9b96@sberdevices.ru>
 <3c6de80a-8fc1-0c63-6d2d-3eee294fe0a7@wanadoo.fr>
 <278ee0cc-83ae-5c26-7718-d0472841e049@sberdevices.ru>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <278ee0cc-83ae-5c26-7718-d0472841e049@sberdevices.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 07/11/2022 à 06:23, Arseniy Krasnov a écrit :
> On 06.11.2022 22:50, Christophe JAILLET wrote:
>> Le 06/11/2022 à 20:36, Arseniy Krasnov a écrit :
>>> To support zerocopy receive, packet's buffer allocation is changed: for
>>> buffers which could be mapped to user's vma we can't use 'kmalloc()'(as
>>> kernel restricts to map slab pages to user's vma) and raw buddy
>>> allocator now called. But, for tx packets(such packets won't be mapped
>>> to user), previous 'kmalloc()' way is used, but with special flag in
>>> packet's structure which allows to distinguish between 'kmalloc()' and
>>> raw pages buffers.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>>    drivers/vhost/vsock.c                   |  1 +
>>>    include/linux/virtio_vsock.h            |  1 +
>>>    net/vmw_vsock/virtio_transport.c        |  8 ++++++--
>>>    net/vmw_vsock/virtio_transport_common.c | 10 +++++++++-
>>>    4 files changed, 17 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>>> index 5703775af129..65475d128a1d 100644
>>> --- a/drivers/vhost/vsock.c
>>> +++ b/drivers/vhost/vsock.c
>>> @@ -399,6 +399,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
>>>            return NULL;
>>>        }
>>>    +    pkt->slab_buf = true;
>>>        pkt->buf_len = pkt->len;
>>>          nbytes = copy_from_iter(pkt->buf, pkt->len, &iov_iter);
>>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>>> index 35d7eedb5e8e..d02cb7aa922f 100644
>>> --- a/include/linux/virtio_vsock.h
>>> +++ b/include/linux/virtio_vsock.h
>>> @@ -50,6 +50,7 @@ struct virtio_vsock_pkt {
>>>        u32 off;
>>>        bool reply;
>>>        bool tap_delivered;
>>> +    bool slab_buf;
>>>    };
>>>      struct virtio_vsock_pkt_info {
>>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>> index ad64f403536a..19909c1e9ba3 100644
>>> --- a/net/vmw_vsock/virtio_transport.c
>>> +++ b/net/vmw_vsock/virtio_transport.c
>>> @@ -255,16 +255,20 @@ static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
>>>        vq = vsock->vqs[VSOCK_VQ_RX];
>>>          do {
>>> +        struct page *buf_page;
>>> +
>>>            pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
>>>            if (!pkt)
>>>                break;
>>>    -        pkt->buf = kmalloc(buf_len, GFP_KERNEL);
>>> -        if (!pkt->buf) {
>>> +        buf_page = alloc_page(GFP_KERNEL);
>>> +
>>> +        if (!buf_page) {
>>>                virtio_transport_free_pkt(pkt);
>>>                break;
>>>            }
>>>    +        pkt->buf = page_to_virt(buf_page);
>>>            pkt->buf_len = buf_len;
>>>            pkt->len = buf_len;
>>>    diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> index a9980e9b9304..37e8dbfe2f5d 100644
>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> @@ -69,6 +69,7 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
>>>            if (!pkt->buf)
>>>                goto out_pkt;
>>>    +        pkt->slab_buf = true;
>>>            pkt->buf_len = len;
>>>              err = memcpy_from_msg(pkt->buf, info->msg, len);
>>> @@ -1339,7 +1340,14 @@ EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
>>>      void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
>>>    {
>>> -    kvfree(pkt->buf);
>>> +    if (pkt->buf_len) {
>>> +        if (pkt->slab_buf)
>>> +            kvfree(pkt->buf);
>>
>> Hi,
>>
>> kfree()? (according to virtio_transport_alloc_pkt() in -next) or something else need to be changed.
>>
> Hello Cristophe,
> 
> I think, 'kvfree()' is still needed here, because buffer for packet could be allocated by 'kvmalloc()'
> in drivers/vhost/vsock.c. Correct me if i'm wrong.

Agreed.

> 
>>> +        else
>>> +            free_pages((unsigned long)pkt->buf,
>>> +                   get_order(pkt->buf_len));
>>
>> In virtio_vsock_rx_fill(), only alloc_page() is used.
>>
>> Should this be alloc_pages(.., get_order(buf_len)) or free_page() (without an 's') here?
> This function frees packets which were allocated in vhost path also. In vhost, for zerocopy
> packets alloc_pageS() is used.

Ok. Seen in patch 5/11.

But wouldn't it be cleaner and future-proof to also have alloc_pageS() 
in virtio_vsock_rx_fill(), even if get_order(buf->len) is kwown to be 0?

What, if for some reason a PAGE_SIZE was < 4kb for a given arch, or 
VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE increased?

CJ

> 
> Thank You, Arseniy
>>
>> Just my 2c,
>>
>> CJ
>>
>>> +    }
>>> +
>>>        kfree(pkt);
>>>    }
>>>    EXPORT_SYMBOL_GPL(virtio_transport_free_pkt);
>>
> 

