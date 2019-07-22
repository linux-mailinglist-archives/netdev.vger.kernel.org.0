Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9196FC45
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 11:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbfGVJea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 05:34:30 -0400
Received: from verein.lst.de ([213.95.11.211]:58780 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbfGVJea (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 05:34:30 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5F1B668B20; Mon, 22 Jul 2019 11:34:28 +0200 (CEST)
Date:   Mon, 22 Jul 2019 11:34:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     john.hubbard@gmail.com
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ilya Dryomov <idryomov@gmail.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ming Lei <ming.lei@redhat.com>, Sage Weil <sage@redhat.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Yan Zheng <zyan@redhat.com>, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 2/3] net/xdp: convert put_page() to put_user_page*()
Message-ID: <20190722093428.GC29538@lst.de>
References: <20190722043012.22945-1-jhubbard@nvidia.com> <20190722043012.22945-3-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722043012.22945-3-jhubbard@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 83de74ca729a..9cbbb96c2a32 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -171,8 +171,7 @@ static void xdp_umem_unpin_pages(struct xdp_umem *umem)
>  	for (i = 0; i < umem->npgs; i++) {
>  		struct page *page = umem->pgs[i];
>  
> -		set_page_dirty_lock(page);
> -		put_page(page);
> +		put_user_pages_dirty_lock(&page, 1);

Same here, we really should avoid the need for the loop here and
do the looping inside the helper.
