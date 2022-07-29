Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B210584DB8
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 10:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbiG2Ixi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 04:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbiG2Ixh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 04:53:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7020F83206
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 01:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659084815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UKNzy1wNl3/wszEHWiuWje3QkhM8MgHzTske10APxFw=;
        b=dQDIp1nn8vdY17mCtyS5vGbng53PrUINbh6nbNXnPFI+zv1bGsM2IwPy8LU7o0KQybFti+
        X7gInZnXl++Inc1pHmuy9pTexQhCCUfj59PM4EG5XqtsOVnE0XFZ3Z5dqBNleHw8mED+0F
        +/l3VmnyLpykbzmqwuU9sWF5zOnuP2s=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-w3liKLEjOUyy1CQJ-lJ30A-1; Fri, 29 Jul 2022 04:53:32 -0400
X-MC-Unique: w3liKLEjOUyy1CQJ-lJ30A-1
Received: by mail-ed1-f71.google.com with SMTP id w15-20020a056402268f00b0043be4012ea9so2528958edd.4
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 01:53:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=UKNzy1wNl3/wszEHWiuWje3QkhM8MgHzTske10APxFw=;
        b=uE+ALUeqV2aglPT9r7zdL4m1Pnvbl6eKIz2IPCZ0keCobf54//4Vj1cRUoZ+55y3jz
         yUUSshKXZE8VN6nPwHT93SXkZWa8+7Eb6HXK7obZbP7FcXy0A4+vUXKt3KdRFuaVX0ya
         JQY6rpu3WL63rK/vGXJujczGQpTmD8APJz40Hg7qtirm+NoohIoOF6XYSVRlVI4GiShy
         Cn3Uy9VIrGjbHfBaRDXtpN/cpWCgiuqab1xVchoOY2lGXCEFf/r4nrbGCX6qe4/hdvrl
         uCQoyaVnG3KlO8P5HxeqkCB7pcqYsRKFUqAJ5x/BDq4Mv0s4sT1CZymPMGxf0g55VWoe
         2SdA==
X-Gm-Message-State: AJIora/++gRoWrZrc9syhN6t59yLBK3BtCtOXc6hupJPPCJ6aKk8POG/
        imSvn+mtiN7r9jZEm7YUgn6zZqnuUt5wGdjXY7e04VWeUrm2rWL+nSoF0Q4lb2h895ifMhRren1
        3yUQVspTdd/FynPoi
X-Received: by 2002:a17:906:9c84:b0:6e0:7c75:6f01 with SMTP id fj4-20020a1709069c8400b006e07c756f01mr2189883ejc.103.1659084811160;
        Fri, 29 Jul 2022 01:53:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tFzt9/6A2RKYxMe6RJ6gz+kx2jnpmTWONPTb+1sLKKtOLsSJuA19N97kaMBeYyhN7fjcnflw==
X-Received: by 2002:a17:906:9c84:b0:6e0:7c75:6f01 with SMTP id fj4-20020a1709069c8400b006e07c756f01mr2189861ejc.103.1659084810678;
        Fri, 29 Jul 2022 01:53:30 -0700 (PDT)
Received: from redhat.com ([2.54.183.236])
        by smtp.gmail.com with ESMTPSA id q15-20020a17090676cf00b006fed93bf71fsm1446122ejn.18.2022.07.29.01.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 01:53:30 -0700 (PDT)
Date:   Fri, 29 Jul 2022 04:53:27 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
Subject: Re: [PATCH V3 6/6] vDPA: fix 'cast to restricted le16' warnings in
 vdpa.c
Message-ID: <20220729045039-mutt-send-email-mst@kernel.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-7-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701132826.8132-7-lingshan.zhu@intel.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 09:28:26PM +0800, Zhu Lingshan wrote:
> This commit fixes spars warnings: cast to restricted __le16
> in function vdpa_dev_net_config_fill() and
> vdpa_fill_stats_rec()
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/vdpa.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 846dd37f3549..ed49fe46a79e 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -825,11 +825,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>  		    config.mac))
>  		return -EMSGSIZE;
>  
> -	val_u16 = le16_to_cpu(config.status);
> +	val_u16 = __virtio16_to_cpu(true, config.status);
>  	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>  		return -EMSGSIZE;
>  
> -	val_u16 = le16_to_cpu(config.mtu);
> +	val_u16 = __virtio16_to_cpu(true, config.mtu);
>  	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>  		return -EMSGSIZE;
>  

Wrong on BE platforms with legacy interface, isn't it?
We generally don't handle legacy properly in VDPA so it's
not a huge deal, but maybe add a comment at least?


> @@ -911,7 +911,7 @@ static int vdpa_fill_stats_rec(struct vdpa_device *vdev, struct sk_buff *msg,
>  	}
>  	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>  
> -	max_vqp = le16_to_cpu(config.max_virtqueue_pairs);
> +	max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
>  	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
>  		return -EMSGSIZE;
>  
> -- 
> 2.31.1

