Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F9858164C
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 17:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbiGZPVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 11:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiGZPVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 11:21:05 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7858D6158
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 08:21:04 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z22so18123442edd.6
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 08:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xuDzkrx6K7ENSV1+LXU4Oqee2TZG3AiU/nj2btXSqWY=;
        b=MUx6MDVyaw6vlBB/jPQXBuBGDHDBZ8v7ZL2mMSa6pXoU9vCKYKnPIA7q6nYXFbiTZl
         zYLhbQbhC1y2c3/gdWOzP4a17gd/DB5LLofzx3tkrnIV9s8lcyCQq5M+dt70t+5wTcU+
         SWTU/gviY0cqE3FtHQ/kdddWvM6AIKyn88J0w3PehzoP0xf/7S8jvLU6Z8HUGWvtuk0p
         sQW2QQn43yuSWNzzfeIbgedlcpd6qcjrr4EPNhPYBYuOIO7k+WSyKx1Qtks02guTb5Cl
         3LY0FBJOmGE4OARyt99h84FZwCfZFnr4gfBHXL5nSKcUFYckAUK7NJZs+TR0dmwbfB4q
         KITA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xuDzkrx6K7ENSV1+LXU4Oqee2TZG3AiU/nj2btXSqWY=;
        b=05GcRM97PGGJbZlgnatb/aVKzq1FQandK5qB2ti9WNDerKAj4Qvs2I1r8RWTt2JO+p
         /7vy5X0ye+F1F3JPKkpvzs0Dm4emquzeHaudMSkoturhNl5wdMuD2DHRASYoR2t2+6w7
         EJPlCu7kFHwx21TP9tcgkzDJPfkb9xI7UTJI59F0csS5RZfIQSC1LfjO8XjlXN9NXIgt
         FFrHf64/YtDsv56ba9J9cLoMkLutYgeuJ/2LgcAQRk8wBBwgVLK+W6PJVL+8MmRfs7w0
         vRPzA5cpYFQYZ4WWPqNVJrb7BW3XU3ovd1ymthirHIG9sTSIXZdC1BFDAcvHj47hiucS
         yodw==
X-Gm-Message-State: AJIora/1QTVhsy+z/8aQGltzoBMLzDZHtd/dRZgTG8fhY7eQ9HfzQQz0
        cT/SLTQ5lDzAhEIXOiLNcDQ=
X-Google-Smtp-Source: AGRyM1tTCbcJwEN7aGVHRl4tylvK0lIJQClx/mULFSkN7DCJuyemOEcQ6FfZ1BLzrRa9TcxOdVGG2g==
X-Received: by 2002:a05:6402:d77:b0:43b:bcdc:ec9b with SMTP id ec55-20020a0564020d7700b0043bbcdcec9bmr19230871edb.183.1658848862543;
        Tue, 26 Jul 2022 08:21:02 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id l1-20020a1709063d2100b006fec27575f1sm6557141ejf.123.2022.07.26.08.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 08:21:01 -0700 (PDT)
Date:   Tue, 26 Jul 2022 18:20:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [patch net-next RFC] net: dsa: move port_setup/teardown to be
 called outside devlink port registered area
Message-ID: <20220726152059.bls6gn7ludfutamy@skbuf>
References: <20220726124105.495652-1-jiri@resnulli.us>
 <20220726134309.qiloewsgtkojf6yq@skbuf>
 <20220726124105.495652-1-jiri@resnulli.us>
 <20220726134309.qiloewsgtkojf6yq@skbuf>
 <Yt/+GKVZi+WtAftm@nanopsycho>
 <Yt/+GKVZi+WtAftm@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yt/+GKVZi+WtAftm@nanopsycho>
 <Yt/+GKVZi+WtAftm@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 04:45:44PM +0200, Jiri Pirko wrote:
> Oh yes, could you please try together with following patch? (nevermind
> chicken-egg problem you may spot now)

Duly ignoring ;)

> Subject: [patch net-next RFC] net: devlink: convert region creation/destroy()
>  to be forbidden on registered devlink/port
> 
> No need to create or destroy region when devlink or devlink ports are
> registered. Limit the possibility to call the region create/destroy()
> only for non-registered devlink or devlink port. Benefit from that and
> avoid need to take devl_lock.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  drivers/net/netdevsim/dev.c |  8 ++--
>  include/net/devlink.h       |  5 ---
>  net/core/devlink.c          | 78 ++++++++-----------------------------
>  3 files changed, 20 insertions(+), 71 deletions(-)
> 
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index 925dc8a5254d..3f0c19e30650 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -557,15 +557,15 @@ static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
>  				      struct devlink *devlink)
>  {
>  	nsim_dev->dummy_region =
> -		devl_region_create(devlink, &dummy_region_ops,
> -				   NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
> -				   NSIM_DEV_DUMMY_REGION_SIZE);
> +		devlink_region_create(devlink, &dummy_region_ops,
> +				      NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
> +				      NSIM_DEV_DUMMY_REGION_SIZE);
>  	return PTR_ERR_OR_ZERO(nsim_dev->dummy_region);
>  }
>  
>  static void nsim_dev_dummy_region_exit(struct nsim_dev *nsim_dev)
>  {
> -	devl_region_destroy(nsim_dev->dummy_region);
> +	devlink_region_destroy(nsim_dev->dummy_region);
>  }
>  
>  static int
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 9edb4a28cf30..2416750e050d 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1666,10 +1666,6 @@ int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
>  int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
>  				       union devlink_param_value init_val);
>  void devlink_param_value_changed(struct devlink *devlink, u32 param_id);
> -struct devlink_region *devl_region_create(struct devlink *devlink,
> -					  const struct devlink_region_ops *ops,
> -					  u32 region_max_snapshots,
> -					  u64 region_size);
>  struct devlink_region *
>  devlink_region_create(struct devlink *devlink,
>  		      const struct devlink_region_ops *ops,
> @@ -1678,7 +1674,6 @@ struct devlink_region *
>  devlink_port_region_create(struct devlink_port *port,
>  			   const struct devlink_port_region_ops *ops,
>  			   u32 region_max_snapshots, u64 region_size);
> -void devl_region_destroy(struct devlink_region *region);
>  void devlink_region_destroy(struct devlink_region *region);
>  void devlink_port_region_destroy(struct devlink_region *region);
>  
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 4e0c4f9265e8..15d28aba69fc 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -5701,8 +5701,7 @@ static void devlink_nl_region_notify(struct devlink_region *region,
>  	struct sk_buff *msg;
>  
>  	WARN_ON(cmd != DEVLINK_CMD_REGION_NEW && cmd != DEVLINK_CMD_REGION_DEL);
> -	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
> -		return;
> +	ASSERT_DEVLINK_REGISTERED(devlink);
>  
>  	msg = devlink_nl_region_notify_build(region, snapshot, cmd, 0, 0);
>  	if (IS_ERR(msg))
> @@ -11131,21 +11130,22 @@ void devlink_param_value_changed(struct devlink *devlink, u32 param_id)
>  EXPORT_SYMBOL_GPL(devlink_param_value_changed);
>  
>  /**
> - * devl_region_create - create a new address region
> + * devlink_region_create - create a new address region
>   *
>   * @devlink: devlink
>   * @ops: region operations and name
>   * @region_max_snapshots: Maximum supported number of snapshots for region
>   * @region_size: size of region
>   */
> -struct devlink_region *devl_region_create(struct devlink *devlink,
> -					  const struct devlink_region_ops *ops,
> -					  u32 region_max_snapshots,
> -					  u64 region_size)
> +struct devlink_region *
> +devlink_region_create(struct devlink *devlink,
> +		      const struct devlink_region_ops *ops,
> +		      u32 region_max_snapshots,
> +		      u64 region_size)
>  {
>  	struct devlink_region *region;
>  
> -	devl_assert_locked(devlink);
> +	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
>  
>  	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
>  		return ERR_PTR(-EINVAL);
> @@ -11164,35 +11164,9 @@ struct devlink_region *devl_region_create(struct devlink *devlink,
>  	INIT_LIST_HEAD(&region->snapshot_list);
>  	mutex_init(&region->snapshot_lock);
>  	list_add_tail(&region->list, &devlink->region_list);
> -	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
>  
>  	return region;
>  }
> -EXPORT_SYMBOL_GPL(devl_region_create);
> -
> -/**
> - *	devlink_region_create - create a new address region
> - *
> - *	@devlink: devlink
> - *	@ops: region operations and name
> - *	@region_max_snapshots: Maximum supported number of snapshots for region
> - *	@region_size: size of region
> - *
> - *	Context: Takes and release devlink->lock <mutex>.
> - */
> -struct devlink_region *
> -devlink_region_create(struct devlink *devlink,
> -		      const struct devlink_region_ops *ops,
> -		      u32 region_max_snapshots, u64 region_size)
> -{
> -	struct devlink_region *region;
> -
> -	devl_lock(devlink);
> -	region = devl_region_create(devlink, ops, region_max_snapshots,
> -				    region_size);
> -	devl_unlock(devlink);
> -	return region;
> -}
>  EXPORT_SYMBOL_GPL(devlink_region_create);
>  
>  /**

Were you on net-next when you generated this patch? Here's what I have
at 11164:

devlink_port_region_create:
	if (devlink_port_region_get_by_name(port, ops->name)) {
		err = -EEXIST;
		goto unlock;
	}

	region = kzalloc(sizeof(*region), GFP_KERNEL);
	if (!region) {

My end of devl_region_create() and start of devlink_region_create() are
at 11106, but notice how I lack the mutex_init(&region->snapshot_lock)
that you have in your context:

	INIT_LIST_HEAD(&region->snapshot_list);
	list_add_tail(&region->list, &devlink->region_list);
	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);

	return region;
}
EXPORT_SYMBOL_GPL(devl_region_create);

Would you mind regenerating this patch rather than letting me bodge it?
