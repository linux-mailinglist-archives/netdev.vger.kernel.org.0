Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027A73D066D
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 03:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhGUAuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 20:50:01 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:40950 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229668AbhGUAt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 20:49:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UgSrlgR_1626831028;
Received: from B-LB6YLVDL-0141.local(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0UgSrlgR_1626831028)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 21 Jul 2021 09:30:33 +0800
Subject: Re: [PATCH v2] vsock/virtio: set vsock frontend ready in
 virtio_vsock_probe()
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     sgarzare@redhat.com, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210720071337.1995-1-xianting.tian@linux.alibaba.com>
 <YPakBTVDbgVcTGQX@stefanha-x1.localdomain>
 <b48bd02d-9514-ec0c-3779-fd5ddc5c2d3d@linux.alibaba.com>
 <YPbL0QIgbAh/PBuC@stefanha-x1.localdomain>
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
Message-ID: <bb4e1c15-a11e-9c73-0c7e-63d65dcb6b4b@linux.alibaba.com>
Date:   Wed, 21 Jul 2021 09:30:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPbL0QIgbAh/PBuC@stefanha-x1.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Got it.

thanks for the comments,


在 2021/7/20 下午9:12, Stefan Hajnoczi 写道:
> On Tue, Jul 20, 2021 at 07:05:39PM +0800, Xianting Tian wrote:
>> 在 2021/7/20 下午6:23, Stefan Hajnoczi 写道:
>>> On Tue, Jul 20, 2021 at 03:13:37PM +0800, Xianting Tian wrote:
>>>> Add the missed virtio_device_ready() to set vsock frontend ready.
>>>>
>>>> Signed-off-by: Xianting Tian<xianting.tian@linux.alibaba.com>
>>>> ---
>>>>    net/vmw_vsock/virtio_transport.c | 2 ++
>>>>    1 file changed, 2 insertions(+)
>>> Please include a changelog when you send v2, v3, etc patches.
>> OK, thanks.
>>>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>>> index e0c2c992a..dc834b8fd 100644
>>>> --- a/net/vmw_vsock/virtio_transport.c
>>>> +++ b/net/vmw_vsock/virtio_transport.c
>>>> @@ -639,6 +639,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>>>    	mutex_unlock(&the_virtio_vsock_mutex);
>>>> +	virtio_device_ready(vdev);
>>> Why is this patch necessary?
>> Sorry, I didn't notice the check in virtio_dev_probe(),
>>
>> As Jason comment,  I alsoe think we need to be consistent: switch to use
>> virtio_device_ready() for all the drivers. What's opinion about this?
> According to the documentation the virtio_device_read() API is optional:
>
>    /**
>     * virtio_device_ready - enable vq use in probe function
>     * @vdev: the device
>     *
>     * Driver must call this to use vqs in the probe function.
>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>     *
>     * Note: vqs are enabled automatically after probe returns.
>       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>     */
>
> Many drivers do not use vqs during the ->probe() function. They don't
> need to call virtio_device_ready(). That's why the virtio_vsock driver
> doesn't call it.
>
> But if a ->probe() function needs to send virtqueue buffers, e.g. to
> query the device or activate some device feature, then the driver will
> need to call it explicitly.
>
> The documentation is clear and this design is less error-prone than
> relying on all drivers to call it manually. I suggest leaving things
> unchanged.
>
> Stefan
