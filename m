Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DF45A8B7F
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbiIACbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbiIACa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:30:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83B0A8CDD;
        Wed, 31 Aug 2022 19:30:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01A6361DC6;
        Thu,  1 Sep 2022 02:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15CEC433C1;
        Thu,  1 Sep 2022 02:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661999453;
        bh=Nek3NqIi8T1Hdq89mzW0JIiWA7Q1H+spSrgOk3jQjiA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=BXpLuh/15cTIuyY1e4u0s3bIKLH1HSqYys1cu7DS7IV+rkbD+UGTxAHQNof9eirRi
         aElCkDp84ORaX46urniaXcQVV/EH6XeHOB+0WOPx1bVbDOreaUdC5YEjmKwy84YYsl
         AGY1OCd2nUYz9yX0Udxwov/q7rvdn59iUFttUi8+nVvPc6mbkb6KaXN0RZDUZfasii
         n3033tis4dkW0HpAC2imos2c2bMUS9Uff1nfqTii5ST7FGre7j5IAF+NPufvjwF1Jy
         kWLKuyXFHC0qg4oaiSpUsfEmd9PVwz8LR7lRc7BAspkg9tW6UyoZifF+N5YykamnsE
         tg3FbqNN9T5oA==
Message-ID: <46edeb7a-da56-e3f2-a823-a025b9386639@kernel.org>
Date:   Wed, 31 Aug 2022 20:30:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH net] ip: fix triggering of 'icmp redirect'
Content-Language: en-US
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Heng Qi <hengqi@linux.alibaba.com>,
        Edwin Brossette <edwin.brossette@6wind.com>,
        kernel test robot <lkp@intel.com>, lkp@lists.01.org,
        stable@vger.kernel.org, kernel test robot <yujie.liu@intel.com>
References: <20220829100121.3821-1-nicolas.dichtel@6wind.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220829100121.3821-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/22 4:01 AM, Nicolas Dichtel wrote:
> __mkroute_input() uses fib_validate_source() to trigger an icmp redirect.
> My understanding is that fib_validate_source() is used to know if the src
> address and the gateway address are on the same link. For that,
> fib_validate_source() returns 1 (same link) or 0 (not the same network).
> __mkroute_input() is the only user of these positive values, all other
> callers only look if the returned value is negative.
> 
> Since the below patch, fib_validate_source() didn't return anymore 1 when
> both addresses are on the same network, because the route lookup returns
> RT_SCOPE_LINK instead of RT_SCOPE_HOST. But this is, in fact, right.
> Let's adapat the test to return 1 again when both addresses are on the same
> link.
> 
> CC: stable@vger.kernel.org
> Fixes: 747c14307214 ("ip: fix dflt addr selection for connected nexthop")
> Reported-by: kernel test robot <yujie.liu@intel.com>
> Reported-by: Heng Qi <hengqi@linux.alibaba.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
> 
> This code exists since more than two decades:
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/netdev-vger-cvs.git/commit/?id=0c2c94df8133f
> 
> Please, feel free to comment if my analysis seems wrong.
> 
> Regards,
> Nicolas
> 
>  net/ipv4/fib_frontend.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index f361d3d56be2..943edf4ad4db 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -389,7 +389,7 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
>  	dev_match = dev_match || (res.type == RTN_LOCAL &&
>  				  dev == net->loopback_dev);
>  	if (dev_match) {
> -		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
> +		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;
>  		return ret;
>  	}
>  	if (no_addr)
> @@ -401,7 +401,7 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
>  	ret = 0;
>  	if (fib_lookup(net, &fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE) == 0) {
>  		if (res.type == RTN_UNICAST)
> -			ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
> +			ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;
>  	}
>  	return ret;
>  

Looks ok to me.

Reviewed-by: David Ahern <dsahern@kernel.org>

