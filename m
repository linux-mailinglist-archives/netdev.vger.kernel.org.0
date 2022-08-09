Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DCF58E023
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244544AbiHITYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiHITY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:24:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42112186
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 12:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660073067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/3RbxJxGVSsLcMA8L1qFPTYGOuc2TNATaWYB7KmkbBM=;
        b=Gh4Uq2jaDmgcMAdz2tMcvhl4dPusrOaahpPwy1v3eLa4nDi4LcMvfmiKDTgFiW/qePbCqh
        2uCs5JAeySMhNNV0NESXJbpit/LiBz3raBL7bh6d+TIeLtQJpki4KKl/0++HHTYHXpzsce
        AHkLFLq4AIETY+h+FJWDtkdmxMifAAA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-2qXpl936Oky253hceDYZhA-1; Tue, 09 Aug 2022 15:24:26 -0400
X-MC-Unique: 2qXpl936Oky253hceDYZhA-1
Received: by mail-ed1-f70.google.com with SMTP id i5-20020a05640242c500b0043e50334109so7785726edc.1
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 12:24:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/3RbxJxGVSsLcMA8L1qFPTYGOuc2TNATaWYB7KmkbBM=;
        b=aEMoJrByiCKZGKERCV36OjlYjTy8HJJLxMbNN9b9DQ54M7b3/zN9GJSpRPBm2n7HIW
         5n5FCLoIaf1ui7FktUtF12PTMdNRlJ+XLCJfemx8DPsf9ae/iu0LkiwiO1svaIxPWfWJ
         It6NUE334h4Kj6iHbeiKBdgrDwyAGmLYy1/YQOnS1AZP4z4zJHbXmoFds1Kg+c/8cIXs
         p5Emo+auP3Adk1gqWAwIzAMKzFYXW9MOJEhXfm/3FWE5dAH++C1szB5nrLKgMMiXTqs3
         6vYCeR63oY72/uo3nKVk5VgdMALAw+V2TzUef5vE9oEOIYVJWUt4TEVxlUVB3Z/NSE2D
         j9FA==
X-Gm-Message-State: ACgBeo0nibPxmDUoPLoLvtaBrr5ZuGkNiDNntsj8y1QW2kLk1GCs/J/3
        S7lvymnlzCrIh/QnRrKS+tEdcp8rcMtUN3sywzVT7RGtDsZxliGRL59sXCuINBS6D0WQkAcuzcI
        MbiuJTZcxPXISHd5/
X-Received: by 2002:a05:6402:3220:b0:43d:ca4f:d2b9 with SMTP id g32-20020a056402322000b0043dca4fd2b9mr23094735eda.177.1660073065073;
        Tue, 09 Aug 2022 12:24:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5brrr+dQboK5ThN120g3Cj1H0pvT2rB9K/dhmHA5Z9w4zkI9/s3kRN1cm78F0pypjDI4qxFQ==
X-Received: by 2002:a05:6402:3220:b0:43d:ca4f:d2b9 with SMTP id g32-20020a056402322000b0043dca4fd2b9mr23094728eda.177.1660073064880;
        Tue, 09 Aug 2022 12:24:24 -0700 (PDT)
Received: from redhat.com ([2.52.152.113])
        by smtp.gmail.com with ESMTPSA id a3-20020a170906670300b0072ee7b51d9asm1463010ejp.39.2022.08.09.12.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 12:24:24 -0700 (PDT)
Date:   Tue, 9 Aug 2022 15:24:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
Subject: Re: [PATCH V4 3/6] vDPA: allow userspace to query features of a vDPA
 device
Message-ID: <20220809152259-mutt-send-email-mst@kernel.org>
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-4-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722115309.82746-4-lingshan.zhu@intel.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 07:53:06PM +0800, Zhu Lingshan wrote:
> This commit adds a new vDPA netlink attribution
> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
> features of vDPA devices through this new attr.
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


I think at least some discussion and documentation
of this attribute versus VDPA_ATTR_DEV_SUPPORTED_FEATURES
is called for.

Otherwise how do people know which one to use?

We can't send everyone to go read the lkml thread.

> ---
>  drivers/vdpa/vdpa.c       | 13 +++++++++----
>  include/uapi/linux/vdpa.h |  1 +
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index ebf2f363fbe7..9b0e39b2f022 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -815,7 +815,7 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>  static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>  {
>  	struct virtio_net_config config = {};
> -	u64 features;
> +	u64 features_device, features_driver;
>  	u16 val_u16;
>  
>  	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> @@ -832,12 +832,17 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>  	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>  		return -EMSGSIZE;
>  
> -	features = vdev->config->get_driver_features(vdev);
> -	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
> +	features_driver = vdev->config->get_driver_features(vdev);
> +	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> +			      VDPA_ATTR_PAD))
> +		return -EMSGSIZE;
> +
> +	features_device = vdev->config->get_device_features(vdev);
> +	if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
>  			      VDPA_ATTR_PAD))
>  		return -EMSGSIZE;
>  
> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
> +	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
>  }
>  
>  static int
> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
> index 25c55cab3d7c..39f1c3d7c112 100644
> --- a/include/uapi/linux/vdpa.h
> +++ b/include/uapi/linux/vdpa.h
> @@ -47,6 +47,7 @@ enum vdpa_attr {
>  	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
>  	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
>  	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
> +	VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,	/* u64 */
>  
>  	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>  	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
> -- 
> 2.31.1

