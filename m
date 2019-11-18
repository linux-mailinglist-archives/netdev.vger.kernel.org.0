Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8365C100D4A
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 21:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfKRUtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 15:49:39 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:15666 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfKRUtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 15:49:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1574110177;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=r/rBuQ55oLDSkHY0eP214V9Mlwgvx9I0t5GHGWN+1pY=;
        b=r8lPzX2f0wprGR/JauHOU/N3GHwjFlgHzbioKwSVcmz5SS6ZQc03l/LnYAQqPlUUT4
        u3PTRtqGA6w7hT2iI24RO1KZNR7jeCneojGjKHcFZtzi/rVXiilhutzrOX3Sbe/T9MQ6
        mUdmyPGEKQMqLm9kPXb7OsM4HatRTlI/PUkE2958MQAK6zCukuOx9rRDWJMhmiou0OsX
        0scd5BhLG1hjV5j+BBDOMeBy0ZtGHNtJMCCe0ca39zyvAOC8jbm3lCZ59mDXiUgQ99Yg
        Rg3MDdOQSfSaf0to7UxYrrDlXgps1PEzmJO+68y/Jzqc2Opcs3AUr9UTZkSNBvBtwvfT
        lcAA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJV8h+lCA="
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id C03a03vAIKnV19G
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 18 Nov 2019 21:49:31 +0100 (CET)
Subject: Re: KMSAN: uninit-value in can_receive
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        syzbot <syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com>,
        davem@davemloft.net, glider@google.com, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000005c08d10597a3a05d@google.com>
 <a5f73d92-fdf2-2590-c863-39a181dca8e1@hartkopp.net>
 <deedd609-6f3b-8035-47e1-252ab221faa1@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <7934bc2b-597f-0bb3-be2d-32f3b07b4de9@hartkopp.net>
Date:   Mon, 18 Nov 2019 21:49:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <deedd609-6f3b-8035-47e1-252ab221faa1@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/11/2019 21.29, Marc Kleine-Budde wrote:
> On 11/18/19 9:25 PM, Oliver Hartkopp wrote:

>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>> Reported-by: syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com
>>>
>>> =====================================================
>>> BUG: KMSAN: uninit-value in can_receive+0x23c/0x5e0 net/can/af_can.c:649
>>> CPU: 1 PID: 3490 Comm: syz-executor.2 Not tainted 5.4.0-rc5+ #0

>>
>> In line 649 of 5.4.0-rc5+ we can find a while() statement:
>>
>> while (!(can_skb_prv(skb)->skbcnt))
>> 	can_skb_prv(skb)->skbcnt = atomic_inc_return(&skbcounter);
>>
>> In linux/include/linux/can/skb.h we see:
>>
>> static inline struct can_skb_priv *can_skb_prv(struct sk_buff *skb)
>> {
>> 	return (struct can_skb_priv *)(skb->head);
>> }
>>
>> IMO accessing can_skb_prv(skb)->skbcnt at this point is a valid
>> operation which has no uninitialized value.
>>
>> Can this probably be a false positive of KMSAN?
> 
> The packet is injected via the packet socket into the kernel. Where does
> skb->head point to in this case? When the skb is a proper
> kernel-generated skb containing a CAN-2.0 or CAN-FD frame skb->head is
> maybe properly initialized?

The packet is either received via vcan or vxcan which checks via 
can_dropped_invalid_skb() if we have a valid ETH_P_CAN type skb.

We additionally might think about introducing a check whether we have a 
can_skb_reserve() created skbuff.

But even if someone forged a skbuff without this reserved space the 
access to can_skb_prv(skb)->skbcnt would point into some CAN frame 
content - which is still no access to uninitialized content, right?

Regards,
Oliver
