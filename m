Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0CF125D50
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 10:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfLSJKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 04:10:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:32946 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfLSJKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 04:10:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hYoBaVE930HGaJi9sF95ko1l6qD4l0xLfHTfEv5mINc=; b=s1cQKRFPA9JIXHP0uNqaSOTIqg
        7Rv49IYLbZJfuN69AdbI+tNCRpjJIG3FH62+GhANieE85gpavAL5MLklbMwoj+PNy3QPmutWdliF1
        7tiDMKJNgqp3JflO5G6a+hinpdl5GUOO4n4EacexZiS+Io7m6Z6zbBAoJvFdL8mSgxfA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ihrpB-0005B1-MJ; Thu, 19 Dec 2019 10:10:25 +0100
Date:   Thu, 19 Dec 2019 10:10:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        jakub.kicinski@netronome.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org,
        alexandre.belloni@bootlin.com, horatiu.vultur@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 1/8] mii: Add helpers for parsing SGMII
 auto-negotiation
Message-ID: <20191219091025.GB17475@lunn.ch>
References: <20191217221831.10923-1-olteanv@gmail.com>
 <20191217221831.10923-2-olteanv@gmail.com>
 <20191218185058.GW25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218185058.GW25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > diff --git a/include/uapi/linux/mii.h b/include/uapi/linux/mii.h
> > index 51b48e4be1f2..dc3b5d635beb 100644
> > --- a/include/uapi/linux/mii.h
> > +++ b/include/uapi/linux/mii.h
> > @@ -71,6 +71,7 @@
> >  /* Advertisement control register. */
> >  #define ADVERTISE_SLCT		0x001f	/* Selector bits               */
> >  #define ADVERTISE_CSMA		0x0001	/* Only selector supported     */
> > +#define ADVERTISE_SGMII		0x0001	/* Can do SGMII                */
> >  #define ADVERTISE_10HALF	0x0020	/* Try for 10mbps half-duplex  */
> >  #define ADVERTISE_1000XFULL	0x0020	/* Try for 1000BASE-X full-duplex */
> >  #define ADVERTISE_10FULL	0x0040	/* Try for 10mbps full-duplex  */
> > @@ -94,6 +95,7 @@
> >  
> >  /* Link partner ability register. */
> >  #define LPA_SLCT		0x001f	/* Same as advertise selector  */
> > +#define LPA_SGMII		0x0001	/* Can do SGMII                */
> >  #define LPA_10HALF		0x0020	/* Can do 10mbps half-duplex   */
> >  #define LPA_1000XFULL		0x0020	/* Can do 1000BASE-X full-duplex */
> >  #define LPA_10FULL		0x0040	/* Can do 10mbps full-duplex   */
> > @@ -104,11 +106,19 @@
> >  #define LPA_1000XPAUSE_ASYM	0x0100	/* Can do 1000BASE-X pause asym*/
> >  #define LPA_100BASE4		0x0200	/* Can do 100mbps 4k packets   */
> >  #define LPA_PAUSE_CAP		0x0400	/* Can pause                   */
> > +#define LPA_SGMII_DPX_SPD_MASK	0x1C00	/* SGMII duplex and speed bits */
> > +#define LPA_SGMII_10HALF	0x0000	/* Can do SGMII 10mbps half-duplex */
> > +#define LPA_SGMII_10FULL	0x1000	/* Can do SGMII 10mbps full-duplex */
> > +#define LPA_SGMII_100HALF	0x0400	/* Can do SGMII 100mbps half-duplex */
> > +#define LPA_SGMII_100FULL	0x1400	/* Can do SGMII 100mbps full-duplex */
> >  #define LPA_PAUSE_ASYM		0x0800	/* Can pause asymetrically     */
> > +#define LPA_SGMII_1000HALF	0x0800	/* Can do SGMII 1000mbps half-duplex */
> > +#define LPA_SGMII_1000FULL	0x1800	/* Can do SGMII 1000mbps full-duplex */
> >  #define LPA_RESV		0x1000	/* Unused...                   */
> >  #define LPA_RFAULT		0x2000	/* Link partner faulted        */
> >  #define LPA_LPACK		0x4000	/* Link partner acked us       */
> >  #define LPA_NPAGE		0x8000	/* Next page bit               */
> > +#define LPA_SGMII_LINK		0x8000	/* Link partner has link       */
> 
> I wonder whether mixing these definitions together is really such a
> good idea, or whether separately grouping them would be better.

I think i prefer a seperate grouping.

  Andrew
