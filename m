Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90FB8EB8BD
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 22:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbfJaVJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 17:09:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:43170 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727957AbfJaVJ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 17:09:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 14:09:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,253,1569308400"; 
   d="scan'208";a="375376881"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by orsmga005.jf.intel.com with ESMTP; 31 Oct 2019 14:09:55 -0700
Date:   Thu, 31 Oct 2019 14:09:55 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
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
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH 02/19] mm/gup: factor out duplicate code from four
 routines
Message-ID: <20191031210954.GE14771@iweiny-DESK2.sc.intel.com>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
 <20191030224930.3990755-3-jhubbard@nvidia.com>
 <20191031183549.GC14771@iweiny-DESK2.sc.intel.com>
 <75b557f7-24b2-740c-2640-2f914d131600@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75b557f7-24b2-740c-2640-2f914d131600@nvidia.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 11:43:37AM -0700, John Hubbard wrote:
> On 10/31/19 11:35 AM, Ira Weiny wrote:
> > On Wed, Oct 30, 2019 at 03:49:13PM -0700, John Hubbard wrote:
> ...
> >> +
> >> +static void __remove_refs_from_head(struct page *page, int refs)
> >> +{
> >> +	/* Do a get_page() first, in case refs == page->_refcount */
> >> +	get_page(page);
> >> +	page_ref_sub(page, refs);
> >> +	put_page(page);
> >> +}
> > 
> > I wonder if this is better implemented as "put_compound_head()"?  To match the
> > try_get_compound_head() call below?
> 
> Hi Ira,
> 
> Good idea, I'll rename it to that.
> 
> > 
> >> +
> >> +static int __huge_pt_done(struct page *head, int nr_recorded_pages, int *nr)
> >> +{
> >> +	*nr += nr_recorded_pages;
> >> +	SetPageReferenced(head);
> >> +	return 1;
> > 
> > When will this return anything but 1?
> > 
> 
> Never, but it saves a line at all four call sites, by having it return like that.
> 
> I could see how maybe people would prefer to just have it be a void function,
> and return 1 directly at the call sites. Since this was a lower line count I
> thought maybe it would be slightly better, but it's hard to say really.

It is a NIT perhaps but I feel like the signature of a function should stand on
it's own.  What this does is mix the meaning of this function with those
calling it.  Which IMO is not good style.

We can see what others say.

Ira

> 
> thanks,
> 
> John Hubbard
> NVIDIA
> 
