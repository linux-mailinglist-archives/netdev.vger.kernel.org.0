Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21EF37F2ED
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 08:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhEMGW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 02:22:56 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:54505 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhEMGWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 02:22:55 -0400
Received: from [192.168.1.18] ([86.243.172.93])
        by mwinf5d84 with ME
        id 46Mh2500H21Fzsu036MiWh; Thu, 13 May 2021 08:21:44 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 13 May 2021 08:21:44 +0200
X-ME-IP: 86.243.172.93
Subject: Re: [PATCH] net: mdio: Fix a double free issue in the .remove
 function
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, david.daney@cavium.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <f8ad939e6d5df4cb0273ea71a418a3ca1835338d.1620855222.git.christophe.jaillet@wanadoo.fr>
 <YJxML4HvQd+WiDK6@lunn.ch>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <6ff7d862-b88a-eea0-d977-b7f71176c5ed@wanadoo.fr>
Date:   Thu, 13 May 2021 08:21:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YJxML4HvQd+WiDK6@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 12/05/2021 à 23:44, Andrew Lunn a écrit :
> On Wed, May 12, 2021 at 11:35:38PM +0200, Christophe JAILLET wrote:
>> 'bus->mii_bus' have been allocated with 'devm_mdiobus_alloc_size()' in the
>> probe function. So it must not be freed explicitly or there will be a
>> double free.
> 
> Hi Christophe
> 
> [PATCH] net: mdio: Fix a double free issue in the .remove function
> 
> Please indicate in the subject which mdio bus driver has a double
> free.

Ok, will do.
But looking at [1], it was not not self-explanatory that it was the rule 
here :)

> 
> Also, octeon_mdiobus_remove() appears to have the same problem.

In fact, even a little worse. It also calls 'mdiobus_free()' in the 
error handling path of the probe (which is why my coccinelle script 
didn't spot it. It looks for discrepancy between error handling path in 
the probe and the remove function. If both are wrong, it looks safe :) )

I'll send another patch for this driver.

CJ

> 
>        Andrew
> 

[1]: 
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/log/drivers/net/mdio
