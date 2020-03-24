Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2961913B1
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgCXOxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:53:36 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:40191 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbgCXOxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:53:36 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48mvQ5573jz1tBx1;
        Tue, 24 Mar 2020 15:53:33 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48mvQ54NS1z1r0bw;
        Tue, 24 Mar 2020 15:53:33 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id KtMgjtT6Hq6Q; Tue, 24 Mar 2020 15:53:30 +0100 (CET)
X-Auth-Info: q/iK8/iTMlze450mVvcXT6YuCzlcjNMUPEfG9ejB/8k=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 24 Mar 2020 15:53:30 +0100 (CET)
Subject: Re: [PATCH 07/14] net: ks8851: Use 16-bit writes to program MAC
 address
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-8-marex@denx.de>
 <20200324081311.ww6p7dmijbddi5jm@wunner.de> <20200324122553.GS3819@lunn.ch>
 <20200324123623.vvvcoiza6ehuecf6@wunner.de>
 <be4c96dc-87ab-27a9-cf51-c1e54853b528@denx.de>
 <20200324144710.bw2q7q7c7yiv7nf7@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <ab4d5e2d-8e4a-059a-c72a-b343a4a8bfb8@denx.de>
Date:   Tue, 24 Mar 2020 15:53:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324144710.bw2q7q7c7yiv7nf7@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/20 3:47 PM, Lukas Wunner wrote:
> On Tue, Mar 24, 2020 at 02:09:18PM +0100, Marek Vasut wrote:
>> I have a feeling this whole thing might be more messed up then we
>> thought. At least the KS8851-16MLL has an "endian mode" bit in the CCR
>> register, the SPI variant does not.
> 
> On the MLL variant of this chip, pin 10 can be pulled up to force it
> into big endian mode, otherwise it's in little-endian mode.  Obviously
> this should be configured by the board designer such that it matches
> the CPU's endianness.

Sadly, that's not the case on the device I have here right now.
So I'm suffering the performance impact of having to endian-swap on
every 16bit access.

> Of course we *could* support inverted endianness in case the hardware
> engineer botched the board layout.  Not sure if we have to.
> 
> In the CCR register that you mention, you can determine whether the
> pin is pulled up or not.  If it is in big-endian mode and you're
> on a little-endian CPU, you're hosed and the only option that you've
> got is to invert endianness in software, i.e. in the accessors.

Yes

> If the pin is pulled to ground or not connected (again, can be
> determined from CCR) then you're able to switch the endianness by
> setting bit 11 in the RXFDPR register.  No need to convert it in
> the accessors in this case.

That's not the setup I have right now, sadly.
