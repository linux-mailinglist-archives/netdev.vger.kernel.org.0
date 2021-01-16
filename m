Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447432F8E7A
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 18:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbhAPRzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 12:55:15 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:44757 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbhAPRzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 12:55:15 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DJ5KC2LfLz1qrf4;
        Sat, 16 Jan 2021 18:54:23 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DJ5KC1X7Wz1tSQn;
        Sat, 16 Jan 2021 18:54:23 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id GTIdQNdWleqH; Sat, 16 Jan 2021 18:54:21 +0100 (CET)
X-Auth-Info: q4PGtmWcEz+TJIq87TKtaqTAN+gpSdtTaxrSUrD/pTA=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 16 Jan 2021 18:54:21 +0100 (CET)
Subject: Re: [PATCH net-next V2] net: ks8851: Fix mixed module/builtin build
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lukas Wunner <lukas@wunner.de>
References: <20210116164828.40545-1-marex@denx.de>
 <CAK8P3a1iqXjsYERVh+nQs9Xz4x7FreW3aS7OQPSB8CWcntnL4A@mail.gmail.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <a660f328-19d9-1e97-3f83-533c1245622e@denx.de>
Date:   Sat, 16 Jan 2021 18:54:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a1iqXjsYERVh+nQs9Xz4x7FreW3aS7OQPSB8CWcntnL4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/21 6:04 PM, Arnd Bergmann wrote:
> On Sat, Jan 16, 2021 at 5:48 PM Marek Vasut <marex@denx.de> wrote:
>>
>> When either the SPI or PAR variant is compiled as module AND the other
>> variant is compiled as built-in, the following build error occurs:
>>
>> arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
>> ks8851_common.c:(.text+0x1564): undefined reference to `__this_module'
>>
>> Fix this by passing THIS_MODULE as argument to ks8851_probe_common(),
>> ks8851_register_mdiobus(), and ultimately __mdiobus_register() in the
>> ks8851_common.c.
>>
>> Fixes: ef3631220d2b ("net: ks8851: Register MDIO bus and the internal PHY")
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Heiner Kallweit <hkallweit1@gmail.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Lukas Wunner <lukas@wunner.de>
> 
> I don't really like this version, as it does not actually solve the problem of
> linking the same object file into both vmlinux and a loadable module, which
> can have all kinds of side-effects besides that link failure you saw.
> 
> If you want to avoid exporting all those symbols, a simpler hack would
> be to '#include "ks8851_common.c" from each of the two files, which
> then always duplicates the contents (even when both are built-in), but
> at least builds the file the correct way.

That's the same as V1, isn't it ?
