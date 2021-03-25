Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E324C348B7F
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhCYI01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhCYI0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 04:26:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EBAC06174A;
        Thu, 25 Mar 2021 01:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IzwmhOqvIxwQPFK4E3Oa+CaBwei0j7Z1kHs2r0VicEc=; b=XChpT9BvzSkcKTC2L6pglmtqNW
        x+opZ3kV2asW/R1xhMVEPkDGdW6thedfIfn6YoDTFki6MY1t4h896/cTLH1MTjKCmfA4ngqa507b8
        WqI6IhRpwUJDgUk8bEVyxoy3yHed8K1bWqir2Hdk7kV14K5JLpiZnuxtrPTIXiTE/XZiotNkhttx5
        Bnd3Gw61TRDpDX6hpIPKwjWcrQ34+03fV66mFds8Q/u5F4dupsvAB58YKvJlNEZB6pkcFyA+UVw4X
        FwcMMISnV5Wf0bZ0+GVp79yQbVdsIdAZjC+tCJtCXnHuC6c2KiXj4Dq+Aci4HMmLSOVCwCT0r9s1S
        2y9CV1pA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lPLHU-00CXQ9-Os; Thu, 25 Mar 2021 08:24:08 +0000
Date:   Thu, 25 Mar 2021 08:23:52 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mika Penttil?? <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 01/11] file: Export __receive_fd() to modules
Message-ID: <20210325082352.GA2988009@infradead.org>
References: <20210315053721.189-1-xieyongji@bytedance.com>
 <20210315053721.189-2-xieyongji@bytedance.com>
 <20210315090822.GA4166677@infradead.org>
 <CACycT3vrHOExXj6v8ULvUzdLcRkdzS5=TNK6=g4+RWEdN-nOJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3vrHOExXj6v8ULvUzdLcRkdzS5=TNK6=g4+RWEdN-nOJw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 05:46:43PM +0800, Yongji Xie wrote:
> On Mon, Mar 15, 2021 at 5:08 PM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Mon, Mar 15, 2021 at 01:37:11PM +0800, Xie Yongji wrote:
> > > Export __receive_fd() so that some modules can use
> > > it to pass file descriptor between processes.
> >
> > I really don't think any non-core code should do that, especilly not
> > modular mere driver code.
> 
> Do you see any issue? Now I think we're able to do that with the help
> of get_unused_fd_flags() and fd_install() in modules. But we may miss
> some security stuff in this way. So I try to export __receive_fd() and
> use it instead.

The real problem is now what helper to use, but rather that random
drivers should not just mess with the FD table like that.
