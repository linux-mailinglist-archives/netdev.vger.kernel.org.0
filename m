Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27593202CB2
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 22:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730669AbgFUUY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 16:24:59 -0400
Received: from correo.us.es ([193.147.175.20]:44568 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730288AbgFUUY6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 16:24:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 57B5D130E21
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 22:24:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4B37FDA78B
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 22:24:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 409A0DA78F; Sun, 21 Jun 2020 22:24:56 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5720DA722;
        Sun, 21 Jun 2020 22:24:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 21 Jun 2020 22:24:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 80CDD42EE38F;
        Sun, 21 Jun 2020 22:24:53 +0200 (CEST)
Date:   Sun, 21 Jun 2020 22:24:53 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] netfiler: ipset: fix unaligned atomic access
Message-ID: <20200621202453.GA30348@salvia>
References: <E1jj7gl-0008Bq-BQ@rmk-PC.armlinux.org.uk>
 <20200621194514.GW1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200621194514.GW1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jozsef,

I'll place in this in nf.git unless you have any objection.

Thanks.

On Sun, Jun 21, 2020 at 08:45:14PM +0100, Russell King - ARM Linux admin wrote:
> Gentle ping...
> 
> This patch fixes a remotely triggerable kernel oops, and as such can
> be viewed as a remote denial of service attack depending on the
> netfilter rule setup.
> 
> On Wed, Jun 10, 2020 at 09:51:11PM +0100, Russell King wrote:
> > When using ip_set with counters and comment, traffic causes the kernel
> > to panic on 32-bit ARM:
> > 
> > Alignment trap: not handling instruction e1b82f9f at [<bf01b0dc>]
> > Unhandled fault: alignment exception (0x221) at 0xea08133c
> > PC is at ip_set_match_extensions+0xe0/0x224 [ip_set]
> > 
> > The problem occurs when we try to update the 64-bit counters - the
> > faulting address above is not 64-bit aligned.  The problem occurs
> > due to the way elements are allocated, for example:
> > 
> > 	set->dsize = ip_set_elem_len(set, tb, 0, 0);
> > 	map = ip_set_alloc(sizeof(*map) + elements * set->dsize);
> > 
> > If the element has a requirement for a member to be 64-bit aligned,
> > and set->dsize is not a multiple of 8, but is a multiple of four,
> > then every odd numbered elements will be misaligned - and hitting
> > an atomic64_add() on that element will cause the kernel to panic.
> > 
> > ip_set_elem_len() must return a size that is rounded to the maximum
> > alignment of any extension field stored in the element.  This change
> > ensures that is the case.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> > Patch against v5.6, where I tripped over this bug.  This bug has
> > caused a kernel panic on my new router twice today.
> > 
> >  net/netfilter/ipset/ip_set_core.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> > index 8dd17589217d..be9cd6a500fb 100644
> > --- a/net/netfilter/ipset/ip_set_core.c
> > +++ b/net/netfilter/ipset/ip_set_core.c
> > @@ -459,6 +459,8 @@ ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len,
> >  	for (id = 0; id < IPSET_EXT_ID_MAX; id++) {
> >  		if (!add_extension(id, cadt_flags, tb))
> >  			continue;
> > +		if (align < ip_set_extensions[id].align)
> > +			align = ip_set_extensions[id].align;
> >  		len = ALIGN(len, ip_set_extensions[id].align);
> >  		set->offset[id] = len;
> >  		set->extensions |= ip_set_extensions[id].type;
> > -- 
> > 2.20.1
> > 
> > 
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
