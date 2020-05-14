Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BB41D24F7
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 03:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgENBvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 21:51:50 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:35865 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgENBvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 21:51:49 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49MvfW3nvTz1qrfc;
        Thu, 14 May 2020 03:51:47 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49MvfW3c64z1shfB;
        Thu, 14 May 2020 03:51:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id Pppl1e80wGDf; Thu, 14 May 2020 03:51:46 +0200 (CEST)
X-Auth-Info: +k3WFhqeY8IntDAECAUaEWK0adIIy0dJc5+mZckc5Yk=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 14 May 2020 03:51:46 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
Subject: Re: [PATCH V5 10/19] net: ks8851: Factor out bus lock handling
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-11-marex@denx.de> <20200514011957.GF527401@lunn.ch>
Message-ID: <64a1c7d9-db89-d4fa-a7bd-dc574d86a853@denx.de>
Date:   Thu, 14 May 2020 03:37:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200514011957.GF527401@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 3:19 AM, Andrew Lunn wrote:
> On Thu, May 14, 2020 at 02:07:38AM +0200, Marek Vasut wrote:
>> Pull out bus access locking code into separate functions, this is done
>> in preparation for unifying the driver with the parallel bus one. The
>> parallel bus driver does not need heavy mutex locking of the bus and
>> works better with spinlocks, hence prepare these locking functions to
>> be overridden then.
>>
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Lukas Wunner <lukas@wunner.de>
>> Cc: Petr Stetiar <ynezz@true.cz>
>> Cc: YueHaibing <yuehaibing@huawei.com>
> 
>   
>> +/**
>> + * ks8851_lock - register access lock
>> + * @ks: The chip state
>> + * @flags: Spinlock flags
>> + *
>> + * Claim chip register access lock
>> + */
>> +static void ks8851_lock(struct ks8851_net *ks, unsigned long *flags)
>> +{
>> +	mutex_lock(&ks->lock);
>> +}
> 
> Do you actually need flags? It is for spin_lock_irqsave().  Which you
> use when you have a critical section inside an interrupt handler. But
> a mutex cannot protect against an interrupt handler. So there should
> be no need to use spin_lock_irqsave(), spin_lock() should be enough,
> and that does not need flags.

I do need it, the SPI variant of the device uses threaded interrupt
handler and does quite a few heavy operations there (like pumping TX
data across the SPI bus) so it needs the mutex, but the overhead of that
is too much for the parallel bus variant of the chip (which pumps the
data in the start_xmit handler directly) and so that one uses spinlock
both in ks8851_start_xmit_par() and in the IRQ handler.

I had to do it this way (spinlock + pumping data in start_xmit),
otherwise the overhead for the parallel bus option was too big (in the
20% ballpark).
