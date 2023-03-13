Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978066B7EA9
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjCMREg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 13:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCMREf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:04:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66B4CA13;
        Mon, 13 Mar 2023 10:03:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC789B81196;
        Mon, 13 Mar 2023 17:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE23BC433D2;
        Mon, 13 Mar 2023 17:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678726960;
        bh=m+gRAhlextJ5L3RQ/bBFFeXPwv/jmWB+9pPPrZ6G7oc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wRrvxR41W/OTafoGGoOFgb+vILnavvFRIgPbOL1KzCCyk8FkjKehv0p6Za0KfThf2
         mYplghwkEV0VhE7mLzBGndZIaSsI+1BEgHN1aB3kRT0fPSLyiWhsEwVl9iAoSM8T5q
         a38u3kBmOPKon1E7641F8I/fiSEaLO3D45ZF4UXI=
Date:   Mon, 13 Mar 2023 18:02:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jorge Merlino <jorge.merlino@canonical.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Add symlink in /sys/class/net for interface altnames
Message-ID: <ZA9XLfunTLtQJNCf@kroah.com>
References: <20230313164903.839-1-jorge.merlino@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313164903.839-1-jorge.merlino@canonical.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 01:49:03PM -0300, Jorge Merlino wrote:
> Currently interface altnames behave almost the same as the interface
> principal name. One difference is that the not have a symlink in
> /sys/class/net as the principal has.
> This was mentioned as a TODO item in the original commit:
> https://lore.kernel.org/netdev/20190719110029.29466-1-jiri@resnulli.us
> This patch adds that symlink when an altname is created and removes it
> when the altname is deleted.
> 
> Signed-off-by: Jorge Merlino <jorge.merlino@canonical.com>
> ---
>  drivers/base/core.c    | 22 ++++++++++++++++++++++
>  include/linux/device.h |  3 +++
>  net/core/dev.c         | 11 +++++++++++
>  3 files changed, 36 insertions(+)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index e54a10b5d..165f51438 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -4223,6 +4223,28 @@ void root_device_unregister(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(root_device_unregister);
>  
> +/**
> + * device_add_altname_symlink - add a symlink in /sys/class/net for a device

If this is only for networking devices, why are you accepting any device
pointer?

> + * altname
> + * @dev: device getting a new altname
> + * @altname: new altname
> + */
> +int device_add_altname_symlink(struct device *dev, const char *altname)
> +{
> +	return sysfs_create_link(&dev->class->p->subsys.kobj, &dev->kobj,

That's a deep -> chain, are you _SURE_ that is going to work properly?
You just want a link in the subsystem directory, so why not pass in the
class/subsystem instead?


> +			altname);
> +}
> +
> +/**
> + * device_remove_altname_symlink - remove device altname symlink from
> + * /sys/class/net
> + * @dev: device losing an altname
> + * @altname: removed altname
> + */
> +void device_remove_altname_symlink(struct device *dev, const char *altname)
> +{
> +	sysfs_delete_link(&dev->class->p->subsys.kobj, &dev->kobj, altname);

Same here, why not pass in the class?

> +}
>  
>  static void device_create_release(struct device *dev)
>  {
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 1508e637b..658d4d743 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -986,6 +986,9 @@ struct device *__root_device_register(const char *name, struct module *owner);
>  
>  void root_device_unregister(struct device *root);
>  
> +int device_add_altname_symlink(struct device *dev, const char *altname);
> +void device_remove_altname_symlink(struct device *dev, const char *altname);
> +
>  static inline void *dev_get_platdata(const struct device *dev)
>  {
>  	return dev->platform_data;
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 253584777..b40ed0b21 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -150,6 +150,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/prandom.h>
>  #include <linux/once_lite.h>
> +#include <linux/device.h>
>  
>  #include "dev.h"
>  #include "net-sysfs.h"
> @@ -328,6 +329,7 @@ int netdev_name_node_alt_create(struct net_device *dev, const char *name)
>  {
>  	struct netdev_name_node *name_node;
>  	struct net *net = dev_net(dev);
> +	int ret;
>  
>  	name_node = netdev_name_node_lookup(net, name);
>  	if (name_node)
> @@ -339,6 +341,11 @@ int netdev_name_node_alt_create(struct net_device *dev, const char *name)
>  	/* The node that holds dev->name acts as a head of per-device list. */
>  	list_add_tail(&name_node->list, &dev->name_node->list);
>  
> +#ifdef CONFIG_SYSFS
> +	ret = device_add_altname_symlink(&dev->dev, name);

Why do you need a #ifdef?  Put the proper #ifdef in the .h file please.

> +	if (ret)
> +		netdev_info(dev, "Unable to create symlink for altname: %d\n", ret);

info level for an error?

> +#endif
>  	return 0;
>  }
>  
> @@ -366,6 +373,10 @@ int netdev_name_node_alt_destroy(struct net_device *dev, const char *name)
>  
>  	__netdev_name_node_alt_destroy(name_node);
>  
> +#ifdef CONFIG_SYSFS
> +	device_remove_altname_symlink(&dev->dev, name);
> +#endif

Again, no #ifdef should be needed.

thanks,

greg k-h
