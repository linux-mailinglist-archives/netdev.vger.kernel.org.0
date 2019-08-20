Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E1C96621
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 18:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbfHTQUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 12:20:30 -0400
Received: from vps.xff.cz ([195.181.215.36]:35352 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbfHTQUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 12:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1566318027; bh=Ur31+ewkQP7gvbR5TMeGYZky/kMp62NibJGT1/dfqKM=;
        h=Date:From:To:Cc:Subject:References:X-My-GPG-KeyId:From;
        b=tvP41V/NpdED1yBnNgPzOZVg4qYsZcKimpIlQTgnpQzjxMVWbq9EcgYLJwdSCNp3R
         G2IRR2dUZG4NS44OINYR/oi3IypT/0iBxlISdDmcj28OTZIRbOmsPaccwz/39979EX
         jAjJK5Me4SuNhwsSo9OvUspxepr4iBchNOmp2WlM=
Date:   Tue, 20 Aug 2019 18:20:27 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Message-ID: <20190820162027.7erc2rlvoqasfjk7@core.my.home>
Mail-Followup-To: Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
References: <20190820145343.29108-1-megous@megous.com>
 <20190820145343.29108-4-megous@megous.com>
 <20190820153939.GL29991@lunn.ch>
 <20190820154714.2rt4ctovil5ol3u2@core.my.home>
 <20190820155744.GN29991@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190820155744.GN29991@lunn.ch>
X-My-GPG-KeyId: EBFBDDE11FB918D44D1F56C1F9F0A873BE9777ED
 <https://xff.cz/key.txt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Aug 20, 2019 at 05:57:44PM +0200, Andrew Lunn wrote:
> On Tue, Aug 20, 2019 at 05:47:14PM +0200, Ondřej Jirman wrote:
> > Hi Andrew,
> > 
> > On Tue, Aug 20, 2019 at 05:39:39PM +0200, Andrew Lunn wrote:
> > > On Tue, Aug 20, 2019 at 04:53:40PM +0200, megous@megous.com wrote:
> > > > From: Ondrej Jirman <megous@megous.com>
> > > > 
> > > > Use devm_regulator_get instead of devm_regulator_get_optional and rely
> > > > on dummy supply. This avoids NULL checks before regulator_enable/disable
> > > > calls.
> > > 
> > > Hi Ondrej
> > > 
> > > What do you mean by a dummy supply? I'm just trying to make sure you
> > > are not breaking backwards compatibility.
> > 
> > Sorry, I mean dummy regulator. See:
> > 
> > https://elixir.bootlin.com/linux/latest/source/drivers/regulator/core.c#L1874
> > 
> > On systems that use DT (i.e. have_full_constraints() == true), when the
> > regulator is not found (ENODEV, not specified in DT), regulator_get will return
> > a fake dummy regulator that can be enabled/disabled, but doesn't do anything
> > real.
> 
> Hi Ondrej
> 
> But we also gain a new warning:
> 
> 	dev_warn(dev,
> 		 "%s supply %s not found, using dummy regulator\n",
> 	         devname, id);
> 
> This regulator is clearly optional, so there should not be a warning.
> 
> Maybe you can add a new get_type, OPTIONAL_GET, which does not issue
> the warning, but does give back a dummy regulator.

We already had a info message. See my other e-mail with the dmesg output.

IMO, that warning is useful during development, and more informative than the
previous one.

regards,
	o.

> Thanks
> 	Andrew
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
