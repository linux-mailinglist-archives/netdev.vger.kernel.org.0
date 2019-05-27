Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDD122ADEC
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 07:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfE0FNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 01:13:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50686 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfE0FNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 01:13:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB2E2148F81BA;
        Sun, 26 May 2019 22:13:39 -0700 (PDT)
Date:   Sun, 26 May 2019 22:13:39 -0700 (PDT)
Message-Id: <20190526.221339.976052988282727359.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] selftest: Fixes for icmp_redirect test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190524233707.19509-1-dsahern@kernel.org>
References: <20190524233707.19509-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 22:13:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Fri, 24 May 2019 16:37:07 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> I was really surprised that the IPv6 mtu exception followed by redirect
> test was passing as nothing about the code suggests it should. The problem
> is actually with the logic in the test script.
> 
> Fix the test cases as follows:
> 1. add debug function to dump the initial and redirect gateway addresses
>    for ipv6. This is shown only in verbose mode. It helps verify the
>    output of 'route get'.
> 
> 2. fix the check_exception logic for the reset case to make sure that
>    for IPv4 neither mtu nor redirect appears in the 'route get' output.
>    For IPv6, make sure mtu is not present and the gateway is the initial
>    R1 lladdr.
> 
> 3. fix the reset logic by using a function to delete the routes added by
>    initial_route_*. This format works better for the nexthop version of
>    the tests.
> 
> While improving the test cases, go ahead and ensure that forwarding is
> disabled since IPv6 redirect requires it.
> 
> Also, runs with kernel debugging enabled sometimes show a failure with
> one of the ipv4 tests, so spread the pings over longer time interval.
> 
> The end result is that 2 tests now show failures:
> 
> TEST: IPv6: mtu exception plus redirect                    [FAIL]
> 
> and the VRF version.
> 
> This is a bug in the IPv6 logic that will need to be fixed
> separately. Redirect followed by MTU works because __ip6_rt_update_pmtu
> hits the 'if (!rt6_cache_allowed_for_pmtu(rt6))' path and updates the
> mtu on the exception rt6_info.
> 
> MTU followed by redirect does not have this logic. rt6_do_redirect
> creates a new exception and then rt6_insert_exception removes the old
> one which has the MTU exception.
> 
> Fixes: ec8105352869 ("selftests: Add redirect tests")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, thanks.
