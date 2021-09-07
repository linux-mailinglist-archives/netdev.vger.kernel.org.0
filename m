Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3551F402B9B
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 17:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345106AbhIGPT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 11:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345187AbhIGPTV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 11:19:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EF88610D0;
        Tue,  7 Sep 2021 15:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631027895;
        bh=/97m/i74To/vQunmhZyAuwwUMsBBuG+szwVCniQt64A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pqofC4GztYvtJ7O/7E1CiSCDAktqLeJ/I06RGKJsi8i87pRdcWf2hq3o5YN0oRyiF
         UWfot5qtizBHxuJM5Wj04clC4HTGEpKpyssISmbiZCIE/V49g7YQ7vJ/ZxCX+mLx1c
         hSyskT5QoGiUQL+2xUnAXJVYObzNjsaKGokGil3w=
Date:   Tue, 7 Sep 2021 17:18:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:MEDIATEK SWITCH DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH 4.19.y] net: dsa: mt7530: disable learning on standalone
 ports
Message-ID: <YTeCtLaG14TGrTCO@kroah.com>
References: <20210824055509.1316124-1-dqfext@gmail.com>
 <YSUQV3jhfbhbf5Ct@sashalap>
 <CALW65ja3hYGmEqcWZzifP2-0WsJOnxcUXsey2ZH5vDbD0-nDeQ@mail.gmail.com>
 <YSi8Ky3GqBjnxbhC@kroah.com>
 <20210902053619.1824464-1-dqfext@gmail.com>
 <YTBoDaYDJfBz3YzN@kroah.com>
 <20210903091430.2209627-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903091430.2209627-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 05:14:30PM +0800, DENG Qingfang wrote:
> On Thu, Sep 02, 2021 at 07:58:37AM +0200, Greg KH wrote:
> > On Thu, Sep 02, 2021 at 01:36:19PM +0800, DENG Qingfang wrote:
> > > On Fri, Aug 27, 2021 at 12:19:23PM +0200, Greg KH wrote:
> > > > On Tue, Aug 24, 2021 at 11:57:53PM +0800, DENG Qingfang wrote:
> > > > > Standalone ports should have address learning disabled, according to
> > > > > the documentation:
> > > > > https://www.kernel.org/doc/html/v5.14-rc7/networking/dsa/dsa.html#bridge-layer
> > > > > dsa_switch_ops on 5.10 or earlier does not have .port_bridge_flags
> > > > > function so it has to be done differently.
> > > > > 
> > > > > I've identified an issue related to this.
> > > > 
> > > > What issue is that?  Where was it reported?
> > > 
> > > See Florian's message here
> > > https://lore.kernel.org/stable/20210317003549.3964522-2-f.fainelli@gmail.com/
> > 
> > THat is just the patch changelog text, or is it unique to this
> > stable-only patch?  It is not obvious at all.
> 
> The issue is with all DSA drivers that do not disable address learning
> on standalone ports.
> 
> "With learning enabled we would end up with the switch having
> incorrectly learned the address of the CPU port which typically results
> in a complete break down of network connectivity until the address
> learned ages out and gets re-learned, from the correct port this time."
> 
> > 
> > > > > > 2. A partial backport of this patch?
> > > > > 
> > > > > The other part does not actually fix anything.
> > > > 
> > > > Then why is it not ok to just take the whole thing?
> > > > 
> > > > When backporting not-identical-patches, something almost always goes
> > > > wrong, so we prefer to take the original commit when ever possible.
> > > 
> > > Okay. MDB and tag ops can be backported as is, and broadcast/multicast
> > > flooding can be implemented in .port_egress_floods. 
> > 
> > So what are we supposed to do here?
> 
> Function port_egress_floods is refactored to port_bridge_flags in commit
> a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags"). I can
> backport the mt7530_port_bridge_flags function as port_egress_floods.

I am sorry, I still do not understand what to do here.

Ideally we want to take the original patches as get merged into Linus's
tree.  If that is not possible for some reason, we need to have it
documented very well why that is so, and to get everyone to agree with
the different patch that is submitted.

thanks,

greg k-h
