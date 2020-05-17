Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221D91D6CF7
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 22:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgEQUvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 16:51:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36370 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726288AbgEQUvy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 16:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/0SvLX7oK3owCdvk34cjvDNN4alN13DkBRL7TfNcy2g=; b=tPYVbWUNgKcGPB1++fpqbiaNhe
        6bJPlhm+eBselnbe47oi/0UGs0XIxb1TjQyyEyLOYW9bNeoKT3QtqT7lvKj1Arwe/5EjZP1FOs+Pv
        Y5LNAxHy3oHF5yaJ6xR50C+ZMDtEolYS5GRymbXi60by7KbRkCLFawwSNDUapeCKuD48=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jaQGE-002Z1J-KT; Sun, 17 May 2020 22:51:50 +0200
Date:   Sun, 17 May 2020 22:51:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Healy <cphealy@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next 4/7] net: phy: marvell: Add support for
 amplitude graph
Message-ID: <20200517205150.GB610998@lunn.ch>
References: <20200517195851.610435-1-andrew@lunn.ch>
 <20200517195851.610435-5-andrew@lunn.ch>
 <CAFXsbZohCG5OScjAszD5vpMacfUEUYK_74FU1tjz4Sm8nbegsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFXsbZohCG5OScjAszD5vpMacfUEUYK_74FU1tjz4Sm8nbegsg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int marvell_vct5_amplitude_distance(struct phy_device *phydev,
> > +                                          int meters)
> > +{
> > +       int mV_pair0, mV_pair1, mV_pair2, mV_pair3;
> > +       int distance;
> > +       u16 reg;
> > +       int err;
> > +
> > +       distance = meters * 1000 / 805;
> 
> With this integer based meters representation, it seems to me that we
> are artificially reducing the resolution of the distance sampling.
> For a 100 meter cable, the Marvell implementation looks to support 124
> sample points.  This could result in incorrect data reporting as two
> adjacent meter numbers would resolve to the same disatance value
> entered into the register.  (eg - 2 meters = 2 distance  3 meters = 2
> distance)
> 
> Is there a better way of doing this which would allow for userspace to
> use the full resolution of the hardware?

Hi Chris

I don't see a simple solution to this.

PHYs/vendors seem to disagree about the ratio. Atheros use
824. Marvell use 805. I've no idea what Broadcom, aQuantia uses. We
would need to limit the choice of step to multiples of whatever the
vendor picks as its ratio. If the user picks a step of 2m, the driver
needs to return an error and say sorry, please try 2.488 meter steps
for Marvell, 2.427 meter steps on Atheros, and who knows what for
Broadcom. And when the user requests data just for 1-25 meters, the
driver needs to say sorry, try again with 0.824-24.62, or maybe
0.805-24.955. That is not a nice user experience.

It is easy for you to disable this conversion. Do you see a noticeable
difference in the quality of the results?

	   Andrew
