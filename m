Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3872A2AF0
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 13:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgKBMrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 07:47:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25712 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728561AbgKBMrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 07:47:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604321232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mzT0AhlYvj48ay046KlpqQOJqmioK9ASEFfbnK3s3So=;
        b=BH3YeCnpB2bFRkepdUvdvtD43vRDPBgEA8PiozS09VeEcz3MIvPXw8TPnn5vnbJcUxYktM
        WpjpC0wRsNBCnMCUKNi9HIJOjYCGmfIYIYl759ecd0NysfSr9QvZ//FbAQ4FqtrwCSzJuh
        wrzhp54c5elDkdCKodaohCB6uGa9cZE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-eyAdvIpqNXyEn0lcoINg6g-1; Mon, 02 Nov 2020 07:47:08 -0500
X-MC-Unique: eyAdvIpqNXyEn0lcoINg6g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 657D6AADF79;
        Mon,  2 Nov 2020 12:47:06 +0000 (UTC)
Received: from carbon (unknown [10.36.110.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26C675B4D8;
        Mon,  2 Nov 2020 12:46:59 +0000 (UTC)
Date:   Mon, 2 Nov 2020 13:46:58 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next V5 4/5] bpf: drop MTU check when doing TC-BPF
 redirect to ingress
Message-ID: <20201102134658.081fd974@carbon>
In-Reply-To: <5f9c7935c6991_16d420838@john-XPS-13-9370.notmuch>
References: <160407661383.1525159.12855559773280533146.stgit@firesoul>
        <160407666748.1525159.1515139110258948831.stgit@firesoul>
        <5f9c7935c6991_16d420838@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 13:36:05 -0700
John Fastabend <john.fastabend@gmail.com> wrote:

> Jesper Dangaard Brouer wrote:
> > The use-case for dropping the MTU check when TC-BPF does redirect to
> > ingress, is described by Eyal Birger in email[0]. The summary is the
> > ability to increase packet size (e.g. with IPv6 headers for NAT64) and
> > ingress redirect packet and let normal netstack fragment packet as needed.
> > 
> > [0] https://lore.kernel.org/netdev/CAHsH6Gug-hsLGHQ6N0wtixdOa85LDZ3HNRHVd0opR=19Qo4W4Q@mail.gmail.com/
> > 
> > V4:
> >  - Keep net_device "up" (IFF_UP) check.
> >  - Adjustment to handle bpf_redirect_peer() helper
> > 
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  include/linux/netdevice.h |   31 +++++++++++++++++++++++++++++--
> >  net/core/dev.c            |   19 ++-----------------
> >  net/core/filter.c         |   14 +++++++++++---
> >  3 files changed, 42 insertions(+), 22 deletions(-)
> > 
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 964b494b0e8d..bd02ddab8dfe 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -3891,11 +3891,38 @@ int dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
> >  bool is_skb_forwardable(const struct net_device *dev,
> >  			const struct sk_buff *skb);
> >  
> > +static __always_inline bool __is_skb_forwardable(const struct net_device *dev,
> > +						 const struct sk_buff *skb,
> > +						 const bool check_mtu)  
> 
> It looks like if check_mtu=false then this is just an interface up check.
> Can we leave is_skb_forwardable logic alone and just change the spots where
> this is called with false to something with a name that describes the check,
> such as is_dev_up(dev). I think it will make this change smaller and the
> code easier to read. Did I miss something?

People should realized that this is constructed such, the compiler will
compile-time remove the actual argument (the const bool check_mtu).
And this propagates also to ____dev_forward_skb() where the call places
are also inlined.

Yes, this (check_mtu=false) is basically an interface up check, but the
only place it is used directly is in the ndo_get_peer_dev() case, and
reading the code I find it more readable that is says
__is_skb_forwardable because this is used as part of a forwarding step,
and is_dev_up() doesn't convey the intent in this use-case.


> > +{
> > +	const u32 vlan_hdr_len = 4; /* VLAN_HLEN */
> > +	unsigned int len;
> > +
> > +	if (!(dev->flags & IFF_UP))
> > +		return false;
> > +
> > +	if (!check_mtu)
> > +		return true;
> > +
> > +	len = dev->mtu + dev->hard_header_len + vlan_hdr_len;
> > +	if (skb->len <= len)
> > +		return true;
> > +
> > +	/* if TSO is enabled, we don't care about the length as the packet
> > +	 * could be forwarded without being segmented before
> > +	 */
> > +	if (skb_is_gso(skb))
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> >  static __always_inline int ____dev_forward_skb(struct net_device *dev,
> > -					       struct sk_buff *skb)
> > +					       struct sk_buff *skb,
> > +					       const bool check_mtu)
> >  {  
> 
> I guess you will get some duplication here if you have a dev_forward_skb()
> and a dev_forward_skb_nocheck() or something. Take it or leave it. I know
> I've added my share of bool swivel bits like this, but better to avoid
> it if possible IMO.

As I wrote the bool will actually get compile-time removed, so I don't
see that as problematic.  And I avoided replicating the code in more
places.

The problematic part (which you didn't comment) on is this:

On Fri, 30 Oct 2020 17:51:07 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> diff --git a/net/core/filter.c b/net/core/filter.c
> index bd4a416bd9ad..71b78b8d443c 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2083,13 +2083,21 @@ static const struct bpf_func_proto bpf_csum_level_proto = {
>  
>  static inline int __bpf_rx_skb(struct net_device *dev, struct sk_buff *skb)
>  {
> -	return dev_forward_skb(dev, skb);
> +	int ret = ____dev_forward_skb(dev, skb, false);
> +
> +	if (likely(!ret)) {
> +		skb->protocol = eth_type_trans(skb, dev);
> +		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> +		ret = netif_rx(skb);
> +	}
> +
> +	return ret;
>  }

I'm replicating two lines from dev_forward_skb(), but I couldn't find a
way to avoid this, without causing larger code changes (and slower code).



> Other than style aspects it looks correct to me.
> 
> >  	if (skb_orphan_frags(skb, GFP_ATOMIC) ||
> > -	    unlikely(!is_skb_forwardable(dev, skb))) {
> > +	    unlikely(!__is_skb_forwardable(dev, skb, check_mtu))) {
> >  		atomic_long_inc(&dev->rx_dropped);
> >  		kfree_skb(skb);
> >  		return NET_RX_DROP;
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 9499a414d67e..445ccf92c149 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -2188,28 +2188,13 @@ static inline void net_timestamp_set(struct sk_buff *skb)
> >    
> 



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

