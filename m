Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0187E35423F
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 15:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240967AbhDENL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 09:11:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33942 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235568AbhDENL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 09:11:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTP0W-00EvY7-HE; Mon, 05 Apr 2021 15:11:08 +0200
Date:   Mon, 5 Apr 2021 15:11:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        qiangqing.zhang@nxp.com, vee.khee.wong@intel.com,
        fugang.duan@nxp.com, kim.tatt.chuah@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com
Subject: Re: [PATCH net-next v2 0/2] Enable 2.5Gbps speed for stmmac
Message-ID: <YGsMbBW9h4H1y/T8@lunn.ch>
References: <20210405112953.26008-1-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405112953.26008-1-michael.wei.hong.sit@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 07:29:51PM +0800, Michael Sit Wei Hong wrote:
> This patchset enables 2.5Gbps speed mode for stmmac.
> Link speed mode is detected and configured at serdes power up sequence.
> For 2.5G, we do not use SGMII in-band AN, we check the link speed mode
> in the serdes and disable the in-band AN accordingly.
> 
> Changes:
> v1 -> v2
>  patch 1/2
>  -Remove MAC supported link speed masking
> 
>  patch 2/2
>  -Add supported link speed masking in the PCS

So there still some confusion here.

------------            --------
|MAC - PCS |---serdes---| PHY  |--- copper 
------------            --------


You have a MAC and an PCS in the stmmac IP block. That then has some
sort of SERDES interface, running 1000BaseX, SGMII, SGMII overclocked
at 2.5G or 25000BaseX. Connected to the SERDES you have a PHY which
converts to copper, giving you 2500BaseT.

You said earlier, that the PHY can only do 2500BaseT. So it should be
the PHY driver which sets supported to 2500BaseT and no other speeds.

You should think about when somebody uses this MAC with a different
PHY, one that can do the full range of 10/half through to 2.5G
full. What generally happens is that the PHY performs auto-neg to
determine the link speed. For 10M-1G speeds the PHY will configure its
SERDES interface to SGMII and phylink will ask the PCS to also be
configured to SGMII. If the PHY negotiates 2500BaseT, it will
configure its side of the SERDES to 2500BaseX or SGMII overclocked at
2.5G. Again, phylink will ask the PCS to match what the PHY is doing.

So, where exactly is the limitation in your hardware? PCS or PHY?

     Andrew
