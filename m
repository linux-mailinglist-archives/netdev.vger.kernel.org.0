Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65416EEC40
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 04:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbjDZCMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 22:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238420AbjDZCMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 22:12:39 -0400
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F1746A1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 19:12:37 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Vh0mqr._1682475153;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vh0mqr._1682475153)
          by smtp.aliyun-inc.com;
          Wed, 26 Apr 2023 10:12:34 +0800
Message-ID: <1682474997.6771185-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v4 virtio 01/10] virtio: allow caller to override device id and DMA mask
Date:   Wed, 26 Apr 2023 10:09:57 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     <drivers@pensando.io>, <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <netdev@vger.kernel.org>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
 <20230425212602.1157-2-shannon.nelson@amd.com>
In-Reply-To: <20230425212602.1157-2-shannon.nelson@amd.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 14:25:53 -0700, Shannon Nelson <shannon.nelson@amd.com> wrote:
> To add a bit of flexibility with various virtio based devices, allow
> the caller to specify a different device id and DMA mask.  This adds
> fields to struct virtio_pci_modern_device to specify an override device
> id check and a DMA mask.
>
> int (*device_id_check)(struct pci_dev *pdev);
> 	If defined by the driver, this function will be called to check
> 	that the PCI device is the vendor's expected device, and will
> 	return the found device id to be stored in mdev->id.device.
> 	This allows vendors with alternative vendor device ids to use
> 	this library on their own device BAR.
>
> u64 dma_mask;
> 	If defined by the driver, this mask will be used in a call to
> 	dma_set_mask_and_coherent() instead of the traditional
> 	DMA_BIT_MASK(64).  This allows limiting the DMA space on
> 	vendor devices with address limitations.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/virtio/virtio_pci_modern_dev.c | 37 +++++++++++++++++---------
>  include/linux/virtio_pci_modern.h      |  6 +++++
>  2 files changed, 31 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
> index 869cb46bef96..1f2db76e8f91 100644
> --- a/drivers/virtio/virtio_pci_modern_dev.c
> +++ b/drivers/virtio/virtio_pci_modern_dev.c
> @@ -218,21 +218,29 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
>  	int err, common, isr, notify, device;
>  	u32 notify_length;
>  	u32 notify_offset;
> +	int devid;
>
>  	check_offsets();
>
> -	/* We only own devices >= 0x1000 and <= 0x107f: leave the rest. */
> -	if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
> -		return -ENODEV;
> -
> -	if (pci_dev->device < 0x1040) {
> -		/* Transitional devices: use the PCI subsystem device id as
> -		 * virtio device id, same as legacy driver always did.
> -		 */
> -		mdev->id.device = pci_dev->subsystem_device;
> +	if (mdev->device_id_check) {
> +		devid = mdev->device_id_check(pci_dev);
> +		if (devid < 0)
> +			return devid;

I would want to know is there any other reason to return the errno?
How about return -ENODEV directly?

Thanks.


> +		mdev->id.device = devid;
>  	} else {
> -		/* Modern devices: simply use PCI device id, but start from 0x1040. */
> -		mdev->id.device = pci_dev->device - 0x1040;
> +		/* We only own devices >= 0x1000 and <= 0x107f: leave the rest. */
> +		if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
> +			return -ENODEV;
> +
> +		if (pci_dev->device < 0x1040) {
> +			/* Transitional devices: use the PCI subsystem device id as
> +			 * virtio device id, same as legacy driver always did.
> +			 */
> +			mdev->id.device = pci_dev->subsystem_device;
> +		} else {
> +			/* Modern devices: simply use PCI device id, but start from 0x1040. */
> +			mdev->id.device = pci_dev->device - 0x1040;
> +		}
>  	}
>  	mdev->id.vendor = pci_dev->subsystem_vendor;
>
> @@ -260,7 +268,12 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
>  		return -EINVAL;
>  	}
>
> -	err = dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(64));
> +	if (mdev->dma_mask)
> +		err = dma_set_mask_and_coherent(&pci_dev->dev,
> +						mdev->dma_mask);
> +	else
> +		err = dma_set_mask_and_coherent(&pci_dev->dev,
> +						DMA_BIT_MASK(64));
>  	if (err)
>  		err = dma_set_mask_and_coherent(&pci_dev->dev,
>  						DMA_BIT_MASK(32));
> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
> index c4eeb79b0139..067ac1d789bc 100644
> --- a/include/linux/virtio_pci_modern.h
> +++ b/include/linux/virtio_pci_modern.h
> @@ -38,6 +38,12 @@ struct virtio_pci_modern_device {
>  	int modern_bars;
>
>  	struct virtio_device_id id;
> +
> +	/* optional check for vendor virtio device, returns dev_id or -ERRNO */
> +	int (*device_id_check)(struct pci_dev *pdev);
> +
> +	/* optional mask for devices with limited DMA space */
> +	u64 dma_mask;
>  };
>
>  /*
> --
> 2.17.1
>
