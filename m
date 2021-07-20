Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2A53CF635
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 10:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhGTH4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 03:56:24 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:47188 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233854AbhGTH4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 03:56:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UgPIBvp_1626770213;
Received: from B-LB6YLVDL-0141.local(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0UgPIBvp_1626770213)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 20 Jul 2021 16:36:53 +0800
Subject: Re: [PATCH v2] vsock/virtio: set vsock frontend ready in
 virtio_vsock_probe()
To:     Jason Wang <jasowang@redhat.com>, stefanha@redhat.com,
        sgarzare@redhat.com, davem@davemloft.net, kuba@kernel.org
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210720071337.1995-1-xianting.tian@linux.alibaba.com>
 <87deb4ff-c4f9-0a5e-e349-c1a8682a864e@redhat.com>
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
Message-ID: <56bae568-34fc-4377-77cd-d3cf9f38a772@linux.alibaba.com>
Date:   Tue, 20 Jul 2021 16:36:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <87deb4ff-c4f9-0a5e-e349-c1a8682a864e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

thanks for the findings.

Let me make furture patches to make consistent.

在 2021/7/20 下午3:54, Jason Wang 写道:
>
> 在 2021/7/20 下午3:13, Xianting Tian 写道:
>> Add the missed virtio_device_ready() to set vsock frontend ready.
>>
>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>> ---
>>   net/vmw_vsock/virtio_transport.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/vmw_vsock/virtio_transport.c 
>> b/net/vmw_vsock/virtio_transport.c
>> index e0c2c992a..dc834b8fd 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -639,6 +639,8 @@ static int virtio_vsock_probe(struct 
>> virtio_device *vdev)
>>         mutex_unlock(&the_virtio_vsock_mutex);
>>   +    virtio_device_ready(vdev);
>> +
>>       return 0;
>>     out:
>
>
> Just notice this:
>
> commit 5b40a7daf51812b35cf05d1601a779a7043f8414
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Tue Feb 17 16:12:44 2015 +1030
>
>     virtio: don't set VIRTIO_CONFIG_S_DRIVER_OK twice.
>
>     I noticed this with the console device.  It's not *wrong*, just a bit
>     weird.
>
>     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index b9f70dfc4751..5ce2aa48fc6e 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -236,7 +236,10 @@ static int virtio_dev_probe(struct device *_d)
>         if (err)
>                 goto err;
>
> -       add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK);
> +       /* If probe didn't do it, mark device DRIVER_OK ourselves. */
> +       if (!(dev->config->get_status(dev) & VIRTIO_CONFIG_S_DRIVER_OK))
> +               virtio_device_ready(dev);
> +
>         if (drv->scan)
>                 drv->scan(dev);
>
> So I think we need to be consistent: switch to use 
> virtio_device_ready() for all the drivers, and then we can remove this 
> step and warn if (DRIVER_OK) is not set.
>
> Thanks
