Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214CB84484
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 08:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfHGGfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 02:35:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36856 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbfHGGfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 02:35:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=h/YO9E7Kk2GlCfqzWsOaLMxcaYYFJaO+2uQZpeggUB0=; b=otE89qYM9WmETe4AtaYSwZhaVp
        x2hWnzTkK/+H6YrywBw2CCvGkAGS0+cMqYBTGZ1bytkCsNKOywsxuaErRoaQPCJFZ74nyD+BaWD0D
        Fqio4bMq3iSkQd4EZDyn1AS+qiOZ+zvMv6fNRqFHw53t3ciAgH4Z1x8wvN/D7EYKreU7FK2EDXOVj
        PtXuttuf2InvZsTot7swxCxX4U2Gh/2vRud2yGtuCEvw7oeWsTGK9Fxhm2aMTINFjUbhDSIHyQW9d
        1InA9ls8uWP73McSrAt6icdTTX2iY22SDv4qsGs3F3dJNdqSF3NdiMXvEekNoqV5nkE99PNfKXpGY
        TVYojzfw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hvFX6-0004to-Ui; Wed, 07 Aug 2019 06:34:48 +0000
Date:   Tue, 6 Aug 2019 23:34:48 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     John Hubbard <jhubbard@nvidia.com>
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
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 00/12] block/bio, fs: convert put_page() to
 put_user_page*()
Message-ID: <20190807063448.GA6002@infradead.org>
References: <20190724042518.14363-1-jhubbard@nvidia.com>
 <20190724061750.GA19397@infradead.org>
 <c35aa2bf-c830-9e57-78ca-9ce6fb6cb53b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c35aa2bf-c830-9e57-78ca-9ce6fb6cb53b@nvidia.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 03:54:35PM -0700, John Hubbard wrote:
> On 7/23/19 11:17 PM, Christoph Hellwig wrote:
> > On Tue, Jul 23, 2019 at 09:25:06PM -0700, john.hubbard@gmail.com wrote:
> >> * Store, in the iov_iter, a "came from gup (get_user_pages)" parameter.
> >>   Then, use the new iov_iter_get_pages_use_gup() to retrieve it when
> >>   it is time to release the pages. That allows choosing between put_page()
> >>   and put_user_page*().
> >>
> >> * Pass in one more piece of information to bio_release_pages: a "from_gup"
> >>   parameter. Similar use as above.
> >>
> >> * Change the block layer, and several file systems, to use
> >>   put_user_page*().
> > 
> > I think we can do this in a simple and better way.  We have 5 ITER_*
> > types.  Of those ITER_DISCARD as the name suggests never uses pages, so
> > we can skip handling it.  ITER_PIPE is rejected іn the direct I/O path,
> > which leaves us with three.
> > 
> 
> Hi Christoph,
> 
> Are you working on anything like this?

I was hoping I could steer you towards it.  But if you don't want to do
it yourself I'll add it to my ever growing todo list.

> Or on the put_user_bvec() idea?

I have a prototype from two month ago:

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/gup-bvec

but that only survived the most basic testing, so it'll need more work,
which I'm not sure when I'll find time for.
