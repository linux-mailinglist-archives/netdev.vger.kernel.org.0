Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A5D2ADC60
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 17:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgKJQrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 11:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgKJQrn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 11:47:43 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05C792065E;
        Tue, 10 Nov 2020 16:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605026862;
        bh=12E6sYuP2ocgXFAGDtoCKHD6UZRsfne45YEVqj28+ig=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qLruM1MRCqsp+eNDUtRJ906k8VOGbwO6VpEka9s44hTTXGVNvTqzr17RnQSRuD4G5
         WIpFOLUul4LHnObIOVLY/Q2YG0/BQlo8J4pq5GqG17vHPNFcBdE6WzCzM+byFg2dmD
         0xz+hpSi7NQDh/U3tC6nXmNG6XdrU9xjZIRO35wQ=
Date:   Tue, 10 Nov 2020 08:47:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org,
        jchapman@katalix.com
Subject: Re: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Message-ID: <20201110084740.3e3418c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110092834.GA30007@linux.home>
References: <20201106181647.16358-1-tparkin@katalix.com>
        <20201109155237.69c2b867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201110092834.GA30007@linux.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 10:28:34 +0100 Guillaume Nault wrote:
> On Mon, Nov 09, 2020 at 03:52:37PM -0800, Jakub Kicinski wrote:
> > On Fri,  6 Nov 2020 18:16:45 +0000 Tom Parkin wrote:  
> > > This small RFC series implements a suggestion from Guillaume Nault in
> > > response to my previous submission to add an ac/pppoe driver to the l2tp
> > > subsystem[1].
> > > 
> > > Following Guillaume's advice, this series adds an ioctl to the ppp code
> > > to allow a ppp channel to be bridged to another.  Quoting Guillaume:
> > > 
> > > "It's just a matter of extending struct channel (in ppp_generic.c) with
> > > a pointer to another channel, then testing this pointer in ppp_input().
> > > If the pointer is NULL, use the classical path, if not, forward the PPP
> > > frame using the ->start_xmit function of the peer channel."
> > > 
> > > This allows userspace to easily take PPP frames from e.g. a PPPoE
> > > session, and forward them over a PPPoL2TP session; accomplishing the
> > > same thing my earlier ac/pppoe driver in l2tp did but in much less code!  
> > 
> > I have little understanding of the ppp code, but I can't help but
> > wonder why this special channel connection is needed? We have great
> > many ways to redirect traffic between interfaces - bpf, tc, netfilter,
> > is there anything ppp specific that is required here?  
> 
> I can see two viable ways to implement this feature. The one described
> in this patch series is the simplest. The reason why it doesn't reuse
> existing infrastructure is because it has to work at the link layer
> (no netfilter) and also has to work on PPP channels (no network
> device).
> 
> The alternative, is to implement a virtual network device for the
> protocols we want to support (at least PPPoE and L2TP, maybe PPTP)
> and teach tunnel_key about them. Then we could use iproute2 commands
> like:
>  # ip link add name pppoe0 up type pppoe external
>  # ip link add name l2tp0 up type l2tp external
>  # tc qdisc add dev pppoe0 ingress
>  # tc qdisc add dev l2tp0 ingress
>  # tc filter add dev pppoe0 ingress matchall                        \
>      action tunnel_key set l2tp_version 2 l2tp_tid XXX l2tp_sid YYY \
>      action mirred egress redirect dev pppoe0
>  # tc filter add dev l2tp0 ingress matchall  \
>      action tunnel_key set pppoe_sid ZZZ     \
>      action mirred egress redirect dev l2tp0
> 
> Note: I've used matchall for simplicity, but a real uses case would
> have to filter on the L2TP session and tunnel IDs and on the PPPoE
> session ID.
> 
> As I said in my reply to the original thread, I like this idea, but
> haven't thought much about the details. So there might be some road
> blocks. Beyond modernising PPP and making it better integrated into the
> stack, that should also bring the possibility of hardware offload (but
> would any NIC vendor be interested?).

Integrating with the stack gives you access to all its features, other
types of encap, firewalling, bpf, etc.

> I think the question is more about long term maintainance. Do we want
> to keep PPP related module self contained, with low maintainance code
> (the current proposal)? Or are we willing to modernise the
> infrastructure, add support and maintain PPP features in other modules
> like flower, tunnel_key, etc.?

Right, it's really not great to see new IOCTLs being added to drivers,
but the alternative would require easily 50 times more code.
 
> Of course, I might have missed other ways to implement this feature.
> But that's all I could think of for now.
> 
> And if anyone wants a quick recap about PPP (what are these PPP channel
> and unit things? what's the relationship between PPPoE, L2TP and PPP?
> etc.), just let me know.

Some pointers would be appreciated if you don't mind :)
