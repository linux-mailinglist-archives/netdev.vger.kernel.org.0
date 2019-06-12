Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF2642FD4
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 21:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfFLTTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 15:19:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:43812 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727496AbfFLTTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 15:19:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BFE22AD78;
        Wed, 12 Jun 2019 19:18:59 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 412ABE00E3; Wed, 12 Jun 2019 21:18:59 +0200 (CEST)
Date:   Wed, 12 Jun 2019 21:18:59 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        John Hurley <john.hurley@netronome.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Message-ID: <20190612191859.GJ31797@unicorn.suse.cz>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
 <20190612180239.GA3499@localhost.localdomain>
 <20190612114627.4dd137ab@cakuba.netronome.com>
 <60a0183a1f8508d0132feb7790baac86dd70fe52.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60a0183a1f8508d0132feb7790baac86dd70fe52.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 08:56:10PM +0200, Johannes Berg wrote:
> (switching to my personal email)
> 
> > > I can't add these actions with current net-next and iproute-next:
> > > # ~/iproute2/tc/tc action add action ctinfo dscp 0xfc000000 0x01000000
> > > Error: NLA_F_NESTED is missing.
> > > We have an error talking to the kernel
> > > 
> > > This also happens with the current post of act_ct and should also
> > > happen with the act_mpls post (thus why Cc'ing John as well).
> > > 
> > > I'm not sure how we should fix this. In theory the kernel can't get
> > > stricter with userspace here, as that breaks user applications as
> > > above, so older actions can't use the more stricter parser. Should we
> > > have some actions behaving one way, and newer ones in a different way?
> > > That seems bad.
> 
> I think you could just fix all of the actions in userspace, since the
> older kernel would allow both with and without the flag, and then from a
> userspace POV it all behaves the same, just the kernel accepts some
> things without the flag for compatibility with older iproute2?
> 
> > > Or maybe all actions should just use nla_parse_nested_deprecated()?
> > > I'm thinking this last. Yet, then the _deprecated suffix may not make
> > > much sense here. WDYT?
> > 
> > Surely for new actions we can require strict validation, there is
> > no existing user space to speak of..  
> 
> That was the original idea.
> 
> > Perhaps act_ctinfo and act_ct
> > got slightly confused with the race you described, but in principle
> > there is nothing stopping new actions from implementing the user space
> > correctly, right?
> 
> There's one potential thing where you have a new command in netlink
> (which thus will use strict validation), but you use existing code in
> userspace to build the netlink message or parts thereof?
> 
> But then again you can just fix that while you test it, and the current
> and older kernel will accept the stricter version for the existing use
> of the existing code too, right?

Userspace can safely set NLA_F_NESTED on every nested attribute as there
are only few places in kernel where nla->type is accessed directly
rather than through nla_type() and those are rather specific (mostly
when attribute type is actually used as an array index). So the best
course of action would be letting userspace always set NLA_F_NESTED.
So kernel can only by strict on newly added attributes but userspace can
(and should) set NLA_F_NESTED always.

The opposite direction (kernel -> userspace) is more tricky as we can
never be sure there isn't some userspace client accessing the type directly
without masking out the flags. Thus kernel can only set NLA_F_NESTED on
new attributes where there cannot be any userspace program used to it
not being set.

Michal
