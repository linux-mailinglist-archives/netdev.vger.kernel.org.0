Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AD65E62B3
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 14:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbiIVMqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 08:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiIVMpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 08:45:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AB7E9997
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 05:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=q/A6daADuWrCAoYq+jB2kpPMlv7MU81VPy1syBQFqGc=; b=ivt4EeNeE+a0kJO+jZeeueB4Yy
        lqj/INU38oWx699i3Q0aVP7+65f+GDjlykR/Of3ZAR0G4wdo5FcwGBUuasp5/hB5OIWEzdLP6iOfb
        Y4C9ARsd+j/rP/+kuCy320ytlPoDGL02lEDkkWh4Fbbx2ZQtUXHLxtC8JPc6XZpmwZAQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obLaB-00HX2X-0Y; Thu, 22 Sep 2022 14:45:35 +0200
Date:   Thu, 22 Sep 2022 14:45:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v14 5/7] net: dsa: mv88e6xxx: rmu: Add
 functionality to get RMON
Message-ID: <YyxY7hLaX0twtThI@lunn.ch>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919224924.yt7nzmr722a62rnl@skbuf>
 <aad1bfa6-e401-2301-2da2-f7d4f9f2798c@gmail.com>
 <20220920131053.24kwiy4hxdovlkxo@skbuf>
 <Yyoqx1+AqMlAqRMx@lunn.ch>
 <20220922114820.hexazc2do5yytsu2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922114820.hexazc2do5yytsu2@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 02:48:20PM +0300, Vladimir Oltean wrote:
> On Tue, Sep 20, 2022 at 11:04:07PM +0200, Andrew Lunn wrote:
> > On Tue, Sep 20, 2022 at 04:10:53PM +0300, Vladimir Oltean wrote:
> > > On Tue, Sep 20, 2022 at 02:26:22PM +0200, Mattias Forsblad wrote:
> > > > This whole shebang was a suggestion from Andrew. I had a solution with
> > > > mv88e6xxx_rmu_available in mv88e6xxx_get_ethtool_stats which he wasn't fond of.
> > > > The mv88e6xxx_bus_ops is declared const and how am I to change the get_rmon
> > > > member? I'm not really sure on how to solve this in a better way?
> > > > Suggestions any? Maybe I've misunderstood his suggestion.
> > > 
> > > Can you point me to the beginning of that exact suggestion? I've removed
> > > everything older than v10 from my inbox, since the flow of patches was
> > > preventing me from seeing other emails.
> > 
> > What i want to do is avoid code like:
> > 
> >      if (have_rmu())
> >      	foo()
> >      else
> > 	bar()
> > 
> > There is nothing common in the MDIO MIB code and the RMU MIB code,
> > just the table of statistics. When we get to dumping the ATU, i also
> > expect there will be little in common between the MDIO and the RMU
> > functions.
> 
> Sorry, I don't understand what it is about "if (have_rmu()) foo() else bar()"
> that you don't like. Isn't the indirection via bus_ops the exact same
> thing, but expressed as an indirect function call rather than an if/else?

There was code like this deep inside the MIB code, which just looked
ugly. That is now gone.

> > Doing MIB via RMU is a big gain, but i would also like normal register
> > read and write to go via RMU, probably with some level of
> > combining. Multiple writes can be combined into one RMU operation
> > ending with a read. That should give us an mv88e6xxx_bus_ops which
> > does RMU, and we can swap the bootstrap MDIO bus_ops for the RMU
> > bus_ops.
> 
> At what level would the combining be done? I think the mv88e6xxx doesn't
> really make use of bulk operations, C45 MDIO reads with post-increment,
> that sort of thing. I could be wrong. And at some higher level, the
> register read/write code should not diverge (too much), even if the
> operation may be done over Ethernet or MDIO. So we need to find places
> which actually make useful sense of bulk reads.

I was thinking within mv88e6xxx_read() and mv88e6xxx_write(). Keep a
buffer for building requests. Each write call appends the write to the
buffer and returns 0. A read call gets appended to the buffer and then
executes the RMU. We probably also need to wrap the reg mutex, so that
when it is released, any buffered writes get executed. If the RMU
fails, we have all the information needed to do the same via MDIO.

What i was not aware of is that some registers are not supposed to be
accessed over RMU. I suppose we can make a list of them, and if there
is a read/write to such a register, execute the RMU and then perform
an MDIO operation for the restricted register.

> But then, Mattias' code structure becomes inadequate. Currently we
> serialize mv88e6xxx_master_state_change() with respect to bus accesses
> via mv88e6xxx_reg_lock(). But if we permit RMU to run in parallel with
> MDIO, we need a rwlock, such that multiple 'readers' of the conceptual
> have_rmu() function can run in parallel with each other, and just
> serialize with the RMU state changes (the 'writers').

I don't think we can allow RMU to run in parallel to MDIO. The reg
lock will probably prevent that anyway.

> 
> > I am assuming here that RMU is reliable. The QCA8K driver currently
> > falls back to MDIO if its inband function is attempted but fails.  I
> > want to stress this part, lots of data packets and see if the RMU
> > frames get dropped, or delayed too much causing failures.
> 
> I don't think you even have to stress it too much. Nothing prevents the
> user from putting a policer on the DSA master which will randomly drop
> responses. Or a shaper that will delay requests beyond the timeout.

That would be a self inflicted problem. But you are correct, we need
to fall back to MDIO.

This is one area we can experiment with. Maybe we can retry the
operation via RMU a few times? Two retries for MIBs is still going to
be a lot faster, if successful, compared to all the MDIO transactions
for all the statistics. We can also add some fall back tracking
logic. If RMU has failed for N times in a row, stop using it for 60
seconds, etc. That might be something we can put into the DSA core,
since it seems like a generic problem.

There is a lot of experimentation needed here, and it could be we need
to throw it all away and try again a few times until we have explored
the problem sufficiently to get it right...

    Andrew
