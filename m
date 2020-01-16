Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1475313D706
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 10:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731519AbgAPJiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 04:38:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgAPJiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 04:38:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/fZtSw8YSFU2Bly7v5Q7x01aJLXfW/w2Sao1/9HMkcI=; b=DExRcwvRtFXUvspwe2EK1pvbk
        toOxyW/Rr7rvJL9Uo35exr8Cq2wCUokVKVlfAtn576Uwh6C0dDY+T/FqZ4x+sYv+8BDucArp3y1Zx
        NC96wmTc5QNReYms4V9DkpZ9WP5G7mGeRlC5SUBjQZBvlUl97PM9jLHyv9Mn7tevIOXaJa4Q5iXde
        bXS+39JbBJRccdS9LFTo+FwnQG+xGELB+IzFC6BcqMnYvzn4K0YbBX5iL1zc87io0r9xxv4FP2Te6
        65YEWF3mg8LdQoUzSr2qBy1recVwExQ2okF4Q/NYnSTv1qsmEBA+XVmZNwmYaFEgRtYH8E7r4VJTs
        MW9dAK1TQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is1aS-00035V-O1; Thu, 16 Jan 2020 09:37:12 +0000
Date:   Thu, 16 Jan 2020 01:37:12 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
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
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v12 04/22] mm: devmap: refactor 1-based refcounting for
 ZONE_DEVICE pages
Message-ID: <20200116093712.GA11011@infradead.org>
References: <20200107224558.2362728-1-jhubbard@nvidia.com>
 <20200107224558.2362728-5-jhubbard@nvidia.com>
 <20200115152306.GA19546@infradead.org>
 <4707f191-86f8-db4a-c3de-0a84b415b658@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4707f191-86f8-db4a-c3de-0a84b415b658@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 01:19:41PM -0800, John Hubbard wrote:
> On 1/15/20 7:23 AM, Christoph Hellwig wrote:
> ...
> > 
> > I'm really not sold on this scheme.  Note that I think it is
> > particularly bad, but it also doesn't seem any better than what
> > we had before, and it introduced quite a bit more code.
> > 
> 
> Hi Christoph,
> 
> All by itself, yes. But the very next patch (which needs a little 
> rework for other reasons, so not included here) needs to reuse some of 
> these functions within __unpin_devmap_managed_user_page():

Well, then combine it with the series that actually does the change.

Also my vaguely recollection is that we had some idea on how to get rid
of the off by one refcounting for the zone device pages, which would be
a much better outcome.
