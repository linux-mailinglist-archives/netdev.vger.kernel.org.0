Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D60D66AC9
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 12:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfGLKO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 06:14:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50982 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfGLKO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 06:14:56 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 13BA04ACDF;
        Fri, 12 Jul 2019 10:14:56 +0000 (UTC)
Received: from [10.72.12.40] (ovpn-12-40.pek2.redhat.com [10.72.12.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF5DE5DAAC;
        Fri, 12 Jul 2019 10:14:48 +0000 (UTC)
Subject: Re: [RFC] virtio-net: share receive_*() and add_recvbuf_*() with
 virtio-vsock
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20190710153707.twmzgmwqqw3pstos@steredhat>
 <9574bc38-4c5c-2325-986b-430e4a2b6661@redhat.com>
 <20190711114134.xhmpciyglb2angl6@steredhat>
 <20190711152855-mutt-send-email-mst@kernel.org>
 <20190712100033.xs3xesz2plfwj3ag@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a514d8a4-3a12-feeb-4467-af7a9fbf5183@redhat.com>
Date:   Fri, 12 Jul 2019 18:14:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712100033.xs3xesz2plfwj3ag@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 12 Jul 2019 10:14:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/12 下午6:00, Stefano Garzarella wrote:
> On Thu, Jul 11, 2019 at 03:52:21PM -0400, Michael S. Tsirkin wrote:
>> On Thu, Jul 11, 2019 at 01:41:34PM +0200, Stefano Garzarella wrote:
>>> On Thu, Jul 11, 2019 at 03:37:00PM +0800, Jason Wang wrote:
>>>> On 2019/7/10 下午11:37, Stefano Garzarella wrote:
>>>>> Hi,
>>>>> as Jason suggested some months ago, I looked better at the virtio-net driver to
>>>>> understand if we can reuse some parts also in the virtio-vsock driver, since we
>>>>> have similar challenges (mergeable buffers, page allocation, small
>>>>> packets, etc.).
>>>>>
>>>>> Initially, I would add the skbuff in the virtio-vsock in order to re-use
>>>>> receive_*() functions.
>>>>
>>>> Yes, that will be a good step.
>>>>
>>> Okay, I'll go on this way.
>>>
>>>>> Then I would move receive_[small, big, mergeable]() and
>>>>> add_recvbuf_[small, big, mergeable]() outside of virtio-net driver, in order to
>>>>> call them also from virtio-vsock. I need to do some refactoring (e.g. leave the
>>>>> XDP part on the virtio-net driver), but I think it is feasible.
>>>>>
>>>>> The idea is to create a virtio-skb.[h,c] where put these functions and a new
>>>>> object where stores some attributes needed (e.g. hdr_len ) and status (e.g.
>>>>> some fields of struct receive_queue).
>>>>
>>>> My understanding is we could be more ambitious here. Do you see any blocker
>>>> for reusing virtio-net directly? It's better to reuse not only the functions
>>>> but also the logic like NAPI to avoid re-inventing something buggy and
>>>> duplicated.
>>>>
>>> These are my concerns:
>>> - virtio-vsock is not a "net_device", so a lot of code related to
>>>    ethtool, net devices (MAC address, MTU, speed, VLAN, XDP, offloading) will be
>>>    not used by virtio-vsock.


Linux support device other than ethernet, so it should not be a problem.


>>>
>>> - virtio-vsock has a different header. We can consider it as part of
>>>    virtio_net payload, but it precludes the compatibility with old hosts. This
>>>    was one of the major doubts that made me think about using only the
>>>    send/recv skbuff functions, that it shouldn't break the compatibility.


We can extend the current vnet header helper for it to work for vsock.


>>>
>>>>> This is an idea of virtio-skb.h that
>>>>> I have in mind:
>>>>>       struct virtskb;
>>>>
>>>> What fields do you want to store in virtskb? It looks to be exist sk_buff is
>>>> flexible enough to us?
>>> My idea is to store queues information, like struct receive_queue or
>>> struct send_queue, and some device attributes (e.g. hdr_len ).


If you reuse skb or virtnet_info, there is not necessary.


>>>
>>>>
>>>>>       struct sk_buff *virtskb_receive_small(struct virtskb *vs, ...);
>>>>>       struct sk_buff *virtskb_receive_big(struct virtskb *vs, ...);
>>>>>       struct sk_buff *virtskb_receive_mergeable(struct virtskb *vs, ...);
>>>>>
>>>>>       int virtskb_add_recvbuf_small(struct virtskb*vs, ...);
>>>>>       int virtskb_add_recvbuf_big(struct virtskb *vs, ...);
>>>>>       int virtskb_add_recvbuf_mergeable(struct virtskb *vs, ...);
>>>>>
>>>>> For the Guest->Host path it should be easier, so maybe I can add a
>>>>> "virtskb_send(struct virtskb *vs, struct sk_buff *skb)" with a part of the code
>>>>> of xmit_skb().
>>>>
>>>> I may miss something, but I don't see any thing that prevents us from using
>>>> xmit_skb() directly.
>>>>
>>> Yes, but my initial idea was to make it more parametric and not related to the
>>> virtio_net_hdr, so the 'hdr_len' could be a parameter and the
>>> 'num_buffers' should be handled by the caller.
>>>
>>>>> Let me know if you have in mind better names or if I should put these function
>>>>> in another place.
>>>>>
>>>>> I would like to leave the control part completely separate, so, for example,
>>>>> the two drivers will negotiate the features independently and they will call
>>>>> the right virtskb_receive_*() function based on the negotiation.
>>>>
>>>> If it's one the issue of negotiation, we can simply change the
>>>> virtnet_probe() to deal with different devices.
>>>>
>>>>
>>>>> I already started to work on it, but before to do more steps and send an RFC
>>>>> patch, I would like to hear your opinion.
>>>>> Do you think that makes sense?
>>>>> Do you see any issue or a better solution?
>>>>
>>>> I still think we need to seek a way of adding some codes on virtio-net.c
>>>> directly if there's no huge different in the processing of TX/RX. That would
>>>> save us a lot time.
>>> After the reading of the buffers from the virtqueue I think the process
>>> is slightly different, because virtio-net will interface with the network
>>> stack, while virtio-vsock will interface with the vsock-core (socket).
>>> So the virtio-vsock implements the following:
>>> - control flow mechanism to avoid to loose packets, informing the peer
>>>    about the amount of memory available in the receive queue using some
>>>    fields in the virtio_vsock_hdr
>>> - de-multiplexing parsing the virtio_vsock_hdr and choosing the right
>>>    socket depending on the port
>>> - socket state handling


I think it's just a branch, for ethernet, go for networking stack. 
otherwise go for vsock core?


>>>
>>> We can use the virtio-net as transport, but we should add a lot of
>>> code to skip "net device" stuff when it is used by the virtio-vsock.


This could be another choice, but consider it was not transparent to the 
admin and require new features, we may seek a transparent solution here.


>>> This could break something in virtio-net, for this reason, I thought to reuse
>>> only the send/recv functions starting from the idea to split the virtio-net
>>> driver in two parts:
>>> a. one with all stuff related to the network stack
>>> b. one with the stuff needed to communicate with the host
>>>
>>> And use skbuff to communicate between parts. In this way, virtio-vsock
>>> can use only the b part.
>>>
>>> Maybe we can do this split in a better way, but I'm not sure it is
>>> simple.
>>>
>>> Thanks,
>>> Stefano
>> Frankly, skb is a huge structure which adds a lot of
>> overhead. I am not sure that using it is such a great idea
>> if building a device that does not have to interface
>> with the networking stack.


I believe vsock is mainly used for stream performance not for PPS. So 
the impact should be minimal. We can use other metadata, just need 
branch in recv_xxx().


> Thanks for the advice!
>
>> So I agree with Jason in theory. To clarify, he is basically saying
>> current implementation is all wrong, it should be a protocol and we
>> should teach networking stack that there are reliable net devices that
>> handle just this protocol. We could add a flag in virtio net that
>> will say it's such a device.
>>
>> Whether it's doable, I don't know, and it's definitely not simple - in
>> particular you will have to also re-implement existing devices in these
>> terms, and not just virtio - vmware vsock too.


Merging vsock protocol to exist networking stack could be a long term 
goal, I believe for the first phase, we can seek to use virtio-net first.


>>
>> If you want to do a POC you can add a new address family,
>> that's easier.
> Very interesting!
> I agree with you. In this way we can completely split the protocol
> logic, from the device.
>
> As you said, it will not simple to do, but can be an opportunity to learn
> better the Linux networking stack!
> I'll try to do a PoC with AF_VSOCK2 that will use the virtio-net.


I suggest to do this step by step:

1) use virtio-net but keep some protocol logic

2) separate protocol logic and merge it to exist Linux networking stack

Thanks


>> Just reusing random functions won't help, net stack
>> is very heavy, if it manages to outperform vsock it's
>> because vsock was not written with performance in mind.
>> But the smarts are in the core not virtio driver.
>> What makes vsock slow is design decisions like
>> using a workqueue to process packets,
>> not batching memory management etc etc.
>> All things that net core does for virtio net.
> Got it :)
>
> Michael, Jason, thank you very much! Your suggestions are very useful!
>
> Stefano
