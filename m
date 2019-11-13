Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0E6FB8A1
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfKMTRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:17:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:15422 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfKMTRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 14:17:09 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 11:17:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,301,1569308400"; 
   d="scan'208";a="379324206"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by orsmga005.jf.intel.com with ESMTP; 13 Nov 2019 11:17:06 -0800
Date:   Wed, 13 Nov 2019 11:17:06 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 08/23] vfio, mm: fix get_user_pages_remote() and
 FOLL_LONGTERM
Message-ID: <20191113191705.GE12947@iweiny-DESK2.sc.intel.com>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
 <20191113042710.3997854-9-jhubbard@nvidia.com>
 <20191113130202.GA26068@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113130202.GA26068@ziepe.ca>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 09:02:02AM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 12, 2019 at 08:26:55PM -0800, John Hubbard wrote:
> > As it says in the updated comment in gup.c: current FOLL_LONGTERM
> > behavior is incompatible with FAULT_FLAG_ALLOW_RETRY because of the
> > FS DAX check requirement on vmas.
> > 
> > However, the corresponding restriction in get_user_pages_remote() was
> > slightly stricter than is actually required: it forbade all
> > FOLL_LONGTERM callers, but we can actually allow FOLL_LONGTERM callers
> > that do not set the "locked" arg.
> > 
> > Update the code and comments accordingly, and update the VFIO caller
> > to take advantage of this, fixing a bug as a result: the VFIO caller
> > is logically a FOLL_LONGTERM user.
> > 
> > Also, remove an unnessary pair of calls that were releasing and
> > reacquiring the mmap_sem. There is no need to avoid holding mmap_sem
> > just in order to call page_to_pfn().
> > 
> > Also, move the DAX check ("if a VMA is DAX, don't allow long term
> > pinning") from the VFIO call site, all the way into the internals
> > of get_user_pages_remote() and __gup_longterm_locked(). That is:
> > get_user_pages_remote() calls __gup_longterm_locked(), which in turn
> > calls check_dax_vmas(). It's lightly explained in the comments as well.
> > 
> > Thanks to Jason Gunthorpe for pointing out a clean way to fix this,
> > and to Dan Williams for helping clarify the DAX refactoring.
> > 
> > Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Jerome Glisse <jglisse@redhat.com>
> > Cc: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> >  drivers/vfio/vfio_iommu_type1.c | 25 ++-----------------------
> >  mm/gup.c                        | 27 ++++++++++++++++++++++-----
> >  2 files changed, 24 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index d864277ea16f..7301b710c9a4 100644
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -340,7 +340,6 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
> >  {
> >  	struct page *page[1];
> >  	struct vm_area_struct *vma;
> > -	struct vm_area_struct *vmas[1];
> >  	unsigned int flags = 0;
> >  	int ret;
> >  
> > @@ -348,33 +347,13 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
> >  		flags |= FOLL_WRITE;
> >  
> >  	down_read(&mm->mmap_sem);
> > -	if (mm == current->mm) {
> > -		ret = get_user_pages(vaddr, 1, flags | FOLL_LONGTERM, page,
> > -				     vmas);
> > -	} else {
> > -		ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags, page,
> > -					    vmas, NULL);
> > -		/*
> > -		 * The lifetime of a vaddr_get_pfn() page pin is
> > -		 * userspace-controlled. In the fs-dax case this could
> > -		 * lead to indefinite stalls in filesystem operations.
> > -		 * Disallow attempts to pin fs-dax pages via this
> > -		 * interface.
> > -		 */
> > -		if (ret > 0 && vma_is_fsdax(vmas[0])) {
> > -			ret = -EOPNOTSUPP;
> > -			put_page(page[0]);
> > -		}
> > -	}
> > -	up_read(&mm->mmap_sem);
> > -
> > +	ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
> > +				    page, NULL, NULL);
> >  	if (ret == 1) {
> >  		*pfn = page_to_pfn(page[0]);
> >  		return 0;
> 
> Mind the return with the lock held this needs some goto unwind

Ah yea...  retract my reviewed by...  :-(

Ira

