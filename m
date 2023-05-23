Return-Path: <netdev+bounces-4665-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2070070DC49
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F206281351
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5374C4A878;
	Tue, 23 May 2023 12:16:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427204A872
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 12:16:54 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BE02109;
	Tue, 23 May 2023 05:16:52 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 103DA139F;
	Tue, 23 May 2023 05:17:37 -0700 (PDT)
Received: from [10.57.84.70] (unknown [10.57.84.70])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2138E3F6C4;
	Tue, 23 May 2023 05:16:44 -0700 (PDT)
Message-ID: <b3fef8c7-29d2-e1d3-09c9-7bb97510faf0@arm.com>
Date: Tue, 23 May 2023 13:16:40 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v9 5/6] iommu/dma: Allow a single FQ in addition to
 per-CPU FQs
Content-Language: en-GB
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
 <b1e53f39-5e0b-a09d-2954-cdc9e8592b67@arm.com>
 <0d9e3f86cf9a1a3d69e650fb631809498c2cd01e.camel@linux.ibm.com>
From: Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <0d9e3f86cf9a1a3d69e650fb631809498c2cd01e.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023-05-23 13:02, Niklas Schnelle wrote:
[...]
>>> +static void fq_flush_single(struct iommu_dma_cookie *cookie)
>>> +{
>>> +	struct iova_fq *fq = cookie->single_fq;
>>> +	unsigned long flags;
>>> +
>>> +	spin_lock_irqsave(&fq->lock, flags);
>>> +	fq_ring_free(cookie, fq);
>>> +	spin_unlock_irqrestore(&fq->lock, flags)
>>
>> Nit: this should clearly just be a self-locked version of fq_ring_free()
>> that takes fq as an argument, then both the new case and the existing
>> loop body become trivial one-line calls.
> 
> Sure will do. Just one question about names. As an example
> pci_reset_function_locked() means that the relevant lock is already
> taken with pci_reset_function() adding the lock/unlock. In your wording
> the implied function names sound the other way around. I can't find
> anything similar in drivers/iommu so would you mind going the PCI way
> and having:
> 
> fq_ring_free_locked(): Called in queue_iova() with the lock held
> fr_ring_free(): Called in fq_flush_timeout() takes the lock itself
> 
> Or maybe I'm just biased because I've used the PCI ..locked() functions
> before and there is a better convention.

Yes, that's the form that's most familiar to me too - sorry I failed to 
express it clearly :)

Thanks,
Robin.

