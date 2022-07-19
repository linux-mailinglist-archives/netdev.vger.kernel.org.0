Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1BAE57A7C7
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 21:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbiGST6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 15:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239911AbiGST5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 15:57:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C9885F99E
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 12:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658260638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nmfj/HdGo7zFRPrsqEE+zb+jXM6fuJ575jDepw2rtxo=;
        b=iDi+K7zKP27alqjnwi8YML1X1xLgANuImcJeCxesTu0afBbYLCuFqVmL9q2fekkp0Ynon9
        uyHVNMm2XS5sXXOPChrmADpanaBPetW4tQzXmzVrZLqtlIbWMXlfTxxq+43TQrdRzp29JK
        aGF/e1jYJY2WUc4LsWjQRrHOx+lIw04=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-WA0x73_3O0i44EJj-7f-Iw-1; Tue, 19 Jul 2022 15:57:16 -0400
X-MC-Unique: WA0x73_3O0i44EJj-7f-Iw-1
Received: by mail-io1-f71.google.com with SMTP id m9-20020a6b7b49000000b0067c0331524cso3795893iop.21
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 12:57:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nmfj/HdGo7zFRPrsqEE+zb+jXM6fuJ575jDepw2rtxo=;
        b=C1fqfj8PRlZdNfofKmHRwrAwfQmbv64ioqkim+gzfs5ECT8iv9wAoefwYPGHDXaYZF
         pNm3Uu/8oJ12GqBl1av4psFmFlbkHoc9mg/3c/+c0RlQ0HcJNceugue0LXshK9DAwfa4
         xEbegI7S2doSz8uT78Tox7TaZVgxx/ByNf/T67xnSJPGlfS77bPk5yvaOtY0xrPfK12N
         TLyVqx3W3YD2TpzUDT2Pf4PY2Zm6aN8sAYFIjc509Zoq0Q6A+orcUcEbtxzbNx8He8kJ
         weMxstsKb4AsmNWYz558BqjIYz6FbpPAU1poTgdNdMejO9DEd0IZnI65xTuitUThG3Ev
         Qb1g==
X-Gm-Message-State: AJIora//Zxl1PM0tC2c6qxWIs//rMR0ZydGMa7rnyGMGzZoDKX/sep4j
        BOUCwNPYR5RxQsIXyeDSRpeiP4u6aOig6abi2F2rxBCEKLOdEnwEuvACQya2om+57eJfTjJTf3f
        qcE+FB7xa32MgIYhA
X-Received: by 2002:a05:6638:3387:b0:33c:9f9e:5a17 with SMTP id h7-20020a056638338700b0033c9f9e5a17mr18235287jav.12.1658260636108;
        Tue, 19 Jul 2022 12:57:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sQetubxeBzqoGe5fqjeSCwtA6S4PWe6B2nZ4dj8f5zYaQba41N3W8PtWwuSRb7EBMTMQ3JGg==
X-Received: by 2002:a05:6638:3387:b0:33c:9f9e:5a17 with SMTP id h7-20020a056638338700b0033c9f9e5a17mr18235279jav.12.1658260635833;
        Tue, 19 Jul 2022 12:57:15 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i13-20020a02ca0d000000b00339c1f7130csm7099085jak.84.2022.07.19.12.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 12:57:15 -0700 (PDT)
Date:   Tue, 19 Jul 2022 13:57:14 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Message-ID: <20220719135714.330297ed.alex.williamson@redhat.com>
In-Reply-To: <49bb237a-5d95-f9fc-6d0b-8bcf082034c1@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
        <20220714081251.240584-4-yishaih@nvidia.com>
        <20220718162957.45ac2a0b.alex.williamson@redhat.com>
        <49bb237a-5d95-f9fc-6d0b-8bcf082034c1@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jul 2022 10:49:42 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 19/07/2022 1:29, Alex Williamson wrote:
> > On Thu, 14 Jul 2022 11:12:43 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >  
> >> DMA logging allows a device to internally record what DMAs the device is
> >> initiating and report them back to userspace. It is part of the VFIO
> >> migration infrastructure that allows implementing dirty page tracking
> >> during the pre copy phase of live migration. Only DMA WRITEs are logged,
> >> and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
> >>
> >> This patch introduces the DMA logging involved uAPIs.
> >>
> >> It uses the FEATURE ioctl with its GET/SET/PROBE options as of below.
> >>
> >> It exposes a PROBE option to detect if the device supports DMA logging.
> >> It exposes a SET option to start device DMA logging in given IOVAs
> >> ranges.
> >> It exposes a SET option to stop device DMA logging that was previously
> >> started.
> >> It exposes a GET option to read back and clear the device DMA log.
> >>
> >> Extra details exist as part of vfio.h per a specific option.  
> >
> > Kevin, Kirti, others, any comments on this uAPI proposal?  Are there
> > potentially other devices that might make use of this or is everyone
> > else waiting for IOMMU based dirty tracking?
> >
> >     
> >> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> >> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >> ---
> >>   include/uapi/linux/vfio.h | 79 +++++++++++++++++++++++++++++++++++++++
> >>   1 file changed, 79 insertions(+)
> >>
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index 733a1cddde30..81475c3e7c92 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h
> >> @@ -986,6 +986,85 @@ enum vfio_device_mig_state {
> >>   	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
> >>   };
> >>   
> >> +/*
> >> + * Upon VFIO_DEVICE_FEATURE_SET start device DMA logging.
> >> + * VFIO_DEVICE_FEATURE_PROBE can be used to detect if the device supports
> >> + * DMA logging.
> >> + *
> >> + * DMA logging allows a device to internally record what DMAs the device is
> >> + * initiating and report them back to userspace. It is part of the VFIO
> >> + * migration infrastructure that allows implementing dirty page tracking
> >> + * during the pre copy phase of live migration. Only DMA WRITEs are logged,
> >> + * and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
> >> + *
> >> + * When DMA logging is started a range of IOVAs to monitor is provided and the
> >> + * device can optimize its logging to cover only the IOVA range given. Each
> >> + * DMA that the device initiates inside the range will be logged by the device
> >> + * for later retrieval.
> >> + *
> >> + * page_size is an input that hints what tracking granularity the device
> >> + * should try to achieve. If the device cannot do the hinted page size then it
> >> + * should pick the next closest page size it supports. On output the device
> >> + * will return the page size it selected.
> >> + *
> >> + * ranges is a pointer to an array of
> >> + * struct vfio_device_feature_dma_logging_range.
> >> + */
> >> +struct vfio_device_feature_dma_logging_control {
> >> +	__aligned_u64 page_size;
> >> +	__u32 num_ranges;
> >> +	__u32 __reserved;
> >> +	__aligned_u64 ranges;
> >> +};
> >> +
> >> +struct vfio_device_feature_dma_logging_range {
> >> +	__aligned_u64 iova;
> >> +	__aligned_u64 length;
> >> +};
> >> +
> >> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_START 3
> >> +
> >> +/*
> >> + * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
> >> + * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
> >> + */
> >> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 4
> >> +
> >> +/*
> >> + * Upon VFIO_DEVICE_FEATURE_GET read back and clear the device DMA log
> >> + *
> >> + * Query the device's DMA log for written pages within the given IOVA range.
> >> + * During querying the log is cleared for the IOVA range.
> >> + *
> >> + * bitmap is a pointer to an array of u64s that will hold the output bitmap
> >> + * with 1 bit reporting a page_size unit of IOVA. The mapping of IOVA to bits
> >> + * is given by:
> >> + *  bitmap[(addr - iova)/page_size] & (1ULL << (addr % 64))
> >> + *
> >> + * The input page_size can be any power of two value and does not have to
> >> + * match the value given to VFIO_DEVICE_FEATURE_DMA_LOGGING_START. The driver
> >> + * will format its internal logging to match the reporting page size, possibly
> >> + * by replicating bits if the internal page size is lower than requested.
> >> + *
> >> + * Bits will be updated in bitmap using atomic or to allow userspace to

s/or/OR/

> >> + * combine bitmaps from multiple trackers together. Therefore userspace must
> >> + * zero the bitmap before doing any reports.  
> > Somewhat confusing, perhaps "between report sets"?  
> 
> The idea was that the driver just turns on its own dirty bits and 
> doesn't touch others.

Right, we can aggregate dirty bits from multiple devices into a single
bitmap.

> Do you suggest the below ?
> 
> "Therefore userspace must zero the bitmap between report sets".

It may be best to simply drop this guidance, we don't need to presume
the user algorithm, we only need to make it apparent that
LOGGING_REPORT will only set bits in the bitmap and never clear or
preform any initialization of the user provided bitmap.

> >> + *
> >> + * If any error is returned userspace should assume that the dirty log is
> >> + * corrupted and restart.  
> > Restart what?  The user can't just zero the bitmap and retry, dirty
> > information at the device has been lost.  
> 
> Right
> 
> >   Are we suggesting they stop
> > DMA logging and restart it, which sounds a lot like failing a migration
> > and starting over.  Or could the user gratuitously mark the bitmap
> > fully dirty and a subsequent logging report iteration might work?
> > Thanks,
> >
> > Alex  
> 
> An error at that step is not expected and might be fatal.
> 
> User space can consider marking all as dirty and continue with that 
> approach for next iterations, maybe even without calling the driver.
> 
> Alternatively, user space can abort the migration and retry later on.
> 
> We can come with some rephrasing as of the above.
> 
> What do you think ?

If userspace needs to consider the bitmap undefined for any errno,
that's a pretty serious usage restriction that may negate the
practical utility of atomically OR'ing in dirty bits.  We can certainly
have EINVAL, ENOTTY, EFAULT, E2BIG, ENOMEM conditions that don't result
in a corrupted/undefined bitmap, right?  Maybe some of those result in
an incomplete bitmap, but how does the bitmap actually get corrupted?
It seems like such a condition should be pretty narrowly defined and
separate from errors resulting in an incomplete bitmap, maybe we'd
reserve -EIO for such a case.  The driver itself can also gratuitously
mark ranges dirty itself if it loses sync with the device, and can
probably do so at a much more accurate granularity than userspace.
Thanks,

Alex

> >> + *
> >> + * If DMA logging is not enabled, an error will be returned.
> >> + *
> >> + */
> >> +struct vfio_device_feature_dma_logging_report {
> >> +	__aligned_u64 iova;
> >> +	__aligned_u64 length;
> >> +	__aligned_u64 page_size;
> >> +	__aligned_u64 bitmap;
> >> +};
> >> +
> >> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 5
> >> +
> >>   /* -------- API for Type1 VFIO IOMMU -------- */
> >>   
> >>   /**  
> 
> 

