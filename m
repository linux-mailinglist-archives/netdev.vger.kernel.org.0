Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAD04340B6
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 23:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhJSVn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 17:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhJSVn5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 17:43:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B543961074;
        Tue, 19 Oct 2021 21:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634679703;
        bh=h9rWMFHD9yM2tzMOtQwpsYaC5UHwqMyquTQ/4E5mkf0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u/T+54Jj0i23OAei8dPO8ZFGvWaQZGq1E1hbM8Y/ul7D142u214cwag1FZxa36lTY
         zZTb3gNsYUeTf60AQC+YmWjMB5Tle7L+6fNMzg5Jziab5WjkHFrDJrlPuIglnxwAxl
         E5Fp9v1k6ums/QPbzMRz/CuBkCBME1tnjGjSe5PAkoxYbbA6cPwZUtYFvqvO6hIxhK
         g99oYB5sFn35b2pLFjgxzUb4B5rAaHLYGES5ZNZePy+3PesWNC1NuT1fLTVsVWV7N+
         MkiYCybMaCwpewhYeJ/voDPqlXALED/T+fC2MxP/J3KSksGms4tXFm6MERnasLC2e5
         s6alrCR9ApWMw==
Date:   Tue, 19 Oct 2021 14:41:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>, David Ahern <dsahern@kernel.org>
Cc:     Eugene Crosser <crosser@average.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Lahav Schlesinger <lschlesinger@drivenets.com>
Subject: Re: Commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1r "vrf: Reset
 skb conntrack connection on VRF rcv" breaks expected netfilter behaviour
Message-ID: <20211019144142.5308fc84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211015210448.GA5069@breakpoint.cc>
References: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
        <20211013092235.GA32450@breakpoint.cc>
        <20211015210448.GA5069@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Oct 2021 23:04:48 +0200 Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > 'track' is hard to implement correctly because of RELATED traffic.
> > 
> > E.g. 'tcp dport 22 track' won't work correctly because icmp pmtu
> > won't be handled.
> > 
> > I'd suggest to try a conditional nf_ct_reset that keeps the conntrack
> > entry if its in another zone.
> > 
> > I can't think of another solution at the moment, the existing behaviour
> > of resetting conntrack entry for postrouting/output is too old,
> > otherwise the better solution IMO would be to keep that entry around on
> > egress if a NAT rewrite has been done. This would avoid the 'double snat'
> > problem that the 'reset on ingress' tries to solve.  
> 
> I'm working on this.
> 
> Eugene, I think it makes sense if you send a formal revert, a proper
> fix for snat+vrf needs more work.

If this is still the plan can we get some acks on the revert please?

https://patchwork.kernel.org/project/netdevbpf/patch/20211018182250.23093-2-crosser@average.org/
