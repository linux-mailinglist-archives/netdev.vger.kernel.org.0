Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F3C7FC1D
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 16:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404005AbfHBOYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 10:24:50 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52950 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731067AbfHBOYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 10:24:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jvuzp+6FCROkRR+waxcd/xSBD2jk0LdlEwwlmE/QRVo=; b=G2sxycFAx+YSXemaZWFj5rBoO
        L5W+suRd87Fzi03i9UbUkz+K/l4OLA7u4vdCzpFKd8kbKkpNT5POJKTjl3Y9NgF+IfuEQiw+Ya9sZ
        Uz98GhfWAglGYt98RBvfBnca/15T9G/n1hhy4hthNjlrIrfsKUlfX1Lr9suoRAYQ/pICfFJo13kmR
        L+hbvfVY5BZygvFEilaamnzYAdT/2P4dTNkPPWEPWi3WZyJpk4mE3pZYxvO4hCe5QB9xougEB5c3g
        IV0U5HMFOk+fqAqk6ui4QqQV5LiDqQxBtFq8kG3bamWa6AZ5dtGBvDFf6uxZiiuQmelcNvOe6qNsg
        wQg03COuw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1htYU7-0007La-VU; Fri, 02 Aug 2019 14:24:43 +0000
Date:   Fri, 2 Aug 2019 07:24:43 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Michal Hocko <mhocko@kernel.org>, john.hubbard@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, devel@lists.orangefs.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        sparclinux@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 00/34] put_user_pages(): miscellaneous call sites
Message-ID: <20190802142443.GB5597@bombadil.infradead.org>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802091244.GD6461@dhcp22.suse.cz>
 <20190802124146.GL25064@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802124146.GL25064@quack2.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 02:41:46PM +0200, Jan Kara wrote:
> On Fri 02-08-19 11:12:44, Michal Hocko wrote:
> > On Thu 01-08-19 19:19:31, john.hubbard@gmail.com wrote:
> > [...]
> > > 2) Convert all of the call sites for get_user_pages*(), to
> > > invoke put_user_page*(), instead of put_page(). This involves dozens of
> > > call sites, and will take some time.
> > 
> > How do we make sure this is the case and it will remain the case in the
> > future? There must be some automagic to enforce/check that. It is simply
> > not manageable to do it every now and then because then 3) will simply
> > be never safe.
> > 
> > Have you considered coccinele or some other scripted way to do the
> > transition? I have no idea how to deal with future changes that would
> > break the balance though.
> 
> Yeah, that's why I've been suggesting at LSF/MM that we may need to create
> a gup wrapper - say vaddr_pin_pages() - and track which sites dropping
> references got converted by using this wrapper instead of gup. The
> counterpart would then be more logically named as unpin_page() or whatever
> instead of put_user_page().  Sure this is not completely foolproof (you can
> create new callsite using vaddr_pin_pages() and then just drop refs using
> put_page()) but I suppose it would be a high enough barrier for missed
> conversions... Thoughts?

I think the API we really need is get_user_bvec() / put_user_bvec(),
and I know Christoph has been putting some work into that.  That avoids
doing refcount operations on hundreds of pages if the page in question is
a huge page.  Once people are switched over to that, they won't be tempted
to manually call put_page() on the individual constituent pages of a bvec.
