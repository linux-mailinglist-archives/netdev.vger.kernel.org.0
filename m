Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE8DC0F47
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 03:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbfI1B46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 21:56:58 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:34052 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfI1B46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 21:56:58 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46gBc73rSYz1s5kQ;
        Sat, 28 Sep 2019 03:56:55 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46gBc71lgWz1qqkK;
        Sat, 28 Sep 2019 03:56:55 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id Pli06WFR5ufN; Sat, 28 Sep 2019 03:56:53 +0200 (CEST)
X-Auth-Info: z3dgMJoumqA4E33y9pZ/1wlWioFhlicdkr5WBG2CUWQ=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 28 Sep 2019 03:56:53 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
Subject: Re: [PATCH V2] net: dsa: microchip: Always set regmap stride to 1
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Woojung Huh <woojung.huh@microchip.com>
References: <20190925220842.4301-1-marex@denx.de>
 <CAFSKS=PFBewpMiMXuPmJXqv=sbYhS8_9k=DrwAXjjPNi7xFwcA@mail.gmail.com>
Message-ID: <638f42ee-bb8e-0217-df09-665ddd795ad5@denx.de>
Date:   Sat, 28 Sep 2019 03:56:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAFSKS=PFBewpMiMXuPmJXqv=sbYhS8_9k=DrwAXjjPNi7xFwcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/26/19 3:52 PM, George McCollister wrote:
> On Wed, Sep 25, 2019 at 5:08 PM Marek Vasut wrote:
>>
>> The regmap stride is set to 1 for regmap describing 8bit registers already.
>> However, for 16/32/64bit registers, the stride is 2/4/8 respectively. This
>> is not correct, as the switch protocol supports unaligned register reads
>> and writes and the KSZ87xx even uses such unaligned register accesses to
>> read e.g. MIB counter.
>>
>> This patch fixes MIB counter access on KSZ87xx.
> 
> After looking through a couple hundred pages of register documentation
> for KSZ9477 and KSZ9567 I find only registers that are aligned to
> their width. In my testing the KSZ9567 works fine with and without the
> patch. The only downside is that all of the unaligned registers
> needlessly show up in the debugfs regmap, this doesn't really matter
> though. As long as it fixes the issues on KSZ87xx this looks fine to
> me.

Right.

To avoid exposing all registers through regmap debugfs entries, we would
have to define the regmap constrains for
readable/writeable/volatile/precious registers, which we should
eventually do anyway, but that's way beyond the scope of this fix.
