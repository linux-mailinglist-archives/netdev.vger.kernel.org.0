Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5C32A6C20
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 18:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732107AbgKDRq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 12:46:58 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:15633 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730391AbgKDRq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 12:46:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1604512015;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=9PwnxAdiDEoKZFqmxj00eY5F/YtQiIx5b1HQwtg0zTU=;
        b=PhaQ0LjdogrTxoOzBKKFKkIOhdStxpQDpD1EFmF0AKEhgnZJpakgwqdzHin4Ju1dn8
        EhsRxJtf27J8CvedfqxNEG74JIC/SCMhv/yyoJ+r8sTT72NbPWnbJQBwTlHShVIosbc+
        LZ9FM2zt/JYqpja0z6M9JN3pyEgroJ75akVSGqeZyZphEOGy8Tx+mc90Isyf8/g/VIG7
        eKmvZZ/sPafHaMvTULKaDT1BkWab6Ri9zgd+t95i2c8LZk9kYAk4FY/8c3eiWVfqyNZJ
        ocmNM/No0ml9itR5Ro9dEyWXnyePIZ0cI16S7B7eVZIwK6i34GRzv0hJh8CAqewb3b1b
        m2Jw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3HMbEWKONeXSNI="
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.3.2 DYNA|AUTH)
        with ESMTPSA id j0816awA4Hki0F2
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 4 Nov 2020 18:46:44 +0100 (CET)
Subject: Re: [net 05/27] can: dev: can_get_echo_skb(): prevent call to
 kfree_skb() in hard IRQ context
To:     Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, linux-can@vger.kernel.org,
        kernel@pengutronix.de
References: <20201103220636.972106-1-mkl@pengutronix.de>
 <20201103220636.972106-6-mkl@pengutronix.de>
 <20201103172102.3d75cb96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iK5xqYmLT=DZk0S15pRObSJbo2-zrO7_A0Q46Ujg1RxYg@mail.gmail.com>
 <988aea6a-c6b6-5d58-3a8e-604a52df0320@hartkopp.net>
 <20201104080237.4d6605ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <550bf8d4-bf4c-b1ef-cd41-78c2b71514e3@hartkopp.net>
Date:   Wed, 4 Nov 2020 18:46:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201104080237.4d6605ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.11.20 17:02, Jakub Kicinski wrote:
> On Wed, 4 Nov 2020 15:59:25 +0100 Oliver Hartkopp wrote:
>> On 04.11.20 09:16, Eric Dumazet wrote:

>>> So skb_orphan(skb) in CAN before calling netif_rx() is better IMO.
>>>    
>>
>> Unfortunately you missed the answer from Vincent, why skb_orphan() does
>> not work here:
>>
>> https://lore.kernel.org/linux-can/CAMZ6RqJyZTcqZcq6jEzm5LLM_MMe=dYDbwvv=Y+dBR0drWuFmw@mail.gmail.com/
> 
> Okay, we can take this as a quick fix but to me it seems a little
> strange to be dropping what is effectively locally generated frames.

Thanks! So this patch doesn't hinder Marc's PR :-)

> Can we use a NAPI poll model here and back pressure TX if the echo
> is not keeping up?

Some of the CAN network drivers already support NAPI.

@Marc: Can we also use NAPI for echo'ing the skbs?

Best regards,
Oliver
