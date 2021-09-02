Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856243FEA3D
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 09:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243653AbhIBHwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 03:52:37 -0400
Received: from verein.lst.de ([213.95.11.211]:50373 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233360AbhIBHwg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 03:52:36 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A78796736F; Thu,  2 Sep 2021 09:51:31 +0200 (CEST)
Date:   Thu, 2 Sep 2021 09:51:31 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, catalin.marinas@arm.com, will@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        gregkh@linuxfoundation.org, arnd@arndb.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        brijesh.singh@amd.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, aneesh.kumar@linux.ibm.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        ardb@kernel.org, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: Re: [PATCH V4 00/13] x86/Hyper-V: Add Hyper-V Isolation VM support
Message-ID: <20210902075131.GA14986@lst.de>
References: <20210827172114.414281-1-ltykernel@gmail.com> <20210830120036.GA22005@lst.de> <91b5e997-8d44-77f0-6519-f574b541ba9f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b5e997-8d44-77f0-6519-f574b541ba9f@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 11:20:06PM +0800, Tianyu Lan wrote:
>> If so I suspect the best way to allocate them is by not using vmalloc
>> but just discontiguous pages, and then use kmap_local_pfn where the
>> PFN includes the share_gpa offset when actually copying from/to the
>> skbs.
>>
> When netvsc needs to copy packet data to send buffer, it needs to caculate 
> position with section_index and send_section_size.
> Please seee netvsc_copy_to_send_buf() detail. So the contiguous virtual 
> address of send buffer is necessary to copy data and batch packets.

Actually that makes the kmap approach much easier.  The phys_to_virt
can just be replaced with a kmap_local_pfn and the unmap needs to
be added.  I've been mostly focussing on the receive path, which
would need a similar treatment.
