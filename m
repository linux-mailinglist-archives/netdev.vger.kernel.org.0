Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8292D588639
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 06:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbiHCEUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 00:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiHCEUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 00:20:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0FF2B60B;
        Tue,  2 Aug 2022 21:20:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B958A612E4;
        Wed,  3 Aug 2022 04:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84062C433D6;
        Wed,  3 Aug 2022 04:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659500406;
        bh=4XvW6Am+LFtU+beJUyoqbF5SdzyM95956jiHnqhMtGw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fP7OAmnJdeDrH+3lKsGs+j7tgGMMLB/DbAh9jWp67VxaRsmO7QibW7knm2D2iYqZG
         dSVQlg7tWQQjiQP2uvEepCh5ML010EhvEJDE6rnIBneJxT3mWexptkIVMdxHaAV9PK
         0GEngfIwWPmIHP8Fi2aou9E21t9PuJdIKKksaZuqUSdy5tBFXAiPLM3QVzxB6rTWH8
         uLbLhTU3bzqlWeg5Q8xKUlmlh6Owbdvf+LjbUXbJDiTCYyWephMAaEvGelYdg7GiDO
         OlG7AH4mP60rel0pO+jvwR0Jy/ng+Vz0sYXEMcntQ2SgFkrnZdDl4V69RvYnSuPOMD
         02P7prfEmDn8g==
Message-ID: <9e8728e0-75e7-d3a8-038b-48e51be4df07@kernel.org>
Date:   Tue, 2 Aug 2022 22:20:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] net: seg6: initialize induction variable to first valid
 array index
Content-Language: en-US
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Andrea Mayer <andrea.mayer@uniroma2.it>
References: <20220802161203.622293-1-ndesaulniers@google.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220802161203.622293-1-ndesaulniers@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ cc Andrea ]

On 8/2/22 10:12 AM, Nick Desaulniers wrote:
> Fixes the following warnings observed when building
> CONFIG_IPV6_SEG6_LWTUNNEL=y with clang:
> 
>   net/ipv6/seg6_local.o: warning: objtool: seg6_local_fill_encap() falls
>   through to next function seg6_local_get_encap_size()
>   net/ipv6/seg6_local.o: warning: objtool: seg6_local_cmp_encap() falls
>   through to next function input_action_end()
> 
> LLVM can fully unroll loops in seg6_local_get_encap_size() and
> seg6_local_cmp_encap(). One issue in those loops is that the induction
> variable is initialized to 0. The loop iterates over members of
> seg6_action_params, a global array of struct seg6_action_param calling
> their put() function pointer members.  seg6_action_param uses an array
> initializer to initialize SEG6_LOCAL_SRH and later elements, which is
> the third enumeration of an anonymous union.
> 
> The guard `if (attrs & SEG6_F_ATTR(i))` may prevent this from being
> called at runtime, but it would still be UB for
> `seg6_action_params[0]->put` to be called; the unrolled loop will make
> the initial iterations unreachable, which LLVM will later rotate to
> fallthrough to the next function.
> 
> Make this more obvious that this cannot happen to the compiler by
> initializing the loop induction variable to the minimum valid index that
> seg6_action_params is initialized to.
> 
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  net/ipv6/seg6_local.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> index 2cd4a8d3b30a..b7de5e46fdd8 100644
> --- a/net/ipv6/seg6_local.c
> +++ b/net/ipv6/seg6_local.c
> @@ -1614,7 +1614,7 @@ static void __destroy_attrs(unsigned long parsed_attrs, int max_parsed,
>  	 * callback. If the callback is not available, then we skip to the next
>  	 * attribute; otherwise, we call the destroy() callback.
>  	 */
> -	for (i = 0; i < max_parsed; ++i) {
> +	for (i = SEG6_LOCAL_SRH; i < max_parsed; ++i) {
>  		if (!(parsed_attrs & SEG6_F_ATTR(i)))
>  			continue;
>  
> @@ -1643,7 +1643,7 @@ static int parse_nla_optional_attrs(struct nlattr **attrs,
>  	struct seg6_action_param *param;
>  	int err, i;
>  
> -	for (i = 0; i < SEG6_LOCAL_MAX + 1; ++i) {
> +	for (i = SEG6_LOCAL_SRH; i < SEG6_LOCAL_MAX + 1; ++i) {
>  		if (!(desc->optattrs & SEG6_F_ATTR(i)) || !attrs[i])
>  			continue;
>  
> @@ -1742,7 +1742,7 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
>  	}
>  
>  	/* parse the required attributes */
> -	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
> +	for (i = SEG6_LOCAL_SRH; i < SEG6_LOCAL_MAX + 1; i++) {
>  		if (desc->attrs & SEG6_F_ATTR(i)) {
>  			if (!attrs[i])
>  				return -EINVAL;
> @@ -1847,7 +1847,7 @@ static int seg6_local_fill_encap(struct sk_buff *skb,
>  
>  	attrs = slwt->desc->attrs | slwt->parsed_optattrs;
>  
> -	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
> +	for (i = SEG6_LOCAL_SRH; i < SEG6_LOCAL_MAX + 1; i++) {
>  		if (attrs & SEG6_F_ATTR(i)) {
>  			param = &seg6_action_params[i];
>  			err = param->put(skb, slwt);
> @@ -1927,7 +1927,7 @@ static int seg6_local_cmp_encap(struct lwtunnel_state *a,
>  	if (attrs_a != attrs_b)
>  		return 1;
>  
> -	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
> +	for (i = SEG6_LOCAL_SRH; i < SEG6_LOCAL_MAX + 1; i++) {
>  		if (attrs_a & SEG6_F_ATTR(i)) {
>  			param = &seg6_action_params[i];
>  			if (param->cmp(slwt_a, slwt_b))

