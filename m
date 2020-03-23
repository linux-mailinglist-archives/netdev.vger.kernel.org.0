Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E65E8190093
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgCWVpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:45:31 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:32922 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgCWVpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 17:45:31 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jGUsV-00061D-Eg; Tue, 24 Mar 2020 08:45:00 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 24 Mar 2020 08:44:59 +1100
Date:   Tue, 24 Mar 2020 08:44:59 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        timo.teras@iki.fi, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] xfrm: policy: Fix doulbe free in xfrm_policy_timer
Message-ID: <20200323214459.GA9720@gondor.apana.org.au>
References: <20200318034839.57996-1-yuehaibing@huawei.com>
 <20200323073239.59000-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323073239.59000-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 03:32:39PM +0800, YueHaibing wrote:
> After xfrm_add_policy add a policy, its ref is 2, then
> 
>                              xfrm_policy_timer
>                                read_lock
>                                xp->walk.dead is 0
>                                ....
>                                mod_timer()
> xfrm_policy_kill
>   policy->walk.dead = 1
>   ....
>   del_timer(&policy->timer)
>     xfrm_pol_put //ref is 1
>   xfrm_pol_put  //ref is 0
>     xfrm_policy_destroy
>       call_rcu
>                                  xfrm_pol_hold //ref is 1
>                                read_unlock
>                                xfrm_pol_put //ref is 0
>                                  xfrm_policy_destroy
>                                   call_rcu
> 
> xfrm_policy_destroy is called twice, which may leads to
> double free.
> 
> Call Trace:
> RIP: 0010:refcount_warn_saturate+0x161/0x210
> ...
>  xfrm_policy_timer+0x522/0x600
>  call_timer_fn+0x1b3/0x5e0
>  ? __xfrm_decode_session+0x2990/0x2990
>  ? msleep+0xb0/0xb0
>  ? _raw_spin_unlock_irq+0x24/0x40
>  ? __xfrm_decode_session+0x2990/0x2990
>  ? __xfrm_decode_session+0x2990/0x2990
>  run_timer_softirq+0x5c5/0x10e0
> 
> Fix this by use write_lock_bh in xfrm_policy_kill.
> 
> Fixes: ea2dea9dacc2 ("xfrm: remove policy lock when accessing policy->walk.dead")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v3: Only lock 'policy->walk.dead'
> v2: Fix typo 'write_lock_bh'--> 'write_unlock_bh' while unlocking
> ---
>  net/xfrm/xfrm_policy.c | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
