Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5902405B5
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 14:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgHJMU2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 10 Aug 2020 08:20:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42591 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726462AbgHJMU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 08:20:28 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-1jYhJCaePQujiXWXLkR0eQ-1; Mon, 10 Aug 2020 08:20:24 -0400
X-MC-Unique: 1jYhJCaePQujiXWXLkR0eQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D945680183C;
        Mon, 10 Aug 2020 12:20:23 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DE8A8BD67;
        Mon, 10 Aug 2020 12:20:21 +0000 (UTC)
Date:   Mon, 10 Aug 2020 14:20:20 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Bram Yvakh <bram-yvahk@mail.wizbit.be>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>, xmu@redhat.com
Subject: Re: [PATCH ipsec] xfrmi: drop ignore_df check before updating pmtu
Message-ID: <20200810122020.GA1128331@bistromath.localdomain>
References: <70e7c2a65afed5de117dbc16082def459bd39d93.1596531053.git.sd@queasysnail.net>
 <5F295578.4040004@mail.wizbit.be>
 <20200807144701.GC906370@bistromath.localdomain>
 <5F2D7615.6090802@mail.wizbit.be>
MIME-Version: 1.0
In-Reply-To: <5F2D7615.6090802@mail.wizbit.be>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-08-07, 17:41:09 +0200, Bram Yvakh wrote:
> 
> On 7/08/2020 16:47, Sabrina Dubroca wrote:
> > 2020-08-04, 14:32:56 +0200, Bram Yvakh wrote:
> >   
> >> On 4/08/2020 11:37, Sabrina Dubroca wrote:
> >>     
> >>> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> >>> index b615729812e5..ade2eba863b3 100644
> >>> --- a/net/xfrm/xfrm_interface.c
> >>> +++ b/net/xfrm/xfrm_interface.c
> >>> @@ -292,7 +292,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
> >>>  	}
> >>>  
> >>>  	mtu = dst_mtu(dst);
> >>> -	if (!skb->ignore_df && skb->len > mtu) {
> >>> +	if (skb->len > mtu) {
> >>>       
> [snip]
> 
> >
> > Yeah, it's the most simple xfrmi setup possible (directly connected by
> > a veth),
> Thanks, that gives me something to experiment with;
> Could you you share what kernel your testing with? (i.e. what
> tree/branch/sha)

Always the latest upstream relevant to the area I'm working on. In
this case, Steffen's ipsec/master.

> > and just run ping on it. ping sets DF, we want an exception
> > to be created, but this test prevents it.
> >   
> As I said dropping the test currently doesn't make sense to me.
> I would expect that the 'ignore_df' flag is not set on the device, and
> if it's set then I would expect things to work.

ignore_df is a property of the packet (skb), not of the device. Only
gre tunnels have an ignore_df property, not vti or xfrmi.

> > The packet ends up being dropped in xfrm_output_one because of the mtu
> > check in xfrm4_tunnel_check_size.
> >   
> That's the bit that does not (yet) make senes to me..
> Looking at net-next/master (bfdd5aaa54b0a44d9df550fe4c9db7e1470a11b8)
> 
> ||
> 
> 	static int xfrm4_tunnel_check_size(struct sk_buff *skb)
> 	{
> 		int mtu, ret = 0;
> 	
> 		if (IPCB(skb)->flags & IPSKB_XFRM_TUNNEL_SIZE)
> 			goto out;
> 	
> 		if (!(ip_hdr(skb)->frag_off & htons(IP_DF)) || skb->ignore_df)
> 			goto out;
> 	
> 		mtu = dst_mtu(skb_dst(skb));
> 		if ((!skb_is_gso(skb) && skb->len > mtu) ||
> 		    (skb_is_gso(skb) &&
> 		     !skb_gso_validate_network_len(skb, ip_skb_dst_mtu(skb->sk, skb)))) {
> 			skb->protocol = htons(ETH_P_IP);
> 	
> 			if (skb->sk)
> 				xfrm_local_error(skb, mtu);
> 			else
> 				icmp_send(skb, ICMP_DEST_UNREACH,
> 					  ICMP_FRAG_NEEDED, htonl(mtu));
> 			ret = -EMSGSIZE;
> 		}
> 	out:
> 		return ret;
> 	}
> 
> *If* skb->ignore_df is set then it *skips* the mtu check.

If the packet doesn't have the DF bit set (so the stack can fragment
the packet at will), or if the stack decided that it can ignore it and
fragment anyway, there's no need to check the mtu, because we'll
fragment the packet when we need. Otherwise, we're not allowed to
fragment, so we have to check the packet's size against the mtu.

> In other words: 'xfrm4_tunnel_check_size' only cares about the mtu if ignore_df isn't set.
> The original code in 'xfrmi_xmit2': only checks the mtu if ignore_df isn't set. (-> looks consistent)

Except that we reset skb->ignore_df in between (just after the mtu
handling in xfrmi_xmit2, via xfrmi_scrub_packet).

Why should we care about whether we can fragment the packet that's
being transmitted over a tunnel? We're not fragmenting it, we're going
to encapsulate it inside another IP header, and then we'll have to
fragment that outer IP packet.

-- 
Sabrina

