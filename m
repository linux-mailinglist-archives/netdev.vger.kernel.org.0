Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D62E6DA590
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 08:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390987AbfJQGYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 02:24:31 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:50151 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727653AbfJQGYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 02:24:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 2D7EC371;
        Thu, 17 Oct 2019 02:24:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 17 Oct 2019 02:24:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=YP1wGi
        dd85LU7NyzQOFhkeqB5Aw8voC3hXvbkm8w4gA=; b=AFd+UGXEciNbnc28YuQjNX
        GP+EpdaQlhVuIturNTJrTU2f2onAmAN8/hf2YqwUJBbajR3HhQIOlMWSEFn+6AxX
        8d8T4xC0ghky44fUX3KOCwLSwu1JozGKlhEd647Hbt/WSiUfQYUXDCK46RHu2SEu
        /1KQSAqiQCoxwAGVKCSo/FCucMqhNTI2ia+GUNLc8nZSM3w22/bS8hZ2r4tkaDDq
        Kv3ai3F+vevxiFMTPkDyTuVmqux/9hvQ0dF17FmXcfvjUwYDK8tC78RGjmw99jyz
        KbP/VsAYYlNtlqz8ztRoOd/5eGKBCRcvZArbZZWGK06uu4qY18BMj2Akl9VZeCJQ
        ==
X-ME-Sender: <xms:HQmoXXcnEEUrjppTg1MSPmnpGcxvtx0f4hlpR25q1r3B3ZFe0GV-0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeeigddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:HQmoXUkuEo1bsWwkwUuEhi0DghR4F4LH-EOuD6sSAE5yTIzFTvZgwA>
    <xmx:HQmoXWFPbV5hKdZQXLy0CfRrIfNt4jqkLuGj3AI8btB0UYmm8gmJQQ>
    <xmx:HQmoXU7Oi6C6AqkXQdf8HYy6J_r5_I-DBGzLUU59GNGbBao2xxgMrg>
    <xmx:HQmoXZBbT3MOtMDF0Bk8C52T5R3Fx0ycnPSK81Ba5iFyA1LPxKFXVA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B2CFFD60057;
        Thu, 17 Oct 2019 02:24:28 -0400 (EDT)
Date:   Thu, 17 Oct 2019 09:24:27 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jesse Hathaway <jesse@mbuki-mvuki.org>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] ipv4: fix race condition between route lookup and
 invalidation
Message-ID: <20191017062427.GA25025@splinter>
References: <20191016190315.151095-1-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016190315.151095-1-weiwan@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 12:03:15PM -0700, Wei Wang wrote:
> Jesse and Ido reported the following race condition:
> <CPU A, t0> - Received packet A is forwarded and cached dst entry is
> taken from the nexthop ('nhc->nhc_rth_input'). Calls skb_dst_set()
> 
> <t1> - Given Jesse has busy routers ("ingesting full BGP routing tables
> from multiple ISPs"), route is added / deleted and rt_cache_flush() is
> called
> 
> <CPU B, t2> - Received packet B tries to use the same cached dst entry
> from t0, but rt_cache_valid() is no longer true and it is replaced in
> rt_cache_route() by the newer one. This calls dst_dev_put() on the
> original dst entry which assigns the blackhole netdev to 'dst->dev'
> 
> <CPU A, t3> - dst_input(skb) is called on packet A and it is dropped due
> to 'dst->dev' being the blackhole netdev
> 
> There are 2 issues in the v4 routing code:
> 1. A per-netns counter is used to do the validation of the route. That
> means whenever a route is changed in the netns, users of all routes in
> the netns needs to redo lookup. v6 has an implementation of only
> updating fn_sernum for routes that are affected.
> 2. When rt_cache_valid() returns false, rt_cache_route() is called to
> throw away the current cache, and create a new one. This seems
> unnecessary because as long as this route does not change, the route
> cache does not need to be recreated.
> 
> To fully solve the above 2 issues, it probably needs quite some code
> changes and requires careful testing, and does not suite for net branch.
> 
> So this patch only tries to add the deleted cached rt into the uncached
> list, so user could still be able to use it to receive packets until
> it's done.
> 
> Fixes: 95c47f9cf5e0 ("ipv4: call dst_dev_put() properly")
> Signed-off-by: Wei Wang <weiwan@google.com>
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Reported-by: Jesse Hathaway <jesse@mbuki-mvuki.org>
> Tested-by: Jesse Hathaway <jesse@mbuki-mvuki.org>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Cc: David Ahern <dsahern@gmail.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
