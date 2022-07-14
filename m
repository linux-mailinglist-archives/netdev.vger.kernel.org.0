Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952A657420E
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbiGNDzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGNDzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:55:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04686222B4
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:55:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9125A61E21
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0C6C34115;
        Thu, 14 Jul 2022 03:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657770910;
        bh=NCxYmFjTaEVRvOWLgPxeNjyIE0TY5qkJvRYXMk0E29I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=squOHAsqXIGGckmW7yMGZJyQNMIO943S6TLIvT08ghPEzj9V5oGTLdW8xZNRvp3Bd
         tOzgv0v+/kg7sgWy9p37wRrblXfjuZO0+qP+C5KRUjVLOhNTVdXOQMTfgVuk4yEsPn
         fuBUo/LopvUsz7igoCFAsFPCng34SQbis0MbQYsA2zsPbG6QkR5iYRQR7sNpwfGfDy
         EXNgWlmazgC6/y1DCB3qoRa4K/Vtfh5uHkEemqMoGmjgCEV+ze3PxsDba4RNwtotog
         Zmiz6OGBEL2DiUZNUwvs3lnIyQXryH7KLy+novg4QgK7kPzDW7AsbmaQTvKPVpwUjV
         tZ/g/SyoQuJig==
Date:   Wed, 13 Jul 2022 20:55:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/8] amt: use workqueue for gateway side message
 handling
Message-ID: <20220713205509.2a79563a@kernel.org>
In-Reply-To: <20220712105714.12282-2-ap420073@gmail.com>
References: <20220712105714.12282-1-ap420073@gmail.com>
        <20220712105714.12282-2-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jul 2022 10:57:07 +0000 Taehee Yoo wrote:
> @@ -2392,12 +2429,14 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
>  	skb->pkt_type = PACKET_MULTICAST;
>  	skb->ip_summed = CHECKSUM_NONE;
>  	len = skb->len;
> +	rcu_read_lock_bh();
>  	if (__netif_rx(skb) == NET_RX_SUCCESS) {
>  		amt_update_gw_status(amt, AMT_STATUS_RECEIVED_QUERY, true);
>  		dev_sw_netstats_rx_add(amt->dev, len);
>  	} else {
>  		amt->dev->stats.rx_dropped++;
>  	}
> +	rcu_read_unlock_bh();
>  
>  	return false;
>  }

The RCU lock addition looks potentially unrelated?

> @@ -2892,10 +3007,21 @@ static int amt_dev_stop(struct net_device *dev)
>  	struct amt_dev *amt = netdev_priv(dev);
>  	struct amt_tunnel_list *tunnel, *tmp;
>  	struct socket *sock;
> +	struct sk_buff *skb;
> +	int i;
>  
>  	cancel_delayed_work_sync(&amt->req_wq);
>  	cancel_delayed_work_sync(&amt->discovery_wq);
>  	cancel_delayed_work_sync(&amt->secret_wq);
> +	cancel_work_sync(&amt->event_wq);

Are you sure the work will not get scheduled again?
What has stopped packet Rx at this point?

> +	for (i = 0; i < AMT_MAX_EVENTS; i++) {
> +		skb = amt->events[i].skb;
> +		if (skb)
> +			kfree_skb(skb);
> +		amt->events[i].event = AMT_EVENT_NONE;
> +		amt->events[i].skb = NULL;
> +	}
> 
>  	/* shutdown */
>  	sock = rtnl_dereference(amt->sock);
> @@ -3051,6 +3177,8 @@ static int amt_newlink(struct net *net, struct net_device *dev,
>  		amt->max_tunnels = AMT_MAX_TUNNELS;
>  
>  	spin_lock_init(&amt->lock);
> +	amt->event_idx = 0;
> +	amt->nr_events = 0;

no need to init member of netdev_priv() to 0, it's zalloc'ed

>  	amt->max_groups = AMT_MAX_GROUP;
>  	amt->max_sources = AMT_MAX_SOURCE;
>  	amt->hash_buckets = AMT_HSIZE;
