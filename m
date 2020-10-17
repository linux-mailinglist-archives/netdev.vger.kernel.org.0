Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A538D291413
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 21:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439396AbgJQTNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 15:13:36 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:17618 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439270AbgJQTNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 15:13:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1602962009;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=sd+e3dzH/JFSegGEuFh9FBQvap5wv1lOACinUFMQpSw=;
        b=NSx0RLhIsi2xU7NUajGucA6O4++IlB+fiYX4bf5v5fgT0LH8ova3cNGOXp0B2WMMxu
        ycnIg2tiV34g0V67jRoU7h42h4zDR84554A4++DDjF8pZR/+oKpEmiFmiUjzJl19RNHC
        xUIBQqwnH5Z9wGXUySj7Q1elH1wBI9D+fuRaAB5OwRVByzGmGkVOvQHK4hKrTbi3pBwt
        wEBMFAyuN7K6Cp/b3TtwVAYEj1u4h/hvVvMEHwzKp7777qkb7dKmaa8/iiScF7uWmNWu
        TuFj4bmoxbj5H2B6G7mbyrD7TSo0VN787dTST5JOzz4Fc+vQUVSx+NpkH6/oVwHFA7HL
        GoWg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR9J85ipw=="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.177]
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id D0b41cw9HJDJfbq
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 17 Oct 2020 21:13:19 +0200 (CEST)
Subject: Re: [RFC] can: can_create_echo_skb(): fix echo skb generation: always
 use skb_clone()
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        dev.kurt@vandijck-laurijssen.be, wg@grandegger.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
References: <20200124132656.22156-1-o.rempel@pengutronix.de>
 <20200214120948.4sjnqn2jvndldphw@pengutronix.de>
 <f2ae9b3a-0d10-64ae-1533-2308e9346ebc@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <f06cd4bc-6264-242f-fd74-ac8e3f2c10b2@hartkopp.net>
Date:   Sat, 17 Oct 2020 21:13:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <f2ae9b3a-0d10-64ae-1533-2308e9346ebc@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16.10.20 21:36, Marc Kleine-Budde wrote:
> On 2/14/20 1:09 PM, Oleksij Rempel wrote:
>> Hi all,
>>
>> any comments on this patch?
> 
> I'm going to take this patch now for 5.10....Comments?

Yes.

Removing the sk reference will lead to the effect, that you will receive 
the CAN frames you have sent on that socket - which is disabled by default:

https://elixir.bootlin.com/linux/latest/source/net/can/raw.c#L124

See concept here:

https://elixir.bootlin.com/linux/latest/source/Documentation/networking/can.rst#L560

How can we maintain the CAN_RAW_RECV_OWN_MSGS to be disabled by default 
and fix the described problem?

Regards,
Oliver

> 
> Marc
> 
>>
>> On Fri, Jan 24, 2020 at 02:26:56PM +0100, Oleksij Rempel wrote:
>>> All user space generated SKBs are owned by a socket (unless injected
>>> into the key via AF_PACKET). If a socket is closed, all associated skbs
>>> will be cleaned up.
>>>
>>> This leads to a problem when a CAN driver calls can_put_echo_skb() on a
>>> unshared SKB. If the socket is closed prior to the TX complete handler,
>>> can_get_echo_skb() and the subsequent delivering of the echo SKB to
>>> all registered callbacks, a SKB with a refcount of 0 is delivered.
>>>
>>> To avoid the problem, in can_get_echo_skb() the original SKB is now
>>> always cloned, regardless of shared SKB or not. If the process exists it
>>> can now safely discard its SKBs, without disturbing the delivery of the
>>> echo SKB.
>>>
>>> The problem shows up in the j1939 stack, when it clones the
>>> incoming skb, which detects the already 0 refcount.
>>>
>>> We can easily reproduce this with following example:
>>>
>>> testj1939 -B -r can0: &
>>> cansend can0 1823ff40#0123
>>>
>>> WARNING: CPU: 0 PID: 293 at lib/refcount.c:25 refcount_warn_saturate+0x108/0x174
>>> refcount_t: addition on 0; use-after-free.
>>> Modules linked in: coda_vpu imx_vdoa videobuf2_vmalloc dw_hdmi_ahb_audio vcan
>>> CPU: 0 PID: 293 Comm: cansend Not tainted 5.5.0-rc6-00376-g9e20dcb7040d #1
>>> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
>>> Backtrace:
>>> [<c010f570>] (dump_backtrace) from [<c010f90c>] (show_stack+0x20/0x24)
>>> [<c010f8ec>] (show_stack) from [<c0c3e1a4>] (dump_stack+0x8c/0xa0)
>>> [<c0c3e118>] (dump_stack) from [<c0127fec>] (__warn+0xe0/0x108)
>>> [<c0127f0c>] (__warn) from [<c01283c8>] (warn_slowpath_fmt+0xa8/0xcc)
>>> [<c0128324>] (warn_slowpath_fmt) from [<c0539c0c>] (refcount_warn_saturate+0x108/0x174)
>>> [<c0539b04>] (refcount_warn_saturate) from [<c0ad2cac>] (j1939_can_recv+0x20c/0x210)
>>> [<c0ad2aa0>] (j1939_can_recv) from [<c0ac9dc8>] (can_rcv_filter+0xb4/0x268)
>>> [<c0ac9d14>] (can_rcv_filter) from [<c0aca2cc>] (can_receive+0xb0/0xe4)
>>> [<c0aca21c>] (can_receive) from [<c0aca348>] (can_rcv+0x48/0x98)
>>> [<c0aca300>] (can_rcv) from [<c09b1fdc>] (__netif_receive_skb_one_core+0x64/0x88)
>>> [<c09b1f78>] (__netif_receive_skb_one_core) from [<c09b2070>] (__netif_receive_skb+0x38/0x94)
>>> [<c09b2038>] (__netif_receive_skb) from [<c09b2130>] (netif_receive_skb_internal+0x64/0xf8)
>>> [<c09b20cc>] (netif_receive_skb_internal) from [<c09b21f8>] (netif_receive_skb+0x34/0x19c)
>>> [<c09b21c4>] (netif_receive_skb) from [<c0791278>] (can_rx_offload_napi_poll+0x58/0xb4)
>>>
>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>> ---
>>>   include/linux/can/skb.h | 20 ++++++++------------
>>>   1 file changed, 8 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
>>> index a954def26c0d..0783b0c6d9e2 100644
>>> --- a/include/linux/can/skb.h
>>> +++ b/include/linux/can/skb.h
>>> @@ -61,21 +61,17 @@ static inline void can_skb_set_owner(struct sk_buff *skb, struct sock *sk)
>>>    */
>>>   static inline struct sk_buff *can_create_echo_skb(struct sk_buff *skb)
>>>   {
>>> -	if (skb_shared(skb)) {
>>> -		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>>> +	struct sk_buff *nskb;
>>>   
>>> -		if (likely(nskb)) {
>>> -			can_skb_set_owner(nskb, skb->sk);
>>> -			consume_skb(skb);
>>> -			return nskb;
>>> -		} else {
>>> -			kfree_skb(skb);
>>> -			return NULL;
>>> -		}
>>> +	nskb = skb_clone(skb, GFP_ATOMIC);
>>> +	if (unlikely(!nskb)) {
>>> +		kfree_skb(skb);
>>> +		return NULL;
>>>   	}
>>>   
>>> -	/* we can assume to have an unshared skb with proper owner */
>>> -	return skb;
>>> +	can_skb_set_owner(nskb, skb->sk);
>>> +	consume_skb(skb);
>>> +	return nskb;
>>>   }
>>>   
>>>   #endif /* !_CAN_SKB_H */
>>> -- 
>>> 2.25.0
>>>
>>>
>>>
>>
> 
> 
