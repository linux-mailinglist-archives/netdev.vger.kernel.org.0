Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFDF2A4EF4
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgKCSei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:34:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728471AbgKCSeh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 13:34:37 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB70C20757;
        Tue,  3 Nov 2020 18:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604428477;
        bh=5HTsQEhN3dMFJV+EaD/jk8OWcfI88rKKhA6wJnPwdFo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TfGM0uV2F3C6oP7hdk2uxUt7iNcGWEqRhUYR7P2t3imv6JFvnu8ErW8XSDOYlLbCi
         U6macm48RopS89m5OaRAQG2pESGPEUi4+lTtOnu17NdazBmdCzA8rXqR4LhWt46oFs
         c/EPVpV/yInEYWITs9tLkn+Bcl4pxjRGTL7pT/b4=
Date:   Tue, 3 Nov 2020 10:34:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v3 net-next 09/12] net: dsa: tag_brcm: let DSA core deal
 with TX reallocation
Message-ID: <20201103103436.486e9339@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201103181528.tyvythhy2ynyjx4a@skbuf>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
        <20201101191620.589272-10-vladimir.oltean@nxp.com>
        <10537403-67a4-c64a-705a-61bc5f55f80e@gmail.com>
        <20201103105059.t66xhok5elgx4r4h@skbuf>
        <20201103090411.64f785cc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201103181528.tyvythhy2ynyjx4a@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 18:15:29 +0000 Vladimir Oltean wrote:
> On Tue, Nov 03, 2020 at 09:04:11AM -0800, Jakub Kicinski wrote:
> > In a recent discussion I was wondering if it makes sense to add the
> > padding len to struct net_device, with similar best-effort semantics
> > to needed_*room. It'd be a u8, so little worry about struct size.  
> 
> What would that mean in practice? Modify the existing alloc_skb calls
> which have an expression e that depends on LL_RESERVED_SPACE(dev), into
> max(e, dev->padding_len)? There's a lot of calls to alloc_skb to modify
> though...

Yeah, separate helper would probably be warranted, so we don't have to
touch multiple sites every time we adjust things.

> > You could also make sure DSA always provisions for padding if it has to
> > reallocate, you don't need to actually pad:
> > 
> > @@ -568,6 +568,9 @@ static int dsa_realloc_skb(struct sk_buff *skb, struct net_device *dev)
> >                 /* No reallocation needed, yay! */
> >                 return 0;
> >  
> > +       if (skb->len < ETH_ZLEN)
> > +               needed_tailroom += ETH_ZLEN;
> > +
> >         return pskb_expand_head(skb, needed_headroom, needed_tailroom,
> >                                 GFP_ATOMIC);
> >  }
> > 
> > That should save the realloc for all reasonable drivers while not
> > costing anything (other than extra if()) to drivers which don't care.  
> 
> DSA does already provision for padding if it has to reallocate, but only
> for the case where it needs to add a frame header at the end of the skb
> (i.e. "tail taggers"). My question here was whether there would be any
> drawback to doing that for all types of switches, including ones that
> might deal with padding in some other way (i.e. in hardware).

Well, we may re-alloc unnecessarily if we provision for padding of all
frames.

So what I was trying to achieve was to add the padding space _after_
the "do we need to realloc" check.

	/* over-provision space for pad, if we realloc anyway */
	if (!needed_tailroom && skb->len < ETH_ZLEN)
		needed_tailroom = ETH_ZLEN - skb->len;
