Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D26F244C2B
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 17:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgHNPcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 11:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:32864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbgHNPbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 11:31:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4A5920716;
        Fri, 14 Aug 2020 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597419115;
        bh=jOHBxpiEEXCGJcWu6VassLagL4Xk2l1CNFHOrYO+bYY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j26cARGS4bXxo0wmWQl2ZMdAn6Bi1i4ehSN4fj5RCb8Las0LxyegZCBvC/IWKjZ25
         vmA3N6EMCa95LLiHKACM5BLx4iCspOQqAkTdaCQy0spXCoPRmM9F1WUg4jgYkTyIrb
         2f+RKUCsSBpZ7hhAKR5M7ocgXtKwpjOcfiz1VCOs=
Date:   Fri, 14 Aug 2020 08:31:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Thomas Ptacek <thomas@sockpuppet.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH net v4] net: xdp: account for layer 3 packets in generic
 skb handler
Message-ID: <20200814083153.06b180b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHmME9rbRrdV0ePxT0DgurGdEKOWiEi5mH5Wtg=aJwSA6fxwMg@mail.gmail.com>
References: <20200813195816.67222-1-Jason@zx2c4.com>
        <20200813140152.1aab6068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAHmME9rbRrdV0ePxT0DgurGdEKOWiEi5mH5Wtg=aJwSA6fxwMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Aug 2020 08:56:48 +0200 Jason A. Donenfeld wrote:
> On Thu, Aug 13, 2020 at 11:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > I had originally dropped this patch, but the issue kept coming up in
> > > user reports, so here's a v4 of it. Testing of it is still rather slim,
> > > but hopefully that will change in the coming days.  
> >
> > Here an alternative patch, untested:  
> 
> Funny. But come on now... Why would we want to deprive our users of
> system consistency?

We should try for consistency between xdp and cls_bpf instead.

> Doesn't it make sense to allow users to use the same code across
> interfaces? You actually want them to rewrite their code to use a
> totally different trigger point just because of some weird kernel
> internals between interfaces?

We're not building an abstraction over the kernel stack so that users
won't have to worry how things work. Users need to have a minimal
understanding of how specific hooks integrate with the stack and what
they are for. And therefore why cls_bpf is actually more efficient to
use in L3 tunnel case.

> Why not make XDP more useful and more generic across interfaces? It's
> very common for systems to be receiving packets with a heavy ethernet
> card from the current data center, in addition to receiving packets
> from a tunnel interface connected to a remote data center, with a need
> to run the same XDP program on both interfaces. Why not support that
> kind of simplicity?
> 
> This is _actually_ something that's come up _repeatedly_. This is a
> real world need from real users who are doing real things. Why not
> help them?

I'm sure it comes up repeatedly because we don't return any errors,
so people waste time investigating why it doesn't work.

> It's not at the expense of any formal consistency, or performance, or
> even semantic perfection. It costs very little to support these
> popular use cases.
