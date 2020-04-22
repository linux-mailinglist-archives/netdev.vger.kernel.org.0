Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BC21B3B70
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 11:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgDVJdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 05:33:51 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:43450 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgDVJdv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 05:33:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E428120519;
        Wed, 22 Apr 2020 11:33:48 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uKgNb0ZKKV0r; Wed, 22 Apr 2020 11:33:45 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 94ADC2009B;
        Wed, 22 Apr 2020 11:33:45 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Apr 2020 11:33:45 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 22 Apr
 2020 11:33:45 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id BFE703180096; Wed, 22 Apr 2020 11:33:44 +0200 (CEST)
Date:   Wed, 22 Apr 2020 11:33:44 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     YueHaibing <yuehaibing@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lucien.xin@gmail.com>
Subject: Re: [PATCH] xfrm: policy: Only use mark as policy lookup key
Message-ID: <20200422093344.GY13121@gauss3.secunet.de>
References: <20200421143149.45108-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200421143149.45108-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 10:31:49PM +0800, YueHaibing wrote:
> While update xfrm policy as follow:
> 
> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
>  priority 1 mark 0 mask 0x10
> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
>  priority 2 mark 0 mask 0x00
> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
>  priority 2 mark 0 mask 0x10
> 
> We get this warning:
> 
> WARNING: CPU: 0 PID: 4808 at net/xfrm/xfrm_policy.c:1548
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 4808 Comm: ip Not tainted 5.7.0-rc1+ #151
> Call Trace:
> RIP: 0010:xfrm_policy_insert_list+0x153/0x1e0
>  xfrm_policy_inexact_insert+0x70/0x330
>  xfrm_policy_insert+0x1df/0x250
>  xfrm_add_policy+0xcc/0x190 [xfrm_user]
>  xfrm_user_rcv_msg+0x1d1/0x1f0 [xfrm_user]
>  netlink_rcv_skb+0x4c/0x120
>  xfrm_netlink_rcv+0x32/0x40 [xfrm_user]
>  netlink_unicast+0x1b3/0x270
>  netlink_sendmsg+0x350/0x470
>  sock_sendmsg+0x4f/0x60
> 
> Policy C and policy A has the same mark.v and mark.m, so policy A is
> matched in first round lookup while updating C. However policy C and
> policy B has same mark and priority, which also leads to matched. So
> the WARN_ON is triggered.
> 
> xfrm policy lookup should only be matched when the found policy has the
> same lookup keys (mark.v & mark.m) no matter priority.
> 
> Fixes: 7cb8a93968e3 ("xfrm: Allow inserting policies with matching mark and different priorities")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/xfrm/xfrm_policy.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index 297b2fd..67d0469 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -1436,13 +1436,7 @@ static void xfrm_policy_requeue(struct xfrm_policy *old,
>  static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
>  				   struct xfrm_policy *pol)
>  {
> -	u32 mark = policy->mark.v & policy->mark.m;
> -
> -	if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
> -		return true;
> -
> -	if ((mark & pol->mark.m) == pol->mark.v &&
> -	    policy->priority == pol->priority)

If you remove the priority check, you can't insert policies with matching
mark and different priorities anymore. This brings us back the old bug.

I plan to apply the patch from Xin Long, this seems to be the right way
to address this problem.
