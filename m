Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE3FB1BF34
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 23:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfEMVng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 17:43:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34587 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbfEMVng (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 17:43:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=z1/mEU0BH5C5OCDEDKNzem043jlI3NyAKsW8ae1HheE=; b=C3RtlCdpQwV99rSBCvKtGGYmLE
        EPv1I9hwqL0Os246k//uL4GN4zRurs76jrxSLngxsnUQ5L2kqdL2pPByzxlIA1Rzhr3m1xss5Toqh
        gOmbbuO5WWQyMWH2bZfTGL7KEkpSWLPXGhtkphHZPokBuoltVKkj2gUwkxatRxeKABts=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hQIjM-0004HU-UG; Mon, 13 May 2019 23:43:32 +0200
Date:   Mon, 13 May 2019 23:43:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Trent Piepho <tpiepho@impinj.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 5/5] net: phy: dp83867: Use unsigned variables to store
 unsigned properties
Message-ID: <20190513214332.GB12345@lunn.ch>
References: <20190510214550.18657-1-tpiepho@impinj.com>
 <20190510214550.18657-5-tpiepho@impinj.com>
 <49c6afc4-6c5b-51c9-74ab-9a6e8c2460a5@gmail.com>
 <3a42c0cc-4a4b-e168-c03e-1cc13bd2f5d4@gmail.com>
 <1557777496.4229.13.camel@impinj.com>
 <b246b18d-5523-7b8b-9cd0-b8ccb8a511e9@gmail.com>
 <20190513204641.GA12345@lunn.ch>
 <1557782787.4229.36.camel@impinj.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557782787.4229.36.camel@impinj.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Trent
> > 
> > I already deleted the patches. For patch 3:
> > 
> > + 	  if (dp83867->clk_output_sel > DP83867_CLK_O_SEL_REF_CLK &&
> > +	         dp83867->clk_output_sel != DP83867_CLK_O_SEL_OFF) {
> > +		 	phydev_err(phydev, "ti,clk-output-sel value %u out of range\n",
> > +				   dp83867->clk_output_sel);
> > +			return -EINVAL;
> > +		      }
> > 
> > This last bit looks odd. If it is not OFF, it is invalid?
> 
> The valid values are in the range 0 to DP83867_CLK_O_SEL_REF_CLK and
> also DP83867_CLK_O_SEL_OFF.  Thus invalid values are those greater than
> DP83867_CLK_O_SEL_REF_CLK which are not DP83867_CLK_O_SEL_OFF.

Hi Trent
 
O.K.

> > Are there any in tree users of DP83867_CLK_O_SEL_REF_CLK? We have to
> > be careful changing its meaning. But if nobody is actually using it...
> 
> Nope.  I doubt this will affect anyone.  They'd need to strap the phy
> to get a different configuration, and the explicitly add a property,
> which isn't in the example DTS files, to change the configuration to
> something they didn't want, and then depend on a driver bug ignoring
> the erroneous setting they added.

O.K, then this patch is O.K. Does the binding documentation need
updating?
 
> > Patch 4:
> > 
> > This is harder. Ideally we want to fix this. At some point, somebody
> > is going to want 'rgmii' to actually mean 'rgmii', because that is
> > what their hardware needs.
> > 
> > Could you add a WARN_ON() for 'rgmii' but the PHY is actually adding a
> > delay? And add a comment about setting the correct thing in device
> > tree?  Hopefully we will then get patches correcting DT blobs. And if
> > we later do need to fix 'rgmii', we will break less board.
> 
> Yes I can do this.  Should it warn on any use of "rgmii"?

No, i would only warn when there is a delay configured by
strapping. If you want the PHY to be left alone, you should use
PHY_INTERFACE_MODE_NA, which should be the default if there is no
phy-mode property. If DT actually asked for "rgmii", it either means
it is wrong and rgmii-id should be used to match the strapping, or
both the strapping and the DT is wrong and somebody really does want
"rgmii".

> If so, how would someone make the warning go away if they actually
> want rgmii mode with no delay?

We take the warning out, and implement "rgmii" correctly, and let
boards break which have broken DT. We have done this before, but
without a period of time with a warning.

> I suspect hsdk.dts is an example of an in-tree broken board that uses
> "rgmii" would it should have used "rgmii-id".

O.K, so when you submit the patch Cc: Alexey Brodkin <abrodkin@synopsys.com>

     Andrew
