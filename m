Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D9C3CF899
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 13:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238431AbhGTKZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 06:25:11 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:52555 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236973AbhGTKZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 06:25:04 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UgQE4aC_1626779139;
Received: from B-LB6YLVDL-0141.local(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0UgQE4aC_1626779139)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 20 Jul 2021 19:05:40 +0800
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: Re: [PATCH v2] vsock/virtio: set vsock frontend ready in
 virtio_vsock_probe()
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     sgarzare@redhat.com, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210720071337.1995-1-xianting.tian@linux.alibaba.com>
 <YPakBTVDbgVcTGQX@stefanha-x1.localdomain>
Message-ID: <b48bd02d-9514-ec0c-3779-fd5ddc5c2d3d@linux.alibaba.com>
Date:   Tue, 20 Jul 2021 19:05:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPakBTVDbgVcTGQX@stefanha-x1.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/20 下午6:23, Stefan Hajnoczi 写道:
> On Tue, Jul 20, 2021 at 03:13:37PM +0800, Xianting Tian wrote:
>> Add the missed virtio_device_ready() to set vsock frontend ready.
>>
>> Signed-off-by: Xianting Tian<xianting.tian@linux.alibaba.com>
>> ---
>>   net/vmw_vsock/virtio_transport.c | 2 ++
>>   1 file changed, 2 insertions(+)
> Please include a changelog when you send v2, v3, etc patches.
OK, thanks.
>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> index e0c2c992a..dc834b8fd 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -639,6 +639,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>   
>>   	mutex_unlock(&the_virtio_vsock_mutex);
>>   
>> +	virtio_device_ready(vdev);
> Why is this patch necessary?

Sorry, I didn't notice the check in virtio_dev_probe(),

As Jason comment,  I alsoe think we need to be consistent: switch to use 
virtio_device_ready() for all the drivers. What's opinion about this?

> The core virtio_dev_probe() code already calls virtio_device_ready for
> us:
>
>    static int virtio_dev_probe(struct device *_d)
>    {
>        ...
>        err = drv->probe(dev);
>        if (err)
>            goto err;
>    
>        /* If probe didn't do it, mark device DRIVER_OK ourselves. */
>        if (!(dev->config->get_status(dev) & VIRTIO_CONFIG_S_DRIVER_OK))
>            virtio_device_ready(dev);
