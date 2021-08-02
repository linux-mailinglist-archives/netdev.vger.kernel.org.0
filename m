Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845393DD62A
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 14:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhHBM6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 08:58:43 -0400
Received: from 8bytes.org ([81.169.241.247]:52982 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232629AbhHBM6m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 08:58:42 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 9AD29379; Mon,  2 Aug 2021 14:58:30 +0200 (CEST)
Date:   Mon, 2 Aug 2021 14:58:26 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, rientjes@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        rppt@kernel.org, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.ibm.com, krish.sadhukhan@oracle.com,
        saravanand@fb.com, xen-devel@lists.xenproject.org,
        pgonda@google.com, david@redhat.com, keescook@chromium.org,
        hannes@cmpxchg.org, sfr@canb.auug.org.au,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, anparri@microsoft.com
Subject: Re: [PATCH 07/13] HV/Vmbus: Add SNP support for VMbus channel
 initiate message
Message-ID: <YQfr8lsaghth8Zix@8bytes.org>
References: <20210728145232.285861-1-ltykernel@gmail.com>
 <20210728145232.285861-8-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728145232.285861-8-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 10:52:22AM -0400, Tianyu Lan wrote:
> +	if (hv_is_isolation_supported()) {
> +		vmbus_connection.monitor_pages_va[0]
> +			= vmbus_connection.monitor_pages[0];
> +		vmbus_connection.monitor_pages[0]
> +			= memremap(msg->monitor_page1, HV_HYP_PAGE_SIZE,
> +				   MEMREMAP_WB);
> +		if (!vmbus_connection.monitor_pages[0])
> +			return -ENOMEM;
> +
> +		vmbus_connection.monitor_pages_va[1]
> +			= vmbus_connection.monitor_pages[1];
> +		vmbus_connection.monitor_pages[1]
> +			= memremap(msg->monitor_page2, HV_HYP_PAGE_SIZE,
> +				   MEMREMAP_WB);
> +		if (!vmbus_connection.monitor_pages[1]) {
> +			memunmap(vmbus_connection.monitor_pages[0]);
> +			return -ENOMEM;
> +		}
> +
> +		memset(vmbus_connection.monitor_pages[0], 0x00,
> +		       HV_HYP_PAGE_SIZE);
> +		memset(vmbus_connection.monitor_pages[1], 0x00,
> +		       HV_HYP_PAGE_SIZE);
> +	}

Okay, let me see if I got this right. In Hyper-V Isolation VMs, when the
guest wants to make memory shared, it does":

	- Call to the Hypervisor the mark the pages shared. The
	  Hypervisor will do the RMP update and remap the pages at
	  (VTOM + pa)

	- The guest maps the memory again into its page-table, so that
	  the entries point to the correct GPA (which is above VTOM
	  now).

Or in other words, Hyper-V implements a hardware-independent and
configurable c-bit position, as the VTOM value is always power-of-two
aligned. Is that correct?
This would at least explain why there is no separate
allocation/dealloction of memory for the shared range.

Thanks,

	Joerg
