Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B7B229D89
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgGVQwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgGVQwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 12:52:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9C6B206F5;
        Wed, 22 Jul 2020 16:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595436751;
        bh=gXHnNXNXpfZZurJ7uSqFREuxYKFMmvI8rB9oIAsB0aY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gl7UAv6HZpl7j6ciDQzY/NMwyYPtXVF7nhroZdd3rQpJuu5q4pvc3FmYFNRcP+CzI
         Y5JVjcCsVUOVjIh6w0iFEFO1+YjlZUP6mie25cH/ke4W6x8QgFDJXcGyQ3zYuwdp5h
         rkBsh1Dscq0LKq0B+fALNJi5530ziRITfxv4IMd0=
Date:   Wed, 22 Jul 2020 09:52:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to
 flash update
Message-ID: <20200722095228.2f2c61b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <02874ECE860811409154E81DA85FBB58C8AF3382@fmsmsx101.amr.corp.intel.com>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
        <20200717183541.797878-7-jacob.e.keller@intel.com>
        <20200720100953.GB2235@nanopsycho>
        <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200721135356.GB2205@nanopsycho>
        <20200721100406.67c17ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200722105139.GA3154@nanopsycho>
        <02874ECE860811409154E81DA85FBB58C8AF3382@fmsmsx101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jul 2020 15:30:05 +0000 Keller, Jacob E wrote:
> > >> >one by one and then omit the one(s) which is config (guessing which
> > >> >one that is based on the name).
> > >> >
> > >> >Wouldn't this be quite inconvenient?  
> > >>
> > >> I see it as an extra knob that is actually somehow provides degradation
> > >> of components.  
> > >
> > >Hm. We have the exact opposite view on the matter. To me components
> > >currently correspond to separate fw/hw entities, that's a very clear
> > >meaning. PHY firmware, management FW, UNDI. Now we would add a
> > >completely orthogonal meaning to the same API.  
> > 
> > I understand. My concern is, we would have a component with some
> > "subparts". Now it is some fuzzy vagely defined "config part",
> > in the future it might be something else. That is what I'm concerned
> > about. Components have clear api.
> > 
> > So perhaps we can introduce something like "component mask", which would
> > allow to flash only part of the component. That is basically what Jacob
> > has, I would just like to have it well defined.
> 
> So, we could make this selection a series of masked bits instead of a
> single enumeration value.

I'd still argue that components (as defined in devlink info) and config
are pretty orthogonal. In my experience config is stored in its own
section of the flash, and some of the knobs are in no obvious way
associated with components (used by components).

That said, if we rename the "component mask" to "update mask" that's
fine with me.

Then we'd have

bit 0 - don't overwrite config
bit 1 - don't overwrite identifiers

? 

Let's define a bit for "don't update program" when we actually need it.
