Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21A43542E0
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 16:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237711AbhDEOfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 10:35:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34056 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235915AbhDEOfh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 10:35:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTQJp-00EwLg-1z; Mon, 05 Apr 2021 16:35:09 +0200
Date:   Mon, 5 Apr 2021 16:35:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2 0/2] Enable 2.5Gbps speed for stmmac
Message-ID: <YGsgHWItHcLFV9Kg@lunn.ch>
References: <20210405112953.26008-1-michael.wei.hong.sit@intel.com>
 <YGsMbBW9h4H1y/T8@lunn.ch>
 <CO1PR11MB5044B1F80C412E6F0CAFD5509D779@CO1PR11MB5044.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB5044B1F80C412E6F0CAFD5509D779@CO1PR11MB5044.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > You have a MAC and an PCS in the stmmac IP block. That then has
> > some
> > sort of SERDES interface, running 1000BaseX, SGMII, SGMII
> > overclocked
> > at 2.5G or 25000BaseX. Connected to the SERDES you have a PHY
> > which
> > converts to copper, giving you 2500BaseT.
> > 
> > You said earlier, that the PHY can only do 2500BaseT. So it should
> > be
> > the PHY driver which sets supported to 2500BaseT and no other
> > speeds.
> > 
> > You should think about when somebody uses this MAC with a
> > different
> > PHY, one that can do the full range of 10/half through to 2.5G
> > full. What generally happens is that the PHY performs auto-neg to
> > determine the link speed. For 10M-1G speeds the PHY will
> > configure its
> > SERDES interface to SGMII and phylink will ask the PCS to also be
> > configured to SGMII. If the PHY negotiates 2500BaseT, it will
> > configure its side of the SERDES to 2500BaseX or SGMII
> > overclocked at
> > 2.5G. Again, phylink will ask the PCS to match what the PHY is
> > doing.
> > 
> > So, where exactly is the limitation in your hardware? PCS or PHY?
> The limitation in the hardware is at the PCS side where it is either running
> in SGMII 2.5G or SGMII 1G speeds.
> When running on SGMII 2.5G speeds, we disable the in-band AN and use 2.5G speed only

So there is no actual limitation! The MAC should indicate it can do
10Half through to 2500BaseT. And you need to listen to PHYLINK and
swap the PCS between SGMII to overclocked SGMII when it requests.

PHYLINK will call stmmac_mac_config() and use state->interface to
decide how to configure the PCS to match what the PHY is doing.

     Andrew
