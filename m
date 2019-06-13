Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E69F43EE9
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731605AbfFMPxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:53:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731597AbfFMI5a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 04:57:30 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1179030872E7;
        Thu, 13 Jun 2019 08:57:25 +0000 (UTC)
Received: from [10.72.12.64] (ovpn-12-64.pek2.redhat.com [10.72.12.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9501880C0;
        Thu, 13 Jun 2019 08:57:16 +0000 (UTC)
Subject: Re: [PATCH 3/4] vsock/virtio: fix flush of works during the .remove()
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S . Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20190528105623.27983-1-sgarzare@redhat.com>
 <20190528105623.27983-4-sgarzare@redhat.com>
 <9ac9fc4b-5c39-2503-dfbb-660a7bdcfbfd@redhat.com>
 <20190529105832.oz3sagbne5teq3nt@steredhat>
 <8c9998c8-1b9c-aac6-42eb-135fcb966187@redhat.com>
 <20190530101036.wnjphmajrz6nz6zc@steredhat.homenet.telecomitalia.it>
 <4c881585-8fee-0a53-865c-05d41ffb8ed1@redhat.com>
 <20190531081824.p6ylsgvkrbckhqpx@steredhat>
 <dbc9964c-65b1-0993-488b-cb44aea55e90@redhat.com>
 <20190606081109.gdx4rsly5i6gtg57@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b1fa0b2f-f7d0-8117-0bde-0cb78d1a3d07@redhat.com>
Date:   Thu, 13 Jun 2019 16:57:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190606081109.gdx4rsly5i6gtg57@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 13 Jun 2019 08:57:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/6/6 下午4:11, Stefano Garzarella wrote:
> On Fri, May 31, 2019 at 05:56:39PM +0800, Jason Wang wrote:
>> On 2019/5/31 下午4:18, Stefano Garzarella wrote:
>>> On Thu, May 30, 2019 at 07:59:14PM +0800, Jason Wang wrote:
>>>> On 2019/5/30 下午6:10, Stefano Garzarella wrote:
>>>>> On Thu, May 30, 2019 at 05:46:18PM +0800, Jason Wang wrote:
>>>>>> On 2019/5/29 下午6:58, Stefano Garzarella wrote:
>>>>>>> On Wed, May 29, 2019 at 11:22:40AM +0800, Jason Wang wrote:
>>>>>>>> On 2019/5/28 下午6:56, Stefano Garzarella wrote:
>>>>>>>>> @@ -690,6 +693,9 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
>>>>>>>>>       	vsock->event_run = false;
>>>>>>>>>       	mutex_unlock(&vsock->event_lock);
>>>>>>>>> +	/* Flush all pending works */
>>>>>>>>> +	virtio_vsock_flush_works(vsock);
>>>>>>>>> +
>>>>>>>>>       	/* Flush all device writes and interrupts, device will not use any
>>>>>>>>>       	 * more buffers.
>>>>>>>>>       	 */
>>>>>>>>> @@ -726,6 +732,11 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
>>>>>>>>>       	/* Delete virtqueues and flush outstanding callbacks if any */
>>>>>>>>>       	vdev->config->del_vqs(vdev);
>>>>>>>>> +	/* Other works can be queued before 'config->del_vqs()', so we flush
>>>>>>>>> +	 * all works before to free the vsock object to avoid use after free.
>>>>>>>>> +	 */
>>>>>>>>> +	virtio_vsock_flush_works(vsock);
>>>>>>>> Some questions after a quick glance:
>>>>>>>>
>>>>>>>> 1) It looks to me that the work could be queued from the path of
>>>>>>>> vsock_transport_cancel_pkt() . Is that synchronized here?
>>>>>>>>
>>>>>>> Both virtio_transport_send_pkt() and vsock_transport_cancel_pkt() can
>>>>>>> queue work from the upper layer (socket).
>>>>>>>
>>>>>>> Setting the_virtio_vsock to NULL, should synchronize, but after a careful look
>>>>>>> a rare issue could happen:
>>>>>>> we are setting the_virtio_vsock to NULL at the start of .remove() and we
>>>>>>> are freeing the object pointed by it at the end of .remove(), so
>>>>>>> virtio_transport_send_pkt() or vsock_transport_cancel_pkt() may still be
>>>>>>> running, accessing the object that we are freed.
>>>>>> Yes, that's my point.
>>>>>>
>>>>>>
>>>>>>> Should I use something like RCU to prevent this issue?
>>>>>>>
>>>>>>>         virtio_transport_send_pkt() and vsock_transport_cancel_pkt()
>>>>>>>         {
>>>>>>>             rcu_read_lock();
>>>>>>>             vsock = rcu_dereference(the_virtio_vsock_mutex);
>>>>>> RCU is probably a way to go. (Like what vhost_transport_send_pkt() did).
>>>>>>
>>>>> Okay, I'm going this way.
>>>>>
>>>>>>>             ...
>>>>>>>             rcu_read_unlock();
>>>>>>>         }
>>>>>>>
>>>>>>>         virtio_vsock_remove()
>>>>>>>         {
>>>>>>>             rcu_assign_pointer(the_virtio_vsock_mutex, NULL);
>>>>>>>             synchronize_rcu();
>>>>>>>
>>>>>>>             ...
>>>>>>>
>>>>>>>             free(vsock);
>>>>>>>         }
>>>>>>>
>>>>>>> Could there be a better approach?
>>>>>>>
>>>>>>>
>>>>>>>> 2) If we decide to flush after dev_vqs(), is tx_run/rx_run/event_run still
>>>>>>>> needed? It looks to me we've already done except that we need flush rx_work
>>>>>>>> in the end since send_pkt_work can requeue rx_work.
>>>>>>> The main reason of tx_run/rx_run/event_run is to prevent that a worker
>>>>>>> function is running while we are calling config->reset().
>>>>>>>
>>>>>>> E.g. if an interrupt comes between virtio_vsock_flush_works() and
>>>>>>> config->reset(), it can queue new works that can access the device while
>>>>>>> we are in config->reset().
>>>>>>>
>>>>>>> IMHO they are still needed.
>>>>>>>
>>>>>>> What do you think?
>>>>>> I mean could we simply do flush after reset once and without tx_rx/rx_run
>>>>>> tricks?
>>>>>>
>>>>>> rest();
>>>>>>
>>>>>> virtio_vsock_flush_work();
>>>>>>
>>>>>> virtio_vsock_free_buf();
>>>>> My only doubt is:
>>>>> is it safe to call config->reset() while a worker function could access
>>>>> the device?
>>>>>
>>>>> I had this doubt reading the Michael's advice[1] and looking at
>>>>> virtnet_remove() where there are these lines before the config->reset():
>>>>>
>>>>> 	/* Make sure no work handler is accessing the device. */
>>>>> 	flush_work(&vi->config_work);
>>>>>
>>>>> Thanks,
>>>>> Stefano
>>>>>
>>>>> [1] https://lore.kernel.org/netdev/20190521055650-mutt-send-email-mst@kernel.org
>>>> Good point. Then I agree with you. But if we can use the RCU to detect the
>>>> detach of device from socket for these, it would be even better.
>>>>
>>> What about checking 'the_virtio_vsock' in the worker functions in a RCU
>>> critical section?
>>> In this way, I can remove the rx_run/tx_run/event_run.
>>>
>>> Do you think it's cleaner?
>>
>> Yes, I think so.
>>
> Hi Jason,
> while I was trying to use RCU also for workers, I discovered that it can
> not be used if we can sleep. (Workers have mutex, memory allocation, etc.).
> There is SRCU, but I think the rx_run/tx_run/event_run is cleaner.
>
> So, if you agree I'd send a v2 using RCU only for the
> virtio_transport_send_pkt() or vsock_transport_cancel_pkt(), and leave
> this patch as is to be sure that no one is accessing the device while we
> call config->reset().
>
> Thanks,
> Stefano


If it work, I don't object to use that consider it was suggested by 
Michael. You can go this way and let's see.

Personally I would like something more cleaner. E.g RCU + some kind of 
reference count (kref?).

Thanks

