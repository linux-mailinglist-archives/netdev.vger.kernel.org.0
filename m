Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFF34655FD
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245030AbhLATGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:06:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34202 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352632AbhLATGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 14:06:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=w7Zif49jo+7Du23s9WYO9kqOZP/pxG5qld7sHh40ygU=; b=5eFd53MiNT8FilJNQOmX9KJs39
        JUUCw+s9hV0a+Hj/4NuExBiPii93rD2EtmkXjBIB6pBRP70rGGfXvti+CBdM6FqoD4aUtMahCRREj
        wi5d9eN6NSnJ869Ycs1LgNIYHolxVtcGS2on4uDXlyq1nb+dvdS3rky9LIx2Da6xqs2A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1msUsg-00FFT8-DQ; Wed, 01 Dec 2021 20:03:02 +0100
Date:   Wed, 1 Dec 2021 20:03:02 +0100
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
Message-ID: <YafG5hboD7itUddn@lunn.ch>
References: <20211201163245.3629254-1-andrew@lunn.ch>
 <20211201163245.3629254-3-andrew@lunn.ch>
 <CA+FuTSfLxEic2ZtD8ygzUQMrftLkRyfjdf7GH6Pf8ioSRjHrOg@mail.gmail.com>
 <Yae6lGvTt8sCtLJX@lunn.ch>
 <CA+FuTSce_Q=uyn9brCDmwijf5-zOp3G9QDqSAaU=PC7=oCxUPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSce_Q=uyn9brCDmwijf5-zOp3G9QDqSAaU=PC7=oCxUPQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 10:22:38AM -0800, Willem de Bruijn wrote:
> > > > +static void icmpv6_notify_srh(struct sk_buff *skb, struct inet6_skb_parm *opt)
> > > > +{
> > > > +       struct sk_buff *skb_orig;
> > > > +       struct ipv6_sr_hdr *srh;
> > > > +
> > > > +       skb_orig = skb_clone(skb, GFP_ATOMIC);
> > > > +       if (!skb_orig)
> > > > +               return;
> > >
> > > Is this to be allowed to write to skb->cb? Or because seg6_get_srh
> > > calls pskb_may_pull to parse the headers?
> >
> > This is an ICMP error message. So we have an IP packet, skb, which
> > contains in the message body the IP packet which invoked the error. If
> > we pass skb to seg6_get_srh() it will look in the received ICMP
> > packet. But we actually want to find the SRH in the packet which
> > invoked the error, the one which is in the message body. So the code
> > makes a clone of the skb, and then updates the pointers so that it
> > points to the invoking packet within the ICMP packet. Then we can use
> > seg6_get_srh() on this inner packet, since it just looks like an
> > ordinary IP packet.
> 
> Ah of course. I clearly did not appreciate the importance of that
> skb_reset_network_header.

So i should probably add a comment here. If we stick with this design.

> > Yes, i checked that. Because the skb has been cloned, if it needs to
> > rearrange the packet because it goes over a fragment boundary,
> > pskb_may_pull() will return false. And then we won't find the
> > SRH.
> 
> Great. So the feature only works if the SRH is in the linear header.

Yes, traceroute will remain broken if the invoking SRH header is not
in the linear header.

> Then if the packet is not shared, you can just temporarily reset the
> network header and revert it after?

Maybe. I was worried about any side affects of such an
operation. Working on a clone seemed a lot less risky.

Is it safe to due such games with the network header?

	Andrew
