Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC675309A3
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 08:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiEWGmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 02:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiEWGmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 02:42:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296652C675;
        Sun, 22 May 2022 23:41:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAF57B80EF5;
        Mon, 23 May 2022 06:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF416C385A9;
        Mon, 23 May 2022 06:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653287509;
        bh=OENwoRgzLHLcoN90lXWyFeYPCL70W7UVzXr++rGaYzU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1QZ7sxf4fQVdnryaaxAxeoKMzG2cFlbm4EUHft6ORNDyzvN8d3Z0sdOdh1picrPSH
         Y1wWzsJZOCGnZTfMiMOyj/WB4go0KIn/4BGSI8WRtf+nRrZnWLu6GntqbdoJHf9nTa
         MqCShC8Lte63pYi8QtgLiWPYEK/dFIPO7WzdUoR0=
Date:   Mon, 23 May 2022 08:31:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael@kernel.org
Subject: Re: [PATCH v3] mwifiex: fix sleep in atomic context bugs caused by
 dev_coredumpv
Message-ID: <YosqUjCYioGh3kBW@kroah.com>
References: <20220523052810.24767-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523052810.24767-1-duoming@zju.edu.cn>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 01:28:10PM +0800, Duoming Zhou wrote:
> There are sleep in atomic context bugs when uploading device dump
> data in mwifiex. The root cause is that dev_coredumpv could not
> be used in atomic contexts, because it calls dev_set_name which
> include operations that may sleep. The call tree shows execution
> paths that could lead to bugs:
> 
>    (Interrupt context)
> fw_dump_timer_fn
>   mwifiex_upload_device_dump
>     dev_coredumpv(..., GFP_KERNEL)
>       dev_coredumpm()
>         kzalloc(sizeof(*devcd), gfp); //may sleep
>         dev_set_name
>           kobject_set_name_vargs
>             kvasprintf_const(GFP_KERNEL, ...); //may sleep
>             kstrdup(s, GFP_KERNEL); //may sleep
> 
> In order to let dev_coredumpv support atomic contexts, this patch
> changes the gfp_t parameter of kvasprintf_const and kstrdup in
> kobject_set_name_vargs from GFP_KERNEL to GFP_ATOMIC. What's more,
> In order to mitigate bug, this patch changes the gfp_t parameter
> of dev_coredumpv from GFP_KERNEL to GFP_ATOMIC.
> 
> Fixes: 57670ee882d4 ("mwifiex: device dump support via devcoredump framework")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
> Changes in v3:
>   - Let dev_coredumpv support atomic contexts.
> 
>  drivers/net/wireless/marvell/mwifiex/main.c | 2 +-
>  lib/kobject.c                               | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> index ace7371c477..258906920a2 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -1116,7 +1116,7 @@ void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter)
>  	mwifiex_dbg(adapter, MSG,
>  		    "== mwifiex dump information to /sys/class/devcoredump start\n");
>  	dev_coredumpv(adapter->dev, adapter->devdump_data, adapter->devdump_len,
> -		      GFP_KERNEL);
> +		      GFP_ATOMIC);
>  	mwifiex_dbg(adapter, MSG,
>  		    "== mwifiex dump information to /sys/class/devcoredump end\n");
>  
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 5f0e71ab292..7672c54944c 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -254,7 +254,7 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>  	if (kobj->name && !fmt)
>  		return 0;
>  
> -	s = kvasprintf_const(GFP_KERNEL, fmt, vargs);
> +	s = kvasprintf_const(GFP_ATOMIC, fmt, vargs);
>  	if (!s)
>  		return -ENOMEM;
>  
> @@ -267,7 +267,7 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>  	if (strchr(s, '/')) {
>  		char *t;
>  
> -		t = kstrdup(s, GFP_KERNEL);
> +		t = kstrdup(s, GFP_ATOMIC);
>  		kfree_const(s);
>  		if (!t)
>  			return -ENOMEM;

Please no, you are hurting the whole kernel because of one odd user.
Please do not make these calls under atomic context.

thanks,

greg k-h
