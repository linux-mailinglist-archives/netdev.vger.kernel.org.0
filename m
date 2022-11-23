Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF0C635130
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 08:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbiKWHlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 02:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbiKWHli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 02:41:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22CBF6082
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 23:41:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 410CBB81ECD
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E48C433D6;
        Wed, 23 Nov 2022 07:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669189292;
        bh=Qva04oLyBFng31pmDphEPFtjB3P1zGwSDSsZvlND0x0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a+XR8/34wc2lNYYkx6Ts9f9yfEpGcZXewHpAxkFhuQteBFc7v+x++K8Yz6jk5mnaH
         YQ59mM211p+Hnitpvg7XqtZ77hmEuMMligL6hCxgQ9aOrGGumofrTJdiCTij5qs5q8
         a7uBL4XUzdtOgFh2sD0uKiIL6kQ23vaJb6Oi51SOLs509VeimUZrefTGbUJFW2H9Fq
         k/Mny/VHV4zXzYFwWAkitLC30di/dThu7Ew+3woaNU3mMU2O7TUkGfEYyLD8ib4393
         8Jt2L9Ac0QhSD964O74AJdgihD4GNverYeZ8k20Q8bERNLKwF2H2VjMVw1x/v4Spbn
         EYcol5Ck0poog==
Date:   Wed, 23 Nov 2022 09:41:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y33OpMvLcAcnJ1oj@unreal>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
 <Y3zdaX1I0Y8rdSLn@unreal>
 <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
 <Y30dPRzO045Od2FA@unreal>
 <20221122122740.4b10d67d@kernel.org>
 <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 02:40:24PM +0800, Yang Yingliang wrote:
> 
> On 2022/11/23 4:27, Jakub Kicinski wrote:
> > On Tue, 22 Nov 2022 21:04:29 +0200 Leon Romanovsky wrote:
> > > > > Please fix nsim instead of devlink.
> > > > I think if devlink is not registered, it can not be get and used, but there
> > > > is no API for driver to check this, can I introduce a new helper name
> > > > devlink_is_registered() for driver using.
> > > There is no need in such API as driver calls to devlink_register() and
> > > as such it knows when devlink is registered.
> > > 
> > > This UAF is nsim specific issue. Real devices have single .probe()
> > > routine with serialized registration flow. None of them will use
> > > devlink_is_registered() call.
> > Agreed, the fix is to move the register call back.
> > Something along the lines of the untested patch below?
> > Yang Yingliang would you be able to turn that into a real patch?
> > 
> > diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> > index e14686594a71..26602d5fe0a2 100644
> > --- a/drivers/net/netdevsim/dev.c
> > +++ b/drivers/net/netdevsim/dev.c
> > @@ -1566,12 +1566,15 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
> >   	err = devlink_params_register(devlink, nsim_devlink_params,
> >   				      ARRAY_SIZE(nsim_devlink_params));
> >   	if (err)
> > -		goto err_dl_unregister;
> > +		goto err_resource_unregister;
> >   	nsim_devlink_set_params_init_values(nsim_dev, devlink);
> > +	/* here, because params API still expect devlink to be unregistered */
> > +	devl_register(devlink);
> > +
> devlink_set_features() called at last in probe() also needs devlink is not
> registered.
> >   	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
> >   	if (err)
> > -		goto err_params_unregister;
> > +		goto err_dl_unregister;
> >   	err = nsim_dev_traps_init(devlink);
> >   	if (err)
> > @@ -1610,7 +1613,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
> >   	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
> >   	devlink_set_features(devlink, DEVLINK_F_RELOAD);
> >   	devl_unlock(devlink);
> > -	devlink_register(devlink);
> >   	return 0;
> >   err_hwstats_exit:
> > @@ -1629,10 +1631,11 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
> >   	nsim_dev_traps_exit(devlink);
> >   err_dummy_region_exit:
> >   	nsim_dev_dummy_region_exit(nsim_dev);
> > -err_params_unregister:
> > +err_dl_unregister:
> > +	devl_unregister(devlink);
> It races with dev_ethtool():
> dev_ethtool
>   devlink_try_get()
>                                 nsim_drv_probe
>                                 devl_lock()
>     devl_lock()
>                                 devlink_unregister()
>                                   devlink_put()
>                                   wait_for_completion() <- the refcount is
> got in dev_ethtool, it causes ABBA deadlock

But all these races are nsim specific ones.
Can you please explain why devlink.[c|h] MUST be changed and nsim can't
be fixed?

Thanks
