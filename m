Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF8911D749
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbfLLTlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:41:44 -0500
Received: from mail.nic.cz ([217.31.204.67]:51952 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730284AbfLLTlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 14:41:44 -0500
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 35F52140E80;
        Thu, 12 Dec 2019 20:41:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1576179702; bh=wrwDoQlzefruckfME5Dmq1VFwgkWjLUcf3vEF7Nrhxc=;
        h=Date:From:To;
        b=A+hOHO9MznfoxezUB1fJWY73s4ILQBqfGX9nLw1w12LhKlR3fqQyr1+mJrSLKmFgh
         l078m9f2COciBJbDyz+btyViWlNYxz+JLoGYh8DeiqP3xo106mtDkV3D4/A7iUgyp6
         9KASMtC/XpxsrKc2AM6NbxaqqxVATT1Zpd1Mus7I=
Date:   Thu, 12 Dec 2019 20:41:41 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Baruch Siach <baruch@tkos.co.il>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191212204141.16a406cd@nic.cz>
In-Reply-To: <20191212193129.GF30053@lunn.ch>
References: <20191211131111.GK16369@lunn.ch>
        <87fthqu6y6.fsf@tarshish>
        <20191211174938.GB30053@lunn.ch>
        <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il>
        <20191212131448.GA9959@lunn.ch>
        <20191212150810.zx6o26jnk5croh4r@sapphire.tkos.co.il>
        <20191212151355.GE30053@lunn.ch>
        <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il>
        <20191212193611.63111051@nic.cz>
        <20191212190640.6vki2pjfacdnxihh@sapphire.tkos.co.il>
        <20191212193129.GF30053@lunn.ch>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT,
        URIBL_BLOCKED shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 20:31:29 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> > diff --git a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
> > index bd881497b872..8f61cae9d3b0 100644
> > --- a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
> > +++ b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
> > @@ -408,6 +408,11 @@ port@5 {
> >  				reg = <5>;
> >  				label = "cpu";
> >  				ethernet = <&cp1_eth2>;
> > +
> > +				fixed-link {
> > +					speed = <2500>;
> > +					full-duplex;
> > +				};
> >  			};
> >  		};  
> 
> The DSA driver is expected to configure the CPU port at its maximum
> speed. You should only add a fixed link if you need to slow it down.
> I expect 2500 is the maximum speed of this port.
> 
>   Andrew

Baruch, if the cpu port is in 2500 base-x, remove the fixed-link and do
this:

port@5 {
	reg = <5>;
	label = "cpu";
	ethernet = <&cp1_eth2>;
	phy-mode = "2500base-x";
	managed = "in-band-status";
};

Andrew, if the dsa driver is expected to do that, the code certainly
does not do so. For example in mv88e6xxx_port_set_cmode you have:
 /* Default to a slow mode, so freeing up SERDES interfaces for
  * other ports which might use them for SFPs.
  */
 if (mode == PHY_INTERFACE_MODE_NA)
         mode = PHY_INTERFACE_MODE_1000BASEX;

Marek
