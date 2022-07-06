Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140095695A2
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbiGFXLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiGFXLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:11:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 860671CFC2
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657149103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HIFp6H7U8H4zLlvFPiQ4cosgxwJdUp4h1jCTeNzWHAk=;
        b=KreyBUbvT6USHcQnio8D8S1xNBcaNB+SE+Soa10Ic4cO29trlh6fQ6xxN8MUJrg81ouPxS
        H665JhUaDk/G3ZQeFKUIoDGQnhqEK8YARmUN8Tm6qk9ERN+rqGysdcEXqnqX6/iiEoAMLc
        kaRTCQorShOlXZ9aXJxsesWvYnO92xs=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-B811iVv-M46ajnpbyqS2QA-1; Wed, 06 Jul 2022 19:11:40 -0400
X-MC-Unique: B811iVv-M46ajnpbyqS2QA-1
Received: by mail-il1-f198.google.com with SMTP id h5-20020a056e021b8500b002d8f50441a2so8460994ili.13
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 16:11:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HIFp6H7U8H4zLlvFPiQ4cosgxwJdUp4h1jCTeNzWHAk=;
        b=F9vFVdG00S8FAQ2HAVbkp/r2H4qgobf0P8Ya9RAaLZs6eJwVpjZxyboAnHNiHlBp4g
         p9pHYMQlo0PAMncp9iUz3ADf8LiO0wXpSB0pHgVDPyJWqsn5pjaKJdCFNOkk+9PgOmPg
         6pXYvh3wfWfu2WWsj5Cly0jhrf1XiM/fPVVXzhcGdEUe9qM7mjLPI59CeFFrGaUES9+N
         WLSiNGWiVh8DaAL4EHXC1SYLQqjRd7rVXM+A6ACsyNqQN/ZGrvTcnn9ccAkSh48RMlcu
         KY7KeA4cGCIBOwg8LLAB0/HBj8xstFrBTFybDbyxyX8Few42H+0voPC3mFH0ykl5FL+Z
         z0Fw==
X-Gm-Message-State: AJIora+sbYQrEmdxOIM7rciYnIxU5F4Ci90zwa2sAZW4UgIK96zi5A8z
        uS3Yu0T862PP/IPNm+ygZL/NP95/wFuBoeinhhFofLwryz4MByy9WoU0Aj7wUyYfKVVOp2F3nrc
        +h1qJtK2vl+gL5HrM
X-Received: by 2002:a6b:c941:0:b0:672:734f:d05f with SMTP id z62-20020a6bc941000000b00672734fd05fmr21700439iof.87.1657149099768;
        Wed, 06 Jul 2022 16:11:39 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sUYXLuk3UWGNawVyOpx/TmaNJ2nFfBX9aQU/SF56aO/Kg2TRfjIV+nR5aoaDdS7GE946l1hw==
X-Received: by 2002:a6b:c941:0:b0:672:734f:d05f with SMTP id z62-20020a6bc941000000b00672734fd05fmr21700422iof.87.1657149099536;
        Wed, 06 Jul 2022 16:11:39 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u125-20020a022383000000b0033ebbb649fasm5678501jau.101.2022.07.06.16.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 16:11:39 -0700 (PDT)
Date:   Wed, 6 Jul 2022 17:11:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V1 vfio 03/11] vfio: Introduce DMA logging uAPIs
Message-ID: <20220706171137.47e4aa10.alex.williamson@redhat.com>
In-Reply-To: <20220705102740.29337-4-yishaih@nvidia.com>
References: <20220705102740.29337-1-yishaih@nvidia.com>
        <20220705102740.29337-4-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jul 2022 13:27:32 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> DMA logging allows a device to internally record what DMAs the device is
> initiating and report them back to userspace. It is part of the VFIO
> migration infrastructure that allows implementing dirty page tracking
> during the pre copy phase of live migration. Only DMA WRITEs are logged,
> and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
> 
> This patch introduces the DMA logging involved uAPIs.
> 
> It uses the FEATURE ioctl with its GET/SET/PROBE options as of below.
> 
> It exposes a PROBE option to detect if the device supports DMA logging.
> It exposes a SET option to start device DMA logging in given IOVAs
> ranges.
> It exposes a SET option to stop device DMA logging that was previously
> started.
> It exposes a GET option to read back and clear the device DMA log.
> 
> Extra details exist as part of vfio.h per a specific option.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 79 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 79 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 733a1cddde30..81475c3e7c92 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -986,6 +986,85 @@ enum vfio_device_mig_state {
>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>  };
>  
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET start device DMA logging.
> + * VFIO_DEVICE_FEATURE_PROBE can be used to detect if the device supports
> + * DMA logging.
> + *
> + * DMA logging allows a device to internally record what DMAs the device is
> + * initiating and report them back to userspace. It is part of the VFIO
> + * migration infrastructure that allows implementing dirty page tracking
> + * during the pre copy phase of live migration. Only DMA WRITEs are logged,
> + * and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
> + *
> + * When DMA logging is started a range of IOVAs to monitor is provided and the
> + * device can optimize its logging to cover only the IOVA range given. Each
> + * DMA that the device initiates inside the range will be logged by the device
> + * for later retrieval.
> + *
> + * page_size is an input that hints what tracking granularity the device
> + * should try to achieve. If the device cannot do the hinted page size then it
> + * should pick the next closest page size it supports. On output the device
> + * will return the page size it selected.
> + *
> + * ranges is a pointer to an array of
> + * struct vfio_device_feature_dma_logging_range.
> + */
> +struct vfio_device_feature_dma_logging_control {
> +	__aligned_u64 page_size;
> +	__u32 num_ranges;
> +	__u32 __reserved;
> +	__aligned_u64 ranges;
> +};

num_ranges probably has a limit below 2^32-1, is it device specific?
How does the user learn the limit?

Presumably new ranges cannot be added while logging is already enabled,
should we build this limitation into the uAPI or might some devices
have the ability to dynamically add and remove logging ranges?  Thanks,

Alex

> +
> +struct vfio_device_feature_dma_logging_range {
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_START 3
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
> + * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
> + */
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 4
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_GET read back and clear the device DMA log
> + *
> + * Query the device's DMA log for written pages within the given IOVA range.
> + * During querying the log is cleared for the IOVA range.
> + *
> + * bitmap is a pointer to an array of u64s that will hold the output bitmap
> + * with 1 bit reporting a page_size unit of IOVA. The mapping of IOVA to bits
> + * is given by:
> + *  bitmap[(addr - iova)/page_size] & (1ULL << (addr % 64))
> + *
> + * The input page_size can be any power of two value and does not have to
> + * match the value given to VFIO_DEVICE_FEATURE_DMA_LOGGING_START. The driver
> + * will format its internal logging to match the reporting page size, possibly
> + * by replicating bits if the internal page size is lower than requested.
> + *
> + * Bits will be updated in bitmap using atomic or to allow userspace to
> + * combine bitmaps from multiple trackers together. Therefore userspace must
> + * zero the bitmap before doing any reports.
> + *
> + * If any error is returned userspace should assume that the dirty log is
> + * corrupted and restart.
> + *
> + * If DMA logging is not enabled, an error will be returned.
> + *
> + */
> +struct vfio_device_feature_dma_logging_report {
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +	__aligned_u64 page_size;
> +	__aligned_u64 bitmap;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 5
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**

