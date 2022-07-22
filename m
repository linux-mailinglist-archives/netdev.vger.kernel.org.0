Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C9157E774
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 21:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236331AbiGVTej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 15:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbiGVTei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 15:34:38 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DE851A1F
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 12:34:37 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id mf4so10252817ejc.3
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 12:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lR1hZw0XukXpRfFvnSBQAvUqz/OTx4MLjptGdrtodks=;
        b=RmWZsbClWP7Fh/dEvfMZZIOjGBmiGK+YAv8r0SldDmAZSzO7RZQ1R6ZZsjpT2IkvmC
         db4+XkEFrBvzDTuYFlN2tfNuG5PLwNPu1zNgL0IIFI0bkxC6c7RllPHF4ljJNWI0hW9Y
         7xhtPuKQ+leyCbWiN2i+9wBr1DHsef1ZRkHkMpxka9vWWOXbT/hPsVa+KwPmDFdLN++8
         iJVTc8coXzJ1t8nFcuJMRq8xebx8mK/UnfgjRIlbAYqLjUGIeVKbWvivjB+r31ir7TcO
         LcTu6s24DZ0fDqwPkDVFuePBY4lY6blXIWa69Y/FgXxbq8xrK94lHEoudYQIJvV92YUt
         haBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lR1hZw0XukXpRfFvnSBQAvUqz/OTx4MLjptGdrtodks=;
        b=sg/UjarKvar3GwERrKg7+pgSAL7zHpHX6UR1CZypImPiD0vEYPfBTRKtSUmGt1OFth
         PayMKjaM0jlfaf749km7SXkuOc2tyQPVCRgPisHm+NAsarjonA46cnqG9I4e1QsBg7MR
         8GWrI0aO+Ap51JbuVJhlL39sHpdsFqhKtJLtRVTe8N4rdaWTIMZL8oOa9h/jsth+BbrZ
         qVc4jw0mMem/Mm2P7NimFgkO4usNYjGNcSpaPRa9GwWtl/uU85MC9/928LTPJHpOjKSl
         A8e7VGxjvL3qNWlFOzh+5CRK9/S6rQUAWCCa+Bu630lTAPI71Dd7GftbfQ5zLN5MMHjP
         LT0A==
X-Gm-Message-State: AJIora+kzjtr+WpiAg45tDvekjWcEj/Oad1PmoLEemg38+Ceq8wJtVCM
        ZaBHY4cXQ7JrY0i3iNwJJhs=
X-Google-Smtp-Source: AGRyM1sFlh+eb5/k0Y3cAejYshv0yjFKwRVwNo5LjTUwWOX6tAmmppRXWfAFkMnIK5sbGABIC/OIpw==
X-Received: by 2002:a17:907:2cf3:b0:72b:8ac1:a21f with SMTP id hz19-20020a1709072cf300b0072b8ac1a21fmr1068785ejc.291.1658518475312;
        Fri, 22 Jul 2022 12:34:35 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id l10-20020a170906938a00b006f3ef214daesm2349416ejx.20.2022.07.22.12.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 12:34:34 -0700 (PDT)
Date:   Fri, 22 Jul 2022 22:34:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH v2 net-next 08/19] ipmr: do not acquire mrt_lock while
 calling ip_mr_forward()
Message-ID: <20220722193432.zdcnnxyigq2yozok@skbuf>
References: <20220623043449.1217288-1-edumazet@google.com>
 <20220623043449.1217288-1-edumazet@google.com>
 <20220623043449.1217288-9-edumazet@google.com>
 <20220623043449.1217288-9-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623043449.1217288-9-edumazet@google.com>
 <20220623043449.1217288-9-edumazet@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Thu, Jun 23, 2022 at 04:34:38AM +0000, Eric Dumazet wrote:
> ip_mr_forward() uses standard RCU protection already.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv4/ipmr.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> index 6ea54bc3d9b6555aaa9974d81ba4acd47481724f..b0f2e6d79d62273c8c2682f28cb45fe5ec3df6f3 100644
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -1817,7 +1817,7 @@ static bool ipmr_forward_offloaded(struct sk_buff *skb, struct mr_table *mrt,
>  }
>  #endif
>  
> -/* Processing handlers for ipmr_forward */
> +/* Processing handlers for ipmr_forward, under rcu_read_lock() */
>  
>  static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
>  			    int in_vifi, struct sk_buff *skb, int vifi)
> @@ -1839,9 +1839,7 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
>  		WRITE_ONCE(vif->bytes_out, vif->bytes_out + skb->len);
>  		vif_dev->stats.tx_bytes += skb->len;
>  		vif_dev->stats.tx_packets++;
> -		rcu_read_lock();
>  		ipmr_cache_report(mrt, skb, vifi, IGMPMSG_WHOLEPKT);
> -		rcu_read_unlock();
>  		goto out_free;
>  	}
>  
> @@ -1936,6 +1934,7 @@ static int ipmr_find_vif(const struct mr_table *mrt, struct net_device *dev)
>  }
>  
>  /* "local" means that we should preserve one skb (for local delivery) */
> +/* Called uner rcu_read_lock() */
>  static void ip_mr_forward(struct net *net, struct mr_table *mrt,
>  			  struct net_device *dev, struct sk_buff *skb,
>  			  struct mfc_cache *c, int local)
> @@ -1992,12 +1991,10 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
>  			       c->_c.mfc_un.res.last_assert +
>  			       MFC_ASSERT_THRESH)) {
>  			c->_c.mfc_un.res.last_assert = jiffies;
> -			rcu_read_lock();
>  			ipmr_cache_report(mrt, skb, true_vifi, IGMPMSG_WRONGVIF);
>  			if (mrt->mroute_do_wrvifwhole)
>  				ipmr_cache_report(mrt, skb, true_vifi,
>  						  IGMPMSG_WRVIFWHOLE);
> -			rcu_read_unlock();
>  		}
>  		goto dont_forward;
>  	}
> @@ -2169,9 +2166,7 @@ int ip_mr_input(struct sk_buff *skb)
>  		return -ENODEV;
>  	}
>  
> -	read_lock(&mrt_lock);
>  	ip_mr_forward(net, mrt, dev, skb, cache, local);
> -	read_unlock(&mrt_lock);
>  
>  	if (local)
>  		return ip_local_deliver(skb);
> -- 
> 2.37.0.rc0.104.g0611611a94-goog
> 

Sorry for reporting this late, but there seems to be 1 call path from
which RCU is not watching in ip_mr_forward(). It's via ipmr_mfc_add() ->
ipmr_cache_resolve() -> ip_mr_forward().

The warning looks like this:

[  632.062382] =============================
[  632.068568] WARNING: suspicious RCU usage
[  632.073702] 5.19.0-rc7-07010-ga9b9500ffaac-dirty #3374 Not tainted
[  632.081098] -----------------------------
[  632.086216] net/ipv4/ipmr.c:1080 suspicious rcu_dereference_check() usage!
[  632.094152]
[  632.094152] other info that might help us debug this:
[  632.103349]
[  632.103349] rcu_scheduler_active = 2, debug_locks = 1
[  632.111011] 1 lock held by smcrouted/359:
[  632.116079]  #0: ffffd27b44d23770 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x1c/0x30
[  632.124703]
[  632.124703] stack backtrace:
[  632.129681] CPU: 0 PID: 359 Comm: smcrouted Not tainted 5.19.0-rc7-07010-ga9b9500ffaac-dirty #3374
[  632.143426] Call trace:
[  632.160542]  lockdep_rcu_suspicious+0xf8/0x10c
[  632.165014]  ipmr_cache_report+0x2f0/0x530
[  632.169137]  ip_mr_forward+0x364/0x38c
[  632.172909]  ipmr_mfc_add+0x894/0xc90
[  632.176592]  ip_mroute_setsockopt+0x6ac/0x950
[  632.180973]  ip_setsockopt+0x16a0/0x16ac
[  632.184921]  raw_setsockopt+0x110/0x184
[  632.188780]  sock_common_setsockopt+0x1c/0x2c
[  632.193163]  __sys_setsockopt+0x94/0x170
[  632.197111]  __arm64_sys_setsockopt+0x2c/0x40
[  632.201492]  invoke_syscall+0x48/0x114

I don't exactly understand the data structures that are used inside ip_mr_forward(),
so I'm unable to say what needs RCU protection and what is fine with the rtnl_mutex
that we are holding, just annotated poorly. Could you please take a look?
