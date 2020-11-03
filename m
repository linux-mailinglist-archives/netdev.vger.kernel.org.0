Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EC62A4C36
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgKCREO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:04:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:32974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgKCREN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 12:04:13 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A386C2080D;
        Tue,  3 Nov 2020 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604423053;
        bh=ZaGxcm2dEynExECVdP9BrXOzGOMSQyCJK2VwxCvRmrM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1SrxpOII6z3cwkYcgQ3k17pa8f69AMh+8lx70Am4Ld78vjcB4bxy9bPSUrkF7uTMY
         S8/G8RtqLjMUHvPGIVjisBVOusQS1jxIk/o/Uh45BzxGlKKcVorhotE7IHGRchhruR
         GKMvBfBy9dBGgUPg56Rvxi29gHw9cjPMYPDbyFIs=
Date:   Tue, 3 Nov 2020 09:04:11 -0800
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
Message-ID: <20201103090411.64f785cc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201103105059.t66xhok5elgx4r4h@skbuf>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
        <20201101191620.589272-10-vladimir.oltean@nxp.com>
        <10537403-67a4-c64a-705a-61bc5f55f80e@gmail.com>
        <20201103105059.t66xhok5elgx4r4h@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 10:51:00 +0000 Vladimir Oltean wrote:
> On Mon, Nov 02, 2020 at 12:34:11PM -0800, Florian Fainelli wrote:
> > On 11/1/2020 11:16 AM, Vladimir Oltean wrote:  
> > > Now that we have a central TX reallocation procedure that accounts for
> > > the tagger's needed headroom in a generic way, we can remove the
> > > skb_cow_head call.
> > >
> > > Cc: Florian Fainelli <f.fainelli@gmail.com>
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>  
> >
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>  
> 
> Florian, I just noticed that tag_brcm.c has an __skb_put_padto call,
> even though it is not a tail tagger. This comes from commit:
> 
> commit bf08c34086d159edde5c54902dfa2caa4d9fbd8c
> Author: Florian Fainelli <f.fainelli@gmail.com>
> Date:   Wed Jan 3 22:13:00 2018 -0800
> 
>     net: dsa: Move padding into Broadcom tagger
> 
>     Instead of having the different master network device drivers
>     potentially used by DSA/Broadcom tags, move the padding necessary for
>     the switches to accept short packets where it makes most sense: within
>     tag_brcm.c. This avoids multiplying the number of similar commits to
>     e.g: bgmac, bcmsysport, etc.
> 
>     Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Do you remember why this was needed?
> As far as I understand, either the DSA master driver or the MAC itself
> should pad frames automatically. Is that not happening on Broadcom SoCs,
> or why do you need to pad from DSA?
> How should we deal with this? Having tag_brcm.c still do some potential
> reallocation defeats the purpose of doing it centrally, in a way. I was
> trying to change the prototype of struct dsa_device_ops::xmit to stop
> returning a struct sk_buff *, and I stumbled upon this.
> Should we just go ahead and pad everything unconditionally in DSA?

In a recent discussion I was wondering if it makes sense to add the
padding len to struct net_device, with similar best-effort semantics
to needed_*room. It'd be a u8, so little worry about struct size.

You could also make sure DSA always provisions for padding if it has to
reallocate, you don't need to actually pad:

@@ -568,6 +568,9 @@ static int dsa_realloc_skb(struct sk_buff *skb, struct net_device *dev)
                /* No reallocation needed, yay! */
                return 0;
 
+       if (skb->len < ETH_ZLEN)
+               needed_tailroom += ETH_ZLEN;
+
        return pskb_expand_head(skb, needed_headroom, needed_tailroom,
                                GFP_ATOMIC);
 }

That should save the realloc for all reasonable drivers while not
costing anything (other than extra if()) to drivers which don't care.
