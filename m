Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D695A1A8E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbiHYUty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiHYUtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:49:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E611EC6E
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 13:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661460590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4vCNp8onSsBOOAnD85MiLb1VrhM+q+amfgv6dKZtoeo=;
        b=SpKv5rxJh7d3yPYskgEbvHFzOobs8ItMd7S7D7MN67m+RRmmYzUu2GquzRcUpT30IYcnEj
        /CNizFR8GdT9041m5y+n0frWQ0DhSSG0+dYjLGaSndCdiiW3tE8gFORcBtVRNCo3EyGf9p
        6wwUdLuIR8qPtih772exTEX2Gpb8QsU=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-564-ZuZxuUaPMYSHF_dMPv8kzA-1; Thu, 25 Aug 2022 16:49:49 -0400
X-MC-Unique: ZuZxuUaPMYSHF_dMPv8kzA-1
Received: by mail-io1-f71.google.com with SMTP id x9-20020a056602210900b006897b3869e4so9882503iox.16
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 13:49:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=4vCNp8onSsBOOAnD85MiLb1VrhM+q+amfgv6dKZtoeo=;
        b=oqUSLD6qsSFVxMMHbLZXUuE8rCnKkSM89Sh+jznUPkG7UO6TcJA17KAXeml9a4Hzh4
         vV1UEZJLYihjU4jcIoz6XiqLCxJQFke+6dscl4ar4pHT4WUGYJ0rGVN6i+0xIaE/mmVu
         Kb+d9HRG45lWPAVPz+apDhVva0IPcgtLFvFURjkBhtzqgJILUQyCPJuqWiZ/ApA+qXNp
         6wMRK1rmN3O/kGqt3mWaSwwMnN7JzhRIV8tf/mJ0bURBqkUyGtlphC5HIAf44Rs9Te1X
         hJhjzRVv9QHFzjJbzCWaV7IERo9a2igrr9p6t+HpcrJxBsTa4yikEVPZ28HawKGYvHwu
         TMvA==
X-Gm-Message-State: ACgBeo1RkqGoMpNp8U+PAH5xJky6aatlz6pRa/EGHl4YcU+m95WkE/l7
        kaQfG3Y1jm7V2W28PFSqCyHMavtsD7gpWxKUKFvtL780NnleT5+4M2lPjebEkjOkVYp9tB5sYTM
        yDD0oF+Ji7suLDtNu
X-Received: by 2002:a05:6638:338b:b0:34a:499:c638 with SMTP id h11-20020a056638338b00b0034a0499c638mr2751369jav.87.1661460588992;
        Thu, 25 Aug 2022 13:49:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5ncR7r2bodD0dv6e5o5tpCa2HHBqoCEgDTRAa3LrjFO0tKio77PfyjOMcNZpw9ftHlfyLjww==
X-Received: by 2002:a05:6638:338b:b0:34a:499:c638 with SMTP id h11-20020a056638338b00b0034a0499c638mr2751362jav.87.1661460588801;
        Thu, 25 Aug 2022 13:49:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h12-20020a056602154c00b0068a235db030sm103496iow.27.2022.08.25.13.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 13:49:48 -0700 (PDT)
Date:   Thu, 25 Aug 2022 14:49:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V4 vfio 05/10] vfio: Introduce the DMA logging feature
 support
Message-ID: <20220825144944.237eb78f.alex.williamson@redhat.com>
In-Reply-To: <20220815151109.180403-6-yishaih@nvidia.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
        <20220815151109.180403-6-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Aug 2022 18:11:04 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:
> +static int
> +vfio_ioctl_device_feature_logging_report(struct vfio_device *device,
> +					 u32 flags, void __user *arg,
> +					 size_t argsz)
> +{
> +	size_t minsz =
> +		offsetofend(struct vfio_device_feature_dma_logging_report,
> +			    bitmap);
> +	struct vfio_device_feature_dma_logging_report report;
> +	struct iova_bitmap_iter iter;
> +	int ret;
> +
> +	if (!device->log_ops)
> +		return -ENOTTY;
> +
> +	ret = vfio_check_feature(flags, argsz,
> +				 VFIO_DEVICE_FEATURE_GET,
> +				 sizeof(report));
> +	if (ret != 1)
> +		return ret;
> +
> +	if (copy_from_user(&report, arg, minsz))
> +		return -EFAULT;
> +
> +	if (report.page_size < PAGE_SIZE || !is_power_of_2(report.page_size))

Why is PAGE_SIZE a factor here?  I'm under the impression that
iova_bitmap is intended to handle arbitrary page sizes.  Thanks,

Alex

> +		return -EINVAL;
> +
> +	ret = iova_bitmap_iter_init(&iter, report.iova, report.length,
> +				    report.page_size,
> +				    u64_to_user_ptr(report.bitmap));
> +	if (ret)
> +		return ret;
> +
> +	for (; !iova_bitmap_iter_done(&iter) && !ret;
> +	     ret = iova_bitmap_iter_advance(&iter)) {
> +		ret = device->log_ops->log_read_and_clear(device,
> +			iova_bitmap_iova(&iter),
> +			iova_bitmap_length(&iter), &iter.dirty);
> +		if (ret)
> +			break;
> +	}
> +
> +	iova_bitmap_iter_free(&iter);
> +	return ret;
> +}

