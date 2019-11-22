Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4897B106F69
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 12:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730831AbfKVLPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 06:15:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:34110 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729023AbfKVLPI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 06:15:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 21586B2F6;
        Fri, 22 Nov 2019 11:15:04 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 4FA541E484C; Fri, 22 Nov 2019 12:15:02 +0100 (CET)
Date:   Fri, 22 Nov 2019 12:15:02 +0100
From:   Jan Kara <jack@suse.cz>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
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
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v7 02/24] mm/gup: factor out duplicate code from four
 routines
Message-ID: <20191122111502.GC26721@quack2.suse.cz>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-3-jhubbard@nvidia.com>
 <20191121080356.GA24784@lst.de>
 <852f6c27-8b65-547b-89e0-e8f32a4d17b9@nvidia.com>
 <20191121095411.GC18190@quack2.suse.cz>
 <9d0846af-2c4f-7cda-dfcb-1f642943afea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d0846af-2c4f-7cda-dfcb-1f642943afea@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 21-11-19 18:54:02, John Hubbard wrote:
> On 11/21/19 1:54 AM, Jan Kara wrote:
> > On Thu 21-11-19 00:29:59, John Hubbard wrote:
> > > > 
> > > > Otherwise this looks fine and might be a worthwhile cleanup to feed
> > > > Andrew for 5.5 independent of the gut of the changes.
> > > > 
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > 
> > > 
> > > Thanks for the reviews! Say, it sounds like your view here is that this
> > > series should be targeted at 5.6 (not 5.5), is that what you have in mind?
> > > And get the preparatory patches (1-9, and maybe even 10-16) into 5.5?
> > 
> > One more note :) If you are going to push pin_user_pages() interfaces
> > (which I'm fine with), it would probably make sense to push also the
> > put_user_pages() -> unpin_user_pages() renaming so that that inconsistency
> > in naming does not exist in the released upstream kernel.
> > 
> > 								Honza
> 
> Yes, that's what this patch series does. But I'm not sure if "push" here
> means, "push out: defer to 5.6", "push (now) into 5.5", or "advocate for"?

I meant to include the patch in the "for 5.5" batch.

> I will note that it's not going to be easy to rename in one step, now
> that this is being split up. Because various put_user_pages()-based items
> are going into 5.5 via different maintainer trees now. Probably I'd need
> to introduce unpin_user_page() alongside put_user_page()...thoughts?

Yes, I understand that moving that patch from the end of the series would
cause fair amount of conflicts. I was hoping that you could generate the
patch with sed/Coccinelle and then rebasing what remains for 5.6 on top of
that patch should not be that painful so overall it should not be that much
work. But I may be wrong so if it proves to be too tedious, let's just
postpone the renaming to 5.6. I don't find having both unpin_user_page()
and put_user_page() a better alternative to current state. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
