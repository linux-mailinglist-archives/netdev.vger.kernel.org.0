Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8906839956E
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 23:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhFBVcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 17:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhFBVcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 17:32:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32B65613D2;
        Wed,  2 Jun 2021 21:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622669416;
        bh=27PXotcSAwyoOyuvKX7GPs9lOkrHOvxe9C8+Aqu841s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gk/Z5uINMC6H/V2GVDoc5KSTd8SuIt21LFoGPArQgSTw6SwYa6+1EszyXDpyoPKkT
         zXnJFt8DrV2qei++JuNZjvQ8vrDZQvpXsyjYBEeF8eCa8ku1A/UUjeK4WsO1GmsQnV
         GL2fspNmYtQ9gkjOcG/szlmgm9zbTqAp6LvrN968vBptf06YvBoE/tdxJHMDscpb5G
         CneIvFq/m6q/4hhFGEcOlpGRpWG2MYBI9a+P6P/+y8QkYy0ELtuk7QQyhFz38kmbxz
         OakHlC5PiN0wk2ctSoS4JOsQgoIQXu+9YfosdrVCWFSPO9H5fULSaOzggOHZw9G7Bb
         QKhIzwTBXu/1w==
Date:   Wed, 2 Jun 2021 14:30:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>, Po Liu <po.liu@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: enetc: count the tc-taprio window
 drops
Message-ID: <20210602143015.75e3f56e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210602175937.nwdz7xju4o5eqaby@skbuf>
References: <20210602122114.2082344-1-olteanv@gmail.com>
        <20210602122114.2082344-3-olteanv@gmail.com>
        <20210602101920.3c09686a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20210602175937.nwdz7xju4o5eqaby@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Jun 2021 20:59:37 +0300 Vladimir Oltean wrote:
> On Wed, Jun 02, 2021 at 10:19:20AM -0700, Jakub Kicinski wrote:
> > On Wed,  2 Jun 2021 15:21:14 +0300 Vladimir Oltean wrote:  
> > > From: Po Liu <Po.Liu@nxp.com>
> > > 
> > > The enetc scheduler for IEEE 802.1Qbv has 2 options (depending on
> > > PTGCR[TG_DROP_DISABLE]) when we attempt to send an oversized packet
> > > which will never fit in its allotted time slot for its traffic class:
> > > either block the entire port due to head-of-line blocking, or drop the  
> > 
> > the entire port or the entire queue?  
> 
> I don't remember, I need to re-test.
> 
> > > packet and set a bit in the writeback format of the transmit buffer
> > > descriptor, allowing other packets to be sent.
> > > 
> > > We obviously choose the second option in the driver, but we do not
> > > detect the drop condition, so from the perspective of the network stack,
> > > the packet is sent and no error counter is incremented.
> > > 
> > > This change checks the writeback of the TX BD when tc-taprio is enabled,
> > > and increments a specific ethtool statistics counter and a generic
> > > "tx_dropped" counter in ndo_get_stats64.  
> > 
> > Any chance we should also report that back to the qdisc to have 
> > a standard way of querying from user space? Qdisc offload supports
> > stats in general, it shouldn't be an issue, and the stat seems generic
> > enough, no?  
> 
> You're thinking of something along the lines of tc_codel_xstats?
> How do you propose I pass this on to the taprio qdisc? Just call a
> function in enetc that is exported by net/sched/sch_taprio.c?

Check out red_dump_offload_stats()/TC_RED_STATS, this is the usual way
of handling stats offload in TC.

> If the skb is bound to a socket, I'm thinking it might be more useful to
> report a struct sock_extended_err similar to the SO_EE_TXTIME_MISSED
> stuff for tc-etf, what do you think?

That's an interesting idea as well, dunno enough about the practical
uses to be able to tell if applications care about per-socket state,
per-interface state, or both.
