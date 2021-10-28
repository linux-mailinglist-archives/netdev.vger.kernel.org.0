Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B7143DB73
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhJ1Grw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 Oct 2021 02:47:52 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:53967 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhJ1Grv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:47:51 -0400
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 7FC9660014;
        Thu, 28 Oct 2021 06:45:21 +0000 (UTC)
Date:   Thu, 28 Oct 2021 08:45:20 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [RFC PATCH net] net: ipconfig: Release the rtnl_lock while
 waiting for carrier
Message-ID: <20211028084520.4b96f93a@bootlin.com>
In-Reply-To: <163535070902.935735.6368176213562383450@kwain>
References: <20211027131953.9270-1-maxime.chevallier@bootlin.com>
        <163535070902.935735.6368176213562383450@kwain>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Antoine,

On Wed, 27 Oct 2021 18:05:09 +0200
Antoine Tenart <atenart@kernel.org> wrote:

>Hi Maxime,
>
>Quoting Maxime Chevallier (2021-10-27 15:19:53)
>> While waiting for a carrier to come on one of the netdevices, some
>> devices will require to take the rtnl lock at some point to fully
>> initialize all parts of the link.
>> 
>> That's the case for SFP, where the rtnl is taken when a module gets
>> detected. This prevents mounting an NFS rootfs over an SFP link.
>> 
>> This means that while ipconfig waits for carriers to be detected, no SFP
>> modules can be detected in the meantime, it's only detected after
>> ipconfig times out.
>> 
>> This commit releases the rtnl_lock while waiting for the carrier to come
>> up, and re-takes it to check the for the init device and carrier status.
>> 
>> At that point, the rtnl_lock seems to be only protecting
>> ic_is_init_dev().
>> 
>> Fixes: 73970055450e ("sfp: add SFP module support")  
>
>Was this working with SFP modules before?

From what I can tell, no. In that case, does it need a fixes tag ?
It seems the problem has always been there, and booting an nfsroot
never worked over SFP links.

>
>> diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
>> index 816d8aad5a68..069ae05bd0a5 100644
>> --- a/net/ipv4/ipconfig.c
>> +++ b/net/ipv4/ipconfig.c
>> @@ -278,7 +278,12 @@ static int __init ic_open_devs(void)
>>                         if (ic_is_init_dev(dev) && netif_carrier_ok(dev))
>>                                 goto have_carrier;
>>  
>> +               /* Give a chance to do complex initialization that
>> +                * would require to take the rtnl lock.
>> +                */
>> +               rtnl_unlock();
>>                 msleep(1);
>> +               rtnl_lock();
>>  
>>                 if (time_before(jiffies, next_msg))
>>                         continue;  
>
>The rtnl lock is protecting 'for_each_netdev' and 'dev_change_flags' in
>this function. What could happen in theory is a device gets removed from
>the list or has its flags changed. I don't think that's an issue here.
>
>Instead of releasing the lock while sleeping, you could drop the lock
>before the carrier waiting loop (with a similar comment) and only
>protect the above 'for_each_netdev' loop.

Nice catch, the effect should be the same but with a much cleaner idea
of what is being protected.

I'll give it a try and respin, thanks for the review !

Maxime

>Antoine



-- 
Maxime Chevallier, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com
