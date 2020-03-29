Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB851196DE7
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 16:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgC2OXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 10:23:41 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:46873 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727488AbgC2OXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 10:23:41 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48qyWF6G37z1rqBD;
        Sun, 29 Mar 2020 16:23:30 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48qyW63Y5Pz1qyF3;
        Sun, 29 Mar 2020 16:23:30 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id ywEKgl-WcSll; Sun, 29 Mar 2020 16:23:29 +0200 (CEST)
X-Auth-Info: qgdue+JsfQ3VqHNbFnD6thNfGg0erPriR8H2dzWD7M8=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 29 Mar 2020 16:23:29 +0200 (CEST)
Subject: Re: [PATCH 11/14] net: ks8851: Implement register and FIFO accessor
 callbacks
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-12-marex@denx.de>
 <20200324134555.wgtvj4owmkw3jup4@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <6aa83a56-e182-aa56-cdb8-d6fdcefd2b5c@denx.de>
Date:   Sun, 29 Mar 2020 16:22:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324134555.wgtvj4owmkw3jup4@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/20 2:45 PM, Lukas Wunner wrote:
> On Tue, Mar 24, 2020 at 12:43:00AM +0100, Marek Vasut wrote:
>> The register and FIFO accessors are bus specific. Implement callbacks so
>> that each variant of the KS8851 can implement matching accessors and use
>> the rest of the common code.
> [...]
>> +	unsigned int		(*rdreg16)(struct ks8851_net *ks,
>> +					   unsigned int reg);
>> +	void			(*wrreg16)(struct ks8851_net *ks,
>> +					   unsigned int reg, unsigned int val);
>> +	void			(*rdfifo)(struct ks8851_net *ks, u8 *buff,
>> +					  unsigned int len);
>> +	void			(*wrfifo)(struct ks8851_net *ks,
>> +					  struct sk_buff *txp, bool irq);
> 
> Using callbacks entails a dereference for each invocation.
> 
> A cheaper approach is to just declare the function signatures
> in ks8851.h and provide non-static implementations in
> ks8851_spi.c and ks8851_mll.c, so I'd strongly prefer that.
> 
> Even better, since this only concerns the register accessors
> (which are inlined anyway by the compiler), it would be best
> to have them in header files (e.g. ks8851_spi.h / ks8851_par.h)
> which are included by the common ks8851.c based on the target
> which is being compiled.  That involves a bit of kbuild magic
> though to generate two different .o from the same .c file,
> each with specific "-include ..." CFLAGS.

Seems this also fails when both options are compiled in, then there is a
symbol name collision. Thoughts ?
