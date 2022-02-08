Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA724AE238
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 20:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237526AbiBHT1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 14:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiBHT1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 14:27:45 -0500
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CA1C0613CB
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 11:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1644348458;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=jqHdnC2kOuUzCVOkrW7OOaRrkbyR18+zFeXarL1nnBU=;
    b=Tj1TB2MiLKzbtrijhYSCgDvsgAW/8Ow9HEk9M88K/gVHgshqeJl+8A8YhGRm4bFSjf
    CE8kjn+8o6TB5uKpbP0YV8aJO7BTiI5LAqXUdFqwZGD1mrecnB3Y9oVqmmexTog4tEPl
    mLkDZGSQ540dNmchoEBcaZnlYz7TfyP0xRcORrdJEtZaMV995rec2ua4GVpr6WqUXWzP
    2L/7/BU7rjle6V4b7xFavNhPwSmeYqFboE6CgR+uo5Fu3G9F7jXKULk1wLFZAaXSfjE5
    t+xgY1DrS7y+evFUEAxMP2/pPjDEBDT+f1OrLQwzo1A6Jv51f0y/LmRqstZh4gh71wcI
    MKWQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXTKq7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::bd7]
    by smtp.strato.de (RZmta 47.39.0 AUTH)
    with ESMTPSA id L7379cy18JRcNBH
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 8 Feb 2022 20:27:38 +0100 (CET)
Message-ID: <43ec78a3-2cde-35c4-51e9-de72d00fbe99@hartkopp.net>
Date:   Tue, 8 Feb 2022 20:27:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] can: gw: use call_rcu() instead of costly
 synchronize_rcu()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
References: <20220207190706.1499190-1-eric.dumazet@gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220207190706.1499190-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.02.22 20:07, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Commit fb8696ab14ad ("can: gw: synchronize rcu operations
> before removing gw job entry") added three synchronize_rcu() calls
> to make sure one rcu grace period was observed before freeing
> a "struct cgw_job" (which are tiny objects).
> 
> This should be converted to call_rcu() to avoid adding delays
> in device / network dismantles.
> 
> Use the rcu_head that was already in struct cgw_job,
> not yet used.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>

Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks Eric!

> ---
>   net/can/gw.c | 16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/net/can/gw.c b/net/can/gw.c
> index d8861e862f157aec36c417b71eb7e8f59bd064b9..20e74fe7d0906dccc65732b8f9e7e14e2d1192c3 100644
> --- a/net/can/gw.c
> +++ b/net/can/gw.c
> @@ -577,6 +577,13 @@ static inline void cgw_unregister_filter(struct net *net, struct cgw_job *gwj)
>   			  gwj->ccgw.filter.can_mask, can_can_gw_rcv, gwj);
>   }
>   
> +static void cgw_job_free_rcu(struct rcu_head *rcu_head)
> +{
> +	struct cgw_job *gwj = container_of(rcu_head, struct cgw_job, rcu);
> +
> +	kmem_cache_free(cgw_cache, gwj);
> +}
> +
>   static int cgw_notifier(struct notifier_block *nb,
>   			unsigned long msg, void *ptr)
>   {
> @@ -596,8 +603,7 @@ static int cgw_notifier(struct notifier_block *nb,
>   			if (gwj->src.dev == dev || gwj->dst.dev == dev) {
>   				hlist_del(&gwj->list);
>   				cgw_unregister_filter(net, gwj);
> -				synchronize_rcu();
> -				kmem_cache_free(cgw_cache, gwj);
> +				call_rcu(&gwj->rcu, cgw_job_free_rcu);
>   			}
>   		}
>   	}
> @@ -1155,8 +1161,7 @@ static void cgw_remove_all_jobs(struct net *net)
>   	hlist_for_each_entry_safe(gwj, nx, &net->can.cgw_list, list) {
>   		hlist_del(&gwj->list);
>   		cgw_unregister_filter(net, gwj);
> -		synchronize_rcu();
> -		kmem_cache_free(cgw_cache, gwj);
> +		call_rcu(&gwj->rcu, cgw_job_free_rcu);
>   	}
>   }
>   
> @@ -1224,8 +1229,7 @@ static int cgw_remove_job(struct sk_buff *skb, struct nlmsghdr *nlh,
>   
>   		hlist_del(&gwj->list);
>   		cgw_unregister_filter(net, gwj);
> -		synchronize_rcu();
> -		kmem_cache_free(cgw_cache, gwj);
> +		call_rcu(&gwj->rcu, cgw_job_free_rcu);
>   		err = 0;
>   		break;
>   	}
