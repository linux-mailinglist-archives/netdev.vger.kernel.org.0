Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2ED534DE5
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 13:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237860AbiEZLO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 07:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbiEZLO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 07:14:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B2DCCFE13
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 04:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653563664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u7bQhPKpC/2vv3TSdrZRb3hAgeC4UybLeZufoqxQdtY=;
        b=UEXWgvAnOtaA7NzSm+S/LYkgDr3iFOtUi+tI6SUaXSvteRhsGP2tV/yLIJ2mm7Ik/Ky4B6
        BrXojNCeWUPqC6WjNYrha2xp5Z9cvdYnyuLH1zU0AMgf5j+Ps+d+CAgAxkzyrebTvTOLPL
        3bPj2+LcWu8CrsBOherIeor6v4jjbzA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-m2jq_Yq7M4CtRNOJDmXy6A-1; Thu, 26 May 2022 07:14:23 -0400
X-MC-Unique: m2jq_Yq7M4CtRNOJDmXy6A-1
Received: by mail-wm1-f71.google.com with SMTP id n18-20020a05600c3b9200b0039746f3d9faso763260wms.4
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 04:14:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=u7bQhPKpC/2vv3TSdrZRb3hAgeC4UybLeZufoqxQdtY=;
        b=pb07/acPFLZ6rfns6bEQ71XOWMTXcWVxSeVF+ajJZqZ7MA9b/BKLZT4C7HPApX4s9n
         ALF5/HkbbkzB0ZtUA4KzeYg3hRAsKcw/t7iD2FgVZBUd3nH2sASu+d2+ArBSCA/8DH6F
         NQ551THX4XqSXe7/rNCDELwFhpLdzFby50Cve2oDXctdGNghr8sZw2mmeej30rnJ+Ip+
         /IozJ8PPd/5vMPL75UC+B3ErqIAY1Bc1lbp5mPucu0u429aG/bs+k8mpMGpaxdgAWvxh
         JILzUJhctY/mu4jlAarg93m3L04aYPU9nxZIuifk8tfc+kVvw/fjDe3j588dKqluI1L2
         ORiw==
X-Gm-Message-State: AOAM531ACRoLWhbz8s2A1b/ZLfkCzb9cKLSTtoIm9fOnDW6+czarZhkL
        ZAmmBmjTGj4ZG1RKHn0uGjtkJVofaSOVVDDr/wyjCXqt/HpD9HApg/9xvk2fVNQXFsDnCma/R5f
        /H/XmlROqdRUGE3pN
X-Received: by 2002:a5d:64cc:0:b0:20f:e6d6:72e1 with SMTP id f12-20020a5d64cc000000b0020fe6d672e1mr14022745wri.384.1653563661971;
        Thu, 26 May 2022 04:14:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNqTc2OdsUsM2oys5V9RV3sUSHMD/A/689Eu2Wl1fyGZ9NhDcupjVv28qYgzeoEVnZw9wl8g==
X-Received: by 2002:a5d:64cc:0:b0:20f:e6d6:72e1 with SMTP id f12-20020a5d64cc000000b0020fe6d672e1mr14022727wri.384.1653563661736;
        Thu, 26 May 2022 04:14:21 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id h131-20020a1c2189000000b00394708a3d7dsm4730095wmh.15.2022.05.26.04.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 04:14:21 -0700 (PDT)
Message-ID: <5a7cb5c7c0bf2f9f9540616a2a0e70d36a166a9f.camel@redhat.com>
Subject: Re: [PATCH] net/mlx5: Fix memory leak in mlx5_sf_dev_add()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jianglei Nie <niejianglei2021@163.com>, saeedm@nvidia.com,
        leon@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, parav@nvidia.com, vuhuong@nvidia.com,
        shayd@nvidia.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 26 May 2022 13:14:20 +0200
In-Reply-To: <20220526084411.480472-1-niejianglei2021@163.com>
References: <20220526084411.480472-1-niejianglei2021@163.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-05-26 at 16:44 +0800, Jianglei Nie wrote:
> The variable id is allocated by mlx5_adev_idx_alloc(). When some error
> happens, the id should be freed by mlx5_adev_idx_free().But when
> auxiliary_device_add() and xa_insert() fail, the id is not freed,which
> will lead to a potential memory leak.
> 
> We can fix it by calling mlx5_sf_dev_add() when auxiliary_device_add()
> and xa_insert() fail.
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
> index 7da012ff0d41..9f222061a1c0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
> @@ -125,13 +125,16 @@ static void mlx5_sf_dev_add(struct mlx5_core_dev *dev, u16 sf_index, u16 fn_id,
>  
>  	err = auxiliary_device_add(&sf_dev->adev);
>  	if (err) {
> +		mlx5_adev_idx_free(id);
>  		put_device(&sf_dev->adev.dev);

This looks not correct. put_device() -> mlx5_sf_dev_release() -> should
already take care of that.

>  		goto add_err;
>  	}
>  
>  	err = xa_insert(&table->devices, sf_index, sf_dev, GFP_KERNEL);
> -	if (err)
> +	if (err) {
> +		mlx5_adev_idx_free(id);
>  		goto xa_err;
> +	}
>  	return;
>  
>  xa_err:

