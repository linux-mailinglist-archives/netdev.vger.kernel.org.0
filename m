Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9B24CCCBC
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiCDFB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiCDFBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:01:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC63A141FFD
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 21:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646370036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C9LljTggMYdd47/c+/HB8RDqC/7m392I60YkhURxrMM=;
        b=GGiBsCbYnM2a0YVT/dbDASj8s0hfZRxIJCHB8Fr3odukOxxFVWpG5hQbLKu4c+WKrdqG5Z
        WJL2BffPPW1b81ekT+5IMLoQQstCGHZb+Mw/97z16Pph0ri7VePZiF1Ws1Silzn20DWHmp
        JRswG+v583k1yqqC0UiDNkcuwxvnjiA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-mmcKxlseN464e0FSClkupA-1; Fri, 04 Mar 2022 00:00:32 -0500
X-MC-Unique: mmcKxlseN464e0FSClkupA-1
Received: by mail-wm1-f71.google.com with SMTP id v125-20020a1cac83000000b0037e3d70e7e1so3812778wme.1
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 21:00:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C9LljTggMYdd47/c+/HB8RDqC/7m392I60YkhURxrMM=;
        b=wTHUWEJjp4S+QIKQJxPlghvDIcdo3Cuo2hIRL8HQkF266sizJ1EodaIXkuqSAjZ7ia
         Hwh1UKlMSUWeLqQr4ZCu4R0ZZCTznA5m8nzvuQlqN+6DybxNOE9ccxLuiHyZBLMKAuaR
         YTkCXPqppNYyKUPupWmjnggWe/4kf6zjogiiPn5VNVc1at/yteRWkGGyw4un2RH9RWCX
         yduIaR7Ca2Q72U+O29kkVbRJsCALlQBCjVLi4fZHF0vTqmP5gsTR+EUvYtQFQ3/E8xa7
         +8cgU9sZpBNdAhgR95J/plr6H9gEohkchfxMFqgli0sS7w9jcs2LaqvSiPur1zX1BURJ
         3CGw==
X-Gm-Message-State: AOAM531q0SO2Fv6nDAvzSw1nCOrA5BqWOUBHoewrta3+vxQ9RfHv7qk+
        qZtnPYbIp693V+XNB/8BmwRAgW5fmnJ/iBerA4vjepX92VotUz9DLXI8vUVN6NI31QGWGeApnbR
        ELirJZck+3yvborK8
X-Received: by 2002:a5d:47c5:0:b0:1ef:f2e8:11fc with SMTP id o5-20020a5d47c5000000b001eff2e811fcmr14057949wrc.109.1646370030409;
        Thu, 03 Mar 2022 21:00:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw/9IpbklvBlJJPYjzIkhqrW9cqHaZPxp5pYripZTV4jzY3k3rJRGhRMUtTqLp99H9+2vfm0A==
X-Received: by 2002:a5d:47c5:0:b0:1ef:f2e8:11fc with SMTP id o5-20020a5d47c5000000b001eff2e811fcmr14057937wrc.109.1646370030110;
        Thu, 03 Mar 2022 21:00:30 -0800 (PST)
Received: from redhat.com ([2.53.6.39])
        by smtp.gmail.com with ESMTPSA id n4-20020a05600c4f8400b00380e45cd564sm4015646wmq.8.2022.03.03.21.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 21:00:29 -0800 (PST)
Date:   Fri, 4 Mar 2022 00:00:25 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220303235937-mutt-send-email-mst@kernel.org>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302075421.2131221-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> vhost_vsock_handle_tx_kick() already holds the mutex during its call
> to vhost_get_vq_desc().  All we have to do is take the same lock
> during virtqueue clean-up and we mitigate the reported issues.
> 
> Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

So combine with the warning patch and update description with
the comment I posted, explaining it's more a just in case thing.

> ---
>  drivers/vhost/vhost.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe28..bbaff6a5e21b8 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  	int i;
>  
>  	for (i = 0; i < dev->nvqs; ++i) {
> +		mutex_lock(&dev->vqs[i]->mutex);
>  		if (dev->vqs[i]->error_ctx)
>  			eventfd_ctx_put(dev->vqs[i]->error_ctx);
>  		if (dev->vqs[i]->kick)
> @@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>  		if (dev->vqs[i]->call_ctx.ctx)
>  			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
>  		vhost_vq_reset(dev, dev->vqs[i]);
> +		mutex_unlock(&dev->vqs[i]->mutex);
>  	}
>  	vhost_dev_free_iovecs(dev);
>  	if (dev->log_ctx)
> -- 
> 2.35.1.574.g5d30c73bfb-goog

