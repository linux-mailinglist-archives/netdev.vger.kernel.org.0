Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1562542F64
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfFLS4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:56:16 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54640 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfFLS4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:56:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hb8Pt-0006Gn-4c; Wed, 12 Jun 2019 20:56:13 +0200
Message-ID: <60a0183a1f8508d0132feb7790baac86dd70fe52.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        John Hurley <john.hurley@netronome.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        David Ahern <dsahern@gmail.com>
Date:   Wed, 12 Jun 2019 20:56:10 +0200
In-Reply-To: <20190612114627.4dd137ab@cakuba.netronome.com>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
         <20190612180239.GA3499@localhost.localdomain>
         <20190612114627.4dd137ab@cakuba.netronome.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(switching to my personal email)

> > I can't add these actions with current net-next and iproute-next:
> > # ~/iproute2/tc/tc action add action ctinfo dscp 0xfc000000 0x01000000
> > Error: NLA_F_NESTED is missing.
> > We have an error talking to the kernel
> > 
> > This also happens with the current post of act_ct and should also
> > happen with the act_mpls post (thus why Cc'ing John as well).
> > 
> > I'm not sure how we should fix this. In theory the kernel can't get
> > stricter with userspace here, as that breaks user applications as
> > above, so older actions can't use the more stricter parser. Should we
> > have some actions behaving one way, and newer ones in a different way?
> > That seems bad.

I think you could just fix all of the actions in userspace, since the
older kernel would allow both with and without the flag, and then from a
userspace POV it all behaves the same, just the kernel accepts some
things without the flag for compatibility with older iproute2?

> > Or maybe all actions should just use nla_parse_nested_deprecated()?
> > I'm thinking this last. Yet, then the _deprecated suffix may not make
> > much sense here. WDYT?
> 
> Surely for new actions we can require strict validation, there is
> no existing user space to speak of..  

That was the original idea.

> Perhaps act_ctinfo and act_ct
> got slightly confused with the race you described, but in principle
> there is nothing stopping new actions from implementing the user space
> correctly, right?

There's one potential thing where you have a new command in netlink
(which thus will use strict validation), but you use existing code in
userspace to build the netlink message or parts thereof?

But then again you can just fix that while you test it, and the current
and older kernel will accept the stricter version for the existing use
of the existing code too, right?

johannes

