Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4603F1F773A
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 13:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgFLLWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 07:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgFLLWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 07:22:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872E5C03E96F;
        Fri, 12 Jun 2020 04:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iQ3cJVOqFbwAFC9lqlAOVqpOP5T72nL9q2aV8aA74xo=; b=S4H44/r+VksRHlDi95QSfK1Lj
        4y7fH8APnwFRucZfDFfZ9yaS8FXx6dDuGOWt4msQ2f5FDheEtfksC4uTCYF7Xtq800R2yhuih6GMQ
        IfhAgPG0Mj3qvGtDCmRRARBZ7MFUDvq5eLS69eQQL27184Yorvdks7XEK96Eva1Ri52oLjdBbppmr
        c5ancELwZOt6jFiJIO/d1W79laOXy5//xkLqysAMt1b2KBRdkHscBQRuuCcPXIyPIEe1v2SLQcTlK
        T+I4eNDfw94q2og8eMAn0AFCQOzwMaSjKY69RK2QRGnQqhgXGOTqS0rkCac4NnioDZlDFq56OH6hh
        EM//YR0zA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:52656)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jjhlG-0002iS-Ax; Fri, 12 Jun 2020 12:22:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jjhlF-0006DP-Gf; Fri, 12 Jun 2020 12:22:13 +0100
Date:   Fri, 12 Jun 2020 12:22:13 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH v2] net: mvneta: Fix Serdes configuration for 2.5Gbps
 modes
Message-ID: <20200612112213.GH1551@shell.armlinux.org.uk>
References: <20200612083847.29942-1-s.hauer@pengutronix.de>
 <20200612084710.GC1551@shell.armlinux.org.uk>
 <20200612100114.GE1551@shell.armlinux.org.uk>
 <20200612101820.GF1551@shell.armlinux.org.uk>
 <20200612104208.GG1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612104208.GG1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 11:42:08AM +0100, Russell King - ARM Linux admin wrote:
> On Fri, Jun 12, 2020 at 11:18:20AM +0100, Russell King - ARM Linux admin wrote:
> > On Fri, Jun 12, 2020 at 11:01:15AM +0100, Russell King - ARM Linux admin wrote:
> > > On Fri, Jun 12, 2020 at 09:47:10AM +0100, Russell King - ARM Linux admin wrote:
> > > > On Fri, Jun 12, 2020 at 10:38:47AM +0200, Sascha Hauer wrote:
> > > > > The Marvell MVNETA Ethernet controller supports a 2.5Gbps SGMII mode
> > > > > called DRSGMII. Depending on the Port MAC Control Register0 PortType
> > > > > setting this seems to be either an overclocked SGMII mode or 2500BaseX.
> > > > > 
> > > > > This patch adds the necessary Serdes Configuration setting for the
> > > > > 2.5Gbps modes. There is no phy interface mode define for overclocked
> > > > > SGMII, so only 2500BaseX is handled for now.
> > > > > 
> > > > > As phy_interface_mode_is_8023z() returns true for both
> > > > > PHY_INTERFACE_MODE_1000BASEX and PHY_INTERFACE_MODE_2500BASEX we
> > > > > explicitly test for 1000BaseX instead of using
> > > > > phy_interface_mode_is_8023z() to differentiate the different
> > > > > possibilities.
> > > > > 
> > > > > Fixes: da58a931f248f ("net: mvneta: Add support for 2500Mbps SGMII")
> > > > > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > > > 
> > > > 2500base-X is used today on Armada 388 and Armada 3720 platforms and
> > > > works - it is known to interoperate with Marvell PP2.2 hardware, as
> > > > well was various SFPs such as the Huawei MA5671A at 2.5Gbps.  The way
> > > > it is handled on these platforms is via the COMPHY, requesting that
> > > > the serdes is upclocked from 1.25Gbps to 3.125Gbps.
> > > > 
> > > > This "DRSGMII" mode is not mentioned in the functional specs for either
> > > > the Armada 388 or Armada 3720, the value you poke into the register is
> > > > not mentioned either.  As I've already requested, some information on
> > > > exactly what this "DRSGMII" is would be very useful, it can't be
> > > > "double-rate SGMII" because that would give you 2Gbps instead of 1Gbps.
> > > > 
> > > > So, I suspect this breaks the platforms that are known to work.
> > > > 
> > > > We need a proper description of what DRSGMII is before we can consider
> > > > taking any patches for it.
> > > 
> > > Okay, having dug through the Armada XP, 370, 388, 3720 specs, I think
> > > this is fine after all - but something that will help for the future
> > > would be to document that this register does not exist on the 388 and
> > > 3720 devices (which brings up the question whether we should be writing
> > > it there.)  The field was moved into the comphy on those devices.
> > > 
> > > So, it looks like if we have a comphy, we should not be writing this
> > > register.
> > > 
> > > What's more, the write to MVNETA_SERDES_CFG should not be in
> > > mvneta_port_power_up(); it's likely that XP and 370 will not work
> > > properly with phylink.  It needs to be done in a similar location to
> > > mvneta_comphy_init(), so that phylink can switch between 1G and 2.5G
> > > speeds.
> > > 
> > > As you have an Armada XP system, you are best placed to test moving
> > > that write.
> > 
> > Here's my suggestion - it won't apply to mainline or net* trees, but
> > gives you the idea I'm proposing:
> > 
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > index 9e25d608d856..17db74d61bc2 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -107,9 +107,11 @@
> >  #define      MVNETA_TX_IN_PRGRS                  BIT(1)
> >  #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
> >  #define MVNETA_RX_MIN_FRAME_SIZE                 0x247c
> > +/* Only exists on Armada XP and Armada 370 */
> >  #define MVNETA_SERDES_CFG			 0x24A0
> > -#define      MVNETA_SGMII_SERDES_PROTO		 0x0cc7
> >  #define      MVNETA_QSGMII_SERDES_PROTO		 0x0667
> > +#define      MVNETA_SGMII_SERDES_PROTO		 0x0cc7
> > +#define      MVNETA_HSGMII_SERDES_PROTO		 0x1107
> >  #define MVNETA_TYPE_PRIO                         0x24bc
> >  #define      MVNETA_FORCE_UNI                    BIT(21)
> >  #define MVNETA_TXQ_CMD_1                         0x24e4
> > @@ -3457,9 +3459,6 @@ static int mvneta_comphy_init(struct mvneta_port *pp)
> >  {
> >  	int ret;
> >  
> > -	if (!pp->comphy)
> > -		return 0;
> > -
> >  	ret = phy_set_mode_ext(pp->comphy, PHY_MODE_ETHERNET,
> >  			       pp->phy_interface);
> >  	if (ret)
> > @@ -3468,11 +3467,47 @@ static int mvneta_comphy_init(struct mvneta_port *pp)
> >  	return phy_power_on(pp->comphy);
> >  }
> >  
> > +static int mvneta_config_interface(struct mvneta_port *pp,i
> > +				   phy_interface_t interface)
> > +{
> > +	int ret = 0;
> > +
> > +	if (pp->comphy) {
> > +		if (interface == PHY_INTERFACE_MODE_SGMII ||
> > +		    interface == PHY_INTERFACE_MODE_1000BASEX ||
> > +		    interface == PHY_INTERFACE_MODE_2500BASEX) {
> > +			ret = mvneta_comphy_init(pp);
> > +		}
> > +	} else {
> > +		switch (interface) {
> > +		case PHY_INTERFACE_MODE_QSGMII:
> > +			mvreg_write(pp, MVNETA_SERDES_CFG,
> > +				    MVNETA_QSGMII_SERDES_PROTO);
> > +			break;
> > +
> > +		case PHY_INTERFACE_MODE_SGMII:
> > +		case PHY_INTERFACE_MODE_1000BASEX:
> > +			mvreg_write(pp, MVNETA_SERDES_CFG,
> > +				    MVNETA_SGMII_SERDES_PROTO);
> > +			break;
> > +
> > +		case PHY_INTERFACE_MODE_2500BASEX:
> > +			mvreg_write(pp, MVNETA_SERDES_CFG,
> > +				    MVNETA_HSGMII_SERDES_PROTO);
> > +			break;
> > +		}
> > +	}
> > +
> > +	pp->phy_interface = interface;
> > +
> > +	return ret;
> > +}
> > +
> >  static void mvneta_start_dev(struct mvneta_port *pp)
> >  {
> >  	int cpu;
> >  
> > -	WARN_ON(mvneta_comphy_init(pp));
> > +	WARN_ON(mvneta_config_interface(pp, pp->phy_interface));
> >  
> >  	mvgmac_set_max_rx_size(&pp->gmac, pp->pkt_size);
> >  	mvneta_txq_max_tx_size_set(pp, pp->pkt_size);
> > @@ -3702,14 +3737,9 @@ static int mvneta_pcs_config(struct phylink_config *config,
> >  	/* We should never see Asym_Pause set */
> >  	WARN_ON(phylink_test(advertising, Asym_Pause));
> >  
> > -	if (pp->comphy && pp->phy_interface != interface &&
> > -	    (interface == PHY_INTERFACE_MODE_SGMII ||
> > -	     interface == PHY_INTERFACE_MODE_1000BASEX ||
> > -	     interface == PHY_INTERFACE_MODE_2500BASEX)) {
> > -		pp->phy_interface = interface;
> > -
> > +	if (pp->phy_interface != interface) {
> >  		WARN_ON(phy_power_off(pp->comphy));
> > -		WARN_ON(mvneta_comphy_init(pp));
> > +		mvneta_config_interface(pp, interface);
> >  	}
> >  
> >  	if (want_1ms_clock) {
> > @@ -4794,12 +4824,10 @@ static int mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
> >  	/* MAC Cause register should be cleared */
> >  	mvreg_write(pp, MVNETA_UNIT_INTR_CAUSE, 0);
> >  
> > -	if (phy_mode == PHY_INTERFACE_MODE_QSGMII)
> > -		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_QSGMII_SERDES_PROTO);
> > -	else if (phy_mode == PHY_INTERFACE_MODE_SGMII ||
> > -		 phy_interface_mode_is_8023z(phy_mode))
> > -		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_SGMII_SERDES_PROTO);
> > -	else if (!phy_interface_mode_is_rgmii(phy_mode))
> > +	if (phy_mode != PHY_INTERFACE_MODE_QSGMII &&
> > +	    phy_mode != PHY_INTERFACE_MODE_SGMII &&
> > +	    !phy_interface_mode_is_8023z(phy_mode) &&
> > +	    !phy_interface_mode_is_rgmii(phy_mode))
> >  		return -EINVAL;
> >  
> >  	return 0;
> 
> With the obvious mistakes fixed (extraneous 'i' and lack of default
> case), it seems to still work on Armada 388 Clearfog Pro with 2.5G
> modules.

... and the other bug fixed - mvneta_comphy_init() needs to be passed
the interface mode.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
