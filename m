Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0024C21603C
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgGFUYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFUYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:24:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E83C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:24:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC648120F19C5;
        Mon,  6 Jul 2020 13:24:49 -0700 (PDT)
Date:   Mon, 06 Jul 2020 13:24:49 -0700 (PDT)
Message-Id: <20200706.132449.437332703151179232.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, brak@choopa.com
Subject: Re: [PATCH v2 net] ipv6: fib6_select_path can not use out path for
 nexthop objects
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706174507.18556-1-dsahern@kernel.org>
References: <20200706174507.18556-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 13:24:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Mon,  6 Jul 2020 11:45:07 -0600

> Brian reported a crash in IPv6 code when using rpfilter with a setup
> running FRR and external nexthop objects. The root cause of the crash
> is fib6_select_path setting fib6_nh in the result to NULL because of
> an improper check for nexthop objects.
> 
> More specifically, rpfilter invokes ip6_route_lookup with flowi6_oif
> set causing fib6_select_path to be called with have_oif_match set.
> fib6_select_path has early check on have_oif_match and jumps to the
> out label which presumes a builtin fib6_nh. This path is invalid for
> nexthop objects; for external nexthops fib6_select_path needs to just
> return if the fib6_nh has already been set in the result otherwise it
> returns after the call to nexthop_path_fib6_result. Update the check
> on have_oif_match to not bail on external nexthops.
> 
> Update selftests for this problem.
> 
> Fixes: f88d8ea67fbd ("ipv6: Plumb support for nexthop object in a fib6_info")
> Reported-by: Brian Rak <brak@choopa.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
> v2
> - for multipath nexthops path may already be set; do not want to
>   overwrite that selection based on hash

Applied and queued up for -stable, thanks David.
