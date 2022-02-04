Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248BE4A927E
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 03:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356685AbiBDCzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 21:55:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60200 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiBDCzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 21:55:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65118B83644;
        Fri,  4 Feb 2022 02:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44D7C340E8;
        Fri,  4 Feb 2022 02:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643943342;
        bh=iFYVFJtjKaIbefdHLdpYqegeVUxQnXuKEpN+3Ch3AIA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dr8qqzYPKFmFJByEK9kO6IpaCaW2bVgGDR5hk16oTTfhfGHTPoaUlr0Z2MKd2sbTW
         zaBeSYK9ycn8fgB8Z8a180clQI9z3bWiKTyHJhz4+uhbMlXyYPkQ4gEZlM5x2szmk9
         drlBO+BE2DeRlnscsGLbH1vqAVjlD+6vzU9SH+ZhT+9yMwvcf2RZMhgUp8rROy9esK
         fJ6SOOMLfaSTdMLABEptYk/mhdKEpf2zEhxhW9QheMEtRF05JB35AR4DPFkp+3Vhjs
         oKHraGBRsNPAWo3JoZptsYDhK+33ru8rNbOXGNRVZ7eKuQ8HsBo0gz5X+iM6m0+PUX
         Vn9EA39y6g5cg==
Date:   Thu, 3 Feb 2022 18:55:39 -0800
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
Message-ID: <20220203185539.3b70a6b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220203155351.2ca86ab3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211213071407.314309-1-ltykernel@gmail.com>
        <20211213071407.314309-5-ltykernel@gmail.com>
        <20220203155351.2ca86ab3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 15:53:51 -0800 Jakub Kicinski wrote:
> On Mon, 13 Dec 2021 02:14:05 -0500 Tianyu Lan wrote:
> > @@ -2078,6 +2079,7 @@ struct hv_device *vmbus_device_create(const guid_t *type,
> >  	return child_device_obj;
> >  }
> >  
> > +static u64 vmbus_dma_mask = DMA_BIT_MASK(64);  
> 
> This breaks the x86 clang allmodconfig build as I presume those
> involved know by now:
> 
> ../drivers/hv/vmbus_drv.c:2082:29: error: shift count >= width of type [-Werror,-Wshift-count-overflow]
> static u64 vmbus_dma_mask = DMA_BIT_MASK(64);
>                             ^~~~~~~~~~~~~~~~
> ../include/linux/dma-mapping.h:76:54: note: expanded from macro 'DMA_BIT_MASK'
> #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
>                                                      ^ ~~~
> 1 error generated.

Looks like a compiler issue actually, found the discussion now:

https://lore.kernel.org/llvm/202112181827.o3X7GmHz-lkp@intel.com/
