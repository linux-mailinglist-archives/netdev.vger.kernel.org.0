Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64B83DF688
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 22:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhHCUlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 16:41:45 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:46994 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhHCUln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 16:41:43 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 173KfRSG072451;
        Tue, 3 Aug 2021 15:41:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628023287;
        bh=6Mev7Km3gabjcz50WEBXisbMvaXrrUq4Smfw6hukFfw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Un5NeG4O+dF5//IYlWIAcJ7AURe4nTYdwqoPdOhsnehNILi3o82wjWIb20kci2of8
         qBEQdK2z4uefXLyxpD8DJBPghlQIzGZw+Bfp+gKV7cQPIQobI5ftcZ5t3VZas0/fOs
         w0476us51cIHf5q4KAMGGi9GLBi4/o6E2VJpm16E=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 173KfRJ6034908
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Aug 2021 15:41:27 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 3 Aug
 2021 15:41:27 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Tue, 3 Aug 2021 15:41:27 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 173KfPBN119960;
        Tue, 3 Aug 2021 15:41:25 -0500
Subject: Re: [PATCH net-next 1/4] ethtool: runtime-resume netdev parent before
 ethtool ioctl ops
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
 <cb44d295-5267-48a7-b7c7-e4bf5b884e7a@gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <b4744988-4463-6463-243a-354cd87c4ced@ti.com>
Date:   Tue, 3 Aug 2021 23:41:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cb44d295-5267-48a7-b7c7-e4bf5b884e7a@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/08/2021 13:36, Heiner Kallweit wrote:
> If a network device is runtime-suspended then:
> - network device may be flagged as detached and all ethtool ops (even if not
>    accessing the device) will fail because netif_device_present() returns
>    false
> - ethtool ops may fail because device is not accessible (e.g. because being
>    in D3 in case of a PCI device)
> 
> It may not be desirable that userspace can't use even simple ethtool ops
> that not access the device if interface or link is down. To be more friendly
> to userspace let's ensure that device is runtime-resumed when executing the
> respective ethtool op in kernel.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>   net/ethtool/ioctl.c | 18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index baa5d1004..b7ff9abe7 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -23,6 +23,7 @@
>   #include <linux/rtnetlink.h>
>   #include <linux/sched/signal.h>
>   #include <linux/net.h>
> +#include <linux/pm_runtime.h>
>   #include <net/devlink.h>
>   #include <net/xdp_sock_drv.h>
>   #include <net/flow_offload.h>
> @@ -2589,7 +2590,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
>   	int rc;
>   	netdev_features_t old_features;
>   
> -	if (!dev || !netif_device_present(dev))
> +	if (!dev)
>   		return -ENODEV;
>   
>   	if (copy_from_user(&ethcmd, useraddr, sizeof(ethcmd)))
> @@ -2645,10 +2646,18 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
>   			return -EPERM;
>   	}
>   
> +	if (dev->dev.parent)
> +		pm_runtime_get_sync(dev->dev.parent);

the PM Runtime should allow to wake up parent when child is resumed if everything is configured properly.

rpm_resume()
...
     if (!parent && dev->parent) {
  --> here

So, hence PM runtime calls are moved to from drivers to net_core wouldn't be more correct approach to
enable PM runtime for netdev->dev and lets PM runtime do the job?

But, to be honest, I'm not sure adding PM runtime manipulation to the net core is a good idea -
at minimum it might be tricky and required very careful approach (especially in err path).
For example, even in this patch you do not check return value of pm_runtime_get_sync() and in
commit bd869245a3dc ("net: core: try to runtime-resume detached device in __dev_open") also actualy.


The TI CPSW driver may also be placed in non reachable state when netdev is closed (and even lose context),
but we do not use netif_device_detach() (so netdev is accessible through netdev_ops/ethtool_ops),
but instead wake up device by runtime PM for allowed operations or just save requested configuration which
is applied at netdev->open() time then.
I feel that using netif_device_detach() in PM runtime sounds like a too heavy approach ;)

huh, see it's merged already, so...

> +
> +	if (!netif_device_present(dev)) {
> +		rc = -ENODEV;
> +		goto out;
> +	}
> +
>   	if (dev->ethtool_ops->begin) {
>   		rc = dev->ethtool_ops->begin(dev);
> -		if (rc  < 0)
> -			return rc;
> +		if (rc < 0)
> +			goto out;
>   	}
>   	old_features = dev->features;
>   
> @@ -2867,6 +2876,9 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
>   
>   	if (old_features != dev->features)
>   		netdev_features_change(dev);
> +out:
> +	if (dev->dev.parent)
> +		pm_runtime_put(dev->dev.parent);
>   
>   	return rc;
>   }
> 

-- 
Best regards,
grygorii
