Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7120170949
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbfGVTHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:07:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38524 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfGVTHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:07:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IHo0jd60OP5WBABQOSv1YQjEJDC3NFfuLVsurLyCzEY=; b=TDn8HmOOJ96erQpia/yNOR+Am
        YGQqQ9dQArre0h0KZDDqf99IHdkb/l0SKklOSbgpgKBBxoLsCLryfEj6RWfmx4DzDPt+rxYgB9uoK
        HlzC/qR3epIN5Zp+2mm2Eh0h566b5uvbDMvD60Z2twrJFWDp7fp+Y0MF9aRcqi0ggM2m4pI6GTB0F
        6GBuIKdZlIWXZn2ybmmbcZjqZg/bV1BEe0awYSuqo9n0vP+IZcIp86Izotrk4G6zHjQTWmvczaFIT
        hUgoONnHg9OZ1x5tDD7cxZKUiNLBZmS2Qv10sjaF766RSkLhz9Cy0Hzyo1vHTA41Aojb86W2/vC4z
        idOs2SARg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hpdec-0003Jj-Kf; Mon, 22 Jul 2019 19:07:22 +0000
Date:   Mon, 22 Jul 2019 12:07:22 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>, john.hubbard@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>,
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
        Miklos Szeredi <miklos@szeredi.hu>,
        Ming Lei <ming.lei@redhat.com>, Sage Weil <sage@redhat.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Yan Zheng <zyan@redhat.com>, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] drivers/gpu/drm/via: convert put_page() to
 put_user_page*()
Message-ID: <20190722190722.GF363@bombadil.infradead.org>
References: <20190722043012.22945-1-jhubbard@nvidia.com>
 <20190722043012.22945-2-jhubbard@nvidia.com>
 <20190722093355.GB29538@lst.de>
 <397ff3e4-e857-037a-1aee-ff6242e024b2@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <397ff3e4-e857-037a-1aee-ff6242e024b2@nvidia.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 11:53:54AM -0700, John Hubbard wrote:
> On 7/22/19 2:33 AM, Christoph Hellwig wrote:
> > On Sun, Jul 21, 2019 at 09:30:10PM -0700, john.hubbard@gmail.com wrote:
> >>  		for (i = 0; i < vsg->num_pages; ++i) {
> >>  			if (NULL != (page = vsg->pages[i])) {
> >>  				if (!PageReserved(page) && (DMA_FROM_DEVICE == vsg->direction))
> >> -					SetPageDirty(page);
> >> -				put_page(page);
> >> +					put_user_pages_dirty(&page, 1);
> >> +				else
> >> +					put_user_page(page);
> >>  			}
> > 
> > Can't just pass a dirty argument to put_user_pages?  Also do we really
> 
> Yes, and in fact that would help a lot more than the single page case,
> which is really just cosmetic after all.
> 
> > need a separate put_user_page for the single page case?
> > put_user_pages_dirty?
> 
> Not really. I'm still zeroing in on the ideal API for all these call sites,
> and I agree that the approach below is cleaner.

so enum { CLEAN = 0, DIRTY = 1, LOCK = 2, DIRTY_LOCK = 3 };
?
