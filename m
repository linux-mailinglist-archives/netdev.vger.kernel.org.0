Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB0463BF65
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 12:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiK2Lv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 06:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiK2Lv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 06:51:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D513358BDC
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 03:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669722654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9CBLyH0RXTvLwjlM6E/Boj09BZZIY990XDzCnn9wbPw=;
        b=VOyz2BwD3d5dqYvlay7o32zWLx6tnEYx5g/EZntyXydqk0qLUQyqGcJ+MtdFEqFRQYSMrt
        /Lv7DPIhhlvUv/5XrklfTT5Ck8rnNyuiEp+Cw2/EIsqXRoJK13m5WWUOpenBgSpdaB8WAM
        aKu+XcI0rvSsi89YKaUEe02WcUMbBBI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-372-C7EtaqCJPtOD9eXo94q78A-1; Tue, 29 Nov 2022 06:50:51 -0500
X-MC-Unique: C7EtaqCJPtOD9eXo94q78A-1
Received: by mail-qk1-f197.google.com with SMTP id v7-20020a05620a0f0700b006faffce43b2so27474145qkl.9
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 03:50:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9CBLyH0RXTvLwjlM6E/Boj09BZZIY990XDzCnn9wbPw=;
        b=eGNPOVi2jBhXO3LkpTCZLx6Vu333uy1Zpx7/G0O+jvoHr8lxJXgbiZEyRXi+6Fg0nF
         hQ9J/Pw8L1RSgIvnQJVPMuWkbTLHjoMcwNRHsiPTUEfM95reThGqV85Q066V2g3szPH0
         ReDMbEjwywoMH3Sszenu56YhgZDFX+wbqTJ4Zj8p7NS1NA9+VYdLKdM9JoB6asfFbAUa
         m18a2ttTHv4HYdbed+DO6At/kL475I2Kro3P4c4c8I1xPC9CarUy6Be8D8fEsBNEQnCc
         25YFwNDY4447jzJ5MV6qBnozbWJSmFR8fOkYxDKBtU22hblqZ4fN1u0ValsItiWMsLg9
         0leQ==
X-Gm-Message-State: ANoB5pnoXCJ+q+7tX2sQLO5L+sCIaVxuTTDEoM6rDmJ7rO8TOGg4RQSj
        wT6BsXS5NBlLfnLOyQL2suHcmSWJQDtDPWziRej/0e1oAADDl77ytZIn2W2S3xEF7wqu8IvY9dq
        LTwHxf/29kbtIkX81
X-Received: by 2002:ac8:4788:0:b0:3a5:9191:da4c with SMTP id k8-20020ac84788000000b003a59191da4cmr33745039qtq.540.1669722650525;
        Tue, 29 Nov 2022 03:50:50 -0800 (PST)
X-Google-Smtp-Source: AA0mqf57udU0/n3t8gQZNxAPApMFwNQckm0QqmopAwqKUSexI8spuHalULyPo60nA5QAlJ3wWtYjrQ==
X-Received: by 2002:ac8:4788:0:b0:3a5:9191:da4c with SMTP id k8-20020ac84788000000b003a59191da4cmr33745022qtq.540.1669722650264;
        Tue, 29 Nov 2022 03:50:50 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id v68-20020a372f47000000b006fa84082b6dsm10183195qkh.128.2022.11.29.03.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 03:50:49 -0800 (PST)
Message-ID: <c2004cd0d54c1510dbb8a049527110822dca2d8b.camel@redhat.com>
Subject: Re: [v2][PATCH 1/1] net: phy: Add link between phy dev and mac dev
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xiaolei Wang <xiaolei.wang@windriver.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 29 Nov 2022 12:50:46 +0100
In-Reply-To: <20221125041206.1883833-2-xiaolei.wang@windriver.com>
References: <20221125041206.1883833-1-xiaolei.wang@windriver.com>
         <20221125041206.1883833-2-xiaolei.wang@windriver.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-11-25 at 12:12 +0800, Xiaolei Wang wrote:
> If the external phy used by current mac interface is
> managed by another mac interface, it means that this
> network port cannot work independently, especially
> when the system suspend and resume, the following
> trace may appear, so we should create a device link
> between phy dev and mac dev.
> 
>   WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 phy_error+0x20/0x68
>   Modules linked in:
>   CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
>   Hardware name: Freescale i.MX6 SoloX (Device Tree)
>   Workqueue: events_power_efficient phy_state_machine
>   unwind_backtrace from show_stack+0x10/0x14
>   show_stack from dump_stack_lvl+0x68/0x90
>   dump_stack_lvl from __warn+0xb4/0x24c
>   __warn from warn_slowpath_fmt+0x5c/0xd8
>   warn_slowpath_fmt from phy_error+0x20/0x68
>   phy_error from phy_state_machine+0x22c/0x23c
>   phy_state_machine from process_one_work+0x288/0x744
>   process_one_work from worker_thread+0x3c/0x500
>   worker_thread from kthread+0xf0/0x114
>   kthread from ret_from_fork+0x14/0x28
>   Exception stack(0xf0951fb0 to 0xf0951ff8)
> 
> Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
> ---
>  drivers/net/phy/phy_device.c | 12 ++++++++++++
>  include/linux/phy.h          |  2 ++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 57849ac0384e..ca6d12f37066 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1511,6 +1511,15 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>  	phy_resume(phydev);
>  	phy_led_triggers_register(phydev);
>  
> +	/**
> +	 * If the external phy used by current mac interface is managed by
> +	 * another mac interface, so we should create a device link between
> +	 * phy dev and mac dev.
> +	 */
> +	if (phydev->mdio.bus->parent && dev->dev.parent != phydev->mdio.bus->parent)
> +		phydev->devlink = device_link_add(dev->dev.parent, &phydev->mdio.dev,
> +						  DL_FLAG_PM_RUNTIME | DL_FLAG_STATELESS);
> +
>  	return err;
>  
>  error:
> @@ -1748,6 +1757,9 @@ void phy_detach(struct phy_device *phydev)
>  	struct module *ndev_owner = NULL;
>  	struct mii_bus *bus;
>  
> +	if (phydev->devlink)
> +		device_link_del(phydev->devlink);
> +
>  	if (phydev->sysfs_links) {
>  		if (dev)
>  			sysfs_remove_link(&dev->dev.kobj, "phydev");
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index ddf66198f751..f7f8b909fed0 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -617,6 +617,8 @@ struct phy_device {
>  	/* And management functions */
>  	struct phy_driver *drv;
>  
> +	struct device_link *devlink;

Sorry for the late nit picking, but could you please add the kdoc
documentation for this new field?

Also, please specify explicitly the net-next target tree on repost, as
per Florian's request.

Thanks,

Paolo

