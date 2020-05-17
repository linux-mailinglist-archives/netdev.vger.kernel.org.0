Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F121D6556
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 04:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgEQC2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 22:28:12 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:33409 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgEQC2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 22:28:12 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49PmK56mySz1qrG5;
        Sun, 17 May 2020 04:28:09 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49PmK569ypz1qr41;
        Sun, 17 May 2020 04:28:09 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id fugxJwvTSsFq; Sun, 17 May 2020 04:28:08 +0200 (CEST)
X-Auth-Info: HokN6+SBdsGCiW11tyLPVX28Rhy9VUxppuqnlMPCcQo=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 17 May 2020 04:28:08 +0200 (CEST)
Subject: Re: [PATCH V6 00/20] net: ks8851: Unify KS8851 SPI and MLL drivers
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, lukas@wunner.de, ynezz@true.cz,
        yuehaibing@huawei.com
References: <20200517003354.233373-1-marex@denx.de>
 <20200516.190225.342589110126932388.davem@davemloft.net>
From:   Marek Vasut <marex@denx.de>
Message-ID: <a68af5dd-d12c-f645-f89f-3967cc64e8df@denx.de>
Date:   Sun, 17 May 2020 04:27:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200516.190225.342589110126932388.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/20 4:02 AM, David Miller wrote:
> From: Marek Vasut <marex@denx.de>
> Date: Sun, 17 May 2020 02:33:34 +0200
> 
>> The KS8851SNL/SNLI and KS8851-16MLL/MLLI/MLLU are very much the same pieces
>> of silicon, except the former has an SPI interface, while the later has a
>> parallel bus interface. Thus far, Linux has two separate drivers for each
>> and they are diverging considerably.
>>
>> This series unifies them into a single driver with small SPI and parallel
>> bus specific parts. The approach here is to first separate out the SPI
>> specific parts into a separate file, then add parallel bus accessors in
>> another separate file and then finally remove the old parallel bus driver.
>> The reason for replacing the old parallel bus driver is because the SPI
>> bus driver is much higher quality.
> 
> What strikes me in these changes is all of the new indirect jumps in
> the fast paths of TX and RX packet processing.  It's just too much for
> my eyes. :-)
> 
> Especially in the presence of Spectre mitigations, these costs are
> quite non-trivial.
> 
> Seriously, I would recommend that instead of having these small
> indirect helpers, just inline the differences into two instances of
> the RX interrupt and the TX handler.

So I was already led into reworking the entire series to do this
inlining once, after V1. It then turned out it's a horrible mess to get
everything to compile as modules and built-in and then also only the
parallel/SPI as a module and then the other way around.

Since Lukas was very adamant about the performance impact of these
indirect calls, I did measurements and it turned out the impact is
basically nonexistent. And that's pretty much to be expected, since this
is a 100 Mbit ethernet on SPI bus limited to 40 MHz (so effectively a 40
Mbit ethernet tops) or on parallel bus. The parallel bus option is the
"more performant" one and even that one shows no difference with and
without this series in iperf, either in throughput or latency.

So I spent more time and undid those changes again. And here is the V6
of the series.
