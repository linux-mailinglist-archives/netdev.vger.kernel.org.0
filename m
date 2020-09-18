Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071F2270757
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgIRUsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIRUr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:47:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1253EC0613CF;
        Fri, 18 Sep 2020 13:47:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15051158E637A;
        Fri, 18 Sep 2020 13:31:10 -0700 (PDT)
Date:   Fri, 18 Sep 2020 13:47:54 -0700 (PDT)
Message-Id: <20200918.134754.204300318220602155.davem@davemloft.net>
To:     fruggeri@arista.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, ap420073@gmail.com, andriin@fb.com,
        edumazet@google.com, jiri@mellanox.com, ast@kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH v4] net: use exponential backoff in netdev_wait_allrefs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918201902.0931495C0649@us180.sjc.aristanetworks.com>
References: <20200918201902.0931495C0649@us180.sjc.aristanetworks.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 13:31:10 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: fruggeri@arista.com (Francesco Ruggeri)
Date: Fri, 18 Sep 2020 13:19:01 -0700

> The combination of aca_free_rcu, introduced in commit 2384d02520ff
> ("net/ipv6: Add anycast addresses to a global hashtable"), and
> fib6_info_destroy_rcu, introduced in commit 9b0a8da8c4c6 ("net/ipv6:
> respect rcu grace period before freeing fib6_info"), can result in
> an extra rcu grace period being needed when deleting an interface,
> with the result that netdev_wait_allrefs ends up hitting the msleep(250),
> which is considerably longer than the required grace period.
> This can result in long delays when deleting a large number of interfaces,
> and it can be observed with this script:
  ...
> Time with this patch on a 5.4 kernel:
> 
> real	0m7.704s
> user	0m0.385s
> sys	0m1.230s
> 
> Time without this patch:
> 
> real    0m31.522s
> user    0m0.438s
> sys     0m1.156s
> 
> v2: use exponential backoff instead of trying to wake up
>     netdev_wait_allrefs.
> v3: preserve reverse christmas tree ordering of local variables
> v4: try an extra rcu_barrier before the backoff, plus some
>     cosmetic changes.
> 
> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>

Applied to net-next, thanks.
