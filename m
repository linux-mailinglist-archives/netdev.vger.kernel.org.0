Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46F26D16D5
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 07:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjCaFfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 01:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCaFfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 01:35:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67AC83C8
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 22:35:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D8446234A
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 05:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74076C433EF;
        Fri, 31 Mar 2023 05:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680240920;
        bh=HhwhM63LVB3ZAGYyOWpm4BV2W9oteQaaNdxZnABoJy0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CGmRDcec1Q47oofC93PkjP+uG9qkjT3JtExCN3IrmMoqOqqfiDgIMe7ehcB3y6DJx
         A125KFz+BJQn/c6K48xSl+yYZm44f+xpJZa4OUN+CRzmlZbUw7MoqxsaVRQFTPy7aw
         rZgbyovFdbTRdkmKd9HNCm/3R6Z3u5dmh8f0ygSgySb040WnCYYAHHyQwlbQrXU0Wg
         HY5+ZL5kPd9tTdRJoUaOVByg6JnW6tIT2Mqap8B+uTZp8tHQQx0TqTs/I6MT3npqCi
         TAccOFISV0wCuiaYzf1ouZYLuycWrv6jj1rZjAAUo89s8J2YE4tk3EvBWDKQ/KyusT
         rwq7mpBo0Oh6A==
Date:   Thu, 30 Mar 2023 22:35:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Message-ID: <20230330223519.36ce7d23@kernel.org>
In-Reply-To: <20230331045619.40256-1-glipus@gmail.com>
References: <20230331045619.40256-1-glipus@gmail.com>
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

On Thu, 30 Mar 2023 22:56:19 -0600 Maxim Georgiev wrote:
> @@ -1642,6 +1650,10 @@ struct net_device_ops {
>  	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
>  						  const struct skb_shared_hwtstamps *hwtstamps,
>  						  bool cycles);
> +	int			(*ndo_hwtstamp_get)(struct net_device *dev,
> +						    struct hwtstamp_config *config);
> +	int			(*ndo_hwtstamp_set)(struct net_device *dev,
> +						    struct hwtstamp_config *config);

I wonder if we should pass in 

	struct netlink_ext_ack *extack

and maybe another structure for future extensions?
So we don't have to change the drivers again when we extend uAPI.

>  };
>  
>  struct xdp_metadata_ops {
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index 5cdbfbf9a7dc..c90fac9a9b2e 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -277,6 +277,39 @@ static int dev_siocbond(struct net_device *dev,
>  	return -EOPNOTSUPP;
>  }
>  
> +static int dev_hwtstamp(struct net_device *dev, struct ifreq *ifr,
> +			unsigned int cmd)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	int err;
> +	struct hwtstamp_config config;

nit: reorder int err after config we like lines longest to shortest

> +
> +	if ((cmd == SIOCGHWTSTAMP && !ops->ndo_hwtstamp_get) ||
> +	    (cmd == SIOCSHWTSTAMP && !ops->ndo_hwtstamp_set))
> +		return dev_eth_ioctl(dev, ifr, cmd);
> +
> +	err = dsa_ndo_eth_ioctl(dev, ifr, cmd);
> +	if (err == 0 || err != -EOPNOTSUPP)
> +		return err;
> +
> +	if (!netif_device_present(dev))
> +		return -ENODEV;
> +
> +	if (cmd == SIOCSHWTSTAMP) {
> +		if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> +			err = -EFAULT;
> +		else
> +			err = ops->ndo_hwtstamp_set(dev, &config);
> +	} else if (cmd == SIOCGHWTSTAMP) {
> +		err = ops->ndo_hwtstamp_get(dev, &config);
> +	}
> +
> +	if (err == 0)
> +		err = copy_to_user(ifr->ifr_data, &config,
> +				   sizeof(config)) ? -EFAULT : 0;

nit: just error check each return value, don't try to save LoC

> +	return err;
> +}
> +
>  static int dev_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
>  			      void __user *data, unsigned int cmd)
>  {
> @@ -391,11 +424,14 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
>  		rtnl_lock();
>  		return err;
>  
> +	case SIOCGHWTSTAMP:
> +		return dev_hwtstamp(dev, ifr, cmd);
> +
>  	case SIOCSHWTSTAMP:
>  		err = net_hwtstamp_validate(ifr);
>  		if (err)
>  			return err;
> -		fallthrough;
> +		return dev_hwtstamp(dev, ifr, cmd);

Let's refactor this differently, we need net_hwtstamp_validate()
to run on the same in-kernel copy as we'll send down to the driver.
If we copy_from_user() twice we may validate a different thing
than the driver will end up seeing (ToCToU).

TBH I'm not sure if keeping GET and SET in a common dev_hwtstamp()
ends up being beneficial. If we fold in the validation check half 
of the code will be under and if (GET) or if (SET)..
