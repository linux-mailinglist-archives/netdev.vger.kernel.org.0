Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9675437F308
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 08:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhEMGaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 02:30:13 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:51877 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbhEMGaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 02:30:11 -0400
Received: from [192.168.1.18] ([86.243.172.93])
        by mwinf5d84 with ME
        id 46V12500L21Fzsu036V12W; Thu, 13 May 2021 08:29:02 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 13 May 2021 08:29:02 +0200
X-ME-IP: 86.243.172.93
Subject: Re: [PATCH] net: mdio: Fix a double free issue in the .remove
 function
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, david.daney@cavium.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <f8ad939e6d5df4cb0273ea71a418a3ca1835338d.1620855222.git.christophe.jaillet@wanadoo.fr>
 <20210512214403.GQ1336@shell.armlinux.org.uk>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <0a044473-f3f7-02fc-eca5-84adf8b5c9f2@wanadoo.fr>
Date:   Thu, 13 May 2021 08:29:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210512214403.GQ1336@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 12/05/2021 à 23:44, Russell King - ARM Linux admin a écrit :
> On Wed, May 12, 2021 at 11:35:38PM +0200, Christophe JAILLET wrote:
>> 'bus->mii_bus' have been allocated with 'devm_mdiobus_alloc_size()' in the
>> probe function. So it must not be freed explicitly or there will be a
>> double free.
>>
>> Remove the incorrect 'mdiobus_free' in the remove function.
> 
> Yes, this looks correct, thanks.
> 
> Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> However, there's another issue in this driver that ought to be fixed.
> 
> If devm_mdiobus_alloc_size() succeeds, but of_mdiobus_register() fails,
> we continue on to the next bus (which I think is reasonable.) We don't
> free the bus.
> 
> When we come to the remove method however, we will call
> mdiobus_unregister() on this existent but not-registered bus. Surely we
> don't want to do that?
> 

Hmmm, I don't agree here.

'nexus' is 'kzalloc()'ed.
So the pointers in 'buses[]' are all NULL by default.
We set 'nexus->buses[i] = bus' only when all functions that can fail in 
the loop have been called. (the very last 'break' is when the array is full)

And in the remove function, we have:
	struct cavium_mdiobus *bus = nexus->buses[i];
	if (!bus)
		continue;

So, this looks safe to me.

CJ
