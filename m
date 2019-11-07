Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52D67F255F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 03:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733036AbfKGC0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 21:26:51 -0500
Received: from mga18.intel.com ([134.134.136.126]:62496 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbfKGC0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 21:26:50 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 18:26:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,276,1569308400"; 
   d="scan'208";a="227685256"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by fmsmga004.fm.intel.com with ESMTP; 06 Nov 2019 18:26:48 -0800
Date:   Wed, 6 Nov 2019 18:26:48 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
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
Subject: Re: [PATCH v2 07/18] infiniband: set FOLL_PIN, FOLL_LONGTERM via
 pin_longterm_pages*()
Message-ID: <20191107022647.GC32084@iweiny-DESK2.sc.intel.com>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-8-jhubbard@nvidia.com>
 <20191104203346.GF30938@ziepe.ca>
 <578c1760-7221-4961-9f7d-c07c22e5c259@nvidia.com>
 <20191104205738.GH30938@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104205738.GH30938@ziepe.ca>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 04:57:38PM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 04, 2019 at 12:48:13PM -0800, John Hubbard wrote:
> > On 11/4/19 12:33 PM, Jason Gunthorpe wrote:
> > ...
> > >> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> > >> index 24244a2f68cc..c5a78d3e674b 100644
> > >> +++ b/drivers/infiniband/core/umem.c
> > >> @@ -272,11 +272,10 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,
> > >>  
> > >>  	while (npages) {
> > >>  		down_read(&mm->mmap_sem);
> > >> -		ret = get_user_pages(cur_base,
> > >> +		ret = pin_longterm_pages(cur_base,
> > >>  				     min_t(unsigned long, npages,
> > >>  					   PAGE_SIZE / sizeof (struct page *)),
> > >> -				     gup_flags | FOLL_LONGTERM,
> > >> -				     page_list, NULL);
> > >> +				     gup_flags, page_list, NULL);
> > > 
> > > FWIW, this one should be converted to fast as well, I think we finally
> > > got rid of all the blockers for that?
> > > 
> > 
> > I'm not aware of any blockers on the gup.c end, anyway. The only broken thing we
> > have there is "gup remote + FOLL_LONGTERM". But we can do "gup fast + LONGTERM". 
> 
> I mean the use of the mmap_sem here is finally in a way where we can
> just delete the mmap_sem and use _fast

Yay!  I agree if we can do this we should.

Thanks,
Ira

>  
> ie, AFAIK there is no need for the mmap_sem to be held during
> ib_umem_add_sg_table()
> 
> This should probably be a standalone patch however
> 
> Jason
