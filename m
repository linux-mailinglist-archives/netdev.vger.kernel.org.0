Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B596460CADF
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiJYLZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiJYLYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:24:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BB216D561
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666697085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1ETYihh/7NrZ4zfN9zxgiV3XM9iKgQJSxjADQD9DQAo=;
        b=J5OWYXOqGCN/NYtfnDyQZPgARAzZWE3cpghyop1jYELrnIKfFYAoADo0afOKsXNGNDOOtJ
        FVK1b3MKS1DQc36RuRgcTtdxOaeqLPiihQ1K+tpMILAFN1UXaNUbFInnK2ldVRc35uxR+K
        4tZWBItsvGfAf5OUHFUOBRXJNoPBa6I=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-597-g7txyEswPQ285MFE_IpLDA-1; Tue, 25 Oct 2022 07:24:41 -0400
X-MC-Unique: g7txyEswPQ285MFE_IpLDA-1
Received: by mail-qk1-f198.google.com with SMTP id o13-20020a05620a2a0d00b006cf9085682dso11105966qkp.7
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1ETYihh/7NrZ4zfN9zxgiV3XM9iKgQJSxjADQD9DQAo=;
        b=I0jOoCkf7PMf4w9/qoA3xVFpipP0J0g8AQ1DnYu7k+rdh8ovZnlj9+KK4hpqHBH7iV
         DCT5Xozx10G3LpQF68SR9I4UtKdoB1afHob2WHou7LmlvvZW/mCQpudmSb05J9U/NKqg
         st8jHyKzQNvpsGHkcKn2rgxgbVlXNbghPRTMh3sejEW+dQTREHsQ0otGwb+ISnffUpLB
         YWv+5Z6Um0pva4ojU90PbdhvS5Sux1lvX8NWy5oMX2loNOheauNZNv2nCW3m7OYdx1gF
         M3XlzTPUPK27bEFo/nSJfcaTUhG/xUO+aBOFvA9a5CRCcqL2SUAtuO/R12Z/bKMYkncl
         PJpQ==
X-Gm-Message-State: ACrzQf2rspI1PeHHGlUO4LCTAeyQBZuZUybrhT6T3vJtJDl6AdO12VUp
        LepYAUCd9rD4jFp3Wlyr5CYyCm2lgNyxzEa9Nx0tRNYx0Zi5OL40aCqpiWZZEhtXxJYC6waxWTa
        Yel27lfMoS+qbFl8D
X-Received: by 2002:a05:622a:2d2:b0:39c:f1cf:e82e with SMTP id a18-20020a05622a02d200b0039cf1cfe82emr31508165qtx.484.1666697081228;
        Tue, 25 Oct 2022 04:24:41 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5z0kZXgrTyCqncDZczPbFnWuNat5f8Sx4a75i8sYJidH5GdDDlNYXy0gvkpfNtt9hoAt5t9g==
X-Received: by 2002:a05:622a:2d2:b0:39c:f1cf:e82e with SMTP id a18-20020a05622a02d200b0039cf1cfe82emr31508147qtx.484.1666697080938;
        Tue, 25 Oct 2022 04:24:40 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id g3-20020ac87d03000000b00342f8984348sm1483977qtb.87.2022.10.25.04.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 04:24:40 -0700 (PDT)
Message-ID: <c66f5b5d68fe15a60cecc2ad213e78f8b1d442ec.camel@redhat.com>
Subject: Re: [PATCH net,v2 1/2] netdevsim: fix memory leak in
 nsim_drv_probe() when nsim_dev_resources_register() failed
From:   Paolo Abeni <pabeni@redhat.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com
Cc:     dsa@cumulusnetworks.com, jiri@mellanox.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Date:   Tue, 25 Oct 2022 13:24:37 +0200
In-Reply-To: <20221022044847.61995-2-shaozhengchao@huawei.com>
References: <20221022044847.61995-1-shaozhengchao@huawei.com>
         <20221022044847.61995-2-shaozhengchao@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-10-22 at 12:48 +0800, Zhengchao Shao wrote:
> If some items in nsim_dev_resources_register() fail, memory leak will
> occur. The following is the memory leak information.
> 
> unreferenced object 0xffff888074c02600 (size 128):
>   comm "echo", pid 8159, jiffies 4294945184 (age 493.530s)
>   hex dump (first 32 bytes):
>     40 47 ea 89 ff ff ff ff 01 00 00 00 00 00 00 00  @G..............
>     ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
>   backtrace:
>     [<0000000011a31c98>] kmalloc_trace+0x22/0x60
>     [<0000000027384c69>] devl_resource_register+0x144/0x4e0
>     [<00000000a16db248>] nsim_drv_probe+0x37a/0x1260
>     [<000000007d1f448c>] really_probe+0x20b/0xb10
>     [<00000000c416848a>] __driver_probe_device+0x1b3/0x4a0
>     [<00000000077e0351>] driver_probe_device+0x49/0x140
>     [<0000000054f2465a>] __device_attach_driver+0x18c/0x2a0
>     [<000000008538f359>] bus_for_each_drv+0x151/0x1d0
>     [<0000000038e09747>] __device_attach+0x1c9/0x4e0
>     [<00000000dd86e533>] bus_probe_device+0x1d5/0x280
>     [<00000000839bea35>] device_add+0xae0/0x1cb0
>     [<000000009c2abf46>] new_device_store+0x3b6/0x5f0
>     [<00000000fb823d7f>] bus_attr_store+0x72/0xa0
>     [<000000007acc4295>] sysfs_kf_write+0x106/0x160
>     [<000000005f50cb4d>] kernfs_fop_write_iter+0x3a8/0x5a0
>     [<0000000075eb41bf>] vfs_write+0x8f0/0xc80
> 
> Fixes: 37923ed6b8ce ("netdevsim: Add simple FIB resource controller via devlink")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  drivers/net/netdevsim/dev.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index 794fc0cc73b8..07b1a3b3afaf 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -442,7 +442,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
>  				     &params);
>  	if (err) {
>  		pr_err("Failed to register IPv4 top resource\n");
> -		goto out;
> +		goto err_out;
>  	}
>  
>  	err = devl_resource_register(devlink, "fib", (u64)-1,
> @@ -450,7 +450,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
>  				     NSIM_RESOURCE_IPV4, &params);
>  	if (err) {
>  		pr_err("Failed to register IPv4 FIB resource\n");
> -		return err;
> +		goto err_out;
>  	}
>  
>  	err = devl_resource_register(devlink, "fib-rules", (u64)-1,
> @@ -458,7 +458,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
>  				     NSIM_RESOURCE_IPV4, &params);
>  	if (err) {
>  		pr_err("Failed to register IPv4 FIB rules resource\n");
> -		return err;
> +		goto err_out;
>  	}
>  
>  	/* Resources for IPv6 */
> @@ -468,7 +468,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
>  				     &params);
>  	if (err) {
>  		pr_err("Failed to register IPv6 top resource\n");
> -		goto out;
> +		goto err_out;
>  	}
>  
>  	err = devl_resource_register(devlink, "fib", (u64)-1,
> @@ -476,7 +476,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
>  				     NSIM_RESOURCE_IPV6, &params);
>  	if (err) {
>  		pr_err("Failed to register IPv6 FIB resource\n");
> -		return err;
> +		goto err_out;
>  	}
>  
>  	err = devl_resource_register(devlink, "fib-rules", (u64)-1,
> @@ -484,7 +484,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
>  				     NSIM_RESOURCE_IPV6, &params);
>  	if (err) {
>  		pr_err("Failed to register IPv6 FIB rules resource\n");
> -		return err;
> +		goto err_out;
>  	}
>  
>  	/* Resources for nexthops */
> @@ -492,8 +492,14 @@ static int nsim_dev_resources_register(struct devlink *devlink)
>  				     NSIM_RESOURCE_NEXTHOPS,
>  				     DEVLINK_RESOURCE_ID_PARENT_TOP,
>  				     &params);
> +	if (err) {
> +		pr_err("Failed to register NEXTHOPS resource\n");
> +		goto err_out;
> +	}
> +	return err;

Nit pick: I think it would be more clear if here you do:

	return 0;

The above is actually almost an excuse to ask you to repost with a
better/more describing cover letter, as the current one is practically
empty.

Thanks!

Paolo

