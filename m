Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F606BA069
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjCNUGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCNUGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:06:19 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B0F4347C;
        Tue, 14 Mar 2023 13:06:17 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x3so66820900edb.10;
        Tue, 14 Mar 2023 13:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678824376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OjikSDB/A+i4L9BeqERv0l8R/cRWGNu1EDH8YsBPfDg=;
        b=WhPYLI/Cny3mi6cww7cX6wbq3H92VOuCnEWKRdB6U2tK6BG3rs+aYdOWOJYDJMkf0a
         YREyt5dhSV4EDSdN3YXUQLBsIucZwPq/g8ic4KrDpZeXc5d1yJ9FbiK60ubHgENmR5D5
         AAP53U0dQ7M5LI77LqhB/hg3e2yuBptasDRCRWIoWeeiK6v5YIew+G1K9/3S5GpYUOvY
         QKLtZqoUVDyLcXFxp+NL0kVxXSyrAN+LeHXs7HkVk9yTsuGEcryrqh3wmQVTVLuwQU6z
         Bjn65mXLdmql8HJo/MZhcBsxZSdc64nEb/gFUi4xL+our/ooo2UtSGFmUvy6UwasRWa1
         fFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678824376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OjikSDB/A+i4L9BeqERv0l8R/cRWGNu1EDH8YsBPfDg=;
        b=qrCZWYy6fy74+lG+VdXOWcFAs3iA44EVdRFipu3qeysfDo+lCpNagoC8PGU4ZQGxzG
         4mGQQSj0pCHyddOfP6Vn1xZEWkDQssKcg+zanUS0FqK3yTGEEEUOEsoENLIiVBb62o+3
         AYjR+RmwTJNsTOBvUQaomnrhTsrnifYhiy2uGXgqpBzQWdHHEQXimexSsUtWOGjq2bV+
         MORtVVWEwBkYiELV6O3lH9/M56ZsNTUtvZw4L7XRbIRrJOX2E9p48rPGVsKwHTVWIMQR
         loMWe92dZ6YXCEQsUiG+WAAvE5qBAY2eRGMtdvCDihMnuSQGM0hETxLBpKyRrHH3LTI6
         P2aw==
X-Gm-Message-State: AO0yUKU50ENxeI45t12BabuLJgoZP6DJA+Fs+2su6t0HBRVkYzMsOifM
        nF2AtEmg48Z4/9MbU/hASZE=
X-Google-Smtp-Source: AK7set/OF3AdfTGjwEHlL5tu1CQX7SQa6dKdOeg+TCkjQnwZiD4NH1p423e+b6+vxXGoSHFc7z6hVw==
X-Received: by 2002:a17:906:32d4:b0:878:7f6e:38a7 with SMTP id k20-20020a17090632d400b008787f6e38a7mr3719709ejk.44.1678824375883;
        Tue, 14 Mar 2023 13:06:15 -0700 (PDT)
Received: from jernej-laptop.localnet (82-149-1-233.dynamic.telemach.net. [82.149.1.233])
        by smtp.gmail.com with ESMTPSA id w11-20020a1709062f8b00b00923bb9f0c36sm1535480eji.127.2023.03.14.13.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:06:15 -0700 (PDT)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Gerd Bayer <gbayer@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Hector Martin <marcan@marcan.st>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Yong Wu <yong.wu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Samuel Holland <samuel@sholland.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux.dev, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v8 2/6] iommu: Allow .iotlb_sync_map to fail and handle s390's
 -ENOMEM return
Date:   Tue, 14 Mar 2023 21:06:12 +0100
Message-ID: <3724716.kQq0lBPeGt@jernej-laptop>
In-Reply-To: <20230310-dma_iommu-v8-2-2347dfbed7af@linux.ibm.com>
References: <20230310-dma_iommu-v8-0-2347dfbed7af@linux.ibm.com>
 <20230310-dma_iommu-v8-2-2347dfbed7af@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dne petek, 10. marec 2023 ob 17:07:47 CET je Niklas Schnelle napisal(a):
> On s390 when using a paging hypervisor, .iotlb_sync_map is used to sync
> mappings by letting the hypervisor inspect the synced IOVA range and
> updating a shadow table. This however means that .iotlb_sync_map can
> fail as the hypervisor may run out of resources while doing the sync.
> This can be due to the hypervisor being unable to pin guest pages, due
> to a limit on mapped addresses such as vfio_iommu_type1.dma_entry_limit
> or lack of other resources. Either way such a failure to sync a mapping
> should result in a DMA_MAPPING_ERROR.
> 
> Now especially when running with batched IOTLB flushes for unmap it may
> be that some IOVAs have already been invalidated but not yet synced via
> .iotlb_sync_map. Thus if the hypervisor indicates running out of
> resources, first do a global flush allowing the hypervisor to free
> resources associated with these mappings as well a retry creating the
> new mappings and only if that also fails report this error to callers.
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
>  drivers/iommu/amd/iommu.c    |  5 +++--
>  drivers/iommu/apple-dart.c   |  5 +++--
>  drivers/iommu/intel/iommu.c  |  5 +++--
>  drivers/iommu/iommu.c        | 20 ++++++++++++++++----
>  drivers/iommu/msm_iommu.c    |  5 +++--
>  drivers/iommu/mtk_iommu.c    |  5 +++--
>  drivers/iommu/s390-iommu.c   | 29 ++++++++++++++++++++++++-----
>  drivers/iommu/sprd-iommu.c   |  5 +++--
>  drivers/iommu/sun50i-iommu.c |  4 +++-

For sun50i:
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>

Best regards,
Jernej

>  drivers/iommu/tegra-gart.c   |  5 +++--
>  include/linux/iommu.h        |  4 ++--
>  11 files changed, 66 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 5a505ba5467e..ff309bd1bb8f 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2187,14 +2187,15 @@ static int amd_iommu_attach_device(struct
> iommu_domain *dom, return ret;
>  }
> 
> -static void amd_iommu_iotlb_sync_map(struct iommu_domain *dom,
> -				     unsigned long iova, size_t 
size)
> +static int amd_iommu_iotlb_sync_map(struct iommu_domain *dom,
> +				    unsigned long iova, size_t 
size)
>  {
>  	struct protection_domain *domain = to_pdomain(dom);
>  	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
> 
>  	if (ops->map_pages)
>  		domain_flush_np_cache(domain, iova, size);
> +	return 0;
>  }
> 
>  static int amd_iommu_map_pages(struct iommu_domain *dom, unsigned long
> iova, diff --git a/drivers/iommu/apple-dart.c b/drivers/iommu/apple-dart.c
> index 06169d36eab8..cbed1f87eae9 100644
> --- a/drivers/iommu/apple-dart.c
> +++ b/drivers/iommu/apple-dart.c
> @@ -506,10 +506,11 @@ static void apple_dart_iotlb_sync(struct iommu_domain
> *domain, apple_dart_domain_flush_tlb(to_dart_domain(domain));
>  }
> 
> -static void apple_dart_iotlb_sync_map(struct iommu_domain *domain,
> -				      unsigned long iova, size_t 
size)
> +static int apple_dart_iotlb_sync_map(struct iommu_domain *domain,
> +				     unsigned long iova, size_t 
size)
>  {
>  	apple_dart_domain_flush_tlb(to_dart_domain(domain));
> +	return 0;
>  }
> 
>  static phys_addr_t apple_dart_iova_to_phys(struct iommu_domain *domain,
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 7c2f4bd33582..b795b2f323e3 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4745,8 +4745,8 @@ static bool risky_device(struct pci_dev *pdev)
>  	return false;
>  }
> 
> -static void intel_iommu_iotlb_sync_map(struct iommu_domain *domain,
> -				       unsigned long iova, size_t 
size)
> +static int intel_iommu_iotlb_sync_map(struct iommu_domain *domain,
> +				      unsigned long iova, size_t 
size)
>  {
>  	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>  	unsigned long pages = aligned_nrpages(iova, size);
> @@ -4756,6 +4756,7 @@ static void intel_iommu_iotlb_sync_map(struct
> iommu_domain *domain,
> 
>  	xa_for_each(&dmar_domain->iommu_array, i, info)
>  		__mapping_notify_one(info->iommu, dmar_domain, pfn, 
pages);
> +	return 0;
>  }
> 
>  static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t
> pasid) diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 10db680acaed..ae549b032a16 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2410,8 +2410,17 @@ int iommu_map(struct iommu_domain *domain, unsigned
> long iova, return -EINVAL;
> 
>  	ret = __iommu_map(domain, iova, paddr, size, prot, gfp);
> -	if (ret == 0 && ops->iotlb_sync_map)
> -		ops->iotlb_sync_map(domain, iova, size);
> +	if (ret == 0 && ops->iotlb_sync_map) {
> +		ret = ops->iotlb_sync_map(domain, iova, size);
> +		if (ret)
> +			goto out_err;
> +	}
> +
> +	return ret;
> +
> +out_err:
> +	/* undo mappings already done */
> +	iommu_unmap(domain, iova, size);
> 
>  	return ret;
>  }
> @@ -2552,8 +2561,11 @@ ssize_t iommu_map_sg(struct iommu_domain *domain,
> unsigned long iova, sg = sg_next(sg);
>  	}
> 
> -	if (ops->iotlb_sync_map)
> -		ops->iotlb_sync_map(domain, iova, mapped);
> +	if (ops->iotlb_sync_map) {
> +		ret = ops->iotlb_sync_map(domain, iova, mapped);
> +		if (ret)
> +			goto out_err;
> +	}
>  	return mapped;
> 
>  out_err:
> diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
> index 454f6331c889..2033716eac78 100644
> --- a/drivers/iommu/msm_iommu.c
> +++ b/drivers/iommu/msm_iommu.c
> @@ -486,12 +486,13 @@ static int msm_iommu_map(struct iommu_domain *domain,
> unsigned long iova, return ret;
>  }
> 
> -static void msm_iommu_sync_map(struct iommu_domain *domain, unsigned long
> iova, -			       size_t size)
> +static int msm_iommu_sync_map(struct iommu_domain *domain, unsigned long
> iova, +			      size_t size)
>  {
>  	struct msm_priv *priv = to_msm_priv(domain);
> 
>  	__flush_iotlb_range(iova, size, SZ_4K, false, priv);
> +	return 0;
>  }
> 
>  static size_t msm_iommu_unmap(struct iommu_domain *domain, unsigned long
> iova, diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
> index d5a4955910ff..29769fb5c51e 100644
> --- a/drivers/iommu/mtk_iommu.c
> +++ b/drivers/iommu/mtk_iommu.c
> @@ -750,12 +750,13 @@ static void mtk_iommu_iotlb_sync(struct iommu_domain
> *domain, mtk_iommu_tlb_flush_range_sync(gather->start, length, dom->bank);
> }
> 
> -static void mtk_iommu_sync_map(struct iommu_domain *domain, unsigned long
> iova, -			       size_t size)
> +static int mtk_iommu_sync_map(struct iommu_domain *domain, unsigned long
> iova, +			      size_t size)
>  {
>  	struct mtk_iommu_domain *dom = to_mtk_domain(domain);
> 
>  	mtk_iommu_tlb_flush_range_sync(iova, size, dom->bank);
> +	return 0;
>  }
> 
>  static phys_addr_t mtk_iommu_iova_to_phys(struct iommu_domain *domain,
> diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
> index fbf59a8db29b..17174b35db11 100644
> --- a/drivers/iommu/s390-iommu.c
> +++ b/drivers/iommu/s390-iommu.c
> @@ -205,6 +205,14 @@ static void s390_iommu_release_device(struct device
> *dev) __s390_iommu_detach_device(zdev);
>  }
> 
> +
> +static int zpci_refresh_all(struct zpci_dev *zdev)
> +{
> +	return zpci_refresh_trans((u64)zdev->fh << 32, zdev->start_dma,
> +				  zdev->end_dma - zdev->start_dma 
+ 1);
> +
> +}
> +
>  static void s390_iommu_flush_iotlb_all(struct iommu_domain *domain)
>  {
>  	struct s390_domain *s390_domain = to_s390_domain(domain);
> @@ -212,8 +220,7 @@ static void s390_iommu_flush_iotlb_all(struct
> iommu_domain *domain)
> 
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(zdev, &s390_domain->devices, iommu_list) {
> -		zpci_refresh_trans((u64)zdev->fh << 32, zdev-
>start_dma,
> -				   zdev->end_dma - zdev-
>start_dma + 1);
> +		zpci_refresh_all(zdev);
>  	}
>  	rcu_read_unlock();
>  }
> @@ -237,20 +244,32 @@ static void s390_iommu_iotlb_sync(struct iommu_domain
> *domain, rcu_read_unlock();
>  }
> 
> -static void s390_iommu_iotlb_sync_map(struct iommu_domain *domain,
> +static int s390_iommu_iotlb_sync_map(struct iommu_domain *domain,
>  				      unsigned long iova, size_t 
size)
>  {
>  	struct s390_domain *s390_domain = to_s390_domain(domain);
>  	struct zpci_dev *zdev;
> +	int ret = 0;
> 
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(zdev, &s390_domain->devices, iommu_list) {
>  		if (!zdev->tlb_refresh)
>  			continue;
> -		zpci_refresh_trans((u64)zdev->fh << 32,
> -				   iova, size);
> +		ret = zpci_refresh_trans((u64)zdev->fh << 32,
> +					 iova, size);
> +		/*
> +		 * let the hypervisor discover invalidated entries
> +		 * allowing it to free IOVAs and unpin pages
> +		 */
> +		if (ret == -ENOMEM) {
> +			ret = zpci_refresh_all(zdev);
> +			if (ret)
> +				break;
> +		}
>  	}
>  	rcu_read_unlock();
> +
> +	return ret;
>  }
> 
>  static int s390_iommu_validate_trans(struct s390_domain *s390_domain,
> diff --git a/drivers/iommu/sprd-iommu.c b/drivers/iommu/sprd-iommu.c
> index ae94d74b73f4..74bcae69653c 100644
> --- a/drivers/iommu/sprd-iommu.c
> +++ b/drivers/iommu/sprd-iommu.c
> @@ -315,8 +315,8 @@ static size_t sprd_iommu_unmap(struct iommu_domain
> *domain, unsigned long iova, return size;
>  }
> 
> -static void sprd_iommu_sync_map(struct iommu_domain *domain,
> -				unsigned long iova, size_t size)
> +static int sprd_iommu_sync_map(struct iommu_domain *domain,
> +			       unsigned long iova, size_t size)
>  {
>  	struct sprd_iommu_domain *dom = to_sprd_domain(domain);
>  	unsigned int reg;
> @@ -328,6 +328,7 @@ static void sprd_iommu_sync_map(struct iommu_domain
> *domain,
> 
>  	/* clear IOMMU TLB buffer after page table updated */
>  	sprd_iommu_write(dom->sdev, reg, 0xffffffff);
> +	return 0;
>  }
> 
>  static void sprd_iommu_sync(struct iommu_domain *domain,
> diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
> index 2d993d0cea7d..60a983f4a494 100644
> --- a/drivers/iommu/sun50i-iommu.c
> +++ b/drivers/iommu/sun50i-iommu.c
> @@ -402,7 +402,7 @@ static void sun50i_iommu_flush_iotlb_all(struct
> iommu_domain *domain) spin_unlock_irqrestore(&iommu->iommu_lock, flags);
>  }
> 
> -static void sun50i_iommu_iotlb_sync_map(struct iommu_domain *domain,
> +static int sun50i_iommu_iotlb_sync_map(struct iommu_domain *domain,
>  					unsigned long iova, 
size_t size)
>  {
>  	struct sun50i_iommu_domain *sun50i_domain = 
to_sun50i_domain(domain);
> @@ -412,6 +412,8 @@ static void sun50i_iommu_iotlb_sync_map(struct
> iommu_domain *domain, spin_lock_irqsave(&iommu->iommu_lock, flags);
>  	sun50i_iommu_zap_range(iommu, iova, size);
>  	spin_unlock_irqrestore(&iommu->iommu_lock, flags);
> +
> +	return 0;
>  }
> 
>  static void sun50i_iommu_iotlb_sync(struct iommu_domain *domain,
> diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
> index a482ff838b53..44966d7b07ba 100644
> --- a/drivers/iommu/tegra-gart.c
> +++ b/drivers/iommu/tegra-gart.c
> @@ -252,10 +252,11 @@ static int gart_iommu_of_xlate(struct device *dev,
>  	return 0;
>  }
> 
> -static void gart_iommu_sync_map(struct iommu_domain *domain, unsigned long
> iova, -				size_t size)
> +static int gart_iommu_sync_map(struct iommu_domain *domain, unsigned long
> iova, +			       size_t size)
>  {
>  	FLUSH_GART_REGS(gart_handle);
> +	return 0;
>  }
> 
>  static void gart_iommu_sync(struct iommu_domain *domain,
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 6595454d4f48..932e5532ee33 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -333,8 +333,8 @@ struct iommu_domain_ops {
>  			      struct iommu_iotlb_gather 
*iotlb_gather);
> 
>  	void (*flush_iotlb_all)(struct iommu_domain *domain);
> -	void (*iotlb_sync_map)(struct iommu_domain *domain, unsigned long 
iova,
> -			       size_t size);
> +	int (*iotlb_sync_map)(struct iommu_domain *domain, unsigned long 
iova,
> +			      size_t size);
>  	void (*iotlb_sync)(struct iommu_domain *domain,
>  			   struct iommu_iotlb_gather *iotlb_gather);




