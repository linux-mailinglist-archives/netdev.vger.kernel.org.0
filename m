Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD9931957EC
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 14:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgC0NX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 09:23:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33784 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgC0NX3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 09:23:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KxLAqRWANV+lRpwj2JfW/z28qcDsnVnMDHMTtllBTdU=; b=B3p2FW7y41USJyD7JbgxxGzYae
        2wnaFlA/0Ag++03oLARlmo19xECQB4FkGAuOn+ffFTxdNCfMEOFQ0hgilpPt7ye/3abHiSHLT+jfV
        DJGuWVZm+teNrbR0MpvqUUrFGFGkyvA/AANfjGHsyhLkIEg6hPn9bkoUfxbEwuPBtEJ8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHox7-0001ab-P3; Fri, 27 Mar 2020 14:23:13 +0100
Date:   Fri, 27 Mar 2020 14:23:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 6/9] net: phy: add backplane kr driver
 support
Message-ID: <20200327132313.GO3819@lunn.ch>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
 <20200327010706.GN3819@lunn.ch>
 <AM0PR04MB5443C1142ABE578ACC641FC5FBCC0@AM0PR04MB5443.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB5443C1142ABE578ACC641FC5FBCC0@AM0PR04MB5443.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 01:02:17PM +0000, Florinel Iordache wrote:
> > > +static u32 le_ioread32(void __iomem *reg) {
> > > +     return ioread32(reg);
> > > +}
> > > +
> > > +static void le_iowrite32(u32 value, void __iomem *reg) {
> > > +     iowrite32(value, reg);
> > > +}
> > > +
> > > +static u32 be_ioread32(void __iomem *reg) {
> > > +     return ioread32be(reg);
> > > +}
> > > +
> > > +static void be_iowrite32(u32 value, void __iomem *reg) {
> > > +     iowrite32be(value, reg);
> > > +}
> > 
> > This is very surprising to me. I've not got my head around the structure of this
> > code yet, but i'm surprised to see memory mapped access functions in generic
> > code.
> > 
> >        Andrew
> 
> Hi Andrew,
> 
> This is part of the framework used to automatically setup desired I/O 
> callbacks for memory access according to device specific endianness 
> which is specified in the specific device tree (DTS).
> This approach (explained below) was used to avoid the potential 
> redundant code related to memory access LE/BE which should be 
> similar for all devices. 

All devices which are using mmio. I assume the standard does not say
anything about memory mapped IO. It talks just about MDIO registers.

I would expect the generic code to just have generic accessors, which
could work for MMIO, yet more MDIO registers, i2c, spi, etc.

So add another support file which adds an MMIO implementation of these
generic access functions. Any driver which uses MMIO can pull it in.
The same should be true for the DT binding. Don't assume MMIO in the
generic binding.

> This portion of code is just preparing these four static IO routines 
> for specific endianness access LE/BE

Linux has a lot of MMIO accessors. Are you sure there is not one which
will do the right thing, making use of cpu_le32() or cpu_be32()
etc. Or are there different variants of the hardware, with some using
BE registers and some using LE registers? Note, this is all about the
endianness of the register, not the endianness of the cpu. cpu_le32()
will be a NOP when the CPU is running LE.

     Andrew
