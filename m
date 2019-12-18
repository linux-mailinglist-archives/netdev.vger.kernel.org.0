Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D12124D01
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfLRQTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:19:16 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34429 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbfLRQTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:19:11 -0500
Received: by mail-lj1-f196.google.com with SMTP id k1so2144819ljg.1
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 08:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1DGAjM55vpYX9DGiWQ7jC+BuPBEROaJ1QWpfbgzGOAs=;
        b=14CMCeLAINpm3ZV8MtR1RG8xV/J5WqHqe0M9oWFTC4pD19UGdVdMY13F8IIsMksm4W
         kTSNndEmcYcPmybyvjsTv6xtEW7+tkkinAcC1MDXkXKoNmZ1SK85nBC+tIiOZGHxYiSE
         ErROILC6IQXrJTMN8gfAw4y8jZgbQsFPr7JEAK4l0hFz0/VKc6BkApPPjq40gufHusUR
         6UvR7LXBYwDS6pUFn7B3nlXBgDLzdcTNFffWkV/qNFz0/kIOhSYmssrziSjQPxEtyx0c
         rJwD1MmUSyQUt9cbhZNcLHY8CW2D/VtVF58ATc7Qb2ieL8bMuLSSx8+04+/1y1quw4DP
         qbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1DGAjM55vpYX9DGiWQ7jC+BuPBEROaJ1QWpfbgzGOAs=;
        b=tSRzKK4MH3QRBWj3c5cDJTtYSv8wRxnsnIYtgqnt2krBs8z54EHilgjv2glAYAoe2g
         V18k7ghJKECCexHq4nAkxTSHea6st2Q802bhRyTzZRdevi7bloukQqwjbwvVsVJcgqrK
         5HO/sdnItuMpIS+0NOWrYRISb8oo55JoKxuHMxjCwCHxeN/egIk+pud4yhFwSMRn9qhm
         GJomZzxe8AbKUqvg9uCe/g2Lv+m8t/mgqw3Nmi09/1y8rS4G6t7jOwJRC/i26kBLvD+x
         ueDcGJ27KC8jdcjDwMzuw+WDxc5wknvSIohuOrOS9LQ+I5dpkcByM1WNBpE5WyK8MqzV
         Rx/w==
X-Gm-Message-State: APjAAAV+6PTrxUQLqrKiuQ+n9cvUzAbf4ebpi5m6iYM/rU6DH0iSVrf+
        9ir/fohNb9SfwAvTOqX/+dz5eg==
X-Google-Smtp-Source: APXvYqy8ptrsSDx1m4BazaV2cUqif19xWrwH+lZkkh3fZ2X5vIkCH+jyW+1oGFguRAmcQm5RYV3mLw==
X-Received: by 2002:a2e:b4e7:: with SMTP id s7mr2195072ljm.58.1576685948274;
        Wed, 18 Dec 2019 08:19:08 -0800 (PST)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id 2sm1412292ljq.38.2019.12.18.08.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 08:19:07 -0800 (PST)
Received: by box.localdomain (Postfix, from userid 1000)
        id E28BB1012CF; Wed, 18 Dec 2019 19:19:07 +0300 (+03)
Date:   Wed, 18 Dec 2019 19:19:07 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
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
        Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v11 06/25] mm: fix get_user_pages_remote()'s handling of
 FOLL_LONGTERM
Message-ID: <20191218161907.yczbijr3ngm7wwnj@box>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191216222537.491123-7-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216222537.491123-7-jhubbard@nvidia.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 02:25:18PM -0800, John Hubbard wrote:
> As it says in the updated comment in gup.c: current FOLL_LONGTERM
> behavior is incompatible with FAULT_FLAG_ALLOW_RETRY because of the
> FS DAX check requirement on vmas.
> 
> However, the corresponding restriction in get_user_pages_remote() was
> slightly stricter than is actually required: it forbade all
> FOLL_LONGTERM callers, but we can actually allow FOLL_LONGTERM callers
> that do not set the "locked" arg.
> 
> Update the code and comments to loosen the restriction, allowing
> FOLL_LONGTERM in some cases.
> 
> Also, copy the DAX check ("if a VMA is DAX, don't allow long term
> pinning") from the VFIO call site, all the way into the internals
> of get_user_pages_remote() and __gup_longterm_locked(). That is:
> get_user_pages_remote() calls __gup_longterm_locked(), which in turn
> calls check_dax_vmas(). This check will then be removed from the VFIO
> call site in a subsequent patch.
> 
> Thanks to Jason Gunthorpe for pointing out a clean way to fix this,
> and to Dan Williams for helping clarify the DAX refactoring.
> 
> Tested-by: Alex Williamson <alex.williamson@redhat.com>
> Acked-by: Alex Williamson <alex.williamson@redhat.com>
> Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Jerome Glisse <jglisse@redhat.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  mm/gup.c | 27 ++++++++++++++++++++++-----
>  1 file changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 3ecce297a47f..c0c56888e7cc 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -29,6 +29,13 @@ struct follow_page_context {
>  	unsigned int page_mask;
>  };
>  
> +static __always_inline long __gup_longterm_locked(struct task_struct *tsk,
> +						  struct mm_struct *mm,
> +						  unsigned long start,
> +						  unsigned long nr_pages,
> +						  struct page **pages,
> +						  struct vm_area_struct **vmas,
> +						  unsigned int flags);

Any particular reason for the forward declaration? Maybe move
get_user_pages_remote() down?

>  /*
>   * Return the compound head page with ref appropriately incremented,
>   * or NULL if that failed.
> @@ -1179,13 +1186,23 @@ long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
>  		struct vm_area_struct **vmas, int *locked)
>  {
>  	/*
> -	 * FIXME: Current FOLL_LONGTERM behavior is incompatible with
> +	 * Parts of FOLL_LONGTERM behavior are incompatible with
>  	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
> -	 * vmas.  As there are no users of this flag in this call we simply
> -	 * disallow this option for now.
> +	 * vmas. However, this only comes up if locked is set, and there are
> +	 * callers that do request FOLL_LONGTERM, but do not set locked. So,
> +	 * allow what we can.
>  	 */
> -	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
> -		return -EINVAL;
> +	if (gup_flags & FOLL_LONGTERM) {
> +		if (WARN_ON_ONCE(locked))
> +			return -EINVAL;
> +		/*
> +		 * This will check the vmas (even if our vmas arg is NULL)
> +		 * and return -ENOTSUPP if DAX isn't allowed in this case:
> +		 */
> +		return __gup_longterm_locked(tsk, mm, start, nr_pages, pages,
> +					     vmas, gup_flags | FOLL_TOUCH |
> +					     FOLL_REMOTE);
> +	}
>  
>  	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
>  				       locked,
> -- 
> 2.24.1
> 

-- 
 Kirill A. Shutemov
