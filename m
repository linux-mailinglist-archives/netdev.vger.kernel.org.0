Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D2D31396D
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 17:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbhBHQ3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 11:29:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45530 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233837AbhBHQ2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 11:28:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612801644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K9lNJnNNY1Fz7QWSI+VzlyuLnjOEnPi/oNdJ+JCAbmg=;
        b=Io/fozKcSDRnWpLhN9sjVOMbh33JzDnnyGOQNPEUnlKFo4CIic4+SenO0DMZXsaDXTCofH
        NwOaGsE38fpJH9Ok6t/sEszF5i7uxwURDnrwIG5BHPicTtKLqIoTk3aAucjnezoK98noWe
        +Wmx3elA8oYmyxkdS6iRy++VQWtMMH8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-SQ-Af8sWOo6gFa4yt4oVwQ-1; Mon, 08 Feb 2021 11:27:20 -0500
X-MC-Unique: SQ-Af8sWOo6gFa4yt4oVwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFABF79EC0;
        Mon,  8 Feb 2021 16:27:17 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D3F76085D;
        Mon,  8 Feb 2021 16:27:10 +0000 (UTC)
Date:   Mon, 8 Feb 2021 17:27:09 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, David Ahern <dsahern@kernel.org>,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next V15 2/7] bpf: fix bpf_fib_lookup helper MTU
 check for SKB ctx
Message-ID: <20210208172709.15415a46@carbon>
In-Reply-To: <547131a3-5125-d419-8e61-0fc675d663a8@iogearbox.net>
References: <161228314075.576669.15427172810948915572.stgit@firesoul>
        <161228321177.576669.11521750082473556168.stgit@firesoul>
        <ada19e5b-87be-ff39-45ba-ff0025bf1de9@iogearbox.net>
        <20210208145713.4ee3e9ba@carbon>
        <20210208162056.44b0236e@carbon>
        <547131a3-5125-d419-8e61-0fc675d663a8@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Feb 2021 16:41:24 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 2/8/21 4:20 PM, Jesper Dangaard Brouer wrote:
> > On Mon, 8 Feb 2021 14:57:13 +0100
> > Jesper Dangaard Brouer <brouer@redhat.com> wrote:  
> >> On Fri, 5 Feb 2021 01:06:35 +0100
> >> Daniel Borkmann <daniel@iogearbox.net> wrote:  
> >>> On 2/2/21 5:26 PM, Jesper Dangaard Brouer wrote:  
> >>>> BPF end-user on Cilium slack-channel (Carlo Carraro) wants to use
> >>>> bpf_fib_lookup for doing MTU-check, but *prior* to extending packet size,
> >>>> by adjusting fib_params 'tot_len' with the packet length plus the expected
> >>>> encap size. (Just like the bpf_check_mtu helper supports). He discovered
> >>>> that for SKB ctx the param->tot_len was not used, instead skb->len was used
> >>>> (via MTU check in is_skb_forwardable() that checks against netdev MTU).
> >>>>
> >>>> Fix this by using fib_params 'tot_len' for MTU check. If not provided (e.g.
> >>>> zero) then keep existing TC behaviour intact. Notice that 'tot_len' for MTU
> >>>> check is done like XDP code-path, which checks against FIB-dst MTU.  
> [...]
> >>>> -	if (!rc) {
> >>>> -		struct net_device *dev;
> >>>> -
> >>>> -		dev = dev_get_by_index_rcu(net, params->ifindex);
> >>>> +	if (rc == BPF_FIB_LKUP_RET_SUCCESS && !check_mtu) {
> >>>> +		/* When tot_len isn't provided by user,
> >>>> +		 * check skb against net_device MTU
> >>>> +		 */
> >>>>    		if (!is_skb_forwardable(dev, skb))
> >>>>    			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;  
> >>>
> >>> ... so using old cached dev from above will result in wrong MTU check &
> >>> subsequent passing of wrong params->mtu_result = dev->mtu this way.  
> >>
> >> Yes, you are right, params->ifindex have a chance to change in the calls.
> >> So, our attempt to save an ifindex lookup (dev_get_by_index_rcu) is not
> >> correct.
> >>  
> >>> So one
> >>> way to fix is that we would need to pass &dev to bpf_ipv{4,6}_fib_lookup().  
> >>
> >> Ok, I will try to code it up, and see how ugly it looks, but I'm no
> >> longer sure that it is worth saving this ifindex lookup, as it will
> >> only happen if BPF-prog didn't specify params->tot_len.  
> > 
> > I guess we can still do this as an "optimization", but the dev/ifindex
> > will very likely be another at this point.  
> 
> I would say for sake of progress, lets ship your series w/o this optimization so
> it can land, and we revisit this later on independent from here. 

I would really really like to make progress for this patchset.  I
unfortunately finished coding this up (and tested with selftests)
before I noticed this request (without optimizations).

I guess, I can revert my recent work by pulling in V12 of the patch.
I'll do it tomorrow, as I want to have time to run my tests before
re-sending patchset.

> Actually DavidA back then acked the old poc patch I posted, so maybe
> that's worth a revisit as well but needs more testing first.

Yes, we can always revisit this as an optimization.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

