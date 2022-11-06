Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1EA61E573
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 20:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiKFTI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 14:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiKFTI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 14:08:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE9E265B;
        Sun,  6 Nov 2022 11:08:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCDD5B80CA2;
        Sun,  6 Nov 2022 19:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB715C433C1;
        Sun,  6 Nov 2022 19:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667761703;
        bh=n1QZlVQPqIfnOW1Dc1y6OdrVUcoHPlboJLH6at3KM+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gc6VGuGzO+7LA7whS2QFCxpM1aGrxqRTd8QwbDdA6QybbgkHE4HU6x8R7gkE3+nav
         QbNpgkKYEcGHE/tni4Pd3szujHnpIvrJxYaK4Rcx3Jn4E2MlcPx5bD+4ZbdHzHguWr
         94nOMrofGcUE+Yu5kqM+PGCxJm9kqt+7Ky8oDdq87mWzl1457xxdXXtBPud9mBzfrt
         Oh1UAHB/j12rTh0eSE5K0D8e5RhSNPLlchq71rvnz/CqCY+REOkRG+d1DA5FPC2m73
         4+AGnhHpszXARAsBH5KyfEszpq2nAbvrJqMXxHXksHtS1Px8FLsNfYGWoyZHl5Xu1a
         NWok6hC+c9Xtg==
Date:   Sun, 6 Nov 2022 21:08:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net] xfrm: Fix ignored return value in xfrm6_init()
Message-ID: <Y2gGIuwY368X8Won@unreal>
References: <20221103090713.188740-1-chenzhongjin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103090713.188740-1-chenzhongjin@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 05:07:13PM +0800, Chen Zhongjin wrote:
> When IPv6 module initializing in xfrm6_init(), register_pernet_subsys()
> is possible to fail but its return value is ignored.
> 
> If IPv6 initialization fails later and xfrm6_fini() is called,
> removing uninitialized list in xfrm6_net_ops will cause null-ptr-deref:
> 
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 1 PID: 330 Comm: insmod
> RIP: 0010:unregister_pernet_operations+0xc9/0x450
> Call Trace:
>  <TASK>
>  unregister_pernet_subsys+0x31/0x3e
>  xfrm6_fini+0x16/0x30 [ipv6]
>  ip6_route_init+0xcd/0x128 [ipv6]
>  inet6_init+0x29c/0x602 [ipv6]
>  ...
> 
> Fix it by catching the error return value of register_pernet_subsys().
> 
> Fixes: 8d068875caca ("xfrm: make gc_thresh configurable in all namespaces")
> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
> ---
>  net/ipv6/xfrm6_policy.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

I see same error in net/ipv4/xfrm4_policy.c which introduced by same
commit mentioned in Fixes line.

Thanks

> 
> diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
> index 4a4b0e49ec92..ea435eba3053 100644
> --- a/net/ipv6/xfrm6_policy.c
> +++ b/net/ipv6/xfrm6_policy.c
> @@ -287,9 +287,13 @@ int __init xfrm6_init(void)
>  	if (ret)
>  		goto out_state;
>  
> -	register_pernet_subsys(&xfrm6_net_ops);
> +	ret = register_pernet_subsys(&xfrm6_net_ops);
> +	if (ret)
> +		goto out_protocol;
>  out:
>  	return ret;
> +out_protocol:
> +	xfrm6_protocol_fini();
>  out_state:
>  	xfrm6_state_fini();
>  out_policy:
> -- 
> 2.17.1
> 
