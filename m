Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E55292B4A
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 18:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbgJSQRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 12:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730059AbgJSQRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 12:17:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EF6B2225F;
        Mon, 19 Oct 2020 16:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603124224;
        bh=jDqFKn3RiuxYB+JI2fznJ2y98dZcjYXcdjyM917ZngU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IojlTmE1qXFAT7jrAU87A3TYrVFuvu3Kgqim4VY/7qdrKIkVA6I14sb2GJCY+9gHy
         kZpq1Y3482kebZENej93h9wLrlJsadR+OpR2I8Rva66vyoq3g+g5usRQbPvIz6ZLGO
         XZAvhRiczgi8h25iPLru3ri0Q5Pzo2nXlyXIoPi0=
Date:   Mon, 19 Oct 2020 09:17:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Reji Thomas <rejithomas.d@gmail.com>
Cc:     Reji Thomas <rejithomas@juniper.net>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        David Lebrun <david.lebrun@uclouvain.be>
Subject: Re: [PATCH v2] IPv6: sr: Fix End.X nexthop to use oif.
Message-ID: <20201019091702.5b26870c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAA8Zg7Gcua1=6CgSkJ-z8uKJneDjedB4z6zm2a+DcYt-_YcmSQ@mail.gmail.com>
References: <20201015082119.68287-1-rejithomas@juniper.net>
        <20201018160147.6b3c940a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAA8Zg7Gcua1=6CgSkJ-z8uKJneDjedB4z6zm2a+DcYt-_YcmSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 09:25:12 +0530 Reji Thomas wrote:
> > > @@ -566,7 +583,8 @@ static struct seg6_action_desc seg6_action_table[] = {
> > >       },
> > >       {
> > >               .action         = SEG6_LOCAL_ACTION_END_X,
> > > -             .attrs          = (1 << SEG6_LOCAL_NH6),
> > > +             .attrs          = ((1 << SEG6_LOCAL_NH6) |
> > > +                                (1 << SEG6_LOCAL_OIF)),
> > >               .input          = input_action_end_x,
> > >       },
> > >       {  
> >
> > If you set this parse_nla_action() will reject all
> > SEG6_LOCAL_ACTION_END_X without OIF.
> >
> > As you say the OIF is only required for using link local addresses,
> > so this change breaks perfectly legitimate configurations.
> >
> > Can we instead only warn about the missing OIF, and only do that when
> > nh is link local?
> >  
> End.X is defined as an adjacency-sid and is used to select a specific link to a
> neighbor for both global and link-local addresses. The intention was
> to drop the
> packet even for global addresses if the route via the specific
> interface is not found.
> Alternatively(believe semantically correct for End.X definition) I
> could do a neighbor lookup
> for nexthop address over specific interface and send the packet out.

If we can save the device lookup and still be semantically correct,
that's probably better.
