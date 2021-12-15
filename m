Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7398475F8A
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 18:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbhLORmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 12:42:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235588AbhLORmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 12:42:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=DgrLy+KtAFDV9SDMDgPi2/0xvVpvtmBTCawykk8PnBE=; b=PMEIRcemeofchF8WP0BuNmcQLj
        TV1bwaGhtAUscl6/WIxp3Rbq+P7/yqVO7xIx2Bw0j2TxScGG56gD8U8dtIXb9lX+9nvHtbb5lp1Yv
        gQjKx5IlBtmPA/y/b5ZdBPltVbbj4aPxYho48BPJLQ1Or2r4jHgjpTUjJm1n5FvY4Ea0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxYI8-00GfjM-CC; Wed, 15 Dec 2021 18:42:12 +0100
Date:   Wed, 15 Dec 2021 18:42:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alex Elder <elder@linaro.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>
Subject: Re: Port mirroring (RFC)
Message-ID: <Yboo9PtNslU+Y4te@lunn.ch>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <YbjiCNRffWYEcWDt@lunn.ch>
 <3bd97657-7a33-71ce-b33a-e4eb02ee7e20@linaro.org>
 <YbmzAkE+5v7Mv89D@lunn.ch>
 <b00fb6e2-c923-39e9-f326-6ec485fcff21@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b00fb6e2-c923-39e9-f326-6ec485fcff21@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Do you have netdevs for the modem, the wifi, and whatever other
> > interfaces the hardware might have?
> 
> Not yet, but yes I expect that's how it will work.
> 
> > To setup a mirror you would do something like:
> > 
> > sudo tc filter add dev eth0 parent ffff: protocol all u32 match u32 0 0 action mirred egress mirror dev tun0
> 
> OK so it sounds like the term "mirror" means mirroring using
> Linux filtering.  And then I suppose "monitoring" is collecting
> all "observed" traffic through an interface?

Yes, that seems like a good description of the difference. 
 
> If that's the case, this seems to me more like monitoring, except
> I suggested presenting the replicated data through a separate
> netdev (rather than, for example, through the one for the modem).

The wifi model allows you to dynamical add netdev on top of a physical
wireless LAN chipset. So you can have one netdev running as an access
point, and a second netdev running as a client, both sharing the
underlying hardware. And you should be able to add another netdev and
put it into monitor mode. So having a dedicated netdev for your
monitoring is not too far away from what you do with wifi.

> If it makes more sense, I could probably inject the replicated
> packets received through this special interface into one or
> another of the existing netdevs, rather than using a separate
> one for this purpose.

> > Do you have control over selecting egress and ingress packets to be
> > mirrored?
> 
> That I'm not sure about.  If it's possible, it would be controlling
> which originators have their traffic replicated.

You need this if you want to do mirroring, since the API requires to
say if you want to mirror ingress or egress. WiFi monitoring is less
specific as far as i understand. It is whatever is received on the
antenna.

> I don't think it will take me all that long to implement this, but
> my goal right now is to be sure that the design I implement is a good
> solution.  I'm open to recommendations.

You probably want to look at what wifi monitor offers. And maybe check
with the WiFi people what they actually think about monitoring, or if
they have a better suggestion.

     Andrew
