Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870B5674B6D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjATEyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjATExr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:53:47 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA3BCE8A2;
        Thu, 19 Jan 2023 20:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674189914; x=1705725914;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DuOBg1V/kEEpNk+BV4bYqVrWJSOOFRR3sdWDamFrvt0=;
  b=DpH5Gz6m8iV2ch09fwLFA5GAnqlxbeNoa7S3bI/YFsVgN87LhKKoHb0Q
   cSCYdT3KmY8GtvjtNyqfoyZjFlZdvPRAzezNcOKx6+isXeCmUB45fV3DF
   026+DbQtNrLVHraaQW0P2BkA1avJfJCRa80U8itPz7XQ3IEFFPIYbClxs
   28pG13X7QphCrYMsq60VrkQyCLoGnlbwbBVjTPl45e3wWdRgqLxggzixe
   SAA5swOR1eMGWiVdWM7YFfhsxGvQQy2A0iZNyMvQ//2lqzy3XrGkXktPN
   QJ1loYld9EDGI/1Qb4zzbto8KYzzKZkmUqKFZsbc6A6sRmm5zTKHoGxD2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="308821076"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="308821076"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 03:47:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="988957189"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="988957189"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.185.248]) ([10.252.185.248])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 03:47:45 -0800
Message-ID: <08c874f6-0c59-0b74-a2c8-7ad61356af6f@linux.intel.com>
Date:   Thu, 19 Jan 2023 19:47:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Cc:     baolu.lu@linux.intel.com,
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
Subject: Re: [PATCH v2 06/10] iommu/intel: Add a gfp parameter to
 alloc_pgtable_page()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <6-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <6-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/1/19 2:00, Jason Gunthorpe wrote:
> This is eventually called by iommufd through intel_iommu_map_pages() and
> it should not be forced to atomic. Push the GFP_ATOMIC to all callers.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu
