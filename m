Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B254C144894
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 00:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgAUXxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 18:53:01 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39763 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgAUXxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 18:53:01 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so2059026plp.6;
        Tue, 21 Jan 2020 15:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mTIwd9W2zLvc27HSaaJRxejcA8B6fjMyurGz7EmpP8o=;
        b=UB4V2oFM14N3BqBhoFyYJ27nGEVYbgXg+u9Mk0AzO1O5eMvhxS9K4VTBBEEMS1KQfU
         Jai74lsOf0or37KusWuWjCMqY+6WUEQLAWF9H+thcU7WnNfEBObMZK4G8n6TdWt/8LUF
         AFLodtgx8OF0yHpEjRhDszApJRgeBG0KowLfzMEFBc/To0XhZnyM60bXZYhYQt7CvjwT
         Dn3q3NMKE6kYK8sdUxP2QUQovbKfg5+mdnFucVLSu02k8A/EHowwhYhLwCHl1Mi9Z67G
         1TW4ZRubPQHT1OLZLFR/akjKZMQ8AZ2Kh9nlHL6GWVkI/vOBikSIra04ZoU4LVw7Tf9F
         E8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mTIwd9W2zLvc27HSaaJRxejcA8B6fjMyurGz7EmpP8o=;
        b=D6NRKobs5F+m+18MnMgkXazl/WFrV1HqEThxsGE7PERMBoz+8GLDp3hg67LYGCagLk
         aWlvVFDiEaqwrbr1xBSUp2Swqk9ZgyUXtHyNghuWzDW+/ca3mkPvV27zhAXvKrdECC4v
         Z48Oc2g/Ij+u2XGNdAw0p8BFxOlxxohBhQB6QYb/JjwVEhWpmewBQxdtSgevah8mj4ru
         4+UV54SBJODwBIZBrPJjH3+Zjq9yGbVOAZ2vyB6roB9YZr6gBEPW+nZ3IJ3Di46rtk69
         EQA7er/MborGIDV5HzGDEXx+yLzPq1LjppkhOf6mGEZQ24wxyZ6o6kmzcSJLmTjTUZNe
         cTAQ==
X-Gm-Message-State: APjAAAUpbrbUU1AmnV8Iuv6MeLYZTGMyBipQWWg5HvVHlD+DB+T+VbWz
        5KM4IIHtf343UK00joBynqYn9TTF
X-Google-Smtp-Source: APXvYqzv+UdIH9Ptiv1BwlBE9BfJYUabY+64X78W0+uvD+01qBWOVNqvh3cklgXB7rhtVx/sFBgQkA==
X-Received: by 2002:a17:90a:a596:: with SMTP id b22mr1187477pjq.28.1579650780641;
        Tue, 21 Jan 2020 15:53:00 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id w6sm10459081pfq.99.2020.01.21.15.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 15:52:59 -0800 (PST)
Subject: Re: [PATCH net v2 01/12] net/sonic: Add mutual exclusion for
 accessing shared state
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1579641728.git.fthain@telegraphics.com.au>
 <d7c6081de558e2fe5693a35bb735724411134cb5.1579641728.git.fthain@telegraphics.com.au>
 <0113c00f-3f77-8324-95a8-31dd6f64fa6a@gmail.com>
 <alpine.LNX.2.21.1.2001221021590.8@nippy.intranet>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1b8d9cbe-94cf-2eb6-de44-2a2f9cb0a084@gmail.com>
Date:   Tue, 21 Jan 2020 15:52:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.21.1.2001221021590.8@nippy.intranet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/21/20 3:33 PM, Finn Thain wrote:
> On Tue, 21 Jan 2020, Eric Dumazet wrote:
> 
>> On 1/21/20 1:22 PM, Finn Thain wrote:
>>> The netif_stop_queue() call in sonic_send_packet() races with the
>>> netif_wake_queue() call in sonic_interrupt(). This causes issues
>>> like "NETDEV WATCHDOG: eth0 (macsonic): transmit queue 0 timed out".
>>> Fix this by disabling interrupts when accessing tx_skb[] and next_tx.
>>> Update a comment to clarify the synchronization properties.
>>>
>>> Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
>>> Tested-by: Stan Johnson <userm57@yahoo.com>
>>> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>>
>>> @@ -284,9 +287,16 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
>>>  	struct net_device *dev = dev_id;
>>>  	struct sonic_local *lp = netdev_priv(dev);
>>>  	int status;
>>> +	unsigned long flags;
>>> +
>>> +	spin_lock_irqsave(&lp->lock, flags);
>>
>>
>> This is a hard irq handler, no need to block hard irqs.
>>
>> spin_lock() here is enough.
>>
> 
> Well, yes, assuming we're dealing with SMP [1]. Probably just disabling 
> pre-emption is all that will ever be needed.
> 
> Anyway, the real problem solved by disabling irqs is that macsonic must 
> avoid re-entrance of sonic_interrupt(). [2]
> 
> [1]
> https://lore.kernel.org/netdev/alpine.LNX.2.21.1.2001211026190.8@nippy.intranet/T/#m0523c8b2a26a410ed56889d9230c37ba1160d40a
> 
> [2]
> https://lore.kernel.org/netdev/alpine.LNX.2.21.1.2001211026190.8@nippy.intranet/T/#m1c8ca580d2b45e61a628d17839978d0bd5aaf061
> 

Oh well... 

I would rather keep the m68k specific wrapper...

Please add a fat comment of why spin_lock_irqsave() is used, 
to avoid a future 'cleanup', since average network developer
wont be aware of m68k oddities.


 
