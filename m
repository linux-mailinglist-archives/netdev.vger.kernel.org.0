Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E4D655419
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 21:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiLWUFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 15:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiLWUFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 15:05:33 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5922A120B2
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 12:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=B/ny6lRUDZlKra0NspUiOdiw5ofFGewPcO02ik6Qrpk=; b=VrFEh0/q0RGohhhzQ92SbrMwlS
        Jxad1uJMoy6flNTqV9nBUin+CgIDwmU/2mLGEMkCvTF+aVELSxBNvKQsTjmQe/IeJM9/p0KI8+K5r
        MWoCxs4NBsHcocKdYGNJ8Gd71YhWb+GN7paITP1T+dO6aZaMpHOEo5ki0z8llEc/sGyE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p8oIJ-000MEr-As; Fri, 23 Dec 2022 21:05:27 +0100
Date:   Fri, 23 Dec 2022 21:05:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org
Subject: Re: Crosschip bridge functionality
Message-ID: <Y6YKBzDJfs8LP0ny@lunn.ch>
References: <Y6YDi0dtiKVezD8/@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6YDi0dtiKVezD8/@euler>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 23, 2022 at 11:37:47AM -0800, Colin Foster wrote:
> Hello,
> 
> I've been looking into what it would take to add the Distributed aspect
> to the Felix driver, and I have some general questions about the theory
> of operation and if there are any limitations I don't foresee. It might
> be a fair bit of work for me to get hardware to even test, so avoiding
> dead ends early would be really nice!
> 
> Also it seems like all the existing Felix-like hardware is all
> integrated into a SOC, so there's really no other potential users at
> this time.
> 
> For a distributed setup, it looks like I'd just need to create
> felix_crosschip_bridge_{join,leave} routines, and use the mv88e6xxx as a
> template. These routines would create internal VLANs where, assuming
> they use a tagging protocol that the switch can offload (your
> documentation specifically mentions Marvell-tagged frames for this
> reason, seemingly) everything should be fully offloaded to the switches.
> 
> What's the catch?

I actually think you need silicon support for this. Earlier versions
of the Marvell Switches are missing some functionality, which results
in VLANs leaking in distributed setups. I think the switches also
share information between themselves, over the DSA ports, i.e. the
ports between switches.

I've no idea if you can replicate the Marvell DSA concept with VLANs.
The Marvell header has D in DSA as a core concept. The SoC can request
a frame is sent out a specific port of a specific switch. And each
switch has a routing table which indicates what egress port to use to
go towards a specific switch. Frames received at the SoC indicate both
the ingress port and the ingress switch, etc.

> In the Marvell case, is there any gotcha where "under these scenarios,
> the controlling CPU needs to process packets at line rate"?

None that i know of. But i'm sure Marvell put a reasonable amount of
thought into how to make a distributed switch. There is at least one
patent covering the concept. It could be that a VLAN based
re-implemention could have such problems. 

	Andrew
