Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396F53B4777
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 18:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbhFYQin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 12:38:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229630AbhFYQim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 12:38:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=T+2AZqZ/2b1WKu9bOF0NlpVpI3gvGrzpNuubkbB7csA=; b=rfl06C/1fRVC7umAQcMO/zyfMt
        JRgQ4p3iSfBEidWiJvjmq7mEzPgywhhOceNMNfCMF7v8ObeISZDO6f4nQLqY0rDWFIBKQQwZX5I9L
        feMPq1iMNKdTANKS9d0xc4WIsyXVoHAoPOPV4a5daIExejy2S5qimdxYyRye1GJTJu0A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwoo9-00B7fE-8y; Fri, 25 Jun 2021 18:35:57 +0200
Date:   Fri, 25 Jun 2021 18:35:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>
Cc:     "Ling, Pei Lee" <pei.lee.ling@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next V1 3/4] net: stmmac: Reconfigure the PHY WOL
 settings in stmmac_resume()
Message-ID: <YNYF7XCyCIuwT0mT@lunn.ch>
References: <20210621094536.387442-1-pei.lee.ling@intel.com>
 <20210621094536.387442-4-pei.lee.ling@intel.com>
 <YNCOqGCDgSOy/yTP@lunn.ch>
 <CH0PR11MB53806E2DC74B2B9BE8F84D7088089@CH0PR11MB5380.namprd11.prod.outlook.com>
 <YNONPZAfmdyBMoL5@lunn.ch>
 <CH0PR11MB538084AFEA548F4B453C624F88079@CH0PR11MB5380.namprd11.prod.outlook.com>
 <YNSLQpNsNhLkK8an@lunn.ch>
 <CH0PR11MB53806D16AF301F16A298C70C88069@CH0PR11MB5380.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH0PR11MB53806D16AF301F16A298C70C88069@CH0PR11MB5380.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I would like to rephase the commit message to make things clear:
> 
> After PHY received a magic packet, the PHY WOL event will be
> triggered. At the same time, the "Magic Packet Match Detected" bit
> is set. In order for the PHY WOL event to be triggered again, the 
> WOL event status of "Magic Packet Match Detected" bit needs to be 
> cleared. When the PHY is in polling mode, the WOL event status needs
> to be manually cleared.
> 
> Ethtool settings will remain with WOL enabled after a S3/S4
> suspend resume cycle as expected. Hence, the driver should
> reconfigure the PHY settings to reenable/disable WOL
> depending on the ethtool WOL settings in the MAC resume flow.
> The PHY set_wol flow would clear the WOL event status.

I would still argue that making use of a WoL interrupts and PHY
polling is just wrong. But i assume you cannot fix this? You have a
hardware design error?

The problem with this solution is you need to modify every MAC driver
using the Marvell PHY. It does not scale.

Please try to find a solution within phylib or the marvell
driver. Something which will work for any broken setup which is using
WoL interrupts combined with polling.

    Andrew
