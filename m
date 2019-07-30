Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8934B7A5F2
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 12:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfG3K0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 06:26:08 -0400
Received: from verein.lst.de ([213.95.11.211]:49987 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbfG3K0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 06:26:03 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4C21468B02; Tue, 30 Jul 2019 12:25:57 +0200 (CEST)
Date:   Tue, 30 Jul 2019 12:25:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jerome Glisse <jglisse@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, john.hubbard@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, ceph-devel@vger.kernel.org,
        kvm@vger.kernel.org, linux-block@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, samba-technical@lists.samba.org,
        v9fs-developer@lists.sourceforge.net,
        virtualization@lists.linux-foundation.org,
        John Hubbard <jhubbard@nvidia.com>,
        Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [PATCH 03/12] block: bio_release_pages: use flags arg instead
 of bool
Message-ID: <20190730102557.GA1700@lst.de>
References: <20190724042518.14363-1-jhubbard@nvidia.com> <20190724042518.14363-4-jhubbard@nvidia.com> <20190724053053.GA18330@infradead.org> <20190729205721.GB3760@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729205721.GB3760@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 04:57:21PM -0400, Jerome Glisse wrote:
> > All pages releases by bio_release_pages should come from
> > get_get_user_pages, so I don't really see the point here.
> 
> No they do not all comes from GUP for see various callers
> of bio_check_pages_dirty() for instance iomap_dio_zero()
> 
> I have carefully tracked down all this and i did not do
> anyconvertion just for the fun of it :)

Well, the point is _should_ not necessarily do.  iomap_dio_zero adds the
ZERO_PAGE, which we by definition don't need to refcount.  So we can
mark this bio BIO_NO_PAGE_REF safely after removing the get_page there.

Note that the equivalent in the old direct I/O code, dio_refill_pages,
will be a little more complicated as it can match user pages and the
ZERO_PAGE in a single bio, so a per-bio flag won't handle it easily.
Maybe we just need to use a separate bio there as well.

In general with series like this we should not encode the status quo an
pile new hacks upon the old one, but thing where we should be and fix
up the old warts while having to wade through all that code.
