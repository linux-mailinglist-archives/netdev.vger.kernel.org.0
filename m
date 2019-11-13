Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB39FB87C
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbfKMTJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:09:40 -0500
Received: from mga05.intel.com ([192.55.52.43]:27273 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727290AbfKMTJj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 14:09:39 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 11:09:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,301,1569308400"; 
   d="scan'208";a="355565939"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by orsmga004.jf.intel.com with ESMTP; 13 Nov 2019 11:09:36 -0800
Date:   Wed, 13 Nov 2019 11:09:35 -0800
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
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 23/23] mm/gup: remove support for gup(FOLL_LONGTERM)
Message-ID: <20191113190935.GD12947@iweiny-DESK2.sc.intel.com>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
 <20191113042710.3997854-24-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113042710.3997854-24-jhubbard@nvidia.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 08:27:10PM -0800, John Hubbard wrote:
> Now that all other kernel callers of get_user_pages(FOLL_LONGTERM)
> have been converted to pin_longterm_pages(), lock it down:
> 
> 1) Add an assertion to get_user_pages(), preventing callers from
>    passing FOLL_LONGTERM (in addition to the existing assertion that
>    prevents FOLL_PIN).
> 
> 2) Remove the associated GUP_LONGTERM_BENCHMARK test.
> 
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  mm/gup.c                                   | 8 ++++----
>  mm/gup_benchmark.c                         | 9 +--------
>  tools/testing/selftests/vm/gup_benchmark.c | 7 ++-----
>  3 files changed, 7 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 82e7e4ce5027..90f5f95ee7ac 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1756,11 +1756,11 @@ long get_user_pages(unsigned long start, unsigned long nr_pages,
>  		struct vm_area_struct **vmas)
>  {
>  	/*
> -	 * FOLL_PIN must only be set internally by the pin_user_page*() and
> -	 * pin_longterm_*() APIs, never directly by the caller, so enforce that
> -	 * with an assertion:
> +	 * FOLL_PIN and FOLL_LONGTERM must only be set internally by the
> +	 * pin_user_page*() and pin_longterm_*() APIs, never directly by the
> +	 * caller, so enforce that with an assertion:
>  	 */
> -	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
> +	if (WARN_ON_ONCE(gup_flags & (FOLL_PIN | FOLL_LONGTERM)))

Don't we want to block FOLL_LONGTERM in get_user_pages_fast() as well after all
this?

Ira

>  		return -EINVAL;
>  
>  	return __gup_longterm_locked(current, current->mm, start, nr_pages,
> diff --git a/mm/gup_benchmark.c b/mm/gup_benchmark.c
> index 8f980d91dbf5..679f0e6a0adb 100644
> --- a/mm/gup_benchmark.c
> +++ b/mm/gup_benchmark.c
> @@ -6,7 +6,7 @@
>  #include <linux/debugfs.h>
>  
>  #define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_benchmark)
> -#define GUP_LONGTERM_BENCHMARK	_IOWR('g', 2, struct gup_benchmark)
> +/* Command 2 has been deleted. */
>  #define GUP_BENCHMARK		_IOWR('g', 3, struct gup_benchmark)
>  #define PIN_FAST_BENCHMARK	_IOWR('g', 4, struct gup_benchmark)
>  #define PIN_LONGTERM_BENCHMARK	_IOWR('g', 5, struct gup_benchmark)
> @@ -28,7 +28,6 @@ static void put_back_pages(int cmd, struct page **pages, unsigned long nr_pages)
>  
>  	switch (cmd) {
>  	case GUP_FAST_BENCHMARK:
> -	case GUP_LONGTERM_BENCHMARK:
>  	case GUP_BENCHMARK:
>  		for (i = 0; i < nr_pages; i++)
>  			put_page(pages[i]);
> @@ -97,11 +96,6 @@ static int __gup_benchmark_ioctl(unsigned int cmd,
>  			nr = get_user_pages_fast(addr, nr, gup->flags,
>  						 pages + i);
>  			break;
> -		case GUP_LONGTERM_BENCHMARK:
> -			nr = get_user_pages(addr, nr,
> -					    gup->flags | FOLL_LONGTERM,
> -					    pages + i, NULL);
> -			break;
>  		case GUP_BENCHMARK:
>  			nr = get_user_pages(addr, nr, gup->flags, pages + i,
>  					    NULL);
> @@ -159,7 +153,6 @@ static long gup_benchmark_ioctl(struct file *filep, unsigned int cmd,
>  
>  	switch (cmd) {
>  	case GUP_FAST_BENCHMARK:
> -	case GUP_LONGTERM_BENCHMARK:
>  	case GUP_BENCHMARK:
>  	case PIN_FAST_BENCHMARK:
>  	case PIN_LONGTERM_BENCHMARK:
> diff --git a/tools/testing/selftests/vm/gup_benchmark.c b/tools/testing/selftests/vm/gup_benchmark.c
> index 03928e47a86f..836b7082db13 100644
> --- a/tools/testing/selftests/vm/gup_benchmark.c
> +++ b/tools/testing/selftests/vm/gup_benchmark.c
> @@ -15,7 +15,7 @@
>  #define PAGE_SIZE sysconf(_SC_PAGESIZE)
>  
>  #define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_benchmark)
> -#define GUP_LONGTERM_BENCHMARK	_IOWR('g', 2, struct gup_benchmark)
> +/* Command 2 has been deleted. */
>  #define GUP_BENCHMARK		_IOWR('g', 3, struct gup_benchmark)
>  
>  /*
> @@ -49,7 +49,7 @@ int main(int argc, char **argv)
>  	char *file = "/dev/zero";
>  	char *p;
>  
> -	while ((opt = getopt(argc, argv, "m:r:n:f:abctTLUuwSH")) != -1) {
> +	while ((opt = getopt(argc, argv, "m:r:n:f:abctTUuwSH")) != -1) {
>  		switch (opt) {
>  		case 'a':
>  			cmd = PIN_FAST_BENCHMARK;
> @@ -75,9 +75,6 @@ int main(int argc, char **argv)
>  		case 'T':
>  			thp = 0;
>  			break;
> -		case 'L':
> -			cmd = GUP_LONGTERM_BENCHMARK;
> -			break;
>  		case 'U':
>  			cmd = GUP_BENCHMARK;
>  			break;
> -- 
> 2.24.0
> 
