Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBEC1C647F
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 01:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgEEX3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 19:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728642AbgEEX3p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 19:29:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FCE0206B8;
        Tue,  5 May 2020 23:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588721384;
        bh=sJqExTpAnOPz7qfZqPDSiy+312yS9Nr/1POIvmOunjM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a+DvbO5AdYfMWA+YZNASVpDDpsRYdgnyA7QXrjwRP5/31iaaVXq1LGzauhZR/NAIt
         xejkdikFTW/1jJjS8A7eeeOa4l4DYeKDwyGWfloxfMvhKeoLqmibk+We2xIHIs00DS
         NffHp6VVUtPiopOM5tCJTDhY1yfSAmIM8utTTPwo=
Date:   Tue, 5 May 2020 16:29:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us, ecree@solarflare.com
Subject: Re: [PATCH net,v2] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200505162942.393ed266@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200505214321.GA13591@salvia>
References: <20200505174736.29414-1-pablo@netfilter.org>
        <20200505114010.132abebd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200505193145.GA9789@salvia>
        <20200505124343.27897ad6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200505214321.GA13591@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 23:43:21 +0200 Pablo Neira Ayuso wrote:
> On Tue, May 05, 2020 at 12:43:43PM -0700, Jakub Kicinski wrote:
> > On Tue, 5 May 2020 21:31:45 +0200 Pablo Neira Ayuso wrote:  
> > > On Tue, May 05, 2020 at 11:40:10AM -0700, Jakub Kicinski wrote:  
> > > > On Tue,  5 May 2020 19:47:36 +0200 Pablo Neira Ayuso wrote:    
> > > > > This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
> > > > > that the frontend does not need counters, this hw stats type request
> > > > > never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly requests
> > > > > the driver to disable the stats, however, if the driver cannot disable
> > > > > counters, it bails out.
> > > > > 
> > > > > TCA_ACT_HW_STATS_* maintains the 1:1 mapping with FLOW_ACTION_HW_STATS_*
> > > > > except by disabled which is mapped to FLOW_ACTION_HW_STATS_DISABLED
> > > > > (this is 0 in tc). Add tc_act_hw_stats() to perform the mapping between
> > > > > TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*.
> > > > > 
> > > > > Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
> > > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > > ---
> > > > > v2: define FLOW_ACTION_HW_STATS_DISABLED at the end of the enumeration
> > > > >     as Jiri suggested. Keep the 1:1 mapping between TCA_ACT_HW_STATS_*
> > > > >     and FLOW_ACTION_HW_STATS_* except by the disabled case.
> > > > > 
> > > > >  include/net/flow_offload.h |  9 ++++++++-
> > > > >  net/sched/cls_api.c        | 14 ++++++++++++--
> > > > >  2 files changed, 20 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> > > > > index 3619c6acf60f..efc8350b42fb 100644
> > > > > --- a/include/net/flow_offload.h
> > > > > +++ b/include/net/flow_offload.h
> > > > > @@ -166,15 +166,18 @@ enum flow_action_mangle_base {
> > > > >  enum flow_action_hw_stats_bit {
> > > > >  	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
> > > > >  	FLOW_ACTION_HW_STATS_DELAYED_BIT,
> > > > > +	FLOW_ACTION_HW_STATS_DISABLED_BIT,
> > > > >  };
> > > > >  
> > > > >  enum flow_action_hw_stats {
> > > > > -	FLOW_ACTION_HW_STATS_DISABLED = 0,
> > > > > +	FLOW_ACTION_HW_STATS_DONT_CARE = 0,    
> > > > 
> > > > Why not ~0? Or ANY | DISABLED? 
> > > > Otherwise you may confuse drivers which check bit by bit.    
> > > 
> > > I'm confused, you agreed with this behaviour:  
> > 
> > I was expecting the 0 to be exposed at UAPI level, and then kernel
> > would translate that to a full mask internally.
> >
> > From the other reply:
> >   
> > > I can send a v3 to handle the _DONT_CARE type from the mlxsw.  
> > 
> > Seems a little unnecessary for all drivers to cater to the special
> > case, when we made the argument be a bitfield specifically so that 
> > the drivers can function as long as they match on any of the bits.  
> 
> Let's summarize semantics:
> 
> - FLOW_ACTION_HW_STATS_DISABLED means disable counters, bail out if
>   driver cannot disable them.
> 
> - FLOW_ACTION_HW_STATS_IMMEDIATE means enable inmediate counters,
>   bail out if driver cannot enable inmediate counters.
> 
> - FLOW_ACTION_HW_STATS_DELAY means enable delayed counters, bail out
>   if driver cannot enable delay counters.
> 
> - FLOW_ACTION_HW_STATS_ANY means enable counters, either inmmediate or
>   delayed, if driver cannot enable any of them, bail out.
> 
> - FLOW_ACTION_HW_STATS_DONT_CARE (0) means counters are not needed, never
>   bail out.
> 
> How can you combine DISABLED and ANY? Look at the semantics above and
> combine them: this is asking for any counter otherwise bail out and
> DISABLED is asking for no counters at all, otherwise bail out.
> 
> This sounds like asking for things that are opposed.
> 
> So bit A means X, bit B means Y, but if you combine A and B, it means
> something complete different, say Z?
> 
> In your proposal, drivers drivers will have to check for ANY | DISABLED
> for don't care?
> 
> And what is the semantic for 0 (no bit set) in the kernel in your
> proposal?
> 
> Jiri mentioned there will be more bits coming soon. How will you
> extend this model (all bit set on for DONT_CARE) if new bits with
> specific semantics are showing up?
> 
> Combining ANY | DISABLED is non-sense, it should be rejected.

IIRC we went from the pure bitfield implementation (which was my
preference) to one where 0 means disabled.

The initial suggestion was to have the hw_stats field on offload mean
"user is okay with any of these types". In which case if users don't 
care about stats at all they should set all the bits, and the driver
picks whatever it prefers. Driver would work like so:

  if (hw_stats & TYPE1) { /* TYPE1 could be disabled */
  	/* this is the preferred type */
  } else if (hw_stats & TYPE2) {
  	/* also support this one */
  } else {
  	return ECANTDO;
  }

Unfortunately we ended up with a convoluted API where drivers have to
check for magic 0 or 'any' values.

I don't really care, we spent too much time talking about this simple
feature, anyway.

But you should adjust mlxsw, the only driver which actually supports
this feature properly, to get a sense of what drivers have to do. Extra
if statement times number of drivers - that will start to matter.
