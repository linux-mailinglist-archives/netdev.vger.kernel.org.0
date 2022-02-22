Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E727F4BF1D0
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 06:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiBVF4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 00:56:53 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiBVF4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 00:56:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738BB7D01B
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 21:56:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 808D161472
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 04:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FD0C340E8;
        Tue, 22 Feb 2022 04:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645505252;
        bh=aajkrxdTmz2seWw1zaFDs4jAhAzlURYloWkVtjaQFT0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IV9+UGW2Mu85tFw1p/28Ez5IekJjlQ5DyfFB49OC3m4BIMQwpAMeKaImlF1kXAOnO
         AONJ/v/gb+XmpKhti3TL0oXk8vcbHaFykhZKRFNDuIQSU58x9RV+6uyDOPeGe3ISzm
         SXus6d8+kA406Cp4LN3+RBXY6dU3KyTAzguiRCFt2M8xD/qEYr6aO+1xNIDEVfw1Rc
         MdaIKDaj9/f1iwBq8SISpRvBL2RiM9rgjBeYXqrXH2VWzNlnNKpLSesVtN37h5GvHF
         VUw2ilqbEhynIqaIxTC7h1OuQZULrG9PMU2p9OJ7kvqOV1+WcrvZfc/NH+wRx5W/bh
         W6iqyEXXnPc2A==
Date:   Mon, 21 Feb 2022 20:47:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        eric.dumazet@gmail.com, ennoerlangen@gmail.com,
        george.mccollister@gmail.com, olteanv@gmail.com,
        marco.wenzel@a-eberle.de
Subject: Re: [PATCH net-next] net: hsr: fix hsr build error when lockdep is
 not enabled
Message-ID: <20220221204731.1229f987@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220220153250.5285-1-claudiajkang@gmail.com>
References: <20220220153250.5285-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Feb 2022 15:32:50 +0000 Juhee Kang wrote:
> In hsr, lockdep_is_held() is needed for rcu_dereference_bh_check().
> But if lockdep is not enabled, lockdep_is_held() causes a build error:
> 
>     ERROR: modpost: "lockdep_is_held" [net/hsr/hsr.ko] undefined!
> 
> Thus, this patch solved by adding lockdep_hsr_is_held(). This helper
> function calls the lockdep_is_held() when lockdep is enabled, and returns 1
> if not defined.
> 
> Fixes: e7f27420681f ("net: hsr: fix suspicious RCU usage warning in hsr_node_get_first()")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> ---
>  net/hsr/hsr_framereg.c | 25 +++++++++++++++----------
>  net/hsr/hsr_framereg.h |  8 +++++++-
>  2 files changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> index 62272d76545c..584e21788799 100644
> --- a/net/hsr/hsr_framereg.c
> +++ b/net/hsr/hsr_framereg.c
> @@ -20,6 +20,13 @@
>  #include "hsr_framereg.h"
>  #include "hsr_netlink.h"
>  
> +#ifdef CONFIG_LOCKDEP
> +int lockdep_hsr_is_held(spinlock_t *lock)
> +{
> +	return lockdep_is_held(lock);
> +}
> +#endif

Let me apply the patch, so that people don't hit this problem,
but please investigate if this helper is needed..

>  u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr)
>  {
>  	u32 hash = jhash(addr, ETH_ALEN, hsr->hash_seed);
> @@ -27,11 +34,12 @@ u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr)
>  	return reciprocal_scale(hash, hsr->hash_buckets);
>  }
>  
> -struct hsr_node *hsr_node_get_first(struct hlist_head *head, int cond)
> +struct hsr_node *hsr_node_get_first(struct hlist_head *head, spinlock_t *lock)
>  {
>  	struct hlist_node *first;
>  
> -	first = rcu_dereference_bh_check(hlist_first_rcu(head), cond);
> +	first = rcu_dereference_bh_check(hlist_first_rcu(head),
> +					 lockdep_hsr_is_held(lock));

.. since you moved the lockdep check inside rcu_dereference() I think
the build problem should go away. rcu_deref..() will only execute the
last argument if PROVE_LOCKING is set, so it should be safe to pass
lockdep_is_held(lock) in directly there.

Please double check and send another follow up if I'm correct, thanks!
