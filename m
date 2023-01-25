Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B8267B075
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbjAYK7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbjAYK7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:59:33 -0500
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0343839B95;
        Wed, 25 Jan 2023 02:59:30 -0800 (PST)
Received: from 8bytes.org (p200300c27714bc0086ad4f9d2505dd0d.dip0.t-ipconnect.de [IPv6:2003:c2:7714:bc00:86ad:4f9d:2505:dd0d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id EA1A7262E65;
        Wed, 25 Jan 2023 11:59:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1674644369;
        bh=T38KYBmqOO/YysbFxidRcHI2EqxeKT2mSwZbXhYqf1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xjLIYBe2Reb4sUbyDIO/QWp7US6P8C31V+nRPiKC12bUvIf7ZM2sEz6rexMly82MG
         SdqC2ipNyx624847dznAPsTr5JegX+avBcrYfRuhpCCtUCj00j5UMMKFv2s5yqcp78
         M0y7wdWzVXQ3svUwvlcuJMoxQJuspChvYRhYbBD4VgYfSxytDzzifVhHBhI3LbACxs
         T3fe0NZnfc4OI4+mzTVEq4TCO9vBUsWz4/KYFySgVFLjFM48o+FEL/Pas2FYAxM+s5
         h6WCzD311EPYK4UyWDMAMAz7XrOhVE163Ksfw3L/LtMiYeejlNUntipX85M2JSVOt+
         8KBgiGtflHGcg==
Date:   Wed, 25 Jan 2023 11:59:27 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-tegra@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nouveau@lists.freedesktop.org,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 00/10] Let iommufd charge IOPTE allocations to the
 memory cgroup
Message-ID: <Y9ELj1yKsE58mlgi@8bytes.org>
References: <0-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-76b587fe28df+6e3-iommu_map_gfp_jgg@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 04:35:53PM -0400, Jason Gunthorpe wrote:
> Jason Gunthorpe (10):
>   iommu: Add a gfp parameter to iommu_map()
>   iommu: Remove iommu_map_atomic()
>   iommu: Add a gfp parameter to iommu_map_sg()
>   iommu/dma: Use the gfp parameter in __iommu_dma_alloc_noncontiguous()
>   iommufd: Use GFP_KERNEL_ACCOUNT for iommu_map()
>   iommu/intel: Add a gfp parameter to alloc_pgtable_page()
>   iommu/intel: Support the gfp argument to the map_pages op
>   iommu/intel: Use GFP_KERNEL in sleepable contexts
>   iommu/s390: Push the gfp parameter to the kmem_cache_alloc()'s
>   iommu/s390: Use GFP_KERNEL in sleepable contexts

Merged into branch iommu-memory-accounting and merged that branch into
core.

The merge commit contains your cover-letter descriptions. Given all
tests pass I will push it out later today.

Regards,

	Joerg
