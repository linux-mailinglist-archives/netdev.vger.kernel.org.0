Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEC32F51BC
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 19:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbhAMSMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 13:12:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbhAMSMx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 13:12:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCA88233ED;
        Wed, 13 Jan 2021 18:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610561532;
        bh=9elX7cNWCe9G39/ZIw1v4prZnJFSz0GD4UUQdqJ6cqE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RgeWmANpXc1zGm081hvR7XF+GkBpB0TC98RrJNkav937ZHj09ykKwwD8xh3/uU97T
         Vt2UhvNZFdwfsOPFEYKH1H9a/ttv4wSLURnfnZrTrfzkNXPjFKl6+tijxAoEbgVAOk
         S2Ptnrzty7BXw0YCJWEoYe9NmIQ2RF1gB0VzBtNeoM2uzsRmUCr8CKix9oNXUx3CdS
         sXLpFNTXSzqFzeXvBczfr3C5qEqCxJKkwfHb856KV8nxGRSTukfB+UFslnUfrYukz6
         g6iAurhru6LdWCrTZ8xJGbfbLh/PhXu5gdqI2ndxW1p+4CXMLNc06OfaSCI+nJ3ggp
         tSge7vUBE9q4g==
Date:   Wed, 13 Jan 2021 10:12:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] skbuff: introduce skbuff_heads bulking and
 reusing
Message-ID: <20210113101210.6d0ad308@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iJeJR+i-WLi=VwNSmWQ2aFepmFO8w6Yh9DQX6hvV4BceA@mail.gmail.com>
References: <20210111182655.12159-1-alobakin@pm.me>
        <d4f4b6ba-fb3b-d873-23b2-4b5ba9cf4db8@gmail.com>
        <20210112110802.3914-1-alobakin@pm.me>
        <CANn89iKEc_8_ySqV+KrbheTDKRL4Ws6JUKYeKXfogJNhfd+pGQ@mail.gmail.com>
        <20210112170242.414b8664@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+ppTAPYwQ2mH5cZtcMqanFU8hXzD4szdygrjOBewPb+Q@mail.gmail.com>
        <20210113090341.74832be9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iJeJR+i-WLi=VwNSmWQ2aFepmFO8w6Yh9DQX6hvV4BceA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 18:15:20 +0100 Eric Dumazet wrote:
> > IDK much about MM, but we already have a kmem_cache for skbs and now
> > we're building a cache on top of a cache.  Shouldn't MM take care of
> > providing a per-CPU BH-only lockless cache?  
> 
> I think part of the improvement comes from bulk operations, which are
> provided by mm layer.
> 
> I also note Alexander made no provision for NUMA awareness.
> Probably reusing skb located on a remote node will not be ideal.

I was wondering about that yesterday, but couldn't really think 
of a legitimate reason not to have XPS set up right. Do you have
particular config in mind, or are we taking "default config"?

Also can't the skb _itself_ be pfmemalloc?

My main point is that I'm wondering if this sort of cache would be
useful when allocating skbs for sockets? Assuming that the network
stack is not isolated to its own cores, won't fronting alloc_skb() 
with 

	bh_disable() 
	try the cache
	bh_enable()

potentially help? In that sense fronting kmem_cache would feel cleaner
than our own little ring buffer.
