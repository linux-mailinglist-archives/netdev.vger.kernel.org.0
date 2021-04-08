Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4600E358F0F
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhDHVQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232482AbhDHVQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 17:16:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13B3E61181;
        Thu,  8 Apr 2021 21:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617916580;
        bh=h5R/Ukb+PlbmY00u4I7MIvwLkBT1oYLfsmuDGEmCSlU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BnJEi+v1jnKC7ShFTaU695erV0P2hthz2CVt74VvRfssOFC20VQWTvtMVJWDOxtN0
         hyW14HndRl1qMHVSnDgdCaYI5k2e616xKax6nZSHQWkc1ES/LGXAmRn4XuIqYBqIRG
         TqknftBUYU1AnIh4NY8D1apbsLtStD3UTHPmhaXcop+E85DLUKmR1BS3nIj0nTqB02
         117iCN/U51YgB30Sk/SldgrC6mX/uHsY+N/XYyERJjx1opNHiW8iSZCHYmMgy9J0Ai
         ciQMf8H+ls6YC3bJ8pthPh6BTGha8ePN/fMK/jxvSVoz+iUzm9XS1c5l1ugVZLl334
         sy6IcqUCtECHg==
Date:   Thu, 8 Apr 2021 14:16:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jianbo Liu <jianbol@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <pablo@netfilter.org>,
        Roi Dayan <roid@nvidia.com>
Subject: Re: [PATCH net] net: flow_offload: Fix UBSAN invalid-load warning
 in tcf_block_unbind
Message-ID: <20210408141619.7dd765b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210408074718.14331-1-jianbol@nvidia.com>
References: <20210408074718.14331-1-jianbol@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Apr 2021 07:47:18 +0000 Jianbo Liu wrote:
> When device is removed, indirect block is unregisterd. As
> bo->unlocked_driver_cb is not initialized, the following UBSAN is
> triggered.
> 
> UBSAN: invalid-load in net/sched/cls_api.c:1496:10
> load of value 6 is not a valid value for type '_Bool'
> 
> This patch fixes the warning by calling device's indr block bind
> callback, and unlocked_driver_cb is assigned with correct value.
> 
> Fixes: 0fdcf78d5973 ("net: use flow_indr_dev_setup_offload()")
> Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>

It's been a while since I looked at this code but I don't understand
what you're doing here.

The init in tc_block_indr_cleanup() makes sense. What's the change to
setup_cb achieving? Thanks.

> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index dc5c1e69cd9f..8cdc60833890 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -459,6 +459,11 @@ typedef int flow_setup_cb_t(enum tc_setup_type type, void *type_data,
>  
>  struct flow_block_cb;
>  
> +typedef int flow_indr_block_bind_cb_t(struct net_device *dev, struct Qdisc *sch, void *cb_priv,
> +				      enum tc_setup_type type, void *type_data,
> +				      void *data,
> +				      void (*cleanup)(struct flow_block_cb *block_cb));
> +
>  struct flow_block_indr {
>  	struct list_head		list;
>  	struct net_device		*dev;
> @@ -466,6 +471,7 @@ struct flow_block_indr {
>  	enum flow_block_binder_type	binder_type;
>  	void				*data;
>  	void				*cb_priv;
> +	flow_indr_block_bind_cb_t	*setup_cb;
>  	void				(*cleanup)(struct flow_block_cb *block_cb);
>  };
>  
> @@ -562,11 +568,6 @@ static inline void flow_block_init(struct flow_block *flow_block)
>  	INIT_LIST_HEAD(&flow_block->cb_list);
>  }
>  
> -typedef int flow_indr_block_bind_cb_t(struct net_device *dev, struct Qdisc *sch, void *cb_priv,
> -				      enum tc_setup_type type, void *type_data,
> -				      void *data,
> -				      void (*cleanup)(struct flow_block_cb *block_cb));
> -
>  int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv);
>  void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
>  			      void (*release)(void *cb_priv));
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 715b67f6c62f..85a3d8530952 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -373,7 +373,8 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
>  }
>  EXPORT_SYMBOL(flow_indr_dev_register);
>  
> -static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
> +static void __flow_block_indr_cleanup(struct flow_indr_dev *indr_dev,
> +				      void (*release)(void *cb_priv),
>  				      void *cb_priv,
>  				      struct list_head *cleanup_list)
>  {
> @@ -381,8 +382,10 @@ static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
>  
>  	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
>  		if (this->release == release &&
> -		    this->indr.cb_priv == cb_priv)
> +		    this->indr.cb_priv == cb_priv) {
> +			this->indr.setup_cb = indr_dev->cb;
>  			list_move(&this->indr.list, cleanup_list);
> +		}
>  	}
>  }
>  
> @@ -390,10 +393,8 @@ static void flow_block_indr_notify(struct list_head *cleanup_list)
>  {
>  	struct flow_block_cb *this, *next;
>  
> -	list_for_each_entry_safe(this, next, cleanup_list, indr.list) {
> -		list_del(&this->indr.list);
> +	list_for_each_entry_safe(this, next, cleanup_list, indr.list)
>  		this->indr.cleanup(this);
> -	}
>  }
>  
>  void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
> @@ -418,7 +419,7 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
>  		return;
>  	}
>  
> -	__flow_block_indr_cleanup(release, cb_priv, &cleanup_list);
> +	__flow_block_indr_cleanup(this, release, cb_priv, &cleanup_list);
>  	mutex_unlock(&flow_indr_block_lock);
>  
>  	flow_block_indr_notify(&cleanup_list);
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index d3db70865d66..b213206da728 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -646,7 +646,7 @@ static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
>  	struct net_device *dev = block_cb->indr.dev;
>  	struct Qdisc *sch = block_cb->indr.sch;
>  	struct netlink_ext_ack extack = {};
> -	struct flow_block_offload bo;
> +	struct flow_block_offload bo = {};
>  
>  	tcf_block_offload_init(&bo, dev, sch, FLOW_BLOCK_UNBIND,
>  			       block_cb->indr.binder_type,
> @@ -654,8 +654,13 @@ static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
>  			       &extack);
>  	rtnl_lock();
>  	down_write(&block->cb_lock);
> -	list_del(&block_cb->driver_list);
> -	list_move(&block_cb->list, &bo.cb_list);
> +	if (!block_cb->indr.setup_cb ||
> +	    block_cb->indr.setup_cb(dev, sch, block_cb->indr.cb_priv,
> +				    TC_SETUP_BLOCK, &bo, block, NULL)) {
> +		list_del(&block_cb->indr.list);
> +		list_del(&block_cb->driver_list);
> +		list_move(&block_cb->list, &bo.cb_list);
> +	}
>  	tcf_block_unbind(block, &bo);
>  	up_write(&block->cb_lock);
>  	rtnl_unlock();

