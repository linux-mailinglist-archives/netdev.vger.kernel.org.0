Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8646554B3
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 22:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiLWVTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 16:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiLWVTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 16:19:01 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F411AF3D
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 13:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7b6dDJMndauysvWiSnZx8ucIkQgINjCdTOSDzc5gWeo=; b=LhrhMUoRlgsyoETgEKR8juu2Lt
        w2Zfyd6gs89N3pfe4zxL3CCAABxGCF3a3F8yi2YEGKOl05R2s01UqfENpKGktx3bLNDkpcB52+mGZ
        8Bev6xXqQGABfkG+AUcHGUnEuSdTK9+fdXN12H3BK18dfWq+dBgtW03oMhgaq3Qs342Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p8pRO-000MPP-A5; Fri, 23 Dec 2022 22:18:54 +0100
Date:   Fri, 23 Dec 2022 22:18:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org
Subject: Re: Crosschip bridge functionality
Message-ID: <Y6YbPiI+pRjOQcxZ@lunn.ch>
References: <Y6YDi0dtiKVezD8/@euler>
 <Y6YKBzDJfs8LP0ny@lunn.ch>
 <Y6YVhWSTg4zgQ6is@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6YVhWSTg4zgQ6is@euler>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > What's the catch?
> > 
> > I actually think you need silicon support for this. Earlier versions
> > of the Marvell Switches are missing some functionality, which results
> > in VLANs leaking in distributed setups. I think the switches also
> > share information between themselves, over the DSA ports, i.e. the
> > ports between switches.
> > 
> > I've no idea if you can replicate the Marvell DSA concept with VLANs.
> > The Marvell header has D in DSA as a core concept. The SoC can request
> > a frame is sent out a specific port of a specific switch. And each
> > switch has a routing table which indicates what egress port to use to
> > go towards a specific switch. Frames received at the SoC indicate both
> > the ingress port and the ingress switch, etc.
> 
> "It might not work at all" is definitely a catch :-)
> 
> I haven't looked into the Marvell documentation about this, so maybe
> that's where I should go next. It seems Ocelot chips support
> double-tagging, which would lend itself to the SoC being able to
> determine which port and switch for ingress and egress... though that
> might imply it could only work with DSA ports on the first chip, which
> would be an understandable limitation.
> 
> > 
> > > In the Marvell case, is there any gotcha where "under these scenarios,
> > > the controlling CPU needs to process packets at line rate"?
> > 
> > None that i know of. But i'm sure Marvell put a reasonable amount of
> > thought into how to make a distributed switch. There is at least one
> > patent covering the concept. It could be that a VLAN based
> > re-implemention could have such problems. 
> 
> I'm starting to understand why there's only one user of
> crosschip_bridge_* functions. So this sounds to me like a "don't go down
> this path - you're in for trouble" scenario.

What is your real use case here?

I know people have stacked switches before, and just operated them as
stacked switches. So you need to configure each switch independently.
What Marvell DSA does is make it transparent, so to some extent it
looks like one big switch, not a collection of switches.

      Andrew
