Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B033926B25A
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbgIOWqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbgIOWqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 18:46:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B69C06174A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 15:46:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0B36913B5D1B4;
        Tue, 15 Sep 2020 15:29:31 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:46:18 -0700 (PDT)
Message-Id: <20200915.154618.670584666009270972.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mastertheknife@gmail.com
Subject: Re: [PATCH net] ipv4: Update exception handling for multipath
 routes via same device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915030354.38468-1-dsahern@kernel.org>
References: <20200915030354.38468-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 15:29:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Mon, 14 Sep 2020 21:03:54 -0600

> Kfir reported that pmtu exceptions are not created properly for
> deployments where multipath routes use the same device.
> 
> After some digging I see 2 compounding problems:
> 1. ip_route_output_key_hash_rcu is updating the flowi4_oif *after*
>    the route lookup. This is the second use case where this has
>    been a problem (the first is related to use of vti devices with
>    VRF). I can not find any reason for the oif to be changed after the
>    lookup; the code goes back to the start of git. It does not seem
>    logical so remove it.
> 
> 2. fib_lookups for exceptions do not call fib_select_path to handle
>    multipath route selection based on the hash.
> 
> The end result is that the fib_lookup used to add the exception
> always creates it based using the first leg of the route.
 ...
> Before this patch the cache always shows exceptions against the first
> leg in the multipath route; 192.168.252.250 per this example. Since the
> hash has an initial random seed, you may need to vary the final octet
> more than what is listed. In my tests, using addresses between 11 and 19
> usually found 1 that used both legs.
> 
> With this patch, the cache will have exceptions for both legs.
> 
> Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions")
> Reported-by: Kfir Itzhak <mastertheknife@gmail.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>

Applied and queued up for -stable, thanks David.

The example topology and commands look like a good addition for
selftests perhaps?

Thanks again.
