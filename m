Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986F1102D9A
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 21:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfKSUbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 15:31:07 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:28244 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfKSUbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 15:31:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1574195464;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=WB13vBsyEr7/Hk93hoXjpA0FmbMZk0HVGJEgs02Tlxs=;
        b=BPIZmvdeBEFw5U85Je6pSvMKg/8XfUwgNs5o5D/2nvruakyzvxe+tJIkIEIev8SxvO
        hZSJjzU95XltVXS163ROrdvmIB6ar25FCg6tf9uHTqEEhb/ieWdkE4U2Aznp1gI8GQ4z
        FomjRpcl8utzL72VDu3EiTctJQKe9C1RfE7dpeG58avOqBIYUo79/WrFnttw73oNS6XI
        xGEAk44boVWhNNPFdgdnwq29p5QowXf4BTmBW9KhgF2lyhT5UF6I9VkuJHScYg23BZAn
        vyySRSTXnzAClWNC+VVkYseTeU3sFSip7EvL+joMlkORTkTO/M61aZpDjJ7jhp/GYw0w
        RGXA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVch5l0xf"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id C03a03vAJKOx5a0
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 19 Nov 2019 21:24:59 +0100 (CET)
Subject: Re: KMSAN: uninit-value in can_receive
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        syzbot <syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com>,
        davem@davemloft.net, glider@google.com, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000005c08d10597a3a05d@google.com>
 <a5f73d92-fdf2-2590-c863-39a181dca8e1@hartkopp.net>
 <deedd609-6f3b-8035-47e1-252ab221faa1@pengutronix.de>
 <7934bc2b-597f-0bb3-be2d-32f3b07b4de9@hartkopp.net>
 <7f5c4546-0c1a-86ae-581e-0203b5fca446@pengutronix.de>
 <1f7d6ea7-152e-ff18-549c-b196d8b5e3a7@hartkopp.net>
 <9e06266a-67f3-7352-7b87-2b9144c7c9a9@gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <3142c032-e46a-531c-d1b8-d532e5b403a6@hartkopp.net>
Date:   Tue, 19 Nov 2019 21:24:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <9e06266a-67f3-7352-7b87-2b9144c7c9a9@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 19/11/2019 17.53, Eric Dumazet wrote:
> 
> 
> On 11/18/19 11:35 PM, Oliver Hartkopp wrote:
>>
> 
>>
>> See ioctl$ifreq https://syzkaller.appspot.com/x/log.txt?x=14563416e00000
>>
>> 23:11:34 executing program 2:
>> r0 = socket(0x200000000000011, 0x3, 0x0)
>> ioctl$ifreq_SIOCGIFINDEX_vcan(r0, 0x8933, &(0x7f0000000040)={'vxcan1\x00', <r1=>0x0})
>> bind$packet(r0, &(0x7f0000000300)={0x11, 0xc, r1}, 0x14)
>> sendmmsg(r0, &(0x7f0000000d00), 0x400004e, 0x0)
>>
>> We only can receive skbs from (v(x))can devices.
>> No matter if someone wrote to them via PF_CAN or PF_PACKET.
>> We check for ETH_P_CAN(FD) type and ARPHRD_CAN dev type at rx time.
> 
> And what entity sets the can_skb_prv(skb)->skbcnt to zero exactly ?
> 
>>
>>>> We additionally might think about introducing a check whether we have a
>>>> can_skb_reserve() created skbuff.
>>>>
>>>> But even if someone forged a skbuff without this reserved space the
>>>> access to can_skb_prv(skb)->skbcnt would point into some CAN frame
>>>> content - which is still no access to uninitialized content, right?
>>
>> So this question remains still valid whether we have a false positive from KMSAN here.
> 
> I do not believe it is a false positive.
> 
> It seems CAN relies on some properties of low level drivers using alloc_can_skb() or similar function.
> 
> Why not simply fix this like that ?
> 
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index 128d37a4c2e0ba5d8db69fcceec8cbd6a79380df..3e71a78d82af84caaacd0ef512b5e894efbf4852 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -647,8 +647,9 @@ static void can_receive(struct sk_buff *skb, struct net_device *dev)
>          pkg_stats->rx_frames_delta++;
>   
>          /* create non-zero unique skb identifier together with *skb */
> -       while (!(can_skb_prv(skb)->skbcnt))
> +       do {
>                  can_skb_prv(skb)->skbcnt = atomic_inc_return(&skbcounter);
> +       } while (!(can_skb_prv(skb)->skbcnt));
>   
>          rcu_read_lock();
>   

Please check commit d3b58c47d330d ("can: replace timestamp as unique skb 
attribute").

can_skb_prv(skb)->skbcnt is set to 0 at skb creation time when sending 
CAN frames from local host or receiving CAN frames from a real CAN 
interface.

When a CAN skb is received by the net layer the *first* time it gets a 
unique value which we need for a per-cpu filter mechanism in raw_rcv().

So where's the problem to check for (!(can_skb_prv(skb)->skbcnt)) in a 
while statement? I can't see a chance for an uninitialized value there.

Regards,
Oliver
