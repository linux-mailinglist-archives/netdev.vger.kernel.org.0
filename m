Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0012AF3C9C
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfKHAOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:14:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50518 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfKHAOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:14:06 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BFA2915385169;
        Thu,  7 Nov 2019 16:14:05 -0800 (PST)
Date:   Thu, 07 Nov 2019 16:14:05 -0800 (PST)
Message-Id: <20191107.161405.1706419291927808566.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, dsahern@gmail.com
Subject: Re: [PATCH v2 net] ipv6: fixes rt6_probe() and fib6_nh->last_probe
 init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107172619.109818-1-edumazet@google.com>
References: <20191107172619.109818-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 16:14:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  7 Nov 2019 09:26:19 -0800

> While looking at a syzbot KCSAN report [1], I found multiple
> issues in this code :
> 
> 1) fib6_nh->last_probe has an initial value of 0.
> 
>    While probably okay on 64bit kernels, this causes an issue
>    on 32bit kernels since the time_after(jiffies, 0 + interval)
>    might be false ~24 days after boot (for HZ=1000)
> 
> 2) The data-race found by KCSAN
>    I could use READ_ONCE() and WRITE_ONCE(), but we also can
>    take the opportunity of not piling-up too many rt6_probe_deferred()
>    works by using instead cmpxchg() so that only one cpu wins the race.
> 
> [1]
> BUG: KCSAN: data-race in find_match / find_match
 ...
> Fixes: cc3a86c802f0 ("ipv6: Change rt6_probe to take a fib6_nh")
> Fixes: f547fac624be ("ipv6: rate-limit probes for neighbourless routes")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Reviewed-by: David Ahern <dsahern@gmail.com>
> ---
> v2: Added a 2nd Fixes: tag to help stable backports and Reviewed-by: from David Ahern

Applied and queued up for -stable, thanks Eric.
