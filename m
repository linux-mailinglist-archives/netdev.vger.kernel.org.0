Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D71412A05
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 02:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbhIUAnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 20:43:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231816AbhIUAlS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 20:41:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5835D611ED;
        Tue, 21 Sep 2021 00:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632184790;
        bh=LWIBgUoLQmqJvINyM9f79iyU619wxm4K/eAPWEmXG/Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MDL7M/tzJ+BIS0DLb6ymvBGg1n+3L5RT13G1wWfthxuGqJZJP0hScPb+6QPaCLC9L
         U07PEy3oV4GSLYk+BhiDXtkkhAn2sosffYWQ5p5RbTH9LjDvGi66ht+NjHRj/CyXQQ
         Z5hKq2AuEVBL4XPLc2xrFQonI+dpMjg0pbMN86uInHrls2XG1HhzqXwVRFXw4sqp9Y
         +GIE8u/C5MJrZRY19FovVfK0BuOL69cMlN++tsSQaiTgYCUFkjIWFKfoJFA2tJAzGv
         5x1zh57Gv27aNVvs2B/1CHnLo1GSUXRiYFGm43JaNB+6Qc2tAz0qEQTCFAd1AZUDb8
         hs1fPsyZVqcLg==
Date:   Mon, 20 Sep 2021 17:39:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org,
        Christoph Paasch <christoph.paasch@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>
Subject: Re: [RFC net v7] net: skb_expand_head() adjust skb->truesize
 incorrectly
Message-ID: <20210920173949.7e060848@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c4d204a5-f3f1-e505-4206-26dfd1c097f1@virtuozzo.com>
References: <20210917162418.1437772-1-kuba@kernel.org>
        <b38881fc-7dbf-8c5f-92b8-5fa1afaade0c@virtuozzo.com>
        <20210920111259.18f9cc01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c4d204a5-f3f1-e505-4206-26dfd1c097f1@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Sep 2021 00:41:15 +0300 Vasily Averin wrote:
> > Thanks for taking a look. I would prefer not to bake any ideas about
> > the skb's function into generic functions. Enumerating every destructor
> > callback in generic code is impossible (technically so, since the code
> > may reside in modules).
> > 
> > Let me think about it. Perhaps we can extend sock callbacks with
> > skb_sock_inherit, and skb_adjust_trusize? That'd transfer the onus of
> > handling the adjustments done on splitting to the protocols. I'll see
> > if that's feasible unless someone can immediately call this path
> > ghastly.  
> 
> This is similar to Alexey Kuznetsov's suggestion for me, 
> see https://lkml.org/lkml/2021/8/27/460

Interesting, I wasn't thinking of keeping the ops pointer in every skb.

> However I think we can do it later,
> right now we need to fix somehow broken skb_expand_head(),
> please take look at v8.

I think v8 still has the issue that Eric was explaining over and over.
