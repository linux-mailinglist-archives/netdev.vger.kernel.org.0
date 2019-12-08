Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81CFF116180
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 13:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfLHLfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 06:35:00 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:24171 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbfLHLe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 06:34:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1575804895;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=GF2AiRZsPODKiD7oiASvqijnWYTD/m8rVH+GoCUca+8=;
        b=Sw8bjcr/21RmK/U8zQD6WCkL0GdlADxz0BzJ/Nb3NaL5IZbCeg50dIz1AETVBz2UhB
        Yhs57Shgr/TtBSgOCJf5oEpYzKud9VbV7AyrZ9FbsVAErn0n7jRom86Xjlo/mzPhP7jY
        k0f+SzNRwXjBecTECiuNHPzMHkFIbVdbQZ2TzWLgFkR5dLbq9TiJwf29BnH4c+VaVTEx
        yUlrvjQG9SXxGwlxJqXx5wCMTHjlWgNQeLBfeqjDXNpiQQwDyW8mvc+pERsVsP6N4NSw
        rfVLSgGsWF67RuebtJaIvyf7WhtY6PAMjzfMSJFCH4OrI423k95YDa9SLo4xQoMjb1c7
        b8lw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1rnbMYliT5L36lTsrXQ=="
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 46.0.2 DYNA|AUTH)
        with ESMTPSA id 90101evB8BYlI0B
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 8 Dec 2019 12:34:47 +0100 (CET)
Subject: Re: [PATCH] can: ensure an initialized headroom in outgoing CAN
 sk_buffs
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        dvyukov@google.com
Cc:     syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com,
        glider@google.com, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, o.rempel@pengutronix.de,
        eric.dumazet@gmail.com
References: <20191207183418.28868-1-socketcan@hartkopp.net>
 <cc102c3b-d9d3-6447-7581-a36795259cc2@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <2b997c05-fcef-e067-2771-8e07e35dfadd@hartkopp.net>
Date:   Sun, 8 Dec 2019 12:34:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cc102c3b-d9d3-6447-7581-a36795259cc2@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08/12/2019 11.48, Marc Kleine-Budde wrote:
> On 12/7/19 7:34 PM, Oliver Hartkopp wrote:
>> KMSAN sysbot detected a read access to an untinitialized value in the headroom
>> of an outgoing CAN related sk_buff. When using CAN sockets this area is filled
>> appropriately - but when using a packet socket this initialization is missing.


>> +/* Check for outgoing skbs that have not been created by the CAN subsystem */
>> +static inline bool can_check_skb_headroom(struct net_device *dev,
>> +					  struct sk_buff *skb)
> 
> Do we want to have such a big function as a static inline?
> 

No. Usually not. can_dropped_invalid_skb() has the same problem IMO.

This additional inline function approach was the only way to ensure 
simple backwards portability for stable kernels.

I would suggest to clean this up once this patch went into mainline.

>> +{
>> +	/* af_packet creates a headroom of HH_DATA_MOD bytes which is fine */
>> +	if (WARN_ON_ONCE(skb_headroom(skb) < sizeof(struct can_skb_priv)))
>> +		return true;
>> +
>> +	/* af_packet does not apply CAN skb specific settings */
>> +	if (skb->ip_summed == CHECKSUM_NONE) {
> 
> Is it possible to set the ip_summed via the packet socket or is it
> always 0 (== CHECKSUM_NONE)?

af_packet only reads ip_summed in the receive path. It is not set when 
creating the outgoing skb where the struct skb is mainly zero'ed.

> 
>> +
> 
> Please remove that empty line.
> 

ok.

>> +		/* init headroom */
>> +		can_skb_prv(skb)->ifindex = dev->ifindex;
>> +		can_skb_prv(skb)->skbcnt = 0;
>> +
>> +		skb->ip_summed = CHECKSUM_UNNECESSARY;
>> +
>> +		/* preform proper loopback on capable devices */
>> +		if (dev->flags & IFF_ECHO)
>> +			skb->pkt_type = PACKET_LOOPBACK;
>> +		else
>> +			skb->pkt_type = PACKET_HOST;
>> +
>> +		skb_reset_mac_header(skb);
>> +		skb_reset_network_header(skb);
>> +		skb_reset_transport_header(skb);
>> +	}
>> +
>> +	return false;
>> +}
>> +
>>   /* Drop a given socketbuffer if it does not contain a valid CAN frame. */
>>   static inline bool can_dropped_invalid_skb(struct net_device *dev,
>>   					  struct sk_buff *skb)
>> @@ -108,6 +140,9 @@ static inline bool can_dropped_invalid_skb(struct net_device *dev,
>>   	} else
>>   		goto inval_skb;
>>   
>> +	if (can_check_skb_headroom(dev, skb))
> 
> Can you rename the function, so that it's clear that returning false
> means it's an invalid skb?
> 

Returning 'false' is *good* like in can_dropped_invalid_skb(). What 
naming would you suggest?

Regards,
Oliver
