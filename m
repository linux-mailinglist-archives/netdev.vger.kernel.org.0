Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FF93B8CCE
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 06:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhGAEPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 00:15:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhGAEPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 00:15:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625112794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mV3/uiyYkjyqMTiVkCY7O4Qq8tUdDulKvyEdoV9r9jE=;
        b=bV+6w4RiGh4iKWFGtLHLuYdxtK3UGl1uhytmmajQs0RCxE0dWp4QFh7g8v1dcqeUqJ/3Sm
        IXKqfCEQfYDUHgnQ6M1o/j0yyIU/7hdN9t6/QekInQFjnVb0n3YvVgku8dcldFdpNG9C9R
        Wu5L7aoVs7lLt3pMSHmnQKXrui14Opc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-1VAIPnIFNCq4T-gRvYImbw-1; Thu, 01 Jul 2021 00:13:13 -0400
X-MC-Unique: 1VAIPnIFNCq4T-gRvYImbw-1
Received: by mail-pj1-f70.google.com with SMTP id x1-20020a17090ab001b02901726198443cso93230pjq.8
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 21:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mV3/uiyYkjyqMTiVkCY7O4Qq8tUdDulKvyEdoV9r9jE=;
        b=JUY5Hwtc4daiTzOmH9XybnhgI5/lLjLQFkM5LlcDeLFYxPc6ZnOI+BnWvzQ7/4GOzK
         7ny1JSdhPb+Ng06/t45GGDNaiaPM+tIQgxKCDi91rEQevSX3cFRDUihJsntjsSToeLvA
         WqFKotog98az0/2aXjt/XQ6dOtR7OXqB+BinpIvRArJNE2JQtn3a3UyW+Esd1vTBST5/
         tDpTkyDGJAuEpouGoHFOtpK1n3/X4z8CUZQevzKAhfnP/geQwyb63c3WJxwTzGom4Wum
         U0Ffcc7t3HUYt2HvzF0zUfjcI1o05EGLScO5k2OlvvVLHOVrvHRzob3dsdD7prtSOSQE
         M3PA==
X-Gm-Message-State: AOAM530Mo+Urqw24UQ47Ubnze8OQWup2Q3Xvw50JiUricAcPZJ/yvxgM
        kBY3TejDVZpLK4g0xBwycOFm+VrSFas2G1uVbt4Bphyl48T2jz0ywylA9l4BIKtT6D/vsO4lUQV
        9wuGoy1bU7iEU3S8R
X-Received: by 2002:a17:903:230d:b029:127:9144:db9e with SMTP id d13-20020a170903230db02901279144db9emr35161858plh.3.1625112792477;
        Wed, 30 Jun 2021 21:13:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwn7a5m+23oQOrdV3siwD9cYzDBrmUb7bdmu20f/r18YvOlWi4aGh9sOAOrmC9YA4RQsvWYMw==
X-Received: by 2002:a17:903:230d:b029:127:9144:db9e with SMTP id d13-20020a170903230db02901279144db9emr35161845plh.3.1625112792183;
        Wed, 30 Jun 2021 21:13:12 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ga1sm8967076pjb.43.2021.06.30.21.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 21:13:11 -0700 (PDT)
Subject: Re: [PATCH v3 3/5] vhost_net: remove virtio_net_hdr validation, let
 tun/tap do it themselves
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
 <20210624123005.1301761-3-dwmw2@infradead.org>
 <b339549d-c8f1-1e56-2759-f7b15ee8eca1@redhat.com>
 <bfad641875aff8ff008dd7f9a072c5aa980703f4.camel@infradead.org>
 <1c6110d9-2a45-f766-9d9a-e2996c14b748@redhat.com>
 <72dfecd426d183615c0dd4c2e68690b0e95dd739.camel@infradead.org>
 <80f61c54a2b39cb129e8606f843f7ace605d67e0.camel@infradead.org>
 <99496947-8171-d252-66d3-0af12c62fd2c@redhat.com>
 <cdf3fe3ceff17bc2a5aaf006577c1cb0bef40f3a.camel@infradead.org>
 <500370cc-d030-6c2d-8e96-533a3533a8e2@redhat.com>
 <aa70346d6983a0146b2220e93dac001706723fe3.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b6192a2a-0226-2767-46b2-ae61494a8ae7@redhat.com>
Date:   Thu, 1 Jul 2021 12:13:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <aa70346d6983a0146b2220e93dac001706723fe3.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/30 下午6:02, David Woodhouse 写道:
> On Wed, 2021-06-30 at 12:39 +0800, Jason Wang wrote:
>> 在 2021/6/29 下午6:49, David Woodhouse 写道:
>>> On Tue, 2021-06-29 at 11:43 +0800, Jason Wang wrote:
>>>>> The kernel on a c5.metal can transmit (AES128-SHA1) ESP at about
>>>>> 1.2Gb/s from iperf, as it seems to be doing it all from the iperf
>>>>> thread.
>>>>>
>>>>> Before I started messing with OpenConnect, it could transmit 1.6Gb/s.
>>>>>
>>>>> When I pull in the 'stitched' AES+SHA code from OpenSSL instead of
>>>>> doing the encryption and the HMAC in separate passes, I get to 2.1Gb/s.
>>>>>
>>>>> Adding vhost support on top of that takes me to 2.46Gb/s, which is a
>>>>> decent enough win.
>>>> Interesting, I think the latency should be improved as well in this
>>>> case.
>>> I tried using 'ping -i 0.1' to get an idea of latency for the
>>> interesting VoIP-like case of packets where we have to wake up each
>>> time.
>>>
>>> For the *inbound* case, RX on the tun device followed by TX of the
>>> replies, I see results like this:
>>>
>>>        --- 172.16.0.2 ping statistics ---
>>>        141 packets transmitted, 141 received, 0% packet loss, time 14557ms
>>>        rtt min/avg/max/mdev = 0.380/0.419/0.461/0.024 ms
>>>
>>>
>>> The opposite direction (tun TX then RX) is similar:
>>>
>>>        --- 172.16.0.1 ping statistics ---
>>>        295 packets transmitted, 295 received, 0% packet loss, time 30573ms
>>>        rtt min/avg/max/mdev = 0.454/0.545/0.718/0.024 ms
>>>
>>>
>>> Using vhost-net (and TUNSNDBUF of INT_MAX-1 just to avoid XDP), it
>>> looks like this. Inbound:
>>>
>>>        --- 172.16.0.2 ping statistics ---
>>>        139 packets transmitted, 139 received, 0% packet loss, time 14350ms
>>>        rtt min/avg/max/mdev = 0.432/0.578/0.658/0.058 ms
>>>
>>> Outbound:
>>>
>>>        --- 172.16.0.1 ping statistics ---
>>>        149 packets transmitted, 149 received, 0% packet loss, time 15391ms
>>>        rtt mn/avg/max/mdev = 0.496/0.682/0.935/0.036 ms
>>>
>>>
>>> So as I expected, the throughput is better with vhost-net once I get to
>>> the point of 100% CPU usage in my main thread, because it offloads the
>>> kernel←→user copies. But latency is somewhat worse.
>>>
>>> I'm still using select() instead of epoll() which would give me a
>>> little back — but only a little, as I only poll on 3-4 fds, and more to
>>> the point it'll give me just as much win in the non-vhost case too, so
>>> it won't make much difference to the vhost vs. non-vhost comparison.
>>>
>>> Perhaps I really should look into that trick of "if the vhost TX ring
>>> is already stopped and would need a kick, and I only have a few packets
>>> in the batch, just write them directly to /dev/net/tun".
>>
>> That should work on low throughput.
> Indeed it works remarkably well, as I noted in my follow-up. I also
> fixed a minor stupidity where I was reading from the 'call' eventfd
> *before* doing the real work of moving packets around. And that gives
> me a few tens of microseconds back too.
>
>>> I'm wondering how that optimisation would translate to actual guests,
>>> which presumably have the same problem. Perhaps it would be an
>>> operation on the vhost fd, which ends up processing the ring right
>>> there in the context of *that* process instead of doing a wakeup?
>>
>> It might improve the latency in an ideal case but several possible issues:
>>
>> 1) this will blocks vCPU running until the sent is done
>> 2) copy_from_user() may sleep which will block the vcpu thread further
> Yes, it would block the vCPU for a short period of time, but we could
> limit that. The real win is to improve latency of single, short packets
> like a first SYN, or SYNACK. It should work fine even if it's limited
> to *one* *short* packet which *is* resident in memory.


This looks tricky since we need to poke both virtqueue metadata as well 
as the payload.

And we need to let the packet iterate the network stack which might have 
extra latency (qdiscs, eBPF, switch/OVS).

So it looks to me it's better to use vhost_net busy polling instead 
(VHOST_SET_VRING_BUSYLOOP_TIMEOUT).

Userspace can detect this feature by validating the existence of the ioctl.


>
> Although actually I'm not *overly* worried about the 'resident' part.
> For a transmit packet, especially a short one not a sendpage(), it's
> fairly likely the the guest has touched the buffer right before sending
> it. And taken the hit of faulting it in then, if necessary. If the host
> is paging out memory which is *active* use by a guest, that guest is
> screwed anyway :)


Right, but there could be workload that is unrelated to the networking. 
Block vCPU thread in this case seems sub-optimal.


>
> I'm thinking of something like an ioctl on the vhost-net fd which *if*
> the thread is currently sleeping and there's a single short packet,
> processes it immediately. {Else,then} it wakes the thread just like the
> eventfd would have done. (Perhaps just by signalling the kick eventfd,
> but perhaps there's a more efficient way anyway).
>
>>> My bandwidth tests go up from 2.46Gb/s with the workarounds, to
>>> 2.50Gb/s once I enable XDP, and 2.52Gb/s when I drop the virtio-net
>>> header. But there's no way for userspace to *detect* that those bugs
>>> are fixed, which makes it hard to ship that version.
> I'm up to 2.75Gb/s now with epoll and other fixes (including using
> sendmmsg() on the other side). Since the kernel can only do *half*
> that, I'm now wondering if I really want my data plane in the kernel at
> all, which was my long-term plan :)


Good to know that.


>
>> Yes, that's sad. One possible way to advertise a VHOST_NET_TUN flag via
>> VHOST_GET_BACKEND_FEATURES?
> Strictly it isn't VHOST_NET_TUN, as that *does* work today if you pick
> the right (very non-intuitive) combination of features. The feature is
> really "VHOST_NET_TUN_WITHOUT_TUNSNDBUF_OR_UNWANTED_VNET_HEADER" :)


Yes, but it's a hint for userspace that TUN could be work without any 
workarounds.


>
> But we don't need a feature specifically for that; I only need to check
> for *any* feature that goes in after the fixes.
>
> Maybe if we do add a new low-latency kick then I could key on *that*
> feature to assume the bugs are fixed.
>
> Alternatively, there's still the memory map thing I need to fix before
> I can commit this in my application:
>
> #ifdef __x86_64__
> 	vmem->regions[0].guest_phys_addr = 4096;
> 	vmem->regions[0].memory_size = 0x7fffffffe000;
> 	vmem->regions[0].userspace_addr = 4096;
> #else
> #error FIXME
> #endif
> 	if (ioctl(vpninfo->vhost_fd, VHOST_SET_MEM_TABLE, vmem) < 0) {
>
> Perhaps if we end up with a user-visible feature to deal with that,
> then I could use the presence of *that* feature to infer that the tun
> bugs are fixed.


As we discussed before it could be a new backend feature. VHOST_NET_SVA 
(shared virtual address)?


>
> Another random thought as I stare at this... can't we handle checksums
> in tun_get_user() / tun_put_user()? We could always set NETIF_F_HW_CSUM
> on the tun device, and just do it *while* we're copying the packet to
> userspace, if userspace doesn't support it. That would be better than
> having the kernel complete the checksum in a separate pass *before*
> handing the skb to tun_net_xmit().


I'm not sure I get this, but for performance reason we don't do any csum 
in this case?


>
> We could similarly do a partial checksum in tun_get_user() and hand it
> off to the network stack with ->ip_summed == CHECKSUM_PARTIAL.


I think that's is how it is expected to work (via vnet header), see 
virtio_net_hdr_to_skb().

Thanks


>
>

