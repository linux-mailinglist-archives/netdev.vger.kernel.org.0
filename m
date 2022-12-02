Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFE06407C4
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 14:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiLBNgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 08:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbiLBNgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 08:36:15 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE61C2D3D
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 05:36:13 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NNv8J2wq3zRpbk;
        Fri,  2 Dec 2022 21:35:28 +0800 (CST)
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 21:36:11 +0800
Subject: Re: [PATCH] net: mdio: fix unbalanced fwnode reference count in
 mdio_device_release()
To:     Zeng Heng <zengheng4@huawei.com>, <f.fainelli@gmail.com>,
        <pabeni@redhat.com>, <andrew@lunn.ch>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <liwei391@huawei.com>
References: <20221201092202.3394119-1-zengheng4@huawei.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <cb1ebff8-af67-e760-8af0-d177eb5bfb66@huawei.com>
Date:   Fri, 2 Dec 2022 21:36:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20221201092202.3394119-1-zengheng4@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/12/1 17:22, Zeng Heng wrote:
> There is warning report about of_node refcount leak
> while probing mdio device:
>
> OF: ERROR: memory leak, expected refcount 1 instead of 2,
> of_node_get()/of_node_put() unbalanced - destroy cset entry:
> attach overlay node /spi/soc@0/mdio@710700c0/ethernet@4
>
> In of_mdiobus_register_device(), we increase fwnode refcount
> by fwnode_handle_get() before associating the of_node with
> mdio device, but it has never been decreased after that.
> Since that, in mdio_device_release(), it needs to call
> fwnode_handle_put() in addition instead of calling kfree()
> directly.
>
> After above, just calling mdio_device_free() in the error handle
> path of of_mdiobus_register_device() is enough to keep the
> refcount balanced.
>
> Fixes: a9049e0c513c ("mdio: Add support for mdio drivers.")
> Signed-off-by: Zeng Heng <zengheng4@huawei.com>
> ---
>   drivers/net/mdio/of_mdio.c    | 1 -
>   drivers/net/phy/mdio_device.c | 2 ++
>   2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
> index 796e9c7857d0..296317a6b333 100644
> --- a/drivers/net/mdio/of_mdio.c
> +++ b/drivers/net/mdio/of_mdio.c
> @@ -69,7 +69,6 @@ static int of_mdiobus_register_device(struct mii_bus *mdio,
>   	rc = mdio_device_register(mdiodev);
>   	if (rc) {
>   		mdio_device_free(mdiodev);
> -		of_node_put(child);
device_set_node() is called to set fwnode and of_node, for undoing this,
calling device_set_node(NULL) is better, and then call the put function.

Thanks,
Yang
>   		return rc;
>   	}
>   
> diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
> index 250742ffdfd9..044828d081d2 100644
> --- a/drivers/net/phy/mdio_device.c
> +++ b/drivers/net/phy/mdio_device.c
> @@ -21,6 +21,7 @@
>   #include <linux/slab.h>
>   #include <linux/string.h>
>   #include <linux/unistd.h>
> +#include <linux/property.h>
>   
>   void mdio_device_free(struct mdio_device *mdiodev)
>   {
> @@ -30,6 +31,7 @@ EXPORT_SYMBOL(mdio_device_free);
>   
>   static void mdio_device_release(struct device *dev)
>   {
> +	fwnode_handle_put(dev->fwnode);
>   	kfree(to_mdio_device(dev));
>   }
>   
