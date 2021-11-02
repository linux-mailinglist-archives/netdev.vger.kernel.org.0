Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690E044347B
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 18:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhKBRWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 13:22:48 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:52068 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhKBRWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 13:22:46 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1A2HK1ZT063923;
        Tue, 2 Nov 2021 12:20:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1635873601;
        bh=W0BspqfN9In7mDTJLDkzgni27xHQbtRyJscHEUeFFl0=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=rlly9oHzItNBRZXVI/pOb8up1WRAlmd3KbQePSp0mUAYY4h92WuyxGzukNel38HTQ
         gmH0cKBcDqiv0d1RK1mBBeXe0FG60xM30IvWjjbEOLqRkN7PizSnlBrJq8cBx/aM5S
         /GwkoB5Sqbv8BCR63nKLOe0cEbLSZlSyIW+ZJPyU=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1A2HJw6u095148
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 2 Nov 2021 12:20:01 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 2
 Nov 2021 12:20:00 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 2 Nov 2021 12:20:00 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1A2HJwmO125534;
        Tue, 2 Nov 2021 12:19:58 -0500
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
References: <20211101182859.24073-1-grygorii.strashko@ti.com>
 <YYBBHsFEwGdPJw3b@lunn.ch> <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk>
 <YYCLJnY52MoYfxD8@lunn.ch> <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <bc9df441-49bf-5c8a-891c-cc3f0db00aba@ti.com>
Date:   Tue, 2 Nov 2021 19:19:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02/11/2021 14:39, Russell King (Oracle) wrote:
> On Tue, Nov 02, 2021 at 01:49:42AM +0100, Andrew Lunn wrote:
>>> The use of the indirect registers is specific to PHYs, and we already
>>> know that various PHYs don't support indirect access, and some emulate
>>> access to the EEE registers - both of which are handled at the PHY
>>> driver level.
>>
>> That is actually an interesting point. Should the ioctl call actually
>> use the PHY driver read_mmd and write_mmd? Or should it go direct to
>> the bus? realtek uses MII_MMD_DATA for something to do with suspend,
>> and hence it uses genphy_write_mmd_unsupported(), or it has its own
>> function emulating MMD operations.
>>
>> So maybe the ioctl handler actually needs to use __phy_read_mmd() if
>> there is a phy at the address, rather than go direct to the bus?
>>
>> Or maybe we should just say no, you should do this all from userspace,
>> by implementing C45 over C22 in userspace, the ioctl allows that, the
>> kernel does not need to be involved.
> 
> Yes and no. There's a problem accessing anything that involves some kind
> of indirect or paged access with the current API - you can only do one
> access under the bus lock at a time, which makes the whole thing
> unreliable. We've accepted that unreliability on the grounds that this
> interface is for debugging only, so if it does go wrong, you get to keep
> all the pieces!

Right, MMD indirect access is 4 MDIO bus transactions.

> 
> The paged access case is really no different from the indirect C45 case.
> They're both exactly the same type of indirect access, just using
> different registers.
> 
> That said, the MII ioctls are designed to be a bus level thing - you can
> address anything on the MII bus with them. Pushing the ioctl up to the
> PHY layer means we need to find the right phy device to operate on.

The phy_read_mmd/__phy_read_mmd() was the first thing i considered, but
rejected exactly because of the possibility to access any MDIO device
through this ioctls.

in general, it can be called with check (mii->phy_id = pl->phydev->mdio.addr)

> What
> if we attempt a C45 access at an address that there isn't a phy device?
> 
> For example, what would be the effect of trying a C45 indirect access to
> a DSA switch?

in case, C22/C22 MMD It will fail to read, seems no issues, and phytool will
just return 0xfffb.

First, there seems was previous attempt to do the same [1].

Also, there is some historical ... mess in this area :(
There are:

- generic_mii_ioctl() - 33 users (2005, it's older), uses struct mii_if_info

- mdio_mii_ioctl() - 7 users (2009), uses struct mdio_if_info

- phy_mii_ioctl() - 29 users, including phylink (2005), need PHY to get MDIO bus

- phy_do_ioctl()->phy_mii_ioctl() - 10 users (2020)

- phy_do_ioctl_running()->phy_mii_ioctl() - 22 users (2020)

- phylink_mii_ioctl() (also calls phy_mii_ioctl(), but only for SIOCSHWTSTAMP) - 9 users, including DSA (2017)
   need PHY to get MDIO bus, also uses PHY for c45 detection, but any phy_id can be passed.

- SIOCSMIIREG custom implementation - 32 users


> 
> Personally, my feeling would be that if we want to solve this, we need
> to solve this properly - we need to revise the interface so it's
> possible to request the kernel to perform a group of MII operations, so
> that userspace can safely access any paged/indirect register. With that
> solved, there will be no issue with requiring userspace to know what
> it's doing with indirect C45 accesses.
> 

It would require MDIO bus lock, which is not a solution,
or some sort of batch processing, like for mmd:
  w reg1 val1
  w reg2 val2
  w reg1 val3
  r reg2

What Kernel interface do you have in mind?

Sry, but I have to note that demand for this become terribly high, min two pings in months

[1] https://www.spinics.net/lists/netdev/msg653629.html

-- 
Best regards,
grygorii
