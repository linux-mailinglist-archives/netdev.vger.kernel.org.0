Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1AF56737B7
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjASL7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjASL7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:59:40 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9F630F6;
        Thu, 19 Jan 2023 03:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674129579; x=1705665579;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5iljU3ubicNtm4iB5o/W1SF+gNSsJnJBGq8FDgyaBeE=;
  b=nyBQzx/7hPPaIuyVULYmDaVpB8M6VrlCYsttgbfYd94fwm6PbPUgRBRG
   pznr5Nb0K7Uxd01M2kRl8AcJ5Xwxfev1cZyV2EQXMPNE22lGrmzjBZt5J
   /dow7zx4QNK/vu8MazONny6gNshRKbx1ssw7q/Qiky5v10jyuqRKc7D5g
   QLJgXmS0ksg6tC7L0a25MFn6mH3Qp2+CccHBBczwp53RhiKfSlZoE88JF
   neAZF2u+u2vsDqMwzYTQy+k97OzBE8oNi4iZlhEHA6dH91Am5ZuiaycnU
   hALqroSsJqZHgHNC/oTjjBlNJeIvs7qqD+v848iQ9iltFhFfmouzI/9Tp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="352522345"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="352522345"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 03:59:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="833967799"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="833967799"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.185.248]) ([10.252.185.248])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 03:59:31 -0800
Message-ID: <54887e93-22a1-496a-838c-ad6a8b4a830f@linux.intel.com>
Date:   Thu, 19 Jan 2023 19:59:28 +0800
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
Subject: Re: [PATCH v2 07/10] iommu/intel: Support the gfp argument to the
 map_pages op
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <7-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
 <e44077a7-e275-4e34-b7ad-3e1382ea974d@linux.intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <e44077a7-e275-4e34-b7ad-3e1382ea974d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/1/19 19:57, Baolu Lu wrote:
> On 2023/1/19 2:00, Jason Gunthorpe wrote:
>> Flow it down to alloc_pgtable_page() via pfn_to_dma_pte() and
>> __domain_mapping().
>>
>> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> 
> Irrelevant to this patch, GFP_ATOMIC could be changed to GFP_KERNEL in
> some places. I will follow up further to clean it up.

It has been done in the next patch. Sorry for the noise.

Best regards,
baolu
