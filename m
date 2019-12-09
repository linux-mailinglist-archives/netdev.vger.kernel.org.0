Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1D6116A80
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 11:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfLIKFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 05:05:39 -0500
Received: from ivanoab7.miniserver.com ([37.128.132.42]:47978 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfLIKFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 05:05:39 -0500
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1ieFv7-0006RE-9h; Mon, 09 Dec 2019 10:05:37 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1ieFv4-0003Zy-Uj; Mon, 09 Dec 2019 10:05:37 +0000
Subject: Re: Invalid GSO - from 4.x (TBA) to 5.5-rc1. Was: Re: 64 bit time
 regression in recvmmsg()
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>
References: <3820d68b-1d97-8f41-d55d-237d1695458c@cambridgegreys.com>
 <CAMuHMdWuiGC4ay=f6M2H=-PLiffavnFSu8CPXE26euAi6aoY0w@mail.gmail.com>
 <CAK8P3a1mrFgRyh5Fgv-d8Szd2pq0T6Ac7wL3ogeYcf-Uyrg4ZQ@mail.gmail.com>
 <a5b9709d-b93b-46e1-ab18-a94ab921ccf7@cambridgegreys.com>
 <9dc1be66-5c55-8b3d-875b-4e1206914e78@cambridgegreys.com>
 <CAK8P3a1KcRcpUB2PdA17tnHN_dDs2Y02zPtkgM22Z-JdugAkfQ@mail.gmail.com>
 <e96aebcc-907a-d86f-ea8f-f5b10f74f39b@cambridgegreys.com>
Message-ID: <5a4dc591-5fd9-063a-13e2-2dbcfe83b22b@cambridgegreys.com>
Date:   Mon, 9 Dec 2019 10:05:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <e96aebcc-907a-d86f-ea8f-f5b10f74f39b@cambridgegreys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/12/2019 09:19, Anton Ivanov wrote:
> 
> 
> On 06/12/2019 20:06, Arnd Bergmann wrote:
>> On Fri, Dec 6, 2019 at 6:50 PM Anton Ivanov
>> <anton.ivanov@cambridgegreys.com> wrote:
>>> On 29/11/2019 16:34, Anton Ivanov wrote:
>>>
>>> I apologize, problem elsewhere. I have narrowed it down, it is a host
>>> regression at the end, not a recvmmsg/time one.
>>>
>>> The EINVAL is occasionally returned from the guts of packet_rcv_vnet
>>>
>>> https://elixir.bootlin.com/linux/latest/ident/packet_rcv_vnet
>>>
>>> in af_packet. I am going to try to figure out exactly when it happens
>>> and why.
>>>
>>> My sincere apologies,
>>
>> No, worries, I'm glad it wasn't me this time ;-)
> 
> At some point in late 4.x (I am going to try narrowing down the 
> version), gso code introduced a condition which should not occur:
> 
> We have
> 
> sinfo(skb)->gso_type = 0
> 
> while
> 
> sinfo(skb)->gso_size = 752.
> skb->len = 818
> skb->data_len = 0
> 
> As a result we get a skb which is GSO, but it has a no GSO type.
> 
> This shows up in virtio_net_hdr_from_skb() which detects the condition 
> as invalid and returns an -EINVAL
> 
> A few interesting things.
> 
> 1. Size is always 752.
> 
> 2. I have found it while tracing an -EINVAL when using recvmmsg() on raw 
> sockets. No idea if it shows up elsewhere.
> 
> 3. The environment under test is reading/writing to a raw socket opened 
> on a vEth pair configured as follows:
> 
> 
> ip link add l-veth0 type veth peer name p-veth0 && ifconfig p-veth0 up
> ifconfig l-veth0 192.168.97.1 netmask 255.255.255.252
> 
> the UML linux instance used as a reader/writer relies on 
> recvmmsg/sendmmesg raw socket with vnet headers enabled.
> 
> virtio_net_hdr_from_skb() is called from the af_packet packet_recv_vnet 
> function.
> 
> This condition simply should not occur. A skb with no data in the frags, 
> gso on, gso size less than MTU and no type looks bogus.

While the gso marking on the frame is bogus, the frame itself actually 
looks good (as seen from the UML used as a reader).

I get ~ 10% throughput increase because recvmmsg does not get broken all 
the time into smaller vector sizes and no frames reported as dropped due 
to checksum or other issues.

I will send a patch with a proposed fix shortly.

We should still find who is producing these frames though.

> 
> 
>>
>>       Arnd
>>
>> _______________________________________________
>> linux-um mailing list
>> linux-um@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-um
>>
> 

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/
