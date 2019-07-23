Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9CF7116C
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 07:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732972AbfGWFyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 01:54:06 -0400
Received: from verein.lst.de ([213.95.11.211]:38712 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbfGWFyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 01:54:04 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3D38F68B20; Tue, 23 Jul 2019 07:53:59 +0200 (CEST)
Date:   Tue, 23 Jul 2019 07:53:59 +0200
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
Subject: Re: [PATCH 1/3] mm/gup: introduce __put_user_pages()
Message-ID: <20190723055359.GC17148@lst.de>
References: <20190722223415.13269-1-jhubbard@nvidia.com> <20190722223415.13269-2-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722223415.13269-2-jhubbard@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 03:34:13PM -0700, john.hubbard@gmail.com wrote:
> +enum pup_flags_t {
> +	PUP_FLAGS_CLEAN		= 0,
> +	PUP_FLAGS_DIRTY		= 1,
> +	PUP_FLAGS_LOCK		= 2,
> +	PUP_FLAGS_DIRTY_LOCK	= 3,
> +};

Well, the enum defeats the ease of just being able to pass a boolean
expression to the function, which would simplify a lot of the caller,
so if we need to support the !locked version I'd rather see that as
a separate helper.

But do we actually have callers where not using the _lock version is
not a bug?  set_page_dirty makes sense in the context of a file systems
that have a reference to the inode the page hangs off, but that is
(almost?) never the case for get_user_pages.
