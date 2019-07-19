Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864F16E264
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 10:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfGSIWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 04:22:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfGSIWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 04:22:04 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95A7630860D3;
        Fri, 19 Jul 2019 08:22:03 +0000 (UTC)
Received: from [10.72.12.179] (ovpn-12-179.pek2.redhat.com [10.72.12.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 147D65DA35;
        Fri, 19 Jul 2019 08:21:53 +0000 (UTC)
Subject: Re: [PATCH v4 4/5] vhost/vsock: split packets to send using multiple
 buffers
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-5-sgarzare@redhat.com>
 <20190717105336-mutt-send-email-mst@kernel.org>
 <CAGxU2F45v40qAOHkm1Hk2E69gCS0UwVgS5NS+tDXXuzdF4EixA@mail.gmail.com>
 <20190718041234-mutt-send-email-mst@kernel.org>
 <CAGxU2F6oo7Cou7t9o=gG2=wxHMKX9xYQXNxVtDYeHq5fyEhJWg@mail.gmail.com>
 <20190718072741-mutt-send-email-mst@kernel.org>
 <20190719080832.7hoeus23zjyrx3cc@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fcd19719-e5a9-adad-1e6c-c84487187088@redhat.com>
Date:   Fri, 19 Jul 2019 16:21:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190719080832.7hoeus23zjyrx3cc@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 19 Jul 2019 08:22:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/19 下午4:08, Stefano Garzarella wrote:
> On Thu, Jul 18, 2019 at 07:35:46AM -0400, Michael S. Tsirkin wrote:
>> On Thu, Jul 18, 2019 at 11:37:30AM +0200, Stefano Garzarella wrote:
>>> On Thu, Jul 18, 2019 at 10:13 AM Michael S. Tsirkin<mst@redhat.com>  wrote:
>>>> On Thu, Jul 18, 2019 at 09:50:14AM +0200, Stefano Garzarella wrote:
>>>>> On Wed, Jul 17, 2019 at 4:55 PM Michael S. Tsirkin<mst@redhat.com>  wrote:
>>>>>> On Wed, Jul 17, 2019 at 01:30:29PM +0200, Stefano Garzarella wrote:
>>>>>>> If the packets to sent to the guest are bigger than the buffer
>>>>>>> available, we can split them, using multiple buffers and fixing
>>>>>>> the length in the packet header.
>>>>>>> This is safe since virtio-vsock supports only stream sockets.
>>>>>>>
>>>>>>> Signed-off-by: Stefano Garzarella<sgarzare@redhat.com>
>>>>>> So how does it work right now? If an app
>>>>>> does sendmsg with a 64K buffer and the other
>>>>>> side publishes 4K buffers - does it just stall?
>>>>> Before this series, the 64K (or bigger) user messages was split in 4K packets
>>>>> (fixed in the code) and queued in an internal list for the TX worker.
>>>>>
>>>>> After this series, we will queue up to 64K packets and then it will be split in
>>>>> the TX worker, depending on the size of the buffers available in the
>>>>> vring. (The idea was to allow EWMA or a configuration of the buffers size, but
>>>>> for now we postponed it)
>>>> Got it. Using workers for xmit is IMHO a bad idea btw.
>>>> Why is it done like this?
>>> Honestly, I don't know the exact reasons for this design, but I suppose
>>> that the idea was to have only one worker that uses the vring, and
>>> multiple user threads that enqueue packets in the list.
>>> This can simplify the code and we can put the user threads to sleep if
>>> we don't have "credit" available (this means that the receiver doesn't
>>> have space to receive the packet).
>> I think you mean the reverse: even without credits you can copy from
>> user and queue up data, then process it without waking up the user
>> thread.
> I checked the code better, but it doesn't seem to do that.
> The .sendmsg callback of af_vsock, check if the transport has space
> (virtio-vsock transport returns the credit available). If there is no
> space, it put the thread to sleep on the 'sk_sleep(sk)' wait_queue.
>
> When the transport receives an update of credit available on the other
> peer, it calls 'sk->sk_write_space(sk)' that wakes up the thread
> sleeping, that will queue the new packet.
>
> So, in the current implementation, the TX worker doesn't check the
> credit available, it only sends the packets.
>
>> Does it help though? It certainly adds up work outside of
>> user thread context which means it's not accounted for
>> correctly.
> I can try to xmit the packet directly in the user thread context, to see
> the improvements.


It will then looks more like what virtio-net (and other networking 
device) did.


>
>> Maybe we want more VQs. Would help improve parallelism. The question
>> would then become how to map sockets to VQs. With a simple hash
>> it's easy to create collisions ...
> Yes, more VQs can help but the map question is not simple to answer.
> Maybe we can do an hash on the (cid, port) or do some kind of estimation
> of queue utilization and try to balance.
> Should the mapping be unique?


It sounds to me you want some kind of fair queuing? We've already had 
several qdiscs that do this.

So if we use the kernel networking xmit path, all those issues could be 
addressed.

Thanks

>
