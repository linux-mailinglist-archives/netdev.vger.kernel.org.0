Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D77FD965B2
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbfHTP5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:57:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45604 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbfHTP5z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 11:57:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a9C3b3G3nm77mUWP6d7nqP+nWBkTPiCKFDND/m1Vhew=; b=iKGQRF0yz5km72zavzs00QyYnf
        lJsAdyZOq5BJbu5UuS6NhRVnE2fIo9APYpeA7sO+5iEB9+zA0YrPOnMNoMCDc4cD5fFM5BCzDD1YA
        VWOUrz4/RXrtkyTeKqTMKHYX7//kPzVuXjFxB4CWDFGZmJ35INddfeS33W3i5sSyYPK0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i06W0-0006rc-Py; Tue, 20 Aug 2019 17:57:44 +0200
Date:   Tue, 20 Aug 2019 17:57:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/6] net: stmmac: sun8i: Use devm_regulator_get for PHY
 regulator
Message-ID: <20190820155744.GN29991@lunn.ch>
References: <20190820145343.29108-1-megous@megous.com>
 <20190820145343.29108-4-megous@megous.com>
 <20190820153939.GL29991@lunn.ch>
 <20190820154714.2rt4ctovil5ol3u2@core.my.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190820154714.2rt4ctovil5ol3u2@core.my.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 05:47:14PM +0200, Ondřej Jirman wrote:
> Hi Andrew,
> 
> On Tue, Aug 20, 2019 at 05:39:39PM +0200, Andrew Lunn wrote:
> > On Tue, Aug 20, 2019 at 04:53:40PM +0200, megous@megous.com wrote:
> > > From: Ondrej Jirman <megous@megous.com>
> > > 
> > > Use devm_regulator_get instead of devm_regulator_get_optional and rely
> > > on dummy supply. This avoids NULL checks before regulator_enable/disable
> > > calls.
> > 
> > Hi Ondrej
> > 
> > What do you mean by a dummy supply? I'm just trying to make sure you
> > are not breaking backwards compatibility.
> 
> Sorry, I mean dummy regulator. See:
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/regulator/core.c#L1874
> 
> On systems that use DT (i.e. have_full_constraints() == true), when the
> regulator is not found (ENODEV, not specified in DT), regulator_get will return
> a fake dummy regulator that can be enabled/disabled, but doesn't do anything
> real.

Hi Ondrej

But we also gain a new warning:

	dev_warn(dev,
		 "%s supply %s not found, using dummy regulator\n",
	         devname, id);

This regulator is clearly optional, so there should not be a warning.

Maybe you can add a new get_type, OPTIONAL_GET, which does not issue
the warning, but does give back a dummy regulator.

Thanks
	Andrew
