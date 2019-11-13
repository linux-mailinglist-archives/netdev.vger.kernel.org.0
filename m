Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C34FB796
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 19:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbfKMSbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 13:31:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:57372 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbfKMSbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 13:31:41 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 10:31:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,301,1569308400"; 
   d="scan'208";a="355555407"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by orsmga004.jf.intel.com with ESMTP; 13 Nov 2019 10:31:38 -0800
Date:   Wed, 13 Nov 2019 10:31:38 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Jan Kara <jack@suse.cz>
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
        "David S . Miller" <davem@davemloft.net>,
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
        Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v4 09/23] mm/gup: introduce pin_user_pages*() and FOLL_PIN
Message-ID: <20191113183137.GA12699@iweiny-DESK2.sc.intel.com>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
 <20191113042710.3997854-10-jhubbard@nvidia.com>
 <20191113104308.GE6367@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113104308.GE6367@quack2.suse.cz>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +/**
> > + * pin_user_pages_fast() - pin user pages in memory without taking locks
> > + *
> > + * Nearly the same as get_user_pages_fast(), except that FOLL_PIN is set. See
> > + * get_user_pages_fast() for documentation on the function arguments, because
> > + * the arguments here are identical.
> > + *
> > + * FOLL_PIN means that the pages must be released via put_user_page(). Please
> > + * see Documentation/vm/pin_user_pages.rst for further details.
> > + *
> > + * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rst. It
> > + * is NOT intended for Case 2 (RDMA: long-term pins).
> > + */
> > +int pin_user_pages_fast(unsigned long start, int nr_pages,
> > +			unsigned int gup_flags, struct page **pages)
> > +{
> > +	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
> > +	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
> > +		return -EINVAL;
> > +
> > +	gup_flags |= FOLL_PIN;
> > +	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
> > +}
> > +EXPORT_SYMBOL_GPL(pin_user_pages_fast);
> 
> I was somewhat wondering about the number of functions you add here. So we
> have:
> 
> pin_user_pages()
> pin_user_pages_fast()
> pin_user_pages_remote()
> 
> and then longterm variants:
> 
> pin_longterm_pages()
> pin_longterm_pages_fast()
> pin_longterm_pages_remote()
> 
> and obviously we have gup like:
> get_user_pages()
> get_user_pages_fast()
> get_user_pages_remote()
> ... and some other gup variants ...
> 
> I think we really should have pin_* vs get_* variants as they are very
> different in terms of guarantees and after conversion, any use of get_*
> variant in non-mm code should be closely scrutinized. OTOH pin_longterm_*
> don't look *that* useful to me and just using pin_* instead with
> FOLL_LONGTERM flag would look OK to me and somewhat reduce the number of
> functions which is already large enough? What do people think? I don't feel
> too strongly about this but wanted to bring this up.

I'm a bit concerned with the function explosion myself.  I think what you
suggest is a happy medium.  So I'd be ok with that.

Ira

