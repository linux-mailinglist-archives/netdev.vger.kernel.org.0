Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F0E192900
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 13:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgCYMyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 08:54:01 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:35012 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbgCYMyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 08:54:01 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8753520265;
        Wed, 25 Mar 2020 13:53:59 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Zrh3ebZnZWSs; Wed, 25 Mar 2020 13:53:57 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9A11A20539;
        Wed, 25 Mar 2020 13:53:57 +0100 (CET)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 MAIL-ESSEN-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Wed, 25 Mar 2020 13:53:57 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 25 Mar
 2020 13:53:57 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id C5FDD318026D;
 Wed, 25 Mar 2020 13:53:56 +0100 (CET)
Date:   Wed, 25 Mar 2020 13:53:56 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     YueHaibing <yuehaibing@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <timo.teras@iki.fi>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] xfrm: policy: Fix doulbe free in xfrm_policy_timer
Message-ID: <20200325125356.GV13121@gauss3.secunet.de>
References: <20200318034839.57996-1-yuehaibing@huawei.com>
 <20200323073239.59000-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200323073239.59000-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
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

Applied, thanks everyone!
