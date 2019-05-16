Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 200842100B
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 23:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbfEPVdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 17:33:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33576 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfEPVdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 17:33:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C64112D8E1E1;
        Thu, 16 May 2019 14:33:46 -0700 (PDT)
Date:   Thu, 16 May 2019 14:33:46 -0700 (PDT)
Message-Id: <20190516.143346.1283734330002616092.davem@davemloft.net>
To:     tracywwnj@gmail.com
Cc:     netdev@vger.kernel.org, kafai@fb.com, weiwan@google.com,
        mikael.kernel@lists.m7n.se, dsahern@gmail.com, edumazet@google.com
Subject: Re: [PATCH v3 net] ipv6: fix src addr routing with the exception
 table
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190516203054.13066-1-tracywwnj@gmail.com>
References: <20190516203054.13066-1-tracywwnj@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 14:33:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <tracywwnj@gmail.com>
Date: Thu, 16 May 2019 13:30:54 -0700

> From: Wei Wang <weiwan@google.com>
> 
> When inserting route cache into the exception table, the key is
> generated with both src_addr and dest_addr with src addr routing.
> However, current logic always assumes the src_addr used to generate the
> key is a /128 host address. This is not true in the following scenarios:
> 1. When the route is a gateway route or does not have next hop.
>    (rt6_is_gw_or_nonexthop() == false)
> 2. When calling ip6_rt_cache_alloc(), saddr is passed in as NULL.
> This means, when looking for a route cache in the exception table, we
> have to do the lookup twice: first time with the passed in /128 host
> address, second time with the src_addr stored in fib6_info.
> 
> This solves the pmtu discovery issue reported by Mikael Magnusson where
> a route cache with a lower mtu info is created for a gateway route with
> src addr. However, the lookup code is not able to find this route cache.
> 
> Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
> Reported-by: Mikael Magnusson <mikael.kernel@lists.m7n.se>
> Bisected-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Wei Wang <weiwan@google.com>

Applied and queued up for -stable.
