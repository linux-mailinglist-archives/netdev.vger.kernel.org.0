Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B31644239
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbiLFLfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLFLfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:35:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D896BE0A
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 03:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670326501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XxhJC/aJm240LUSto2U3qwVrOXldkyr0mmhlgjdt/Wk=;
        b=D4VKuBjYM4ePZIBw5N1IIww1+QY7uEN7FNrdbws+qxqIkRHl1RBCv2oSYOclpNFFrJDDxL
        mf4TQn5qJbGIhVbfRDvSFy0acuoDAogbkTMRef2GVDkPbd80ofpm5cG9UGt6gi+bwpW0Ts
        2tQhfHtAWFgaEqHSF/LC/Gb9t+BMzQ8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-213-GFHNKtXZOQu_XdbP6_bA_Q-1; Tue, 06 Dec 2022 06:35:00 -0500
X-MC-Unique: GFHNKtXZOQu_XdbP6_bA_Q-1
Received: by mail-qk1-f198.google.com with SMTP id bi42-20020a05620a31aa00b006faaa1664b9so20092306qkb.8
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 03:35:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XxhJC/aJm240LUSto2U3qwVrOXldkyr0mmhlgjdt/Wk=;
        b=oSskKSIhBaSTAzcFr2df0hX9YHFecpYA7F7flS7QzBFqBEdbK6tyNmMgmS6S3mtsMb
         K217Y+qsWWjfPkjYmFGt1FVyZVgGgl8uAkNNuUtfw8DQ9HMiHQCBh2HZH6NqJJotG5tP
         VUBLrEqgMCBI+10KRubbFSLltjussBj4+5SZKQXh9uCwsd1mLFuoCvESMHgQSQEm47nC
         bQkaCKlHypDlwg0LaOCFSl4hsSwUKvrsOwKaaYwQHTH6Bx4m8kO0PqxgmMUPN0pvdmkk
         7K+T/LQ90kozhDPmmqJAqO5ThA7PuE03MPm9GazX+6zBI/1EZwYNMP+9wstxBAxNLq/a
         RogQ==
X-Gm-Message-State: ANoB5pnZVfKRsERrYZuCDGegyz0U35VHcAirlWXwPvb2c1qM/m2YfklP
        /pVvJX64H1uE1sGejzduuk5/lqi4NrSGyz3IbvWPEXki6FuXbxHqNGBjO//pyIGBWPOsh7Cndn6
        BEtlzsgTcoFHEGPpa
X-Received: by 2002:a05:622a:2c3:b0:3a7:e5b3:7f6b with SMTP id a3-20020a05622a02c300b003a7e5b37f6bmr5994189qtx.373.1670326499727;
        Tue, 06 Dec 2022 03:34:59 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7hTcjS1nL3ZGwks5LW0Yfae91uDnGxhFkCJml1B7L4jR1fy3bdimiGwkaFyqOPlKJxZbGmZQ==
X-Received: by 2002:a05:622a:2c3:b0:3a7:e5b3:7f6b with SMTP id a3-20020a05622a02c300b003a7e5b37f6bmr5994175qtx.373.1670326499473;
        Tue, 06 Dec 2022 03:34:59 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-106-100.dyn.eolo.it. [146.241.106.100])
        by smtp.gmail.com with ESMTPSA id w25-20020a05620a129900b006fcaa1eab0esm11113839qki.123.2022.12.06.03.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 03:34:59 -0800 (PST)
Message-ID: <a1df3cb4676ce4f51680b9ead3dcf01d561eed99.camel@redhat.com>
Subject: Re: [PATCH v2] net: mdio: fix unbalanced fwnode reference count in
 mdio_device_release()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Zeng Heng <zengheng4@huawei.com>, hkallweit1@gmail.com,
        edumazet@google.com, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, linux@armlinux.org.uk
Cc:     liwei391@huawei.com, netdev@vger.kernel.org
Date:   Tue, 06 Dec 2022 12:34:55 +0100
In-Reply-To: <20221203073441.3885317-1-zengheng4@huawei.com>
References: <20221203073441.3885317-1-zengheng4@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
On Sat, 2022-12-03 at 15:34 +0800, Zeng Heng wrote:
> There is warning report about of_node refcount leak
> while probing mdio device:
> 
> OF: ERROR: memory leak, expected refcount 1 instead of 2,
> of_node_get()/of_node_put() unbalanced - destroy cset entry:
> attach overlay node /spi/soc@0/mdio@710700c0/ethernet@4
> 
> In of_mdiobus_register_device(), we increase fwnode refcount
> by fwnode_handle_get() before associating the of_node with
> mdio device, but it has never been decreased in normal path.
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
> Reviewed-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  changes in v2:
>   - Add operation about setting device node as NULL-pointer.
>     There is no practical changes.
>   - Add reviewed-by tag.
> ---
>  drivers/net/mdio/of_mdio.c    | 3 ++-
>  drivers/net/phy/mdio_device.c | 2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
> index 796e9c7857d0..510822d6d0d9 100644
> --- a/drivers/net/mdio/of_mdio.c
> +++ b/drivers/net/mdio/of_mdio.c
> @@ -68,8 +68,9 @@ static int of_mdiobus_register_device(struct mii_bus *mdio,
>  	/* All data is now stored in the mdiodev struct; register it. */
>  	rc = mdio_device_register(mdiodev);
>  	if (rc) {
> +		device_set_node(&mdiodev->dev, NULL);
> +		fwnode_handle_put(fwnode);
>  		mdio_device_free(mdiodev);
> -		of_node_put(child);
>  		return rc;
>  	}
>  
> diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
> index 250742ffdfd9..044828d081d2 100644
> --- a/drivers/net/phy/mdio_device.c
> +++ b/drivers/net/phy/mdio_device.c
> @@ -21,6 +21,7 @@
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/unistd.h>
> +#include <linux/property.h>
>  
>  void mdio_device_free(struct mdio_device *mdiodev)
>  {
> @@ -30,6 +31,7 @@ EXPORT_SYMBOL(mdio_device_free);
>  
>  static void mdio_device_release(struct device *dev)
>  {
> +	fwnode_handle_put(dev->fwnode);
>  	kfree(to_mdio_device(dev));
>  }
> 
The patch LGTM, but I'll wait a bit more just in case Andrew want to
comment on it.

Cheers,

Paolo

