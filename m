Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A40E83574
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 17:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbfHFPjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 11:39:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37574 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbfHFPjU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 11:39:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/dQaZQMhVFrWkGgcjKYtqkC8hkpv/jcBX7O5fB1A2Gs=; b=554UWq0phj8ND95AlfMvrXrRV8
        FvfBalqc2Cn2fc/uOEXhojHHPT3ibrrKrXhJFciKKTSH5nBlZjdC8y4QfW0/cav/IkUrl/yA+MF/N
        T8nqRvwYQZT/0Lj56dBKtn3mMHCnvmw47vmttwXSeDZ7vExd1XrElJcexqnFDvp66kkY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hv1YM-0005SY-HM; Tue, 06 Aug 2019 17:39:10 +0200
Date:   Tue, 6 Aug 2019 17:39:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH 06/16] net: phy: adin: support PHY mode converters
Message-ID: <20190806153910.GB20422@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-7-alexandru.ardelean@analog.com>
 <20190805145105.GN24275@lunn.ch>
 <15cf5732415c313a7bfe610e7039e7c97b987073.camel@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15cf5732415c313a7bfe610e7039e7c97b987073.camel@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 06:47:08AM +0000, Ardelean, Alexandru wrote:
> On Mon, 2019-08-05 at 16:51 +0200, Andrew Lunn wrote:
> > [External]
> > 
> > On Mon, Aug 05, 2019 at 07:54:43PM +0300, Alexandru Ardelean wrote:
> > > Sometimes, the connection between a MAC and PHY is done via a
> > > mode/interface converter. An example is a GMII-to-RGMII converter, which
> > > would mean that the MAC operates in GMII mode while the PHY operates in
> > > RGMII. In this case there is a discrepancy between what the MAC expects &
> > > what the PHY expects and both need to be configured in their respective
> > > modes.
> > > 
> > > Sometimes, this converter is specified via a board/system configuration (in
> > > the device-tree for example). But, other times it can be left unspecified.
> > > The use of these converters is common in boards that have FPGA on them.
> > > 
> > > This patch also adds support for a `adi,phy-mode-internal` property that
> > > can be used in these (implicit convert) cases. The internal PHY mode will
> > > be used to specify the correct register settings for the PHY.
> > > 
> > > `fwnode_handle` is used, since this property may be specified via ACPI as
> > > well in other setups, but testing has been done in DT context.
> > 
> > Looking at the patch, you seems to assume phy-mode is what the MAC is
> > using? That seems rather odd, given the name. It seems like a better
> > solution would be to add a mac-mode, which the MAC uses to configure
> > its side of the link. The MAC driver would then implement this
> > property.
> > 
> 
> actually, that's a pretty good idea;
> i guess i was narrow-minded when writing the driver, and got stuck on phy specifics, and forgot about the MAC-side;
> [ i also catch these design elements when reviewing, but i also seem to miss them when writing stuff sometimes ]
> 

Hi Ardelean

We should also consider the media converter itself. It is passive, or
does it need a driver. You seems to be considering GMII-to-RGMII. But
what about RGMII to SGMII? or RGMII to 1000Base-KX etc? Ideally we
want a generic solution and we need to think about all the parts in
the system.

     Andrew
