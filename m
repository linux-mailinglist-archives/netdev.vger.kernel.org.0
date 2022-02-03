Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE0A4A9152
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 00:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356074AbiBCXxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 18:53:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58824 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiBCXxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 18:53:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA3CC618E8;
        Thu,  3 Feb 2022 23:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC84EC340E8;
        Thu,  3 Feb 2022 23:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643932434;
        bh=tIBMDUl1KSV62Vg/VFyfqCLarqutkx/5NsVZllWQuIU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IIrLpytIhS33bMp6wD+kg5PysYuMemf04OOa2Lj1gpIMvmPHN1gxyLy1K7HLqJclZ
         c7l3vnEM9Jvc548pHw4nJ3lEO09bchMEB/ZLKPWnTCXwzz0iYkvXvgzDwBB9jqgS/f
         4WG+uTqDKvHAAi8AMh65/hh8PLifsBBX5Sg0WlFQdM6Oqlp9vA60RtDWgWzjQrTPiW
         OXz6dMSeWYbhgRqKfFdPC5GmQonZHLnPVry4ki9FY2iDTTK/DdtbCyWEPE/Nqa7csX
         CFI/COWjUi8SSQ0MM7Xeo4mcBueW81k4CinnEituMznCNOifCfE3L2MJEtJ68kkNGr
         FbovxEEWAEGuw==
Date:   Thu, 3 Feb 2022 15:53:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, davem@davemloft.net,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, Tianyu.Lan@microsoft.com,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, hch@lst.de, joro@8bytes.org,
        parri.andrea@gmail.com, dave.hansen@intel.com
Subject: Re: [PATCH V7 4/5] scsi: storvsc: Add Isolation VM support for
 storvsc driver
Message-ID: <20220203155351.2ca86ab3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211213071407.314309-5-ltykernel@gmail.com>
References: <20211213071407.314309-1-ltykernel@gmail.com>
        <20211213071407.314309-5-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Dec 2021 02:14:05 -0500 Tianyu Lan wrote:
> @@ -2078,6 +2079,7 @@ struct hv_device *vmbus_device_create(const guid_t *type,
>  	return child_device_obj;
>  }
>  
> +static u64 vmbus_dma_mask = DMA_BIT_MASK(64);

This breaks the x86 clang allmodconfig build as I presume those
involved know by now:

../drivers/hv/vmbus_drv.c:2082:29: error: shift count >= width of type [-Werror,-Wshift-count-overflow]
static u64 vmbus_dma_mask = DMA_BIT_MASK(64);
                            ^~~~~~~~~~~~~~~~
../include/linux/dma-mapping.h:76:54: note: expanded from macro 'DMA_BIT_MASK'
#define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
                                                     ^ ~~~
1 error generated.


Is there any ETA on getting the fix into Linus's tree?
