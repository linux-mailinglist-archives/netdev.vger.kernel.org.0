Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D702350ADC5
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 04:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443349AbiDVCdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 22:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443337AbiDVCdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 22:33:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45D455B4;
        Thu, 21 Apr 2022 19:30:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E7A3B82A18;
        Fri, 22 Apr 2022 02:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7146FC385A7;
        Fri, 22 Apr 2022 02:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650594656;
        bh=aR1It5W2waUvU+xKtFR98aoY5O6gV6+zb3KxX4aFIf4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TxaSVGnrNsAuJkOht+36k7tQvjX3MfpkkLIhyTGPCXPQCafq3ZKj23Mb0YN2mMTor
         x2VyySuJQ0lqY3Vy2xbmak0sdFM1/ehd83ZjbpHySLUtTfj5i7rrQuVs3+rsJd7RHo
         2MunRBLaStFNN+imlcWEDxo6tALHZ4ihhLgU1J05P7D6wILe+sQEFcKVBCWrG7d2LI
         6nWDsq8ufBk2PML9GAYiZL5P9b5rqDXsJtKJeoU+MzSsYdKs2Mgco5MZsPa2BeXLci
         t1qLQ971quvdFp8pZdOXOn9Ou48sLY/QA8+qDy4pp0JBpOsoel29/meQL5ysQtkQuf
         74SLphVmU1BcA==
Message-ID: <0d4e27ee-385c-fd5d-bd31-51e9e2382667@kernel.org>
Date:   Thu, 21 Apr 2022 20:30:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next 1/3] ipv4: Don't reset ->flowi4_scope in
 ip_rt_fix_tos().
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dccp@vger.kernel.org
References: <cover.1650470610.git.gnault@redhat.com>
 <c3fdfe3353158c9b9da14602619fb82db5e77f27.1650470610.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <c3fdfe3353158c9b9da14602619fb82db5e77f27.1650470610.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/22 5:21 PM, Guillaume Nault wrote:
> All callers already initialise ->flowi4_scope with RT_SCOPE_UNIVERSE,
> either by manual field assignment, memset(0) of the whole structure or
> implicit structure initialisation of on-stack variables
> (RT_SCOPE_UNIVERSE actually equals 0).
> 
> Therefore, we don't need to always initialise ->flowi4_scope in
> ip_rt_fix_tos(). We only need to reduce the scope to RT_SCOPE_LINK when
> the special RTO_ONLINK flag is present in the tos.
> 
> This will allow some code simplification, like removing
> ip_rt_fix_tos(). Also, the long term idea is to remove RTO_ONLINK
> entirely by properly initialising ->flowi4_scope, instead of
> overloading ->flowi4_tos with a special flag. Eventually, this will
> allow to convert ->flowi4_tos to dscp_t.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
> It's important for the correctness of this patch that all callers
> initialise ->flowi4_scope to 0 (in one way or another). Auditing all of
> them is long, although each case is pretty trivial.
> 
> If it helps, I can send a patch series that converts implicit
> initialisation of ->flowi4_scope with an explicit assignment to
> RT_SCOPE_UNIVERSE. This would also have the advantage of making it
> clear to future readers that ->flowi4_scope _has_ to be initialised. I
> haven't sent such patch series to not overwhelm reviewers with trivial
> and not technically-required changes (there are 40+ places to modify,
> scattered over 30+ different files). But if anyone prefers explicit
> initialisation everywhere, then just let me know and I'll send such
> patches.

There are a handful of places that open code the initialization of the
flow struct. I *think* I found all of them in 40867d74c374.

> ---
>  net/ipv4/route.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index e839d424b861..d8f82c0ac132 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -503,8 +503,8 @@ static void ip_rt_fix_tos(struct flowi4 *fl4)
>  	__u8 tos = RT_FL_TOS(fl4);
>  
>  	fl4->flowi4_tos = tos & IPTOS_RT_MASK;
> -	fl4->flowi4_scope = tos & RTO_ONLINK ?
> -			    RT_SCOPE_LINK : RT_SCOPE_UNIVERSE;
> +	if (tos & RTO_ONLINK)
> +		fl4->flowi4_scope = RT_SCOPE_LINK;
>  }
>  
>  static void __build_flow_key(const struct net *net, struct flowi4 *fl4,

Reviewed-by: David Ahern <dsahern@kernel.org>
