Return-Path: <netdev+bounces-4365-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 342F370C344
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B56DC1C20B6B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 459AF16411;
	Mon, 22 May 2023 16:26:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34178154AA
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 16:26:21 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC404F1;
	Mon, 22 May 2023 09:26:16 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B316139F;
	Mon, 22 May 2023 09:27:01 -0700 (PDT)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4399F3F762;
	Mon, 22 May 2023 09:26:09 -0700 (PDT)
Message-ID: <b1e53f39-5e0b-a09d-2954-cdc9e8592b67@arm.com>
Date: Mon, 22 May 2023 17:26:03 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v9 5/6] iommu/dma: Allow a single FQ in addition to
 per-CPU FQs
To: Niklas Schnelle <schnelle@linux.ibm.com>, Joerg Roedel <joro@8bytes.org>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Will Deacon <will@kernel.org>,
 Wenjia Zhang <wenjia@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Gerd Bayer <gbayer@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>,
 Pierre Morel <pmorel@linux.ibm.com>, Alexandra Winter
 <wintera@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konrad.dybcio@linaro.org>, Yong Wu <yong.wu@mediatek.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Orson Zhai <orsonzhai@gmail.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Chunyan Zhang <zhang.lyra@gmail.com>,
 Chen-Yu Tsai <wens@csie.org>, Jernej Skrabec <jernej.skrabec@gmail.com>,
 Samuel Holland <samuel@sholland.org>,
 Thierry Reding <thierry.reding@gmail.com>, Krishna Reddy
 <vdumpa@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
 asahi@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20230310-dma_iommu-v9-0-65bb8edd2beb@linux.ibm.com>
 <20230310-dma_iommu-v9-5-65bb8edd2beb@linux.ibm.com>
Content-Language: en-GB
In-Reply-To: <20230310-dma_iommu-v9-5-65bb8edd2beb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023-05-15 10:15, Niklas Schnelle wrote:
> In some virtualized environments, including s390 paged memory guests,
> IOTLB flushes are used to update IOMMU shadow tables. Due to this, they
> are much more expensive than in typical bare metal environments or
> non-paged s390 guests. In addition they may parallelize more poorly in
> virtualized environments. This changes the trade off for flushing IOVAs
> such that minimizing the number of IOTLB flushes trumps any benefit of
> cheaper queuing operations or increased paralellism.
> 
> In this scenario per-CPU flush queues pose several problems. Firstly
> per-CPU memory is often quite limited prohibiting larger queues.
> Secondly collecting IOVAs per-CPU but flushing via a global timeout
> reduces the number of IOVAs flushed for each timeout especially on s390
> where PCI interrupts may not be bound to a specific CPU.
> 
> Let's introduce a single flush queue mode that reuses the same queue
> logic but only allocates a single global queue. This mode can be
> selected as a flag bit in a new dma_iommu_options struct which can be
> modified from its defaults by IOMMU drivers implementing a new
> ops.tune_dma_iommu() callback. As a first user the s390 IOMMU driver
> selects the single queue mode if IOTLB flushes are needed on map which
> indicates shadow table use. With the unchanged small FQ size and
> timeouts this setting is worse than per-CPU queues but a follow up patch
> will make the FQ size and timeout variable. Together this allows the
> common IOVA flushing code to more closely resemble the global flush
> behavior used on s390's previous internal DMA API implementation.
> 
> Link: https://lore.kernel.org/linux-iommu/3e402947-61f9-b7e8-1414-fde006257b6f@arm.com/
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com> #s390
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
>   drivers/iommu/dma-iommu.c  | 163 ++++++++++++++++++++++++++++++++++-----------
>   drivers/iommu/dma-iommu.h  |   4 +-
>   drivers/iommu/iommu.c      |  18 +++--
>   drivers/iommu/s390-iommu.c |  10 +++
>   include/linux/iommu.h      |  21 ++++++
>   5 files changed, 169 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 7a9f0b0bddbd..be4cab6b4fe4 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -49,8 +49,11 @@ struct iommu_dma_cookie {
>   		/* Full allocator for IOMMU_DMA_IOVA_COOKIE */
>   		struct {
>   			struct iova_domain	iovad;
> -
> -			struct iova_fq __percpu *fq;	/* Flush queue */
> +			/* Flush queue */
> +			union {
> +				struct iova_fq	*single_fq;
> +				struct iova_fq	__percpu *percpu_fq;
> +			};
>   			/* Number of TLB flushes that have been started */
>   			atomic64_t		fq_flush_start_cnt;
>   			/* Number of TLB flushes that have been finished */
> @@ -67,6 +70,8 @@ struct iommu_dma_cookie {
>   
>   	/* Domain for flush queue callback; NULL if flush queue not in use */
>   	struct iommu_domain		*fq_domain;
> +	/* Options for dma-iommu use */
> +	struct dma_iommu_options	options;
>   	struct mutex			mutex;
>   };
>   
> @@ -152,25 +157,44 @@ static void fq_flush_iotlb(struct iommu_dma_cookie *cookie)
>   	atomic64_inc(&cookie->fq_flush_finish_cnt);
>   }
>   
> -static void fq_flush_timeout(struct timer_list *t)
> +static void fq_flush_percpu(struct iommu_dma_cookie *cookie)
>   {
> -	struct iommu_dma_cookie *cookie = from_timer(cookie, t, fq_timer);
>   	int cpu;
>   
> -	atomic_set(&cookie->fq_timer_on, 0);
> -	fq_flush_iotlb(cookie);
> -
>   	for_each_possible_cpu(cpu) {
>   		unsigned long flags;
>   		struct iova_fq *fq;
>   
> -		fq = per_cpu_ptr(cookie->fq, cpu);
> +		fq = per_cpu_ptr(cookie->percpu_fq, cpu);
>   		spin_lock_irqsave(&fq->lock, flags);
>   		fq_ring_free(cookie, fq);
>   		spin_unlock_irqrestore(&fq->lock, flags);
>   	}
>   }
>   
> +static void fq_flush_single(struct iommu_dma_cookie *cookie)
> +{
> +	struct iova_fq *fq = cookie->single_fq;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fq->lock, flags);
> +	fq_ring_free(cookie, fq);
> +	spin_unlock_irqrestore(&fq->lock, flags)

Nit: this should clearly just be a self-locked version of fq_ring_free() 
that takes fq as an argument, then both the new case and the existing 
loop body become trivial one-line calls.

> +}
> +
> +static void fq_flush_timeout(struct timer_list *t)
> +{
> +	struct iommu_dma_cookie *cookie = from_timer(cookie, t, fq_timer);
> +
> +	atomic_set(&cookie->fq_timer_on, 0);
> +	fq_flush_iotlb(cookie);
> +
> +	if (cookie->options.flags & IOMMU_DMA_OPTS_SINGLE_QUEUE)
> +		fq_flush_single(cookie);
> +	else
> +		fq_flush_percpu(cookie);
> +}
> +
>   static void queue_iova(struct iommu_dma_cookie *cookie,
>   		unsigned long pfn, unsigned long pages,
>   		struct list_head *freelist)
> @@ -188,7 +212,11 @@ static void queue_iova(struct iommu_dma_cookie *cookie,
>   	 */
>   	smp_mb();
>   
> -	fq = raw_cpu_ptr(cookie->fq);
> +	if (cookie->options.flags & IOMMU_DMA_OPTS_SINGLE_QUEUE)
> +		fq = cookie->single_fq;
> +	else
> +		fq = raw_cpu_ptr(cookie->percpu_fq);
> +
>   	spin_lock_irqsave(&fq->lock, flags);
>   
>   	/*
> @@ -219,58 +247,114 @@ static void queue_iova(struct iommu_dma_cookie *cookie,
>   			  jiffies + msecs_to_jiffies(IOVA_FQ_TIMEOUT));
>   }
>   
> -static void iommu_dma_free_fq(struct iommu_dma_cookie *cookie)
> +static void iommu_dma_free_fq_single(struct iova_fq *fq)
> +{
> +	int idx;
> +
> +	if (!fq)
> +		return;
> +	fq_ring_for_each(idx, fq)
> +		put_pages_list(&fq->entries[idx].freelist);
> +	vfree(fq);
> +}
> +
> +static void iommu_dma_free_fq_percpu(struct iova_fq __percpu *percpu_fq)
>   {
>   	int cpu, idx;
>   
> -	if (!cookie->fq)
> -		return;
> -
> -	del_timer_sync(&cookie->fq_timer);
>   	/* The IOVAs will be torn down separately, so just free our queued pages */
>   	for_each_possible_cpu(cpu) {
> -		struct iova_fq *fq = per_cpu_ptr(cookie->fq, cpu);
> +		struct iova_fq *fq = per_cpu_ptr(percpu_fq, cpu);
>   
>   		fq_ring_for_each(idx, fq)
>   			put_pages_list(&fq->entries[idx].freelist);
>   	}
>   
> -	free_percpu(cookie->fq);
> +	free_percpu(percpu_fq);
> +}
> +
> +static void iommu_dma_free_fq(struct iommu_dma_cookie *cookie)
> +{
> +	if (!cookie->fq_domain)
> +		return;
> +
> +	del_timer_sync(&cookie->fq_timer);
> +	if (cookie->options.flags & IOMMU_DMA_OPTS_SINGLE_QUEUE)
> +		iommu_dma_free_fq_single(cookie->single_fq);
> +	else
> +		iommu_dma_free_fq_percpu(cookie->percpu_fq);
> +}
> +
> +
> +static void iommu_dma_init_one_fq(struct iova_fq *fq)
> +{
> +	int i;
> +
> +	fq->head = 0;
> +	fq->tail = 0;
> +
> +	spin_lock_init(&fq->lock);
> +
> +	for (i = 0; i < IOVA_FQ_SIZE; i++)
> +		INIT_LIST_HEAD(&fq->entries[i].freelist);
> +}
> +
> +static int iommu_dma_init_fq_single(struct iommu_dma_cookie *cookie)
> +{
> +	struct iova_fq *queue;
> +
> +	queue = vzalloc(sizeof(*queue));
> +	if (!queue)
> +		return -ENOMEM;
> +	iommu_dma_init_one_fq(queue);
> +	cookie->single_fq = queue;
> +
> +	return 0;
> +}
> +
> +static int iommu_dma_init_fq_percpu(struct iommu_dma_cookie *cookie)
> +{
> +	struct iova_fq __percpu *queue;
> +	int cpu;
> +
> +	queue = alloc_percpu(struct iova_fq);
> +	if (!queue)
> +		return -ENOMEM;
> +
> +	for_each_possible_cpu(cpu)
> +		iommu_dma_init_one_fq(per_cpu_ptr(queue, cpu));
> +	cookie->percpu_fq = queue;
> +	return 0;
>   }
>   
>   /* sysfs updates are serialised by the mutex of the group owning @domain */
> -int iommu_dma_init_fq(struct iommu_domain *domain)
> +int iommu_dma_init_fq(struct device *dev, struct iommu_domain *domain)
>   {
>   	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> -	struct iova_fq __percpu *queue;
> -	int i, cpu;
> +	const struct iommu_ops *ops = dev_iommu_ops(dev);
> +	int rc;
>   
>   	if (cookie->fq_domain)
>   		return 0;
>   
> +	if (ops->tune_dma_iommu)
> +		ops->tune_dma_iommu(dev, &cookie->options);
> +
>   	atomic64_set(&cookie->fq_flush_start_cnt,  0);
>   	atomic64_set(&cookie->fq_flush_finish_cnt, 0);
>   
> -	queue = alloc_percpu(struct iova_fq);
> -	if (!queue) {
> +	if (cookie->options.flags & IOMMU_DMA_OPTS_SINGLE_QUEUE)
> +		rc = iommu_dma_init_fq_single(cookie);
> +	else
> +		rc = iommu_dma_init_fq_percpu(cookie);
> +
> +	if (rc) {
>   		pr_warn("iova flush queue initialization failed\n");
> -		return -ENOMEM;
> +		/* fall back to strict mode */
> +		domain->type = IOMMU_DOMAIN_DMA;

Why move this? It doesn't logically belong to FQ initialisation itself.

> +		return rc;
>   	}
>   
> -	for_each_possible_cpu(cpu) {
> -		struct iova_fq *fq = per_cpu_ptr(queue, cpu);
> -
> -		fq->head = 0;
> -		fq->tail = 0;
> -
> -		spin_lock_init(&fq->lock);
> -
> -		for (i = 0; i < IOVA_FQ_SIZE; i++)
> -			INIT_LIST_HEAD(&fq->entries[i].freelist);
> -	}
> -
> -	cookie->fq = queue;
> -
>   	timer_setup(&cookie->fq_timer, fq_flush_timeout, 0);
>   	atomic_set(&cookie->fq_timer_on, 0);
>   	/*
> @@ -297,6 +381,7 @@ static struct iommu_dma_cookie *cookie_alloc(enum iommu_dma_cookie_type type)
>   	if (cookie) {
>   		INIT_LIST_HEAD(&cookie->msi_page_list);
>   		cookie->type = type;
> +		cookie->options.flags = IOMMU_DMA_OPTS_PER_CPU_QUEUE;
>   	}
>   	return cookie;
>   }
> @@ -585,9 +670,9 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, dma_addr_t base,
>   	if (ret)
>   		goto done_unlock;
>   
> -	/* If the FQ fails we can simply fall back to strict mode */
> -	if (domain->type == IOMMU_DOMAIN_DMA_FQ && iommu_dma_init_fq(domain))
> -		domain->type = IOMMU_DOMAIN_DMA;
> +	/* If the FQ fails we fall back to strict mode */
> +	if (domain->type == IOMMU_DOMAIN_DMA_FQ)
> +		iommu_dma_init_fq(dev, domain);
>   
>   	ret = iova_reserve_iommu_regions(dev, domain);
>   
> diff --git a/drivers/iommu/dma-iommu.h b/drivers/iommu/dma-iommu.h
> index 942790009292..4f727ab56d3c 100644
> --- a/drivers/iommu/dma-iommu.h
> +++ b/drivers/iommu/dma-iommu.h
> @@ -12,7 +12,7 @@
>   int iommu_get_dma_cookie(struct iommu_domain *domain);
>   void iommu_put_dma_cookie(struct iommu_domain *domain);
>   
> -int iommu_dma_init_fq(struct iommu_domain *domain);
> +int iommu_dma_init_fq(struct device *dev, struct iommu_domain *domain);
>   
>   void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list);
>   
> @@ -20,7 +20,7 @@ extern bool iommu_dma_forcedac;
>   
>   #else /* CONFIG_IOMMU_DMA */
>   
> -static inline int iommu_dma_init_fq(struct iommu_domain *domain)
> +static inline int iommu_dma_init_fq(struct device *dev, struct iommu_domain *domain)
>   {
>   	return -EINVAL;
>   }
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 51f816367205..e2334ca480dd 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2967,10 +2967,19 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
>   		return -EINVAL;
>   
>   	mutex_lock(&group->mutex);
> +	/* Ensure that device exists. */
> +	if (list_empty(&group->devices)) {
> +		mutex_unlock(&group->mutex);
> +		return -EPERM;
> +	}
> +
> +	grp_dev = list_first_entry(&group->devices, struct group_device, list);
> +	dev = grp_dev->dev;
> +
>   	/* We can bring up a flush queue without tearing down the domain. */
>   	if (req_type == IOMMU_DOMAIN_DMA_FQ &&
>   	    group->default_domain->type == IOMMU_DOMAIN_DMA) {
> -		ret = iommu_dma_init_fq(group->default_domain);
> +		ret = iommu_dma_init_fq(dev, group->default_domain);
>   		if (!ret)
>   			group->default_domain->type = IOMMU_DOMAIN_DMA_FQ;
>   		mutex_unlock(&group->mutex);
> @@ -2978,15 +2987,12 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
>   		return ret ?: count;
>   	}
>   
> -	/* Otherwise, ensure that device exists and no driver is bound. */
> -	if (list_empty(&group->devices) || group->owner_cnt) {
> +	/* Otherwise, ensure that no driver is bound. */
> +	if (group->owner_cnt) {
>   		mutex_unlock(&group->mutex);
>   		return -EPERM;
>   	}
>   
> -	grp_dev = list_first_entry(&group->devices, struct group_device, list);
> -	dev = grp_dev->dev;
> -
>   	ret = iommu_change_dev_def_domain(group, dev, req_type);
>   
>   	/*
> diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
> index 161b0be5aba6..65dd469ad524 100644
> --- a/drivers/iommu/s390-iommu.c
> +++ b/drivers/iommu/s390-iommu.c
> @@ -451,6 +451,15 @@ static void s390_iommu_get_resv_regions(struct device *dev,
>   	}
>   }
>   
> +static void s390_iommu_tune_dma_iommu(struct device *dev,
> +					     struct dma_iommu_options *options)
> +{
> +	struct zpci_dev *zdev = to_zpci_dev(dev);
> +
> +	if (zdev->tlb_refresh)
> +		options->flags |= IOMMU_DMA_OPTS_SINGLE_QUEUE;
> +}
> +
>   static struct iommu_device *s390_iommu_probe_device(struct device *dev)
>   {
>   	struct zpci_dev *zdev;
> @@ -793,6 +802,7 @@ static const struct iommu_ops s390_iommu_ops = {
>   	.device_group = generic_device_group,
>   	.pgsize_bitmap = SZ_4K,
>   	.get_resv_regions = s390_iommu_get_resv_regions,
> +	.tune_dma_iommu = s390_iommu_tune_dma_iommu,
>   	.default_domain_ops = &(const struct iommu_domain_ops) {
>   		.attach_dev	= s390_iommu_attach_device,
>   		.map_pages	= s390_iommu_map_pages,
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 58891eddc2c4..3649a17256a5 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -219,6 +219,21 @@ struct iommu_iotlb_gather {
>   	bool			queued;
>   };
>   
> +/**
> + * struct dma_iommu_options - Options for dma-iommu
> + *
> + * @flags: Flag bits for enabling/disabling dma-iommu settings
> + *
> + * This structure is intended to provide IOMMU drivers a way to influence the
> + * behavior of the dma-iommu DMA API implementation. This allows optimizing for
> + * example for a virtualized environment with slow IOTLB flushes.
> + */
> +struct dma_iommu_options {
> +#define IOMMU_DMA_OPTS_PER_CPU_QUEUE	(0L << 0)
> +#define IOMMU_DMA_OPTS_SINGLE_QUEUE	(1L << 0)
> +	u64	flags;
> +};

I think for now this can just use a bit in dev_iommu to indicate that 
the device will prefer a global flush queue; s390 can set that in 
.probe_device, then iommu_dma_init_domain() can propagate it to an 
equivalent flag in the cookie (possibly even a new cookie type?) that 
iommu_dma_init_fq() can then consume. Then just make the s390 parameters 
from patch #6 the standard parameters for a global queue.

Thanks,
Robin.

> +
>   /**
>    * struct iommu_ops - iommu ops and capabilities
>    * @capable: check capability
> @@ -242,6 +257,9 @@ struct iommu_iotlb_gather {
>    *		- IOMMU_DOMAIN_IDENTITY: must use an identity domain
>    *		- IOMMU_DOMAIN_DMA: must use a dma domain
>    *		- 0: use the default setting
> + * @tune_dma_iommu: Allows the IOMMU driver to modify the default
> + *		    options of the dma-iommu layer for a specific
> + *		    device.
>    * @default_domain_ops: the default ops for domains
>    * @remove_dev_pasid: Remove any translation configurations of a specific
>    *                    pasid, so that any DMA transactions with this pasid
> @@ -278,6 +296,9 @@ struct iommu_ops {
>   	int (*def_domain_type)(struct device *dev);
>   	void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid);
>   
> +	void (*tune_dma_iommu)(struct device *dev,
> +			       struct dma_iommu_options *options);
> +
>   	const struct iommu_domain_ops *default_domain_ops;
>   	unsigned long pgsize_bitmap;
>   	struct module *owner;
> 

