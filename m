Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674F829DB96
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389447AbgJ2AFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:05:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50702 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389373AbgJ2AFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:05:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXvRb-0043T5-Dv; Thu, 29 Oct 2020 01:05:31 +0100
Date:   Thu, 29 Oct 2020 01:05:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v7 2/8] net: dsa: Give drivers the chance to
 veto certain upper devices
Message-ID: <20201029000531.GD933237@lunn.ch>
References: <20201028074221.29326-1-kurt@linutronix.de>
 <20201028074221.29326-3-kurt@linutronix.de>
 <20201028104344.56exyeh5tbwefyw5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028104344.56exyeh5tbwefyw5@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 12:43:44PM +0200, Vladimir Oltean wrote:
> On Wed, Oct 28, 2020 at 08:42:15AM +0100, Kurt Kanzenbach wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Some switches rely on unique pvids to ensure port separation in
> > standalone mode, because they don't have a port forwarding matrix
> > configurable in hardware. So, setups like a group of 2 uppers with the
> > same VLAN, swp0.100 and swp1.100, will cause traffic tagged with VLAN
> > 100 to be autonomously forwarded between these switch ports, in spite
> > of there being no bridge between swp0 and swp1.
> > 
> > These drivers need to prevent this from happening. They need to have
> > VLAN filtering enabled in standalone mode (so they'll drop frames tagged
> > with unknown VLANs) and they can only accept an 8021q upper on a port as
> > long as it isn't installed on any other port too. So give them the
> > chance to veto bad user requests.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> > ---
> 
> In case reviewers have doubts about this new DSA operation in general.
> I would expect that when LAG support is merged, some drivers will
> support it, but not any tx_type, but e.g. just NETDEV_LAG_TX_TYPE_HASH.
> So it would also be helpful in that case, so they could veto other types
> of bond interfaces cleanly. So I do see the need for a generic
> "prechangeupper" operation given to drivers.

There is always the interesting question, do we want to veto, or
simply not accelerate it? We will want to consider that case by case.

       Andrew
