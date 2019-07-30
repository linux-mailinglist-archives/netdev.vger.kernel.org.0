Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60DD27AD00
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 17:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbfG3P5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 11:57:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40090 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbfG3P5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 11:57:20 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AD19A300CB0C;
        Tue, 30 Jul 2019 15:57:17 +0000 (UTC)
Received: from redhat.com (ovpn-112-36.rdu2.redhat.com [10.10.112.36])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A63655D6A7;
        Tue, 30 Jul 2019 15:57:05 +0000 (UTC)
Date:   Tue, 30 Jul 2019 11:57:02 -0400
From:   Jerome Glisse <jglisse@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
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
Subject: Re: [PATCH 03/12] block: bio_release_pages: use flags arg instead of
 bool
Message-ID: <20190730155702.GB10366@redhat.com>
References: <20190724042518.14363-1-jhubbard@nvidia.com>
 <20190724042518.14363-4-jhubbard@nvidia.com>
 <20190724053053.GA18330@infradead.org>
 <20190729205721.GB3760@redhat.com>
 <20190730102557.GA1700@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190730102557.GA1700@lst.de>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 30 Jul 2019 15:57:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 12:25:57PM +0200, Christoph Hellwig wrote:
> On Mon, Jul 29, 2019 at 04:57:21PM -0400, Jerome Glisse wrote:
> > > All pages releases by bio_release_pages should come from
> > > get_get_user_pages, so I don't really see the point here.
> > 
> > No they do not all comes from GUP for see various callers
> > of bio_check_pages_dirty() for instance iomap_dio_zero()
> > 
> > I have carefully tracked down all this and i did not do
> > anyconvertion just for the fun of it :)
> 
> Well, the point is _should_ not necessarily do.  iomap_dio_zero adds the
> ZERO_PAGE, which we by definition don't need to refcount.  So we can
> mark this bio BIO_NO_PAGE_REF safely after removing the get_page there.
> 
> Note that the equivalent in the old direct I/O code, dio_refill_pages,
> will be a little more complicated as it can match user pages and the
> ZERO_PAGE in a single bio, so a per-bio flag won't handle it easily.
> Maybe we just need to use a separate bio there as well.
> 
> In general with series like this we should not encode the status quo an
> pile new hacks upon the old one, but thing where we should be and fix
> up the old warts while having to wade through all that code.

Other user can also add page that are not coming from GUP but need to
have a reference see __blkdev_direct_IO() saddly bio get fill from many
different places and not always with GUP. So we can not say that all
pages here are coming from bio. I had a different version of the patchset
i think that was adding a new release dirty function for GUP versus non
GUP bio. I posted it a while ago, i will try to dig it up once i am
back.

Cheers,
Jérôme
