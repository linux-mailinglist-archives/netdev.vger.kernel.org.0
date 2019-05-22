Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E28625C49
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 05:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbfEVDoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 23:44:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbfEVDoe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 23:44:34 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0BAB5307D855
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 03:44:34 +0000 (UTC)
Received: from [10.72.12.187] (ovpn-12-187.pek2.redhat.com [10.72.12.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1F9327CC3;
        Wed, 22 May 2019 03:44:27 +0000 (UTC)
Subject: Re: Question about IRQs during the .remove() of virtio-vsock driver
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>
References: <20190521094407.ltij4ggbd7xw25ge@steredhat>
 <20190521055650-mutt-send-email-mst@kernel.org>
 <20190521134920.pulvy5pqnertbafd@steredhat>
 <20190521095206-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d58c5a2e-6bb2-aae6-4765-a6205e156ae4@redhat.com>
Date:   Wed, 22 May 2019 11:44:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190521095206-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 22 May 2019 03:44:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/21 下午9:56, Michael S. Tsirkin wrote:
> On Tue, May 21, 2019 at 03:49:20PM +0200, Stefano Garzarella wrote:
>> On Tue, May 21, 2019 at 06:05:31AM -0400, Michael S. Tsirkin wrote:
>>> On Tue, May 21, 2019 at 11:44:07AM +0200, Stefano Garzarella wrote:
>>>> Hi Micheal, Jason,
>>>> as suggested by Stefan, I'm checking if we have some races in the
>>>> virtio-vsock driver. We found some races in the .probe() and .remove()
>>>> with the upper layer (socket) and I'll fix it.
>>>>
>>>> Now my attention is on the bottom layer (virtio device) and my question is:
>>>> during the .remove() of virtio-vsock driver (virtio_vsock_remove), could happen
>>>> that an IRQ comes and one of our callback (e.g. virtio_vsock_rx_done()) is
>>>> executed, queueing new works?
>>>>
>>>> I tried to follow the code in both cases (device unplugged or module removed)
>>>> and maybe it couldn't happen because we remove it from bus's knowledge,
>>>> but I'm not sure and your advice would be very helpful.
>>>>
>>>> Thanks in advance,
>>>> Stefano
>>>
>>> Great question! This should be better documented: patches welcome!
>> When I'm clear, I'll be happy to document this.
>>
>>> Here's my understanding:
>>>
>>>
>>> A typical removal flow works like this:
>>>
>>> - prevent linux from sending new kick requests to device
>>>    and flush such outstanding requests if any
>>>    (device can still send notifications to linux)
>>>
>>> - call
>>>            vi->vdev->config->reset(vi->vdev);
>>>    this will flush all device writes and interrupts.
>>>    device will not use any more buffers.
>>>    previously outstanding callbacks might still be active.
>>>
>>> - Then call
>>>            vdev->config->del_vqs(vdev);
>>>    to flush outstanding callbacks if any.
>> Thanks for sharing these useful information.
>>
>> So, IIUC between step 1 (e.g. in virtio-vsock we flush all work-queues) and
>> step 2, new IRQs could happen, and in the virtio-vsock driver new work
>> will be queued.
>>
>> In order to handle this case, I'm thinking to add a new variable
>> 'work_enabled' in the struct virtio_vsock, put it to false at the start
>> of the .remove(), then call synchronize_rcu() before to flush all work
>> queues
>> and use an helper function virtio_transport_queue_work() to queue
>> a new work, where the check of work_enabled and the queue_work are in the
>> RCU read critical section.
>>
>> Here a pseudo code to explain better the idea:
>>
>> virtio_vsock_remove() {
>>      vsock->work_enabled = false;
>>
>>      /* Wait for other CPUs to finish to queue works */
>>      synchronize_rcu();
>>
>>      flush_works();
>>
>>      vdev->config->reset(vdev);
>>
>>      ...
>>
>>      vdev->config->del_vqs(vdev);
>> }
>>
>> virtio_vsock_queue_work(vsock, work) {
>>      rcu_read_lock();
>>
>>      if (!vsock->work_enabled) {
>>          goto out;
>>      }
>>
>>      queue_work(virtio_vsock_workqueue, work);
>>
>> out:
>>      rcu_read_unlock();
>> }
>>
>>
>> Do you think can work?
>> Please tell me if there is a better way to handle this case.
>>
>> Thanks,
>> Stefano
>
> instead of rcu tricks I would just have rx_run and tx_run and check it
> within the queued work - presumably under tx or rx lock.
>
> then queueing an extra work becomes harmless,
> and you flush it after del vqs which flushes everything for you.
>
>

It looks to me that we need guarantee no work queued or scheduled before 
del_vqs. Otherwise it may lead use after free? (E.g net disable NAPI 
before del_vqs).

Thanks

