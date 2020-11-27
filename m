Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2FE2C6CD7
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 22:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbgK0VPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 16:15:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728726AbgK0VNw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 16:13:52 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0597122210;
        Fri, 27 Nov 2020 21:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606511627;
        bh=bupFm8Uy4aFKsEcnqyBwy4HCLbRmC5x2dr8E5v631O0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vneZD1les0V0RUVNHIBGDyxZ+cNWDb6B/YGqjdPved+OGv762iRgW2vym/9aHxwni
         OkTqW1UXZOkplPlvN1CKf9E84AFdxFhH8+EDriqSDp0MKPAfzYgmfrIrcD8mw4SN2/
         xVkV6LuIqDYMTMEthf3HspILL74AIITa12TdB6fc=
Date:   Fri, 27 Nov 2020 13:13:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127131346.3d594c8e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127204714.GX2073444@lunn.ch>
References: <20201125193740.36825-1-george.mccollister@gmail.com>
        <20201125193740.36825-3-george.mccollister@gmail.com>
        <20201125174214.0c9dd5a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
        <20201126132418.zigx6c2iuc4kmlvy@skbuf>
        <20201126175607.bqmpwbdqbsahtjn2@skbuf>
        <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
        <20201126220500.av3clcxbbvogvde5@skbuf>
        <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201127204714.GX2073444@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 21:47:14 +0100 Andrew Lunn wrote:
> > Is the periodic refresh really that awful? We're mostly talking error
> > counters here so every second or every few seconds should be perfectly
> > fine.  
> 
> Humm, i would prefer error counts to be more correct than anything
> else. When debugging issues, you generally don't care how many packets
> worked. It is how many failed you are interesting, and how that number
> of failures increases.

Right, but not sure I'd use the word "correct". Perhaps "immediately up
to date"?

High speed NICs usually go through a layer of firmware before they
access the stats, IOW even if we always synchronously ask for the stats
in the kernel - in practice a lot of NICs (most?) will return some form
of cached information.

> So long as these counters are still in ethtool -S, i guess it does not
> matter. That i do trust to be accurate, and probably consistent across
> the counters it returns.

Not in the NIC designs I'm familiar with.

But anyway - this only matters in some strict testing harness, right?
Normal users will look at a stats after they noticed issues (so minutes
/ hours later) or at the very best they'll look at a graph, which will
hardly require <1sec accuracy to when error occurred.
