Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C71313492
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhBHOIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:08:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232131AbhBHN7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:59:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612792648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z66ZKmmlAo5XkGXYiEacOsB+4kzMmQWYANVJg2K54PI=;
        b=Yr2663f23zcuO5lmmPKyWb6ukkGGTCR+tbY5SLzoRDZXZPaLh7OJqIqhlnGJWlvSRXpN02
        N06l453e1d/suqd4KnYdlAqcfKI9hj8bgz7GG4Bdh7YTnHxf2mp+yFKAkNIQgbhPz3Bxge
        p8fJj6W67+Uvh0ILkYwekzxaxIHXOvU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-VYRHtGkqOx-OcllBatt2PA-1; Mon, 08 Feb 2021 08:57:24 -0500
X-MC-Unique: VYRHtGkqOx-OcllBatt2PA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE00A427CC;
        Mon,  8 Feb 2021 13:57:21 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB6091002393;
        Mon,  8 Feb 2021 13:57:14 +0000 (UTC)
Date:   Mon, 8 Feb 2021 14:57:13 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH bpf-next V15 2/7] bpf: fix bpf_fib_lookup helper MTU
 check for SKB ctx
Message-ID: <20210208145713.4ee3e9ba@carbon>
In-Reply-To: <ada19e5b-87be-ff39-45ba-ff0025bf1de9@iogearbox.net>
References: <161228314075.576669.15427172810948915572.stgit@firesoul>
        <161228321177.576669.11521750082473556168.stgit@firesoul>
        <ada19e5b-87be-ff39-45ba-ff0025bf1de9@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Feb 2021 01:06:35 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 2/2/21 5:26 PM, Jesper Dangaard Brouer wrote:
> > BPF end-user on Cilium slack-channel (Carlo Carraro) wants to use
> > bpf_fib_lookup for doing MTU-check, but *prior* to extending packet size,
> > by adjusting fib_params 'tot_len' with the packet length plus the expected
> > encap size. (Just like the bpf_check_mtu helper supports). He discovered
> > that for SKB ctx the param->tot_len was not used, instead skb->len was used
> > (via MTU check in is_skb_forwardable() that checks against netdev MTU).
> > 
> > Fix this by using fib_params 'tot_len' for MTU check. If not provided (e.g.
> > zero) then keep existing TC behaviour intact. Notice that 'tot_len' for MTU
> > check is done like XDP code-path, which checks against FIB-dst MTU.
> > 
> > V13:
> > - Only do ifindex lookup one time, calling dev_get_by_index_rcu().
> > 
> > V10:
> > - Use same method as XDP for 'tot_len' MTU check
> > 
> > Fixes: 4c79579b44b1 ("bpf: Change bpf_fib_lookup to return lookup status")
> > Reported-by: Carlo Carraro <colrack@gmail.com>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Acked-by: John Fastabend <john.fastabend@gmail.com>  
> [...]
> 
> I was about to apply the series just now, but on a last double check there is
> a subtle logic bug in here that still needs fixing unfortunately. :/ See below:
> 
> > @@ -5568,7 +5565,9 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
> >   	   struct bpf_fib_lookup *, params, int, plen, u32, flags)
> >   {
> >   	struct net *net = dev_net(skb->dev);
> > +	struct net_device *dev;
> >   	int rc = -EAFNOSUPPORT;
> > +	bool check_mtu = false;
> >   
> >   	if (plen < sizeof(*params))
> >   		return -EINVAL;
> > @@ -5576,23 +5575,30 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
> >   	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
> >   		return -EINVAL;
> >   
> > +	dev = dev_get_by_index_rcu(net, params->ifindex);
> > +	if (unlikely(!dev))
> > +		return -ENODEV;  
> 
> Based on your earlier idea, you try to avoid refetching the dev this way, so
> here it's being looked up via params->ifindex provided from the BPF prog ...
> 
> > +	if (params->tot_len)
> > +		check_mtu = true;
> > +
> >   	switch (params->family) {
> >   #if IS_ENABLED(CONFIG_INET)
> >   	case AF_INET:
> > -		rc = bpf_ipv4_fib_lookup(net, params, flags, false);
> > +		rc = bpf_ipv4_fib_lookup(net, dev, params, flags, check_mtu);  
> 
> ... however, bpf_ipv{4,6}_fib_lookup() might change params->ifindex here to
> indicate nexthop output dev:
> 
> [...]
>          dev = nhc->nhc_dev;
> 
>          params->rt_metric = res.fi->fib_priority;
>          params->ifindex = dev->ifindex;
> [...]

I want to hear David Ahern, what cases does this cover?


> >   		break;
> >   #endif
> >   #if IS_ENABLED(CONFIG_IPV6)
> >   	case AF_INET6:
> > -		rc = bpf_ipv6_fib_lookup(net, params, flags, false);
> > +		rc = bpf_ipv6_fib_lookup(net, dev, params, flags, check_mtu);
> >   		break;
> >   #endif
> >   	}
> >   
> > -	if (!rc) {
> > -		struct net_device *dev;
> > -
> > -		dev = dev_get_by_index_rcu(net, params->ifindex);
> > +	if (rc == BPF_FIB_LKUP_RET_SUCCESS && !check_mtu) {
> > +		/* When tot_len isn't provided by user,
> > +		 * check skb against net_device MTU
> > +		 */
> >   		if (!is_skb_forwardable(dev, skb))
> >   			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;  
> 
> ... so using old cached dev from above will result in wrong MTU check &
> subsequent passing of wrong params->mtu_result = dev->mtu this way. 

Yes, you are right, params->ifindex have a chance to change in the calls.
So, our attempt to save an ifindex lookup (dev_get_by_index_rcu) is not
correct.

> So one
> way to fix is that we would need to pass &dev to bpf_ipv{4,6}_fib_lookup().

Ok, I will try to code it up, and see how ugly it looks, but I'm no
longer sure that it is worth saving this ifindex lookup, as it will
only happen if BPF-prog didn't specify params->tot_len.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

