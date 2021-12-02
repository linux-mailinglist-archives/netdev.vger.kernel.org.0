Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF61146659B
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 15:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358730AbhLBOrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 09:47:12 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:42829 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355560AbhLBOrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 09:47:09 -0500
Received: by mail-wm1-f54.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so3765061wmd.1;
        Thu, 02 Dec 2021 06:43:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ngfxfU8cMx05IJ2GEXLujweygC6BKjS+/TEJnexPuyU=;
        b=53me9CCfi7lSoK0NGLHG2Hu6InbddQKhkYkvj6gB84OZTy6t+tIb7TfogeaKc2Wh9q
         /aL5jN7i4wRIl8ypTzLw9u2Tnu6Vt+PtRZDmQ2FDDyx/Ub46YqeOB/DhiyiCtwQ2xNSf
         EDLHmZq/ebeqT64qcWx/1wAPbcW3mzYusdduV2IQSveQm0Jw0IAc45qHM9WF/TEO2OZ8
         e9kUTOHV4X0IWBHZXqjzMBWjFMaiKPoqHUUxrJvxhUqVCn4+s9lTrNp4CUFqXLgFrWVd
         xKqU/RJWqXAK+i+UpHyri6JXT9AzLew3w/VDIXcicNDFTfyvW2aiwOfJokU3ADitFbV+
         bdaw==
X-Gm-Message-State: AOAM532dTx7PQEz+KNxHCXSws12WW7O76VfkqngeKW9xFNuDCnv+AFCl
        4ifMrAjG94vxyNmGi4dtwXU=
X-Google-Smtp-Source: ABdhPJzcC/sLI+YXsme26UERQHG8ONsijhz0w3mw0YtYq520oHvctN0qsFmSNBM5FNo5EKfA2KQfgA==
X-Received: by 2002:a1c:ed18:: with SMTP id l24mr7167526wmh.99.1638456219030;
        Thu, 02 Dec 2021 06:43:39 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id b15sm3831942wri.62.2021.12.02.06.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 06:43:38 -0800 (PST)
Date:   Thu, 2 Dec 2021 14:43:36 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jgross@suse.com,
        sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        joro@8bytes.org, will@kernel.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, hch@lst.de, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: Re: [PATCH V3 3/5] hyperv/IOMMU: Enable swiotlb bounce buffer for
 Isolation VM
Message-ID: <20211202144336.z2sfs6kw5kdsfqgv@liuwe-devbox-debian-v2>
References: <20211201160257.1003912-1-ltykernel@gmail.com>
 <20211201160257.1003912-4-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201160257.1003912-4-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 11:02:54AM -0500, Tianyu Lan wrote:
[...]
> diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
> index 46df59aeaa06..30fd0600b008 100644
> --- a/arch/x86/xen/pci-swiotlb-xen.c
> +++ b/arch/x86/xen/pci-swiotlb-xen.c
> @@ -4,6 +4,7 @@
>  
>  #include <linux/dma-map-ops.h>
>  #include <linux/pci.h>
> +#include <linux/hyperv.h>
>  #include <xen/swiotlb-xen.h>
>  
>  #include <asm/xen/hypervisor.h>
> @@ -91,6 +92,6 @@ int pci_xen_swiotlb_init_late(void)
>  EXPORT_SYMBOL_GPL(pci_xen_swiotlb_init_late);
>  
>  IOMMU_INIT_FINISH(pci_xen_swiotlb_detect,
> -		  NULL,
> +		  hyperv_swiotlb_detect,

It is not immediately obvious why this is needed just by reading the
code. Please consider copying some of the text in the commit message to
a comment here.

Thanks,
Wei.
