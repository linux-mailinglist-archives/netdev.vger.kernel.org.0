Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62964654C7
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 19:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352141AbhLASOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:14:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34088 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352036AbhLASOF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 13:14:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eHYysn+7iTT4LMGW6nBSiQ2CUEf1tziX/aH/Dk9lv/I=; b=xm0wM7VnXZEwkFulJ92sxcDs8H
        pAs0C1fu8/fn9LfHC/7izjaNdZUIqH95+yRepSnwHSwdA68MaC2+dCeUcbCj8DijeypUnbyrejcuM
        U/Pg6UxS6PX1C/WB80482cqpPLNGG5uYk+PbCXBhk2cVpOXg1rqioIcNv+/Wr1t8ozV0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1msU3o-00FF1p-Q7; Wed, 01 Dec 2021 19:10:28 +0100
Date:   Wed, 1 Dec 2021 19:10:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [patch RFC net-next 2/3] icmp: ICMPV6: Examine invoking packet
 for Segment Route Headers.
Message-ID: <Yae6lGvTt8sCtLJX@lunn.ch>
References: <20211201163245.3629254-1-andrew@lunn.ch>
 <20211201163245.3629254-3-andrew@lunn.ch>
 <CA+FuTSfLxEic2ZtD8ygzUQMrftLkRyfjdf7GH6Pf8ioSRjHrOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfLxEic2ZtD8ygzUQMrftLkRyfjdf7GH6Pf8ioSRjHrOg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 09:33:32AM -0800, Willem de Bruijn wrote:
> >  include/linux/ipv6.h |  2 ++
> >  net/ipv6/icmp.c      | 36 +++++++++++++++++++++++++++++++++++-
> >  2 files changed, 37 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
> > index 20c1f968da7c..d8ab5022d397 100644
> > --- a/include/linux/ipv6.h
> > +++ b/include/linux/ipv6.h
> > @@ -133,6 +133,7 @@ struct inet6_skb_parm {
> >         __u16                   dsthao;
> >  #endif
> >         __u16                   frag_max_size;
> > +       __u16                   srhoff;
> 
> Out of scope for this patch, but I guess we could use a
> 
> BUILD_BUG_ON(sizeof(struct inet6_skb_parm) > sizeof_field(struct sk_buff, cb));
 
There is something like that already. I triggered a BUILD_BUG_ON
failure when i put the actual IPv6 destination address here, rather
than an offset to it.

> >  #define IP6SKB_XFRM_TRANSFORMED        1
> >  #define IP6SKB_FORWARDED       2
> > @@ -142,6 +143,7 @@ struct inet6_skb_parm {
> >  #define IP6SKB_HOPBYHOP        32
> >  #define IP6SKB_L3SLAVE         64
> >  #define IP6SKB_JUMBOGRAM      128
> > +#define IP6SKB_SEG6          512
> 
> 256?

Doh!

> > +static void icmpv6_notify_srh(struct sk_buff *skb, struct inet6_skb_parm *opt)
> > +{
> > +       struct sk_buff *skb_orig;
> > +       struct ipv6_sr_hdr *srh;
> > +
> > +       skb_orig = skb_clone(skb, GFP_ATOMIC);
> > +       if (!skb_orig)
> > +               return;
> 
> Is this to be allowed to write to skb->cb? Or because seg6_get_srh
> calls pskb_may_pull to parse the headers?

This is an ICMP error message. So we have an IP packet, skb, which
contains in the message body the IP packet which invoked the error. If
we pass skb to seg6_get_srh() it will look in the received ICMP
packet. But we actually want to find the SRH in the packet which
invoked the error, the one which is in the message body. So the code
makes a clone of the skb, and then updates the pointers so that it
points to the invoking packet within the ICMP packet. Then we can use
seg6_get_srh() on this inner packet, since it just looks like an
ordinary IP packet.

> It is unlikely (not impossible) in this path for the packet to be
> shared or cloned. Avoid this operation when it isn't? Most packets
> will not actually have segment routing, so this imposes significant
> cost on the common case (if in the not common ICMP processing path).
> 
> nit: I found the name skb_orig confusing, as it is not in the meaning
> of preserve the original skb as at function entry.

skb_invoking? That seems to be the ICMP terminology?

> > +       skb_dst_drop(skb_orig);
> > +       skb_reset_network_header(skb_orig);
> > +
> > +       srh = seg6_get_srh(skb_orig, 0);
> > +       if (!srh)
> > +               goto out;
> > +
> > +       if (srh->type != IPV6_SRCRT_TYPE_4)
> > +               goto out;
> > +
> > +       opt->flags |= IP6SKB_SEG6;
> > +       opt->srhoff = (unsigned char *)srh - skb->data;
> 
> Should this offset be against skb->head, in case other data move
> operations could occur?

I copied the idea from get_srh(). It does:

srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);

So i'm just undoing it.

> Also, what happens if the header was in a frags that was pulled by
> pskb_may_pull in seg6_get_srh.

Yes, i checked that. Because the skb has been cloned, if it needs to
rearrange the packet because it goes over a fragment boundary,
pskb_may_pull() will return false. And then we won't find the
SRH. Nothing bad happens, traceroute is till broken as before.  What
is a typical fragment size? We basically need a MAC header, IPv6
header, ICMP Header and another IP header. 14 + 40 + 8 + 40. Plus the
SRH headers. So if 128 byte fragments are being used, then yes, it
could be an issue. But is that realistic? It seems more likely 1K, 2K
or 4K fragments are used?

> If we can expect headers to exist in the linear segment, then perhaps
> the whole code can be simplified and the clone can be avoided.

It will require seg6_get_srh() to be re-written so that you can tell
it to look at a nested IP header. Which actually means ipv6_find_hdr()
needs re-writing. Things like the helper ipv6_hdr(skb) point to the
ICMP packet IP header, not the invoking IP packet header inside the
ICMP packet. I didn't like the idea of such a rewrite.

	Andrew
