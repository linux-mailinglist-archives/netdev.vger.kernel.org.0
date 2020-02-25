Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D360116B85C
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 05:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgBYEDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 23:03:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42292 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727402AbgBYEDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 23:03:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582603385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7TOYYvzJQOOZ9LfcpJBYM56+MM7z1Z4OzHQN2nrm9SM=;
        b=SV+6l6qgb8IpLP/yL2kA84qinPVzy2al2/AkXbmAABXLPuMblkPGMhkuoU3EPibRTrQi7p
        WXi/43BgpXh2BfCoDLRFRiaS0YtZ3EJuMzNPE8cfxzUs3I/qhYovvXENrq4dnbP+Al5vmQ
        W6szAS5sceTrYlDZm8zmYE2zyw1tTvM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-4UZrMMeUPcqkJ4_f8hQ_nw-1; Mon, 24 Feb 2020 23:03:01 -0500
X-MC-Unique: 4UZrMMeUPcqkJ4_f8hQ_nw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84A788017CC;
        Tue, 25 Feb 2020 04:02:59 +0000 (UTC)
Received: from [10.72.13.170] (ovpn-13-170.pek2.redhat.com [10.72.13.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C62A90519;
        Tue, 25 Feb 2020 04:02:53 +0000 (UTC)
Subject: Re: [PATCH v3] virtio: Work around frames incorrectly marked as gso
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-um@lists.infradead.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20200224132550.2083-1-anton.ivanov@cambridgegreys.com>
 <CA+FuTSd8P6uQnwisZEh7+nfowW9qKLBEvA4GPg+xUkjBa-6TDA@mail.gmail.com>
 <4e7757cf-148e-4585-b358-3b38f391275d@cambridgegreys.com>
 <CA+FuTSdOCJZCVS4xohx+BQmkmq8JALnK=gGc0=qy1TbjY707ag@mail.gmail.com>
 <93cb2b3f-6cae-8cf1-5fab-93fa34c14628@cambridgegreys.com>
 <CA+FuTScEXRwYtFzn-jtFhV0dNKNQqKPBwCWaNORJW=ERU=izMA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1af28666-1d27-8c9e-7225-2796a9f7336e@redhat.com>
Date:   Tue, 25 Feb 2020 12:02:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTScEXRwYtFzn-jtFhV0dNKNQqKPBwCWaNORJW=ERU=izMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/25 =E4=B8=8A=E5=8D=886:22, Willem de Bruijn wrote:
> On Mon, Feb 24, 2020 at 4:00 PM Anton Ivanov
> <anton.ivanov@cambridgegreys.com> wrote:
>> On 24/02/2020 20:20, Willem de Bruijn wrote:
>>> On Mon, Feb 24, 2020 at 2:55 PM Anton Ivanov
>>> <anton.ivanov@cambridgegreys.com> wrote:
>>>> On 24/02/2020 19:27, Willem de Bruijn wrote:
>>>>> On Mon, Feb 24, 2020 at 8:26 AM <anton.ivanov@cambridgegreys.com> w=
rote:
>>>>>> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>>>>>
>>>>>> Some of the locally generated frames marked as GSO which
>>>>>> arrive at virtio_net_hdr_from_skb() have no GSO_TYPE, no
>>>>>> fragments (data_len =3D 0) and length significantly shorter
>>>>>> than the MTU (752 in my experiments).
>>>>> Do we understand how these packets are generated?
>>>> No, we have not been able to trace them.
>>>>
>>>> The only thing we know is that this is specific to locally generated
>>>> packets. Something arriving from the network does not show this.
>>>>
>>>>> Else it seems this
>>>>> might be papering over a deeper problem.
>>>>>
>>>>> The stack should not create GSO packets less than or equal to
>>>>> skb_shinfo(skb)->gso_size. See for instance the check in
>>>>> tcp_gso_segment after pulling the tcp header:
>>>>>
>>>>>            mss =3D skb_shinfo(skb)->gso_size;
>>>>>            if (unlikely(skb->len <=3D mss))
>>>>>                    goto out;
>>>>>
>>>>> What is the gso_type, and does it include SKB_GSO_DODGY?
>>>>>
>>>> 0 - not set.
>>> Thanks for the follow-up details. Is this something that you can trig=
ger easily?
>> Yes, if you have a UML instance handy.
>>
>> Running iperf between the host and a UML guest using raw socket
>> transport triggers it immediately.
>>
>> This is my UML command line:
>>
>> vmlinux mem=3D2048M umid=3DOPX \
>>       ubd0=3DOPX-3.0-Work.img \
>> vec0:transport=3Draw,ifname=3Dp-veth0,depth=3D128,gro=3D1,mac=3D92:9b:=
36:5e:38:69 \
>>       root=3D/dev/ubda ro con=3Dnull con0=3Dnull,fd:2 con1=3Dfd:0,fd:1
>>
>> p-right is a part of a vEth pair:
>>
>> ip link add l-veth0 type veth peer name p-veth0 && ifconfig p-veth0 up
>>
>> iperf server is on host, iperf -c in the guest.
>>
>>> An skb_dump() + dump_stack() when the packet socket gets such a
>>> packet may point us to the root cause and fix that.
>> We tried dump stack, it was not informative - it was just the recvmmsg
>> call stack coming from the UML until it hits the relevant recv bit in
>> af_packet - it does not tell us where the packet is coming from.
>>
>> Quoting from the message earlier in the thread:
>>
>> [ 2334.180854] Call Trace:
>> [ 2334.181947]  dump_stack+0x5c/0x80
>> [ 2334.183021]  packet_recvmsg.cold+0x23/0x49
>> [ 2334.184063]  ___sys_recvmsg+0xe1/0x1f0
>> [ 2334.185034]  ? packet_poll+0xca/0x130
>> [ 2334.186014]  ? sock_poll+0x77/0xb0
>> [ 2334.186977]  ? ep_item_poll.isra.0+0x3f/0xb0
>> [ 2334.187936]  ? ep_send_events_proc+0xf1/0x240
>> [ 2334.188901]  ? dequeue_signal+0xdb/0x180
>> [ 2334.189848]  do_recvmmsg+0xc8/0x2d0
>> [ 2334.190728]  ? ep_poll+0x8c/0x470
>> [ 2334.191581]  __sys_recvmmsg+0x108/0x150
>> [ 2334.192441]  __x64_sys_recvmmsg+0x25/0x30
>> [ 2334.193346]  do_syscall_64+0x53/0x140
>> [ 2334.194262]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> That makes sense. skb_dump might show more interesting details about
> the packet. From the previous thread, these are assumed to be TCP
> packets?
>
> I had missed the original thread. If the packet has
>
>      sinfo(skb)->gso_size =3D 752.
>      skb->len =3D 818
>
> then this is a GSO packet. Even though UML will correctly process it
> as a normal 818 B packet if psock_rcv pretends that it is, treating it
> like that is not strictly correct. A related question is how the setup
> arrived at that low MTU size, assuming that is not explicitly
> configured that low.
>
> As of commit 51466a7545b7 ("tcp: fill shinfo->gso_type at last
> moment") tcp unconditionally sets gso_type, even for non gso packets.
> So either this is not a tcp packet or the field gets zeroed somewhere
> along the way. I could not quickly find a possible path to
> skb_gso_reset or a raw write.
>
> It may be useful to insert tests for this condition (skb_is_gso(skb)
> && !skb_shinfo(skb)->gso_type) that call skb_dump at other points in
> the network stack. For instance in __ip_queue_xmit and
> __dev_queue_xmit.


+1

We meet some customer hit such condition as well which lead over MTU=20
packet to be queued by TAP which crashes their buggy userspace applicatio=
n.

We suspect it's the issue of wrong gso_type vs gso_size.

Thanks


>
> Since skb segmentation fails in tcp_gso_segment for such packets, it
> may also be informative to disable TSO on the veth device and see if
> the test fails.
>

