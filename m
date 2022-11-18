Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CED3630000
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiKRWYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiKRWYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:24:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30003205A;
        Fri, 18 Nov 2022 14:23:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F8BD627B8;
        Fri, 18 Nov 2022 22:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAE5C433D6;
        Fri, 18 Nov 2022 22:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668810229;
        bh=saD4ekaR7aTv0tgNKWhed7zpzPCX3G62radVkykS1Us=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Nrr9/LDlLu0c7qtlU9AyNxbP/NzttRuFpt0JOV0n8IDqKQDrgVZIDsW94d1ys3hRZ
         M3m0hZIBRA8X4OGed/P5VUQvNUWqYs1I2PBy95NlmAriDnLF44f1sJ6BX6eEIGgXZj
         RmrQ3i0CBnGwoETXl2cU4pKP0cmpovPjpAbaUlOF+tWr0Pi277cVaVSbJGmJAt4x6a
         vZ4doG6op8I6glx03SoNDGtQIqJaDw510Du6TFJmGk5DSZRK7c7h9OHkm5zqCm5Ns6
         eLs2P7iq3udRnLyPtFd1WeGekKPPNv+KW3R+GlkAZKlmorfAoU2seVBLMi944ErsgD
         gGRXJunwDodwA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 991EB5C0F9C; Fri, 18 Nov 2022 14:23:48 -0800 (PST)
Date:   Fri, 18 Nov 2022 14:23:48 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, fweisbec@gmail.com
Subject: Re: [PATCH v2 2/2] net: devinet: Reduce refcount before grace period
Message-ID: <20221118222348.GQ4001@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20221118191909.1756624-1-joel@joelfernandes.org>
 <20221118191909.1756624-2-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118191909.1756624-2-joel@joelfernandes.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 07:19:09PM +0000, Joel Fernandes (Google) wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Currently, the inetdev_destroy() function waits for an RCU grace period
> before decrementing the refcount and freeing memory. This causes a delay
> with a new RCU configuration that tries to save power, which results in the
> network interface disappearing later than expected. The resulting delay
> causes test failures on ChromeOS.
> 
> Refactor the code such that the refcount is freed before the grace period
> and memory is freed after. With this a ChromeOS network test passes that
> does 'ip netns del' and polls for an interface disappearing, now passes.
> 
> Reported-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Queued and pushed, thank you both!

This patch can go as-is based on Eric's Signed-off-by, but the first
one of course needs at least an ack.

							Thanx, Paul

> ---
>  net/ipv4/devinet.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index e8b9a9202fec..b0acf6e19aed 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -234,13 +234,20 @@ static void inet_free_ifa(struct in_ifaddr *ifa)
>  	call_rcu(&ifa->rcu_head, inet_rcu_free_ifa);
>  }
>  
> +static void in_dev_free_rcu(struct rcu_head *head)
> +{
> +	struct in_device *idev = container_of(head, struct in_device, rcu_head);
> +
> +	kfree(rcu_dereference_protected(idev->mc_hash, 1));
> +	kfree(idev);
> +}
> +
>  void in_dev_finish_destroy(struct in_device *idev)
>  {
>  	struct net_device *dev = idev->dev;
>  
>  	WARN_ON(idev->ifa_list);
>  	WARN_ON(idev->mc_list);
> -	kfree(rcu_dereference_protected(idev->mc_hash, 1));
>  #ifdef NET_REFCNT_DEBUG
>  	pr_debug("%s: %p=%s\n", __func__, idev, dev ? dev->name : "NIL");
>  #endif
> @@ -248,7 +255,7 @@ void in_dev_finish_destroy(struct in_device *idev)
>  	if (!idev->dead)
>  		pr_err("Freeing alive in_device %p\n", idev);
>  	else
> -		kfree(idev);
> +		call_rcu(&idev->rcu_head, in_dev_free_rcu);
>  }
>  EXPORT_SYMBOL(in_dev_finish_destroy);
>  
> @@ -298,12 +305,6 @@ static struct in_device *inetdev_init(struct net_device *dev)
>  	goto out;
>  }
>  
> -static void in_dev_rcu_put(struct rcu_head *head)
> -{
> -	struct in_device *idev = container_of(head, struct in_device, rcu_head);
> -	in_dev_put(idev);
> -}
> -
>  static void inetdev_destroy(struct in_device *in_dev)
>  {
>  	struct net_device *dev;
> @@ -328,7 +329,7 @@ static void inetdev_destroy(struct in_device *in_dev)
>  	neigh_parms_release(&arp_tbl, in_dev->arp_parms);
>  	arp_ifdown(dev);
>  
> -	call_rcu(&in_dev->rcu_head, in_dev_rcu_put);
> +	in_dev_put(in_dev);
>  }
>  
>  int inet_addr_onlink(struct in_device *in_dev, __be32 a, __be32 b)
> -- 
> 2.38.1.584.g0f3c55d4c2-goog
> 
