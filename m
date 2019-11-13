Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A49FB850
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbfKMTEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:04:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:64338 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726978AbfKMTEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 14:04:12 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 11:04:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,301,1569308400"; 
   d="scan'208";a="207545072"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by orsmga003.jf.intel.com with ESMTP; 13 Nov 2019 11:03:59 -0800
Date:   Wed, 13 Nov 2019 11:03:59 -0800
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
Subject: Re: [PATCH v4 21/23] mm/gup_benchmark: support pin_user_pages() and
 related calls
Message-ID: <20191113190359.GB12947@iweiny-DESK2.sc.intel.com>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
 <20191113042710.3997854-22-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113042710.3997854-22-jhubbard@nvidia.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 08:27:08PM -0800, John Hubbard wrote:
> Up until now, gup_benchmark supported testing of the
> following kernel functions:
> 
> * get_user_pages(): via the '-U' command line option
> * get_user_pages_longterm(): via the '-L' command line option
> * get_user_pages_fast(): as the default (no options required)
> 
> Add test coverage for the new corresponding pin_*() functions:
> 
> * pin_user_pages(): via the '-c' command line option
> * pin_longterm_pages(): via the '-b' command line option
> * pin_user_pages_fast(): via the '-a' command line option
> 
> Also, add an option for clarity: '-u' for what is now (still) the
> default choice: get_user_pages_fast().
> 
> Also, for the three commands that set FOLL_PIN, verify that the pages
> really are dma-pinned, via the new is_dma_pinned() routine.
> Those commands are:
> 
>     PIN_FAST_BENCHMARK     : calls pin_user_pages_fast()
>     PIN_LONGTERM_BENCHMARK : calls pin_longterm_pages()
>     PIN_BENCHMARK          : calls pin_user_pages()
> 
> In between the calls to pin_*() and put_user_pages(),
> check each page: if page_dma_pinned() returns false, then
> WARN and return.
> 
> Do this outside of the benchmark timestamps, so that it doesn't
> affect reported times.
> 
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  mm/gup_benchmark.c                         | 73 ++++++++++++++++++++--
>  tools/testing/selftests/vm/gup_benchmark.c | 23 ++++++-
>  2 files changed, 90 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/gup_benchmark.c b/mm/gup_benchmark.c
> index 7fc44d25eca7..8f980d91dbf5 100644
> --- a/mm/gup_benchmark.c
> +++ b/mm/gup_benchmark.c
> @@ -8,6 +8,9 @@
>  #define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_benchmark)
>  #define GUP_LONGTERM_BENCHMARK	_IOWR('g', 2, struct gup_benchmark)
>  #define GUP_BENCHMARK		_IOWR('g', 3, struct gup_benchmark)
> +#define PIN_FAST_BENCHMARK	_IOWR('g', 4, struct gup_benchmark)
> +#define PIN_LONGTERM_BENCHMARK	_IOWR('g', 5, struct gup_benchmark)
> +#define PIN_BENCHMARK		_IOWR('g', 6, struct gup_benchmark)
>  
>  struct gup_benchmark {
>  	__u64 get_delta_usec;
> @@ -19,6 +22,44 @@ struct gup_benchmark {
>  	__u64 expansion[10];	/* For future use */
>  };
>  
> +static void put_back_pages(int cmd, struct page **pages, unsigned long nr_pages)
> +{
> +	int i;
> +
> +	switch (cmd) {
> +	case GUP_FAST_BENCHMARK:
> +	case GUP_LONGTERM_BENCHMARK:
> +	case GUP_BENCHMARK:
> +		for (i = 0; i < nr_pages; i++)
> +			put_page(pages[i]);
> +		break;
> +
> +	case PIN_FAST_BENCHMARK:
> +	case PIN_LONGTERM_BENCHMARK:
> +	case PIN_BENCHMARK:
> +		put_user_pages(pages, nr_pages);
> +		break;
> +	}
> +}
> +
> +static void verify_dma_pinned(int cmd, struct page **pages,
> +			      unsigned long nr_pages)
> +{
> +	int i;
> +
> +	switch (cmd) {
> +	case PIN_FAST_BENCHMARK:
> +	case PIN_LONGTERM_BENCHMARK:
> +	case PIN_BENCHMARK:
> +		for (i = 0; i < nr_pages; i++) {
> +			if (WARN(!page_dma_pinned(pages[i]),
> +				 "pages[%d] is NOT dma-pinned\n", i))
> +				break;
> +		}
> +		break;
> +	}
> +}
> +
>  static int __gup_benchmark_ioctl(unsigned int cmd,
>  		struct gup_benchmark *gup)
>  {
> @@ -65,6 +106,18 @@ static int __gup_benchmark_ioctl(unsigned int cmd,
>  			nr = get_user_pages(addr, nr, gup->flags, pages + i,
>  					    NULL);
>  			break;
> +		case PIN_FAST_BENCHMARK:
> +			nr = pin_user_pages_fast(addr, nr, gup->flags,
> +						 pages + i);
> +			break;
> +		case PIN_LONGTERM_BENCHMARK:
> +			nr = pin_longterm_pages(addr, nr, gup->flags, pages + i,
> +						NULL);
> +			break;
> +		case PIN_BENCHMARK:
> +			nr = pin_user_pages(addr, nr, gup->flags, pages + i,
> +					    NULL);
> +			break;
>  		default:
>  			return -1;
>  		}
> @@ -75,15 +128,22 @@ static int __gup_benchmark_ioctl(unsigned int cmd,
>  	}
>  	end_time = ktime_get();
>  
> +	/* Shifting the meaning of nr_pages: now it is actual number pinned: */
> +	nr_pages = i;
> +
>  	gup->get_delta_usec = ktime_us_delta(end_time, start_time);
>  	gup->size = addr - gup->addr;
>  
> +	/*
> +	 * Take an un-benchmark-timed moment to verify DMA pinned
> +	 * state: print a warning if any non-dma-pinned pages are found:
> +	 */
> +	verify_dma_pinned(cmd, pages, nr_pages);
> +
>  	start_time = ktime_get();
> -	for (i = 0; i < nr_pages; i++) {
> -		if (!pages[i])
> -			break;
> -		put_page(pages[i]);
> -	}
> +
> +	put_back_pages(cmd, pages, nr_pages);
> +
>  	end_time = ktime_get();
>  	gup->put_delta_usec = ktime_us_delta(end_time, start_time);
>  
> @@ -101,6 +161,9 @@ static long gup_benchmark_ioctl(struct file *filep, unsigned int cmd,
>  	case GUP_FAST_BENCHMARK:
>  	case GUP_LONGTERM_BENCHMARK:
>  	case GUP_BENCHMARK:
> +	case PIN_FAST_BENCHMARK:
> +	case PIN_LONGTERM_BENCHMARK:
> +	case PIN_BENCHMARK:
>  		break;
>  	default:
>  		return -EINVAL;
> diff --git a/tools/testing/selftests/vm/gup_benchmark.c b/tools/testing/selftests/vm/gup_benchmark.c
> index 389327e9b30a..03928e47a86f 100644
> --- a/tools/testing/selftests/vm/gup_benchmark.c
> +++ b/tools/testing/selftests/vm/gup_benchmark.c
> @@ -18,6 +18,15 @@
>  #define GUP_LONGTERM_BENCHMARK	_IOWR('g', 2, struct gup_benchmark)
>  #define GUP_BENCHMARK		_IOWR('g', 3, struct gup_benchmark)
>  
> +/*
> + * Similar to above, but use FOLL_PIN instead of FOLL_GET. This is done
> + * by calling pin_user_pages_fast(), pin_longterm_pages(), and pin_user_pages(),
> + * respectively.
> + */
> +#define PIN_FAST_BENCHMARK	_IOWR('g', 4, struct gup_benchmark)
> +#define PIN_LONGTERM_BENCHMARK	_IOWR('g', 5, struct gup_benchmark)
> +#define PIN_BENCHMARK		_IOWR('g', 6, struct gup_benchmark)
> +
>  /* Just the flags we need, copied from mm.h: */
>  #define FOLL_WRITE	0x01	/* check pte is writable */
>  
> @@ -40,8 +49,17 @@ int main(int argc, char **argv)
>  	char *file = "/dev/zero";
>  	char *p;
>  
> -	while ((opt = getopt(argc, argv, "m:r:n:f:tTLUwSH")) != -1) {
> +	while ((opt = getopt(argc, argv, "m:r:n:f:abctTLUuwSH")) != -1) {
>  		switch (opt) {
> +		case 'a':
> +			cmd = PIN_FAST_BENCHMARK;
> +			break;
> +		case 'b':
> +			cmd = PIN_LONGTERM_BENCHMARK;
> +			break;
> +		case 'c':
> +			cmd = PIN_BENCHMARK;
> +			break;
>  		case 'm':
>  			size = atoi(optarg) * MB;
>  			break;
> @@ -63,6 +81,9 @@ int main(int argc, char **argv)
>  		case 'U':
>  			cmd = GUP_BENCHMARK;
>  			break;
> +		case 'u':
> +			cmd = GUP_FAST_BENCHMARK;
> +			break;
>  		case 'w':
>  			write = 1;
>  			break;
> -- 
> 2.24.0
> 
