Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 455222D309
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfE2A7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:59:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60584 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfE2A7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 20:59:12 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1B66DC049D7C;
        Wed, 29 May 2019 00:59:12 +0000 (UTC)
Received: from [10.72.12.48] (ovpn-12-48.pek2.redhat.com [10.72.12.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C414760BF1;
        Wed, 29 May 2019 00:59:04 +0000 (UTC)
Subject: Re: [PATCH v2 1/8] vsock/virtio: limit the memory used per-socket
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20190510125843.95587-1-sgarzare@redhat.com>
 <20190510125843.95587-2-sgarzare@redhat.com>
 <3b275b52-63d9-d260-1652-8e8bf7dd679f@redhat.com>
 <20190513172322.vcgenx7xk4v6r2ay@steredhat>
 <f834c9e9-5d0e-8ebb-44e0-6d99b6284e5c@redhat.com>
 <20190514163500.a7moalixvpn5mkcr@steredhat>
 <034a5081-b4fb-011f-b5b7-fbf293c13b23@redhat.com>
 <20190528164521.k2euedfcmtvvynew@steredhat.homenet.telecomitalia.it>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3f0019cc-29b5-1ddd-fbcf-d5f1716ca802@redhat.com>
Date:   Wed, 29 May 2019 08:59:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190528164521.k2euedfcmtvvynew@steredhat.homenet.telecomitalia.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 29 May 2019 00:59:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/29 上午12:45, Stefano Garzarella wrote:
> On Wed, May 15, 2019 at 10:48:44AM +0800, Jason Wang wrote:
>> On 2019/5/15 上午12:35, Stefano Garzarella wrote:
>>> On Tue, May 14, 2019 at 11:25:34AM +0800, Jason Wang wrote:
>>>> On 2019/5/14 上午1:23, Stefano Garzarella wrote:
>>>>> On Mon, May 13, 2019 at 05:58:53PM +0800, Jason Wang wrote:
>>>>>> On 2019/5/10 下午8:58, Stefano Garzarella wrote:
>>>>>>> +static struct virtio_vsock_buf *
>>>>>>> +virtio_transport_alloc_buf(struct virtio_vsock_pkt *pkt, bool zero_copy)
>>>>>>> +{
>>>>>>> +	struct virtio_vsock_buf *buf;
>>>>>>> +
>>>>>>> +	if (pkt->len == 0)
>>>>>>> +		return NULL;
>>>>>>> +
>>>>>>> +	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
>>>>>>> +	if (!buf)
>>>>>>> +		return NULL;
>>>>>>> +
>>>>>>> +	/* If the buffer in the virtio_vsock_pkt is full, we can move it to
>>>>>>> +	 * the new virtio_vsock_buf avoiding the copy, because we are sure that
>>>>>>> +	 * we are not use more memory than that counted by the credit mechanism.
>>>>>>> +	 */
>>>>>>> +	if (zero_copy && pkt->len == pkt->buf_len) {
>>>>>>> +		buf->addr = pkt->buf;
>>>>>>> +		pkt->buf = NULL;
>>>>>>> +	} else {
>>>>>> Is the copy still needed if we're just few bytes less? We meet similar issue
>>>>>> for virito-net, and virtio-net solve this by always copy first 128bytes for
>>>>>> big packets.
>>>>>>
>>>>>> See receive_big()
>>>>> I'm seeing, It is more sophisticated.
>>>>> IIUC, virtio-net allocates a sk_buff with 128 bytes of buffer, then copies the
>>>>> first 128 bytes, then adds the buffer used to receive the packet as a frag to
>>>>> the skb.
>>>> Yes and the point is if the packet is smaller than 128 bytes the pages will
>>>> be recycled.
>>>>
>>>>
>>> So it's avoid the overhead of allocation of a large buffer. I got it.
>>>
>>> Just a curiosity, why the threshold is 128 bytes?
>>
>>  From its name (GOOD_COPY_LEN), I think it just a value that won't lose much
>> performance, e.g the size two cachelines.
>>
> Jason, Stefan,
> since I'm removing the patches to increase the buffers to 64 KiB and I'm
> adding a threshold for small packets, I would simplify this patch,
> removing the new buffer allocation and copying small packets into the
> buffers already queued (if there is a space).
> In this way, I should solve the issue of 1 byte packets.
>
> Do you think could be better?


I think so.

Thanks


>
> Thanks,
> Stefano
