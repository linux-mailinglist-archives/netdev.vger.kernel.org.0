Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFDE3B2463
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 03:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFXBI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 21:08:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52698 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhFXBI0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 21:08:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4C8upAdlHdRQK9JoaWR39CXvfzPqZO8dKujhFIlIsbg=; b=O2NzqLPKpvD+WLf/nyEWRrFcjV
        Nfl1W2HK9ATqjU1/CpOEixHpCykTsVhqRdhNUgnFAZ9FC676fafqymT3xFSHahRehH3JNu5HMBjQL
        enONyrazeAu0uWTWQ7Myzf0QEsEORoFA/qq66rqnt4pZzt2xk/xYI9FfF62/eazy9KcY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwDoe-00Aupq-O9; Thu, 24 Jun 2021 03:06:00 +0200
Date:   Thu, 24 Jun 2021 03:06:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Liang Xu <lxu@maxlinear.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YNPaeI+I3d2XnV6U@lunn.ch>
References: <20210604161250.49749-1-lxu@maxlinear.com>
 <20210604194428.2276092-1-martin.blumenstingl@googlemail.com>
 <b01a8ac2-b77e-32aa-7c9b-57de4f2d3a95@maxlinear.com>
 <YLuzX5EYfGNaosHT@lunn.ch>
 <9ecb75b8-c4d8-1769-58f4-1082b8f53e05@maxlinear.com>
 <CAFBinCARo+YiQezBQfZ=M6HNwvkro0nK=0Y9KhhhRO+akiaHbw@mail.gmail.com>
 <MWHPR19MB0077D01E4EAFA9FE521D83ECBD0D9@MWHPR19MB0077.namprd19.prod.outlook.com>
 <766ab274-25ff-c9a2-1ed6-fe2aa44b4660@maxlinear.com>
 <CAFBinCBCPcCD3uxO5iJF11LBhdMe32nzMLvnD1xyLvpT2HZt_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCBCPcCD3uxO5iJF11LBhdMe32nzMLvnD1xyLvpT2HZt_Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 11:09:23PM +0200, Martin Blumenstingl wrote:
> Hi Liang,
> 
> On Wed, Jun 23, 2021 at 12:56 PM Liang Xu <lxu@maxlinear.com> wrote:
> [...]
> > Hi Martin,
> >
> > 1) The legacy PHY GPY111 does not share the same register format and address for WoL and LED registers. Therefore code saving with a common driver is not possible.
> > 2) The interrupt handling routine would be different when new features are added in driver, such as PTP offload, MACsec offload. These will be added step by step as enhancement patches afte initial version of this driver upstreamed.
> I think that would leave only few shared registers with the older PHYs
> (and thus the intel-xway driver). Due to the lack of a public
> datasheet however I have no way to confirm this.
> So with this information added to the patch description having a
> different driver is fine for me
> 
> Maybe Andrew can also share his opinion - based on this new
> information - as he previously also suggested to extend the intel-xway
> driver instead of creating a new one

If the potential sharing is minimal, then a new driver makes sense. So
please do expand the patch description with a good justification.

> > 3) The new PHY generation comes with a reasonable pre-configuration for the LED registers which does not need any modification usually.
> >    In case a customer needs a specific configuration (e.g. traffic pulsing only, no link status) he needs to configure this via MDIO. There is also another option for a fixed preconfiguration with the support of an external flash. However, this is out of scope of the driver.
> older PHYs also do this, but not all boards use a reasonable LED setup
> 
> > 4) Many old products are mostly used on embedded devices which do not support WoL. Therefore there was no request yet to supported by the legacy XWAY driver.
> my understanding of Andrew's argument is: "if the register layout is
> the same for old and new PHY then why would we do some extra effort to
> not add WoL support for the old PHYs"
> Based on your information above the register layout is different, so
> that means two different implementations are needed anyways.

It would be nice to add WoL support for the older devices. They might
not be maxlinears latest and greatest, but there could be more of them
actually in use at the moment than this new PHY.

	 Andrew
