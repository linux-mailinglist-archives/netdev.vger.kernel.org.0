Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD652DD336
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 15:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgLQOsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 09:48:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34625 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726012AbgLQOsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 09:48:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608216428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9dIgUyuEcjJkPwiD61XKrH42CdrbPPDWnkmKtHwrOL4=;
        b=YhpuSTQjBIyRDSJ8Xh24xY3BV5YXxq+OEIb88xby/rDa5HTZl56ZH6IyumW2czBUBqkmRl
        AyNKKbS6pVX9RdEodxmmZa5Ke2mppxmNY1qlS2s90/GDfgk88Wn1Uly8O4xP4PCTz9+0JP
        KlpROsRsx3IifO82ElvTowSb1B+2ufE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-AVE7hUvePDCP6czJlEGH0Q-1; Thu, 17 Dec 2020 09:47:06 -0500
X-MC-Unique: AVE7hUvePDCP6czJlEGH0Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FB8551B6;
        Thu, 17 Dec 2020 14:47:04 +0000 (UTC)
Received: from carbon (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A82E5D9E3;
        Thu, 17 Dec 2020 14:46:56 +0000 (UTC)
Date:   Thu, 17 Dec 2020 15:46:55 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V8 5/8] bpf: drop MTU check when doing TC-BPF
 redirect to ingress
Message-ID: <20201217154655.42e89d08@carbon>
In-Reply-To: <af28e4e7-8089-b252-3927-a962b98ad7b8@iogearbox.net>
References: <160650034591.2890576.1092952641487480652.stgit@firesoul>
        <160650040292.2890576.17040975200628427127.stgit@firesoul>
        <af28e4e7-8089-b252-3927-a962b98ad7b8@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 00:43:36 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 11/27/20 7:06 PM, Jesper Dangaard Brouer wrote:
> > The use-case for dropping the MTU check when TC-BPF does redirect to
> > ingress, is described by Eyal Birger in email[0]. The summary is the
> > ability to increase packet size (e.g. with IPv6 headers for NAT64) and
> > ingress redirect packet and let normal netstack fragment packet as needed.
> > 
> > [0] https://lore.kernel.org/netdev/CAHsH6Gug-hsLGHQ6N0wtixdOa85LDZ3HNRHVd0opR=19Qo4W4Q@mail.gmail.com/
> > 
> > V4:
> >   - Keep net_device "up" (IFF_UP) check.
> >   - Adjustment to handle bpf_redirect_peer() helper
> > 
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >   include/linux/netdevice.h |   31 +++++++++++++++++++++++++++++--
> >   net/core/dev.c            |   19 ++-----------------
> >   net/core/filter.c         |   14 +++++++++++---
> >   3 files changed, 42 insertions(+), 22 deletions(-)
> > 
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 7ce648a564f7..4a854e09e918 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -3917,11 +3917,38 @@ int dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
> >   bool is_skb_forwardable(const struct net_device *dev,
> >   			const struct sk_buff *skb);
> >   
> > +static __always_inline bool __is_skb_forwardable(const struct net_device *dev,
> > +						 const struct sk_buff *skb,
> > +						 const bool check_mtu)
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
> >   static __always_inline int ____dev_forward_skb(struct net_device *dev,
> > -					       struct sk_buff *skb)
> > +					       struct sk_buff *skb,
> > +					       const bool check_mtu)
> >   {
> >   	if (skb_orphan_frags(skb, GFP_ATOMIC) ||
> > -	    unlikely(!is_skb_forwardable(dev, skb))) {
> > +	    unlikely(!__is_skb_forwardable(dev, skb, check_mtu))) {
> >   		atomic_long_inc(&dev->rx_dropped);
> >   		kfree_skb(skb);
> >   		return NET_RX_DROP;
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 60d325bda0d7..6ceb6412ee97 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -2189,28 +2189,13 @@ static inline void net_timestamp_set(struct sk_buff *skb)
> >   
> >   bool is_skb_forwardable(const struct net_device *dev, const struct sk_buff *skb)
> >   {
> > -	unsigned int len;
> > -
> > -	if (!(dev->flags & IFF_UP))
> > -		return false;
> > -
> > -	len = dev->mtu + dev->hard_header_len + VLAN_HLEN;
> > -	if (skb->len <= len)
> > -		return true;
> > -
> > -	/* if TSO is enabled, we don't care about the length as the packet
> > -	 * could be forwarded without being segmented before
> > -	 */
> > -	if (skb_is_gso(skb))
> > -		return true;
> > -
> > -	return false;
> > +	return __is_skb_forwardable(dev, skb, true);
> >   }
> >   EXPORT_SYMBOL_GPL(is_skb_forwardable);  
> 
> Only user of is_skb_forwardable() that is left after this patch is bridge, maybe
> the whole thing should be moved into the header?

Well, yes, maybe... I just felt it belongs in another patchset.


> >   int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
> >   {
> > -	int ret = ____dev_forward_skb(dev, skb);
> > +	int ret = ____dev_forward_skb(dev, skb, true);
> >   
> >   	if (likely(!ret)) {
> >   		skb->protocol = eth_type_trans(skb, dev);
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index d6125cfc49c3..4673afe59533 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -2083,13 +2083,21 @@ static const struct bpf_func_proto bpf_csum_level_proto = {
> >   
> >   static inline int __bpf_rx_skb(struct net_device *dev, struct sk_buff *skb)
> >   {
> > -	return dev_forward_skb(dev, skb);
> > +	int ret = ____dev_forward_skb(dev, skb, false);
> > +
> > +	if (likely(!ret)) {
> > +		skb->protocol = eth_type_trans(skb, dev);
> > +		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> > +		ret = netif_rx(skb);  
> 
> Why netif_rx() and not netif_rx_internal() as in dev_forward_skb() originally?
> One extra call otherwise.

This is because the function below calls netif_rx(), which is just
outside patch-diff-window.  Thus, it looked wrong/strange to call
netif_rx_internal(), but sure I can use netif_rx_internal() instead.

> 
> > +	}
> > +
> > +	return ret;
> >   }
> >   
> >   static inline int __bpf_rx_skb_no_mac(struct net_device *dev,
> >   				      struct sk_buff *skb)
> >   {
> > -	int ret = ____dev_forward_skb(dev, skb);
> > +	int ret = ____dev_forward_skb(dev, skb, false);
> >   
> >   	if (likely(!ret)) {
> >   		skb->dev = dev;
> > @@ -2480,7 +2488,7 @@ int skb_do_redirect(struct sk_buff *skb)
> >   			goto out_drop;
> >   		dev = ops->ndo_get_peer_dev(dev);
> >   		if (unlikely(!dev ||
> > -			     !is_skb_forwardable(dev, skb) ||
> > +			     !__is_skb_forwardable(dev, skb, false) ||  
> 
> If we only use __is_skb_forwardable() with false directly here, maybe then
> lets just have the !(dev->flags & IFF_UP) test here instead..

Sure, let do that.

> >   			     net_eq(net, dev_net(dev))))
> >   			goto out_drop;
> >   		skb->dev = dev;
> > 


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

