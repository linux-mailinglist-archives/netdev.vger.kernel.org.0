Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95AB64CD4A
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 13:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731655AbfFTL4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 07:56:48 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:36226 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726392AbfFTL4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 07:56:47 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hdvgM-0007va-17; Thu, 20 Jun 2019 13:56:46 +0200
Date:   Thu, 20 Jun 2019 13:56:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [RFC bpf-next 0/7] Programming socket lookup with BPF
Message-ID: <20190620115646.zrt5brpqxtniczhx@breakpoint.cc>
References: <20190618130050.8344-1-jakub@cloudflare.com>
 <20190618135258.spo6c457h6dfknt2@breakpoint.cc>
 <87sgs6ey43.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sgs6ey43.fsf@cloudflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki <jakub@cloudflare.com> wrote:
> > Sorry for the question, but where is the problem?
> > (i.e., is it with TPROXY or bpf side)?
> 
> The way I see it is that the problem is that we have mappings for
> steering traffic into sockets split between two places: (1) the socket
> lookup tables, and (2) the TPROXY rules.
> 
> BPF programs that need to check if there is a socket the packet is
> destined for have access to the socket lookup tables, via the mentioned
> bpf_sk_lookup helper, but are unaware of TPROXY redirects.

Oh, right.

[ TPROXY setup ]

Thanks for sharing, it will take me some time to digest this.
It would be good to have a simpler way to express this.

> One thing I haven't touched on in the cover letter is that to use TPROXY
> you need to set IP_TRANSPARENT on the listening socket. This requires
> that your process runs with CAP_NET_RAW or CAP_NET_ADMIN, or that you
> get the socket from systemd.
> 
> I haven't been able to explain why the process needs to be privileged to
> receive traffic steered with TPROXY, but it turns out to be a pain point
> too. We end up having to lock down the service to ensure it doesn't use
> the elevated privileges for anything else than setting IP_TRANSPARENT.

Marek thinks its security measure:
1. TPROXY rule to redirect 80 to 8080 is added
2. UNPRIV binds 8080 -> Unpriv can then intercept packets for privileged
    port (it can't, as TPROXY rule refuses to redirect to sk that did not
    have IP_TRANSPARENT set).

AFAICS purely from stack pov, it sets IP_REPLY_ARG_NOSRCCHECK which in
turn sets FLOWI_FLAG_ANYSRC which bypasses a "fl->saddr is configured on
this machine" check in ip_route_output_key_hash_rcu.

I did not yet find similar entanglement for ipv6, will check.
