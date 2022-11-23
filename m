Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5306356F9
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 10:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbiKWJgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 04:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237907AbiKWJf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 04:35:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50576F72FE
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 01:33:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BAE1B81E54
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5B4C433D7;
        Wed, 23 Nov 2022 09:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669196001;
        bh=K+W78ogsVHHG48hfc7uDaCJCo8+wvL/f5nh+x34eQ5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dvn7DXvRGGxfEniR/QyeqHbMh6taeRnkJr5HzEr0ccS55tL2R+x0dK4vJPvV4eqRI
         NrUTHEp9zy5lCYrinBNEtG8GZkvafgIxsjcAqqo7v5IHbL7/fl7P8YkLo9ednoa5AX
         Qvzi4uZQt3liQN7fiVqO4MxTpW2kaYUQy7KVkfE8hkTqB0+cH8+Ilh7q9aE8sfl/3k
         Qdi0O0marWzNn7rnzHjMm/pHSQikRkqnu3WgQXpvY4JR5WZUPDFCIH4VMddtIECZHf
         gDR5t8+iX5M0RY1UvLLKBeY2EokqgzkVSuwQdDZz+IRxR4+OCJxlDX7xzvZXbteWHP
         2E01P4lfAW2tg==
Date:   Wed, 23 Nov 2022 11:33:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y33o2iB9RAoSY6hZ@unreal>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
 <Y3zdaX1I0Y8rdSLn@unreal>
 <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
 <Y30dPRzO045Od2FA@unreal>
 <20221122122740.4b10d67d@kernel.org>
 <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
 <Y33OpMvLcAcnJ1oj@unreal>
 <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 04:34:49PM +0800, Yang Yingliang wrote:
> 
> On 2022/11/23 15:41, Leon Romanovsky wrote:
> > On Wed, Nov 23, 2022 at 02:40:24PM +0800, Yang Yingliang wrote:
> > > On 2022/11/23 4:27, Jakub Kicinski wrote:
> > > > On Tue, 22 Nov 2022 21:04:29 +0200 Leon Romanovsky wrote:
> > > > > > > Please fix nsim instead of devlink.
> > > > > > I think if devlink is not registered, it can not be get and used, but there
> > > > > > is no API for driver to check this, can I introduce a new helper name
> > > > > > devlink_is_registered() for driver using.
> > > > > There is no need in such API as driver calls to devlink_register() and
> > > > > as such it knows when devlink is registered.
> > > > > 
> > > > > This UAF is nsim specific issue. Real devices have single .probe()
> > > > > routine with serialized registration flow. None of them will use
> > > > > devlink_is_registered() call.
> > > > Agreed, the fix is to move the register call back.
> > > > Something along the lines of the untested patch below?
> > > > Yang Yingliang would you be able to turn that into a real patch?
> > > > 
> > > > diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> > > > index e14686594a71..26602d5fe0a2 100644
> > > > --- a/drivers/net/netdevsim/dev.c
> > > > +++ b/drivers/net/netdevsim/dev.c
> > > > @@ -1566,12 +1566,15 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
> > > >    	err = devlink_params_register(devlink, nsim_devlink_params,
> > > >    				      ARRAY_SIZE(nsim_devlink_params));
> > > >    	if (err)
> > > > -		goto err_dl_unregister;
> > > > +		goto err_resource_unregister;
> > > >    	nsim_devlink_set_params_init_values(nsim_dev, devlink);
> > > > +	/* here, because params API still expect devlink to be unregistered */
> > > > +	devl_register(devlink);
> > > > +
> > > devlink_set_features() called at last in probe() also needs devlink is not
> > > registered.
> > > >    	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
> > > >    	if (err)
> > > > -		goto err_params_unregister;
> > > > +		goto err_dl_unregister;
> > > >    	err = nsim_dev_traps_init(devlink);
> > > >    	if (err)
> > > > @@ -1610,7 +1613,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
> > > >    	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
> > > >    	devlink_set_features(devlink, DEVLINK_F_RELOAD);
> > > >    	devl_unlock(devlink);
> > > > -	devlink_register(devlink);
> > > >    	return 0;
> > > >    err_hwstats_exit:
> > > > @@ -1629,10 +1631,11 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
> > > >    	nsim_dev_traps_exit(devlink);
> > > >    err_dummy_region_exit:
> > > >    	nsim_dev_dummy_region_exit(nsim_dev);
> > > > -err_params_unregister:
> > > > +err_dl_unregister:
> > > > +	devl_unregister(devlink);
> > > It races with dev_ethtool():
> > > dev_ethtool
> > >    devlink_try_get()
> > >                                  nsim_drv_probe
> > >                                  devl_lock()
> > >      devl_lock()
> > >                                  devlink_unregister()
> > >                                    devlink_put()
> > >                                    wait_for_completion() <- the refcount is
> > > got in dev_ethtool, it causes ABBA deadlock
> > But all these races are nsim specific ones.
> > Can you please explain why devlink.[c|h] MUST be changed and nsim can't
> > be fixed?
> I used the fix code proposed by Jakub, but it didn't work correctly, so
> I tried to correct and improve it, and need some devlink helper.
> 
> Anyway, it is a nsim problem, if we want fix this without touch devlink,
> I think we can add a 'registered' field in struct nsim_dev, and it can be
> checked in nsim_get_devlink_port() like this:
> --- a/drivers/net/netdevsim/netdev.c
> +++ b/drivers/net/netdevsim/netdev.c
> @@ -242,6 +242,9 @@ static struct devlink_port *nsim_get_devlink_port(struct
> net_device *dev)
>  {
>         struct netdevsim *ns = netdev_priv(dev);
> 
> +       if (!ns->nsim_dev->devlink_registered)
> +               return NULL;

Something like that, but you need to make sure that this check is
protected by some sort of the locking.

> +
>         return &ns->nsim_dev_port->devlink_port;
>  }
> 
> Thanks,
> Yang
> > 
> > Thanks
> > .
