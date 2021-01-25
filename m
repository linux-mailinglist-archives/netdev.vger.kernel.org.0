Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE98302765
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 17:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbhAYQBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 11:01:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47025 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728948AbhAYQAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:00:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611590334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FjO7IzXQfUSbflOYOdqxjoPa6fZg3R1AGbOy1QaC80k=;
        b=hQJwr5Z7qUY+YVCb4sWOlt4wnLq2dE1yuJbowO74CetMQ5NJWt+C7o58DQfoOopKneFWHl
        eGqmi5/mrdqHsrTxP6XDkL7r+8X11tPH2Io3V9Q58l1zjaVk1kGEzKZJsD3R8T3W8eAPU4
        /O2ZHTbOQlhrHLB0lIbZMBKiCtkAQpE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-p90vs-uoMuqicxcFY4TL4Q-1; Mon, 25 Jan 2021 10:58:50 -0500
X-MC-Unique: p90vs-uoMuqicxcFY4TL4Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04996104F958;
        Mon, 25 Jan 2021 15:58:48 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E30601045D22;
        Mon, 25 Jan 2021 15:58:35 +0000 (UTC)
Date:   Mon, 25 Jan 2021 16:58:34 +0100
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
Subject: Re: [PATCH bpf-next V12 2/7] bpf: fix bpf_fib_lookup helper MTU
 check for SKB ctx
Message-ID: <20210125165834.558f7fe1@carbon>
In-Reply-To: <06f94963-f16b-3339-abf2-6529b474a2f6@iogearbox.net>
References: <161098881526.108067.7603213364270807261.stgit@firesoul>
        <161098885996.108067.14467274374916086727.stgit@firesoul>
        <06f94963-f16b-3339-abf2-6529b474a2f6@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jan 2021 02:47:28 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 1/18/21 5:54 PM, Jesper Dangaard Brouer wrote:
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
> > V10:
> > - Use same method as XDP for 'tot_len' MTU check
> > 
> > Fixes: 4c79579b44b1 ("bpf: Change bpf_fib_lookup to return lookup status")
> > Reported-by: Carlo Carraro <colrack@gmail.com>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >   net/core/filter.c |   13 ++++++++++---
> >   1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 5beadd659091..d5e6f395cf64 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -5569,6 +5569,7 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
> >   {
> >   	struct net *net = dev_net(skb->dev);
> >   	int rc = -EAFNOSUPPORT;
> > +	bool check_mtu = false;
> >   
> >   	if (plen < sizeof(*params))
> >   		return -EINVAL;
> > @@ -5576,22 +5577,28 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
> >   	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
> >   		return -EINVAL;
> >   
> > +	if (params->tot_len)
> > +		check_mtu = true;
> > +
> >   	switch (params->family) {
> >   #if IS_ENABLED(CONFIG_INET)
> >   	case AF_INET:
> > -		rc = bpf_ipv4_fib_lookup(net, params, flags, false);
> > +		rc = bpf_ipv4_fib_lookup(net, params, flags, check_mtu);
> >   		break;
> >   #endif
> >   #if IS_ENABLED(CONFIG_IPV6)
> >   	case AF_INET6:
> > -		rc = bpf_ipv6_fib_lookup(net, params, flags, false);
> > +		rc = bpf_ipv6_fib_lookup(net, params, flags, check_mtu);
> >   		break;
> >   #endif
> >   	}
> >   
> > -	if (!rc) {
> > +	if (rc == BPF_FIB_LKUP_RET_SUCCESS && !check_mtu) {
> >   		struct net_device *dev;
> >   
> > +		/* When tot_len isn't provided by user,
> > +		 * check skb against net_device MTU
> > +		 */
> >   		dev = dev_get_by_index_rcu(net, params->ifindex);
> >   		if (!is_skb_forwardable(dev, skb))
> >   			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;  
> 
> Btw, looking at some of the old feedback, looks like [0] got missed somehow. Would
> be nice if we could simplify this rather ugly bit with refetching dev for tc.
> 
>    [0] https://lore.kernel.org/bpf/f959017b-5d3c-5cdb-a016-c467a3c9a2fc@iogearbox.net/
>        https://lore.kernel.org/bpf/f8ff26f0-b1b6-6dd1-738d-4c592a8efdb0@gmail.com/

I have tried to incorporate the ideas from [0].  If you notice this
code path is only called in-case params->tot_len is zero (!check_mtu).
Then if params->tot_len does contain something, then the check_mtu code
path of bpf_ipv4_fib_lookup() and bpf_ipv6_fib_lookup().

I agree, that it is ugly refetching dev.  I'll look at moving the
lookup dev_get_by_index_rcu() call one level-up, as both
bpf_ipv4_fib_lookup() and bpf_ipv6_fib_lookup() does this call. (I
cannot move the check into the functions due skb is not avail in XDP
case)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

