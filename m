Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CC549E30D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241500AbiA0NGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:06:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57790 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241497AbiA0NGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 08:06:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=I1B80wTk0Z7TVvxhdKY4ix7J4uHlW/Q6ukG/Wfi3avE=; b=Yv8sMaxTNQyOPYFTYkbMTA1oiC
        bh212u4L3DJ7q1zBayPmfps1AkXC9/0mKa7MbSXtcZkpOVyRN7er7jUX5sXynN26lJHNKNTjCjZlA
        MACVcKug7cKRPlLtrICfbWVTaRH5ls4cNS2HkWoBAaopDpqhjeLTJZ3OnkQTBjy+DoGM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nD4TR-002zOw-Gv; Thu, 27 Jan 2022 14:06:01 +0100
Date:   Thu, 27 Jan 2022 14:06:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Improve performance of
 busy bit polling
Message-ID: <YfKYua94K20/gkCA@lunn.ch>
References: <20220126231239.1443128-1-tobias@waldekranz.com>
 <20220126231239.1443128-2-tobias@waldekranz.com>
 <YfHdCDIUvpaYpDSF@lunn.ch>
 <87o83xbajf.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o83xbajf.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 01:58:12PM +0100, Tobias Waldekranz wrote:
> On Thu, Jan 27, 2022 at 00:45, Andrew Lunn <andrew@lunn.ch> wrote:
> > There are a few bit-banging systems out there. For those, i wonder if
> > 50ms is too short? With the old code, they had 16 chances, no matter
> > how slow they were. With the new code, if they take 50ms for one
> > transaction, they don't get a second chance.
> >
> > But if they have taken 50ms, around 37ms has been spent with the
> > preamble, start, op, phy address, and register address. I assume at
> > that point the switch actually looks at the register, and given your
> > timings, it really should be ready, so a second loop is probably not
> > required?
> >
> > O.K, so this seems safe.
> 
> I think you raise a good point though. Say that you then have this
> series of events:
> 
> 1. Bang out ST
> 2. Bang out OP
> 3. Bang out PHYADR
> 4. Bang out REGADR
> 5. Clock out TA
> 6. schedule()
> 7. A SCHED_FIFO/P99 task runs
> 8. Clock in DATA
> 
> - Steps 1 through 5 could plausibly be completed before the bit clears
>   if you are running over some memory mapped GPIO lines
> - Step 7 could execute for more than 50ms
> - After step 8, you would see the busy bit set, but your time is up

So this is the opposite case i was thinking about. A very fast bit
banger. Yes, in theory this could happen.

> All of this is of course _very_ unlikely, but not impossible. Should we
> ensure that you always get at least two bites at the apple?

This is why i always point people at include/linux/iopoll.h. It
handles conditions like this by doing one more poll after the timeout
just to be sure the scheduler has not interfered. So a minimum of 2
would be good.

      Andrew
