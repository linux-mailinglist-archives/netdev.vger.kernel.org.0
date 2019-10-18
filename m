Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B084DBA62
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 02:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503752AbfJRABV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 20:01:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44000 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729190AbfJRABV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 20:01:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 273191433FC52;
        Thu, 17 Oct 2019 17:01:21 -0700 (PDT)
Date:   Thu, 17 Oct 2019 17:01:20 -0700 (PDT)
Message-Id: <20191017.170120.984298608358144040.davem@davemloft.net>
To:     weiwan@google.com
Cc:     netdev@vger.kernel.org, idosch@idosch.org, jesse@mbuki-mvuki.org,
        kafai@fb.com, dsahern@gmail.com
Subject: Re: [PATCH net] ipv4: fix race condition between route lookup and
 invalidation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191016190315.151095-1-weiwan@google.com>
References: <20191016190315.151095-1-weiwan@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 17:01:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>
Date: Wed, 16 Oct 2019 12:03:15 -0700

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

Applied and queued up for -stable.
