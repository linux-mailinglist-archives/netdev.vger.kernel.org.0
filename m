Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD9E672821
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 08:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfGXGR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 02:17:59 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55090 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfGXGR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 02:17:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1Xa50e3c+n/XgLreEXAZzM1/Dusmqf3jal/tdBSMEUY=; b=gGQOCJFzwPHRaT0Y5VpwBtWJoQ
        7N90/JQMzvZNdlZpfiJ/+4M5wIFkAFW6SLRu80CqjgQtsuC25Bn72Ra55U98FUrqDgFJii1g2Pk+v
        XPvWZXVP7/4TvQIWdHMJJsTBcEyaiNbtoPg+JOyeFN2/iHN+j8DiH//YTyjVYst2eZdJNW8GDmmaH
        1tpuC3lNNf/w0GceJkPRPaBB6JdiZZSZVJOlr+inma1SfS2sXWO/g3eKnofUKFN7B7pQL3769+3TW
        jCOEK61cTU+A0p4axGitNuC4cMeg/ZDpW3Ry+2Ff0HYkYs0+KxmpPcvICLo1Gula2Bgy/8Zw4ackm
        7GUAhyFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hqAb0-0007QP-TP; Wed, 24 Jul 2019 06:17:50 +0000
Date:   Tue, 23 Jul 2019 23:17:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     john.hubbard@gmail.com
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 00/12] block/bio, fs: convert put_page() to
 put_user_page*()
Message-ID: <20190724061750.GA19397@infradead.org>
References: <20190724042518.14363-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190724042518.14363-1-jhubbard@nvidia.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 09:25:06PM -0700, john.hubbard@gmail.com wrote:
> * Store, in the iov_iter, a "came from gup (get_user_pages)" parameter.
>   Then, use the new iov_iter_get_pages_use_gup() to retrieve it when
>   it is time to release the pages. That allows choosing between put_page()
>   and put_user_page*().
> 
> * Pass in one more piece of information to bio_release_pages: a "from_gup"
>   parameter. Similar use as above.
> 
> * Change the block layer, and several file systems, to use
>   put_user_page*().

I think we can do this in a simple and better way.  We have 5 ITER_*
types.  Of those ITER_DISCARD as the name suggests never uses pages, so
we can skip handling it.  ITER_PIPE is rejected іn the direct I/O path,
which leaves us with three.

Out of those ITER_BVEC needs a user page reference, so we want to call
put_user_page* on it.  ITER_BVEC always already has page reference,
which means in the block direct I/O path path we alread don't take
a page reference.  We should extent that handling to all other calls
of iov_iter_get_pages / iov_iter_get_pages_alloc.  I think we should
just reject ITER_KVEC for direct I/O as well as we have no users and
it is rather pointless.  Alternatively if we see a use for it the
callers should always have a life page reference anyway (or might
be on kmalloc memory), so we really should not take a reference either.

In other words:  the only time we should ever have to put a page in
this patch is when they are user pages.  We'll need to clean up
various bits of code for that, but that can be done gradually before
even getting to the actual put_user_pages conversion.
