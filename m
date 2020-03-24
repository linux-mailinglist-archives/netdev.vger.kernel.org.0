Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BAF19138A
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgCXOrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:47:12 -0400
Received: from bmailout3.hostsharing.net ([176.9.242.62]:38337 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbgCXOrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:47:12 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id A0261100FBFE8;
        Tue, 24 Mar 2020 15:47:10 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 3E317AF8E3; Tue, 24 Mar 2020 15:47:10 +0100 (CET)
Date:   Tue, 24 Mar 2020 15:47:10 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 07/14] net: ks8851: Use 16-bit writes to program MAC
 address
Message-ID: <20200324144710.bw2q7q7c7yiv7nf7@wunner.de>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-8-marex@denx.de>
 <20200324081311.ww6p7dmijbddi5jm@wunner.de>
 <20200324122553.GS3819@lunn.ch>
 <20200324123623.vvvcoiza6ehuecf6@wunner.de>
 <be4c96dc-87ab-27a9-cf51-c1e54853b528@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be4c96dc-87ab-27a9-cf51-c1e54853b528@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 02:09:18PM +0100, Marek Vasut wrote:
> I have a feeling this whole thing might be more messed up then we
> thought. At least the KS8851-16MLL has an "endian mode" bit in the CCR
> register, the SPI variant does not.

On the MLL variant of this chip, pin 10 can be pulled up to force it
into big endian mode, otherwise it's in little-endian mode.  Obviously
this should be configured by the board designer such that it matches
the CPU's endianness.

Of course we *could* support inverted endianness in case the hardware
engineer botched the board layout.  Not sure if we have to.

In the CCR register that you mention, you can determine whether the
pin is pulled up or not.  If it is in big-endian mode and you're
on a little-endian CPU, you're hosed and the only option that you've
got is to invert endianness in software, i.e. in the accessors.

If the pin is pulled to ground or not connected (again, can be
determined from CCR) then you're able to switch the endianness by
setting bit 11 in the RXFDPR register.  No need to convert it in
the accessors in this case.

Thanks,

Lukas
