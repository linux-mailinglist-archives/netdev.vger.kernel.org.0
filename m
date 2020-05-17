Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1EB1D67FB
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 14:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgEQMjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 08:39:24 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:34895 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgEQMjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 08:39:24 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49Q1tK4S8Dz1qrfB;
        Sun, 17 May 2020 14:39:20 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49Q1tJ133lz1qr4Z;
        Sun, 17 May 2020 14:39:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id TznATJdw1tkZ; Sun, 17 May 2020 14:39:17 +0200 (CEST)
X-Auth-Info: Tv0Gq7lH3pFwydGsH+xnmgIwQHKHd/DjKSPluHbtOsE=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 17 May 2020 14:39:17 +0200 (CEST)
Subject: Re: [PATCH V6 00/20] net: ks8851: Unify KS8851 SPI and MLL drivers
To:     Lukas Wunner <lukas@wunner.de>, David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, ynezz@true.cz, yuehaibing@huawei.com
References: <20200517003354.233373-1-marex@denx.de>
 <20200516.190225.342589110126932388.davem@davemloft.net>
 <20200517071355.ww5xh7fgq7ymztac@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <b9763cd7-e206-df0b-a4dc-cedcccb29de5@denx.de>
Date:   Sun, 17 May 2020 14:36:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200517071355.ww5xh7fgq7ymztac@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/20 9:13 AM, Lukas Wunner wrote:
> On Sat, May 16, 2020 at 07:02:25PM -0700, David Miller wrote:
>>> The KS8851SNL/SNLI and KS8851-16MLL/MLLI/MLLU are very much the same pieces
>>> of silicon, except the former has an SPI interface, while the later has a
>>> parallel bus interface. Thus far, Linux has two separate drivers for each
>>> and they are diverging considerably.
>>>
>>> This series unifies them into a single driver with small SPI and parallel
>>> bus specific parts. The approach here is to first separate out the SPI
>>> specific parts into a separate file, then add parallel bus accessors in
>>> another separate file and then finally remove the old parallel bus driver.
>>> The reason for replacing the old parallel bus driver is because the SPI
>>> bus driver is much higher quality.
>>
>> What strikes me in these changes is all of the new indirect jumps in
>> the fast paths of TX and RX packet processing.  It's just too much for
>> my eyes. :-)
>>
>> Especially in the presence of Spectre mitigations, these costs are
>> quite non-trivial.
>>
>> Seriously, I would recommend that instead of having these small
>> indirect helpers, just inline the differences into two instances of
>> the RX interrupt and the TX handler.
> 
> I agree.

I do not.

> However in terms of performance there's a bigger problem:
> 
> Previously ks8851.c (SPI driver) had 8-bit and 32-bit register accessors.
> The present series drops them and performs a 32-bit access as two 16-bit
> accesses and an 8-bit access as one 16-bit access because that's what
> ks8851_mll.c (16-bit parallel bus driver) does.  That has a real,
> measurable performance impact because in the case of 8-bit accesses,
> another 8 bits need to be transferred over the SPI bus, and in the case
> of 32-bit accesses, *two* SPI transfers need to be performed.
> 
> The 8-bit and 32-bit accesses happen in ks8851_rx_pkts(), i.e. in the
> RX hotpath.  I've provided numbers for the performance impact and even
> a patch to solve them but it was dismissed and not included in the
> present series:
> 
> https://lore.kernel.org/netdev/20200420140700.6632hztejwcgjwsf@wunner.de/
> 
> The reason given for the dismissal was that I had performed the measurements
> on 4.19 which is allegedly "long dead" (in Andrew Lunn's words).
> However I can assure you that performing two SPI transfers has not
> magically become as fast as performing one SPI transfer since 4.19.
> So the argument is nonsense.

I invested time and even obtained the SPI variant of the card to perform
actual comparative measurements on linux-next both on the SPI and
parallel variant with iperf, both for latency and throughput, and I do
not observe this problem.

A month ago, I even provided you a branch with all the patches and the
DT patch for RPi3 (the platform you claim to use for these tests, so I
used the same) so you can perform the same test as I did, with the same
hardware and the same software. So it should have been trivial to
reproduce the tests I did and their results.

> Nevertheless I was going to repeat the performance measurements on a
> recent kernel but haven't gotten around to that yet because the
> measurements need to be performed with CONFIG_PREEMPT_RT_FULL to
> be reliable (a vanilla kernel is too jittery), so I have to create
> a new branch with RT patches on the test machine, which is fairly
> involved and time consuming.
> 
> I think it's fair that the two drivers are unified, but the performance
> for the SPI variant shouldn't be unnecessarily diminished in the process.

Could it be that your problem is related to this huge out-of-tree patch
you use then ?

-- 
Best regards,
Marek Vasut
