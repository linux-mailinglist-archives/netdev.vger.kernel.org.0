Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485F93E49A3
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 18:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhHIQVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 12:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232861AbhHIQTn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 12:19:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 883C260F25;
        Mon,  9 Aug 2021 16:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628525959;
        bh=mUD6mi+2Ezw+xjAgq6p3e/jUBc+9BdNicDHE0iYiD64=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dGRRaXYBlqafpN5SWUx28tgkr93PNiDLx0Uj8HSo6fm4tAFL0zXCT43mRROsNJt96
         6d9yKPX7EO2v5XpGLzQXBMVu1z/B/eWYG7cQ4V52xKhnrbwj1XhwTmZI/QMyN42mn7
         90jOtoAPZkQuhMWFX4BLgNOpujc/hMIey12k3gXhz8Z4ox5fbUmMOumBs3Y+OWEuUz
         vYzRzu1bwrUiuCs4S/WJhJCNuZfVYXVTjaHkJKa3Ay0wqviNWDnEXvKXtghnEQ8f9u
         pl/5bLHY4bo1OGQEL8DzZhOdr45Z/LFZsTBENjbMWQuqZbF2/p7EnBwG8bDl9ScjRC
         x6HTAhmeV+P/w==
Date:   Mon, 9 Aug 2021 09:19:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] bareudp: Fix invalid read beyond skb's linear data
Message-ID: <20210809091918.68ae21e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210808161625.GA2912@pc-32.home>
References: <7741c46545c6ef02e70c80a9b32814b22d9616b3.1628264975.git.gnault@redhat.com>
        <20210806162234.69334902@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210808161625.GA2912@pc-32.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 8 Aug 2021 18:16:25 +0200 Guillaume Nault wrote:
> On Fri, Aug 06, 2021 at 04:22:34PM -0700, Jakub Kicinski wrote:
> > On Fri, 6 Aug 2021 17:52:06 +0200 Guillaume Nault wrote:  
> > > Data beyond the UDP header might not be part of the skb's linear data.
> > > Use skb_copy_bits() instead of direct access to skb->data+X, so that
> > > we read the correct bytes even on a fragmented skb.
> > > 
> > > Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS.")
> > > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > > ---
> > >  drivers/net/bareudp.c | 16 +++++++++++-----
> > >  1 file changed, 11 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> > > index a7ee0af1af90..54e321a695ce 100644
> > > --- a/drivers/net/bareudp.c
> > > +++ b/drivers/net/bareudp.c
> > > @@ -71,12 +71,18 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
> > >  		family = AF_INET6;
> > >  
> > >  	if (bareudp->ethertype == htons(ETH_P_IP)) {
> > > -		struct iphdr *iphdr;
> > > +		__u8 ipversion;
> > >  
> > > -		iphdr = (struct iphdr *)(skb->data + BAREUDP_BASE_HLEN);
> > > -		if (iphdr->version == 4) {
> > > -			proto = bareudp->ethertype;
> > > -		} else if (bareudp->multi_proto_mode && (iphdr->version == 6)) {
> > > +		if (skb_copy_bits(skb, BAREUDP_BASE_HLEN, &ipversion,
> > > +				  sizeof(ipversion))) {  
> > 
> > No preference just curious - could skb_header_pointer() be better suited?  
> 
> I have no preference either. I just used skb_copy_bits() because it
> didn't seem useful to get a pointer to the buffer (just to read one
> byte of data).

Right, the advantage would be in the "fast" case of skb_header_pointer()
being inlined.

> But I don't mind reposting with skb_header_pointer() if anyone prefers
> that solution.
