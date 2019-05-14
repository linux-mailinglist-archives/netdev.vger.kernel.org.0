Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C73F1C114
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 05:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfENDkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 23:40:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbfENDkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 23:40:22 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 763A2C058CA8;
        Tue, 14 May 2019 03:40:21 +0000 (UTC)
Received: from [10.72.12.59] (ovpn-12-59.pek2.redhat.com [10.72.12.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B61C419C67;
        Tue, 14 May 2019 03:40:12 +0000 (UTC)
Subject: Re: [PATCH v2 1/8] vsock/virtio: limit the memory used per-socket
From:   Jason Wang <jasowang@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20190510125843.95587-1-sgarzare@redhat.com>
 <20190510125843.95587-2-sgarzare@redhat.com>
 <3b275b52-63d9-d260-1652-8e8bf7dd679f@redhat.com>
 <20190513172322.vcgenx7xk4v6r2ay@steredhat>
 <f834c9e9-5d0e-8ebb-44e0-6d99b6284e5c@redhat.com>
Message-ID: <f8cf457e-c379-6f3c-f59a-2b844c8f893a@redhat.com>
Date:   Tue, 14 May 2019 11:40:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f834c9e9-5d0e-8ebb-44e0-6d99b6284e5c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 14 May 2019 03:40:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/14 上午11:25, Jason Wang wrote:
>
> On 2019/5/14 上午1:23, Stefano Garzarella wrote:
>> On Mon, May 13, 2019 at 05:58:53PM +0800, Jason Wang wrote:
>>> On 2019/5/10 下午8:58, Stefano Garzarella wrote:
>>>> Since virtio-vsock was introduced, the buffers filled by the host
>>>> and pushed to the guest using the vring, are directly queued in
>>>> a per-socket list avoiding to copy it.
>>>> These buffers are preallocated by the guest with a fixed
>>>> size (4 KB).
>>>>
>>>> The maximum amount of memory used by each socket should be
>>>> controlled by the credit mechanism.
>>>> The default credit available per-socket is 256 KB, but if we use
>>>> only 1 byte per packet, the guest can queue up to 262144 of 4 KB
>>>> buffers, using up to 1 GB of memory per-socket. In addition, the
>>>> guest will continue to fill the vring with new 4 KB free buffers
>>>> to avoid starvation of her sockets.
>>>>
>>>> This patch solves this issue copying the payload in a new buffer.
>>>> Then it is queued in the per-socket list, and the 4KB buffer used
>>>> by the host is freed.
>>>>
>>>> In this way, the memory used by each socket respects the credit
>>>> available, and we still avoid starvation, paying the cost of an
>>>> extra memory copy. When the buffer is completely full we do a
>>>> "zero-copy", moving the buffer directly in the per-socket list.
>>>
>>> I wonder in the long run we should use generic socket accouting 
>>> mechanism
>>> provided by kernel (e.g socket, skb, sndbuf, recvbug, truesize) 
>>> instead of
>>> vsock specific thing to avoid duplicating efforts.
>> I agree, the idea is to switch to sk_buff but this should require an 
>> huge
>> change. If we will use the virtio-net datapath, it will become simpler.
>
>
> Yes, unix domain socket is one example that uses general skb and 
> socket structure. And we probably need some kind of socket pair on 
> host. Using socket can also simplify the unification with vhost-net 
> which depends on the socket proto_ops to work. I admit it's a huge 
> change probably, we can do it gradually.
>
>
>>>
>>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>>> ---
>>>>    drivers/vhost/vsock.c                   |  2 +
>>>>    include/linux/virtio_vsock.h            |  8 +++
>>>>    net/vmw_vsock/virtio_transport.c        |  1 +
>>>>    net/vmw_vsock/virtio_transport_common.c | 95 
>>>> ++++++++++++++++++-------
>>>>    4 files changed, 81 insertions(+), 25 deletions(-)
>>>>
>>>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>>>> index bb5fc0e9fbc2..7964e2daee09 100644
>>>> --- a/drivers/vhost/vsock.c
>>>> +++ b/drivers/vhost/vsock.c
>>>> @@ -320,6 +320,8 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
>>>>            return NULL;
>>>>        }
>>>> +    pkt->buf_len = pkt->len;
>>>> +
>>>>        nbytes = copy_from_iter(pkt->buf, pkt->len, &iov_iter);
>>>>        if (nbytes != pkt->len) {
>>>>            vq_err(vq, "Expected %u byte payload, got %zu bytes\n",
>>>> diff --git a/include/linux/virtio_vsock.h 
>>>> b/include/linux/virtio_vsock.h
>>>> index e223e2632edd..345f04ee9193 100644
>>>> --- a/include/linux/virtio_vsock.h
>>>> +++ b/include/linux/virtio_vsock.h
>>>> @@ -54,9 +54,17 @@ struct virtio_vsock_pkt {
>>>>        void *buf;
>>>>        u32 len;
>>>>        u32 off;
>>>> +    u32 buf_len;
>>>>        bool reply;
>>>>    };
>>>> +struct virtio_vsock_buf {
>>>> +    struct list_head list;
>>>> +    void *addr;
>>>> +    u32 len;
>>>> +    u32 off;
>>>> +};
>>>> +
>>>>    struct virtio_vsock_pkt_info {
>>>>        u32 remote_cid, remote_port;
>>>>        struct vsock_sock *vsk;
>>>> diff --git a/net/vmw_vsock/virtio_transport.c 
>>>> b/net/vmw_vsock/virtio_transport.c
>>>> index 15eb5d3d4750..af1d2ce12f54 100644
>>>> --- a/net/vmw_vsock/virtio_transport.c
>>>> +++ b/net/vmw_vsock/virtio_transport.c
>>>> @@ -280,6 +280,7 @@ static void virtio_vsock_rx_fill(struct 
>>>> virtio_vsock *vsock)
>>>>                break;
>>>>            }
>>>> +        pkt->buf_len = buf_len;
>>>>            pkt->len = buf_len;
>>>>            sg_init_one(&hdr, &pkt->hdr, sizeof(pkt->hdr));
>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c 
>>>> b/net/vmw_vsock/virtio_transport_common.c
>>>> index 602715fc9a75..0248d6808755 100644
>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>> @@ -65,6 +65,9 @@ virtio_transport_alloc_pkt(struct 
>>>> virtio_vsock_pkt_info *info,
>>>>            pkt->buf = kmalloc(len, GFP_KERNEL);
>>>>            if (!pkt->buf)
>>>>                goto out_pkt;
>>>> +
>>>> +        pkt->buf_len = len;
>>>> +
>>>>            err = memcpy_from_msg(pkt->buf, info->msg, len);
>>>>            if (err)
>>>>                goto out;
>>>> @@ -86,6 +89,46 @@ virtio_transport_alloc_pkt(struct 
>>>> virtio_vsock_pkt_info *info,
>>>>        return NULL;
>>>>    }
>>>> +static struct virtio_vsock_buf *
>>>> +virtio_transport_alloc_buf(struct virtio_vsock_pkt *pkt, bool 
>>>> zero_copy)
>>>> +{
>>>> +    struct virtio_vsock_buf *buf;
>>>> +
>>>> +    if (pkt->len == 0)
>>>> +        return NULL;
>>>> +
>>>> +    buf = kzalloc(sizeof(*buf), GFP_KERNEL);
>>>> +    if (!buf)
>>>> +        return NULL;
>>>> +
>>>> +    /* If the buffer in the virtio_vsock_pkt is full, we can move 
>>>> it to
>>>> +     * the new virtio_vsock_buf avoiding the copy, because we are 
>>>> sure that
>>>> +     * we are not use more memory than that counted by the credit 
>>>> mechanism.
>>>> +     */
>>>> +    if (zero_copy && pkt->len == pkt->buf_len) {
>>>> +        buf->addr = pkt->buf;
>>>> +        pkt->buf = NULL;
>>>> +    } else {
>>>
>>> Is the copy still needed if we're just few bytes less? We meet 
>>> similar issue
>>> for virito-net, and virtio-net solve this by always copy first 
>>> 128bytes for
>>> big packets.
>>>
>>> See receive_big()
>> I'm seeing, It is more sophisticated.
>> IIUC, virtio-net allocates a sk_buff with 128 bytes of buffer, then 
>> copies the
>> first 128 bytes, then adds the buffer used to receive the packet as a 
>> frag to
>> the skb.
>
>
> Yes and the point is if the packet is smaller than 128 bytes the pages 
> will be recycled. 


To be clear, this only work if you use order 0 page instead of a large 
buffer that is allocated through kmalloc(). Another requirement for 
order 0 page.

Thanks


