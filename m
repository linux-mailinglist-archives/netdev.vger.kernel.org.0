Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049491C1E0D
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 21:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgEATrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 15:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgEATrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 15:47:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE12C061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 12:47:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0754C14C1A0AD;
        Fri,  1 May 2020 12:47:13 -0700 (PDT)
Date:   Fri, 01 May 2020 12:47:13 -0700 (PDT)
Message-Id: <20200501.124713.1763767482562707777.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, eric.dumazet@gmail.com,
        nikolay@cumulusnetworks.com
Subject: Re: [PATCH v2 net] ipv6: Use global sernum for dst validation with
 nexthop objects
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200501145308.48766-1-dsahern@kernel.org>
References: <20200501145308.48766-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 12:47:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Fri,  1 May 2020 08:53:08 -0600

> Nik reported a bug with pcpu dst cache when nexthop objects are
> used illustrated by the following:
 ...
> Conversion of FIB entries to work with external nexthop objects
> missed an important difference between IPv4 and IPv6 - how dst
> entries are invalidated when the FIB changes. IPv4 has a per-network
> namespace generation id (rt_genid) that is bumped on changes to the FIB.
> Checking if a dst_entry is still valid means comparing rt_genid in the
> rtable to the current value of rt_genid for the namespace.
> 
> IPv6 also has a per network namespace counter, fib6_sernum, but the
> count is saved per fib6_node. With the per-node counter only dst_entries
> based on fib entries under the node are invalidated when changes are
> made to the routes - limiting the scope of invalidations. IPv6 uses a
> reference in the rt6_info, 'from', to track the corresponding fib entry
> used to create the dst_entry. When validating a dst_entry, the 'from'
> is used to backtrack to the fib6_node and check the sernum of it to the
> cookie passed to the dst_check operation.
> 
> With the inline format (nexthop definition inline with the fib6_info),
> dst_entries cached in the fib6_nh have a 1:1 correlation between fib
> entries, nexthop data and dst_entries. With external nexthops, IPv6
> looks more like IPv4 which means multiple fib entries across disparate
> fib6_nodes can all reference the same fib6_nh. That means validation
> of dst_entries based on external nexthops needs to use the IPv4 format
> - the per-network namespace counter.
> 
> Add sernum to rt6_info and set it when creating a pcpu dst entry. Update
> rt6_get_cookie to return sernum if it is set and update dst_check for
> IPv6 to look for sernum set and based the check on it if so. Finally,
> rt6_get_pcpu_route needs to validate the cached entry before returning
> a pcpu entry (similar to the rt_cache_valid calls in __mkroute_input and
> __mkroute_output for IPv4).
> 
> This problem only affects routes using the new, external nexthops.
> 
> Thanks to the kbuild test robot for catching the IS_ENABLED needed
> around rt_genid_ipv6 before I sent this out.
> 
> Fixes: 5b98324ebe29 ("ipv6: Allow routes to use nexthop objects")
> Reported-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>
> Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Tested-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Applied and queued up for -stable, thanks David.
