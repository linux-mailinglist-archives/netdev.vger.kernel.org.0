Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 718DC58987
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfF0SLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:11:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57724 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfF0SLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 14:11:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2930B133E98DF;
        Thu, 27 Jun 2019 11:11:33 -0700 (PDT)
Date:   Thu, 27 Jun 2019 11:11:32 -0700 (PDT)
Message-Id: <20190627.111132.896895315960292606.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kafai@fb.com, weiwan@google.com,
        dsahern@gmail.com
Subject: Re: [PATCH v2 net-next] ipv6: Convert gateway validation to use
 fib6_info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624204451.10929-1-dsahern@kernel.org>
References: <20190624204451.10929-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 11:11:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Mon, 24 Jun 2019 13:44:51 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Gateway validation does not need a dst_entry, it only needs the fib
> entry to validate the gateway resolution and egress device. So,
> convert ip6_nh_lookup_table from ip6_pol_route to fib6_table_lookup
> and ip6_route_check_nh to use fib6_lookup over rt6_lookup.
> 
> ip6_pol_route is a call to fib6_table_lookup and if successful a call
> to fib6_select_path. From there the exception cache is searched for an
> entry or a dst_entry is created to return to the caller. The exception
> entry is not relevant for gateway validation, so what matters are the
> calls to fib6_table_lookup and then fib6_select_path.
> 
> Similarly, rt6_lookup can be replaced with a call to fib6_lookup with
> RT6_LOOKUP_F_IFACE set in flags. Again, the exception cache search is
> not relevant, only the lookup with path selection. The primary difference
> in the lookup paths is the use of rt6_select with fib6_lookup versus
> rt6_device_match with rt6_lookup. When you remove complexities in the
> rt6_select path, e.g.,
> 1. saddr is not set for gateway validation, so RT6_LOOKUP_F_HAS_SADDR
>    is not relevant
> 2. rt6_check_neigh is not called so that removes the RT6_NUD_FAIL_DO_RR
>    return and round-robin logic.
> 
> the code paths are believed to be equivalent for the given use case -
> validate the gateway and optionally given the device. Furthermore, it
> aligns the validation with onlink code path and the lookup path actually
> used for rx and tx.
> 
> Adjust the users, ip6_route_check_nh_onlink and ip6_route_check_nh to
> handle a fib6_info vs a rt6_info when performing validation checks.
> 
> Existing selftests fib-onlink-tests.sh and fib_tests.sh are used to
> verify the changes.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
> v2
> - use in6_dev_get versus __in6_dev_get + in6_dev_hold (comment from Wei)
> - updated commit message

Applied, thanks.
