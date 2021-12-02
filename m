Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62915466A32
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 20:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355929AbhLBTPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 14:15:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36292 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348386AbhLBTPg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 14:15:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zSUh0xNwlHbletDfJShKsJGi0R+3zGCiKfa/HR3mOHs=; b=1gQJz4HZYQM/iJAN5xnVO88dwG
        Da3TIZmhidfERIC0KB6Hf0tMHQ9zY6kq86f7vvvOSvu+aS/iRgR/zZkH6w75R9Qlyan+FSoOb6GHJ
        rg+RyVIMHix1W7ND2Q0rd1E5EH2+PFxsRyXTby2IIFU/zXJfQNlUIHcx3L0y3qaWTktM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1msrUs-00FM4A-CB; Thu, 02 Dec 2021 20:11:58 +0100
Date:   Thu, 2 Dec 2021 20:11:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [patch RFC net-next v2 2/3] icmp: ICMPV6: Examine invoking
 packet for Segment Route Headers.
Message-ID: <YakafsFxVxg8/ulH@lunn.ch>
References: <20211201202519.3637005-1-andrew@lunn.ch>
 <20211201202519.3637005-3-andrew@lunn.ch>
 <d284a03b-baf8-339f-05bb-c42c3a2fb3f8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d284a03b-baf8-339f-05bb-c42c3a2fb3f8@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 09:38:36AM -0700, David Ahern wrote:
> On 12/1/21 1:25 PM, Andrew Lunn wrote:
> > diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> > index a7c31ab67c5d..dd1fe8a822e3 100644
> > --- a/net/ipv6/icmp.c
> > +++ b/net/ipv6/icmp.c
> > @@ -818,9 +819,40 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
> >  	local_bh_enable();
> >  }
> >  
> > +/* Determine if the invoking packet contains a segment routing header.
> > + * If it does, extract the true destination address, which is in the
> > + * first segment address
> > + */
> > +static void icmpv6_notify_srh(struct sk_buff *skb, struct inet6_skb_parm *opt)
> > +{
> > +	__u16 network_header = skb->network_header;
> > +	struct ipv6_sr_hdr *srh;
> > +
> > +	/* Update network header to point to the invoking packet
> > +	 * inside the ICMP packet, so we can use the seg6_get_srh()
> > +	 * helper.
> > +	 */
> > +	skb_reset_network_header(skb);
> > +
> > +	srh = seg6_get_srh(skb, 0);
> > +	if (!srh)
> > +		goto out;
> > +
> > +	if (srh->type != IPV6_SRCRT_TYPE_4)
> > +		goto out;
> > +
> > +	opt->flags |= IP6SKB_SEG6;
> > +	opt->srhoff = (unsigned char *)srh - skb->data;
> > +
> > +out:
> > +	/* Restore the network header back to the ICMP packet */
> > +	skb->network_header = network_header;
> > +}
> > +
> 
> since this is SR specific, why not put it in seg6.c?

Hi David

I can move it.

I was thinking it is only every going to be called from one location,
so having it here the compiler will inline it.

And it is also very specific to ICMP.  If you are not thinking ICMP,
you might not actually understand what it is doing.

    Andrew
