Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762883D2A6B
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 19:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbhGVQL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 12:11:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40856 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234911AbhGVQKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 12:10:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MHOn0Jhpt6FinLn9RmDt/2oCyA5BNFu7YbvgcTDwJII=; b=Q4uJIzIqNIywEWQa0v5kDvtQom
        Tf9pGPlR4PU/0eBAjLP6ZmY8f+JwT5DuH6zJZ/hCsmvRzr9mIiAkZHm32TSjDYeY2HY1Ezql/C3+4
        FC3WLer2otX0tQe6/EBmDq0gHs9WcUa3Vk2MhtQ7GYPrA1DaZp+Skod5e7jsFrvUQAwk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6buT-00EMiv-2K; Thu, 22 Jul 2021 18:50:57 +0200
Date:   Thu, 22 Jul 2021 18:50:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 net-next 1/1] net: ethernet: ti: cpsw: allow MTU >
 1500 when overridden by module parameter
Message-ID: <YPmh8UpyhCnhXuqA@lunn.ch>
References: <20210721210538.22394-1-colin.foster@in-advantage.com>
 <YPl7LdLMMTmhSu1z@lunn.ch>
 <20210722153351.GA3590944@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722153351.GA3590944@euler>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 08:33:51AM -0700, Colin Foster wrote:
> On Thu, Jul 22, 2021 at 04:05:33PM +0200, Andrew Lunn wrote:
> > On Wed, Jul 21, 2021 at 02:05:38PM -0700, Colin Foster wrote:
> > > The module parameter rx_packet_max can be overridden at module load or
> > > boot args. But it doesn't adjust the max_mtu for the device accordingly.
> > > 
> > > If a CPSW device is to be used in a DSA architecture, increasing the
> > > MTU by small amounts to account for switch overhead becomes necessary.
> > > This way, a boot arg of cpsw.rx_packet_max=1600 should allow the MTU
> > > to be increased to values of 1520, which is necessary for DSA tagging
> > > protocols like "ocelot" and "seville".
> > 
> > Hi Colin
> > 
> > As far as your patch goes, it makes sense.
> > 
> > However, module parameters are unlikely by netdev maintainers. Having
> > to set one in order to make DSA work is not nice. What is involved in
> > actually removing the module parameter and making the MTU change work
> > without it?
> 
> Thanks for the feedback Andrew.
> 
> That's a good idea. I used the module parameter because it was already 
> there.

Yes, i understand the rational for what you did. KISS. But this is
also a chance to improve the code.

> My intent was to not change any existing default behavior. The below 
> forum post makes me think that simply changing the default value of 
> rx_packet_max from 1500 to 1998 alongside this patch is all that is 
> needed. It all seems too easy, so either my use-case is rare enough 
> that nobody considered it, or there's some limitation I'm missing.

Probably nobody has done it before. The internal switch for the cpsw
is probably enough for most users, and it is happy with the default
MTU. And anybody using jumbo seems to be happy to hack the driver and
not post the fix upstream?

I've not looked at what is actually required to make this dynamic.
Maybe you need to destroy all the descriptors and buffers and
re-create them?

[Goes an looks at the code]

On the RX side, it is using a page pool, order 0. So it looks like it
already supports MTU of 4K - overheads. And changing the default max
MTU costs nothing. And on the TX side, i don't see any restrictions.

I guess when the page pool was added, nobody considered what affect
this has on the module parameter, and the MTU. It looks like 99% of
the work is done to allow bigger MTU at no cost. But the devil is in
the details.

   Andrew
