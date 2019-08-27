Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84D4F9EFDF
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbfH0QNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:13:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34982 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbfH0QNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EUdcOXqzDMg/BPMZ+mHA3Lf8aib/qAEj7QKintG8i1o=; b=zoV9sB08UoCM+TTqsh2QC+T5y+
        lZz1Ib+zNYLNZRXVPOm2DbrZuZSMep/zbGNMPAsR7DBWL3PjE0xYRuVSiCMWWrT9paWu+58hqLWYK
        BeT4BvV4LrCDclJaiVCpjNqloDVf7Yaooj0FbOSeQq/jYcfdbQfLo98KAgBObxacyNmk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2dig-0004bz-PJ; Tue, 27 Aug 2019 17:49:18 +0200
Date:   Tue, 27 Aug 2019 17:49:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: Re: [PATCH v1 net-next] net: phy: mdio_bus: make mdiobus_scan also
 cover PHY that only talks C45
Message-ID: <20190827154918.GO2168@lunn.ch>
References: <1566870769-9967-1-git-send-email-weifeng.voon@intel.com>
 <e9ece5ad-a669-6d6b-d050-c633cad15476@gmail.com>
 <20190826185418.GG2168@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC814758ED8@PGSMSX103.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D6759987A7968C4889FDA6FA91D5CBC814758ED8@PGSMSX103.gar.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 03:23:34PM +0000, Voon, Weifeng wrote:
> > > > Make mdiobus_scan() to try harder to look for any PHY that only
> > talks C45.
> > > If you are not using Device Tree or ACPI, and you are letting the MDIO
> > > bus be scanned, it sounds like there should be a way for you to
> > > provide a hint as to which addresses should be scanned (that's
> > > mii_bus::phy_mask) and possibly enhance that with a mask of possible
> > > C45 devices?
> > 
> > Yes, i don't like this unconditional c45 scanning. A lot of MDIO bus
> > drivers don't look for the MII_ADDR_C45. They are going to do a C22
> > transfer, and maybe not mask out the MII_ADDR_C45 from reg, causing an
> > invalid register write. Bad things can then happen.
> > 
> > With DT and ACPI, we have an explicit indication that C45 should be used,
> > so we know on this platform C45 is safe to use. We need something
> > similar when not using DT or ACPI.
> > 
> > 	  Andrew
> 
> Florian and Andrew,
> The mdio c22 is using the start-of-frame ST=01 while mdio c45 is using ST=00
> as identifier. So mdio c22 device will not response to mdio c45 protocol.
> As in IEEE 802.1ae-2002 Annex 45A.3 mention that:
> " Even though the Clause 45 MDIO frames using the ST=00 frame code
> will also be driven on to the Clause 22 MII Management interface,
> the Clause 22 PHYs will ignore the frames. "
> 
> Hence, I am not seeing any concern that the c45 scanning will mess up with 
> c22 devices.

Hi Voon

Take for example mdio-hisi-femac.c 

static int hisi_femac_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
{
        struct hisi_femac_mdio_data *data = bus->priv;
        int ret;

        ret = hisi_femac_mdio_wait_ready(data);
        if (ret)
                return ret;

        writel((mii_id << BIT_PHY_ADDR_OFFSET) | regnum,
               data->membase + MDIO_RWCTRL);


There is no check here for MII_ADDR_C45. So it will perform a C22
transfer. And regnum will still have MII_ADDR_C45 in it, so the
writel() is going to set bit 30, since #define MII_ADDR_C45
(1<<30). What happens on this hardware under these conditions?

You cannot unconditionally ask an MDIO driver to do a C45
transfer. Some drivers are going to do bad things.

	  Andrew

