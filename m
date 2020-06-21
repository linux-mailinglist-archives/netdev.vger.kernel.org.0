Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4072202CEB
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 23:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730754AbgFUVO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 17:14:28 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:60343 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730729AbgFUVO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 17:14:27 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Jun 2020 17:14:26 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 29F03CC0101;
        Sun, 21 Jun 2020 23:05:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1592773518; x=1594587919; bh=fwxZkm1MWG
        QMcxOAgCizOAJq5jQ+Ka19NTZj5D0nv4E=; b=W4O+AGO3kti2JT+Pu+2zxK9W57
        OQ+1gfvOU6OEyu7JeNIy/RUVEfNWbBnplNphI2Bhg6ygsXMXC5KUWpMyjk3yg4P/
        gz7YQ8NtMEyUOD0lq5jYoW5tIozEyW74BoPs8772RTYC7O3ipeM/hS0NlbfTcp8c
        VULbDn6NWPUrWLHA8=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sun, 21 Jun 2020 23:05:18 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp2.kfki.hu (Postfix) with ESMTP id B6FA0CC0100;
        Sun, 21 Jun 2020 23:05:17 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 798C220D01; Sun, 21 Jun 2020 23:05:17 +0200 (CEST)
Date:   Sun, 21 Jun 2020 23:05:17 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] netfiler: ipset: fix unaligned atomic access
In-Reply-To: <20200621202453.GA30348@salvia>
Message-ID: <alpine.DEB.2.22.394.2006212304260.536@blackhole.kfki.hu>
References: <E1jj7gl-0008Bq-BQ@rmk-PC.armlinux.org.uk> <20200621194514.GW1551@shell.armlinux.org.uk> <20200621202453.GA30348@salvia>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, 21 Jun 2020, Pablo Neira Ayuso wrote:

> I'll place in this in nf.git unless you have any objection.

No objection at all and thanks!

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef

> On Sun, Jun 21, 2020 at 08:45:14PM +0100, Russell King - ARM Linux admin wrote:
> > Gentle ping...
> > 
> > This patch fixes a remotely triggerable kernel oops, and as such can
> > be viewed as a remote denial of service attack depending on the
> > netfilter rule setup.
> > 
> > On Wed, Jun 10, 2020 at 09:51:11PM +0100, Russell King wrote:
> > > When using ip_set with counters and comment, traffic causes the kernel
> > > to panic on 32-bit ARM:
> > > 
> > > Alignment trap: not handling instruction e1b82f9f at [<bf01b0dc>]
> > > Unhandled fault: alignment exception (0x221) at 0xea08133c
> > > PC is at ip_set_match_extensions+0xe0/0x224 [ip_set]
> > > 
> > > The problem occurs when we try to update the 64-bit counters - the
> > > faulting address above is not 64-bit aligned.  The problem occurs
> > > due to the way elements are allocated, for example:
> > > 
> > > 	set->dsize = ip_set_elem_len(set, tb, 0, 0);
> > > 	map = ip_set_alloc(sizeof(*map) + elements * set->dsize);
> > > 
> > > If the element has a requirement for a member to be 64-bit aligned,
> > > and set->dsize is not a multiple of 8, but is a multiple of four,
> > > then every odd numbered elements will be misaligned - and hitting
> > > an atomic64_add() on that element will cause the kernel to panic.
> > > 
> > > ip_set_elem_len() must return a size that is rounded to the maximum
> > > alignment of any extension field stored in the element.  This change
> > > ensures that is the case.
> > > 
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > > Patch against v5.6, where I tripped over this bug.  This bug has
> > > caused a kernel panic on my new router twice today.
> > > 
> > >  net/netfilter/ipset/ip_set_core.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> > > index 8dd17589217d..be9cd6a500fb 100644
> > > --- a/net/netfilter/ipset/ip_set_core.c
> > > +++ b/net/netfilter/ipset/ip_set_core.c
> > > @@ -459,6 +459,8 @@ ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len,
> > >  	for (id = 0; id < IPSET_EXT_ID_MAX; id++) {
> > >  		if (!add_extension(id, cadt_flags, tb))
> > >  			continue;
> > > +		if (align < ip_set_extensions[id].align)
> > > +			align = ip_set_extensions[id].align;
> > >  		len = ALIGN(len, ip_set_extensions[id].align);
> > >  		set->offset[id] = len;
> > >  		set->extensions |= ip_set_extensions[id].type;
> > > -- 
> > > 2.20.1
> > > 
> > > 
> > 
> > -- 
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
