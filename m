Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B6D6D2E2C
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 06:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbjDAEg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 00:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjDAEg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 00:36:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560501D855;
        Fri, 31 Mar 2023 21:36:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04FABB831EF;
        Sat,  1 Apr 2023 04:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EE6C433EF;
        Sat,  1 Apr 2023 04:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680323782;
        bh=hJYcCSeVoGQ70jodkVGpdkucAOpNMklA3+qqhGyCqoI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=errMlgysqOkWlgQS0VIR05dgnQpEQ6FX2IDff/PIVouOFBHjLQ8X/joUcntyLlKPN
         pKEjk2cveDJXPBvFl20EpMFwQBnPgqkn+zrN6pvXGOWJ1yNIpKh5AMVjjyPgdFBt9I
         RWFPIkLiCnK3ppA2dCE1YZ8eDiftDAXZU5qb/ZyjDa6XXVyv8EIjv17pv2ABoUdHwp
         66sAAd1aDr4XSl+y/2uBh1EFoRJPBEsJchNTW9snLUdBfaQoKD37PR61r5ve5amGDO
         0TcevbxPNzH2JnXxUxaAOAT6zeVK6gd1TENKNSeUZ9b6Ck5Dc8l6kKItPUE8UPjXwa
         nMJnC6bbksIKg==
Date:   Fri, 31 Mar 2023 21:36:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v2 1/2] net: extend drop reasons for multiple subsystems
Message-ID: <20230331213621.0993e25b@kernel.org>
In-Reply-To: <20230330212227.928595-1-johannes@sipsolutions.net>
References: <20230330212227.928595-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 23:22:26 +0200 Johannes Berg wrote:
> diff --git a/include/net/dropreason.h b/include/net/dropreason.h
> index c0a3ea806cd5..d7a134c108ad 100644
> --- a/include/net/dropreason.h
> +++ b/include/net/dropreason.h
> @@ -339,10 +339,28 @@ enum skb_drop_reason {
>  	 */
>  	SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST,
>  	/**
> -	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
> -	 * used as a real 'reason'
> -	 */
> +	 * @SKB_DROP_REASON_MAX: the maximum of core drop reasons, which
> +	 * shouldn't be used as a real 'reason' - only for tracing code gen
> +         */
>  	SKB_DROP_REASON_MAX,
> +
> +	/** @SKB_DROP_REASON_SUBSYS_MASK: subsystem mask in drop reasons,
> +	 * see &enum skb_drop_reason_subsys
> +	 */
> +	SKB_DROP_REASON_SUBSYS_MASK = 0xffff0000,
> +};
> +
> +#define SKB_DROP_REASON_SUBSYS_SHIFT	16
> +
> +/**
> + * enum skb_drop_reason_subsys - subsystem tag for (extended) drop reasons
> + */
> +enum skb_drop_reason_subsys {
> +	/** @SKB_DROP_REASON_SUBSYS_CORE: core drop reasons defined above */
> +	SKB_DROP_REASON_SUBSYS_CORE,
> +
> +	/** @SKB_DROP_REASON_SUBSYS_NUM: number of subsystems defined */
> +	SKB_DROP_REASON_SUBSYS_NUM
>  };
>  
>  #define SKB_DR_INIT(name, reason)				\
> @@ -358,6 +376,17 @@ enum skb_drop_reason {
>  			SKB_DR_SET(name, reason);		\
>  	} while (0)
>  
> -extern const char * const drop_reasons[];
> +struct drop_reason_list {
> +	const char * const *reasons;
> +	size_t n_reasons;
> +};
> +
> +/* Note: due to dynamic registrations, access must be under RCU */
> +extern const struct drop_reason_list __rcu *
> +drop_reasons_by_subsys[SKB_DROP_REASON_SUBSYS_NUM];
> +
> +void drop_reasons_register_subsys(enum skb_drop_reason_subsys subsys,
> +				  const struct drop_reason_list *list);
> +void drop_reasons_unregister_subsys(enum skb_drop_reason_subsys subsys);

dropreason.h is included by skbuff.h because history, but I don't think
any of the new stuff must be visible in skbuff.h.

Could you make a new header, and put as much of this stuff there as
possible? Our future selves will thank us for shorter rebuild times..

>  #undef FN
>  #define FN(reason) [SKB_DROP_REASON_##reason] = #reason,
> -const char * const drop_reasons[] = {
> +static const char * const drop_reasons[] = {
>  	[SKB_CONSUMED] = "CONSUMED",
>  	DEFINE_DROP_REASON(FN, FN)
>  };
> -EXPORT_SYMBOL(drop_reasons);
> +
> +static const struct drop_reason_list drop_reasons_core = {
> +	.reasons = drop_reasons,
> +	.n_reasons = ARRAY_SIZE(drop_reasons),
> +};
> +
> +const struct drop_reason_list __rcu *
> +drop_reasons_by_subsys[SKB_DROP_REASON_SUBSYS_NUM] = {
> +	[SKB_DROP_REASON_SUBSYS_CORE] = &drop_reasons_core,
> +};
> +EXPORT_SYMBOL(drop_reasons_by_subsys);
> +
> +/**
> + * drop_reasons_register_subsys - register another drop reason subsystem
> + * @subsys: the subsystem to register, must not be the core
> + * @list: the list of drop reasons within the subsystem, must point to
> + *	a statically initialized list
> + */
> +void drop_reasons_register_subsys(enum skb_drop_reason_subsys subsys,
> +				  const struct drop_reason_list *list)
> +{
> +	if (WARN(subsys <= SKB_DROP_REASON_SUBSYS_CORE ||
> +		 subsys >= ARRAY_SIZE(drop_reasons_by_subsys),
> +		 "invalid subsystem %d\n", subsys))
> +		return;
> +
> +	/* must point to statically allocated memory, so INIT is OK */
> +	RCU_INIT_POINTER(drop_reasons_by_subsys[subsys], list);
> +}
> +EXPORT_SYMBOL_GPL(drop_reasons_register_subsys);
> +
> +/**
> + * drop_reasons_unregister_subsys - unregister a drop reason subsystem
> + * @subsys: the subsystem to remove, must not be the core
> + *
> + * Note: This will synchronize_rcu() to ensure no users when it returns.
> + */
> +void drop_reasons_unregister_subsys(enum skb_drop_reason_subsys subsys)
> +{
> +	if (WARN(subsys <= SKB_DROP_REASON_SUBSYS_CORE ||
> +		 subsys >= ARRAY_SIZE(drop_reasons_by_subsys),
> +		 "invalid subsystem %d\n", subsys))
> +		return;
> +
> +	RCU_INIT_POINTER(drop_reasons_by_subsys[subsys], NULL);
> +
> +	synchronize_rcu();
> +}
> +EXPORT_SYMBOL_GPL(drop_reasons_unregister_subsys);

Weak preference to also take the code out of skbuff.c but that's not as
important.


You To'd both wireless and netdev, who are you expecting to apply this?
:S
