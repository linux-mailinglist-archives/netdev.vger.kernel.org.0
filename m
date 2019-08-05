Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03DEA8231C
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 18:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbfHEQxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 12:53:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:43074 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbfHEQxN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 12:53:13 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 09:53:12 -0700
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="168030649"
Received: from rdvivi-losangeles.jf.intel.com (HELO intel.com) ([10.7.196.65])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 09:53:12 -0700
Date:   Mon, 5 Aug 2019 09:53:46 -0700
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     john.hubbard@gmail.com
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, Jan Kara <jack@suse.cz>,
        kvm@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dave Chinner <david@fromorbit.com>,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
        sparclinux@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org,
        rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org,
        x86@kernel.org, amd-gfx@lists.freedesktop.org,
        Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, xen-devel@lists.xenproject.org,
        devel@lists.orangefs.org, linux-media@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>,
        intel-gfx@lists.freedesktop.org, linux-block@vger.kernel.org,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        linux-rpi-kernel@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-xfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 06/34] drm/i915: convert put_page() to put_user_page*()
Message-ID: <20190805165346.GB25953@intel.com>
References: <20190804224915.28669-1-jhubbard@nvidia.com>
 <20190804224915.28669-7-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190804224915.28669-7-jhubbard@nvidia.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 04, 2019 at 03:48:47PM -0700, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> For pages that were retained via get_user_pages*(), release those pages
> via the new put_user_page*() routines, instead of via put_page() or
> release_pages().
> 
> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
> ("mm: introduce put_user_page*(), placeholder versions").
> 
> This is a merge-able version of the fix, because it restricts
> itself to put_user_page() and put_user_pages(), both of which
> have not changed their APIs. Later, i915_gem_userptr_put_pages()
> can be simplified to use put_user_pages_dirty_lock().

Thanks for that.
with this version we won't have any conflict.

Ack for going through mm tree.

> 
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  drivers/gpu/drm/i915/gem/i915_gem_userptr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> index 2caa594322bc..76dda2923cf1 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
> @@ -527,7 +527,7 @@ __i915_gem_userptr_get_pages_worker(struct work_struct *_work)
>  	}
>  	mutex_unlock(&obj->mm.lock);
>  
> -	release_pages(pvec, pinned);
> +	put_user_pages(pvec, pinned);
>  	kvfree(pvec);
>  
>  	i915_gem_object_put(obj);
> @@ -640,7 +640,7 @@ static int i915_gem_userptr_get_pages(struct drm_i915_gem_object *obj)
>  		__i915_gem_userptr_set_active(obj, true);
>  
>  	if (IS_ERR(pages))
> -		release_pages(pvec, pinned);
> +		put_user_pages(pvec, pinned);
>  	kvfree(pvec);
>  
>  	return PTR_ERR_OR_ZERO(pages);
> @@ -675,7 +675,7 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
>  			set_page_dirty_lock(page);
>  
>  		mark_page_accessed(page);
> -		put_page(page);
> +		put_user_page(page);
>  	}
>  	obj->mm.dirty = false;
>  
> -- 
> 2.22.0
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
