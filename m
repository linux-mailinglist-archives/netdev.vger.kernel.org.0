Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0FB9859E7
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 07:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731038AbfHHFmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 01:42:46 -0400
Received: from ozlabs.org ([203.11.71.1]:56463 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfHHFmp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 01:42:45 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 463y252c4Xz9sN1;
        Thu,  8 Aug 2019 15:42:37 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?utf-8?B?SsOpcsO0?= =?utf-8?B?bWU=?= Glisse 
        <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, devel@lists.orangefs.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        sparclinux@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christoph Hellwig <hch@lst.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 38/41] powerpc: convert put_page() to put_user_page*()
In-Reply-To: <20190807013340.9706-39-jhubbard@nvidia.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com> <20190807013340.9706-39-jhubbard@nvidia.com>
Date:   Thu, 08 Aug 2019 15:42:34 +1000
Message-ID: <87k1botdpx.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

john.hubbard@gmail.com writes:
> diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s64/iommu_api.c
> index b056cae3388b..e126193ba295 100644
> --- a/arch/powerpc/mm/book3s64/iommu_api.c
> +++ b/arch/powerpc/mm/book3s64/iommu_api.c
> @@ -203,6 +202,7 @@ static void mm_iommu_unpin(struct mm_iommu_table_group_mem_t *mem)
>  {
>  	long i;
>  	struct page *page = NULL;
> +	bool dirty = false;

I don't think you need that initialisation do you?

>  	if (!mem->hpas)
>  		return;
> @@ -215,10 +215,9 @@ static void mm_iommu_unpin(struct mm_iommu_table_group_mem_t *mem)
>  		if (!page)
>  			continue;
>  
> -		if (mem->hpas[i] & MM_IOMMU_TABLE_GROUP_PAGE_DIRTY)
> -			SetPageDirty(page);
> +		dirty = mem->hpas[i] & MM_IOMMU_TABLE_GROUP_PAGE_DIRTY;
> -		put_page(page);
> +		put_user_pages_dirty_lock(&page, 1, dirty);
>  		mem->hpas[i] = 0;
>  	}
>  }

cheers
