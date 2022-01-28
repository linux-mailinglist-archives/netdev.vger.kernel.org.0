Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D4149FDB3
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 17:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237576AbiA1QKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 11:10:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60494 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbiA1QKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 11:10:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6nCWgy9m02hUt7uQpkNW9XdqKNY5FJhMDyIwqP/X4jo=; b=aT3qINVuUmb3KjB705OCgfFFZ/
        oSWStzYSpeBw/pLB7Vq39BI057kZjR0PUIRzHaBfhtwpCXvifpo0bhIe8daVke8+nmQ8DhzCWe5VU
        fUxAQmJ7U/dhDXR4FHCdx9LU7SECNXKb300ixHOY0I9qpblq9W8WUs+H91W8DeWAxiSQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nDTpj-003C6n-W8; Fri, 28 Jan 2022 17:10:43 +0100
Date:   Fri, 28 Jan 2022 17:10:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 0/2] net: dsa: mv88e6xxx: Improve indirect
 addressing performance
Message-ID: <YfQVg4mYYT9iop3x@lunn.ch>
References: <20220128104938.2211441-1-tobias@waldekranz.com>
 <c3bc08f82f1c435ca6fd47e30eb65405@AcuMS.aculab.com>
 <87k0ejc0ol.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0ejc0ol.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 04:58:02PM +0100, Tobias Waldekranz wrote:
> On Fri, Jan 28, 2022 at 14:10, David Laight <David.Laight@ACULAB.COM> wrote:
> > From: Tobias Waldekranz
> >> Sent: 28 January 2022 10:50
> >> 
> >> The individual patches have all the details. This work was triggered
> >> by recent work on a platform that took 16s (sic) to load the mv88e6xxx
> >> module.
> >> 
> >> The first patch gets rid of most of that time by replacing a very long
> >> delay with a tighter poll loop to wait for the busy bit to clear.
> >> 
> >> The second patch shaves off some more time by avoiding redundant
> >> busy-bit-checks, saving 1 out of 4 MDIO operations for every register
> >> read/write in the optimal case.
> >
> > I don't think you should fast-poll for the entire timeout period.
> > Much better to drop to a usleep_range() after the first 2 (or 3)
> > reads fail.
> 
> You could, I suppose. Andrew, do you want a v3?

You have i available, so it would be a simple change. So yes please.

But saying that, it seems like if the switch does not complete within
2 polls, it is likely to be dead and we are about to start a cascade
of failures. We probably don't care about a bit of CPU usage when the
devices purpose in being has just stopped working.

	Andrew
