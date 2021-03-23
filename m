Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EC1345E37
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 13:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhCWMdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 08:33:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42748 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230347AbhCWMcy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 08:32:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lOgDF-00CauS-2w; Tue, 23 Mar 2021 13:32:45 +0100
Date:   Tue, 23 Mar 2021 13:32:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <YFnf7arsXNbJpuBE@lunn.ch>
References: <20210323102326.3677940-1-tobias@waldekranz.com>
 <20210323113522.coidmitlt6e44jjq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323113522.coidmitlt6e44jjq@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 01:35:22PM +0200, Vladimir Oltean wrote:
> On Tue, Mar 23, 2021 at 11:23:26AM +0100, Tobias Waldekranz wrote:
> > All devices are capable of using regular DSA tags. Support for
> > Ethertyped DSA tags sort into three categories:
> > 
> > 1. No support. Older chips fall into this category.
> > 
> > 2. Full support. Datasheet explicitly supports configuring the CPU
> >    port to receive FORWARDs with a DSA tag.
> > 
> > 3. Undocumented support. Datasheet lists the configuration from
> >    category 2 as "reserved for future use", but does empirically
> >    behave like a category 2 device.
> > 
> > Because there are ethernet controllers that do not handle regular DSA
> > tags in all cases, it is sometimes preferable to rely on the
> > undocumented behavior, as the alternative is a very crippled
> > system. But, in those cases, make sure to log the fact that an
> > undocumented feature has been enabled.
> > 
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> > ---
> > 
> > In a system using an NXP T1023 SoC connected to a 6390X switch, we
> > noticed that TO_CPU frames where not reaching the CPU. This only
> > happened on hardware port 8. Looking at the DSA master interface
> > (dpaa-ethernet) we could see that an Rx error counter was bumped at
> > the same rate. The logs indicated a parser error.
> > 
> > It just so happens that a TO_CPU coming in on device 0, port 8, will
> > result in the first two bytes of the DSA tag being one of:
> > 
> > 00 40
> > 00 44
> > 00 46
> > 
> > My guess is that since these values look like 802.3 length fields, the
> > controller's parser will signal an error if the frame length does not
> > match what is in the header.
> 
> Interesting assumption.
> Could you please try this patch out, just for my amusement? It is only
> compile-tested.

Another thing you could try, just for amusement, is change the
Ethertype in EDSA to 00400044 and see if it also causes problems. It
might not, since the last two bytes are not set as required.

      Andrew
